package oepul.o6_16_test

import data.oepul.o6_16

maize_with_psm(substances, product_type) := object.union(maize_parcel, {"operations": {"psm_applications": [{"date": "2026-05-10", "active_substances": substances, "product_type": product_type}]}})

test_banned_substance_on_maize if {
	inp := with_parcels([maize_with_psm(["S-Metolachlor"], "chemical_synthetic"), wheat_parcel])
	"o6_16.psm.banned_active_substances" in rule_ids(o6_16.violations) with input as inp
}

test_banned_substance_terbuthylazin_case_insensitive if {
	inp := with_parcels([maize_with_psm(["terbuthylazin"], "chemical_synthetic")])
	"o6_16.psm.banned_active_substances" in rule_ids(o6_16.violations) with input as inp
}

test_banned_substance_on_wheat_allowed if {
	w := object.union(wheat_parcel, {"operations": {"psm_applications": [{"date": "2026-04-10", "active_substances": ["Metazachlor"], "product_type": "chemical_synthetic"}]}})
	not "o6_16.psm.banned_active_substances" in rule_ids(o6_16.violations) with input as with_parcels([w])
}

test_banned_substance_outside_area_allowed if {
	p := object.union(maize_with_psm(["S-Metolachlor"], "chemical_synthetic"), {"cadastral_community_number": "99999"})
	not "o6_16.psm.banned_active_substances" in rule_ids(o6_16.violations) with input as with_parcels([p])
}

test_bentazon_only_if_reauthorized if {
	inp := with_parcels([maize_with_psm(["Bentazon"], "chemical_synthetic")])
	not "o6_16.psm.banned_active_substances" in rule_ids(o6_16.violations) with input as inp
	inp2 := object.union(inp, {"farm": {"oepul": {"o6_16": {"bentazon_reauthorized": true}}}})
	"o6_16.psm.banned_active_substances" in rule_ids(o6_16.violations) with input as inp2
}

test_psm_coding_required_2025 if {
	inp := with_year(with_parcels([maize_with_psm(["Mesotrione"], "chemical_synthetic")]), 2025)
	"o6_16.psm.coding_until_2025" in rule_ids(o6_16.violations) with input as inp
}

test_psm_coding_psmcs_sufficient_for_mixed_use if {
	p := object.union(maize_parcel, {
		"operations": {"psm_applications": [
			{"date": "2025-05-10", "active_substances": ["Mesotrione"], "product_type": "chemical_synthetic"},
			{"date": "2025-06-10", "active_substances": ["Kupfer"], "product_type": "bio"},
		]},
		"oepul": {"codes": ["PSMCS"]},
	})
	not "o6_16.psm.coding_until_2025" in rule_ids(o6_16.violations) with input as with_year(with_parcels([p]), 2025)
}

test_psm_coding_bio_only if {
	p := object.union(maize_with_psm(["Kupfer"], "bio"), {"oepul": {"codes": ["PSMBIO"]}})
	not "o6_16.psm.coding_until_2025" in rule_ids(o6_16.violations) with input as with_year(with_parcels([p]), 2025)
}

test_psm_coding_dropped_from_2026 if {
	not o6_16.psm_coding_required(2026)
	inp := with_parcels([maize_with_psm(["Mesotrione"], "chemical_synthetic")])
	not "o6_16.psm.coding_until_2025" in rule_ids(o6_16.violations) with input as inp
}

# Oberösterreich (KG 51106 Bergham)
ooe_parcel(crop, applications) := object.union(maize_parcel, {
	"parcel_id": "OOE1",
	"cadastral_community_number": "51106",
	"n_reduction_zone": "restliche_gebietskulisse",
	"crop": crop,
	"operations": {"fertilizer_applications": applications},
})

wheat_crop := {"crop_category": "cereal", "crop_name": "Winterweizen"}

maize_crop := {"crop_category": "maize", "crop_name": "Körnermais"}

test_ooe_soluble_n_ban_autumn if {
	p := ooe_parcel(wheat_crop, [{"date": "2026-11-02", "readily_soluble_n": true, "n_available_kg_ha": 40}])
	"o6_16.ooe.readily_soluble_n_ban" in rule_ids(o6_16.violations) with input as with_parcels([p])
}

test_ooe_soluble_n_allowed_march_for_wheat if {
	p := ooe_parcel(wheat_crop, [{"date": "2026-03-01", "readily_soluble_n": true, "n_available_kg_ha": 40}])
	not "o6_16.ooe.readily_soluble_n_ban" in rule_ids(o6_16.violations) with input as with_parcels([p])
}

test_ooe_soluble_n_banned_march_for_maize if {
	p := ooe_parcel(maize_crop, [{"date": "2026-03-15", "readily_soluble_n": true, "n_available_kg_ha": 40}])
	"o6_16.ooe.readily_soluble_n_ban" in rule_ids(o6_16.violations) with input as with_parcels([p])
}

test_ooe_forage_exempt_from_february_ban if {
	p := ooe_parcel({"crop_category": "other", "crop_name": "Kleegras"}, [{"date": "2026-02-01", "readily_soluble_n": true, "n_available_kg_ha": 30}])
	not "o6_16.ooe.readily_soluble_n_ban" in rule_ids(o6_16.violations) with input as with_parcels([p])
}

test_ooe_not_applicable_outside_upper_austria if {
	p := object.union(maize_parcel, {"operations": {"fertilizer_applications": [{"date": "2026-11-02", "readily_soluble_n": true, "n_available_kg_ha": 120}]}})
	vs := rule_ids(o6_16.violations) with input as with_parcels([p])
	not "o6_16.ooe.readily_soluble_n_ban" in vs
	not "o6_16.ooe.split_n_applications" in vs
}

test_ooe_split_application if {
	p := ooe_parcel(maize_crop, [{"date": "2026-05-02", "readily_soluble_n": true, "n_available_kg_ha": 90}])
	"o6_16.ooe.split_n_applications" in rule_ids(o6_16.violations) with input as with_parcels([p])
	p2 := ooe_parcel(maize_crop, [{"date": "2026-05-02", "readily_soluble_n": true, "n_available_kg_ha": 90, "slow_release": true}])
	not "o6_16.ooe.split_n_applications" in rule_ids(o6_16.violations) with input as with_parcels([p2])
	p3 := ooe_parcel(maize_crop, [{"date": "2026-05-02", "readily_soluble_n": true, "n_available_kg_ha": 80}])
	not "o6_16.ooe.split_n_applications" in rule_ids(o6_16.violations) with input as with_parcels([p3])
}

test_ooe_cover_crop_variant_3 if {
	p := object.union(ooe_parcel(wheat_crop, []), {"operations": {"cover_crop": {"is_used": true, "o6_6_variant": 3}}})
	"o6_16.ooe.no_cover_crop_variant_3" in rule_ids(o6_16.violations) with input as with_parcels([p])
}

test_ooe_control_walk if {
	p := object.union(ooe_parcel(wheat_crop, []), {"operations": {"psm_applications": [{"date": "2026-05-01", "active_substances": ["Prosulfocarb"], "product_type": "chemical_synthetic"}]}})
	"o6_16.ooe.ipm_control_walk" in rule_ids(o6_16.violations) with input as with_parcels([p])
	p2 := object.union(ooe_parcel(wheat_crop, []), {"operations": {"psm_applications": [{"date": "2026-05-01", "active_substances": ["Prosulfocarb"], "product_type": "chemical_synthetic", "warning_service_documented": true}]}})
	not "o6_16.ooe.ipm_control_walk" in rule_ids(o6_16.violations) with input as with_parcels([p2])
}
