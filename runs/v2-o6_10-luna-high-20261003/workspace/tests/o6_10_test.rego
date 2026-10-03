package oepul.o6_10_test

import data.oepul.o6_10
import rego.v1

sample := {
	"farm": {"year": 2025},
	"land": {"parcels": [{
		"area_ha": 1,
		"land_use": "special_crop",
		"slope_percent": 30,
		"crop": {"crop_category": "vineyard"},
		"o6_10": {
			"full_year_and_all_alleys_cover": true,
			"hardy_mixture_partners": 3,
			"open_stem_width_cm": 80,
			"cover_type": "sown_mixture",
			"cover_removal_method": "mechanical",
			"surcharge_applied": true,
		},
	}]},
	"o6_10": {
		"requested": true,
		"records": {},
		"organism_or_pheromone_surcharge_requested": false,
	},
}

test_valid_vineyard if {
	o6_10.eligible with input as sample
	o6_10.premium_eur_per_ha == 324 with input as sample
}

test_minimum_area_violation if {
	not o6_10.eligible with input as object.union(sample, {"land": {"parcels": []}})
	"minimum_participation_area" in o6_10.violations with input as object.union(sample, {"land": {"parcels": []}})
}

test_invalid_cover_violation if {
	bad := object.union(sample, {"land": {"parcels": [{
		"area_ha": 1,
		"slope_percent": 10,
		"crop": {"crop_category": "orchard"},
		"o6_10": {"full_year_and_all_alleys_cover": true, "hardy_mixture_partners": 3, "cover_type": "self_seeding"},
	}]}})
	not o6_10.eligible with input as bad
	"invalid_cover_culture" in o6_10.violations with input as bad
}

test_reduced_surcharge if {
	with_surcharge := object.union(sample, {"o6_10": {
		"requested": true,
		"records": {},
		"organism_or_pheromone_surcharge_requested": true,
		"surcharge_applied_on_at_least_one_plot": true,
		"application_replaces_pesticide": true,
		"insecticide_avoidance": true,
	}})
	o6_10.surcharge_eur_per_ha == 81 with input as with_surcharge
}

test_drought_exception if {
	dry := object.union(sample, {"farm": {"year": 2026}, "o6_10": {
		"requested": true,
		"drought_2026": true,
		"proper_cover_establishment": true,
		"records": {},
	}})
	o6_10.eligible with input as dry
}

test_farm_records_required if {
	incomplete := object.union(sample, {"o6_10": {"requested": true, "records": {"farm": false}}})
	not o6_10.eligible with input as incomplete
	"records_incomplete" in o6_10.violations with input as incomplete
}
