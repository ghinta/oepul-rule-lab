# Modul: o6_22 – Stallhaltung, Gruppenhaltung, Platzangebot und Freilandhaltung
package oepul.o6_22

# ---------------------------------------------------------------------------
# Gewichtsklassen und Mindestflächen (O622-SPACE-002, O622-SPACE-003, O622-SPACE-005)
# ---------------------------------------------------------------------------

above_lower(lower, w) if {
	lower == null
	is_number(w)
}

above_lower(lower, w) if {
	is_number(lower)
	w > lower
}

below_upper(upper, w) if {
	upper == null
	is_number(w)
}

below_upper(upper, w) if {
	is_number(upper)
	w <= upper
}

# Gewichtsklasse laut Tabelle Kapitel 6.2.5 anhand des Durchschnittsgewichts der Gruppe.
weight_class(w) := row if {
	some row in space.piglets_fattening
	above_lower(row.min_weight_kg_exclusive, w)
	below_upper(row.max_weight_kg_inclusive, w)
}

sow_space_row(animal_type) := row if {
	some row in space.sows
	row.animal_type == animal_type
}

# O622-DOC-002: maximal mögliche Tierzahl je Stallabteil (Belegungsplan).
max_animals_in_pen(area_m2, avg_weight_kg) := floor((area_m2 + 0.000001) / weight_class(avg_weight_kg).total_area_m2)

max_sows_in_pen(area_m2, animal_type) := floor((area_m2 + 0.000001) / sow_space_row(animal_type).total_area_m2)

# O622-SPACE-002: geforderte nutzbare Gesamtfläche einer Bucht (Ferkel, Jung- und Mastschweine).
required_total_area_fattening(pen) := r4(pen.animal_count * weight_class(pen.average_weight_kg).total_area_m2)

# O622-SPACE-001: eingestreute Liegefläche mindestens 40 % der geforderten Gesamtfläche.
required_littered_lying_area_fattening(pen) := r4(required_total_area_fattening(pen) * space.thresholds.min_littered_lying_share_of_required_total)

# O622-SPACE-005: Sauenbuchten (Zuchtsauen 3,00/1,30 m², gedeckte Jungsauen 2,00/0,95 m²).
sow_counts(pen) := object.get(pen, "sow_counts", {})

required_total_area_sows(pen) := r4(sum([x | some t, n in sow_counts(pen); x := n * sow_space_row(t).total_area_m2]))

required_lying_area_sows(pen) := r4(sum([x | some t, n in sow_counts(pen); x := n * sow_space_row(t).lying_area_m2]))

# O622-STALL-004: nutzbare Gesamtfläche = befestigte Flächen mit ständigem Zugang.
effective_usable_area(pen) := r4((object.get(pen, "usable_total_area_m2", 0) - object.get(pen, "unpaved_area_included_m2", 0)) - closed_run_area(pen))

closed_run_area(pen) := object.get(pen, "outdoor_run_area_m2", 0) if object.get(pen, "outdoor_run_permanent_access", true) == false

closed_run_area(pen) := 0 if object.get(pen, "outdoor_run_permanent_access", true) != false

# ---------------------------------------------------------------------------
# Buchten der Stallhaltung
# ---------------------------------------------------------------------------

stall_housed(g) if object.get(g, ["housing", "housing_type"], "unknown") in {"stall", "mixed"}

free_range_housed(g) if object.get(g, ["housing", "housing_type"], "unknown") in {"pasture", "mixed"}

group_pens(g) := object.get(g, ["housing", "stall", "pens"], [])

# O622-GRP-008: Sauen außerhalb der Gruppenhaltungspflicht – Einstreu und Platzbedarf
# müssen in diesen Zeiten nicht erfüllt sein.
pen_exempt(g, pen) if {
	group_measure_category(g) == "zuchtsauen"
	object.get(pen, "outside_group_housing_obligation", false) == true
}

checked_pen(g, pen) if {
	g.housing.housing_type in {"stall", "mixed"}
	not pen_exempt(g, pen)
}

is_fattening_group(g) if group_measure_category(g) in {"ferkel", "mastschweine"}

is_sow_group(g) if group_measure_category(g) == "zuchtsauen"

bedding_row(code) := row if {
	some row in lists.bedding_materials_examples
	row.code == code
}

# O622-ENR-001: Beschäftigungsmaterial (Gras, Stroh oder Heu) jederzeit verfügbar.
enrichment_ok(pen) if {
	bedding_row(pen.bedding_material).counts_as_straw_or_hay_bedding == true
	object.get(pen, "minimal_bedding", false) == false
}

enrichment_ok(pen) if {
	object.get(pen, "enrichment_permanently_available", false) == true
	object.get(pen, "enrichment_material", "") in lists.enrichment_materials
}

# ---------------------------------------------------------------------------
# Gruppenhaltung Sauen (THVO) – O622-GRP-006, O622-GRP-007, O622-GRP-009
# ---------------------------------------------------------------------------

sow_transitional_rule_applicable(sgh) if {
	object.get(sgh, "stall_built_or_rebuilt_since_2013", true) == false
	object.get(sgh, "sufficient_group_space_without_construction", true) == false
	year <= params.sow_group_housing_transition_until_year
}

required_group_start_days_after_mating(sgh) := params.sow_group_housing_transitional_start_days_after_mating if sow_transitional_rule_applicable(sgh)

required_group_start_days_after_mating(sgh) := params.sow_group_housing_start_days_after_mating if not sow_transitional_rule_applicable(sgh)

required_group_end_days_before_farrowing(sgh) := params.sow_group_housing_transitional_end_days_before_farrowing if sow_transitional_rule_applicable(sgh)

required_group_end_days_before_farrowing(sgh) := params.sow_group_housing_end_days_before_farrowing if not sow_transitional_rule_applicable(sgh)

# Gruppenhaltungspflicht an einem Tag des Trächtigkeitszyklus.
sow_group_housing_required(sgh, days_after_mating, days_before_farrowing) if {
	days_after_mating >= required_group_start_days_after_mating(sgh)
	days_before_farrowing >= required_group_end_days_before_farrowing(sgh)
}

# ---------------------------------------------------------------------------
# Freilandhaltung – O622-FREE-001 bis O622-FREE-010
# ---------------------------------------------------------------------------

free_range(g) := object.get(g, ["housing", "free_range"], {})

free_range_reference_area_ha(fr) := fr.rotational_total_area_ha if {
	object.get(fr, "rotational_paddocks", false) == true
	is_number(object.get(fr, "rotational_total_area_ha", null))
}

free_range_reference_area_ha(fr) := object.get(fr, "unpaved_area_ha", 0) if {
	not object.get(fr, "rotational_paddocks", false) == true
}

free_range_reference_area_ha(fr) := object.get(fr, "unpaved_area_ha", 0) if {
	object.get(fr, "rotational_paddocks", false) == true
	not is_number(object.get(fr, "rotational_total_area_ha", null))
}

free_range_max_gve_per_ha(fr) := fr.water_permit_max_gve_per_ha if is_number(object.get(fr, "water_permit_max_gve_per_ha", null))

free_range_max_gve_per_ha(fr) := params.free_range_default_max_gve_per_ha if not is_number(object.get(fr, "water_permit_max_gve_per_ha", null))

free_range_gve(g) := object.get(free_range(g), "enclosure_gve", group_gve_declared(g))

free_range_stocking_gve_per_ha(g) := r4(free_range_gve(g) / free_range_reference_area_ha(free_range(g))) if free_range_reference_area_ha(free_range(g)) > 0

# ---------------------------------------------------------------------------
# Verstöße Stallhaltung
# ---------------------------------------------------------------------------

violations contains {
	"rule_id": "O622-SPACE-002",
	"message": sprintf("Gruppe %v, Bucht %v: nutzbare Gesamtfläche %v m² < gefordert %v m²", [group_label(i, g), pen.pen_id, effective_usable_area(pen), required_total_area_fattening(pen)]),
} if {
	some i, g in pig_groups
	is_fattening_group(g)
	some pen in group_pens(g)
	checked_pen(g, pen)
	effective_usable_area(pen) < required_total_area_fattening(pen)
}

violations contains {
	"rule_id": "O622-SPACE-001",
	"message": sprintf("Gruppe %v, Bucht %v: eingestreute Liegefläche %v m² < 40 %% der geforderten Gesamtfläche (%v m²)", [group_label(i, g), pen.pen_id, object.get(pen, "littered_lying_area_m2", 0), required_littered_lying_area_fattening(pen)]),
} if {
	some i, g in pig_groups
	is_fattening_group(g)
	some pen in group_pens(g)
	checked_pen(g, pen)
	object.get(pen, "littered_lying_area_m2", 0) < required_littered_lying_area_fattening(pen)
}

violations contains {
	"rule_id": "O622-SPACE-006",
	"message": sprintf("Gruppe %v, Bucht %v: Durchschnittsgewicht fehlt oder ist keiner Gewichtsklasse zuordenbar", [group_label(i, g), pen.pen_id]),
} if {
	some i, g in pig_groups
	is_fattening_group(g)
	some pen in group_pens(g)
	checked_pen(g, pen)
	not weight_class(object.get(pen, "average_weight_kg", null))
}

violations contains {
	"rule_id": "O622-SPACE-005",
	"message": sprintf("Gruppe %v, Bucht %v: nutzbare Gesamtfläche %v m² < gefordert %v m² (Sauen)", [group_label(i, g), pen.pen_id, effective_usable_area(pen), required_total_area_sows(pen)]),
} if {
	some i, g in pig_groups
	is_sow_group(g)
	some pen in group_pens(g)
	checked_pen(g, pen)
	effective_usable_area(pen) < required_total_area_sows(pen)
}

violations contains {
	"rule_id": "O622-SPACE-005",
	"message": sprintf("Gruppe %v, Bucht %v: eingestreute Liegefläche %v m² < gefordert %v m² (Sauen)", [group_label(i, g), pen.pen_id, object.get(pen, "littered_lying_area_m2", 0), required_lying_area_sows(pen)]),
} if {
	some i, g in pig_groups
	is_sow_group(g)
	some pen in group_pens(g)
	checked_pen(g, pen)
	object.get(pen, "littered_lying_area_m2", 0) < required_lying_area_sows(pen)
}

violations contains {
	"rule_id": "O622-LIE-001",
	"message": sprintf("Gruppe %v, Bucht %v: Liegefläche mit %v %% Perforation gilt nicht als planbefestigt (max. 5 %%)", [group_label(i, g), pen.pen_id, pen.lying_area_perforation_percent]),
} if {
	some i, g in pig_groups
	some pen in group_pens(g)
	checked_pen(g, pen)
	object.get(pen, "lying_area_perforation_percent", 0) > space.thresholds.max_perforation_percent_solid_lying_area
}

violations contains {
	"rule_id": "O622-LIE-002",
	"message": sprintf("Gruppe %v, Bucht %v: Liegebereich nicht so eingestreut, dass eine trockene Liegefläche gewährleistet ist", [group_label(i, g), pen.pen_id]),
} if {
	some i, g in pig_groups
	some pen in group_pens(g)
	checked_pen(g, pen)
	not object.get(pen, "lying_area_littered_and_dry", false) == true
}

violations contains {
	"rule_id": "O622-ENR-001",
	"message": sprintf("Gruppe %v, Bucht %v: kein ständig verfügbares Beschäftigungsmaterial (Gras, Stroh oder Heu)", [group_label(i, g), pen.pen_id]),
} if {
	some i, g in pig_groups
	some pen in group_pens(g)
	checked_pen(g, pen)
	not enrichment_ok(pen)
}

violations contains {
	"rule_id": "O622-GRP-001",
	"message": sprintf("Gruppe %v, Bucht %v: Tiere werden nicht in Gruppen gehalten", [group_label(i, g), pen.pen_id]),
} if {
	some i, g in pig_groups
	some pen in group_pens(g)
	checked_pen(g, pen)
	object.get(pen, "group_housed", true) == false
}

violations contains {
	"rule_id": "O622-STALL-001",
	"message": sprintf("Gruppe %v: Stall entspricht nicht der Stalldefinition (Verschalung/Windschutz, überdachte Liegeplätze, befestigter Boden, Sammelbehälter)", [group_label(i, g)]),
} if {
	some i, g in pig_groups
	stall_housed(g)
	st := object.get(g, ["housing", "stall", "structure"], {})
	object.get(st, "open_stall_system", false) == false
	not closed_stall_ok(st)
}

closed_stall_ok(st) if {
	st.three_sided_enclosure_or_windbreak == true
	st.lying_area_roofed == true
	st.paved_floor == true
	object.get(st, "liquid_manure_collectable", true) == true
}

violations contains {
	"rule_id": "O622-STALL-002",
	"message": sprintf("Gruppe %v: Offenstall ohne festes Dach über Liegeflächen, flüssigkeitsdichte Befestigung oder Sickerwasserableitung", [group_label(i, g)]),
} if {
	some i, g in pig_groups
	stall_housed(g)
	st := object.get(g, ["housing", "stall", "structure"], {})
	st.open_stall_system == true
	not open_stall_ok(st)
}

open_stall_ok(st) if {
	st.lying_area_roofed == true
	st.liquid_tight_paved == true
	st.seepage_to_collection_pit == true
}

violations contains {
	"rule_id": "O622-STALL-003",
	"message": sprintf("Gruppe %v: Stall bietet nicht für alle Tiere ausreichend Platz", [group_label(i, g)]),
} if {
	some i, g in pig_groups
	free_range_housed(g)
	stall_housed(g)
	object.get(g, ["housing", "stall", "structure", "space_for_all_animals"], true) == false
}

# ---------------------------------------------------------------------------
# Verstöße Gruppenhaltung Sauen und Einzeltierhaltung
# ---------------------------------------------------------------------------

violations contains {
	"rule_id": "O622-GRP-006",
	"message": sprintf("Gruppe %v: Gruppenhaltung beginnt erst %v Tage nach dem Decken (gefordert spätestens %v)", [group_label(i, g), sgh.group_from_day_after_mating, required_group_start_days_after_mating(sgh)]),
} if {
	some i, g in pig_groups
	is_sow_group(g)
	sgh := object.get(g, ["housing", "sow_group_housing"], null)
	is_object(sgh)
	sgh.group_from_day_after_mating > required_group_start_days_after_mating(sgh)
}

violations contains {
	"rule_id": "O622-GRP-006",
	"message": sprintf("Gruppe %v: Gruppenhaltung endet %v Tage vor dem Abferkeltermin (gefordert frühestens %v)", [group_label(i, g), sgh.group_until_days_before_farrowing, required_group_end_days_before_farrowing(sgh)]),
} if {
	some i, g in pig_groups
	is_sow_group(g)
	sgh := object.get(g, ["housing", "sow_group_housing"], null)
	is_object(sgh)
	sgh.group_until_days_before_farrowing > required_group_end_days_before_farrowing(sgh)
}

single_housing_events(g) := object.get(g, ["pig_welfare", "single_housing_events"], [])

violations contains {
	"rule_id": "O622-GRP-003",
	"message": sprintf("Gruppe %v: Einzeltierhaltung %v Tage (> 10 Tage) ohne Abmeldung des Tieres", [group_label(i, g), ev.days]),
} if {
	some i, g in pig_groups
	some ev in single_housing_events(g)
	ev.days > params.max_single_housing_days
	object.get(ev, "deregistered", false) == false
}

violations contains {
	"rule_id": "O622-GRP-002",
	"message": sprintf("Gruppe %v: Einzeltierhaltung ohne gesundheitlichen Grund oder ohne eingestreutes System (Prämienfähigkeit nicht gegeben)", [group_label(i, g)]),
} if {
	some i, g in pig_groups
	some ev in single_housing_events(g)
	ev.days <= params.max_single_housing_days
	not single_housing_short_ok(ev)
	object.get(ev, "deregistered", false) == false
}

single_housing_short_ok(ev) if {
	ev.health_reason == true
	ev.littered == true
}

violations contains {
	"rule_id": "O622-GRP-004",
	"message": sprintf("Gruppe %v: Krankheit/Verletzung und Dauer der Einzeltierhaltung nicht dokumentiert", [group_label(i, g)]),
} if {
	some i, g in pig_groups
	some ev in single_housing_events(g)
	object.get(ev, "documented", false) == false
}

# ---------------------------------------------------------------------------
# Teilnahme aller Tiere / bestehende Stallungen (O622-ALL-001 bis O622-ALL-003)
# ---------------------------------------------------------------------------

non_compliant_count(g) := count_basis(g) if object.get(g, ["pig_welfare", "continuous_compliance_from_eligible_weight"], true) == false

non_compliant_count(g) := object.get(g, ["pig_welfare", "non_compliant_average_count"], 0) if object.get(g, ["pig_welfare", "continuous_compliance_from_eligible_weight"], true) != false

violations contains {
	"rule_id": "O622-ALL-002",
	"message": sprintf("Gruppe %v: %v Tiere erfüllen die Haltungsbedingungen nicht durchgängig, aber nur %v abgemeldet", [group_label(i, g), non_compliant_count(g), deregistered_count(g)]),
} if {
	some i, g in pig_groups
	group_measure_category(g) in active_categories
	non_compliant_count(g) > deregistered_count(g)
}

# ---------------------------------------------------------------------------
# Verstöße Freilandhaltung
# ---------------------------------------------------------------------------

violations contains {
	"rule_id": "O622-FREE-001",
	"message": sprintf("Gruppe %v: Besatz %v GVE/ha überschreitet zulässige %v GVE/ha", [group_label(i, g), free_range_stocking_gve_per_ha(g), free_range_max_gve_per_ha(free_range(g))]),
} if {
	some i, g in pig_groups
	free_range_housed(g)
	free_range_stocking_gve_per_ha(g) > free_range_max_gve_per_ha(free_range(g))
}

violations contains {
	"rule_id": "O622-FREE-001",
	"message": sprintf("Gruppe %v: keine unbefestigte Freilandfläche angegeben", [group_label(i, g)]),
} if {
	some i, g in pig_groups
	free_range_housed(g)
	not free_range_reference_area_ha(free_range(g)) > 0
}

violations contains {
	"rule_id": "O622-FREE-002",
	"message": sprintf("Gruppe %v: durchgehende Nutzung der unbefestigten Fläche %v Monate (> 1 Jahr)", [group_label(i, g), free_range(g).continuous_use_months]),
} if {
	some i, g in pig_groups
	free_range_housed(g)
	object.get(free_range(g), "continuous_use_months", 0) > params.free_range_max_continuous_use_months
}

free_range_flag_rules := {
	"double_fence_or_solid_enclosure": "O622-FREE-003",
	"feed_and_water_separated": "O622-FREE-004",
	"feed_and_water_paved_or_moved_regularly": "O622-FREE-004",
	"feeding_place_roofed": "O622-FREE-004",
	"shelter_roofed_three_sided_littered": "O622-FREE-005",
	"shelter_all_animals_lie_simultaneously": "O622-FREE-005",
}

violations contains {
	"rule_id": rule_id,
	"message": sprintf("Gruppe %v: Freilandauflage '%v' nicht erfüllt", [group_label(i, g), flag]),
} if {
	some i, g in pig_groups
	free_range_housed(g)
	some flag, rule_id in free_range_flag_rules
	object.get(free_range(g), flag, false) != true
}

violations contains {
	"rule_id": "O622-FREE-006",
	"message": sprintf("Gruppe %v: keine Abferkelhütten für Zuchtsauen in Freilandhaltung", [group_label(i, g)]),
} if {
	some i, g in pig_groups
	free_range_housed(g)
	is_sow_group(g)
	object.get(free_range(g), "farrowing_on_range", false) == true
	object.get(free_range(g), "farrowing_huts_available", false) != true
}

violations contains {
	"rule_id": "O622-FREE-008",
	"message": sprintf("Gruppe %v: Freilandhaltung nicht laufend dokumentiert (Beginn/Ende je Schlag, Tierzahl je Schlag)", [group_label(i, g)]),
} if {
	some i, g in pig_groups
	free_range_housed(g)
	object.get(free_range(g), "records_complete", false) != true
}

violations contains {
	"rule_id": "O622-FREE-009",
	"message": sprintf("Gruppe %v: Wildschweine in Freilandhaltung sind nicht förderbar und abzumelden", [group_label(i, g)]),
} if {
	some i, g in pig_groups
	is_wild_boar(g)
	deregistered_count(g) < count_basis(g)
}

# O622-FREE-010: unbefestigte Ausläufe als "Sonstige Acker-/Grünlandflächen" beantragen.
violations contains {
	"rule_id": "O622-FREE-010",
	"message": sprintf("Schlag %v: unbefestigte Auslauffläche der Freilandschweinehaltung nicht als 'Sonstige Ackerflächen' oder 'Sonstige Grünlandflächen' beantragt", [p.parcel_id]),
} if {
	count(active_categories) > 0
	some p in object.get(input, ["land", "parcels"], [])
	object.get(p, "pig_free_range_run", false) == true
	not object.get(p, "mfa_land_use_type", "") in lists.free_range_run_land_use_types
}
