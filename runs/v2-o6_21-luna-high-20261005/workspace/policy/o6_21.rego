package policy.o6_21

import rego.v1

profile := object.get(object.get(input, "farm", {}), "o6_21", {})
stall := object.get(profile, "stall", {})
animals := object.get(profile, "animals", [])
categories := object.get(profile, "participating_categories", [])
year := object.get(profile, "year", object.get(input, "year", 0))

default decision := {
	"eligible": false,
	"violations": [],
	"premium_eur": 0,
	"application": "unknown",
	"contract_year": "unknown",
}

decision := {
	"eligible": count(violations) == 0,
	"violations": violations,
	"premium_eur": premium_eur,
	"application": application_status,
	"contract_year": contract_status,
}

violations := [violation | violation := violation_set[_]]

violation_set contains {"rule_id": "O621-MIN-RGVE", "reason": "Der durchschnittliche förderfähige Bestand muss mindestens 2,00 RGVE erreichen."} if {
	object.get(profile, "average_fundable_rgve", 0) < 2
}

violation_set contains {"rule_id": "O621-CATEGORIES", "reason": "Es ist nur eine der vier zugelassenen Rinderkategorien beantragt."} if {
	some category in categories
	not category_allowed(category)
}

category_allowed(category) if {
	some row in data.categories
	row.id == category
}

violation_set contains {"rule_id": "O621-STALL-DEFINITION", "reason": "Die baulichen Mindestmerkmale des Stalls sind nicht vollständig nachgewiesen."} if {
	not object.get(stall, "structural_requirements_met", false)
}

violation_set contains {"rule_id": "O621-OPEN-STALL", "reason": "Die besonderen Anforderungen an ein Offenstallhaltungssystem sind nicht vollständig erfüllt."} if {
	object.get(profile, "open_stall", false)
	not object.get(stall, "open_stall_requirements_met", false)
}

violation_set contains {"rule_id": "O621-USABLE-AREA", "reason": "Die als nutzbare Gesamtfläche angesetzte Fläche ist nicht befestigt oder nicht ständig zugänglich."} if {
	not object.get(stall, "usable_area_definition_met", false)
}

violation_set contains {"rule_id": "O621-ALL-ANIMALS", "reason": "Grundsätzlich muss mit allen Tieren der jeweiligen Kategorie teilgenommen werden."} if {
	not object.get(profile, "all_eligible_animals_participating", false)
}

violation_set contains {"rule_id": "O621-HEALTH-SERVICE", "reason": "Bei mehr als 10,00 RGVE förderbaren Rindern fehlt die Teilnahme am anerkannten Tiergesundheitsdienst."} if {
	object.get(profile, "fundable_rgve_total", 0) > 10
	not object.get(profile, "health_service_participation", false)
}

violation_set contains {"rule_id": "O621-QPLUS", "reason": "Bei weiblichen Rindern fehlt Qplus Rind oder ein vergleichbares Programm."} if {
	any_female_category
	not object.get(profile, "qplus_rind_or_comparable", false)
}

any_female_category if {
	some category in categories
	category == "female_under_half_year"
}

any_female_category if {
	some category in categories
	category == "female_half_to_two_years"
}

violation_set contains {"rule_id": "O621-MILK-DELIVERY", "reason": "Betriebe mit Milchanlieferung dürfen die Kategorie weibliche Rinder ab ½ bis unter 2 Jahre nicht beantragen."} if {
	"female_half_to_two_years" in categories
	object.get(profile, "milk_delivery_to_dairy", false)
}

violation_set contains {"rule_id": "O621-HOUSING-PERIOD", "reason": "Die alters-, abgangs- und zukaufsbezogenen Haltungszeiträume sind nicht vollständig dokumentiert."} if {
	not object.get(profile, "housing_periods_documented", false)
}

violation_set contains {"rule_id": "O621-GROUP-LITTER", "reason": "Die Haltung muss in Gruppen und auf eingestreuten Systemen erfolgen."} if {
	not object.get(stall, "group_housing", false)
}

violation_set contains {"rule_id": "O621-GROUP-LITTER", "reason": "Die Haltung muss in Gruppen und auf eingestreuten Systemen erfolgen."} if {
	not object.get(stall, "littered_system", false)
}

violation_set contains {"rule_id": "O621-LYING-SURFACE", "reason": "Die Liegefläche muss planbefestigt sein; höchstens 5 % Perforation gelten als planbefestigt."} if {
	object.get(stall, "perforation_percent", 100) > 5
}

violation_set contains {"rule_id": "O621-LITTER-PERCENT", "reason": "Mindestens 40 % der geforderten nutzbaren Gesamtfläche müssen eingestreute Liegefläche sein."} if {
	object.get(stall, "littered_lying_area_percent", 0) < 40
}

violation_set contains {"rule_id": "O621-SOFT-DRY", "reason": "Die eingestreute Liegefläche muss weich und trocken sein."} if {
	not object.get(stall, "lying_area_soft_and_dry", false)
}

violation_set contains {"rule_id": "O621-LITTER-QUALITY", "reason": "Bei harter oder befestigter Liegefläche fehlt die mindestens 3 cm dicke Einstreudecke."} if {
	object.get(stall, "hard_surface", false)
	object.get(stall, "litter_depth_cm", 0) < 3
}

violation_set contains {"rule_id": "O621-SPACE", "reason": "Der erforderliche Mindestplatzbedarf je Tier ist nicht erfüllt."} if {
	some animal in animals
	requirement := space_requirement_for(object.get(animal, "weight_kg", 0))
	actual := object.get(stall, "total_area_m2_per_animal", 0)
	actual < requirement.total_area_m2_per_animal
}

violation_set contains {"rule_id": "O621-SPACE", "reason": "Der erforderliche Mindestplatzbedarf je Tier ist nicht erfüllt."} if {
	some animal in animals
	requirement := space_requirement_for(object.get(animal, "weight_kg", 0))
	actual := object.get(stall, "lying_area_m2_per_animal", 0)
	actual < requirement.lying_area_m2_per_animal
}

space_requirement_for(weight) := row if {
	rows := [candidate | candidate := data.space_requirements[_]; candidate.max_weight_kg != null; weight <= candidate.max_weight_kg]
	count(rows) > 0
	row := rows[0]
}

space_requirement_for(weight) := row if {
	row := data.space_requirements[4]
	weight > 500
}

violation_set contains {"rule_id": "O621-SINGLE-HOUSING", "reason": "Einzelhaltung ist nur aus gesundheitlichen Gründen und höchstens 10 Tage prämienunschädlich."} if {
	object.get(profile, "individual_housing_days", 0) > 10
}

violation_set contains {"rule_id": "O621-SINGLE-HOUSING", "reason": "Erkrankte oder verletzte Tiere in Einzeltierhaltung müssen auf eingestreuten Systemen gehalten werden."} if {
	object.get(profile, "individual_housing_days", 0) > 0
	not object.get(stall, "individual_housing_littered", false)
}

violation_set contains {"rule_id": "O621-CALF-SOCIAL", "reason": "Kälber unter 21 Tagen in Einzelhaltung müssen ausreichenden Sozialkontakt haben."} if {
	object.get(profile, "calves_under_21_days_individually_housed", false)
	not object.get(profile, "calf_social_contact", false)
}

violation_set contains {"rule_id": "O621-SINGLE-HOUSING", "reason": "Die Krankheit/Verletzung und Dauer der Einzeltierhaltung müssen am Betrieb dokumentiert werden."} if {
	object.get(profile, "individual_housing_days", 0) > 0
	not object.get(profile, "individual_housing_records_complete", false)
}

violation_set contains {"rule_id": "O621-SHARED-ANIMALS", "reason": "Bei gemeinsamer Haltung wurden die Platzbedarfe nicht für alle Tiere der Box berechnet."} if {
	object.get(profile, "shared_group", false)
	not object.get(profile, "shared_group_area_calculated_for_all", false)
}

violation_set contains {"rule_id": "O621-COWS", "reason": "Die zusätzlichen Flächenanforderungen für gemeinsam gehaltene Kühe wurden nicht berücksichtigt."} if {
	object.get(profile, "cow_count", 0) > 0
	not object.get(profile, "cow_group_area_calculated", false)
}

violation_set contains {"rule_id": "O621-STALL-PLAN-HISTORY", "reason": "Für ein Antragsjahr bis einschließlich 2024 fehlt die damals erforderliche Stallskizze oder der Belegungsplan."} if {
	year <= 2024
	not object.get(profile, "stall_sketch_and_occupancy_plan_available", false)
}

violation_set contains {"rule_id": "O621-COMPOST", "reason": "Für den Zuschlag muss der gesamte am Betrieb anfallende Festmist ordnungsgemäß kompostiert und dokumentiert werden."} if {
	object.get(profile, "compost_surcharge_requested", false)
	compost := object.get(profile, "compost", {})
	not compost_valid(compost)
}

violation_set contains {"rule_id": "O621-REPORTING", "reason": "Betroffene Tiere müssen umgehend ohrmarkenbezogen abgemeldet werden."} if {
	object.get(profile, "noncompliant_animals_count", 0) > 0
	not object.get(profile, "noncompliant_animals_reported_immediately", false)
}

compost_valid(compost) if {
	object.get(compost, "all_solid_manure_in_piles", false)
	object.get(compost, "mode", "") == "turned"
	object.get(compost, "turns", 0) >= 2
	object.get(compost, "minimum_interval_days", 0) >= 14
	object.get(compost, "turning_equipment_available_or_proven", false)
	object.get(compost, "records_complete", false)
	object.get(compost, "napv_compliant", false)
	not object.get(compost, "compost_barn", false)
}

compost_valid(compost) if {
	object.get(compost, "all_solid_manure_in_piles", false)
	object.get(compost, "mode", "") == "mixed_or_layered_no_turn"
	object.get(compost, "records_complete", false)
	object.get(compost, "napv_compliant", false)
	not object.get(compost, "compost_barn", false)
}

compost_valid(compost) if {
	object.get(compost, "all_solid_manure_in_piles", false)
	object.get(compost, "mode", "") == "alternative_organic_material_process"
	object.get(compost, "additional_organic_material_nondisregarded", false)
	object.get(compost, "composting_process", false)
	object.get(compost, "records_complete", false)
	object.get(compost, "napv_compliant", false)
	not object.get(compost, "compost_barn", false)
}

application_status := "valid" if {
	object.get(profile, "application_submitted_by_december_31", false)
}

application_status := "late_or_missing" if {
	not object.get(profile, "application_submitted_by_december_31", false)
}

contract_status := "one_year_and_auto_renewing" if {
	object.get(profile, "minimum_participation_met", false)
}

contract_status := "expires_for_measure" if {
	not object.get(profile, "minimum_participation_met", false)
}

premium_eur := value if {
	average_rgve := object.get(profile, "average_fundable_rgve", 0)
	rates := [rate | rate := data.premium_rates_eur_per_rgve[_]; rate.year_band == "2023"; year == 2023]
	rate := rates[0]
	base := premium_component(rate, profile)
	surcharge := compost_component(rate, profile)
	value := (average_rgve * base) + (average_rgve * surcharge)
}

premium_eur := value if {
	average_rgve := object.get(profile, "average_fundable_rgve", 0)
	rates := [rate | rate := data.premium_rates_eur_per_rgve[_]; rate.year_band == "from_2024"; year >= 2024]
	rate := rates[0]
	base := premium_component(rate, profile)
	surcharge := compost_component(rate, profile)
	value := (average_rgve * base) + (average_rgve * surcharge)
}

premium_component(rate, profile) := rate.overlap_premium if {
	object.get(profile, "overlap_with_alp_or_weide", false)
}

premium_component(rate, profile) := rate.animal_premium if {
	not object.get(profile, "overlap_with_alp_or_weide", false)
}

compost_component(rate, profile) := rate.compost_surcharge if {
	object.get(profile, "compost_surcharge_requested", false)
}

compost_component(_, profile) := 0 if {
	not object.get(profile, "compost_surcharge_requested", false)
}
