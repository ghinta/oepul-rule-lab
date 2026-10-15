package oepul.o6_17.agl

# Optionaler Zuschlag für artenreiches Grünland (Code AGL): Definition,
# Kennartenerhebung und Dokumentation (Informationsblatt Kapitel 5.2, 6.6,
# 7, 9, 10; SRL 2.17; Anhang H).

import data.oepul.o6_17.common

kennarten := data.o6_17_tables.kennarten

# Nachschlagetabelle: ID, deutscher Name (auch ohne Klammerzusatz) und
# wissenschaftliche Namen werden auf die Kennart-ID abgebildet.
name_variants(k) := {n |
	some raw in array.concat(
		[k.id, k.name_de, trim_space(split(k.name_de, "(")[0])],
		k.scientific_names,
	)
	n := common.normalize(raw)
}

kennart_lookup := {n: k.id |
	some k in kennarten.species
	some n in name_variants(k)
}

section_kennarten(sec) := {kennart_lookup[common.normalize(s)] | some s in object.get(sec, "species_found", [])}

survey(p) := object.get(p, ["o6_17", "agl_survey"], {})

sections(p) := object.get(survey(p), "sections", [])

# In jedem Abschnitt mindestens 5 Kennarten.
all_sections_min_species(p) if {
	count(sections(p)) > 0
	every sec in sections(p) {
		count(section_kennarten(sec)) >= kennarten.minimum_species_per_section
	}
}

surveyed_in_year(p) if {
	some d in object.get(survey(p), "survey_dates", [])
	startswith(d, sprintf("%d-", [common.year]))
}

# Erfassungsbogen und Skizze oder geolokalisierte Fotos (AMA MFA Fotos App).
documentation_ok(p) if {
	object.get(survey(p), "documented", false) == true
	object.get(survey(p), "sketch_documented", false) == true
}

documentation_ok(p) if object.get(survey(p), "photo_documented", false) == true

first_use_is_mowing(p) if object.get(survey(p), "first_use_is_mowing", false) == true

requires_code_and_survey(p) if common.use_type_info(p).agl_mode == "code_agl_and_survey"

automatic(p) if common.use_type_info(p).agl_mode == "automatic"

survey_conditions_met(p) if {
	"AGL" in common.codes(p)
	all_sections_min_species(p)
	surveyed_in_year(p)
	documentation_ok(p)
	first_use_is_mowing(p)
}

qualifies(p) if automatic(p)

qualifies(p) if {
	requires_code_and_survey(p)
	survey_conditions_met(p)
}

failed_conditions(p) := {c |
	some c in ["code_agl", "min_5_kennarten_per_section", "survey_in_year", "documentation", "first_use_mowing"]
	not condition_ok(p, c)
}

condition_ok(p, "code_agl") if "AGL" in common.codes(p)

condition_ok(p, "min_5_kennarten_per_section") if all_sections_min_species(p)

condition_ok(p, "survey_in_year") if surveyed_in_year(p)

condition_ok(p, "documentation") if documentation_ok(p)

condition_ok(p, "first_use_mowing") if first_use_is_mowing(p)

# Mit AGL gekennzeichnete Schläge, die die Bedingungen nicht erfüllen.
violations contains v if {
	some p in common.grassland_parcels
	requires_code_and_survey(p)
	"AGL" in common.codes(p)
	missing := failed_conditions(p)
	count(missing) > 0
	v := {
		"rule_id": "o6_17.agl.survey_and_documentation",
		"parcel_id": p.parcel_id,
		"failed_conditions": missing,
	}
}

# AGL-Code auf Schlagnutzungsarten ohne Zuschlagsmöglichkeit (z. B. Dauerweide,
# Bergmähder); einmähdige Wiesen und Streuwiesen benötigen keinen Code.
violations contains v if {
	some p in common.grassland_parcels
	"AGL" in common.codes(p)
	common.use_type_info(p).agl_mode == "none"
	v := {
		"rule_id": "o6_17.agl.code_only_on_maehwiesen",
		"parcel_id": p.parcel_id,
		"failed_conditions": {"use_type_not_eligible_for_code_agl"},
	}
}
