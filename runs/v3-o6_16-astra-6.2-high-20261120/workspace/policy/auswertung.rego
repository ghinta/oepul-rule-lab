package oepul.o6_16

import rego.v1

# Teilentscheidungen setzen einen bestehenden Vertrag voraus. Fehlende Eingaben
# erzeugen keine positive Konformitätsfeststellung.
betrieb.Gebietsacker_ha := zone_area
betrieb["Mindestfläche_Maßnahme"] := area_requirement
betrieb["Begrünungskombination"] := combination_met
betrieb.Vertragsjahre := contract_years(measure_farm.start_year)
betrieb["Fristen_Düngeaufzeichnung"] := planning_dates(year)
betrieb.Schweinebesatz_erreicht := pig_density_met if measure_farm.pig_option
betrieb.Schweineoption_kombinierbar := pig_combination_met if measure_farm.pig_option
betrieb.Bodenproben_Mindestzahl_Basis := samples_required(measure_farm.zone_ha_mfa_2026)
betrieb.Bodenproben_Mindestzahl_Wien := vienna_samples_required(measure_farm.vienna_ha_mfa_2026) if measure_farm.vienna_option
betrieb.Bodenproben_anrechenbar := count({s.id | some s in measure_farm.samples; sample_valid(s)}) if is_array(measure_farm.samples)
betrieb["Modulationsfaktor_Heimfläche"] := modulation_factor(measure_farm.home_area_ha)
betrieb["AG_prämienfähige_Hektar_maximal"] := input.land.arable_area_ha / 5
betrieb["Flächenabgang_Toleranz_ha"] := loss_tolerance(measure_farm.previous_commitment_ha)
betrieb["Flächenzugang_seit_2025_max_ha"] := addition_limit(measure_farm.commitment_2025_ha) if year >= 2026
betrieb.Schulung_Basis_Stunden := training_hours("Basis", measure_farm.trained_person_id)
betrieb.Schulung_Wien_Stunden := training_hours("Wien", measure_farm.trained_person_id) if measure_farm.vienna_option

parcels_by_id := {p.parcel_id: p | some p in input.land.parcels}
schlag[id].Gebiet := state(p, year) if some id, p in parcels_by_id

schlag[id]["N_Übertrag_mindestens_kg_ha"] := carryover(year, p.gwa.previous_balance, balance_region(p)) if {
	some id, p in parcels_by_id
	zone(p, year)
}

schlag[id].Herbstanlage_erforderlich if {
	some id, p in parcels_by_id
	autumn_required(p)
}

schlag[id].Aufzeichnungen_erforderlich := p.gwa.crop_total_ha > 0.30 if {
	some id, p in parcels_by_id
	zone(p, year)
	is_number(p.gwa.crop_total_ha)
}

schlag[id].Verbotene_Wirkstoffe := banned_substances(p) if some id, p in parcels_by_id

schlag[id].PSM_Code := psm_code(year, p.gwa.area_application_bio, p.gwa.area_application_chemical) if {
	some id, p in parcels_by_id
	zone(p, year)
}

schlag[id].PSM_Code := null if {
	some id, p in parcels_by_id
	zone(p, year)
	year >= 2026
}

schlag[id]["Grundprämiensatz_EUR_ha"] := base_rate(p) if some id, p in parcels_by_id
schlag[id].PSM_Zuschlagssatz_EUR_ha := psm_rate(p) if some id, p in parcels_by_id
schlag[id]["OÖ_Zuschlagssatz_EUR_ha"] := ooe_rate(p) if some id, p in parcels_by_id
schlag[id].Schweine_Zuschlagssatz_EUR_ha := pig_rate(p) if some id, p in parcels_by_id

schlag[id].Wien_Zuschlagssatz_EUR_ha := rate("wien", year) if {
	some id, p in parcels_by_id
	state(p, year) == "Wien"
	plain_parcel(p)
	measure_farm.vienna_option
	p.gwa.erosion_payment_method == "keine"
}

schlag[id].Cultan_Zuschlagssatz_EUR_ha := rate("cultan_satz", year) if {
	some id, p in parcels_by_id
	plain_parcel(p)
	cultan_application(p)
}

schlag[id]["AG_Standortvoraussetzungen_erfüllt"] if {
	some id, p in parcels_by_id
	ag_use(p)
	ag_site(p)
}

schlag[id]["AG_frühester_Umbruch"] := ag_earliest_plough(p.gwa.ag_established_year) if {
	some id, p in parcels_by_id
	"AG" in p.gwa.codes
}

schlag[id]["Dürre_Ernteausnahme"] if {
	some id, p in parcels_by_id
	drought_exemption(p)
}

# Belegte Einzelverstöße, ohne Sanktionshöhe vorwegzunehmen.
finding(id, parcel) := {"regel": sprintf("o6_16.%s", [id]), "schlag": parcel}
hinweise contains finding("einstieg", null) if area_requirement == false
hinweise contains finding("begruenung", null) if combination_met == false

hinweise contains finding("viehbesatz", null) if {
	measure_farm.pig_option
	pig_density_met == false
}

hinweise contains finding("schweine_kombination", null) if {
	measure_farm.pig_option
	pig_combination_met == false
}

hinweise contains finding("planung", null) if date_ns(measure_farm.plan_date) > date_ns(planning_dates(year).plan_due)
hinweise contains finding("planung", null) if date_ns(measure_farm.balance_date) > date_ns(planning_dates(year).balance_due)
hinweise contains finding("konzept", null) if date_ns(measure_farm.water_plan_date) > date_ns("2026-12-31")

hinweise contains finding("wirkstoffe", p.parcel_id) if {
	some p in input.land.parcels
	count(banned_substances(p)) > 0
}

hinweise contains finding("herbst", p.parcel_id) if {
	some p in input.land.parcels
	autumn_required(p)
	p.gwa.compliant_intercrop == false
	missed_autumn(p.gwa.autumn_sowing)
}

missed_autumn(d) if d == null
missed_autumn(d) if date_ns(d) > date_ns(iso(year, "11-15"))

hinweise contains finding("ooe_sperre", p.parcel_id) if {
	some p in input.land.parcels
	some e in p.gwa.n_applications
	e.readily_soluble
	closed_period(p, e.date)
}

hinweise contains finding("gabenteilung", p.parcel_id) if {
	some p in input.land.parcels
	some e in p.gwa.n_applications
	split_required(p, e.soluble_n_after_losses, e.delayed_release)
	e.split == false
}

hinweise contains finding("variante3", p.parcel_id) if {
	some p in input.land.parcels
	variant3_prohibited(p)
}

hinweise contains finding("kontrollgang", p.parcel_id) if {
	some p in input.land.parcels
	state(p, year) == "Oö"
	some e in p.gwa.psm_events
	e.chemical_synthetic
	e.prior_inspection_documented == false
	e.warning_documented_and_observed == false
}

hinweise contains finding("buchfrist", p.parcel_id) if {
	some p in input.land.parcels
	records_required(p)
	some e in p.gwa.field_events
	date_ns(e.recorded_date) - date_ns(e.event_date) > 14 * 86400000000000
}

hinweise contains finding("ag_umbruch", p.parcel_id) if {
	some p in input.land.parcels
	"AG" in p.gwa.codes
	date_ns(p.gwa.break_date) < date_ns(ag_earliest_plough(p.gwa.ag_established_year))
}

hinweise contains finding("ag_pflege", p.parcel_id) if {
	some p in input.land.parcels
	"AG" in p.gwa.codes
	some operation in p.gwa.ag_operations
	operation in {"Beweidung", "Drusch", "Begrünung zerstört"}
}

hinweise contains finding("ag_betriebsmittel", p.parcel_id) if {
	some p in input.land.parcels
	"AG" in p.gwa.codes
	some operation in p.gwa.ag_operations
	operation in {"PSM", "Düngung"}
}

hinweise contains finding("wien_wenden", p.parcel_id) if {
	some p in input.land.parcels
	vienna_tillage_prohibited(p)
}

auswertung := {"betrieb": betrieb, "schlaege": schlag, "festgestellte_abweichungen": hinweise}

schlag[id].Bentazon_Wiederzulassung_offen if {
	some id, p in parcels_by_id
	zone(p, year)
	crop_key(p.crop.crop_name) in object.keys(data.gwa_tables.psm_crops)
	"Bentazon" in p.gwa.applied_substances
	not bentazon_status_known(p)
}
