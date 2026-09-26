package oepul.o6_6_test

import data.oepul.o6_6
import rego.v1

valid := {"land": {"arable_area_ha": 3}, "o6_6": {"parcels": [{"parcel_id": "p1", "variant": "2", "arable": true, "active_establishment": true, "cover_is_dense": true, "after_main_crop": true, "followed_by_active_main_crop": true, "volunteer_crop": false, "self_greening": false, "is_cereal": false, "is_maize": false, "cereal_or_maize_share_gt_50": false, "mixture_partners": 7, "plant_families": 3, "insect_flowering_partners": 0, "mineral_n_during_period": false, "combined_n_at_sowing": false, "plant_protection_during_period": false, "mechanically_terminated": true}]}}

test_variant_2_complies if {
	o6_6.compliant.p1 with input as valid
	violations := o6_6.violations with input as valid
	count(violations) == 0
}

test_rejects_nitrogen if {
	bad := object.union(valid, {"o6_6": {"parcels": [object.union(valid.o6_6.parcels[0], {"mineral_n_during_period": true})]}})
	o6_6.violations[_].reason == "nitrogen, plant-protection, or mechanical-termination requirement is not met" with input as bad
}

test_variant_6_closed_list if {
	p := object.union(valid.o6_6.parcels[0], {"variant": "6", "crops": ["wintererbse", "perko"]})
	o6_6.variant_mixture_ok(p)
}
