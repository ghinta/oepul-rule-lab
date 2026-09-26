package oepul.o6_10_test

import data.oepul.o6_10

# ---------------------------------------------------------------------------
# Testfixtures
# ---------------------------------------------------------------------------

full_greening := {
	"establishment_method": "sown_mixture",
	"winter_hardy_mixture_partners": 4,
	"cover_type": "living_greening",
	"contains_pure_cereal_or_maize": false,
	"is_green_cut_rye_variety": false,
	"max_cereal_maize_share_percent": 20,
	"cereal_is_oat_or_spring_barley_nurse_crop": false,
	"full_coverage_all_inter_rows_all_year": true,
	"open_strip_width_cm": 70,
	"greened_share_of_total_area_percent": null,
	"properly_established": true,
	"events": [],
	"growth_used_or_removed": false,
	"grazing": "none",
	"psm_applied_on_greening": false,
	"removal_method": "mechanical",
}

parcel(pid, ctype, area, slope) := {
	"parcel_id": pid,
	"area_ha": area,
	"land_use": "special_crop",
	"slope_percent": slope,
	"crop": {"crop_category": "vineyard", "crop_name": null},
	"permanent_crop": {"type": ctype, "is_grafted_planting_material": true, "planting_system": "single_row"},
	"oepul_codes": [],
	"oepul_measures": ["10"],
	"location": {"is_in_austria": true, "national_park": null},
	"operations": {"inter_row_greening": full_greening},
}

v1 := json.patch(parcel("V1", "vine", 1.0, 20), [
	{"op": "replace", "path": "/oepul_codes", "value": ["EOP"]},
	{"op": "add", "path": "/operations/organisms_pheromones", "value": {"used": true, "per_register_application_rates": true, "replaces_psm_application": true}},
])

v2 := parcel("V2", "vine", 0.5, 40)

t1 := parcel("T1", "vine_terrace", 0.3, 55)

o1 := json.patch(parcel("O1", "fruit", 0.4, 30), [{"op": "replace", "path": "/crop", "value": {"crop_category": "orchard", "crop_name": "Apfel"}}])

h1 := parcel("H1", "hop", 0.2, 5)

all_greening_items := ["farm", "field_piece_number_and_name", "plot_size", "clearing_replanting_date", "greening_establishment_and_break_dates"]

all_eop_items := ["type_and_amount", "purchase_receipts", "reason_and_target", "application_date"]

farm_input(y, ps) := {
	"farm": {
		"farm_id": "AT-TEST",
		"year": y,
		"applicant": {"person_type": "natural_person", "public_authority_share_percent": 0, "is_active_farmer": true, "farms_in_own_name_and_account": true},
		"oepul": {
			"first_oepul_participation_year": 2023,
			"participating_measures": ["10"],
			"producer_organisation": {"is_member": false, "operational_programme_compensates_organisms_or_pheromones": false},
			"o6_10": {
				"measure_application_date": "2022-11-15",
				"multiple_application_submitted": true,
				"deregistration_date": null,
				"control_findings": [],
				"full_reductions_in_contract_period": 0,
			},
		},
	},
	"land": {"total_area_ha": 10, "parcels": ps},
	"documentation": {
		"o6_10_greening_record_items": all_greening_items,
		"o6_10_organisms_pheromones_record_items": all_eop_items,
	},
}

base := farm_input(2026, [v1, v2, t1, o1, h1])

with_farm(inp, path, value) := json.patch(inp, [{"op": "add", "path": path, "value": value}])

approx(a, b) if abs(a - b) < 0.0001

rule_ids(s) := {v.rule_id | some v in s}

violations_for(inp, pid) := {v.rule_id | some v in o6_10.obligation_violations with input as inp; v.parcel_id == pid}

# ---------------------------------------------------------------------------
# Teilnahme und Zugang
# ---------------------------------------------------------------------------

test_base_contract_valid if {
	o6_10.contract_valid with input as base
	o6_10.contract_status == "valid" with input as base
	count(o6_10.access_violations) == 0 with input as base
	count(o6_10.obligation_violations) == 0 with input as base
	count(o6_10.farm_obligation_violations) == 0 with input as base
}

test_min_area_not_reached_contract_lapses if {
	inp := farm_input(2026, [json.patch(v2, [{"op": "replace", "path": "/area_ha", "value": 0.4}])])
	"O610-MIN-AREA" in rule_ids(o6_10.access_violations) with input as inp
	not o6_10.contract_valid with input as inp
	o6_10.contract_status == "lapsed_access_conditions_not_met" with input as inp
	o6_10.payable_total_eur == 0 with input as inp
}

test_min_area_exactly_half_hectare_ok if {
	inp := farm_input(2026, [v2])
	not "O610-MIN-AREA" in rule_ids(o6_10.access_violations) with input as inp
}

test_nursery_not_eligible_and_not_counted if {
	nursery := json.patch(parcel("N1", "vine_nursery", 2.0, 10), [])
	inp := farm_input(2026, [nursery])
	"O610-ELIG-ONLY-VFH" in rule_ids(o6_10.ineligible_parcels) with input as inp
	o6_10.vfh_area_ha == 0 with input as inp
	"O610-MIN-AREA" in rule_ids(o6_10.access_violations) with input as inp
}

test_public_authority_allowed_2024_not_2025 if {
	inp24 := with_farm(farm_input(2024, [v1, v2]), "/farm/applicant/person_type", "territorial_authority")
	count(o6_10.access_violations) == 0 with input as inp24
	inp25 := with_farm(farm_input(2025, [v1, v2]), "/farm/applicant/person_type", "territorial_authority")
	"O610-GEN-PUBLIC-AUTHORITY-10" in rule_ids(o6_10.access_violations) with input as inp25
}

test_legal_person_public_share_over_25_from_2025 if {
	inp := json.patch(base, [
		{"op": "replace", "path": "/farm/applicant/person_type", "value": "legal_person"},
		{"op": "replace", "path": "/farm/applicant/public_authority_share_percent", "value": 30},
	])
	"O610-GEN-PUBLIC-AUTHORITY-10" in rule_ids(o6_10.access_violations) with input as inp
}

test_first_year_farm_min_size if {
	inp := json.patch(farm_input(2026, [v2]), [
		{"op": "replace", "path": "/farm/oepul/first_oepul_participation_year", "value": 2026},
		{"op": "replace", "path": "/land/total_area_ha", "value": 1.2},
	])
	"O610-GEN-FARM-MIN-SIZE" in rule_ids(o6_10.access_violations) with input as inp
}

test_application_after_last_entry_rejected if {
	inp := with_farm(farm_input(2028, [v1, v2]), "/farm/oepul/o6_10/measure_application_date", "2027-05-01")
	o6_10.contract_status == "no_application" with input as inp
	not o6_10.contract_valid with input as inp
}

test_application_for_2027_is_last_entry if {
	inp := with_farm(farm_input(2027, [v1, v2]), "/farm/oepul/o6_10/measure_application_date", "2026-12-31")
	o6_10.contract_valid with input as inp
	o6_10.exit_possible_from_year == 2028 with input as inp
}

test_contract_not_yet_started if {
	inp := with_farm(farm_input(2026, [v1, v2]), "/farm/oepul/o6_10/measure_application_date", "2026-03-01")
	not o6_10.contract_valid with input as inp
}

test_deregistration_in_year_invalidates if {
	inp := with_farm(base, "/farm/oepul/o6_10/deregistration_date", "2026-06-01")
	o6_10.contract_status == "deregistered" with input as inp
	o6_10.payable_total_eur == 0 with input as inp
}

test_deregistration_after_announced_control_blocked if {
	inp := json.patch(base, [
		{"op": "replace", "path": "/farm/oepul/o6_10/deregistration_date", "value": "2026-06-10"},
		{"op": "add", "path": "/farm/oepul/o6_10/on_site_control_announced_date", "value": "2026-06-01"},
	])
	o6_10.contract_valid with input as inp
}

test_reentry_after_deregistration_requires_new_application if {
	inp := json.patch(base, [
		{"op": "replace", "path": "/farm/oepul/o6_10/deregistration_date", "value": "2024-02-01"},
		{"op": "replace", "path": "/farm/oepul/o6_10/measure_application_date", "value": "2025-10-01"},
	])
	o6_10.contract_valid with input as inp
	inp_old := with_farm(base, "/farm/oepul/o6_10/deregistration_date", "2024-02-01")
	not o6_10.contract_valid with input as inp_old
}

test_takeover_valid_until_april_15 if {
	inp := json.patch(base, [
		{"op": "replace", "path": "/farm/oepul/o6_10/measure_application_date", "value": null},
		{"op": "add", "path": "/farm/oepul/o6_10/takeover", "value": {"is_takeover": true, "request_date": "2026-04-15", "farm_already_participating": false, "taken_over_area_ha": 2.0, "additional_area_ha": 0.4}},
	])
	o6_10.contract_valid with input as inp
}

test_takeover_too_late_or_too_large if {
	late := json.patch(base, [
		{"op": "replace", "path": "/farm/oepul/o6_10/measure_application_date", "value": null},
		{"op": "add", "path": "/farm/oepul/o6_10/takeover", "value": {"is_takeover": true, "request_date": "2026-04-16", "farm_already_participating": false, "taken_over_area_ha": 2.0, "additional_area_ha": 0}},
	])
	o6_10.contract_status == "takeover_rejected" with input as late
	large := json.patch(late, [{"op": "replace", "path": "/farm/oepul/o6_10/takeover/request_date", "value": "2026-04-01"}, {"op": "replace", "path": "/farm/oepul/o6_10/takeover/additional_area_ha", "value": 1.5}])
	not o6_10.contract_valid with input as large
}

test_takeover_2028_deadline_april_17 if {
	inp := json.patch(farm_input(2028, [v1, v2]), [
		{"op": "replace", "path": "/farm/oepul/o6_10/measure_application_date", "value": null},
		{"op": "add", "path": "/farm/oepul/o6_10/takeover", "value": {"is_takeover": true, "request_date": "2028-04-17", "farm_already_participating": false, "taken_over_area_ha": 1.0, "additional_area_ha": 0}},
	])
	o6_10.contract_valid with input as inp
}

# ---------------------------------------------------------------------------
# Prämie
# ---------------------------------------------------------------------------

test_base_premium_2026 if {
	# 216*1.0 + 540*0.5 + 864*0.3 + 378*0.4 + 216*0.2 = 939.6; Zuschlag 162*1.0
	approx(o6_10.gross_base_eur, 939.6) with input as base
	approx(o6_10.gross_supplement_eur, 162) with input as base
	approx(o6_10.payable_total_eur, 1101.6) with input as base
	o6_10.decision.premium.parcels.T1.after_modulation_eur > 259 with input as base
}

test_slope_band_boundaries if {
	inp := farm_input(2026, [parcel("A", "vine", 1, 25), parcel("B", "vine", 1, 35), parcel("C", "vine", 1, 50), parcel("D", "fruit", 1, 24.9)])
	o6_10.gross_parcel_premiums.A.base_rate_eur_per_ha == 324 with input as inp
	o6_10.gross_parcel_premiums.B.base_rate_eur_per_ha == 540 with input as inp
	o6_10.gross_parcel_premiums.C.base_rate_eur_per_ha == 864 with input as inp
	o6_10.gross_parcel_premiums.D.base_rate_eur_per_ha == 216 with input as inp
}

test_band_years_use_guaranteed_minimum if {
	inp := farm_input(2024, [v1, v2])
	o6_10.gross_parcel_premiums.V1.base_rate_eur_per_ha == 180 with input as inp
	o6_10.gross_parcel_premiums.V1.base_rate_band_max_eur_per_ha == 220 with input as inp
	o6_10.gross_parcel_premiums.V1.supplement_rate_eur_per_ha == 135 with input as inp
}

test_eop_reduced_by_half_with_bio_or_12 if {
	inp := with_farm(base, "/farm/oepul/participating_measures", ["10", "1B"])
	o6_10.gross_parcel_premiums.V1.supplement_rate_eur_per_ha == 81 with input as inp
	inp12 := with_farm(base, "/farm/oepul/participating_measures", ["10", "12"])
	o6_10.gross_parcel_premiums.V1.supplement_rate_eur_per_ha == 81 with input as inp12
	inp11 := with_farm(base, "/farm/oepul/participating_measures", ["10", "11"])
	o6_10.gross_parcel_premiums.V1.supplement_rate_eur_per_ha == 162 with input as inp11
}

test_eop_blocked_by_producer_organisation if {
	inp := json.patch(base, [
		{"op": "replace", "path": "/farm/oepul/producer_organisation/is_member", "value": true},
		{"op": "replace", "path": "/farm/oepul/producer_organisation/operational_programme_compensates_organisms_or_pheromones", "value": true},
	])
	not o6_10.eop_supplement_granted with input as inp
	"O610-EOP-NO-OP-PO" in rule_ids(o6_10.eop_rejections) with input as inp
	o6_10.gross_supplement_eur == 0 with input as inp
	o6_10.contract_valid with input as inp
}

test_eop_requires_replacing_psm if {
	inp := farm_input(2026, [json.patch(v1, [{"op": "replace", "path": "/operations/organisms_pheromones/replaces_psm_application", "value": false}]), v2])
	"O610-EOP-REQ-USE" in rule_ids(o6_10.eop_rejections) with input as inp
	not o6_10.eop_supplement_granted with input as inp
}

test_eop_records_incomplete if {
	inp := with_farm(base, "/documentation/o6_10_organisms_pheromones_record_items", ["type_and_amount"])
	"O610-EOP-RECORDS" in rule_ids(o6_10.farm_obligation_violations) with input as inp
}

test_modulation_example_220_ha if {
	approx(o6_10.modulation_factor_for(220), 218 / 220)
	o6_10.modulation_factor_for(150) == 1
	approx(o6_10.modulation_factor_for(1100), (((200 + 90) + 595) + 75) / 1100)
}

test_sanction_reduction_and_2027_withholding if {
	inp := with_farm(base, "/farm/oepul/o6_10/control_findings", [{"stage": "reduction_10"}, {"stage": "warning"}])
	o6_10.content_reduction_percent == 10 with input as inp
	approx(o6_10.payable_total_eur, 1101.6 * 0.9) with input as inp
	inp27 := json.patch(farm_input(2027, [v1, v2]), [{"op": "replace", "path": "/farm/oepul/o6_10/control_findings", "value": [{"stage": "warning"}]}])
	o6_10.content_reduction_percent == 1 with input as inp27
	inp26 := with_farm(base, "/farm/oepul/o6_10/control_findings", [{"stage": "warning"}])
	o6_10.content_reduction_percent == 0 with input as inp26
}

test_exclusion_after_second_full_reduction if {
	inp := json.patch(base, [
		{"op": "replace", "path": "/farm/oepul/o6_10/control_findings", "value": [{"stage": "reduction_100"}]},
		{"op": "replace", "path": "/farm/oepul/o6_10/full_reductions_in_contract_period", "value": 1},
	])
	o6_10.excluded_from_measure with input as inp
	o6_10.payable_total_eur == 0 with input as inp
}

test_area_payment_cap_from_2025 if {
	capped := json.patch(v2, [{"op": "add", "path": "/other_area_payments_eur_per_ha", "value": 1000}])
	inp := farm_input(2026, [capped])

	# 540 + 1000 = 1540 > 1300 => Überschreitung 240, anteilig 240*540/1540 je ha
	approx(o6_10.parcel_payments.V2.cap_excess_eur_per_ha, 240) with input as inp
	approx(o6_10.parcel_payments.V2.payable_eur, 270 - (((240 * 540) / 1540) * 0.5)) with input as inp
	inp24 := farm_input(2024, [capped])
	o6_10.parcel_payments.V2.cap_excess_eur_per_ha == 0 with input as inp24
}

test_minimum_payout_notice if {
	# 0,2 ha Hopfen (43,20 EUR) + 0,3 ha Wein mit Code OP: Mindestfläche erreicht, Betrag <= 50 EUR
	inp := farm_input(2026, [h1, json.patch(parcel("X", "vine", 0.3, 10), [{"op": "add", "path": "/oepul_codes", "value": ["OP"]}])])
	o6_10.contract_valid with input as inp
	approx(o6_10.payable_total_eur, 43.2) with input as inp
	o6_10.below_minimum_payout with input as inp
	"O610-GEN-MIN-PAYOUT" in rule_ids(o6_10.notices) with input as inp
}

test_payment_deadline_and_advance if {
	o6_10.payment_deadline == "2027-06-30" with input as base
	approx(o6_10.max_advance_payment_eur, 1101.6 * 0.75) with input as base
}

# ---------------------------------------------------------------------------
# Prämienausschlüsse je Schlag
# ---------------------------------------------------------------------------

test_ungrafted_fruit_no_premium_and_op_code_required if {
	ungrafted := json.patch(o1, [{"op": "replace", "path": "/permanent_crop/is_grafted_planting_material", "value": false}])
	inp := farm_input(2026, [v2, ungrafted])
	"O610-FRUIT-GRAFTED" in rule_ids(o6_10.premium_exclusions) with input as inp
	"O610-FRUIT-GRAFTED" in violations_for(inp, "O1")
	not o6_10.gross_parcel_premiums.O1 with input as inp
	coded := json.patch(ungrafted, [{"op": "replace", "path": "/oepul_codes", "value": ["OP"]}])
	inp2 := farm_input(2026, [v2, coded])
	not "O610-FRUIT-GRAFTED" in violations_for(inp2, "O1")
}

test_national_parks if {
	np := json.patch(v2, [{"op": "replace", "path": "/location/national_park", "value": "neusiedlersee"}])
	inp := farm_input(2026, [v1, np])
	"O610-GEN-NATIONAL-PARK" in rule_ids(o6_10.premium_exclusions) with input as inp
	np2 := json.patch(v2, [{"op": "replace", "path": "/location/national_park", "value": "kalkalpen"}])
	inp2 := farm_input(2026, [v1, np2])
	o6_10.gross_parcel_premiums.V2 with input as inp2
}

test_trial_area_and_measure_specific_op if {
	vf := json.patch(v2, [{"op": "replace", "path": "/oepul_codes", "value": ["VF"]}])
	inp := farm_input(2026, [v1, vf])
	"O610-GEN-TRIAL-AREAS" in rule_ids(o6_10.premium_exclusions) with input as inp
	opm := json.patch(v2, [{"op": "add", "path": "/op_excluded_measures", "value": ["10"]}])
	inp2 := farm_input(2026, [v1, opm])
	"O610-GEN-OP-MEASURE-SPECIFIC" in rule_ids(o6_10.premium_exclusions) with input as inp2
}

test_transfer_without_continuation if {
	tr := json.patch(v2, [{"op": "add", "path": "/transfer", "value": {"transferred_during_year": true, "successor_continues_until_year_end": false}}])
	inp := farm_input(2026, [v1, tr])
	"O610-GEN-TRANSFER-MIDYEAR" in rule_ids(o6_10.premium_exclusions) with input as inp
	"O610-GEN-TRANSFER-MIDYEAR" in violations_for(inp, "V2")
}

test_fruit_species_by_year if {
	mb := json.patch(o1, [{"op": "replace", "path": "/crop/crop_name", "value": "Maulbeere"}])
	inp24 := farm_input(2024, [v2, mb])
	"O610-GEN-DEF-FRUIT" in rule_ids(o6_10.ineligible_parcels) with input as inp24
	inp25 := farm_input(2025, [v2, mb])
	not "O610-GEN-DEF-FRUIT" in rule_ids(o6_10.ineligible_parcels) with input as inp25
	o6_10.gross_parcel_premiums.O1 with input as inp25
}

test_minimum_management_not_met if {
	mm := json.patch(v2, [{"op": "add", "path": "/permanent_crop/minimum_management", "value": {"properly_planted": true, "annual_care": true, "harvest_and_removal": false}}])
	inp := farm_input(2026, [v1, mm])
	"O610-GEN-MIN-MGMT-PERMANENT" in rule_ids(o6_10.premium_exclusions) with input as inp
}

# ---------------------------------------------------------------------------
# Begrünungsverpflichtungen
# ---------------------------------------------------------------------------

greening_variant(pid, ctype, patch) := json.patch(parcel(pid, ctype, 1.0, 10), [{"op": "replace", "path": "/operations/inter_row_greening", "value": object.union(full_greening, patch)}])

test_terrace_exempt_from_greening if {
	t := json.patch(t1, [{"op": "replace", "path": "/operations/inter_row_greening", "value": {}}])
	inp := farm_input(2026, [v1, v2, t])
	count(violations_for(inp, "T1")) == 0
}

test_terrace_below_25_percent_treated_as_vine if {
	t := json.patch(parcel("T2", "vine_terrace", 1.0, 20), [{"op": "replace", "path": "/operations/inter_row_greening", "value": {}}])
	inp := farm_input(2026, [t])
	o6_10.effective_crop_type(t) == "vine"
	"O610-GREEN-ALLYEAR-FULL" in violations_for(inp, "T2")
}

test_too_few_mixture_partners if {
	inp := farm_input(2026, [greening_variant("G", "vine", {"winter_hardy_mixture_partners": 2})])
	"O610-GREEN-ESTABLISHMENT" in violations_for(inp, "G")
}

test_existing_greening_retained_ok if {
	inp := farm_input(2026, [greening_variant("G", "vine", {"establishment_method": "existing_greening_retained", "winter_hardy_mixture_partners": null})])
	count(violations_for(inp, "G")) == 0
}

test_invalid_covers if {
	inp := farm_input(2026, [greening_variant("M", "vine", {"cover_type": "organic_mulch"}), greening_variant("S", "fruit", {"cover_type": "self_greening"})])
	"O610-GREEN-INVALID-MULCH" in violations_for(inp, "M")
	"O610-GREEN-INVALID-SELF" in violations_for(inp, "S")
}

test_cereal_rules if {
	inp := farm_input(2025, [
		greening_variant("C1", "vine", {"contains_pure_cereal_or_maize": true}),
		greening_variant("C2", "vine", {"contains_pure_cereal_or_maize": true, "is_green_cut_rye_variety": true}),
		greening_variant("C3", "vine", {"max_cereal_maize_share_percent": 60}),
		greening_variant("C4", "vine", {"max_cereal_maize_share_percent": 60, "cereal_is_oat_or_spring_barley_nurse_crop": true}),
		greening_variant("C5", "vine", {"max_cereal_maize_share_percent": 50}),
	])
	"O610-GREEN-INVALID-CEREAL-MAIZE" in violations_for(inp, "C1")
	count(violations_for(inp, "C2")) == 0
	"O610-GREEN-CEREAL-SHARE-50" in violations_for(inp, "C3")
	count(violations_for(inp, "C4")) == 0
	count(violations_for(inp, "C5")) == 0
}

test_drought_2026_relief if {
	patch := {"full_coverage_all_inter_rows_all_year": false, "max_cereal_maize_share_percent": 70, "properly_established": true}
	inp26 := farm_input(2026, [greening_variant("D", "vine", patch)])
	count(violations_for(inp26, "D")) == 0
	"D" in o6_10.drought_2026_relief_parcels with input as inp26
	"O610-2026-DROUGHT-GREENING" in rule_ids(o6_10.notices) with input as inp26
	inp25 := farm_input(2025, [greening_variant("D", "vine", patch)])
	"O610-GREEN-ALLYEAR-FULL" in violations_for(inp25, "D")
	"O610-GREEN-CEREAL-SHARE-50" in violations_for(inp25, "D")
	not_proper := farm_input(2026, [greening_variant("D", "vine", object.union(patch, {"properly_established": false}))])
	"O610-GREEN-ALLYEAR-FULL" in violations_for(not_proper, "D")
}

test_open_strip_widths if {
	inp := farm_input(2026, [
		greening_variant("W", "vine", {"open_strip_width_cm": 90}),
		greening_variant("F", "fruit", {"open_strip_width_cm": 90}),
		greening_variant("H", "hop", {"open_strip_width_cm": 110}),
	])
	"O610-GREEN-OPEN-STRIP" in violations_for(inp, "W")
	count(violations_for(inp, "F")) == 0
	"O610-GREEN-OPEN-STRIP" in violations_for(inp, "H")
}

test_alternative_planting_60_percent if {
	dr55 := json.patch(greening_variant("D1", "fruit", {"open_strip_width_cm": 150, "greened_share_of_total_area_percent": 55}), [{"op": "replace", "path": "/permanent_crop/planting_system", "value": "double_row"}])
	dr65 := json.patch(greening_variant("D2", "fruit", {"open_strip_width_cm": 150, "greened_share_of_total_area_percent": 65}), [{"op": "replace", "path": "/permanent_crop/planting_system", "value": "double_row"}])
	inp := farm_input(2026, [dr55, dr65])
	"O610-GREEN-60PCT-ALT-SYSTEMS" in violations_for(inp, "D1")
	count(violations_for(inp, "D2")) == 0
}

test_reestablishment_within_8_weeks if {
	ok := greening_variant("R1", "vine", {"events": [{"event_type": "break", "date": "2026-06-01"}, {"event_type": "establishment", "date": "2026-07-20"}]})
	late := greening_variant("R2", "vine", {"events": [{"event_type": "break", "date": "2026-06-01"}, {"event_type": "establishment", "date": "2026-08-10"}]})
	oct := greening_variant("R3", "vine", {"events": [{"event_type": "break", "date": "2026-09-01"}, {"event_type": "establishment", "date": "2026-10-05"}]})
	inp := farm_input(2026, [ok, late, oct])
	count(violations_for(inp, "R1")) == 0
	"O610-TILLAGE-REESTABLISH-8W" in violations_for(inp, "R2")
	"O610-TILLAGE-REESTABLISH-8W" in violations_for(inp, "R3")
}

test_non_destructive_tillage_allowed if {
	inp := farm_input(2026, [greening_variant("L", "vine", {"events": [{"event_type": "subsoil_loosening", "date": "2026-04-01"}, {"event_type": "other_tillage", "date": "2026-05-01", "destroys_greening": false}]})])
	count(violations_for(inp, "L")) == 0
}

test_clearing_and_replanting_window if {
	cl := greening_variant("K1", "vine", {"events": [
		{"event_type": "clearing", "date": "2026-03-01"},
		{"event_type": "replanting", "date": "2026-05-01"},
		{"event_type": "establishment", "date": "2026-06-15"},
	]})
	inp := farm_input(2026, [cl])
	count(violations_for(inp, "K1")) == 0
}

test_late_clearing_until_may_15 if {
	pending := greening_variant("K2", "vine", {"events": [{"event_type": "clearing", "date": "2026-09-20"}]})
	inp := farm_input(2026, [pending])
	count(violations_for(inp, "K2")) == 0
	count(o6_10.pending_reestablishments) == 1 with input as inp
	missed := greening_variant("K3", "vine", {"events": [{"event_type": "clearing", "date": "2025-09-20"}, {"event_type": "establishment", "date": "2026-05-20"}]})
	inp2 := farm_input(2026, [missed])
	"O610-TILLAGE-LATE-CLEARING" in violations_for(inp2, "K3")
	kept := greening_variant("K4", "vine", {"events": [{"event_type": "clearing", "date": "2025-09-20"}, {"event_type": "establishment", "date": "2026-05-15"}]})
	inp3 := farm_input(2026, [kept])
	count(violations_for(inp3, "K4")) == 0
}

test_renewal_only_once_per_year if {
	two := greening_variant("E", "vine", {"events": [
		{"event_type": "break", "date": "2026-03-01"},
		{"event_type": "establishment", "date": "2026-03-20"},
		{"event_type": "break", "date": "2026-06-01"},
		{"event_type": "establishment", "date": "2026-06-20"},
	]})
	inp := farm_input(2026, [two])
	"O610-TILLAGE-RENEWAL-ONCE" in violations_for(inp, "E")
}

test_use_ban_grazing_psm_and_removal if {
	inp := farm_input(2026, [
		greening_variant("U1", "vine", {"growth_used_or_removed": true}),
		greening_variant("U2", "fruit", {"grazing": "sheep_extensive"}),
		greening_variant("U3", "fruit", {"grazing": "other"}),
		greening_variant("U4", "vine", {"psm_applied_on_greening": true}),
		greening_variant("U5", "vine", {"removal_method": "chemical"}),
		greening_variant("U6", "fruit", {"grazing": "poultry_temporary"}),
	])
	"O610-USE-BAN" in violations_for(inp, "U1")
	count(violations_for(inp, "U2")) == 0
	"O610-USE-GRAZING-EXC" in violations_for(inp, "U3")
	"O610-PSM-BAN-GREENING" in violations_for(inp, "U4")
	"O610-REMOVAL-MECHANICAL" in violations_for(inp, "U5")
	count(violations_for(inp, "U6")) == 0
}

test_greening_records_incomplete if {
	inp := with_farm(base, "/documentation/o6_10_greening_record_items", ["farm", "plot_size"])
	"O610-REC-GREENING" in rule_ids(o6_10.farm_obligation_violations) with input as inp
	o6_10.missing_greening_record_items == {"field_piece_number_and_name", "clearing_replanting_date", "greening_establishment_and_break_dates"} with input as inp
}

# ---------------------------------------------------------------------------
# Kombinationen (Anhang L) und Hinweise
# ---------------------------------------------------------------------------

test_annex_l_combinations if {
	o6_10.combinable_with_10 == {"1A", "1B", "2", "11", "12"}
	comb := json.patch(v2, [{"op": "replace", "path": "/oepul_measures", "value": ["10", "12", "16"]}])
	inp := farm_input(2026, [v1, comb])
	conflicts := {c.measure | some c in o6_10.combination_conflicts with input as inp}
	conflicts == {"16"}
	some n in o6_10.combination_notes with input as inp
	n.measure == "12"
	contains(n.footnotes[0], "Einsatz von Organismen")
	"O610-GEN-COMBINATION-CORRECTION" in rule_ids(o6_10.notices) with input as inp
}

test_measure_is_one_year_without_area_access_restriction if {
	o6_10.measure_is_one_year
	not o6_10.area_access_restricted
	o6_10.supplement_application_possible with input as farm_input(2028, [v1])
}

test_control_refusal_blocks_payment if {
	inp := with_farm(base, "/farm/oepul/o6_10/control_refused", true)
	o6_10.payable_total_eur == 0 with input as inp
	"O610-GEN-CONTROL-REFUSAL" in rule_ids(o6_10.notices) with input as inp
}

test_missing_multiple_application_no_payment if {
	inp := with_farm(base, "/farm/oepul/o6_10/multiple_application_submitted", false)
	o6_10.payable_total_eur == 0 with input as inp
}

test_decision_document_complete if {
	d := o6_10.decision with input as base
	d.measure == "o6_10"
	d.contract_status == "valid"
	d.eop.granted == true
	approx(d.premium.payable_total_eur, 1101.6)
}
