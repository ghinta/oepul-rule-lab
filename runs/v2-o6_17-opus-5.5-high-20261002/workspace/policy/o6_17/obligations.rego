# o6_17 Förderverpflichtungen
#
#   Verzicht auf Grünlandumbruch, erlaubte Geräte, Ausnahmen, Weiterbildung,
#   Bodenuntersuchungen und Dokumentation artenreiches Grünland
#   (Merkblatt o6_17 Kap. 5, 6, 9; SRL 2.17; SRL Anhang H).
package oepul.o6_17

import rego.v1

thresholds := tables.thresholds

# ---------------------------------------------------------------------------
# Grünlandumbruch (Merkblatt 5.1, 6.1, 6.3; SRL 2.17)
# ---------------------------------------------------------------------------

minor_deviation_codes := {m.code | some m in tables.lists.minor_deviation_examples}

event_in_contract(e) if {
	contract_period
	e.event_date >= contract_period.contract_start
	e.event_date <= contract_period.contract_end
}

grassland_breaking_events contains {"parcel_id": p.parcel_id, "event": e} if {
	some p in parcels
	is_grassland(p)
	some e in object.get(p, ["oepul", "grassland_breaking_events"], [])
	event_in_contract(e)
}

# Ausnahme: Sanierung nach Schädlingsbefall, Notwendigkeit dokumentiert.
breaking_permitted(_, e) if {
	e.reason == "pest_damage_renovation"
	object.get(e, "documentation_kept", false) == true
}

# Ausnahme: Neueinsaat regionaler Saatgutmischung für Biodiversitätsflächen (UBB/BIO).
breaking_permitted(p, e) if {
	e.reason == "div_regional_seed_mixture"
	combination_requirement_met
	"DIVRS" in parcel_codes(p)
}

# Geringfügige Abweichungen bis 300 m² je Einzelfläche gelten nicht als Umbruch.
breaking_permitted(_, e) if {
	e.reason in minor_deviation_codes
	e.area_m2 <= thresholds.minor_deviation_max_m2
}

# Aufschüttungen > 300 m² nur mit vorab eingeholter landesrechtlicher Bewilligung.
breaking_permitted(_, e) if {
	e.reason == "fill_up"
	e.area_m2 > thresholds.minor_deviation_max_m2
	object.get(e, "state_permit_obtained", false) == true
}

parcel_by_id := {p.parcel_id: p | some p in parcels}

ploughing_violations contains {
	"rule_id": "O617-OBL-NO-PLOUGHING",
	"parcel_id": item.parcel_id,
	"event_date": item.event.event_date,
	"message": "Unzulässiger Grünlandumbruch während des Vertragszeitraums.",
} if {
	some item in grassland_breaking_events
	not breaking_permitted(parcel_by_id[item.parcel_id], item.event)
}

ploughing_violations contains {
	"rule_id": "O617-OBL-NO-SWAP",
	"parcel_id": null,
	"event_date": null,
	"message": "Acker-Grünland-Flächentausch ist nicht möglich.",
} if {
	in_contract_period
	object.get(measure, "arable_grassland_swap", false) == true
}

# Aufschüttung ohne Nutzung im betroffenen Jahr: Beantragung als "Sonstige Grünlandflächen".
parcel_used_this_year(p) if count(object.get(p, ["operations", "cutting_dates"], [])) > 0

parcel_used_this_year(p) if object.get(p, ["oepul", "grazed_fully"], false) == true

fill_up_declaration_violations contains {
	"rule_id": "O617-DEF-FILL-UP-UNUSED",
	"parcel_id": p.parcel_id,
	"message": "Aufschüttung ohne Nutzung im Jahr: Fläche ist als 'Sonstige Grünlandflächen' zu beantragen.",
} if {
	some p in parcels
	is_grassland(p)
	some e in object.get(p, ["oepul", "grassland_breaking_events"], [])
	e.reason == "fill_up"
	startswith(e.event_date, sprintf("%d-", [year]))
	not parcel_used_this_year(p)
	parcel_field_use(p) != "sonstige_gruenlandflaechen"
}

# ---------------------------------------------------------------------------
# Umbruchslose Grünlanderneuerung – zulässige Geräte (Merkblatt 6.2)
# ---------------------------------------------------------------------------

allowed_renewal_equipment := {e.id | some e in tables.lists.allowed_renewal_equipment}

renewal_equipment_violations contains {
	"rule_id": "O617-OBL-RENEWAL-EQUIPMENT",
	"parcel_id": p.parcel_id,
	"equipment": tool,
	"message": "Für die umbruchslose Grünlanderneuerung nicht zulässiges Gerät.",
} if {
	in_contract_period
	some p in parcels
	is_grassland(p)
	some tool in object.get(p, ["oepul", "renewal_equipment_used"], [])
	not tool in allowed_renewal_equipment
}

# ---------------------------------------------------------------------------
# Weiterbildung (Merkblatt 6.4; SRL 2.17)
# ---------------------------------------------------------------------------

training := object.get(measure, "training", {})

training_courses := object.get(training, "courses", [])

training_roles := {r.code | some r in tables.lists.training_attendee_roles}

attendee_left_before_deadline(c) if {
	left := object.get(c, "attendee_left_farm_date", null)
	is_string(left)
	left < thresholds.training_deadline
}

creditable_course(c) if {
	c.course_date >= thresholds.training_creditable_from
	c.course_date <= thresholds.training_deadline
	c.provider_recognized == true
	c.attendee_role in training_roles
	object.get(c, "credited_to_other_farm", false) == false
	object.get(c, "credited_to_other_commitment", false) == false
	not attendee_left_before_deadline(c)
}

training_hours := sum([c.hours | some c in training_courses; creditable_course(c)])

training_met if training_hours >= thresholds.training_min_hours

obligation_deadline_passed if year >= 2025

training_violations contains {
	"rule_id": "O617-OBL-TRAINING",
	"message": "Weiterbildung Grünlandbewirtschaftung im Mindestausmaß von 5 Stunden nicht bis 31.12.2025 absolviert.",
} if {
	in_contract_period
	obligation_deadline_passed
	not training_met
}

training_violations contains {
	"rule_id": "O617-OBL-TRAINING-CONFIRMATION",
	"message": "Kursbesuchsbestätigung trotz Aufforderung nicht an die AMA übermittelt.",
} if {
	object.get(training, "confirmation_requested", false) == true
	object.get(training, "confirmation_submitted", false) == false
	object.get(training, "transmitted_by_provider", false) == false
}

# ---------------------------------------------------------------------------
# Bodenuntersuchungen (Merkblatt 6.5; SRL 2.17)
# ---------------------------------------------------------------------------

gloez_ineligible_codes := {g.code | some g in tables.lists.gloez_conversion_bans_ineligible}

parcel_gloez_ineligible(p) if object.get(p, ["oepul", "gloez_conversion_ban"], "none") in gloez_ineligible_codes

# Ausgangsbasis: Grünland < 18 % gemäß MFA 2025 ohne GLÖZ 2/4/9-Flächen.
soil_sample_base_ha := max([0, measure.soil_sample_base_mfa2025_grassland_lt18_ha - object.get(measure, "soil_sample_base_gloez_excluded_ha", 0)]) if {
	is_number(object.get(measure, "soil_sample_base_mfa2025_grassland_lt18_ha", null))
}

# Ersatzweise Berechnung aus den Schlägen des Mehrfachantrags 2025.
soil_sample_base_ha := sum([p.area_ha |
	some p in parcels
	is_grassland(p)
	is_number(p.slope_percent)
	p.slope_percent < tables.premium_rates.base_slope_max_exclusive_percent
	not parcel_gloez_ineligible(p)
]) if {
	not is_number(object.get(measure, "soil_sample_base_mfa2025_grassland_lt18_ha", null))
	year == thresholds.soil_sample_reference_mfa_year
}

# Pro angefangene 5 ha mindestens eine Bodenprobe.
required_soil_samples := ceil(soil_sample_base_ha / thresholds.soil_sample_area_unit_ha)

required_soil_parameters := {s.code | some s in tables.lists.soil_sample_parameters}

soil_methods := {s.code | some s in tables.lists.soil_sample_methods}

creditable_soil_sample(s) if {
	s.sample_date >= thresholds.soil_sample_creditable_from
	s.lab_submission_date <= thresholds.soil_sample_deadline
	s.lab_accredited == true
	s.method in soil_methods
	every param in required_soil_parameters {
		param in s.parameters
	}
	object.get(s, "received_with_transferred_area", false) == false
}

soil_samples := object.get(measure, "soil_samples", [])

creditable_soil_sample_count := count([s | some s in soil_samples; creditable_soil_sample(s)])

soil_sampling_met if creditable_soil_sample_count >= required_soil_samples

soil_sampling_violations contains {
	"rule_id": "O617-OBL-SOIL-SAMPLES",
	"required": required_soil_samples,
	"creditable": creditable_soil_sample_count,
	"message": "Erforderliche Anzahl an Bodenproben nicht bis 31.12.2025 an ein akkreditiertes Labor übermittelt.",
} if {
	in_contract_period
	obligation_deadline_passed
	not soil_sampling_met
}

soil_sampling_violations contains {
	"rule_id": "O617-DOC-SOIL-RESULTS-GIS",
	"required": required_soil_samples,
	"creditable": creditable_soil_sample_count,
	"message": "Ergebnisse angerechneter Bodenproben nicht im INVEKOS-GIS erfasst.",
} if {
	some s in soil_samples
	creditable_soil_sample(s)
	object.get(s, "recorded_in_invekos_gis", false) == false
}

# ---------------------------------------------------------------------------
# Artenreiches Grünland – Kennarten und Dokumentation (Merkblatt 6.6, 9, 10; Anhang H)
# ---------------------------------------------------------------------------

kennarten_ids := {k.species_id | some k in tables.kennarten.species}

species_rich(p) := object.get(p, ["oepul", "species_rich"], {})

section_species_count(section) := count({sp |
	some sp in object.get(section, "indicator_species", [])
	sp in kennarten_ids
})

agl_species_requirement_met(p) if {
	sections := object.get(species_rich(p), "survey_sections", [])
	count(sections) > 0
	every section in sections {
		section_species_count(section) >= tables.kennarten.minimum_species_per_section
	}
}

agl_documentation_complete(p) if {
	object.get(species_rich(p), "survey_documented", false) == true
	object.get(species_rich(p), "sketch_documented", false) == true
	count(object.get(species_rich(p), "survey_dates", [])) >= 1
}

agl_first_use_mowing(p) if object.get(species_rich(p), "first_use_mowing", false) == true

agl_code_required(p) if field_use_types[parcel_field_use(p)].agl_mode == "code_agl_required"

agl_violations contains {
	"rule_id": "O617-AGL-SPECIES",
	"parcel_id": p.parcel_id,
	"message": "Als AGL beantragter Schlag: nicht in jedem Abschnitt mindestens 5 Kennarten.",
} if {
	some p in parcels
	"AGL" in parcel_codes(p)
	agl_code_required(p)
	not agl_species_requirement_met(p)
}

agl_violations contains {
	"rule_id": "O617-AGL-FIRST-USE-MOWING",
	"parcel_id": p.parcel_id,
	"message": "Als AGL beantragter Schlag: erste Nutzung nicht als Mahd.",
} if {
	some p in parcels
	"AGL" in parcel_codes(p)
	agl_code_required(p)
	not agl_first_use_mowing(p)
}

agl_violations contains {
	"rule_id": "O617-AGL-DOCUMENTATION",
	"parcel_id": p.parcel_id,
	"message": "Als AGL beantragter Schlag: Erhebung/Begehung, Erfassungsbogen oder Skizze nicht dokumentiert.",
} if {
	some p in parcels
	"AGL" in parcel_codes(p)
	agl_code_required(p)
	not agl_documentation_complete(p)
}

agl_violations contains {
	"rule_id": "O617-AGL-CODE-FIELD-USE",
	"parcel_id": p.parcel_id,
	"message": "Code AGL nur auf Mähwiese/-weide zwei bzw. drei und mehr Nutzungen.",
} if {
	some p in parcels
	"AGL" in parcel_codes(p)
	not agl_code_required(p)
}
