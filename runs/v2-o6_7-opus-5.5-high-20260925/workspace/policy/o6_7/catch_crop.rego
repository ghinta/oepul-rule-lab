# Zwischenfrüchte: Gültigkeit (Anrechenbarkeit als Zwischenfrucht) und
# Förderverpflichtungen während des Begrünungszeitraums (Kapitel 5.2 Merkblatt,
# SRL Punkt 2.7 „Für Zwischenfrüchte gelten folgende Bedingungen“).
package o6_7.catch_crop

import data.o6_7.lib

cc := lib.params.catch_crop

# Bei Untersaaten gilt die Ernte der Hauptfrucht als Anlagedatum.
effective_start(s) := s.undersown_host_harvest_date if {
	s.is_undersown == true
} else := s.start_date

start_year(s) := lib.year_of(effective_start(s))

start_day(s) := lib.day(effective_start(s))

# Eine im Mehrfachantrag beantragte Begrünung zählt als Hauptfrucht.
effective_kind(s) := "main_crop" if {
	s.kind == "catch_crop"
	s.declared_in_mfa == true
} else := s.kind

is_catch_crop(s) if effective_kind(s) == "catch_crop"

sown_by_mixture_cutoff(s) if start_day(s) <= lib.mmdd_day(start_year(s), cc.mixture_cutoff_mmdd)

# Ersteinstieg: Anlage vor Vertragsbeginn (1.1. des ersten Teilnahmejahres).
pre_contract(s) if {
	first := input.farm.oepul.o6_7.first_contract_year
	start_day(s) < lib.mmdd_day(first, "01-01")
}

mixture(s) := object.get(s, "mixture", {})

mixture_requirement_met(s) if {
	object.get(mixture(s), "partner_count", 0) >= cc.min_mixture_partners
	object.get(mixture(s), "plant_family_count", 0) >= cc.min_plant_families
}

# Vor 2025: ausschließlich winterhart; ab Antragsjahr 2025: überwiegend
# winterhart (abfrostende Komponenten unter 50 %).
winter_hardy_requirement_met(s) if {
	start_year(s) >= cc.mostly_winter_hardy_from_year
	object.get(mixture(s), "frost_killed_share", 1) < cc.max_frost_killed_share_from_2025_exclusive
}

winter_hardy_requirement_met(s) if {
	start_year(s) < cc.mostly_winter_hardy_from_year
	object.get(mixture(s), "frost_killed_share", 1) == 0
}

proper_sowing(s) if s.proper_sowing == true

# Dürre 2026: kein Beanstanden bei ordnungsgemäßer Anlage, wenn Feldaufgang
# keine Flächendeckung erreicht bzw. Ausfallgetreide die 50 %-Grenze überschreitet.
drought_2026_relief(s) if {
	start_year(s) == lib.params.drought_2026.year
	proper_sowing(s)
}

volunteer_cereal_drought_relief(s) if {
	drought_2026_relief(s)
	mixture(s).cereal_excess_from_volunteer == true
}

overwintering(s) if not s.end_date

overwintering(s) if lib.year_of(s.end_date) > start_year(s)

catch_crop_segments[key] := e if {
	some key, e in lib.segments
	is_catch_crop(e.seg)
}

# ---------------------------------------------------------------------------
# Anrechenbarkeit als Zwischenfrucht
# ---------------------------------------------------------------------------

invalid_reasons[key] contains "volunteer_only" if {
	some key, e in catch_crop_segments
	mixture(e.seg).is_volunteer_only == true
}

invalid_reasons[key] contains "cereal_maize_share_over_50_percent" if {
	some key, e in catch_crop_segments
	s := e.seg
	lib.approx_gt(object.get(mixture(s), "cereal_maize_share", 0), cc.max_cereal_maize_share)
	not mixture(s).green_rye_varieties_only == true
	not volunteer_cereal_drought_relief(s)
}

invalid_reasons[key] contains "sown_after_october_15" if {
	some key, e in catch_crop_segments
	s := e.seg
	not pre_contract(s)
	start_day(s) > lib.mmdd_day(start_year(s), cc.latest_sowing_mmdd)
}

invalid_reasons[key] contains "mixture_partners_insufficient" if {
	some key, e in catch_crop_segments
	s := e.seg
	not pre_contract(s)
	sown_by_mixture_cutoff(s)
	not mixture_requirement_met(s)
}

invalid_reasons[key] contains "not_winter_hardy_after_september_20" if {
	some key, e in catch_crop_segments
	s := e.seg
	not pre_contract(s)
	not sown_by_mixture_cutoff(s)
	not winter_hardy_requirement_met(s)
}

invalid_reasons[key] contains "pre_contract_mixture_not_compliant" if {
	some key, e in catch_crop_segments
	s := e.seg
	pre_contract(s)
	not mixture_requirement_met(s)
	not winter_hardy_requirement_met(s)
}

invalid_reasons[key] contains "minimum_duration_42_days_not_met" if {
	some key, e in catch_crop_segments
	s := e.seg
	s.end_date
	lib.day(s.end_date) - start_day(s) < cc.min_duration_days
}

invalid_reasons[key] contains "broken_before_february_15" if {
	some key, e in catch_crop_segments
	s := e.seg
	not sown_by_mixture_cutoff(s)
	s.end_date
	lib.day(s.end_date) < lib.mmdd_day(start_year(s) + 1, cc.earliest_break_after_late_sowing_mmdd)
}

invalid_reasons[key] contains "threshed" if {
	some key, e in catch_crop_segments
	e.seg.threshed == true
}

invalid_reasons[key] contains "threshed" if {
	some key, e in catch_crop_segments
	some op in object.get(e.seg, "operations", [])
	op.type == "threshing"
}

invalid_reasons[key] contains "no_full_coverage" if {
	some key, e in catch_crop_segments
	s := e.seg
	s.full_coverage_achieved == false
	not drought_2026_relief(s)
}

valid[key] if {
	some key, _ in catch_crop_segments
	not invalid_reasons[key]
}

# ---------------------------------------------------------------------------
# Förderverpflichtungen während des Begrünungszeitraums
# ---------------------------------------------------------------------------

in_period(s, d) if {
	lib.day(d) > start_day(s)
	not s.end_date
}

in_period(s, d) if {
	lib.day(d) > start_day(s)
	lib.day(d) < lib.day(s.end_date)
}

nitrate_ban_end_day(s) := lib.day(s.nitrate_ban_end_date) if {
	s.nitrate_ban_end_date
} else := lib.day(s.end_date) if {
	s.end_date
} else := lib.year_end_day + 366

mechanical_codes := {m.code | some m in lib.lists.mechanical_removal_methods}

mechanical_removal(s) if s.removal_method in mechanical_codes

care_before_nov_allowed(op) if {
	op.type == "chopping"
	op.ground_near == false
	op.problem_weed in lib.lists.problem_weeds_early_chopping
	op.evidence_kept == true
}

before_care_cutoff(s, op) if lib.day(op.date) <= lib.mmdd_day(start_year(s), cc.overwintering_care_ban_until_mmdd)

cover_or_regrowth_lost(op) if op.cover_maintained == false

cover_or_regrowth_lost(op) if op.regrowth_expected == false

violation(e, rule_id, code, d) := {
	"rule_id": rule_id,
	"parcel_id": e.parcel_id,
	"segment": object.get(e.seg, "segment_id", null),
	"code": code,
	"date": d,
}

violations contains violation(e, "O67-CC-MINERAL-N-BAN", "mineral_n_during_ban", d) if {
	some e in catch_crop_segments
	s := e.seg
	some d in object.get(s, "mineral_n_dates", [])
	lib.day(d) >= start_day(s)
	lib.day(d) <= nitrate_ban_end_day(s)
}

violations contains violation(e, "O67-CC-COMBINED-FERTILISATION", "combined_fertilisation_at_sowing", effective_start(e.seg)) if {
	some e in catch_crop_segments
	e.seg.combined_n_fertilisation_at_sowing == true
}

violations contains violation(e, "O67-CC-PSM-BAN", "psm_during_greening", d) if {
	some e in catch_crop_segments
	s := e.seg
	some d in object.get(s, "psm_dates", [])
	lib.day(d) >= start_day(s)
	not s.end_date
}

violations contains violation(e, "O67-CC-PSM-BAN", "psm_during_greening", d) if {
	some e in catch_crop_segments
	s := e.seg
	some d in object.get(s, "psm_dates", [])
	lib.day(d) >= start_day(s)
	lib.day(d) < lib.day(s.end_date)
}

violations contains violation(e, "O67-CC-PSM-AFTER-NON-MECHANICAL", "psm_before_following_sowing_without_mechanical_removal", d) if {
	some e in catch_crop_segments
	s := e.seg
	s.end_date
	not mechanical_removal(s)
	some d in object.get(s, "psm_dates", [])
	lib.day(d) >= lib.day(s.end_date)
	lib.day(d) < lib.day(s.following_main_crop_sowing_date)
}

violations contains violation(e, "O67-CC-MECHANICAL-REMOVAL", "no_mechanical_removal", e.seg.end_date) if {
	some e in catch_crop_segments
	e.seg.end_date
	not mechanical_removal(e.seg)
}

violations contains violation(e, "O67-CC-MECHANICAL-REMOVAL", "removal_requires_complete_frost_kill", s.end_date) if {
	some e in catch_crop_segments
	s := e.seg
	s.end_date
	some m in lib.lists.mechanical_removal_methods
	m.code == s.removal_method
	m.requires_fully_frost_killed
	not s.fully_frost_killed == true
}

violations contains violation(e, "O67-CC-MECHANICAL-REMOVAL", "removal_requires_only_frost_killing_components", s.end_date) if {
	some e in catch_crop_segments
	s := e.seg
	s.end_date
	some m in lib.lists.mechanical_removal_methods
	m.code == s.removal_method
	m.requires_only_frost_killing_components
	object.get(mixture(s), "frost_killed_share", 0) < 1
}

violations contains violation(e, "O67-CC-TILLAGE-BAN", "tillage_during_greening", op.date) if {
	some e in catch_crop_segments
	some op in object.get(e.seg, "operations", [])
	op.type in {"tillage", "knife_roller"}
	in_period(e.seg, op.date)
}

violations contains violation(e, "O67-CC-ROLLING", "rolling_destroys_cover", op.date) if {
	some e in catch_crop_segments
	some op in object.get(e.seg, "operations", [])
	op.type in {"rolling", "reconsolidation_rolling"}
	in_period(e.seg, op.date)
	op.cover_maintained == false
}

# Anwalzen zur Rückverfestigung nur unmittelbar nach der Anlage; späteres
# Walzen ist bei überwinternden Zwischenfrüchten erst nach dem 31.10. zulässig.
violations contains violation(e, "O67-CC-ROLLING", "reconsolidation_rolling_not_immediate", op.date) if {
	some e in catch_crop_segments
	s := e.seg
	some op in object.get(s, "operations", [])
	op.type == "reconsolidation_rolling"
	in_period(s, op.date)
	lib.day(op.date) - start_day(s) > cc.reconsolidation_rolling_max_days_after_sowing
	overwintering(s)
	before_care_cutoff(s, op)
}

violations contains violation(e, "O67-CC-CARE-BEFORE-NOV", "care_on_overwintering_catch_crop_before_november", op.date) if {
	some e in catch_crop_segments
	s := e.seg
	overwintering(s)
	some op in object.get(s, "operations", [])
	op.type in {"chopping", "maintenance_mowing", "rolling"}
	not op.ground_near == true
	in_period(s, op.date)
	before_care_cutoff(s, op)
	not care_before_nov_allowed(op)
}

violations contains violation(e, "O67-CC-CARE-CONDITIONS", "care_or_use_without_regrowth_or_cover", op.date) if {
	some e in catch_crop_segments
	some op in object.get(e.seg, "operations", [])
	op.type in {"chopping", "maintenance_mowing", "mowing_with_removal", "grazing"}
	not op.ground_near == true
	in_period(e.seg, op.date)
	cover_or_regrowth_lost(op)
}

violations contains violation(e, "O67-CC-GROUND-NEAR-CHOPPING", "ground_near_chopping_before_complete_frost_kill", op.date) if {
	some e in catch_crop_segments
	some op in object.get(e.seg, "operations", [])
	op.type in {"chopping", "maintenance_mowing", "mowing_with_removal"}
	op.ground_near == true
	in_period(e.seg, op.date)
	not op.fully_frost_killed == true
}

violations contains violation(e, "O67-CC-STRIP-TILL-DEEP-LOOSENING", "strip_till_or_deep_loosening_without_cover", op.date) if {
	some e in catch_crop_segments
	some op in object.get(e.seg, "operations", [])
	op.type in {"strip_till_preparation", "deep_loosening"}
	in_period(e.seg, op.date)
	op.cover_maintained == false
}

violations contains violation(e, "O67-CC-STRIP-TILL-DEEP-LOOSENING", "strip_till_preparation_full_area", op.date) if {
	some e in catch_crop_segments
	some op in object.get(e.seg, "operations", [])
	op.type == "strip_till_preparation"
	in_period(e.seg, op.date)
	op.whole_area == true
}

violations contains violation(e, "O67-CC-NO-THRESHING", "threshed_catch_crop_not_declared", object.get(e.seg, "end_date", effective_start(e.seg))) if {
	some key, e in catch_crop_segments
	"threshed" in invalid_reasons[key]
}

violations contains violation(e, "O67-CC-PROBLEM-WEED-EVIDENCE", "early_chopping_without_evidence", op.date) if {
	some e in catch_crop_segments
	s := e.seg
	overwintering(s)
	some op in object.get(s, "operations", [])
	op.type == "chopping"
	op.problem_weed in lib.lists.problem_weeds_early_chopping
	in_period(s, op.date)
	before_care_cutoff(s, op)
	not op.evidence_kept == true
}

# Ist die Anzahl der Mischungspartner am Feld nicht ersichtlich, ist ein
# Saatgutnachweis über Rechnung oder Etikett erforderlich.
violations contains violation(e, "O67-CC-SEED-PROOF", "seed_proof_missing", effective_start(e.seg)) if {
	some e in catch_crop_segments
	s := e.seg
	sown_by_mixture_cutoff(s)
	mixture(s).partners_visible_in_field == false
	not mixture(s).seed_proof_available == true
}
