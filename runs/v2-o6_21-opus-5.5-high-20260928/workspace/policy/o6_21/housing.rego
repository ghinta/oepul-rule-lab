# Stallhaltung: Stalldefinition, Liegebereich, Einstreu, Platzangebot, Gruppenhaltung (Kapitel 5, 6.3 Informationsblatt).
package oepul.o6_21

import rego.v1

epsilon := 0.000001

# ---------------------------------------------------------------------------
# Stalldefinition (O6_21-DEF-001 bis O6_21-DEF-004)
# ---------------------------------------------------------------------------

stall_violations contains {"rule_id": "O6_21-DEF-001", "stall_id": b.stall_id, "reason": "Stall ohne mindestens dreiseitige Verschalung bzw. dreiseitigen Behang mit Windfangnetzen"} if {
	some b in stall_buildings
	b.system == "closed"
	not b.three_sided_enclosure == true
}

stall_violations contains {"rule_id": "O6_21-DEF-001", "stall_id": b.stall_id, "reason": "Liegeplätze nicht überdacht"} if {
	some b in stall_buildings
	b.system == "closed"
	not b.roof_over_lying_places == true
}

stall_violations contains {"rule_id": "O6_21-DEF-001", "stall_id": b.stall_id, "reason": "kein befestigter Boden (Schotter oder Lehm gelten nicht als befestigt)"} if {
	some b in stall_buildings
	b.system == "closed"
	not closed_stall_floor_fixed(b)
}

closed_stall_floor_fixed(b) if {
	b.floor_fixed == true
	not b.floor_material in space.unfixed_floor_materials
}

stall_violations contains {"rule_id": "O6_21-DEF-002", "stall_id": b.stall_id, "reason": "anfallender flüssiger Kot und Harn kann nicht in einem Behälter gesammelt werden"} if {
	some b in stall_buildings
	b.liquid_manure_occurs == true
	not b.liquid_manure_container == true
}

stall_violations contains {"rule_id": "O6_21-DEF-003", "stall_id": b.stall_id, "reason": "Offenstall ohne festes Dach über den Liegeflächen"} if {
	some b in stall_buildings
	b.system == "open"
	not b.solid_roof_over_lying_area == true
}

stall_violations contains {"rule_id": "O6_21-DEF-003", "stall_id": b.stall_id, "reason": "Offenstall-Stallflächen nicht flüssigkeitsdicht befestigt"} if {
	some b in stall_buildings
	b.system == "open"
	not b.liquid_tight_floor == true
}

stall_violations contains {"rule_id": "O6_21-DEF-003", "stall_id": b.stall_id, "reason": "Offenstall ohne gewährleisteten Abfluss der Sickerwässer in eine Sammelgrube"} if {
	some b in stall_buildings
	b.system == "open"
	not b.seepage_drain_to_collection_pit == true
}

stall_violations contains {"rule_id": "O6_21-DEF-004", "stall_id": b.stall_id, "reason": "Stall bietet nicht für alle Tiere (auch während Weideperiode abwesende) Platz"} if {
	some b in stall_buildings
	b.capacity_for_all_animals == false
}

# O6_21-COMB-003: grundsätzlich muss am Heimbetrieb ein Stall zur Verfügung stehen.
farm_violations contains {"rule_id": "O6_21-COMB-003", "reason": "kein Stall am Heimbetrieb erfasst"} if {
	count(applied_categories) > 0
	count(stall_buildings) == 0
}

# ---------------------------------------------------------------------------
# Platzangebot und Liegefläche je Stallabteil (O6_21-HOUS-006 bis O6_21-HOUS-019)
# ---------------------------------------------------------------------------

weight_fits(row, w) if {
	w > row.min_weight_kg_exclusive
	row.max_weight_kg == null
}

weight_fits(row, w) if {
	w > row.min_weight_kg_exclusive
	is_number(row.max_weight_kg)
	w <= row.max_weight_kg
}

# O6_21-HOUS-013: Mindestplatzbedarf je Tier nach Gewichtsklasse.
space_row(w) := row if {
	some row in space.young_cattle_by_weight
	weight_fits(row, w)
}

# O6_21-HOUS-013 / O6_21-HOUS-014 / O6_21-HOUS-015: geforderte nutzbare Gesamtfläche je Belegungsgruppe.
occupant_required_total_area(o) := o.count * space.cows_in_shared_group.total_area_m2_per_animal if o.kind == "cow"

occupant_required_total_area(o) := o.count * space_row(o.weight_kg).total_area_m2_per_animal if o.kind == "young_cattle"

pen_required_total_area(p) := sum([occupant_required_total_area(o) | some o in object.get(p, "occupants", [])])

# O6_21-HOUS-007 / O6_21-HOUS-016: mind. 40 % der geforderten Gesamtfläche eingestreute Liegefläche.
pen_required_bedded_area(p) := pen_required_total_area(p) * space.bedded_lying_area_min_share_of_required_total_area

# O6_21-SKETCH-003: maximal mögliche Belegung eines Stallabteils nach Gewichtsklasse.
max_animals_for_area(area_m2, weight_kg) := floor((area_m2 + epsilon) / space_row(weight_kg).total_area_m2_per_animal)

# O6_21-HOUS-017: Mutterkuhbetrieb mit Liegeboxenlaufstall - Gesamtfläche gilt bei Erfüllung des Tierschutzgesetzes als eingehalten.
cubicle_exception(p) if {
	p.cubicle_loose_housing == true
	input.farm.suckler_cow_farm == true
}

total_area_ok(p) if {
	cubicle_exception(p)
	p.tschg_minimum_met == true
}

total_area_ok(p) if {
	not cubicle_exception(p)
	p.usable_total_area_m2 + epsilon >= pen_required_total_area(p)
}

# O6_21-HOUS-018: Liegefläche gilt als erreicht, wenn jedes Tier > 6 Monate eine Liegebox hat
# und alle Kälber einen zusätzlichen, ständig erreichbaren Liegeplatz haben.
lying_area_ok(p) if {
	cubicle_exception(p)
	p.all_animals_over_6_months_have_cubicle == true
	p.calves_have_additional_lying_place == true
}

lying_area_ok(p) if {
	not cubicle_exception(p)
	p.bedded_lying_area_m2 + epsilon >= pen_required_bedded_area(p)
}

pen_violations contains {"rule_id": "O6_21-HOUS-013", "pen_id": p.pen_id, "reason": "nutzbare Gesamtfläche unter Mindestplatzbedarf"} if {
	some p in pens
	not total_area_ok(p)
}

pen_violations contains {"rule_id": "O6_21-HOUS-007", "pen_id": p.pen_id, "reason": "eingestreute Liegefläche unter 40 % der geforderten nutzbaren Gesamtfläche"} if {
	some p in pens
	not lying_area_ok(p)
}

# O6_21-HOUS-019: im Kälberschlupf mind. 40 % der geforderten Gesamtfläche eingestreut.
pen_violations contains {"rule_id": "O6_21-HOUS-019", "pen_id": p.pen_id, "reason": "eingestreute Liegefläche im Kälberschlupf unter 40 %"} if {
	some p in pens
	cubicle_exception(p)
	creep := p.calf_creep
	required := pen_required_total_area(creep) * space.bedded_lying_area_min_share_of_required_total_area
	creep.bedded_lying_area_m2 + epsilon < required
}

# O6_21-HOUS-006: geschlossene (planbefestigte) Liegefläche, max. 5 % Perforation.
pen_violations contains {"rule_id": "O6_21-HOUS-006", "pen_id": p.pen_id, "reason": "Liegefläche nicht planbefestigt (Perforationsanteil über 5 %)"} if {
	some p in pens
	p.lying_area_perforation_percent > space.closed_lying_area_max_perforation_percent
}

# O6_21-HOUS-010: harter Gummi oder befestigte Fläche - mind. 3 cm Einstreudecke.
pen_violations contains {"rule_id": "O6_21-HOUS-010", "pen_id": p.pen_id, "reason": "Einstreudecke unter 3 cm auf hartem Gummi bzw. befestigter Liegefläche"} if {
	some p in pens
	some t in space.lying_surface_types
	t.id == p.lying_surface
	is_number(t.min_litter_depth_cm)
	p.litter_depth_cm < t.min_litter_depth_cm
}

# O6_21-HOUS-009: weicher Kunststoff/Gummi - Einstreu zur Sicherstellung der Trockenheit.
pen_violations contains {"rule_id": "O6_21-HOUS-009", "pen_id": p.pen_id, "reason": "weiche Liegefläche ohne Einstreu zur Sicherstellung der Trockenheit"} if {
	some p in pens
	p.lying_surface == "soft_plastic_or_rubber"
	not p.littered == true
}

# O6_21-HOUS-008 / O6_21-HOUS-011: ausreichend saugfähige, weiche Einstreu - weiche und trockene Liegefläche.
pen_violations contains {"rule_id": "O6_21-HOUS-008", "pen_id": p.pen_id, "reason": "keine weiche und trockene Liegefläche gewährleistet"} if {
	some p in pens
	p.lying_area_soft_and_dry == false
}

pen_violations contains {"rule_id": "O6_21-HOUS-011", "pen_id": p.pen_id, "reason": "Einstreu nicht saugfähig und weich"} if {
	some p in pens
	p.litter_absorbent_and_soft == false
}

# O6_21-DEF-006: Absperren von Teilflächen nur für Routinearbeiten zulässig.
pen_violations contains {"rule_id": "O6_21-DEF-006", "pen_id": p.pen_id, "reason": "Teilflächen außerhalb von Routinearbeiten abgesperrt"} if {
	some p in pens
	p.subareas_closed_off_outside_routine_work == true
}

# O6_21-DEF-005: nutzbare Gesamtfläche nur befestigte Flächen mit ständigem Zugang.
pen_violations contains {"rule_id": "O6_21-DEF-005", "pen_id": p.pen_id, "reason": "angerechnete Fläche nicht befestigt oder nicht ständig zugänglich"} if {
	some p in pens
	p.counted_area_fixed_and_permanently_accessible == false
}

# ---------------------------------------------------------------------------
# Tierbezogene Haltungsverstöße (O6_21-HOUS-001, O6_21-SINGLE-*, O6_21-COMB-002)
# ---------------------------------------------------------------------------

housing(a) := object.get(a, "housing", {})

single_housing(a) := object.get(housing(a), "single_housing", null)

animal_breaches contains {"ear_tag": a.ear_tag, "rule_id": "O6_21-HOUS-001", "reason": "keine Gruppenhaltung"} if {
	some a in cattle
	housing(a).group_housed == false
}

animal_breaches contains {"ear_tag": a.ear_tag, "rule_id": "O6_21-HOUS-001", "reason": "kein eingestreutes System"} if {
	some a in cattle
	housing(a).bedded_system == false
}

animal_breaches contains {"ear_tag": a.ear_tag, "rule_id": "O6_21-HOUS-001", "reason": "Anbindehaltung"} if {
	some a in cattle
	housing(a).tethered == true
}

animal_breaches contains {"ear_tag": a.ear_tag, "rule_id": "O6_21-HOUS-001", "reason": "Haltung auf Vollspaltensystem"} if {
	some a in cattle
	housing(a).full_slatted == true
}

animal_breaches contains {"ear_tag": a.ear_tag, "rule_id": "O6_21-COMB-002", "reason": "ganzjährige Freilandhaltung ohne entsprechendes Stallsystem"} if {
	some a in cattle
	housing(a).year_round_outdoor_without_stall == true
}

animal_breaches contains {"ear_tag": a.ear_tag, "rule_id": v.rule_id, "reason": sprintf("Stallabteil %s: %s", [p.pen_id, v.reason])} if {
	some a in cattle
	p := pens_by_id[housing(a).pen_id]
	some v in pen_violations
	v.pen_id == p.pen_id
}

animal_breaches contains {"ear_tag": a.ear_tag, "rule_id": v.rule_id, "reason": sprintf("Stall %s: %s", [v.stall_id, v.reason])} if {
	some a in cattle
	p := pens_by_id[housing(a).pen_id]
	some v in stall_violations
	v.stall_id == p.stall_id
}

# O6_21-SINGLE-006: Kälber unter 21 Tagen dürfen einzeln auf eingestreutem System mit Sozialkontakt gehalten werden.
calf_single_housing_ok(sh) if {
	sh.calf_age_days_at_end < params.calf_single_housing_max_age_days_exclusive
	sh.bedded == true
	sh.social_contact == true
}

# O6_21-SINGLE-001 / O6_21-SINGLE-002: Einzelhaltung kranker/verletzter Tiere max. 10 Tage auf eingestreutem System.
sick_single_housing_ok(sh) if {
	sh.reason in {"illness", "injury"}
	sh.days <= params.single_housing_max_days
	sh.bedded == true
}

animal_breaches contains {"ear_tag": a.ear_tag, "rule_id": rid, "reason": reason} if {
	some a in cattle
	sh := single_housing(a)
	is_object(sh)
	not calf_single_housing_ok(sh)
	not sick_single_housing_ok(sh)
	[rid, reason] := single_housing_breach(sh)
}

single_housing_breach(sh) := ["O6_21-SINGLE-003", "Einzeltierhaltung länger als 10 Tage"] if {
	sh.reason in {"illness", "injury"}
	sh.days > params.single_housing_max_days
} else := ["O6_21-SINGLE-002", "Einzeltierhaltung nicht auf eingestreutem System"] if {
	sh.reason in {"illness", "injury"}
	not sh.bedded == true
} else := ["O6_21-SINGLE-001", "Einzeltierhaltung ohne gesundheitlichen Grund bzw. ohne zulässige Kälberausnahme"]

# O6_21-SINGLE-004: Dokumentation von Krankheit/Verletzung und Dauer (Aufzeichnungsverstoß, kein Abmeldegrund).
documentation_violations contains {"rule_id": "O6_21-SINGLE-004", "ear_tag": a.ear_tag, "reason": "Einzeltierhaltung nicht dokumentiert"} if {
	some a in cattle
	sh := single_housing(a)
	is_object(sh)
	sh.reason in {"illness", "injury"}
	not sh.documented == true
}

# Beginn des Verstoßes; ohne Angabe wird der Verstoß ab Jahresbeginn angenommen.
breach_start_ns(a) := date_ns(housing(a).conditions_breached_from) if {
	is_string(housing(a).conditions_breached_from)
} else := year_start_ns

# O6_21-NOTIF-004: ein Verstoß ist nur relevant, wenn er in ein Verpflichtungsfenster einer beantragten Kategorie fällt.
breach_relevant(a) if {
	some b in animal_breaches
	b.ear_tag == a.ear_tag
	some c in applied_categories
	w := obligation_window(a, categories_by_id[c])
	breach_start_ns(a) < w[1]
}

# O6_21-NOTIF-001 / O6_21-SINGLE-003: Tiere, die abgemeldet werden müssen.
deregistration_required contains a.ear_tag if {
	some a in cattle
	breach_relevant(a)
}

deregistered(a) if a.o6_21_deregistered == true

# O6_21-NOTIF-001: nicht gemeldete Nichteinhaltung ist ein Verstoß gegen die Meldepflicht.
unreported_noncompliance contains a.ear_tag if {
	some a in cattle
	a.ear_tag in deregistration_required
	not deregistered(a)
}
