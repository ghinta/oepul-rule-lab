package oepul.o6_18_test

import data.oepul.o6_18

base := {"land": {"arable_area_ha": 10, "total_area_ha": 220}, "o6_18": {"participates": true, "project_confirmation": {"present": true}, "monitoring": {"phenology": true, "great_bustard": true}, "regional_plan": {"requested": true, "annual_confirmation": true}, "fallow_requested_ha": 4, "parcels": [{"parcel_id": "p1", "nat_code": true, "land_use": "grassland", "uses_per_year": 2, "care_or_use_within_two_years": true, "prohibited_general_activity": false, "requires_grazing_log": false, "project_operations_confirmed": true, "project_codes": ["GL06"]}]}}

test_eligible if o6_18.eligible with input as base
test_regional_plan_premium if o6_18.regional_plan_premium_eur == 270 with input as base
test_fallow_cap if o6_18.fallow_eligible_ha == 2.5 with input as base
test_modulation if o6_18.area_modulation_factor == 0.9909090909090909091 with input as base

test_missing_monitoring_violation if {
	v := o6_18.violations with input as object.union(base, {"o6_18": object.union(base.o6_18, {"monitoring": {"phenology": false, "great_bustard": true}})})
	v[_].rule_id == "o6_18.phenology_monitoring"
}

test_invalid_annex_code_violation if {
	v := o6_18.violations with input as object.union(base, {"o6_18": object.union(base.o6_18, {"parcels": [object.union(base.o6_18.parcels[0], {"project_codes": ["ZZ99"]})]})})
	v[_].rule_id == "o6_18.annex_code"
}

test_fallow_care_needs_sa01 if {
	v := o6_18.violations with input as object.union(base, {"o6_18": object.union(base.o6_18, {"parcels": [object.union(base.o6_18.parcels[0], {"project_codes": ["SB01"]})]})})
	v[_].rule_id == "o6_18.fallow_combination"
}
