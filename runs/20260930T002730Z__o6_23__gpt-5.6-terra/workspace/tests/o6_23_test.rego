package oepul.o6_23_test

import data.oepul.o6_23
import rego.v1

test_eligible_parcel_and_premium if {
	test_input := {"application": {"o6_23": {"applied": true}}, "land": {"parcels": [{"parcel_id": "p1", "area_ha": 2, "natura2000": {"selected": true, "project_confirmation_present": true, "project_requirements_met": true, "management_code": "N2GL04", "obligation_chapters": ["G", "L"]}}]}}
	o6_23.eligible with input as test_input
	o6_23.premium_eur.p1 == 453.6 with input as test_input
	violations := o6_23.violations with input as test_input
	count(violations) == 0
}

test_missing_confirmation_is_violation if {
	test_input := {"application": {"o6_23": {"applied": true}}, "land": {"parcels": [{"parcel_id": "p1", "area_ha": 1, "natura2000": {"selected": true, "project_confirmation_present": false, "project_requirements_met": true, "management_code": "N2GI05", "obligation_chapters": ["G"]}}]}}
	not o6_23.eligible with input as test_input
	violations := o6_23.violations with input as test_input
	{"parcel_id": "p1", "code": "missing_project_confirmation"} in violations
}

test_incompatible_combination_is_flagged if {
	test_input := {"application": {"o6_23": {"applied": true}}, "land": {"parcels": [{"parcel_id": "p1", "area_ha": 1, "natura2000": {"selected": true, "project_confirmation_present": true, "project_requirements_met": true, "management_code": "N2GI05", "obligation_chapters": ["G", "W"]}}]}}
	violations := o6_23.violations with input as test_input
	{"parcel_id": "p1", "code": "incompatible_obligation_combination"} in violations
}

test_2026_exception_needs_regulation_change if {
	parcel := {"natura2000": {"selected": true, "cut_date_changed_by_land_regulation": true}}
	o6_23.can_use_2026_drought_cut_exception(parcel)
}
