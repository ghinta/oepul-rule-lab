# Stalldefinition, Liegebereich, Einstreu, Platzbedarf und Gruppenhaltung (o6_21, Kapitel 5 und 6.3).
package oepul.o6_21.housing

import data.oepul.o6_21.lib

compartments := object.get(input, ["livestock", "stall_compartments"], [])

animals := object.get(input, ["livestock", "cattle_animals"], [])

# Belegung zum Prüfstichtag: alle am Betrieb befindlichen Tiere des Abteils, auch wenn sie sich z. B. auf der Weide befinden.
compartment_animals(cid) := [a |
	some a in animals
	object.get(a, "stall_compartment_id", null) == cid
	present_at(a, lib.assessment_date)
]

present_at(a, d) if {
	lib.parse_date(a.on_farm_from) <= lib.parse_date(d)
	not is_string(object.get(a, "on_farm_until", null))
}

present_at(a, d) if {
	lib.parse_date(a.on_farm_from) <= lib.parse_date(d)
	lib.parse_date(a.on_farm_until) >= lib.parse_date(d)
}

# --- Stalldefinition (Kapitel 5) -------------------------------------------------------------

# O6_21-DEF-01: Stall = befestigtes Gebäude, mind. dreiseitige Verschalung/Windfangnetze, überdachte
# Liegeplätze, befestigter Boden (Schotter/Lehm gelten nicht als befestigt), Sammelbehälter für flüssigen Kot/Harn.
standard_stall_ok(b) if {
	b.is_fixed_building
	b.enclosed_sides_count >= 3
	b.lying_area_roofed
	b.floor_material in lib.tables.paved_floor_materials
	liquid_collection_ok(b)
}

liquid_collection_ok(b) if not b.liquid_excreta_occur

liquid_collection_ok(b) if {
	b.liquid_excreta_occur
	b.liquid_excreta_collectable
}

# O6_21-DEF-02: Offenstall – festes Dach über Liegeflächen, flüssigkeitsdichte Stallflächen,
# Abfluss der Sickerwässer in eine Sammelgrube.
open_stall_ok(b) if {
	b.is_open_stall_system
	b.solid_roof_over_lying_area
	b.surfaces_liquid_tight
	b.seepage_drain_to_collection_pit
}

building_ok(c) if standard_stall_ok(c.building)

building_ok(c) if open_stall_ok(c.building)

# --- Platzbedarf (Kapitel 6.3.1) --------------------------------------------------------------

animal_total_area_requirement(a) := lib.tables.cow_space_requirement.total_area_m2_per_animal if {
	object.get(a, "is_cow", false)
}

animal_total_area_requirement(a) := lib.space_row_for_weight(a.current_weight_kg).total_area_m2_per_animal if {
	not object.get(a, "is_cow", false)
	is_number(object.get(a, "current_weight_kg", null))
}

animal_lying_area_requirement(a) := lib.tables.cow_space_requirement.lying_area_m2_per_animal if {
	object.get(a, "is_cow", false)
}

animal_lying_area_requirement(a) := lib.space_row_for_weight(a.current_weight_kg).lying_area_m2_per_animal if {
	not object.get(a, "is_cow", false)
	is_number(object.get(a, "current_weight_kg", null))
}

animals_missing_weight contains a.ear_tag if {
	some a in animals
	object.get(a, "stall_compartment_id", null) != null
	not object.get(a, "is_cow", false)
	not is_number(object.get(a, "current_weight_kg", null))
}

# O6_21-SPACE-01 / O6_21-SPACE-03: Mindestgesamtfläche für alle Tiere der Box (auch nicht förderfähige Tiere, Kühe mit 6,00 m²).
required_total_area(cid) := lib.r4(sum([animal_total_area_requirement(a) | some a in compartment_animals(cid)]))

# Summe der tabellarischen Liegeflächen je Tier (entspricht 40 % der Gesamtfläche).
table_lying_area(cid) := lib.r4(sum([animal_lying_area_requirement(a) | some a in compartment_animals(cid)]))

# O6_21-LIE-02: eingestreute Liegefläche mindestens 40 % der geforderten nutzbaren Gesamtfläche.
required_bedded_area(cid) := lib.r4(required_total_area(cid) * lib.thresholds.bedded_lying_area_min_share)

suckler_cubicle(c) if object.get(c, ["suckler_cubicle_housing", "applies"], false)

total_area_ok(c) if {
	not suckler_cubicle(c)
	lib.r4(c.usable_paved_area_m2) >= required_total_area(c.compartment_id)
}

# O6_21-SPACE-04: Mutterkuhbetriebe mit Liegeboxenlaufstall – Gesamtfläche gilt bei Einhaltung des Tierschutzgesetzes als erfüllt.
total_area_ok(c) if {
	suckler_cubicle(c)
	c.suckler_cubicle_housing.meets_animal_welfare_act_space
}

bedded_area_ok(c) if {
	not suckler_cubicle(c)
	lib.r4(c.bedded_lying_area_m2) >= required_bedded_area(c.compartment_id)
}

calf_creep_required_total_area(c) := lib.r4(sum([animal_total_area_requirement(a) |
	some a in compartment_animals(c.compartment_id)
	not object.get(a, "is_cow", false)
	lib.age_under_half_year_at(a, lib.assessment_date)
]))

# O6_21-SPACE-04: Liegeboxen für Tiere über 6 Monate, zusätzlicher Liegeplatz für Kälber,
# im Kälberschlupf eingestreute Liegefläche mindestens 40 % der geforderten Gesamtfläche.
bedded_area_ok(c) if {
	suckler_cubicle(c)
	s := c.suckler_cubicle_housing
	s.each_animal_over_6_months_has_legal_cubicle
	s.calves_have_additional_free_lying_place
	lib.r4(s.calf_creep_bedded_area_m2) >= lib.r4(calf_creep_required_total_area(c) * lib.thresholds.bedded_lying_area_min_share)
}

# --- Liegebereich und Einstreu (Kapitel 6.3.1) -----------------------------------------------

# O6_21-LIE-01: geschlossene (planbefestigte) Liegefläche, Perforationsanteil max. 5 %.
closed_lying_area_ok(c) if {
	c.lying_area_perforation_percent <= lib.thresholds.closed_lying_area_max_perforation_percent
}

# O6_21-LIE-03 / O6_21-LIE-04: weiche Liegefläche wird zur Sicherung der Trockenheit eingestreut;
# harter Gummi bzw. befestigte Fläche benötigt mind. 3 cm Einstreudecke.
bedding_ok(c) if {
	c.lying_surface_material == "soft_rubber_or_plastic"
	c.bedded_system
	c.bedding_soft_and_dry
}

bedding_ok(c) if {
	c.lying_surface_material in {"hard_rubber", "paved"}
	c.bedding_depth_cm >= lib.thresholds.min_bedding_depth_cm_hard_surface
	c.bedding_soft_and_dry
}

# --- Befund je Stallabteil ----------------------------------------------------------------------

compartment_violations[cid] := v if {
	some c in compartments
	cid := c.compartment_id
	v := {code | some code in all_codes; compartment_check_failed(c, code)}
}

all_codes := {
	"stall_definition_not_met",
	"usable_area_insufficient",
	"bedded_lying_area_insufficient",
	"lying_area_not_closed",
	"bedding_insufficient",
	"no_group_housing",
	"no_bedded_system",
	"partial_areas_closed_off",
	"usable_area_not_paved",
}

compartment_check_failed(c, "stall_definition_not_met") if not building_ok(c)

compartment_check_failed(c, "usable_area_insufficient") if not total_area_ok(c)

compartment_check_failed(c, "bedded_lying_area_insufficient") if not bedded_area_ok(c)

compartment_check_failed(c, "lying_area_not_closed") if not closed_lying_area_ok(c)

compartment_check_failed(c, "bedding_insufficient") if not bedding_ok(c)

# O6_21-GROUP-01: Haltung in Gruppen auf eingestreuten Systemen.
compartment_check_failed(c, "no_group_housing") if not c.group_housing

compartment_check_failed(c, "no_bedded_system") if not c.bedded_system

# O6_21-SPACE-02: Absperren von Teilflächen nur für Routinearbeiten zulässig.
compartment_check_failed(c, "partial_areas_closed_off") if {
	object.get(c, "partial_areas_closed_except_routine_work", false)
}

# O6_21-SPACE-02: nutzbare Gesamtfläche nur befestigte Flächen (betoniert oder perforiert) mit ständigem Zugang.
compartment_check_failed(c, "usable_area_not_paved") if {
	object.get(c, "usable_area_includes_unpaved_or_inaccessible", false)
}

noncompliant_compartments contains cid if {
	some cid, v in compartment_violations
	count(v) > 0
}

# --- Belegungsplan (Kapitel 6.3.2, bis Antragsjahr 2024) ---------------------------------------

# O6_21-PLAN-02: maximal mögliche Anzahl je Gewichtsklasse aus dem Mindestplatzbedarf.
max_occupancy(area) := {row.weight_class: n |
	some row in lib.tables.space_requirements
	n := floor((area / row.total_area_m2_per_animal) + 0.000001)
}

occupancy_plan[cid] := max_occupancy(c.usable_paved_area_m2) if {
	some c in compartments
	cid := c.compartment_id
}

# O6_21-PLAN-01: Stallskizze und Belegungsplan bis einschließlich Antragsjahr 2024; ab 2025 entfallen.
stall_sketch_required if lib.year <= lib.deadlines.stall_sketch_required_until_year

stall_sketch_missing if {
	stall_sketch_required
	not object.get(lib.measure_input, "stall_sketch_and_occupancy_plan_available", false)
}
