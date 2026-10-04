# Zugangsvoraussetzungen und betriebsbezogene Förderverpflichtungen (o6_21, Kapitel 3 und 6.1/6.2).
package oepul.o6_21.eligibility

import data.oepul.o6_21.animals
import data.oepul.o6_21.application
import data.oepul.o6_21.lib

programmes := object.get(input, ["farm", "programmes"], {})

# Im Förderjahr 2023 genügt eine Teilnahme ab 15. April.
required_programme_start := lib.deadlines.reduced_participation_start_2023 if lib.year == 2023

required_programme_start := sprintf("%d-01-01", [lib.year]) if lib.year != 2023

required_programme_end := sprintf("%d-12-31", [lib.year])

programme_covers_year(p) if {
	p.participating
	lib.parse_date(p.from) <= lib.parse_date(required_programme_start)
	lib.parse_date(p.until) >= lib.parse_date(required_programme_end)
}

# O6_21-ELIG-01: Teilnahme mit mindestens 2,00 RGVE im Jahresdurchschnitt über alle beantragten Kategorien.
min_participation_met if animals.eligible_rgve >= lib.thresholds.min_participation_rgve

# O6_21-TGD-01: über 10,00 RGVE förderbare Rinder → Teilnahme an anerkanntem Tiergesundheitsdienst 1.1.–31.12.
animal_health_service_required if {
	animals.gross_category_rgve > lib.thresholds.animal_health_service_rgve_threshold_exclusive
}

animal_health_service_ok if not animal_health_service_required

animal_health_service_ok if {
	animal_health_service_required
	programme_covers_year(object.get(programmes, "animal_health_service_cattle", {"participating": false}))
}

# O6_21-QPL-01: bei weiblichen Kategorien Teilnahme an Qplus Rind (oder vergleichbarem Programm) 1.1.–31.12.
female_category_applied if {
	some cat_id in application.valid_categories
	lib.category_def(cat_id).requires_qplus_rind
}

quality_programme := object.get(programmes, "quality_programme_female_cattle", {"participating": false})

quality_programme_ok if not female_category_applied

quality_programme_ok if {
	female_category_applied
	quality_programme.programme in lib.tables.accepted_quality_programmes_female
	programme_covers_year(quality_programme)
}

# O6_21-ELIG-04: Kategorie weibliche Rinder ½–2 Jahre bei Milchanlieferung ausgeschlossen.
milk_delivery_conflict if {
	"female_half_to_2_years" in application.valid_categories
	animals.milk_delivery
}

access_issue("no_valid_category") if count(application.valid_categories) == 0

access_issue("min_participation_not_met") if not min_participation_met

access_issue("animal_health_service_missing") if not animal_health_service_ok

access_issue("quality_programme_missing") if not quality_programme_ok

access_issue("takeover_not_permitted") if application.takeover_violation

# O6_21-ELIG-05: Betriebsmindestgröße im ersten ÖPUL-Teilnahmejahr (1,50 ha bzw. 0,50 ha geschützter Anbau).
first_oepul_year if object.get(input, ["farm", "oepul_first_participation_year"], null) == lib.year

farm_min_size_met if not first_oepul_year

farm_min_size_met if {
	first_oepul_year
	object.get(input, ["land", "total_area_ha"], 0) >= lib.tables.farm_min_size.min_agricultural_area_ha
}

farm_min_size_met if {
	first_oepul_year
	object.get(input, ["land", "protected_cultivation_area_ha"], 0) >= lib.tables.farm_min_size.min_protected_cultivation_ha
}

access_issue("farm_min_size_not_met") if not farm_min_size_met

access_issues := {code |
	some code in {
		"no_valid_category",
		"min_participation_not_met",
		"animal_health_service_missing",
		"quality_programme_missing",
		"takeover_not_permitted",
		"farm_min_size_not_met",
	}
	access_issue(code)
}

# O6_21-CONTRACT-02: wird die Mindestteilnahme nicht eingehalten, erlischt der Vertrag für die Maßnahme;
# bei einjährigen Maßnahmen kommt bei Nichterfüllung der Zugangsvoraussetzungen kein Vertrag zustande.
contract_lapses if not min_participation_met
