package oepul.o6_16

import data.gwa_tables as t
import rego.v1

div_variant(code) := t.green_div[code]

# Gruppen haben unterschiedliche Rechtsfolgen, auch wenn eine Maßnahme in
# mehreren Listen erscheint.
measure_list(group) := {
	"mehrjährig": t.multiannual,
	"jährlich wechselnde Einheiten": t.annual_units,
	"einjährig": t.annual,
	"Übernahme nur im Einzelfall": t.exceptional_takeover,
	"beschränkter Zugang": t.limited_addition,
	"Gebietskörperschaften": t.public_applicants,
	"besondere Pflege": t.management_exemptions,
}[group]

contract_application(c) if {
	c.approved
	entry_timely(c.component, c.start_year, c.submitted)
}

valid_transfer(assumed_ha, additional_ha, d, y) if {
	assumed_ha > 0
	additional_ha >= 0
	additional_ha * 2 <= assumed_ha
	within_year(d, y)
	date_ns(d) <= date_ns(transfer_deadline(y))
}

repayable_loss(previous_ha, counted_loss_ha) := counted_loss_ha if {
	counted_loss_ha > loss_tolerance(previous_ha)
} else := 0 if {
	counted_loss_ha >= 0
	counted_loss_ha <= loss_tolerance(previous_ha)
}

eligible_new_area(y, base_2025, already_added, new_ha) := new_ha if {
	y in {2024, 2025}
	new_ha >= 0
} else := min([remaining, new_ha]) if {
	y in {2026, 2027, 2028}
	new_ha >= 0
	already_added >= 0
	remaining := max([0, addition_limit(base_2025) - already_added])
}

used_advance_limit(premium) := (premium * 75) / 100 if premium >= 0
lowest_sanction(y) := sanction_levels(y)[0]
exclusion_after_full_reductions(history) if {
	count([cut | some cut in history; cut == 100]) >= 2
}

allowed_annual_payment_per_ha(category, y, included, excluded) := min([included, area_cap(category, y)]) + excluded if {
	included >= 0
	excluded >= 0
}

vienna_project_met if {
	measure_farm.project.recognised
	measure_farm.project.scientific_supervision
	measure_farm.project.confirmation
}

schlag[id].Cultan_Ausbringung_belegt if {
	some id, p in parcels_by_id
	cultan_application(p)
}

schlag[id].AG_DIV_Nutzung_und_Codes if {
	some id, p in parcels_by_id
	ag_div_use(p)
}

schlag[id]["AG_Anlage_erfüllt"] if {
	some id, p in parcels_by_id
	ag_use(p)
	ag_establishment(p)
}

betrieb["Gewässerschutzkonzept_fristgerecht"] := date_ns(measure_farm.water_plan_date) <= date_ns("2026-12-31")
betrieb["Düngeplanung_fristgerecht"] := date_ns(measure_farm.plan_date) <= date_ns(planning_dates(year).plan_due)
betrieb["Düngebilanz_fristgerecht"] := date_ns(measure_farm.balance_date) <= date_ns(planning_dates(year).balance_due)
betrieb.Bodenproben_Anzahlsoll_erreicht := betrieb.Bodenproben_anrechenbar >= samples_required(measure_farm.zone_ha_mfa_2026)
betrieb.Schulung_Basis_Stundensoll_erreicht := training_hours("Basis", measure_farm.trained_person_id) >= 10
betrieb.Schulung_Wien_Stundensoll_erreicht := training_hours("Wien", measure_farm.trained_person_id) >= 3 if measure_farm.vienna_option
betrieb["Anträge_form_und_fristgerecht"] := {c.component | some c in measure_farm.measure_applications; contract_application(c)} if is_array(measure_farm.measure_applications)
betrieb["Prämienobergrenze_für_allgemeine_Flächen_EUR_ha"] := area_cap("allgemein", year)
betrieb.Niedrigste_Sanktionsstufe := lowest_sanction(year)
betrieb.Teilzahlung_max_EUR := used_advance_limit(measure_farm.payment_control.annual_premium_eur) if measure_farm.payment_control.checks_completed
betrieb["Ausschluss_nach_zwei_Vollkürzungen"] if exclusion_after_full_reductions(measure_farm.payment_control.sanction_percentages)

betrieb["Wien_Projektbestätigung_belegt"] if {
	measure_farm.vienna_option
	vienna_project_met
}

hinweise contains finding("ag_pflege", p.parcel_id) if {
	some p in input.land.parcels
	ag_use(p)
	two_year_care_overdue(p)
}

two_year_care_overdue(p) if {
	year > p.gwa.ag_established_year
	is_array(p.gwa.ag_management.cuts_or_mulching)
	dates := [d | some d in p.gwa.ag_management.cuts_or_mulching; date_ns(d) >= date_ns(iso(year - 1, "01-01")); date_ns(d) <= date_ns(iso(year, "12-31"))]
	count(dates) == 0
	measure_farm.as_of >= iso(year, "12-31")
}

hinweise contains finding("buchfrist", p.parcel_id) if {
	some p in input.land.parcels
	records_required(p)
	some e in p.gwa.field_events
	e.electronic == false
}

hinweise contains finding("psm_code", p.parcel_id) if {
	some p in input.land.parcels
	zone(p, year)
	year <= 2025
	code := psm_code(year, p.gwa.area_application_bio, p.gwa.area_application_chemical)
	is_string(code)
	is_array(p.gwa.codes)
	not code in p.gwa.codes
}

hinweise contains finding("ag_gruenland", p.parcel_id) if {
	some p in input.land.parcels
	"AG" in p.gwa.codes
	p.gwa.grassland_2020
}

hinweise contains finding("ag_gloez", p.parcel_id) if {
	some p in input.land.parcels
	"AG" in p.gwa.codes
	p.gwa.gloez4
}

hinweise contains finding("ag_gloez", p.parcel_id) if {
	some p in input.land.parcels
	"AG" in p.gwa.codes
	historical_setaside(p)
}

hinweise contains finding("ackerzahl", p.parcel_id) if {
	some p in input.land.parcels
	"AG" in p.gwa.codes
	is_number(p.gwa.soil_score)
	p.gwa.soil_score > 40
}

hinweise contains finding("rezeptur", null) if {
	measure_farm.pig_option
	some ration in measure_farm.pig_rations
	ration.recipe_documented == false
}

hinweise contains finding("wien_kombination", p.parcel_id) if {
	some p in input.land.parcels
	state(p, year) == "Wien"
	measure_farm.vienna_option
	p.gwa.erosion_payment_method in {"Mulchsaat", "Direktsaat", "Strip-Till"}
}

# Nachgewiesener Übertrag über eine ungenutzte Zwischenfrucht. Bereits
# reduzierte Altbeträge werden beim Erneuern der Begrünung unverändert übernommen.
unused_cover_credit(prior, region, n_applied, compliant, factor_taken) := ((prior * regional_percent(region)) / 100) + n_applied if {
	compliant == true
	factor_taken == false
	prior >= 0
	n_applied >= 0
} else := prior + n_applied if {
	prior >= 0
	n_applied >= 0
	keep_credit(compliant, factor_taken)
}

keep_credit(_, already) if already == true
keep_credit(compliant, _) if compliant == false

# 2026 ersetzen die Ausnahmen nur bestimmte Bedingungen der Partnermaßnahme.
cover_emergence_excused(y, method, proper_sowing, dry_failure) if {
	y == 2026
	method in {"6", "7", "10", "8-US"}
	proper_sowing
	dry_failure
}

evergreen_2026_dates_met(sown, winterhard, days, earliest_feasible, planned_ahead, conditions_missing) if {
	within_year(sown, 2026)
	sown == earliest_feasible
	planned_ahead
	conditions_missing
	days >= 42
	deadline := {"abfrostend": "09-20", "überwiegend winterhart": "10-15"}[winterhard]
	sown <= iso(2026, deadline)
}

deduction_order := t.deductions

access_consequence(component, first_year, met) := "kein gültiger Vertrag" if {
	met == false
	component in {"einjährige Maßnahme", "vorab zu beantragende Option"}
} else := "kein gültiger Vertrag" if {
	met == false
	component == "mehrjährige Maßnahme"
	first_year == true
} else := "keine Maßnahmenprämie im betroffenen Jahr" if {
	met == false
	component == "mehrjährige Maßnahme"
	first_year == false
}

ag_payment_basis(p) if {
	ag_site(p)
	ag_use(p)
	every code in {"OP", "OPGWA", "VF"} { not code in p.gwa.codes }
}

betrieb["AG_Standort_und_Code_berechnete_Fläche_ha"] := sum([p.area_ha |
	some p in input.land.parcels
	ag_payment_basis(p)
]) if {
	complete_locations
	every p in input.land.parcels { ag_facts_known(p) }
}

ag_facts_known(p) if p.land_use != "arable"

ag_facts_known(p) if {
	is_array(p.gwa.codes)
	not "AG" in p.gwa.codes
}

ag_facts_known(p) if {
	"AG" in p.gwa.codes
	is_string(p.crop.crop_name)
	is_number(p.gwa.soil_score)
	is_boolean(p.gwa.grassland_2020)
	is_boolean(p.gwa.gloez4)
	gloez8_known(p)
}

betrieb["AG_Tabellenbetrag_vor_weiteren_Kürzungen_EUR"] := ag_amount(betrieb["AG_Standort_und_Code_berechnete_Fläche_ha"], input.land.arable_area_ha, year)

partner_rate_range(key) := t.partner_rates[key]

ag_other_payment_permitted(measure, kind) if {
	measure in {"1A", "1B"}
	kind == "Landschaftselement"
}

# Einzelflächenregel für Acker-DIV. Die 25-%-Quote wird für den Betrieb
# ermittelt, der zusätzliche AG-Weideausschluss gilt auf dem Schlag.
div_early_code_required(y, operation, when, exceeds_free_quota) if {
	y == 2026
	within_year(when, y)
	when < iso(y, "08-01")
	operation in {"Mahd", "Häckseln"}
	exceeds_free_quota
}

div_early_code_required(y, operation, when, _) if {
	y == 2026
	within_year(when, y)
	when < iso(y, "08-01")
	operation == "Beweidung"
}

div_third_use_code(y, n) if {
	y == 2026
	n == 3
}
