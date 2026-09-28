package oepul.o6_14_test

import data.oepul.o6_14
import rego.v1

test_rgve_and_area_cap if {
	alp := {"id": "a1", "area_ha": 10, "access_stage": "stage_1", "nature_supplement": false, "weideplan": false, "weideplan_intensification_approved": false, "animals": [{"species": "cattle", "category": "cattle_2_plus", "count": 12, "days_total": 60}]}
	o6_14.stocking_rgve(alp) == 12
	o6_14.eligible_premium_area(alp) == 10
	o6_14.base_premium(alp) == 432
}

test_stocking_limit_and_option_incompatibility if {
	alp := {"id": "a2", "area_ha": 10, "access_stage": "stage_3", "nature_supplement": true, "weideplan": true, "weideplan_intensification_approved": false, "animals": [{"species": "cattle", "category": "cattle_2_plus", "count": 16, "days_total": 60}]}
	o6_14.stocking_limit(alp) == 1.5
	not o6_14.stocking_compliant(alp)
}

test_weideplan_rate_first_twenty_hectares if {
	alp := {"id": "a3", "area_ha": 25, "access_stage": "stage_2", "nature_supplement": false, "weideplan": true, "weideplan_intensification_approved": false, "animals": [{"species": "cattle", "category": "cattle_2_plus", "count": 25, "days_total": 60}]}
	o6_14.weideplan_premium(alp) == 400
}
