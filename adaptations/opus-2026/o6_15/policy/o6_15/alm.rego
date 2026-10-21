# Almbezogene Förderbedingungen: Alm-Definition, Bestoßungsdauer, Versorgung,
# Übernachtung, Hirtinnen/Hirten und Herdenschutzhunde.
package oepul.o6_15

alm_animals(alm) := object.get(alm, "animals", [])

# ---------------------------------------------------------------------------
# Alm-Definition (Kapitel 5.1 Informationsblatt, Punkt 2.15 iVm 1.6.2.1 SRL)
# ---------------------------------------------------------------------------

alm_definition_met(alm) if {
	object.get(alm, "alpine_pasture_area_ha", 0) > 0
	object.get(alm, "in_alm_cadastre_or_alm_area", false) == true
	object.get(alm, "managed_from_home_farm", false) == false
	object.get(alm, "visible_boundary_to_grassland", false) == true
}

alm_in_austria(alm) if object.get(alm, "in_austria", true) == true

# ---------------------------------------------------------------------------
# Mindestbestoßungsdauer pro Alm 60 Tage (Kapitel 6.1)
# ---------------------------------------------------------------------------

alm_min_stocking_met(alm) if {
	some a in alm_animals(alm)
	recognized_days_this_alm(a) >= params.min_stocking_days_per_alm
}

alm_min_stocking_met(alm) if {
	object.get(alm, "stocking_days", 0) >= params.min_stocking_days_per_alm
}

# ---------------------------------------------------------------------------
# Versorgung der Tiere (Kapitel 6.2)
# ---------------------------------------------------------------------------

care_requirements := [
	"daily_care",
	"night_care_when_required",
	"herding_substantial_part_of_day",
	"sufficient_water_supply",
	"animal_care",
	"treatment_of_diseases_and_injuries",
	"safety_measures",
	"site_adapted_grazing_management",
]

missing_care_requirements(alm) := {req |
	some req in care_requirements
	object.get(object.get(alm, "care", {}), req, false) != true
}

care_only_inspection(alm) if object.get(object.get(alm, "care", {}), "inspection_only", false) == true

alm_care_ok(alm) if {
	count(missing_care_requirements(alm)) == 0
	not care_only_inspection(alm)
}

# ---------------------------------------------------------------------------
# Übernachtungsmöglichkeit (Kapitel 6.3)
# ---------------------------------------------------------------------------

alm_accommodation_ok(alm) if object.get(alm, "herder_accommodation_available", false) == true

# Nächtigung nicht zwingend, wenn den Verpflichtungen täglich nachgekommen wird
overnight_stay_required(alm) if {
	object.get(object.get(alm, "care", {}), "daily_care", false) != true
}

# ---------------------------------------------------------------------------
# Hirtinnen und Hirten: eine Person darf nur eine Alm behirten
# ---------------------------------------------------------------------------

herder_alm_pairs := [[h.person_id, alm.alm_id] |
	some alm in alms
	some h in object.get(alm, "herders", [])
]

herder_alm_count(person_id) := count({alm_id |
	some pair in herder_alm_pairs
	pair[0] == person_id
	alm_id := pair[1]
})

duplicate_herders contains person_id if {
	some pair in herder_alm_pairs
	person_id := pair[0]
	herder_alm_count(person_id) > 1
}

herder_valid(_, h) if {
	not h.person_id in duplicate_herders
	object.get(h, "herds_other_alm", false) == false
}

# Bei Mehrfachnennung wird die Person nur der ersten Alm (nach alm_id) zugerechnet
herder_valid(alm, h) if {
	h.person_id in duplicate_herders
	object.get(h, "herds_other_alm", false) == false
	first_alm := min({pair[1] | some pair in herder_alm_pairs; pair[0] == h.person_id})
	alm.alm_id == first_alm
}

valid_herder_count(alm) := count({h.person_id |
	some h in object.get(alm, "herders", [])
	herder_valid(alm, h)
})

# ---------------------------------------------------------------------------
# Behirtung aller Tiere je beantragter Tierkategorie (Kapitel 4)
# ---------------------------------------------------------------------------

unherded_animals_in_claimed_category(alm) := {object.get(a, "animal_id", "unknown") |
	some a in alm_animals(alm)
	animal_in_claimed_category(alm, a)
	not animal_is_herded(a)
}

invalid_claimed_categories(alm) := {c |
	some c in object.get(alm, "herded_categories", [])
	not c in {hc.id | some hc in params.herding_categories}
}

# ---------------------------------------------------------------------------
# Herdenschutzhunde (Kapitel 6.4)
# ---------------------------------------------------------------------------

dog_requirements := [
	"certified_herd_protection_dog",
	"certificate_available_on_farm",
	"liability_insurance",
	"present_whole_alpine_period",
	"permanent_herd_member",
	"day_and_night_with_herd",
	"works_without_direct_commands",
	"entered_in_auftriebsliste",
]

missing_dog_requirements(dog) := {req |
	some req in dog_requirements
	object.get(dog, req, false) != true
}

dog_alm_pairs := [[d.dog_id, alm.alm_id] |
	some alm in alms
	some d in object.get(alm, "herd_protection_dogs", [])
]

duplicate_dogs contains dog_id if {
	some pair in dog_alm_pairs
	dog_id := pair[0]
	count({p[1] | some p in dog_alm_pairs; p[0] == dog_id}) > 1
}

dog_eligible(_, dog) if {
	count(missing_dog_requirements(dog)) == 0
	object.get(dog, "days_on_this_alm", 0) >= params.min_dog_days_on_one_alm
	object.get(dog, "claimed_on_other_alm", false) == false
	not dog.dog_id in duplicate_dogs
}

eligible_dogs(alm) := {d.dog_id |
	some d in object.get(alm, "herd_protection_dogs", [])
	dog_eligible(alm, d)
}

paid_dog_count(alm) := min_of(count(eligible_dogs(alm)), rates.limits.max_herd_protection_dogs_per_alm)

# ---------------------------------------------------------------------------
# Almbezogene Prämienfähigkeit
# ---------------------------------------------------------------------------

alm_failures(alm) := {check.rule_id |
	some check in alm_checks(alm)
	check.ok == false
}

default alm_definition_met(_) := false

default alm_in_austria(_) := false

default alm_min_stocking_met(_) := false

default alm_care_ok(_) := false

default alm_accommodation_ok(_) := false

default alm_has_valid_herder(_) := false

default alm_not_double_funded(_) := false

alm_has_valid_herder(alm) if valid_herder_count(alm) > 0

alm_not_double_funded(alm) if object.get(alm, "herding_funded_by_other_public_title", false) == false

alm_checks(alm) := [
	{"rule_id": "o6_15.def.alm", "ok": alm_definition_met(alm)},
	{"rule_id": "o6_15.gen.location_austria", "ok": alm_in_austria(alm)},
	{"rule_id": "o6_15.obl.min_stocking_per_alm", "ok": alm_min_stocking_met(alm)},
	{"rule_id": "o6_15.obl.daily_care", "ok": alm_care_ok(alm)},
	{"rule_id": "o6_15.obl.accommodation", "ok": alm_accommodation_ok(alm)},
	{"rule_id": "o6_15.app.herder_count", "ok": alm_has_valid_herder(alm)},
	{"rule_id": "o6_15.gen.no_double_funding", "ok": alm_not_double_funded(alm)},
]

alm_eligible(alm) if count(alm_failures(alm)) == 0
