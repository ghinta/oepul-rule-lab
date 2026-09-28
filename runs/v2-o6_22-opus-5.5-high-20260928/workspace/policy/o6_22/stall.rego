# Tierwohl – Schweinehaltung (o6_22): stall housing conditions (definitions,
# group housing, lying area, litter, enrichment material, space allowance).
package oepul.o6_22

# Rule: O622-FAT-SPACE-02 (weight class via group average; half-open class boundaries, see notes/assumptions.md)
space_weight(g) := g.average_live_weight_kg if {
	is_number(object.get(g, "average_live_weight_kg", null))
} else := tierliste[g.tierliste_category].fallback_space_weight_kg

weight_in_class(_, row) if row.upper_kg == null

weight_in_class(w, row) if {
	row.upper_kg != null
	row.upper_inclusive == true
	w <= row.upper_kg
}

weight_in_class(w, row) if {
	row.upper_kg != null
	row.upper_inclusive == false
	w < row.upper_kg
}

# Rule: O622-FAT-SPACE-01 (minimum area table for Ferkel, Jung- und Mastschweine)
fattening_requirement(w) := space.fattening[min({i | some i, row in space.fattening; weight_in_class(w, row)})]

# Rule: O622-SOW-SPACE-01 (minimum area table for Zuchtsauen and gedeckte Jungsauen)
sow_requirement(sow_type) := row if {
	some row in space.sows
	row.sow_type == sow_type
}

space_requirement(g) := fattening_requirement(space_weight(g)) if {
	not is_sow_group(g)
}

space_requirement(g) := sow_requirement(tierliste[g.tierliste_category].sow_type) if {
	is_sow_group(g)
}

# Rule: O622-FAT-SPACE-01 / O622-SOW-SPACE-01 (required usable total area in the compartment)
required_total_area(g) := r2(g.animal_count * space_requirement(g).total_area_m2_per_animal)

# Rule: O622-FAT-LYING-01 (littered lying area >= 40 % of the required usable total area)
required_littered_lying_area(g) := r2(space.fattening_min_littered_lying_share * required_total_area(g)) if {
	not is_sow_group(g)
}

# Rule: O622-SOW-SPACE-01 (lying area 1.30 m² per Zuchtsau / 0.95 m² per gedeckte Jungsau)
required_littered_lying_area(g) := r2(g.animal_count * space_requirement(g).lying_area_m2_per_animal) if {
	is_sow_group(g)
}

# Rule: O622-DEF-AREA-01 (usable total area = stall plus paved outdoor run with permanent access)
usable_total_area(g) := stall(g).stall_area_m2 + stall(g).paved_outdoor_run_area_m2 if {
	stall(g).outdoor_run_permanently_accessible == true
	is_number(object.get(stall(g), "paved_outdoor_run_area_m2", null))
} else := stall(g).stall_area_m2

# Rule: O622-DOC-SKETCH-03 (maximum occupancy of a compartment computed from the space table)
max_animals_in_compartment(area_m2, weight_kg) := floor((area_m2 + 0.000001) / fattening_requirement(weight_kg).total_area_m2_per_animal)

max_sows_in_compartment(area_m2, sow_type) := floor((area_m2 + 0.000001) / sow_requirement(sow_type).total_area_m2_per_animal)

# Rule: O622-DEF-STALL-01 (closed stall definition)
stall_definition_failure(s) if {
	object.get(s, "is_open_stall", false) != true
	s.enclosed_sides < params.stall_min_enclosed_sides
}

stall_definition_failure(s) if s.lying_area_roofed == false

stall_definition_failure(s) if {
	object.get(s, "is_open_stall", false) != true
	s.floor_paved == false
}

stall_definition_failure(s) if {
	object.get(s, "is_open_stall", false) != true
	s.liquid_manure_container == false
}

# Rule: O622-DEF-STALL-02 (open stall systems: roof over lying area, liquid-tight floor, seepage drain)
stall_definition_failure(s) if {
	s.is_open_stall == true
	s.floor_liquid_tight == false
}

stall_definition_failure(s) if {
	s.is_open_stall == true
	s.seepage_drain_to_pit == false
}

# Rule: O622-STALL-GROUP-02 (single housing of sick/injured animals up to 10 days on litter)
single_housing(g) := object.get(welfare(g), "single_housing", {})

permitted_single_housing(g) if {
	sh := single_housing(g)
	sh.reason == "illness_or_injury"
	sh.max_days <= params.single_housing_max_days
	sh.littered == true
}

enrichment_codes := {row.code | some row in lists.enrichment_materials}

littered_with_straw_or_hay(g) if stall(g).bedding_type == "straw"

littered_with_straw_or_hay(g) if object.get(stall(g), "litter_material", null) in {"straw", "hay"}

# Rule: O622-STALL-ENRICH-01 (enrichment material grass/straw/hay at all times)
enrichment_ok(g) if {
	littered_with_straw_or_hay(g)
	object.get(stall(g), "minimal_litter", false) != true
}

enrichment_ok(g) if object.get(stall(g), "enrichment_material", "none") in enrichment_codes

enrichment_known(g) if object.get(stall(g), "bedding_type", "unknown") != "unknown"

enrichment_known(g) if object.get(stall(g), "enrichment_material", "unknown") != "unknown"

stall_groups := {i: g | some i, g in participating_groups; stall_kept(g)}

# ---- group issues: animals affected must be deregistered (O622-REPORT-01) ----

# Rule: O622-STALL-GROUP-01
group_issues contains {"group": i, "rule_id": "O622-STALL-GROUP-01", "reason": "no_group_housing"} if {
	some i, g in stall_groups
	welfare(g).group_housing == false
	not permitted_single_housing(g)
}

# Rule: O622-STALL-GROUP-03
group_issues contains {"group": i, "rule_id": "O622-STALL-GROUP-03", "reason": "single_housing_over_10_days"} if {
	some i, g in stall_groups
	single_housing(g).max_days > params.single_housing_max_days
}

# Rule: O622-STALL-GROUP-02
group_issues contains {"group": i, "rule_id": "O622-STALL-GROUP-02", "reason": "single_housing_not_littered"} if {
	some i, g in stall_groups
	single_housing(g).reason == "illness_or_injury"
	single_housing(g).littered == false
}

# Rule: O622-STALL-GROUP-02 (single housing only for health reasons)
group_issues contains {"group": i, "rule_id": "O622-STALL-GROUP-02", "reason": "single_housing_without_health_reason"} if {
	some i, g in stall_groups
	single_housing(g).reason == "other"
}

# Rule: O622-STALL-01 (littered systems only)
group_issues contains {"group": i, "rule_id": "O622-STALL-01", "reason": "not_littered"} if {
	some i, g in stall_groups
	stall(g).bedding_type == "none"
}

# Rule: O622-STALL-LYING-01 (closed lying area, fully slatted floors do not qualify)
group_issues contains {"group": i, "rule_id": "O622-STALL-LYING-01", "reason": "full_slatted_floor"} if {
	some i, g in stall_groups
	stall(g).floor_type == "full_slatted"
}

# Rule: O622-STALL-LYING-01 (perforation of lying area max. 5 %)
group_issues contains {"group": i, "rule_id": "O622-STALL-LYING-01", "reason": "lying_area_perforation_above_5_percent"} if {
	some i, g in stall_groups
	stall(g).lying_area_perforation_percent > space.max_lying_area_perforation_percent
}

# Rule: O622-STALL-LYING-02 (dry littered lying area)
group_issues contains {"group": i, "rule_id": "O622-STALL-LYING-02", "reason": "lying_area_not_dry"} if {
	some i, g in stall_groups
	stall(g).lying_area_dry == false
}

# Rule: O622-STALL-ENRICH-01
group_issues contains {"group": i, "rule_id": "O622-STALL-ENRICH-01", "reason": "insufficient_enrichment_material"} if {
	some i, g in stall_groups
	enrichment_known(g)
	not enrichment_ok(g)
}

# Rule: O622-SPACE-TOTAL / O622-FAT-SPACE-01 / O622-FAT-SPACE-03 / O622-SOW-SPACE-01 / O622-DEF-STALL-03
group_issues contains {"group": i, "rule_id": "O622-SPACE-TOTAL", "reason": "insufficient_usable_total_area"} if {
	some i, g in stall_groups
	usable_total_area(g) < required_total_area(g)
}

# Rule: O622-SPACE-LYING / O622-FAT-LYING-01 / O622-SOW-SPACE-01 / O622-STALL-LYING-03
group_issues contains {"group": i, "rule_id": "O622-SPACE-LYING", "reason": "insufficient_littered_lying_area"} if {
	some i, g in stall_groups
	stall(g).lying_area_m2 < required_littered_lying_area(g)
}

# Rule: O622-DEF-STALL-01 / O622-DEF-STALL-02
group_issues contains {"group": i, "rule_id": "O622-DEF-STALL-01", "reason": "stall_definition_not_met"} if {
	some i, g in stall_groups
	stall_definition_failure(stall(g))
}

# Rule: O622-FAT-ALL-02 / O622-SOW-ALL-02 / O622-CONTRACT-04 / O622-GEN-DURATION-01 (continuous compliance over the whole holding period)
group_issues contains {"group": i, "rule_id": "O622-FAT-ALL-02", "reason": "not_compliant_throughout_holding_period"} if {
	some i, g in participating_groups
	welfare(g).compliant_throughout_holding_period == false
}

# Rule: O622-STALL-GROUP-04 (documentation of illness and duration of single housing)
violations contains {
	"rule_id": "O622-STALL-GROUP-04",
	"severity": "obligation",
	"message": sprintf("Group %v: illness/injury and duration of single housing are not documented", [i]),
} if {
	some i, g in stall_groups
	single_housing(g).reason == "illness_or_injury"
	single_housing(g).documented == false
}

# Missing key inputs are surfaced instead of being treated as compliant.
missing_inputs contains sprintf("livestock.species_groups[%v].housing.stall.stall_area_m2", [i]) if {
	some i, g in stall_groups
	not is_number(object.get(stall(g), "stall_area_m2", null))
}

missing_inputs contains sprintf("livestock.species_groups[%v].housing.stall.lying_area_m2", [i]) if {
	some i, g in stall_groups
	not is_number(object.get(stall(g), "lying_area_m2", null))
}

missing_inputs contains sprintf("livestock.species_groups[%v].pig_welfare.group_housing", [i]) if {
	some i, g in stall_groups
	not is_boolean(object.get(welfare(g), "group_housing", null))
}

# Rule: O622-GROUP-SOW-01 / O622-GROUP-SOW-02 (group-housing window for sows under the 1. THVO)
sow_group_housing_period(regime) := row if {
	some row in params.sow_group_housing_periods
	row.regime == regime
}

# Rule: O622-GROUP-SOW-02 (transitional window only for existing stalls, only until 2033 and only
# if the requirement cannot be met without construction work; otherwise the 10-day window applies)
applicable_sow_regime(existing_stall_without_rebuild, achievable_without_construction, y) := "uebergang_bestand_bis_2033" if {
	existing_stall_without_rebuild == true
	achievable_without_construction == false
	y <= sow_group_housing_period("uebergang_bestand_bis_2033").valid_until_year
} else := "neu_oder_umbau_seit_2013"

# Rule: O622-GROUP-SOW-01 / O622-GROUP-SOW-03 / O622-GROUP-SOW-04 (group housing and the other
# conditions (litter, space) are only required inside this window; applies also below 10 sows)
sow_group_housing_required(days_after_mating, days_before_expected_farrowing, regime) if {
	p := sow_group_housing_period(regime)
	days_after_mating >= p.start_days_after_mating
	days_before_expected_farrowing >= p.end_days_before_expected_farrowing
}
