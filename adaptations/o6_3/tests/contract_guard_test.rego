package adapted.o6_3_test

import rego.v1

# Direct consumers also get an explicit unknown decision for missing/null arrays.
test_absent_input_is_a_data_gap if {
	r := data.adapted.o6_3.decision with input as {}
	r.status == "missing_data"
	r.current_rgve == null
	r.indicative_premium_eur == null
}

test_null_collections_never_become_confirmed_zero if {
	r := data.adapted.o6_3.decision with input as {
		"land": {"parcels": null, "parcels_complete": true},
		"livestock": {"species_groups": null, "species_groups_complete": true},
	}
	r.status == "missing_data"
	r.current_rgve == null
	r.premium_area_ha == null
}

test_wrong_year_is_not_a_funding_rejection if {
	r := data.adapted.o6_3.decision with input as {
		"context": {"current_year": 2026, "snapshot_year": 2025, "as_of": "2026-10-07"},
		"farm": {"year": 2026},
	}
	r.status == "missing_data"
	"SNAPSHOT_YEAR_MISMATCH" in r.basis_failures
	r.indicative_premium_eur == null
}
