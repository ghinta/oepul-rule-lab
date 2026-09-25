package o6_7.farm_test

import data.o6_7
import data.o6_7.eligibility
import data.o6_7.exit
import data.o6_7.fixtures
import data.o6_7.general
import data.o6_7.premium
import data.o6_7.records

ids(inp) := r if {
	r := o6_7.violation_rule_ids with input as inp
}

set_farm(patch) := object.union(fixtures.base, {"farm": patch})

# --- Zugang / Mindestteilnahme ---------------------------------------------

test_min_arable_area_1_5_ha_met if {
	inp := fixtures.farm(2025, [fixtures.good_parcel("A", 1.5)])
	eligibility.access_ok with input as inp
}

test_below_1_5_ha_no_access_and_no_premium if {
	inp := fixtures.farm(2025, [fixtures.good_parcel("A", 1.49)])
	not eligibility.access_ok with input as inp
	"O67-ACCESS-MIN-ARABLE" in ids(inp)
	premium.premium_eur == 0 with input as inp
	exit.contract_lapsed_in_year with input as inp
}

# --- Förderwerbende ------------------------------------------------------

test_territorial_authority_allowed_for_immergruen if {
	inp := set_farm({"applicant": {"legal_form": "territorial_authority", "public_body_share_percent": 100, "is_active_farmer": true}})
	not "O67-APPLICANT-PUBLIC-SHARE" in ids(inp)
	not "O67-APPLICANT-TYPE" in ids(inp)
	premium.measure_valid with input as inp
}

test_territorial_exception_applies_for_measure_7 if {
	eligibility.territorial_exception_applies with input as fixtures.base
}

test_unknown_applicant_type_rejected if {
	inp := set_farm({"applicant": {"legal_form": "foundation_abroad", "is_active_farmer": true}})
	"O67-APPLICANT-TYPE" in ids(inp)
	not premium.measure_valid with input as inp
}

test_not_active_farmer_rejected if {
	inp := set_farm({"applicant": {"legal_form": "natural_person", "is_active_farmer": false}})
	"O67-APPLICANT-ACTIVE-FARMER" in ids(inp)
}

# --- Antrag ------------------------------------------------------------------

test_application_after_31_december_is_late if {
	inp := set_farm({"oepul": {"o6_7": {"application_date": "2024-01-02", "first_contract_year": 2024}}})
	"O67-APPLICATION-DEADLINE" in ids(inp)
}

test_last_entry_2027_allowed if {
	inp := object.union(
		fixtures.farm(2027, [fixtures.good_parcel("A", 10)]),
		{"farm": {"oepul": {"o6_7": {"application_date": "2026-12-31", "first_contract_year": 2027}}}},
	)
	not "O67-LAST-ENTRY" in ids(inp)
	not "O67-APPLICATION-DEADLINE" in ids(inp)
}

test_entry_2028_not_allowed if {
	inp := object.union(
		fixtures.farm(2028, [fixtures.good_parcel("A", 10)]),
		{"farm": {"oepul": {"o6_7": {"application_date": "2027-12-15", "first_contract_year": 2028}}}},
	)
	"O67-LAST-ENTRY" in ids(inp)
}

test_first_oepul_year_min_farm_size if {
	inp := object.union(
		fixtures.farm(2025, [fixtures.good_parcel("A", 1.5)]),
		{"farm": {"oepul": {"first_participation_year": 2025}}, "land": {"total_area_ha": 1.4}},
	)
	"O67-GEN-FARM-MIN-SIZE" in ids(inp)
}

# --- Kombination -------------------------------------------------------------

test_not_combinable_with_zwischenfruchtanbau if {
	inp := set_farm({"oepul": {"participations": [{"measure_code": "7"}, {"measure_code": "6"}]}})
	"O67-COMB-NOT-WITH-6" in ids(inp)
	not premium.measure_valid with input as inp
}

test_grundwasserschutz_requires_6_or_7 if {
	inp := set_farm({"oepul": {"participations": [{"measure_code": "16"}]}})
	"O67-COMB-PREREQUISITE-FOR-8-16" in ids(inp)
	with7 := set_farm({"oepul": {"participations": [{"measure_code": "16"}, {"measure_code": "7"}]}})
	not "O67-COMB-PREREQUISITE-FOR-8-16" in ids(with7)
}

test_erosion_mulch_requires_6_or_7 if {
	inp := set_farm({"oepul": {"participations": [{"measure_code": "8", "options": ["mulch_direct_strip_till"]}]}})
	"O67-COMB-PREREQUISITE-FOR-8-16" in ids(inp)
}

# --- Prämie ------------------------------------------------------------------

test_premium_guaranteed_minimum_70_eur if {
	premium.premium_eur == 1400 with input as fixtures.base
	premium.premium_min_eur == 1400 with input as fixtures.base
	premium.premium_max_eur == 1800 with input as fixtures.base
}

test_premium_uses_announced_rate_within_band if {
	inp := set_farm({"oepul": {"o6_7": {"premium_rate_eur_per_ha": 80}}})
	premium.premium_eur == 1600 with input as inp
}

test_modulation_220_ha_factor_99_09_percent if {
	f := premium.modulation_factor_for(220)
	round(f * 10000) == 9909
}

test_modulation_brackets if {
	premium.modulation_factor_for(200) == 1
	round(premium.modulation_factor_for(300) * 10000) == 9667
	round(premium.modulation_factor_for(1200) * 10000) == round(((((200 + 90) + 595) + 150) / 1200) * 10000)
}

parcel_with(extra) := object.union(fixtures.good_parcel("X", 5), extra)

test_nat_parcel_no_premium_but_in_base if {
	inp := fixtures.farm(2025, [fixtures.good_parcel("A", 10), parcel_with({"oepul_codes": ["NAT"]})])
	premium.eligible_area_ha == 10 with input as inp
	"not_combinable_with_18" in premium.no_premium_reasons.X with input as inp
}

test_grundwasserschutz_parcel_combinable if {
	inp := fixtures.farm(2025, [fixtures.good_parcel("A", 10), parcel_with({"oepul_measures": ["16", "1A", "8"]})])
	premium.eligible_area_ha == 15 with input as inp
}

test_k20_parcel_no_premium if {
	inp := fixtures.farm(2025, [fixtures.good_parcel("A", 10), parcel_with({"oepul_codes": ["K20"]})])
	"k20_not_combinable" in premium.no_premium_reasons.X with input as inp
}

test_op_code_parcel_no_premium if {
	inp := fixtures.farm(2025, [fixtures.good_parcel("A", 10), parcel_with({"oepul_codes": ["OP"]})])
	premium.eligible_area_ha == 10 with input as inp
}

test_national_park_neusiedlersee_no_premium if {
	inp := fixtures.farm(2025, [fixtures.good_parcel("A", 10), parcel_with({"national_park": "Neusiedlersee"})])
	"national_park_no_premium" in premium.no_premium_reasons.X with input as inp
}

test_other_national_park_premium_possible if {
	inp := fixtures.farm(2025, [fixtures.good_parcel("A", 10), parcel_with({"national_park": "Thayatal"})])
	premium.eligible_area_ha == 15 with input as inp
}

test_gloez8_npf_2024_not_eligible if {
	inp := fixtures.farm(2024, [fixtures.good_parcel("A", 10), parcel_with({"gloez8_npf_variant": "Variante 3 NPF"})])
	"gloez8_npf_catch_crop_2024" in premium.no_premium_reasons.X with input as inp
}

test_green_fallow_no_premium_unless_div if {
	fallow := {"parcel_id": "X", "area_ha": 2, "land_use": "arable", "usage_category": "green_fallow", "greening": {"segments": [{"segment_id": "gb", "kind": "green_fallow", "start_date": "2023-01-01"}]}}
	inp := fixtures.farm(2025, [fixtures.good_parcel("A", 10), fallow])
	premium.eligible_area_ha == 10 with input as inp
	div := fixtures.farm(2025, [fixtures.good_parcel("A", 10), object.union(fallow, {"oepul_codes": ["DIV"]})])
	premium.eligible_area_ha == 12 with input as div
}

test_small_premium_may_be_withheld if {
	inp := fixtures.farm(2025, [object.union(fixtures.good_parcel("A", 1.5), {"oepul_codes": []}), parcel_with({"oepul_codes": ["OP"]})])
	i2 := object.union(inp, {"land": {"parcels": [
		object.union(fixtures.good_parcel("A", 1.5), {"oepul_codes": ["OP"]}),
		fixtures.good_parcel("B", 0.5),
	]}})
	premium.premium_eur == 35 with input as i2
	premium.below_min_payout with input as i2
}

test_excluded_from_payment_cap if {
	premium.excluded_from_payment_cap with input as fixtures.base
}

# --- Ausstieg / Wechsel --------------------------------------------------------

test_withdrawal_during_year_invalidates_measure if {
	inp := set_farm({"oepul": {"o6_7": {"withdrawal_date": "2025-03-01"}}})
	"O67-EXIT-DURING-YEAR" in ids(inp)
	premium.premium_eur == 0 with input as inp
}

test_withdrawal_blocks_erosion_mulch_option if {
	inp := set_farm({"oepul": {
		"o6_7": {"withdrawal_date": "2025-03-01"},
		"participations": [{"measure_code": "7"}, {"measure_code": "8", "options": ["mulch_direct_strip_till"]}],
	}})
	"O67-EXIT-ES-ACKER" in ids(inp)
}

test_switch_to_6_by_end_2026_valid if {
	inp := set_farm({"oepul": {"o6_7": {"switch_to_6_application_date": "2026-12-31"}}})
	exit.switch_to_6_valid with input as inp
	late := set_farm({"oepul": {"o6_7": {"switch_to_6_application_date": "2027-01-02"}}})
	"O67-SWITCH-TO-6" in ids(late)
}

test_reentry_after_lapse_requires_new_application if {
	inp := set_farm({"oepul": {"o6_7": {"contract_lapsed_year": 2024, "application_date": "2023-12-15"}}})
	"O67-CONTRACT-LAPSE-REAPPLY" in ids(inp)
	ok := set_farm({"oepul": {"o6_7": {"contract_lapsed_year": 2024, "application_date": "2024-11-30"}}})
	not "O67-CONTRACT-LAPSE-REAPPLY" in ids(ok)
}

test_auto_renewal_without_withdrawal if {
	exit.auto_renewed_next_year with input as fixtures.base
}

test_double_use_field_fodder_blocks_erosion_mulch_on_parcel if {
	x := object.union(
		fixtures.parcel("X", 5, [fixtures.wheat, {"segment_id": "kg", "kind": "catch_crop", "declared_in_mfa": true, "double_use_field_fodder": true, "start_date": "2025-08-01"}]),
		{"es_acker_mulch_direct_strip_till": true},
	)
	inp := fixtures.farm(2025, [fixtures.good_parcel("A", 10), x])
	"O67-FIELD-FODDER-DOUBLE-USE" in ids(inp)
}

# --- Allgemeine Bedingungen -------------------------------------------------------

test_harvest_below_85_percent_requires_op if {
	x := parcel_with({"harvested_share": 0.5})
	inp := fixtures.farm(2025, [fixtures.good_parcel("A", 10), x])
	"O67-GEN-HARVEST-OBLIGATION" in ids(inp)
	"harvest_obligation_not_met" in premium.no_premium_reasons.X with input as inp
}

drought_farm(state, district) := object.union(
	fixtures.farm(2026, [
		fixtures.parcel("A", 10, [
			{"segment_id": "ww", "kind": "main_crop", "start_date": "2025-10-10", "end_date": "2026-07-15"},
			object.union(fixtures.good_catch_crop, {"start_date": "2026-07-25", "end_date": "2027-02-20"}),
		]),
		object.union(
			fixtures.parcel("X", 5, [
				{"segment_id": "ww", "kind": "main_crop", "start_date": "2025-10-10", "end_date": "2026-07-15"},
				object.union(fixtures.good_catch_crop, {"start_date": "2026-07-25", "end_date": "2027-02-20"}),
			]),
			{"harvested_share": 0, "no_harvestable_crop_due_to_drought": true},
		),
	]),
	{"farm": {"region": {"federal_state": state, "district": district}}},
)

test_drought_2026_burgenland_harvest_exempt if {
	not "O67-GEN-HARVEST-OBLIGATION" in ids(drought_farm("Burgenland", "Neusiedl am See"))
}

test_drought_2026_styria_extension_weiz_exempt if {
	not "O67-GEN-HARVEST-OBLIGATION" in ids(drought_farm("Steiermark", "Weiz"))
}

test_drought_2026_styria_liezen_not_exempt if {
	"O67-GEN-HARVEST-OBLIGATION" in ids(drought_farm("Steiermark", "Liezen"))
}

test_transfer_without_continuation_requires_op if {
	x := parcel_with({"transfer": {"transferred_during_year": true, "successor_continues_until_year_end": false}})
	inp := fixtures.farm(2025, [fixtures.good_parcel("A", 10), x])
	"O67-GEN-COMMITMENT-PERIOD" in ids(inp)
}

test_warning_replaced_by_one_percent_retention_from_2027 if {
	inp := fixtures.farm(2027, [fixtures.good_parcel("A", 10)])
	general.sanction_step_reduction("warning") == 0.01 with input as inp
	general.sanction_step_reduction("warning") == 0 with input as fixtures.base
	general.sanction_step_reduction("reduction_25") == 0.25 with input as fixtures.base
}

test_control_refusal_rejects_application if {
	inp := set_farm({"oepul": {"control_refused": true}})
	"O67-GEN-CONTROL-ACCESS" in ids(inp)
	not premium.measure_valid with input as inp
}

# --- Aufzeichnungen / Mehrfachantrag ---------------------------------------------

test_missing_field_records_violation if {
	inp := object.union(fixtures.base, {"documentation": {"field_records_complete": false}})
	"O67-RECORDS" in ids(inp)
}

test_missing_parcel_record_event_violation if {
	x := parcel_with({"greening": {"records": {"catch_crop_break": false}}})
	inp := fixtures.farm(2025, [fixtures.good_parcel("A", 10), x])
	some v in records.violations with input as inp
	v.event == "catch_crop_break"
}

test_undeclared_main_crop_violation if {
	x := fixtures.parcel("X", 5, [object.union(fixtures.wheat, {"declared_in_mfa": false}), fixtures.good_catch_crop])
	inp := fixtures.farm(2025, [fixtures.good_parcel("A", 10), x])
	"O67-MFA-MAIN-CROPS" in ids(inp)
}
