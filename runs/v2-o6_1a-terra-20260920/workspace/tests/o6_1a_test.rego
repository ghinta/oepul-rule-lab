package oepul.o6_1a_test

import data.oepul.o6_1a
import rego.v1

base := {"farm": {"year": 2026}, "ubb": {"arable_area_ha": 10, "mown_grassland_area_ha": 10, "fodder_area_ha": 10, "rgve_total": 3, "cereal_maize_area_ha": 7, "arable_biodiversity_eligible_ha": 0.7, "mown_grassland_biodiversity_eligible_ha": 0.7, "crop_shares": [{"name": "wheat", "area_ha": 5, "exempt_55pct": false}], "training": {"biodiversity_hours": 3}, "parcels": []}}

test_baseline_passes if {
	vs := o6_1a.violations with input as base
	count(vs) == 0
}

test_arable_threshold if {
	v := o6_1a.required_arable_biodiversity_ha with input as base
	v == 0.7
}

test_cereal_limit_fails if {
	i := object.union(base, {"ubb": object.union(base.ubb, {"cereal_maize_area_ha": 7.6})})
	vs := o6_1a.violations with input as i
	some v in vs
	v.rule_id == "o6_1a.crop.cereal_maize_limit"
}

test_divrs_seed_rate_fails if {
	p := {"biodiversity": {"code": "DIVRS", "species_count": 30, "family_count": 7, "seed_rate_kg_ha": 19, "is_arable": true, "drusch": false, "fertilized": false}}
	i := object.union(base, {"ubb": object.union(base.ubb, {"parcels": [p]})})
	vs := o6_1a.violations with input as i
	some v in vs
	v.rule_id == "o6_1a.biodiv.regional_seed"
}

test_2026_divnfz_exception if {
	p := {"biodiversity": {"code": "DIVNFZ", "rest_days": 49, "op_ubb_or_bio": true, "is_arable": false, "is_grassland": true, "pesticide_non_bio": false}}
	i := object.union(base, {"ubb": object.union(base.ubb, {"parcels": [p]})})
	vs := o6_1a.violations with input as i
	count(vs) == 0
}

test_rare_cultivar_data if {
	v := o6_1a.rare_cultivar_tier.Soblus with input as base
	v == "A"
}

test_rgve_factor_from_annex_table if {
	v := o6_1a.rgve_factor("Rinder unter ½ Jahr") with input as base
	v == 0.4
}

test_land_access_cap_from_2026 if {
	i := object.union(base, {"ubb": object.union(base.ubb, {"access": {"year": 2026, "added_area_ha": 12, "measure_area_ha_2025": 20, "previously_under_same_measure": false}})})
	v := o6_1a.premium_eligible_access_ha with input as i
	v == 10
}
