# Zugangs- und Teilnahmevoraussetzungen (Informationsblatt Kap. 3, 4; Allgemeine Teilnahmebedingungen 5.2, 5.3, 5.6; SRL 1.4, 1.6.1, 2.20.3).
package oepul.o6_20.eligibility

import data.oepul.o6_20.common
import data.oepul.o6_20.rgve

gc := data.o6_20.general_conditions

applicant := object.get(input, ["farm", "applicant"], {})

participation := object.get(input, ["farm", "oepul_participation"], {})

# --- Förderwerbende Personen -------------------------------------------------

applicant_form_eligible if applicant.legal_form in gc.eligible_applicant_forms

violations contains v if {
	applicant.legal_form
	not applicant_form_eligible
	v := {
		"rule_id": "o6_20.gen.applicant.legal_form",
		"severity": "contract_invalid",
		"message": sprintf("Rechtsform %v ist keine zulässige förderwerbende Person", [applicant.legal_form]),
	}
}

missing_inputs contains "farm.applicant.legal_form" if not applicant.legal_form

violations contains v if {
	some field in ["is_active_farmer", "has_agricultural_activity", "farms_in_own_name_and_account"]
	object.get(applicant, field, true) == false
	v := {
		"rule_id": "o6_20.gen.applicant.active_farmer",
		"severity": "contract_invalid",
		"message": sprintf("Voraussetzung nicht erfüllt: %s", [field]),
	}
}

# Gebietskörperschaften bzw. Beteiligung > 25 % sind grundsätzlich ausgeschlossen, außer bei
# den in data.o6_20.general_conditions.public_body_permitted_measures genannten Maßnahmen.
public_body_involved if object.get(applicant, "is_public_body", false) == true

public_body_involved if object.get(applicant, "public_body_share_percent", 0) > gc.public_body_max_share_percent

measure_permits_public_body(measure_key, y) if {
	some m in gc.public_body_permitted_measures
	m.measure_key == measure_key
	year_in_range(y, m.from_year, m.to_year)
}

year_in_range(y, from, to) if {
	from_ok(y, from)
	to_ok(y, to)
}

from_ok(_, from) if from == null

from_ok(y, from) if y >= from

to_ok(_, to) if to == null

to_ok(y, to) if y <= to

public_body_permitted if measure_permits_public_body(common.params.measure_key, common.year)

violations contains v if {
	public_body_involved
	not public_body_permitted
	v := {
		"rule_id": "o6_20.gen.applicant.public_body",
		"severity": "contract_invalid",
		"message": "Gebietskörperschaft bzw. bestimmender Einfluss einer Gebietskörperschaft: Maßnahme nicht zugänglich",
	}
}

# --- Betriebsmindestgröße im ersten ÖPUL-Teilnahmejahr ----------------------

first_oepul_year if common.year == participation.first_oepul_year

min_farm_size_met if {
	object.get(input, ["land", "protected_cultivation_area_ha"], 0) >= gc.min_farm_size_first_year.protected_cultivation_ha
}

min_farm_size_met if {
	object.get(input, ["land", "total_area_ha"], 0) >= gc.min_farm_size_first_year.agricultural_area_ha
}

violations contains v if {
	first_oepul_year
	not min_farm_size_met
	v := {
		"rule_id": "o6_20.gen.min_farm_size_first_year",
		"severity": "contract_invalid",
		"message": "Betriebsmindestgröße im ersten ÖPUL-Teilnahmejahr (1,50 ha bzw. 0,50 ha geschützter Anbau) nicht erreicht",
	}
}

missing_inputs contains "farm.oepul_participation.first_oepul_year" if not participation.first_oepul_year

# --- Mindestteilnahme 2,00 RGVE ---------------------------------------------

min_participation_met if rgve.total_rgve >= common.params.min_participation_rgve

violations contains v if {
	count(common.categories) > 0
	not min_participation_met
	v := {
		"rule_id": "o6_20.min_participation.rgve",
		"severity": "contract_invalid",
		"message": sprintf("Durchschnittlich %.2f RGVE im Weidezeitraum; mindestens %.2f RGVE über alle beantragten Kategorien erforderlich – Vertrag erlischt", [rgve.total_rgve, common.params.min_participation_rgve]),
	}
}

# --- Teilnahmefähige Tierkategorien -----------------------------------------

violations contains v if {
	some code in common.applied_category_codes
	not common.category_defs[code]
	v := {
		"rule_id": "o6_20.categories.closed_list",
		"severity": "category_invalid",
		"category_code": code,
		"message": sprintf("Tierkategorie %v ist in der Maßnahme nicht wählbar", [code]),
	}
}

violations contains v if {
	some code in common.duplicate_category_codes
	v := {
		"rule_id": "o6_20.categories.closed_list",
		"severity": "input_error",
		"category_code": code,
		"message": sprintf("Tierkategorie %v mehrfach angegeben", [code]),
	}
}

violations contains v if {
	some a in common.animals
	not rgve.class_allowed(a.category_code, a.rgve_class)
	v := {
		"rule_id": "o6_20.rgve.key",
		"severity": "no_premium",
		"category_code": a.category_code,
		"animal_id": a.animal_id,
		"message": sprintf("RGVE-Klasse %v ist für Kategorie %v nicht zulässig", [a.rgve_class, a.category_code]),
	}
}

violations contains v if {
	some c in common.categories
	some e in object.get(c, "count_entries", [])
	not rgve.class_allowed(c.category_code, e.rgve_class)
	v := {
		"rule_id": "o6_20.rgve.key",
		"severity": "no_premium",
		"category_code": c.category_code,
		"message": sprintf("RGVE-Klasse %v ist für Kategorie %v nicht zulässig", [e.rgve_class, c.category_code]),
	}
}

# --- Mindestteilnahme je Kategorie (Kap. 3.2) --------------------------------

supplement_applied(c) if object.get(c, "supplement_150_applied", false) == true

required_presence_days(c) := common.params.min_grazing_days_supplement if supplement_applied(c)

else := common.params.min_grazing_days_base

presence_ok(c) if object.get(c, "days_with_min_one_animal_present", 0) >= required_presence_days(c)

# Weibliche Rinder: beide Kategorien beantragt, ein konkretes Tier erreicht über beide Kategorien die Tage.
presence_ok(c) if {
	pair := common.catalog.female_cattle_category_pair
	c.category_code in pair
	every p in pair {
		p in common.applied_category_codes
	}
	object.get(c, "female_cattle_combined_single_animal_days", 0) >= required_presence_days(c)
}

violations contains v if {
	some c in common.categories
	common.category_defs[c.category_code]
	not presence_ok(c)
	v := {
		"rule_id": "o6_20.min_participation.category_presence",
		"severity": "category_invalid",
		"category_code": c.category_code,
		"message": sprintf("Kein Tier der Kategorie (auch nicht durch Ersatztiere) %d Tage im Weidezeitraum am Betrieb", [required_presence_days(c)]),
	}
}

# Ohne prämienfähiges Tier erlischt der Vertrag für die Kategorie (Kap. 7).
violations contains v if {
	some code in common.applied_category_codes
	common.category_defs[code]
	rgve.category_rgve(code) <= 0
	v := {
		"rule_id": "o6_20.application.category_lapse_no_animal",
		"severity": "category_invalid",
		"category_code": code,
		"message": "Kein prämienfähiges Tier in der Kategorie – Vertrag für die Kategorie erlischt",
	}
}

category_valid(code) if {
	common.category_defs[code]
	c := common.category_entry(code)
	presence_ok(c)
	rgve.category_rgve(code) > 0
}

# --- Haltungsort der Tiere --------------------------------------------------

violations contains v if {
	some a in common.animals
	object.get(a, "held_in_austria", true) == false
	v := {
		"rule_id": "o6_20.gen.animals_in_austria",
		"severity": "no_premium",
		"category_code": a.category_code,
		"animal_id": a.animal_id,
		"message": "Tier wird nicht in Österreich gehalten – nicht prämienfähig",
	}
}

# --- Betriebsstrukturwechsel bei Rindern ------------------------------------

review_items contains r if {
	some a in common.animals
	common.regime(a.category_code) == "cattle"
	common.is_date(object.get(a, "structure_change_date", null))
	r := {
		"rule_id": "o6_20.min_participation.structure_change_cattle",
		"animal_id": a.animal_id,
		"message": sprintf("Rind ab %v der neuen Betriebsstruktur zugerechnet; für die ursprüngliche Struktur nicht mehr prämienfähig", [a.structure_change_date]),
	}
}
