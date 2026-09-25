package oepul.o6_4_test

import data.oepul.o6_4
import rego.v1

base := {
	"farm": {"year": 2026},
	"land": {"parcels": [{
		"parcel_id": "p1", "area_ha": 2,
		"mountain_meadow": {
			"participates": true, "is_mountain_meadow": true, "area_above_1200m_ha": 1.1,
			"code": "BM2", "mowing_count": 1, "mowing_count_last_two_years": 1,
			"mowed_area_ha": 2, "mowings": [{"forage_removed": true}],
			"grazing_occurred": true, "grazing_start_date": "2026-08-16",
			"fertilizer_applications": [{"kind": "farmyard_manure", "original_form": true}],
			"psm_applications": [{"bio_eu_2018_848_allowed": true}],
		},
	}]},
}

test_rate_and_premium if {
	premiums := o6_4.annual_premium with input as base
	premiums.p1 == 1188
	violations := o6_4.violations with input as base
	count(violations) == 0
}

test_altitude_violation if {
	bad := object.union(base, {"land": {"parcels": [object.union(base.land.parcels[0], {"mountain_meadow": object.union(base.land.parcels[0].mountain_meadow, {"area_above_1200m_ha": 1})})]}})
	some v in o6_4.violations with input as bad
	v.rule == "O64.ELIGIBILITY.ALTITUDE"
}

test_bm0_not_paid if {
	idle := object.union(base, {"land": {"parcels": [object.union(base.land.parcels[0], {"mountain_meadow": object.union(base.land.parcels[0].mountain_meadow, {"code": "BM0", "mowing_count": 0, "mowings": []})})]}})
	not o6_4.annual_premium.p1 with input as idle
	violations := o6_4.violations with input as idle
	count(violations) == 0
}
