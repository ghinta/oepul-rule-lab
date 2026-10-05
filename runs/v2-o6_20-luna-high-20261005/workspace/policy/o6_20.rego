package oepul.o6_20

import rego.v1

default decision := {
	"eligible": false,
	"violations": [],
	"categories": [],
	"premium": {},
}

o6_20 := object.get(object.get(object.get(input, "farm", {}), "livestock", {}), "o6_20", [])
application := object.get(input, "o6_20_application", {})
context := object.get(input, "context", {})
farm := object.get(input, "farm", {})

category_records contains c if {
	c := o6_20[_]
	object.get(c, "participating", false) == true
}

category_config(c) := data.categories[c.category] if {
	data.categories[c.category]
	object.get(data.categories[c.category], "measure_eligible", false) == true
}

category_threshold(c) := 150 if {
	object.get(c, "optional_150_days", false) == true
}

category_threshold(c) := 120 if {
	object.get(c, "optional_150_days", false) == false
}

category_minimum_met(c) if {
	object.get(c, "weide_days", 0) >= category_threshold(c)
}

category_minimum_met(c) := false if {
	object.get(c, "weide_days", 0) < category_threshold(c)
}

category_species(c) := category_config(c).species

total_rgve := sum([object.get(c, "average_rgve", 0) | c := category_records[_]])

has_valid_application if {
	object.get(application, "measure_requested", false) == true
	object.get(application, "application_date_before_31_december", false) == true
}

default has_valid_application := false

report_satisfied(c) if {
	object.get(c, "correction_or_report", false) == true
}

sheep_or_goat(c) if {
	species := category_species(c)
	species in {"sheep", "goats"}
}

equid_or_camel(c) if {
	species := category_species(c)
	species in {"equids", "camelids"}
}

violations contains {
	"rule_id": "o620-valid-categories",
	"message": sprintf("Unbekannte Tierkategorie: %v", [c.category]),
} if {
	c := category_records[_]
	not category_config(c)
}

violations contains {
	"rule_id": "o620-minimum-rgve",
	"message": sprintf("Mindestens 2,00 RGVE erforderlich; ermittelt: %.3f", [total_rgve]),
} if {
	total_rgve < 2
}

violations contains {
	"rule_id": "o620-minimum-category-presence",
	"message": sprintf("Kategorie %v benötigt mindestens ein teilnehmendes/prämienfähiges Tier", [c.category]),
} if {
	c := category_records[_]
	object.get(c, "animal_count", 0) < 1
}

violations contains {
	"rule_id": "o620-all-category-animals",
	"message": sprintf("Nicht alle Tiere der Kategorie %v nehmen teil", [c.category]),
} if {
	c := category_records[_]
	object.get(c, "all_category_animals_participate", false) == false
}

violations contains {
	"rule_id": "o620-weide-period",
	"message": sprintf("Kategorie %v liegt nicht vollständig im Weidezeitraum 1. April bis 31. Oktober", [c.category]),
} if {
	c := category_records[_]
	object.get(c, "weide_period_valid", false) == false
}

violations contains {
	"rule_id": "o620-minimum-weide-days",
	"message": sprintf("Kategorie %v erreicht die erforderlichen %v Weidetage nicht", [c.category, category_threshold(c)]),
} if {
	c := category_records[_]
	not category_minimum_met(c)
}

violations contains {
	"rule_id": "o620-groundfeed-grazing",
	"message": sprintf("Grundfutterbedarf der Kategorie %v wird nicht überwiegend durch Beweidung gedeckt", [c.category]),
} if {
	c := category_records[_]
	object.get(c, "groundfeed_predominantly_grazing", false) == false
}

violations contains {
	"rule_id": "o620-substantial-day-grazing",
	"message": sprintf("Kategorie %v wird nicht über einen wesentlichen Teil des Tages beweidet", [c.category]),
} if {
	c := category_records[_]
	object.get(c, "grazing_substantial_part_of_day", false) == false
}

violations contains {
	"rule_id": "o620-water-shelter",
	"message": sprintf("Tränke oder Unterstell-/rasch-verbringbare Stallmöglichkeit für %v fehlt", [c.category]),
} if {
	c := category_records[_]
	object.get(c, "water_access", false) == false
}

violations contains {
	"rule_id": "o620-water-shelter",
	"message": sprintf("Unterstellmöglichkeit für %v fehlt", [c.category]),
} if {
	c := category_records[_]
	object.get(c, "shelter_access", false) == false
}

violations contains {
	"rule_id": "o620-diary",
	"message": sprintf("Weidetagebuch für %v ist nicht vollständig", [c.category]),
} if {
	c := category_records[_]
	object.get(c, "weide_diary_complete", false) == false
}

violations contains {
	"rule_id": "o620-missed-days-report",
	"message": sprintf("Nichterreichung der Mindestweidedauer für %v ist nicht gemeldet/korrigiert", [c.category]),
} if {
	c := category_records[_]
	not category_minimum_met(c)
	not report_satisfied(c)
}

violations contains {
	"rule_id": "o620-sheep-goat-entry-7-days",
	"message": sprintf("Zugangsmeldung für %v wurde nicht innerhalb von 7 Tagen vorgenommen", [c.category]),
} if {
	c := category_records[_]
	sheep_or_goat(c)
	object.get(c, "entry_after_april", false) == true
	object.get(c, "entry_report_within_7_days", false) == false
}

violations contains {
	"rule_id": "o620-sheep-goat-exit-7-days",
	"message": sprintf("Abgangsmeldung für %v wurde nicht innerhalb von 7 Tagen vorgenommen", [c.category]),
} if {
	c := category_records[_]
	sheep_or_goat(c)
	object.get(c, "exit_after_april", false) == true
	object.get(c, "exit_report_within_7_days", false) == false
}

violations contains {
	"rule_id": "o620-sheep-goat-pasture-not-exit",
	"message": sprintf("Vorübergehender Aufenthalt von %v auf Alm-/Gemeinschafts-/Zinsweide wurde als Abgang behandelt", [c.category]),
} if {
	c := category_records[_]
	sheep_or_goat(c)
	object.get(c, "temporary_pasture_stay", false) == true
	object.get(c, "pasture_treated_as_exit", false) == true
}

violations contains {
	"rule_id": "o620-equid-camel-correction",
	"message": sprintf("Korrektur der Anzahl für %v bei Nichterreichung der Mindestweidetage fehlt", [c.category]),
} if {
	c := category_records[_]
	equid_or_camel(c)
	not category_minimum_met(c)
	object.get(c, "replacement_by_growing_animals", false) == false
	object.get(c, "count_correction_done", false) == false
}

violations contains {
	"rule_id": "o620-vis-reporting",
	"message": sprintf("VIS-Tiermeldungen für %v sind nicht als vollständig angegeben", [c.category]),
} if {
	c := category_records[_]
	species := category_species(c)
	species in {"sheep", "goats", "equids"}
	object.get(c, "vis_reporting_complete", false) == false
}

violations contains {
	"rule_id": "o620-austria-location",
	"message": sprintf("Tiere der Kategorie %v werden nicht in Österreich gehalten", [c.category]),
} if {
	c := category_records[_]
	object.get(c, "animals_held_in_austria", false) == false
}

violations contains {
	"rule_id": "o620-drought-control-context",
	"message": "2026-Dürrekontext: Grundfutterbedarf auf der Weide ist in der Kontrolle gesondert zu plausibilisieren",
} if {
	object.get(farm, "year", 0) == 2026
	object.get(context, "drought_2026", false) == true
	object.get(context, "control_note_acknowledged", false) == false
}

optional_150_premium_eligible(c) if {
	object.get(c, "optional_150_days", false) == true
	category_minimum_met(c)
}

optional_150_premium_eligible(c) := false if {
	object.get(c, "optional_150_days", false) == false
}

optional_150_premium_eligible(c) := false if {
	object.get(c, "optional_150_days", false) == true
	not category_minimum_met(c)
}

category_results contains result if {
	c := category_records[_]
	category_config(c)
	result := {
		"category": c.category,
		"label": category_config(c).label,
		"required_weide_days": category_threshold(c),
		"actual_weide_days": object.get(c, "weide_days", 0),
		"minimum_met": category_minimum_met(c),
		"average_rgve": object.get(c, "average_rgve", 0),
		"base_premium_eligible": category_minimum_met(c),
		"optional_150_premium_eligible": optional_150_premium_eligible(c),
	}
}

premium_amounts := {
	"base_band_eur_per_rgve": data.premium_band_eur_per_rgve.base_min,
	"base_band_max_eur_per_rgve": data.premium_band_eur_per_rgve.base_max,
	"optional_150_band_eur_per_rgve": data.premium_band_eur_per_rgve.optional_150_min,
	"optional_150_band_max_eur_per_rgve": data.premium_band_eur_per_rgve.optional_150_max,
	"coupled_alpine_support_base_factor": 0.5,
	"common_pasture_base_factor": 1.0,
}

is_eligible if {
	count(violations) == 0
	count(category_records) > 0
}

default is_eligible := false

decision := {
	"eligible": is_eligible,
	"violations": sort([v | v := violations[_]]),
	"categories": [c | c := category_results[_]],
	"premium": premium_amounts,
	"total_average_rgve": total_rgve,
	"application_valid": has_valid_application,
	"annual_contract": true,
}
