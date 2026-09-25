package oepul.o6_9_test

import data.oepul.o6_9
import rego.v1

base_input := {
	"farm": {"year": 2026},
	"o6_9": {
		"dungungswuerdige_area_ha": 2,
		"cattle_gve_annual_average": 3,
		"arable_area_ha": 2,
		"pig_gve_annual_average": 2,
		"gw_acker_same_named_pig_option": false,
		"pig_feeding_evidence_available": true,
		"all_held_pigs_covered": true,
		"applications": [{"parcel_id": "A1", "volume_m3": 50, "manure_type": "slurry", "technique": "trailing_hose", "land_use": "arable", "on_farm_land": true, "record_complete": true, "external_device": false}],
		"separations": [{"date": "2026-05-05", "volume_m3": 30, "origin": "own_cattle", "mechanical_separation": true, "record_complete": true, "external_device": false}],
		"pig_rations": [{"category": "piglet_8_to_32_kg", "method": "average", "protein_g_per_kg_88pct_dm": 160}, {"category": "grower_finisher_32kg_to_finish", "method": "average", "protein_g_per_kg_88pct_dm": 157}, {"category": "pregnant_sow", "method": "maximum", "protein_g_per_kg_88pct_dm": 120}],
	},
}

test_eligible_records_and_caps if {
	application_cap := o6_9.application_cap_m3 with input as base_input
	application_cap == 100
	separation_cap := o6_9.separation_cap_m3 with input as base_input
	separation_cap == 60
	application_premium := o6_9.claimed_application_premium_eur with input as base_input
	application_premium == 55
	separation_premium := o6_9.claimed_separation_premium_eur with input as base_input
	separation_premium == 45
	o6_9.contract_continues with input as base_input
}

test_external_device_requires_evidence if {
	changed := object.union(base_input, {"o6_9": object.union(base_input.o6_9, {"applications": [{"parcel_id": "A1", "volume_m3": 20, "manure_type": "slurry", "technique": "trailing_shoe", "land_use": "arable", "on_farm_land": true, "record_complete": true, "external_device": true, "external_service_evidence": false}], "separations": [], "pig_gve_annual_average": 0})})
	records := o6_9.eligible_application_records with input as changed
	count(records) == 0
	o6_9.contract_ends with input as changed
}

test_pig_feeding_rules_and_noncombination if {
	o6_9.pig_feeding_eligible with input as base_input
	pig_premium := o6_9.pig_feeding_premium_eur with input as base_input
	pig_premium == 108
	excluded := object.union(base_input, {"o6_9": object.union(base_input.o6_9, {"gw_acker_same_named_pig_option": true})})
	not o6_9.pig_feeding_eligible with input as excluded
}

test_protein_limit_violation if {
	changed := object.union(base_input, {"o6_9": object.union(base_input.o6_9, {"pig_rations": [{"category": "pregnant_sow", "method": "maximum", "protein_g_per_kg_88pct_dm": 126}]})})
	violations := o6_9.pig_protein_violations with input as changed
	count(violations) == 1
	not o6_9.pig_protein_compliant with input as changed
}
