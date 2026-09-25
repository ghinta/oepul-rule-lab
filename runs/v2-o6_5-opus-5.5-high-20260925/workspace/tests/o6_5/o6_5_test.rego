package oepul.o6_5_test

import data.oepul.o6_5

# ---------------------------------------------------------------------------
# Test-Fixtures
# ---------------------------------------------------------------------------

confirmed := {"status": "confirmed", "date": "2026-01-20"}

cow := {
	"animal_id": "COW1",
	"animal_category": "kuh",
	"breed": "Original Braunvieh",
	"is_purebred": true,
	"herdbook_registered": true,
	"approved_breeding_program": true,
	"regular_breeding_use": true,
	"purebred_mating_only": true,
	"first_offspring_date": "2024-02-10",
	"milk_recording": true,
	"kept_in_austria": true,
	"on_farm_from": "2020-05-01",
	"breeding_org_confirmation": confirmed,
	"departure": {"date": null},
}

ewe := {
	"animal_id": "EWE1",
	"animal_category": "mutterschaf",
	"breed": "Braunes Bergschaf",
	"is_purebred": true,
	"herdbook_registered": true,
	"approved_breeding_program": true,
	"regular_breeding_use": true,
	"purebred_mating_only": true,
	"first_offspring_date": "2024-03-01",
	"kept_in_austria": true,
	"applied_in_mfa": true,
	"on_farm_from": "2022-01-01",
	"breeding_org_confirmation": confirmed,
	"departure": {"date": null},
}

ram := {
	"animal_id": "RAM1",
	"animal_category": "zuchtwidder",
	"breed": "Braunes Bergschaf",
	"is_purebred": true,
	"herdbook_registered": true,
	"approved_breeding_program": true,
	"regular_breeding_use": true,
	"birth_date": "2024-01-15",
	"breeding_use_in_year": true,
	"kept_in_austria": true,
	"applied_in_mfa": true,
	"on_farm_from": "2024-06-01",
	"breeding_org_confirmation": confirmed,
	"departure": {"date": null},
}

mare := {
	"animal_id": "MARE1",
	"animal_category": "stute",
	"breed": "Noriker",
	"identification": "040001234567890",
	"equine_database_and_vis_reported": true,
	"ueln_in_application": true,
	"is_purebred": true,
	"herdbook_registered": true,
	"approved_breeding_program": true,
	"regular_breeding_use": true,
	"purebred_mating_only": true,
	"first_offspring_date": "2021-05-10",
	"last_foaling_date": "2024-04-20",
	"kept_in_austria": true,
	"applied_in_mfa": true,
	"on_farm_from": "2019-01-01",
	"breeding_org_confirmation": confirmed,
	"departure": {"date": null},
}

stallion := {
	"animal_id": "STAL1",
	"animal_category": "zuchthengst",
	"breed": "Noriker",
	"identification": "040001234567891",
	"equine_database_and_vis_reported": true,
	"ueln_in_application": true,
	"is_purebred": true,
	"herdbook_registered": true,
	"approved_breeding_program": true,
	"regular_breeding_use": true,
	"birth_date": "2022-04-01",
	"kept_in_austria": true,
	"applied_in_mfa": true,
	"on_farm_from": "2023-01-01",
	"breeding_org_confirmation": confirmed,
	"departure": {"date": null},
}

sow := {
	"animal_id": "SOW1",
	"animal_category": "zuchtsau",
	"breed": "Mangaliza",
	"is_purebred": true,
	"herdbook_registered": true,
	"approved_breeding_program": true,
	"regular_breeding_use": true,
	"purebred_mating_only": true,
	"first_purebred_farrowing_date": "2024-09-01",
	"litters_total": 4,
	"litters_purebred": 2,
	"kept_in_austria": true,
	"applied_in_mfa": true,
	"on_farm_from": "2023-01-01",
	"breeding_org_confirmation": confirmed,
	"departure": {"date": null},
}

bull := {
	"animal_id": "BULL1",
	"animal_category": "zuchtstier",
	"breed": "Tiroler Grauvieh",
	"is_purebred": true,
	"herdbook_registered": true,
	"approved_breeding_program": true,
	"regular_breeding_use": true,
	"birth_date": "2024-06-01",
	"breeding_use_in_year": true,
	"kept_in_austria": true,
	"on_farm_from": "2024-06-01",
	"breeding_org_confirmation": confirmed,
	"departure": {"date": null},
}

farm_input(yr, animal_list) := {
	"farm": {
		"year": yr,
		"applicant": {
			"legal_form": "natural_person",
			"is_public_body": false,
			"public_body_share_percent": 0,
			"is_active_farmer": true,
			"performs_agricultural_activity": true,
		},
	},
	"land": {"total_area_ha": 40, "protected_cultivation_area_ha": 0},
	"documentation": {"inspection_refused": false, "vis_reports_complete": true},
	"oepul_participation": {
		"first_oepul_year": 2023,
		"o6_5": {
			"participation_start_year": 2023,
			"measure_application_date": "2022-12-15",
			"deregistration_date": null,
			"content_violation_stage": "none",
		},
	},
	"livestock": {"endangered_breed_animals": animal_list},
}

with_participation(inp, patch) := object.union(inp, {"oepul_participation": {"o6_5": object.union(inp.oepul_participation.o6_5, patch)}})

with_applicant(inp, patch) := object.union(inp, {"farm": {"applicant": object.union(inp.farm.applicant, patch)}})

failures(inp, id) := r if {
	r := o6_5.animal_results[id].failures with input as inp
}

finding_ids(inp) := {f.rule_id | some f in o6_5.findings with input as inp}

# ---------------------------------------------------------------------------
# Prämien (O6_5-PREM-*)
# ---------------------------------------------------------------------------

test_cow_stage_b_with_gep_and_mlk_2025 if {
	r := o6_5.animal_results.COW1 with input as farm_input(2025, [cow])
	r.eligible == true
	r.premium_eur == 442.8
}

test_cow_rates_2023 if {
	c := object.union(cow, {"first_offspring_date": "2022-02-10", "breeding_org_confirmation": {"status": "confirmed", "date": "2024-02-10"}})
	r := o6_5.animal_results.COW1 with input as farm_input(2023, [c])
	r.eligible == true
	r.premium_eur == 410
}

test_cow_stage_a_without_mlk if {
	c := object.union(cow, {"breed": "Murbodner", "milk_recording": false})
	r := o6_5.animal_results.COW1 with input as farm_input(2025, [c])
	r.premium_eur == 248.4
}

test_ewe_stage_a_without_gep if {
	r := o6_5.animal_results.EWE1 with input as farm_input(2025, [ewe])
	r.premium_eur == 54
}

test_bull_stage_a_with_gep if {
	r := o6_5.animal_results.BULL1 with input as farm_input(2025, [bull])
	r.eligible == true
	r.premium_eur == 475.2
}

test_mare_noriker_premium if {
	r := o6_5.animal_results.MARE1 with input as farm_input(2025, [mare])
	r.eligible == true
	r.premium_eur == 248.4
}

test_sow_stage_b_premium if {
	r := o6_5.animal_results.SOW1 with input as farm_input(2025, [sow])
	r.eligible == true
	r.premium_eur == 183.6
}

test_breed_table_complete if {
	count(data.o6_5.breeds) == 27
	count(data.o6_5.premium_rates) == 20
}

# ---------------------------------------------------------------------------
# Förderbare Tiere (O6_5-ELIG-*)
# ---------------------------------------------------------------------------

test_breed_not_listed if {
	c := object.union(cow, {"breed": "Fleckvieh"})
	"O6_5-ELIG-BREED-LIST" in failures(farm_input(2025, [c]), "COW1")
}

test_breed_species_mismatch if {
	c := object.union(cow, {"breed": "Noriker"})
	"O6_5-ELIG-BREED-LIST" in failures(farm_input(2025, [c]), "COW1")
}

test_not_purebred if {
	c := object.union(cow, {"is_purebred": false})
	"O6_5-ELIG-PUREBRED-HERDBOOK" in failures(farm_input(2025, [c]), "COW1")
}

test_female_crossbreeding_not_allowed if {
	c := object.union(cow, {"purebred_mating_only": false})
	"O6_5-ELIG-FEMALE-PUREBRED-MATING" in failures(farm_input(2025, [c]), "COW1")
}

test_cow_calved_after_stichtag if {
	c := object.union(cow, {"first_offspring_date": "2025-04-02"})
	"O6_5-ELIG-FIRST-BIRTH-STICHTAG" in failures(farm_input(2025, [c]), "COW1")
}

test_cow_calved_on_stichtag if {
	c := object.union(cow, {"first_offspring_date": "2025-04-01"})
	count(failures(farm_input(2025, [c]), "COW1")) == 0
}

test_mare_foaled_by_may_31 if {
	m := object.union(mare, {"first_offspring_date": "2025-05-31", "last_foaling_date": "2025-05-31"})
	count(failures(farm_input(2025, [m]), "MARE1")) == 0
}

test_mare_foaled_after_may_31 if {
	m := object.union(mare, {"first_offspring_date": "2025-06-01", "last_foaling_date": "2025-06-01"})
	"O6_5-ELIG-MARE-FOALING" in failures(farm_input(2025, [m]), "MARE1")
}

test_mare_refoaling_overdue if {
	m := object.union(mare, {"last_foaling_date": "2021-11-30"})
	"O6_5-ELIG-MARE-REFOALING" in failures(farm_input(2025, [m]), "MARE1")
}

test_mare_refoaling_exactly_3_5_years if {
	m := object.union(mare, {"last_foaling_date": "2021-11-30"})
	count(failures(farm_input(2025, [m]), "MARE1")) == 1
	m2 := object.union(mare, {"last_foaling_date": "2021-12-01"})
	count(failures(farm_input(2025, [m2]), "MARE1")) == 0
}

test_sow_litter_share_too_low if {
	s := object.union(sow, {"litters_total": 3, "litters_purebred": 1})
	"O6_5-ELIG-SOW-LITTER-SHARE" in failures(farm_input(2025, [s]), "SOW1")
}

test_sow_without_purebred_farrowing if {
	s := object.union(sow, {"first_purebred_farrowing_date": null})
	"O6_5-ELIG-SOW-PUREBRED-FARROWING" in failures(farm_input(2025, [s]), "SOW1")
}

test_bull_too_young if {
	b := object.union(bull, {"birth_date": "2024-06-02"})
	"O6_5-ELIG-MALE-MIN-AGE" in failures(farm_input(2025, [b]), "BULL1")
}

test_bull_exactly_ten_months if {
	b := object.union(bull, {"birth_date": "2024-06-01"})
	count(failures(farm_input(2025, [b]), "BULL1")) == 0
}

test_buck_five_months_ok if {
	buck := object.union(ram, {"animal_id": "BUCK1", "animal_category": "zuchtbock", "breed": "Pinzgauer Ziege", "birth_date": "2024-11-01"})
	count(failures(farm_input(2025, [buck]), "BUCK1")) == 0
}

test_ram_five_months_too_young if {
	r := object.union(ram, {"birth_date": "2024-11-01"})
	"O6_5-ELIG-MALE-MIN-AGE" in failures(farm_input(2025, [r]), "RAM1")
}

test_male_without_annual_breeding_use if {
	r := object.union(ram, {"breeding_use_in_year": false})
	"O6_5-ELIG-MALE-ANNUAL-BREEDING" in failures(farm_input(2025, [r]), "RAM1")
}

test_male_approval_year_exempt if {
	r := object.union(ram, {"breeding_use_in_year": false, "breeding_approval_year": 2025})
	count(failures(farm_input(2025, [r]), "RAM1")) == 0
}

test_stallion_too_young if {
	s := object.union(stallion, {"birth_date": "2023-06-01"})
	"O6_5-ELIG-STALLION-MIN-AGE" in failures(farm_input(2025, [s]), "STAL1")
}

test_old_stallion_needs_offspring if {
	s := object.union(stallion, {"birth_date": "2018-05-01", "live_offspring_registered_last_2_years": false})
	"O6_5-ELIG-STALLION-OFFSPRING" in failures(farm_input(2025, [s]), "STAL1")
}

test_old_stallion_with_offspring if {
	s := object.union(stallion, {"birth_date": "2018-05-01", "live_offspring_registered_last_2_years": true})
	count(failures(farm_input(2025, [s]), "STAL1")) == 0
}

test_animal_kept_abroad if {
	c := object.union(cow, {"kept_in_austria": false})
	"O6_5-GEN-ANIMALS-IN-AUSTRIA" in failures(farm_input(2025, [c]), "COW1")
}

test_breeding_org_rejection if {
	c := object.union(cow, {"breeding_org_confirmation": {"status": "rejected", "date": "2026-01-10"}})
	"O6_5-OBL-BREEDING-ORG-CONFIRMATION" in failures(farm_input(2025, [c]), "COW1")
}

test_breeding_org_confirmation_after_feb_10 if {
	c := object.union(cow, {"breeding_org_confirmation": {"status": "confirmed", "date": "2026-02-11"}})
	"O6_5-OBL-BREEDING-ORG-CONFIRMATION" in failures(farm_input(2025, [c]), "COW1")
}

test_sheep_not_applied_in_mfa if {
	e := object.union(ewe, {"applied_in_mfa": false})
	"O6_5-APP-INDIVIDUAL-MFA" in failures(farm_input(2025, [e]), "EWE1")
}

test_cattle_need_no_individual_application if {
	not "O6_5-APP-INDIVIDUAL-MFA" in failures(farm_input(2025, [cow]), "COW1")
}

test_animal_arrived_after_stichtag if {
	c := object.union(cow, {"on_farm_from": "2025-04-02"})
	"O6_5-OBL-HOLDING-PERIOD" in failures(farm_input(2025, [c]), "COW1")
}

# ---------------------------------------------------------------------------
# Haltedauer, Abgang, Nachbesetzung (O6_5-OBL-*)
# ---------------------------------------------------------------------------

departed_ewe(date) := object.union(ewe, {"departure": {"date": date, "reason": "death", "reported_date": date}})

replacement(id, of, date, extra) := object.union(object.union(ewe, {"animal_id": id, "replaces_animal_id": of, "replacement_date": date, "replacement_reported_date": date, "applied_in_mfa": false, "on_farm_from": date}), extra)

test_departure_without_replacement if {
	inp := farm_input(2025, [departed_ewe("2025-06-01")])
	"O6_5-OBL-REPLACEMENT-5-WEEKS" in failures(inp, "EWE1")
	o6_5.decision.minimum_participation_met == false with input as inp
	o6_5.decision.contract_lapses == true with input as inp
	o6_5.decision.payout_eur == 0 with input as inp
}

test_replacement_within_five_weeks if {
	inp := farm_input(2025, [departed_ewe("2025-06-01"), replacement("EWE2", "EWE1", "2025-07-06", {})])
	r := o6_5.animal_results.EWE1 with input as inp
	r.eligible == true
	r.replaced_by == {"EWE2"}
}

test_replacement_after_five_weeks if {
	inp := farm_input(2025, [departed_ewe("2025-06-01"), replacement("EWE2", "EWE1", "2025-07-07", {})])
	"O6_5-OBL-REPLACEMENT-5-WEEKS" in failures(inp, "EWE1")
}

test_replacement_other_breed if {
	inp := farm_input(2025, [departed_ewe("2025-06-01"), replacement("EWE2", "EWE1", "2025-06-10", {"breed": "Waldschaf"})])
	"O6_5-OBL-REPLACEMENT-5-WEEKS" in failures(inp, "EWE1")
}

test_replacement_deadline_crosses_year_end if {
	o6_5.replacement_deadline(departed_ewe("2023-12-20")) == "2024-01-24"
}

test_female_replaced_by_male_pays_lower if {
	inp := farm_input(2025, [departed_ewe("2025-06-01"), object.union(ram, {"animal_id": "RAM2", "replaces_animal_id": "EWE1", "replacement_date": "2025-06-10", "replacement_reported_date": "2025-06-12", "applied_in_mfa": false, "on_farm_from": "2025-06-10"})])
	r := o6_5.animal_results.EWE1 with input as inp
	r.eligible == true
	r.premium_eur == 54
}

test_mlk_cow_replaced_by_non_mlk_pays_lower if {
	c := object.union(cow, {"departure": {"date": "2025-05-01", "reason": "slaughter"}})
	c2 := object.union(cow, {"animal_id": "COW2", "replaces_animal_id": "COW1", "replacement_date": "2025-05-20", "milk_recording": false, "on_farm_from": "2025-05-20", "departure": {"date": null}})
	r := o6_5.animal_results.COW1 with input as farm_input(2025, [c, c2])
	r.premium_eur == 356.4
}

test_second_level_replacement_chain if {
	e2 := object.union(replacement("EWE2", "EWE1", "2025-06-10", {}), {"departure": {"date": "2025-08-01", "reason": "sale", "reported_date": "2025-08-02"}})
	e3 := replacement("EWE3", "EWE2", "2025-08-20", {})
	r := o6_5.animal_results.EWE1 with input as farm_input(2025, [departed_ewe("2025-06-01"), e2, e3])
	r.eligible == true
	r.replaced_by == {"EWE2", "EWE3"}
}

test_2026_departure_from_september_keeps_premium if {
	inp := farm_input(2026, [departed_ewe("2026-09-01")])
	r := o6_5.animal_results.EWE1 with input as inp
	r.eligible == true
	o6_5.holding_end_md == "08-31" with input as inp
}

test_2026_departure_in_august_needs_replacement if {
	"O6_5-OBL-REPLACEMENT-5-WEEKS" in failures(farm_input(2026, [departed_ewe("2026-08-31")]), "EWE1")
}

test_2025_departure_in_september_needs_replacement if {
	"O6_5-OBL-REPLACEMENT-5-WEEKS" in failures(farm_input(2025, [departed_ewe("2025-09-01")]), "EWE1")
}

test_cattle_transfer_after_september_30 if {
	c := object.union(cow, {"departure": {"date": "2025-10-01", "reason": "sale", "exported_slaughtered_or_died_before_next_jan1": false}})
	count(failures(farm_input(2025, [c]), "COW1")) == 0
}

test_cattle_transfer_on_september_30_not_permitted if {
	c := object.union(cow, {"departure": {"date": "2025-09-30", "reason": "sale", "exported_slaughtered_or_died_before_next_jan1": false}})
	"O6_5-OBL-REPLACEMENT-5-WEEKS" in failures(farm_input(2025, [c]), "COW1")
}

test_cattle_transfer_then_slaughtered_before_jan1 if {
	c := object.union(cow, {"departure": {"date": "2025-10-15", "reason": "sale", "exported_slaughtered_or_died_before_next_jan1": true}})
	"O6_5-OBL-REPLACEMENT-5-WEEKS" in failures(farm_input(2025, [c]), "COW1")
}

test_breeding_station_six_months_ok if {
	e := object.union(ewe, {"temporary_absences": [{"type": "breeding_station", "start_date": "2025-04-10", "end_date": "2025-10-10", "reported_before_transfer": true, "documented": true}]})
	count(failures(farm_input(2025, [e]), "EWE1")) == 0
}

test_breeding_station_longer_than_six_months if {
	e := object.union(ewe, {"temporary_absences": [{"type": "breeding_station", "start_date": "2025-04-10", "end_date": "2025-10-11", "reported_before_transfer": true, "documented": true}]})
	"O6_5-OBL-TRANSFER-LIMITS" in failures(farm_input(2025, [e]), "EWE1")
}

test_male_breeding_use_three_months if {
	r := object.union(ram, {"temporary_absences": [{"type": "male_breeding_use_other_farm", "start_date": "2025-09-01", "end_date": "2025-12-01", "reported_before_transfer": true, "documented": true}]})
	count(failures(farm_input(2025, [r]), "RAM1")) == 0
}

test_female_breeding_use_other_farm_not_permitted if {
	e := object.union(ewe, {"temporary_absences": [{"type": "male_breeding_use_other_farm", "start_date": "2025-09-01", "end_date": "2025-10-01", "reported_before_transfer": true, "documented": true}]})
	"O6_5-OBL-TRANSFER-LIMITS" in failures(farm_input(2025, [e]), "EWE1")
}

test_short_documented_absence if {
	h := object.union(mare, {"temporary_absences": [{"type": "sport_event", "start_date": "2025-07-01", "end_date": "2025-07-11", "reported_before_transfer": false, "documented": true}]})
	count(failures(farm_input(2025, [h]), "MARE1")) == 0
	not "O6_5-REP-PRIOR-TRANSFER-REPORT" in finding_ids(farm_input(2025, [h]))
}

test_absence_longer_than_ten_days if {
	h := object.union(mare, {"temporary_absences": [{"type": "sport_event", "start_date": "2025-07-01", "end_date": "2025-07-12", "reported_before_transfer": false, "documented": true}]})
	"O6_5-OBL-TRANSFER-LIMITS" in failures(farm_input(2025, [h]), "MARE1")
}

test_alpine_pasture_is_no_departure if {
	e := object.union(ewe, {"temporary_absences": [{"type": "alpine_or_common_pasture", "start_date": "2025-06-15", "end_date": "2025-09-15", "control_retained_or_care_only": true}]})
	count(failures(farm_input(2025, [e]), "EWE1")) == 0
}

# ---------------------------------------------------------------------------
# Meldepflichten (O6_5-REP-*)
# ---------------------------------------------------------------------------

test_prior_transfer_report_missing if {
	e := object.union(ewe, {"temporary_absences": [{"type": "breeding_station", "start_date": "2025-04-10", "end_date": "2025-06-10", "reported_before_transfer": false, "documented": true}]})
	"O6_5-REP-PRIOR-TRANSFER-REPORT" in finding_ids(farm_input(2025, [e]))
}

test_late_departure_report if {
	e := object.union(ewe, {"departure": {"date": "2025-10-01", "reason": "sale", "reported_date": "2025-10-09"}})
	"O6_5-REP-DEPARTURE-7-DAYS" in finding_ids(farm_input(2025, [e]))
}

test_departure_report_on_day_seven if {
	e := object.union(ewe, {"departure": {"date": "2025-10-01", "reason": "sale", "reported_date": "2025-10-08"}})
	not "O6_5-REP-DEPARTURE-7-DAYS" in finding_ids(farm_input(2025, [e]))
}

test_cattle_departure_needs_no_ama_report if {
	c := object.union(cow, {"departure": {"date": "2025-10-01", "reason": "sale", "exported_slaughtered_or_died_before_next_jan1": false}})
	not "O6_5-REP-DEPARTURE-7-DAYS" in finding_ids(farm_input(2025, [c]))
}

test_2026_departure_after_august_still_reportable if {
	e := object.union(ewe, {"departure": {"date": "2026-09-10", "reason": "sale", "reported_date": null}})
	"O6_5-REP-DEPARTURE-7-DAYS" in finding_ids(farm_input(2026, [e]))
}

test_late_replacement_report if {
	r := object.union(replacement("EWE2", "EWE1", "2025-06-10", {}), {"replacement_reported_date": "2025-06-18"})
	"O6_5-REP-REPLACEMENT-7-DAYS" in finding_ids(farm_input(2025, [departed_ewe("2025-06-01"), r]))
}

test_2026_replacement_report_waived_after_august if {
	r := object.union(replacement("EWE2", "EWE1", "2026-09-02", {}), {"replacement_reported_date": null})
	not "O6_5-REP-REPLACEMENT-7-DAYS" in finding_ids(farm_input(2026, [departed_ewe("2026-08-30"), r]))
}

test_2025_replacement_report_not_waived if {
	r := object.union(replacement("EWE2", "EWE1", "2025-09-02", {}), {"replacement_reported_date": null})
	"O6_5-REP-REPLACEMENT-7-DAYS" in finding_ids(farm_input(2025, [departed_ewe("2025-08-30"), r]))
}

test_horse_without_ueln_in_application if {
	h := object.union(mare, {"ueln_in_application": false})
	"O6_5-APP-HORSE-UELN" in finding_ids(farm_input(2025, [h]))
}

test_vis_reporting_for_sheep if {
	inp := object.union(farm_input(2025, [ewe]), {"documentation": {"inspection_refused": false, "vis_reports_complete": false}})
	"O6_5-OBL-VIS-SHEEP-GOATS" in finding_ids(inp)
}

# ---------------------------------------------------------------------------
# Förderwerbende Person, Antrag, Vertrag (O6_5-GEN-*, O6_5-APP-*, O6_5-CON-*)
# ---------------------------------------------------------------------------

test_base_farm_meets_access_requirements if {
	o6_5.decision.access_requirements_met == true with input as farm_input(2025, [cow])
	o6_5.decision.contract_renews_next_year == true with input as farm_input(2025, [cow])
}

test_public_body_excluded if {
	inp := with_applicant(farm_input(2025, [cow]), {"is_public_body": true})
	"O6_5-GEN-PUBLIC-BODY-EXCLUDED" in o6_5.applicant_failures with input as inp
	o6_5.payout_eur == 0 with input as inp
}

test_public_body_share_above_25_percent if {
	inp := with_applicant(farm_input(2025, [cow]), {"legal_form": "legal_person", "public_body_share_percent": 26})
	"O6_5-GEN-PUBLIC-BODY-EXCLUDED" in o6_5.applicant_failures with input as inp
}

test_public_body_share_25_percent_ok if {
	inp := with_applicant(farm_input(2025, [cow]), {"legal_form": "legal_person", "public_body_share_percent": 25})
	count(o6_5.applicant_failures) == 0 with input as inp
}

test_not_active_farmer if {
	inp := with_applicant(farm_input(2025, [cow]), {"is_active_farmer": false})
	"O6_5-GEN-ACTIVE-FARMER" in o6_5.applicant_failures with input as inp
}

test_min_farm_size_first_year if {
	base := object.union(farm_input(2025, [cow]), {"land": {"total_area_ha": 1.2, "protected_cultivation_area_ha": 0}})
	inp := object.union(base, {"oepul_participation": {"first_oepul_year": 2025}})
	"O6_5-GEN-MIN-FARM-SIZE" in o6_5.applicant_failures with input as inp
}

test_min_farm_size_protected_cultivation if {
	base := object.union(farm_input(2025, [cow]), {"land": {"total_area_ha": 0.6, "protected_cultivation_area_ha": 0.5}})
	inp := object.union(base, {"oepul_participation": {"first_oepul_year": 2025}})
	not "O6_5-GEN-MIN-FARM-SIZE" in o6_5.applicant_failures with input as inp
}

test_min_farm_size_not_required_after_first_year if {
	inp := object.union(farm_input(2025, [cow]), {"land": {"total_area_ha": 0.3, "protected_cultivation_area_ha": 0}})
	not "O6_5-GEN-MIN-FARM-SIZE" in o6_5.applicant_failures with input as inp
}

test_inspection_refused if {
	inp := object.union(farm_input(2025, [cow]), {"documentation": {"inspection_refused": true}})
	"O6_5-CTRL-REFUSAL" in o6_5.applicant_failures with input as inp
}

test_inspection_refused_force_majeure if {
	inp := object.union(farm_input(2025, [cow]), {"documentation": {"inspection_refused": true, "inspection_refusal_force_majeure": true}})
	not "O6_5-CTRL-REFUSAL" in o6_5.applicant_failures with input as inp
}

test_application_after_december_31 if {
	inp := with_participation(farm_input(2025, [cow]), {"measure_application_date": "2023-01-05"})
	"O6_5-APP-DEADLINE" in o6_5.contract_failures with input as inp
}

test_last_entry_2027 if {
	ok := with_participation(farm_input(2027, [cow]), {"participation_start_year": 2027, "measure_application_date": "2026-12-31"})
	count(o6_5.contract_failures) == 0 with input as ok
	late := with_participation(farm_input(2028, [cow]), {"participation_start_year": 2028, "measure_application_date": "2027-12-20"})
	"O6_5-APP-LAST-ENTRY" in o6_5.contract_failures with input as late
}

test_deregistration_during_year if {
	inp := with_participation(farm_input(2025, [cow]), {"deregistration_date": "2025-11-15"})
	"O6_5-EXIT-DEREGISTRATION-TIMING" in o6_5.contract_failures with input as inp
	o6_5.payout_eur == 0 with input as inp
}

test_deregistration_in_following_year if {
	inp := with_participation(farm_input(2025, [cow]), {"deregistration_date": "2026-01-02"})
	count(o6_5.contract_failures) == 0 with input as inp
	o6_5.decision.contract_renews_next_year == false with input as inp
}

test_deregistration_after_inspection_notice if {
	inp := with_participation(farm_input(2025, [cow]), {"deregistration_date": "2025-09-10", "inspection_notice_date": "2025-09-01"})
	not "O6_5-EXIT-DEREGISTRATION-TIMING" in o6_5.contract_failures with input as inp
	"O6_5-GEN-EXIT-UNTIL-INSPECTION" in finding_ids(inp)
}

test_takeover_only_in_individual_cases if {
	bad := with_participation(farm_input(2025, [cow]), {"takeover": {"is_takeover": true, "reason": "other", "animals_and_land_from_same_predecessor": true}})
	"O6_5-GEN-TAKEOVER" in o6_5.contract_failures with input as bad
	good := with_participation(farm_input(2025, [cow]), {"takeover": {"is_takeover": true, "reason": "betriebsteilung", "animals_and_land_from_same_predecessor": true}})
	not "O6_5-GEN-TAKEOVER" in o6_5.contract_failures with input as good
}

test_reentry_after_lapse if {
	bad := with_participation(farm_input(2025, [cow]), {"previous_year_contract_lapsed": true})
	"O6_5-CON-REENTRY-AFTER-LAPSE" in o6_5.contract_failures with input as bad
	late := with_participation(farm_input(2025, [cow]), {"previous_year_contract_lapsed": true, "late_reentry_correction": true, "written_request_submitted": true})
	not "O6_5-CON-REENTRY-AFTER-LAPSE" in o6_5.contract_failures with input as late
	timely := with_participation(farm_input(2025, [cow]), {"previous_year_contract_lapsed": true, "reapplication_date": "2024-12-30"})
	not "O6_5-CON-REENTRY-AFTER-LAPSE" in o6_5.contract_failures with input as timely
}

# ---------------------------------------------------------------------------
# Kürzungen, Modulation, Auszahlung (O6_5-GEN-*)
# ---------------------------------------------------------------------------

test_modulation_220_ha if {
	inp := object.union(farm_input(2025, [cow]), {"land": {"total_area_ha": 220}})
	f := o6_5.modulation_factor with input as inp
	round(f * 10000) == 9909
}

test_modulation_1500_ha if {
	inp := object.union(farm_input(2025, [cow]), {"land": {"total_area_ha": 1500}})
	f := o6_5.modulation_factor with input as inp
	round(f * 10000) == 8400
}

test_no_modulation_up_to_200_ha if {
	inp := object.union(farm_input(2025, [cow]), {"land": {"total_area_ha": 200}})
	o6_5.modulation_factor == 1 with input as inp
}

test_content_reduction_5_percent if {
	inp := with_participation(farm_input(2025, [cow]), {"content_violation_stage": "5"})
	o6_5.payout_eur == 420.66 with input as inp
}

test_warning_without_reduction_before_2027 if {
	inp := with_participation(farm_input(2026, [cow]), {"content_violation_stage": "warning"})
	o6_5.reduction_percent == 0 with input as inp
}

test_warning_becomes_retention_from_2027 if {
	inp := with_participation(farm_input(2027, [cow]), {"content_violation_stage": "warning"})
	o6_5.reduction_percent == 1 with input as inp
}

test_exclusion_after_two_full_reductions if {
	inp := with_participation(farm_input(2025, [cow]), {"content_violation_stage": "100", "full_reductions_in_contract_period": 2})
	o6_5.reduction_percent == 100 with input as inp
	o6_5.payout_eur == 0 with input as inp
}

test_small_payout_may_be_waived if {
	e := object.union(ewe, {"breed": "Tiroler Steinschaf"})
	inp := farm_input(2025, [e])
	o6_5.payout_eur == 54 with input as inp
	not o6_5.payout_may_be_waived with input as inp
	inp2 := with_participation(inp, {"content_violation_stage": "10"})
	o6_5.payout_eur == 48.6 with input as inp2
	o6_5.payout_may_be_waived with input as inp2
}

test_advance_payment_and_deadline if {
	inp := farm_input(2025, [cow])
	o6_5.max_advance_payment_eur == 332.1 with input as inp
	o6_5.payment_deadline == "2026-06-30" with input as inp
}

test_total_over_multiple_animals if {
	inp := farm_input(2025, [cow, ewe, bull])
	o6_5.premium_total_eur == 972 with input as inp
	o6_5.decision.eligible_animal_ids == {"COW1", "EWE1", "BULL1"} with input as inp
}
