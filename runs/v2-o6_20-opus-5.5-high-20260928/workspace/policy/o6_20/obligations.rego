# Förderverpflichtungen (Informationsblatt Kap. 5; SRL 2.20.5).
package oepul.o6_20.obligations

import data.oepul.o6_20.common
import data.oepul.o6_20.notices_2026

supplement_applied(c) if object.get(c, "supplement_150_applied", false) == true

# Stalltage für Ablammung/Abkitzung ohne Einzeltierdokumentation erhöhen die erforderliche Weidedauer.
birth_extra_days(c) := object.get(c, "birth_stall_days", 0) if {
	common.regime(c.category_code) == "sheep_goat"
	object.get(c, "individual_birth_documentation", false) == false
} else := 0

required_base_days(c) := common.params.min_grazing_days_base + birth_extra_days(c)

required_supplement_days(c) := common.params.min_grazing_days_supplement + birth_extra_days(c)

grazing_days(c) := object.get(c, "grazing_days_all_animals", 0)

base_grazing_met(c) if grazing_days(c) >= required_base_days(c)

supplement_grazing_met(c) if {
	supplement_applied(c)
	grazing_days(c) >= required_supplement_days(c)
}

category_reported_non_compliant(c) if object.get(c, "non_compliance_reported", false) == true

# 120 Weidetage mit allen Tieren der Kategorie zwischen 1.4. und 31.10.
violations contains v if {
	some c in common.categories
	not base_grazing_met(c)
	not notices_2026.force_majeure_recognized
	v := {
		"rule_id": "o6_20.obligation.grazing_min_days",
		"severity": severity_grazing(c),
		"category_code": c.category_code,
		"message": sprintf("%d Weidetage erreicht, mindestens %d erforderlich (1.4.–31.10., alle Tiere der Kategorie)", [grazing_days(c), required_base_days(c)]),
	}
}

severity_grazing(c) := "no_premium" if category_reported_non_compliant(c)

else := "sanction_risk"

# Optionaler Zuschlag: Nichterreichen der 150 Tage erfordert Korrektur (Entfernen des Zuschlags).
violations contains v if {
	some c in common.categories
	supplement_applied(c)
	not supplement_grazing_met(c)
	object.get(c, "supplement_150_removed_by_correction", false) == false
	not notices_2026.force_majeure_recognized
	v := {
		"rule_id": "o6_20.obligation.supplement_150_days",
		"severity": "correction_required",
		"category_code": c.category_code,
		"message": sprintf("Zuschlag 150 Weidetage beantragt, nur %d von %d Tagen erreicht – Zuschlag per Korrektur entfernen", [grazing_days(c), required_supplement_days(c)]),
	}
}

# Grundfutterbedarf überwiegend über Beweidung, wesentlicher Teil des Tages.
forage_ok(c) if {
	object.get(c, "forage_mainly_from_grazing", true) == true
	object.get(c, "grazing_substantial_part_of_day", true) == true
}

violations contains v if {
	some c in common.categories
	not forage_ok(c)
	not notices_2026.drought_consideration_applies
	v := {
		"rule_id": "o6_20.obligation.forage_from_grazing",
		"severity": "sanction_risk",
		"category_code": c.category_code,
		"message": "Grundfutterbedarf nicht überwiegend über Beweidung bzw. Beweidung nicht über einen wesentlichen Teil des Tages",
	}
}

# Tränke und Unterstellmöglichkeit.
violations contains v if {
	some c in common.categories
	some field in ["water_access", "shelter_or_rapid_stall_access"]
	object.get(c, field, true) == false
	v := {
		"rule_id": "o6_20.obligation.water_shelter",
		"severity": "sanction_risk",
		"category_code": c.category_code,
		"message": sprintf("Weideinfrastruktur fehlt: %s", [field]),
	}
}

# Weidetagebuch.
diary := object.get(common.tw, "grazing_diary", {})

diary_required_fields := [
	"maintained",
	"records_category_or_group",
	"records_location",
	"records_period_start_end_per_location",
	"records_daily_animal_interruption_reasons",
	"significant_changes_recorded_same_day",
]

violations contains v if {
	count(common.categories) > 0
	some field in diary_required_fields
	object.get(diary, field, true) == false
	v := {
		"rule_id": "o6_20.obligation.grazing_diary",
		"severity": "sanction_risk",
		"message": sprintf("Weidetagebuch unvollständig: %s", [field]),
	}
}

missing_inputs contains "oepul_measures.tierwohl_weide.grazing_diary" if {
	count(common.categories) > 0
	not common.tw.grazing_diary
}

# Nicht teilnehmende Tiere einer beantragten Kategorie: Grundsätzlich alle Tiere der Kategorie.
violations contains v if {
	some c in common.categories
	object.get(c, "animals_not_grazed_without_report", 0) > 0
	v := {
		"rule_id": "o6_20.reporting.all_animals_participate",
		"severity": "sanction_risk",
		"category_code": c.category_code,
		"message": sprintf("%d Tiere der Kategorie nicht geweidet und nicht gemeldet", [c.animals_not_grazed_without_report]),
	}
}
