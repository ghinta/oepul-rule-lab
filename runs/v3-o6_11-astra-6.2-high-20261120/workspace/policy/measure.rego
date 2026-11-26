package oepul.o6_11

import data.o6_11_tables as t
import rego.v1

contract_years(start) := row.years if {
	some row in t.contracts
	row.start_year == start
}

# Dates are civil dates in the MFA, without a time or timezone.
valid_date(d) if {
	regex.match(`^\d{4}-\d{2}-\d{2}$`, d)
	time.parse_rfc3339_ns(concat("", [d, "T00:00:00Z"]))
}

entry_timely(start, filed) := ok if {
	contract_years(start)
	valid_date(filed)
	ok := substring(filed, 0, 4) == format_int(start - 1, 10)
}

switch_timely(target, filed) := ok if {
	valid_date(filed)
	some row in t.switches
	row.source == "11"
	row.target == target
	ok := filed <= "2025-12-31"
}

active if {
	input.farm.o6_11.active == true
	input.farm.year >= input.farm.o6_11.first_year
	input.farm.year >= 2023
	input.farm.year <= 2028
}

# MFA names qualify broad crop categories. A known marginal crop has its own
# effective year. Unclassified fruit needs identification before a decision.
fruit_name(p) := name if {
	name := lower(p.crop.crop_name)
	some row in t.fruit
	lower(row.name) == name
} else := "walnuss" if {
	some label in [object.get(p.crop, "crop_name", ""), object.get(p, ["mfa", "use"], "")]
	lower(label) in {"walnüsse", "walnuss"}
}

else := "edelkastanie" if {
	some label in [object.get(p.crop, "crop_name", ""), object.get(p, ["mfa", "use"], "")]
	lower(label) in {"edelkastanie", "edelkastanien"}
}

else := lower(p.crop.fruit_group)

nursery(p) if lower(p.crop.crop_name) in {"rebschule", "rebschulen"}
nursery(p) if lower(p.mfa.use) in {"rebschule", "rebschulen"}

crop_group(p, y) := "outside" if nursery(p)

else := "vineyard" if {
	lower(p.crop.crop_name) in {"schnittweingarten", "schnittweingärten"}
} else := "vineyard" if {
	lower(p.mfa.use) in {"schnittweingärten", "schnittweingarten"}
} else := "vineyard" if p.crop.crop_category == "vineyard"

else := "hop" if {
	p.crop.crop_category == "hop"
} else := group if {
	name := fruit_name(p)
	some row in t.fruit
	lower(row.name) == name
	group := fruit_in_year(row, y)
} else := "outside" if {
	p.crop.crop_category in {"cereal", "maize", "oilseed", "legume", "root", "vegetable", "fallow", "other"}
}

fruit_in_year(row, y) := "orchard" if y >= row.from_year

else := "outside" if y < row.from_year

scope(p, y) if {
	crop_group(p, y) in {"orchard", "hop", "vineyard"}
	p.mfa.country == "AT"
}

known_area(p, _) if {
	is_string(p.mfa.country)
	p.mfa.country != "AT"
}

known_area(p, y) if {
	p.mfa.country == "AT"
	crop_group(p, y) == "outside"
}

known_area(p, y) if {
	scope(p, y)
	is_number(p.area_ha)
	p.area_ha >= 0
}

first_year_area_ok := ok if {
	y := input.farm.year
	y == input.farm.o6_11.first_year
	is_array(input.land.parcels)
	every p in input.land.parcels { known_area(p, y) }
	hectares := sum([p.area_ha | some p in input.land.parcels; scope(p, y)])
	ok := hectares >= 0.5
}

bio_compatible := ok if {
	mode := input.farm.o6_11.bio_participation
	mode in {"none", "whole_farm", "partial_arable_grassland", "partial_wine_fruit_hop"}
	ok := mode in {"none", "partial_arable_grassland"}
}

herbicide_findings contains {"parcel_id": p.parcel_id, "event": e, "rule_id": "o6_11.verzicht"} if {
	active
	some p in input.land.parcels
	scope(p, input.farm.year)
	some e in p.operations.psm_events
	e.status == "applied"
	"Herbizid" in e.register_types
}

formic_findings contains {"parcel_id": p.parcel_id, "event": e, "rule_id": "o6_11.ameisensaeure"} if {
	some p in input.land.parcels
	p.mfa.country == "AT"
	p.operations.field_production == true
	some e in p.operations.psm_events
	e.status == "applied"
	some ingredient in e.ingredients
	some label in t.formic_names
	lower(ingredient) == lower(label)
}

# Results are violations and missing justifications, never a blanket clearance.
stock_findings contains {"id": s.id, "action": s.action, "result": "verboten"} if {
	active
	some s in input.farm.o6_11.herbicide_transactions
	s.action in {"purchase", "storage"}
	s.lawful_other_crop == false
}

stock_findings contains {"id": s.id, "action": s.action, "result": "Menge nicht plausibel oder nicht belegt"} if {
	active
	some s in input.farm.o6_11.herbicide_transactions
	s.action in {"purchase", "storage"}
	s.lawful_other_crop == true
	false in [object.get(s, "plausible", null), object.get(s, "documented", null)]
}

psm_class(e) := "synthetic_herbicide" if "Herbizid" in e.register_types

else := e.code_class

class_set(p) := {c | some e in p.operations.psm_events; e.status == "applied"; e.broadcast == true; c := psm_class(e)}

necessary(classes, c) if {
	c in classes
	c != "bio"
}

necessary(classes, "bio") if {
	"bio" in classes
	not "synthetic_other" in classes
}

required_codes(p, y) := set() if y >= 2026

else := codes if {
	y >= 2023
	y <= 2025
	is_array(p.operations.psm_events)
	every e in p.operations.psm_events { classifiable_event(e) }
	classes := class_set(p)
	codes := {t.psm_codes[c] | some c in classes; necessary(classes, c)}
}

classifiable_event(e) if e.status in {"planned", "cancelled"}

classifiable_event(e) if {
	e.status == "applied"
	e.broadcast == false
}

classifiable_event(e) if {
	e.status == "applied"
	e.broadcast == true
	psm_class(e) in object.keys(t.psm_codes)
}

excluded_use(p) if {
	some name in t.excluded_uses
	lower(p.mfa.use) == lower(name)
}

excluded_use(p) if lower(p.crop.crop_name) in {"walnuss", "walnüsse", "edelkastanie", "edelkastanien"}

# A tariff, before general eligibility, sanctions, modulation and the parcel cap.
tariff(p, y) := 0 if excluded_use(p)

else := 0 if crop_group(p, y) == "outside"

else := 0 if {
	crop_group(p, y) == "orchard"
	p.crop.quality_stock == false
} else := 0 if {
	crop_group(p, y) == "orchard"
	p.crop.ungrafted_tree == true
}

else := rate.eur_per_ha if {
	is_string(p.mfa.use)
	group := crop_group(p, y)
	quality_known(p, group)
	some rate in t.rates
	rate.group == group
	y >= rate.from_year
	y <= rate.through_year
}

quality_known(_, group) if group in {"vineyard", "hop"}
quality_known(p, "orchard") if p.crop.quality_stock == true

parcel_tariffs := {p.parcel_id: tariff(p, input.farm.year) | some p in input.land.parcels}
coding_by_parcel := {p.parcel_id: required_codes(p, input.farm.year) | active; some p in input.land.parcels; scope(p, input.farm.year)}

missing_codes contains {"parcel_id": p.parcel_id, "code": c} if {
	active
	some p in input.land.parcels
	scope(p, input.farm.year)
	is_array(p.mfa.codes)
	some c in required_codes(p, input.farm.year)
	not c in p.mfa.codes
}

# All parcel-level amounts here are tariff calculations, before shared caps,
# modulation or AMA assessment of infringements.
parcel_base_amounts := {p.parcel_id: amount |
	some p in input.land.parcels
	p.mfa.country == "AT"
	is_number(p.area_ha)
	p.area_ha >= 0
	amount := p.area_ha * tariff(p, input.farm.year)
}

coding_actions contains {"parcel_id": p.parcel_id, "action": "Code streichen", "code": c} if {
	active
	input.farm.year <= 2025
	some p in input.land.parcels
	scope(p, input.farm.year)
	some e in p.operations.psm_events
	e.status == "cancelled"
	e.broadcast == true
	c := t.psm_codes[psm_class(e)]
	c in p.mfa.codes
	every event in p.operations.psm_events { classifiable_event(event) }
	not retained_code(p, c)
}

retained_code(p, c) if {
	some e in p.operations.psm_events
	e.status in {"planned", "applied"}
	e.broadcast == true
	c == t.psm_codes[psm_class(e)]
}

needs_evidence contains {"parcel_id": p.parcel_id, "field": "crop / fruit_group"} if {
	some p in input.land.parcels
	p.mfa.country == "AT"
	not classified(p, input.farm.year)
}

classified(p, y) if is_string(crop_group(p, y))

needs_evidence contains {"parcel_id": p.parcel_id, "field": "mfa.country"} if {
	some p in input.land.parcels
	not is_string(object.get(p, ["mfa", "country"], null))
}

needs_evidence contains {"parcel_id": p.parcel_id, "field": "operations.psm_events"} if {
	active
	some p in input.land.parcels
	scope(p, input.farm.year)
	not is_array(object.get(p, ["operations", "psm_events"], null))
}

needs_evidence contains {"parcel_id": p.parcel_id, "field": "register_types"} if {
	active
	some p in input.land.parcels
	scope(p, input.farm.year)
	some e in p.operations.psm_events
	e.status == "applied"
	not is_array(object.get(e, "register_types", null))
}

stock_evidence_needed contains s.id if {
	active
	some s in input.farm.o6_11.herbicide_transactions
	not is_boolean(object.get(s, "lawful_other_crop", null))
}

stock_evidence_needed contains s.id if {
	active
	some s in input.farm.o6_11.herbicide_transactions
	s.lawful_other_crop == true
	some key in {"plausible", "documented"}
	not is_boolean(object.get(s, key, null))
}

entry_application_timely := entry_timely(input.farm.o6_11.original_start_year, input.farm.o6_11.entry_filed)

switch_application_timely := ok if {
	contract := input.farm.o6_11
	valid_date(contract.switch_filed)
	contract.active == true
	contract.switch_filed >= sprintf("%d-01-01", [contract.first_year])
	ok := switch_timely(contract.switch_target, contract.switch_filed)
}

# Finding lists report observed facts. Individual positive decisions require
# the applicable information; a missing key does not establish compliance.
reported_modulation_factor := modulation_factor(input.farm.opul.home_modulation_area_ha)
reported_sanction := sanction(input.farm.opul.sanction_stage, input.farm.year, input.farm.opul.prior_full_cuts_in_contract)
reported_loss_review := annual_loss_review(input.farm.opul.previous_committed_area_ha, input.farm.opul.relevant_loss_ha)

observed_combinations contains {"parcel_id": claim.parcel_id, "other_measure": claim.measure, "matrix": cell} if {
	active
	some claim in input.farm.opul_combinations
	claim.measure != "11"
	some p in input.land.parcels
	p.parcel_id == claim.parcel_id
	p.mfa.claimed_11 == true
	cell := combination("11", claim.measure)
}

# The parcel component after known area exclusions, before farm-level access
# conditions, modulation, aggregate caps and any sanction assessment.
parcel_amount_before_farm_checks(p) := 0 if {
	count(parcel_exclusions[p.parcel_id]) > 0
} else := 0 if {
	tariff(p, input.farm.year) == 0
} else := amount if {
	active
	scope(p, input.farm.year)
	p.mfa.claimed_11 == true
	p.mfa.correctly_identified == true
	p.mfa.active_production == true
	p.mfa.mainly_agricultural == true
	p.mfa.gaec_feature == false
	p.mfa.approved_trial_prevents_compliance == false
	p.mfa.op_for_11 == false
	is_array(p.mfa.codes)
	park_checks_complete(p)
	cultivation_ok(p)
	input.farm.opul_procedure.conditions_met_through_year == true
	is_number(p.area_ha)
	p.area_ha >= 0
	amount := tariff(p, input.farm.year) * p.area_ha
}

park_checks_complete(p) if p.mfa.national_park == "none"

park_checks_complete(p) if {
	is_string(p.mfa.national_park)
	p.mfa.park_relevant_conditions == false
}

parcel_amounts_before_farm_checks := {p.parcel_id: parcel_amount_before_farm_checks(p) | some p in input.land.parcels}
