package oepul.o6_1b

import rego.v1

# Die KG-Prüfung ist der räumlichen Prüfung der einzelnen Parzelle vorgelagert.
listed_kg("BAW", kg) if {
	some r in tab.baw_katastralgemeinden
	r.kg_nummer == kg
}

listed_kg("AG", kg) if {
	some r in tab.gwa_katastralgemeinden
	r.kg_nummer == kg
}

listed_baw_site(p) if {
	listed_kg("BAW", p.oepul.kg_nummer)
	p.oepul.baw_gis_confirmed
}

listed_ag_site(p) if {
	listed_kg("AG", p.oepul.kg_nummer)
	p.oepul.annual_groundwater_zone_confirmed
	p.oepul.soil_rating <= 40
}

nat_phenology(code) := r if {
	some r in tab.nat_phaenologie
	r.code == code
}

nat_fallow_care(code) := r if {
	some r in tab.nat_stilllegung_pflege
	r.code == code
}

n2_project_rate(code, y) := r.eur_ha if {
	some r in tab.natura_teilpraemien
	r.code == code
	y >= r.ab
}

slk_all_origins(group, y) := r.stufe if {
	some r in tab.seltene_sorten
	group in r.alle_herkuenfte_von
	y >= r.ab
}

undersowing_timing_met(p) if {
	undersowing_crop(p.crop.crop_name, year)
	p.oepul.undersowing_species_count >= 3
	elapsed := day(p.oepul.undersowing_date) - day(p.oepul.crop_sowing_date)
	elapsed >= 0
	elapsed <= 56
	p.oepul.undersowing_date <= key_date(year, "06-30")
}

# Nur der Teilanspruch auf die beschäftigungs- und größenunabhängige Pauschale.
transaction_cost_eur := rate("transaktion", year) if {
	contract.approved_bio_participation
}

arable_harvest_standard_met(p) if {
	p.land_use == "arable"
	is_string(p.oepul.use)
	not forage_crop(p.oepul.use)
	p.oepul.specific_minimum_management_exemption == false
	p.oepul.crop_properly_established
	p.oepul.annual_care_complete
	p.area_ha > 0
	p.oepul.harvested_and_removed_ha * 100 >= 85 * p.area_ha
}

arable_harvest_standard_met(p) if {
	harvest_waiver(p)
	p.oepul.crop_properly_established
	p.oepul.annual_care_complete
}

credit_special_arable_div(p) if {
	p.land_use == "arable"
	"DIV" in p.oepul.codes
	some c in p.oepul.codes
	c in {"BAW", "AG"}
	p.oepul.use in {"Grünbrache", "Sonstiges Feldfutter"}
	p.oepul.arable_div_care_met
}

credit_special_arable_div(p) if {
	"DIV" in p.oepul.codes
	p.oepul.use == "LSE Mehrnutzenhecke"
	p.oepul.herb_strip_care_met
}

credit_special_arable_div(p) if {
	p.land_use == "arable"
	"DIV" in p.oepul.codes
	some c in p.oepul.codes
	eligible_gloez(c, year)
	p.oepul.all_arable_div_management_met
}

eligible_gloez("GLÖZ 4", _) := true

eligible_gloez("GLÖZ 8", y) if y <= 2024

parcel_findings contains {"parcel_id": p.parcel_id, "result": "Erntekriterium Acker erfüllt"} if {
	some p in input.land.parcels
	arable_harvest_standard_met(p)
}

parcel_findings contains {"parcel_id": p.parcel_id, "result": "Zusätzliche Ackerfläche mit DIV anrechenbar"} if {
	some p in input.land.parcels
	credit_special_arable_div(p)
}

# Jeder begünstigte Schlag zählt einmal. Der Deckel bezieht sich auf die Kulturfläche.
soil_bonus_area(use, basis_ha) := min([basis_ha * 0.20, sum(eligible)]) if {
	basis_ha >= 0
	is_array(input.land.parcels)
	every p in input.land.parcels {
		soil_record_complete(p, use)
	}
	eligible := [p.area_ha | some p in input.land.parcels; p.land_use == use; soil_bonus_rate(p) > 0]
}

soil_record_complete(p, use) if p.land_use != use

soil_record_complete(p, _) if p.oepul.qualifies_for_bio_div_premium == false

soil_record_complete(p, _) if {
	p.oepul.qualifies_for_bio_div_premium
	is_number(p.oepul.soil_rating)
	is_number(p.area_ha)
}

lse_field_maximum(field_area_ha) := floor(field_area_ha * 80) if field_area_ha >= 0

monitoring_entry_timely(application, first_year) if {
	first_year >= 2023
	first_year <= 2028
	day(application) <= day(key_date(first_year - 1, "12-31"))
}

two_year_site_binding_met(p) if {
	p.oepul.control_lost
}

two_year_site_binding_met(p) if {
	p.oepul.converted_to_grassland
}

two_year_site_binding_met(p) if {
	p.oepul.same_location
	p.oepul.successive_div_claim_years >= 2
}
