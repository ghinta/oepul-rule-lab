package oepul.o6_24_test

import data.oepul.o6_24
import rego.v1

# --- Aufzeichnungen ---

test_records_not_kept_at_farm if {
	inp := patched([{"op": "replace", "path": "/documentation/wrrl_records/kept_at_farm", "value": false}])
	"Betriebsbuch nicht am Betrieb aufbewahrt" in o6_24.farm_record_violations with input as inp
}

test_records_annual_field_missing if {
	inp := patched([{"op": "replace", "path": "/documentation/wrrl_records/annual_fields_recorded", "value": ["total_agricultural_area"]}])
	"jährliche Betriebsdaten fehlen: manure_n_produced" in o6_24.farm_record_violations with input as inp
}

test_records_retention_seven_years if {
	inp := patched([{"op": "replace", "path": "/documentation/wrrl_records/retention_years", "value": 4}])
	"Aufbewahrungsdauer unter sieben Jahren" in o6_24.farm_record_violations with input as inp
}

test_records_entry_within_one_week if {
	inp := patched([{"op": "replace", "path": "/land/parcels/0/wrrl/n_applications/0/recorded_date", "value": "2026-03-10"}])
	o6_24.late_entries.P1 == {"2026-03-01"} with input as inp
}

test_plot_record_missing_amount if {
	inp := patched([{"op": "remove", "path": "/land/parcels/1/wrrl/n_applications/1/amount"}])
	"Düngung 2026-06-01: amount" in o6_24.plot_record_missing.P2 with input as inp
}

# --- Basisanforderungen GWSP ---

test_more_than_100kg_within_three_weeks if {
	inp := patched([{"op": "replace", "path": "/land/parcels/1/wrrl/n_applications/1/date", "value": "2026-04-25"}])
	o6_24.n_over_100_within_3_weeks.P2 == {"2026-04-10"} with input as inp
}

test_fertilization_more_than_10_days_before_sowing if {
	inp := patched([{"op": "replace", "path": "/land/parcels/1/wrrl/n_applications/0/date", "value": "2026-04-01"}])
	o6_24.fertilization_too_early_before_sowing.P2 == {"2026-04-01"} with input as inp
	manure := patched([
		{"op": "replace", "path": "/land/parcels/1/wrrl/n_applications/0/date", "value": "2026-04-01"},
		{"op": "replace", "path": "/land/parcels/1/wrrl/n_applications/0/fertilizer_type", "value": "solid_manure_hoof_claw"},
	])
	not o6_24.fertilization_too_early_before_sowing.P2 with input as manure
}

test_wrg_175_threshold_without_green_cover if {
	inp := patched([{"op": "add", "path": "/land/parcels/3/wrrl/n_applications/0/n_field_kg_per_ha", "value": 180}])
	o6_24.wrg_permit_required.P4 == {"n_field": 180, "threshold": 175} with input as inp
	covered := patched([
		{"op": "add", "path": "/land/parcels/3/wrrl/n_applications/0/n_field_kg_per_ha", "value": 180},
		{"op": "add", "path": "/land/parcels/3/wrrl/green_cover_or_n_consuming_rotation", "value": true},
	])
	not o6_24.wrg_permit_required.P4 with input as covered
}

test_widmungsgebiet2_permits if {
	inp := patched([{"op": "add", "path": "/farm/gwsp_widmungsgebiet2_activities", "value": [
		{"key": "clearing_over_1ha", "value": 1.5, "has_permit": false},
		{"key": "storage_hazardous_substances_over_5000kg", "value": 3000, "has_permit": false},
		{"key": "solid_manure_or_silage_on_unpaved", "has_permit": false},
	]}])
	o6_24.wg2_permit_missing == {"clearing_over_1ha", "solid_manure_or_silage_on_unpaved"} with input as inp
}

# --- Gemüsebau ---

test_vegetable_rotation_cruciferous_max_two_in_four_years if {
	inp := patched([{"op": "add", "path": "/land/parcels/3/wrrl/crop_history", "value": [
		{"year": 2024, "crop_name": "Kohlrabi", "plant_family": "Kreuzblütler"},
		{"year": 2025, "crop_name": "Brokkoli", "plant_family": "Kreuzblütler"},
		{"year": 2026, "crop_name": "Karfiol", "plant_family": "Kreuzblütler"},
	]}])
	"Kreuzblütler" in o6_24.rotation_violations.P4 with input as inp
}

test_vegetable_rotation_asparagus_excluded_from_liliaceae if {
	inp := patched([{"op": "add", "path": "/land/parcels/3/wrrl/crop_history", "value": [
		{"year": 2025, "crop_name": "Spargel", "plant_family": "Liliengewächse"},
		{"year": 2026, "crop_name": "Zwiebel", "plant_family": "Liliengewächse"},
	]}])
	not o6_24.rotation_violations.P4 with input as inp
}

test_nmin_missing_for_vegetables if {
	inp := patched([{"op": "replace", "path": "/land/parcels/3/wrrl/nmin_test_date", "value": "2026-04-19"}])
	o6_24.nmin_missing.P4 with input as inp
	not o6_24.nmin_missing.P4 with input as base_input
}

test_irrigation_water_test_visual_strip_insufficient if {
	inp := patched([
		{"op": "add", "path": "/land/parcels/3/wrrl/irrigation_water_sources", "value": ["W1", "W2"]},
		{"op": "add", "path": "/documentation/irrigation_water_nitrate_tests", "value": [
			{"water_source_id": "W1", "test_date": "2024-05-01", "method": "authorized_body"},
			{"water_source_id": "W2", "test_date": "2026-05-01", "method": "visual_test_strip"},
		]},
	])
	o6_24.irrigation_water_test_missing.P4 == {"W2"} with input as inp
}

test_table_potato_soil_open_all_year if {
	inp := patched([
		{"op": "replace", "path": "/land/parcels/1/wrrl/gwsp_crop", "value": "Speisekartoffel, Industriekartoffel"},
		{"op": "add", "path": "/land/parcels/1/wrrl/soil_open_all_year", "value": true},
	])
	o6_24.potato_soil_open_all_year.P2 with input as inp
}

# --- Allgemeine Teilnahmebedingungen ---

test_public_body_not_eligible if {
	inp := patched([{"op": "replace", "path": "/farm/applicant/legal_form", "value": "public_body"}])
	not o6_24.applicant_eligible with input as inp
	not o6_24.participation_eligible with input as inp
}

test_legal_person_public_share_max_25 if {
	ok := patched([{"op": "replace", "path": "/farm/applicant", "value": {"legal_form": "legal_person", "public_body_share_percent": 25, "is_active_farmer": true}}])
	o6_24.applicant_eligible with input as ok
	bad := patched([{"op": "replace", "path": "/farm/applicant", "value": {"legal_form": "legal_person", "public_body_share_percent": 30, "is_active_farmer": true}}])
	not o6_24.applicant_eligible with input as bad
}

test_minimum_farm_size_first_year_only if {
	inp := patched([
		{"op": "replace", "path": "/farm/oepul/first_participation_year", "value": 2026},
		{"op": "replace", "path": "/land/total_area_ha", "value": 1.4},
	])
	not o6_24.minimum_farm_size_met with input as inp
	later := patched([{"op": "replace", "path": "/land/total_area_ha", "value": 1.4}])
	o6_24.minimum_farm_size_met with input as later
}

test_combination_not_allowed_with_naturschutz if {
	inp := patched([{"op": "replace", "path": "/land/parcels/0/oepul/measures", "value": ["24", "18"]}])
	o6_24.combination_conflicts.P1 == {"18"} with input as inp
	not "P1" in o6_24.eligible_parcels with input as inp
}

test_combination_allowed_with_groundwater_protection if {
	inp := patched([{"op": "replace", "path": "/land/parcels/0/oepul/measures", "value": ["24", "16", "6", "1B"]}])
	not o6_24.combination_conflicts.P1 with input as inp
}

test_harvest_obligation_violation_makes_parcel_ineligible if {
	inp := patched([
		{"op": "replace", "path": "/farm/region/district", "value": "Murtal"},
		{"op": "add", "path": "/land/parcels/1/management", "value": {
			"harvested_share_percent": 0,
			"usually_harvested_late_summer_or_autumn": true,
			"no_harvestable_stand_due_to_drought": true,
		}},
	])
	not "P2" in o6_24.eligible_parcels with input as inp
	o6_24.individual_force_majeure_request_required.P2 with input as inp
}

test_drought_2026_leibnitz_exemption if {
	inp := patched([{"op": "add", "path": "/land/parcels/1/management", "value": {
		"harvested_share_percent": 0,
		"usually_harvested_late_summer_or_autumn": true,
		"no_harvestable_stand_due_to_drought": true,
	}}])
	o6_24.drought_harvest_exemption.P2 with input as inp
	"P2" in o6_24.eligible_parcels with input as inp
}

test_drought_exemption_only_2026 if {
	inp := patched([
		{"op": "replace", "path": "/farm/year", "value": 2025},
		{"op": "add", "path": "/land/parcels/1/management", "value": {
			"harvested_share_percent": 0,
			"usually_harvested_late_summer_or_autumn": true,
			"no_harvestable_stand_due_to_drought": true,
		}},
	])
	not o6_24.drought_harvest_exemption.P2 with input as inp
}

test_national_park_does_not_exclude_o6_24 if {
	inp := patched([{"op": "add", "path": "/land/parcels/0/in_national_park", "value": true}])
	"P1" in o6_24.eligible_parcels with input as inp
	not o6_24.national_park_excludes_premium
}

test_agreement_overlap_requires_op if {
	inp := patched([{"op": "add", "path": "/land/parcels/0/oepul/public_funding_agreement_overlap", "value": true}])
	not "P1" in o6_24.eligible_parcels with input as inp
}

test_force_majeure_three_weeks if {
	inp := patched([{"op": "add", "path": "/farm/oepul/force_majeure_cases", "value": [
		{"able_to_notify_date": "2026-05-01", "notified_date": "2026-05-22"},
		{"able_to_notify_date": "2026-06-01", "notified_date": "2026-06-30"},
	]}])
	count(o6_24.force_majeure_late) == 1 with input as inp
}

test_takeover_deadline if {
	inp := patched([{"op": "add", "path": "/farm/oepul/o6_24/takeover", "value": {"request_date": "2026-04-15", "taking_over_farm_previously_participating": false, "expansion_share": 0.4}}])
	o6_24.takeover_allowed with input as inp
	late := patched([{"op": "add", "path": "/farm/oepul/o6_24/takeover", "value": {"request_date": "2026-04-16", "taking_over_farm_previously_participating": false, "expansion_share": 0.4}}])
	not o6_24.takeover_allowed with input as late
}

# --- Modulation, Sanktionen, Obergrenzen ---

test_modulation_220ha_example if {
	inp := patched([{"op": "replace", "path": "/land/total_area_ha", "value": 220}])
	f := o6_24.modulation_factor with input as inp
	abs(f - 0.990909) < 0.00001
}

test_modulation_full_below_200 if {
	o6_24.modulation_factor == 1 with input as base_input
}

test_content_sanctions_cumulate_and_escalate if {
	inp := patched([{"op": "add", "path": "/farm/oepul/o6_24/content_findings", "value": [
		{"obligation": "n_limit", "base_level": 2},
		{"obligation": "records", "base_level": 1, "previous_occurrences_same_obligation": 2},
	]}])

	# 5 % + (2 % -> zwei Stufen höher = 10 %) = 15 %
	o6_24.content_reduction_percent == 15 with input as inp
	o6_24.premium_after_modulation == 114.75 with input as inp
}

test_warning_becomes_one_percent_from_2027 if {
	inp := patched([
		{"op": "replace", "path": "/farm/year", "value": 2027},
		{"op": "add", "path": "/farm/oepul/o6_24/content_findings", "value": [{"obligation": "records", "base_level": 0}]},
	])
	o6_24.content_reduction_percent == 1 with input as inp
	inp26 := patched([{"op": "add", "path": "/farm/oepul/o6_24/content_findings", "value": [{"obligation": "records", "base_level": 0}]}])
	o6_24.content_reduction_percent == 0 with input as inp26
}

test_second_100pct_reduction_excludes if {
	inp := patched([
		{"op": "add", "path": "/farm/oepul/o6_24/content_findings", "value": [{"obligation": "n_limit", "base_level": 6}]},
		{"op": "add", "path": "/farm/oepul/o6_24/previous_100pct_reductions_in_period", "value": 1},
	])
	o6_24.measure_exclusion with input as inp
	o6_24.premium_after_modulation == 0 with input as inp
}

test_area_over_declaration_sanction if {
	inp := patched([
		{"op": "add", "path": "/farm/oepul/o6_24/declared_area_ha", "value": 2.5},
		{"op": "add", "path": "/farm/oepul/o6_24/determined_area_ha", "value": 2.3},
	])
	o6_24.area_sanction_applies with input as inp
	a := o6_24.calculation_area_ha with input as inp
	abs(a - 2.0) < 0.000001
}

test_area_small_deviation_no_sanction if {
	inp := patched([
		{"op": "add", "path": "/farm/oepul/o6_24/declared_area_ha", "value": 2.5},
		{"op": "add", "path": "/farm/oepul/o6_24/determined_area_ha", "value": 2.45},
	])
	not o6_24.area_sanction_applies with input as inp
	o6_24.calculation_area_ha == 2.45 with input as inp
}

test_payment_up_to_50_eur_may_be_waived if {
	inp := patched([{"op": "replace", "path": "/land/parcels/1/oepul/codes", "value": ["OP"]}])
	o6_24.premium_after_modulation == 54 with input as inp
	not o6_24.payment_may_be_waived with input as inp
	small := patched([
		{"op": "replace", "path": "/land/parcels/1/oepul/codes", "value": ["OP"]},
		{"op": "replace", "path": "/land/parcels/0/area_ha", "value": 0.9},
		{"op": "replace", "path": "/land/parcels/0/wrrl/fertilization_classes", "value": [{"class": "D", "area_ha": 0.9}]},
	])
	o6_24.payment_may_be_waived with input as small
}

test_area_payment_cap if {
	inp := patched([{"op": "add", "path": "/land/parcels/0/oepul/other_area_payments_eur_per_ha", "value": 1260}])
	o6_24.cap_exceeded_parcels.P1 == 1314 with input as inp
}

test_controls_obstructed_no_premium if {
	inp := patched([{"op": "add", "path": "/farm/oepul/controls_obstructed", "value": true}])
	o6_24.premium_after_modulation == 0 with input as inp
}

test_decision_summary if {
	d := o6_24.decision with input as base_input
	d.measure == "o6_24"
	d.participation_eligible == true
	d.eligible_area_ha == 2.5
	d.premium_after_modulation_eur == 135
}
