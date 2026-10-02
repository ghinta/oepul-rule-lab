package oepul.o6_16_test

import data.oepul.o6_16

ag_parcel := {
	"parcel_id": "AG1",
	"area_ha": 3,
	"land_use": "arable",
	"cadastral_community_number": "20152",
	"n_reduction_zone": "oestliches_niederoesterreich_inkl_tullnerfeld",
	"crop": {"crop_category": "fallow", "crop_name": "Grünbrache"},
	"operations": {"tillage_type": "no_till", "cover_crop": {"is_used": false, "sowing_date": null}, "psm_used": false, "fertilizer": {"mineral_n_kg_per_ha": 0, "organic_n_kg_per_ha": 0}, "cutting_dates": ["2026-07-10"]},
	"oepul": {"codes": ["AG"], "usage_type": "Grünbrache"},
	"leaching_option": {
		"ackerzahl_avg": 35,
		"first_ag_year": 2026,
		"sowing_date": "2026-04-20",
		"mix_winter_hardy": true,
		"mix_contains_legumes": false,
		"existing_stand_retained": false,
		"grassland_in_mfa_2020": false,
		"grazed": false,
		"threshed": false,
		"mowing_or_mulching_years": [2026],
	},
}

ag_input(p) := with_parcels([maize_parcel, wheat_parcel, outside_parcel, p])

test_ag_compliant_parcel if {
	vs := rule_ids(o6_16.violations) with input as ag_input(ag_parcel)
	count({r | some r in vs; startswith(r, "o6_16.ag.")}) == 0
}

test_ag_ackerzahl_above_40 if {
	p := object.union(ag_parcel, {"leaching_option": {"ackerzahl_avg": 45}})
	"o6_16.ag.eligibility" in rule_ids(o6_16.violations) with input as ag_input(p)
}

test_ag_grassland_2020_not_eligible if {
	p := object.union(ag_parcel, {"leaching_option": {"grassland_in_mfa_2020": true}})
	"o6_16.ag.eligibility" in rule_ids(o6_16.violations) with input as ag_input(p)
}

test_ag_late_sowing if {
	p := object.union(ag_parcel, {"leaching_option": {"sowing_date": "2026-05-20"}})
	"o6_16.ag.establishment" in rule_ids(o6_16.violations) with input as ag_input(p)
}

test_ag_legumes_in_new_mix if {
	p := object.union(ag_parcel, {"leaching_option": {"mix_contains_legumes": true}})
	"o6_16.ag.establishment" in rule_ids(o6_16.violations) with input as ag_input(p)
}

test_ag_existing_stand_retained if {
	p := object.union(ag_parcel, {"leaching_option": {"existing_stand_retained": true, "sowing_date": null}})
	not "o6_16.ag.establishment" in rule_ids(o6_16.violations) with input as ag_input(p)
}

test_ag_breakup_too_early if {
	p := object.union(ag_parcel, {"leaching_option": {"breakup_date": "2027-09-01"}})
	inp := with_year(ag_input(p), 2027)
	"o6_16.ag.breakup_date" in rule_ids(o6_16.violations) with input as inp
	o6_16.ag_earliest_breakup(p) == "2027-09-15" with input as inp
}

test_ag_breakup_takeover_counts_previous_farm if {
	# Folgebetrieb übernimmt im 2. Jahr: Umbruch bereits am 15.09. des Übernahmejahres möglich
	p := object.union(ag_parcel, {"leaching_option": {"first_ag_year": 2027, "previous_farm_first_ag_year": 2026, "breakup_date": "2027-09-15"}})
	not "o6_16.ag.breakup_date" in rule_ids(o6_16.violations) with input as with_year(ag_input(p), 2027)
}

test_ag_fertilizer_forbidden if {
	p := object.union(ag_parcel, {"operations": {"fertilizer": {"organic_n_kg_per_ha": 30}}})
	"o6_16.ag.no_psm_no_fertilizer" in rule_ids(o6_16.violations) with input as ag_input(p)
}

test_ag_psm_forbidden if {
	p := object.union(ag_parcel, {"operations": {"psm_used": true}})
	"o6_16.ag.no_psm_no_fertilizer" in rule_ids(o6_16.violations) with input as ag_input(p)
}

test_ag_mowing_every_second_year if {
	p := object.union(ag_parcel, {"operations": {"cutting_dates": []}, "leaching_option": {"mowing_or_mulching_years": [2026]}})
	not "o6_16.ag.mowing_every_second_year" in rule_ids(o6_16.violations) with input as with_year(ag_input(p), 2027)
	"o6_16.ag.mowing_every_second_year" in rule_ids(o6_16.violations) with input as with_year(ag_input(p), 2028)
}

test_ag_grazing_forbidden if {
	p := object.union(ag_parcel, {"leaching_option": {"grazed": true}})
	"o6_16.ag.no_grazing_no_threshing" in rule_ids(o6_16.violations) with input as ag_input(p)
}

test_ag_usage_type if {
	p := object.union(ag_parcel, {"oepul": {"usage_type": "Winterweizen"}})
	"o6_16.application.ag_usage_type" in rule_ids(o6_16.violations) with input as ag_input(p)
}

test_ag_div_requires_ubb_or_bio if {
	p := object.union(ag_parcel, {"oepul": {"codes": ["AG", "DIV"]}})
	not "o6_16.application.ag_div_double_coding" in rule_ids(o6_16.violations) with input as ag_input(p)
	inp := object.union(ag_input(p), {"farm": {"oepul": {"participating_measures": ["o6_16", "o6_6"]}}})
	"o6_16.application.ag_div_double_coding" in rule_ids(o6_16.violations) with input as inp
}

test_ag_premium_capped_at_20_percent if {
	big := object.union(ag_parcel, {"area_ha": 6})

	# Ackerfläche des Betriebes 22 ha -> max. 4,4 ha AG-Prämienfläche
	o6_16.ag_premium_area == 4.4 with input as ag_input(big)
	c := o6_16.premium_components.leaching_risk_area with input as ag_input(big)
	c.amount_eur == 2376
}

test_ag_gloez4_area_deducted if {
	p := object.union(ag_parcel, {"leaching_option": {"gloez4_area_ha": 0.5}})
	o6_16.ag_eligible_area(p) == 2.5 with input as ag_input(p)
}

test_ag_npf_until_2024_no_premium if {
	p := object.union(ag_parcel, {"oepul": {"codes": ["AG", "NPF"]}})
	o6_16.ag_npf_no_premium(p) with input as with_year(ag_input(p), 2024)
	not o6_16.ag_npf_no_premium(p) with input as with_year(ag_input(p), 2025)
}

test_ag_conversion_deadline if {
	o6_16.ag_conversion_possible("o6_18", "2025-12-31")
	not o6_16.ag_conversion_possible("o6_18", "2026-01-02")
	not o6_16.ag_conversion_possible("o6_1b", "2025-06-01")
}

test_ag_no_basis_premium if {
	# AG-Schlag erhält keine Basisprämie
	o6_16.basis_parcels_ha == 20 with input as ag_input(ag_parcel)
}

# Wien
vienna_parcel := object.union(maize_parcel, {
	"parcel_id": "W1",
	"area_ha": 6,
	"cadastral_community_number": "1104",
	"crop": {"crop_category": "cereal", "crop_name": "Winterweizen"},
	"previous_crop": {"crop_category": "cereal", "crop_name": "Wintergerste", "n_saldo_kg_ha": 10},
	"operations": {"tillage_type": "plough"},
	"oepul": {"o6_8_practices": ["mulchsaat"]},
})

vienna_input(p) := object.union(
	with_parcels([p]),
	{"farm": {"oepul": {"o6_16": {"humus_erosion_vienna": {"applied": true, "project_confirmation": true}}}}},
)

test_vienna_inversion_tillage_forbidden if {
	"o6_16.vienna.no_inversion_tillage" in rule_ids(o6_16.violations) with input as vienna_input(vienna_parcel)
}

test_vienna_tillage_after_maize_allowed if {
	p := object.union(vienna_parcel, {"previous_crop": {"crop_category": "maize", "crop_name": "Körnermais"}})
	not "o6_16.vienna.no_inversion_tillage" in rule_ids(o6_16.violations) with input as vienna_input(p)
}

test_vienna_project_confirmation_required if {
	inp := object.union(vienna_input(vienna_parcel), {"farm": {"oepul": {"o6_16": {"humus_erosion_vienna": {"project_confirmation": false}}}}})
	"o6_16.vienna.scientific_project" in rule_ids(o6_16.violations) with input as inp
}

test_vienna_double_soil_samples if {
	# 6 ha in Wien -> 2 x 2 = 4 Proben
	o6_16.vienna_soil_samples_required == 4 with input as vienna_input(vienna_parcel)
	"o6_16.vienna.double_soil_samples" in rule_ids(o6_16.violations) with input as with_year(vienna_input(vienna_parcel), 2027)
}

test_vienna_o6_8_mulch_excluded if {
	"W1" in o6_16.o6_8_premium_excluded with input as vienna_input(vienna_parcel)
}

test_vienna_premium if {
	c := o6_16.premium_components.humus_erosion_vienna with input as vienna_input(vienna_parcel)
	c.area_ha == 6
	c.amount_eur == 712.8
}

# Schweinefütterung – Rohproteingrenzen
test_pig_protein_average_ok if {
	o6_16.pig_group_protein_ok(pig_group(100))
}

test_pig_protein_average_exceeded if {
	sg := object.union(pig_group(100), {"feeding": {"crude_protein_avg_g_per_kg": 160}})
	not o6_16.pig_group_protein_ok(sg)
	inp := object.union(pig_input(100), {"livestock": {"species_groups": [sg]}})
	"o6_16.pig_feeding.crude_protein_limits" in rule_ids(o6_16.violations) with input as inp
}

test_pig_protein_phase_feeding_alternative if {
	sg := object.union(pig_group(100), {"feeding": {
		"crude_protein_avg_g_per_kg": 160,
		"phase_feeding": true,
		"phase_feeding_plausible": true,
		"phases": [
			{"weight_from_kg": 32, "weight_to_kg": 60, "crude_protein_g_per_kg": 170},
			{"weight_from_kg": 60, "weight_to_kg": 90, "crude_protein_g_per_kg": 155},
			{"weight_from_kg": 90, "weight_to_kg": null, "crude_protein_g_per_kg": 150},
		],
	}})
	o6_16.pig_group_protein_ok(sg)
}

test_pig_protein_phase_exceeded if {
	sg := object.union(pig_group(100), {"feeding": {
		"crude_protein_avg_g_per_kg": 160,
		"phase_feeding": true,
		"phases": [{"weight_from_kg": 90, "weight_to_kg": null, "crude_protein_g_per_kg": 152}],
	}})
	not o6_16.pig_group_protein_ok(sg)
}

test_pig_protein_sows if {
	tragend := {"species": "pigs", "category": "zucht_jungsauen_ab_50kg", "animal_count": 10, "feeding": {"feeding_category": "zuchtsau_tragend_jungsau_gedeckt", "crude_protein_avg_g_per_kg": 126}}
	not o6_16.pig_group_protein_ok(tragend)
	saeugend := {"species": "pigs", "category": "zucht_jungsauen_ab_50kg", "animal_count": 10, "feeding": {"feeding_category": "zuchtsau_saeugend", "crude_protein_avg_g_per_kg": 155}}
	o6_16.pig_group_protein_ok(saeugend)
}

test_pig_feeding_evidence_required if {
	sg := object.union(pig_group(100), {"feeding": {"recipe_evidence_available": false}})
	inp := object.union(pig_input(100), {"livestock": {"species_groups": [sg]}})
	"o6_16.pig_feeding.evidence" in rule_ids(o6_16.violations) with input as inp
}

# Cultan
cul_parcel := object.union(wheat_parcel, {
	"parcel_id": "C1",
	"oepul": {"codes": ["CUL"]},
	"operations": {"fertilizer_applications": [{"date": "2026-03-20", "method": "cultan_injection", "n_available_kg_ha": 120, "recorded": true, "external_contractor": true, "contractor_invoice_available": true}]},
})

test_cultan_premium if {
	c := o6_16.premium_components.cultan with input as with_parcels([maize_parcel, cul_parcel])
	c.area_ha == 8
	c.amount_eur == 320
}

test_cultan_missing_invoice if {
	p := object.union(cul_parcel, {"operations": {"fertilizer_applications": [{"date": "2026-03-20", "method": "cultan_injection", "recorded": true, "external_contractor": true, "contractor_invoice_available": false}]}})
	"o6_16.cultan.requirements" in rule_ids(o6_16.violations) with input as with_parcels([p])
}

test_cultan_not_before_2025 if {
	"o6_16.cultan.requirements" in rule_ids(o6_16.violations) with input as with_year(with_parcels([cul_parcel]), 2024)
}
