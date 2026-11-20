# Zugangsvoraussetzungen, Beantragung, Vertragszeitraum und Maßnahmenkombination.
package oepul.o6_16

import data.o6_16 as d

# --- Mindestteilnahme: 2,00 ha Ackerfläche in der Gebietskulisse im 1. Verpflichtungsjahr ---
min_area_first_year_met if gwa_arable_area_ha >= 2.0

access_violations contains v if {
	first_commitment_year
	not min_area_first_year_met
	v := {
		"rule_id": "O616-ACC-001",
		"message": sprintf("Im 1. Verpflichtungsjahr nur %v ha Ackerfläche in der Gebietskulisse (mind. 2,00 ha)", [gwa_arable_area_ha]),
	}
}

# --- Angebot nur in Burgenland, Kärnten, Niederösterreich, Oberösterreich, Steiermark, Wien ---
farm_state_offered if input.farm.region.federal_state in {s | some s in d.offered_federal_states}

access_violations contains v if {
	not farm_state_offered
	count(area_parcels) == 0
	v := {
		"rule_id": "O616-ACC-002",
		"message": "Betrieb bewirtschaftet keine Ackerflächen in den Angebotsbundesländern bzw. der Gebietskulisse",
	}
}

# --- Kombinationsverpflichtung: gleichzeitige Teilnahme an Maßnahme 6 oder 7 ---
combination_obligation_met if participates("6")

combination_obligation_met if participates("7")

access_violations contains v if {
	not combination_obligation_met
	v := {
		"rule_id": "O616-ACC-003",
		"message": "Keine zeitgleiche Teilnahme an „Begrünung von Ackerflächen – Zwischenfruchtanbau“ (6) oder „System Immergrün“ (7)",
	}
}

# --- Betriebsmindestgröße im 1. ÖPUL-Teilnahmejahr (allgemeine Bedingung) ---
first_oepul_year if year == object.get(input, ["farm", "oepul", "first_oepul_participation_year"], null)

farm_min_size_met if object.get(input, ["land", "protected_cultivation_area_ha"], 0) >= 0.5

farm_min_size_met if {
	agricultural := object.get(input, ["land", "total_area_ha"], 0)
	agricultural >= 1.5
}

access_violations contains v if {
	first_oepul_year
	not farm_min_size_met
	v := {
		"rule_id": "O616-GEN-003",
		"message": "Betriebsmindestgröße im 1. ÖPUL-Teilnahmejahr (1,50 ha bzw. 0,50 ha geschützter Anbau) nicht erreicht",
	}
}

# --- Förderwerbende Personen ---
applicant := object.get(input, ["farm", "applicant"], {})

access_violations contains v if {
	object.get(applicant, "is_public_body", false) == true
	v := {
		"rule_id": "O616-GEN-001",
		"message": "Gebietskörperschaften und deren Einrichtungen sind in dieser Maßnahme keine förderwerbenden Personen",
	}
}

access_violations contains v if {
	object.get(applicant, "legal_form", "natural_person") in {"legal_person", "association"}
	object.get(applicant, "public_body_share_percent", 0) > 25
	v := {
		"rule_id": "O616-GEN-001",
		"message": "Beteiligung von Gebietskörperschaften über 25 % (bestimmender Einfluss)",
	}
}

access_violations contains v if {
	object.get(applicant, "active_farmer", true) == false
	v := {
		"rule_id": "O616-GEN-002",
		"message": "Förderwerbende Person ist kein aktiver Landwirt bzw. übt keine landwirtschaftliche Tätigkeit aus",
	}
}

# --- Beantragung: Maßnahmenantrag bis 31.12. vor Vertragsbeginn; letzter Einstieg 2025 ---
application_deadline(start_year) := sprintf("%d-12-31", [start_year - 1])

access_violations contains v if {
	start := commitment_start_year
	start != null
	app := object.get(o16, "measure_application_date", null)
	app != null
	app > application_deadline(start)
	v := {
		"rule_id": "O616-APP-001",
		"message": sprintf("Maßnahmenantrag %v nach Frist %v", [app, application_deadline(start)]),
	}
}

access_violations contains v if {
	start := commitment_start_year
	start != null
	start > 2025
	v := {
		"rule_id": "O616-APP-002",
		"message": "Letzter Einstieg in die Maßnahme ist mit Förderjahr 2025 (Beantragung bis 31.12.2024) möglich",
	}
}

# Vertragszeitraum: Beginn 2023/2024/2025, Ende jeweils 31.12.2028
contract_period := p if {
	some p in d.contract_periods
	date_year(p.start) == commitment_start_year
}

contract_end_date := "2028-12-31"

in_contract_period if {
	commitment_start_year != null
	year >= commitment_start_year
	year <= 2028
}

# --- Optionaler Zuschlag „Humusaufbau und Erosionsschutz in Wien“ ---
wien_option := object.get(o16, "wien_humus", {})

wien_option_applied if object.get(wien_option, "applied", false) == true

access_violations contains v if {
	wien_option_applied
	count(wien_area_parcels) == 0
	v := {
		"rule_id": "O616-WIEN-001",
		"message": "Zuschlag Wien nur für Betriebe mit Ackerflächen innerhalb der Gebietskulisse Wien",
	}
}

access_violations contains v if {
	wien_option_applied
	start := object.get(wien_option, "commitment_start_year", commitment_start_year)
	app := object.get(wien_option, "application_date", null)
	app != null
	app > application_deadline(start)
	v := {
		"rule_id": "O616-APP-001",
		"message": "Zuschlag Wien nicht fristgerecht im Maßnahmenantrag beantragt",
	}
}

access_violations contains v if {
	wien_option_applied
	object.get(wien_option, "commitment_start_year", commitment_start_year) > 2025
	v := {
		"rule_id": "O616-APP-002",
		"message": "Letzter Einstieg in den Zuschlag Wien ist mit Förderjahr 2025 möglich",
	}
}

access_violations contains v if {
	wien_option_applied
	object.get(wien_option, "scientific_project_confirmation", false) != true
	v := {
		"rule_id": "O616-WIEN-003",
		"message": "Teilnahmebestätigung der wissenschaftlichen Begleitung liegt nicht vor",
	}
}

# --- Optionaler Zuschlag „Stark stickstoffreduzierte Fütterung von Schweinen“ ---
pig_option := object.get(o16, "pig_feeding", {})

pig_option_applied if object.get(pig_option, "applied", false) == true

pig_groups := [g |
	some g in object.get(input, ["livestock", "species_groups"], [])
	g.species == "pigs"
]

gve_factor_for_pig_category(cat) := f if {
	key := d.pig_category_gve_mapping[cat]
	some r in d.annex_a_gve_key
	r.category_key == key
	f := r.gve_per_head
}

pig_group_gve(g) := g.gve if {
	g.gve != null
}

pig_group_gve(g) := gve if {
	object.get(g, "gve", null) == null
	n := object.get(g, "annual_average_count", g.animal_count)
	gve := n * gve_factor_for_pig_category(g.category)
}

pig_gve_total := sum([pig_group_gve(g) | some g in pig_groups])

pig_gve_per_ha_arable := pig_gve_total / total_arable_area_ha if total_arable_area_ha > 0

pig_density_met if pig_gve_per_ha_arable >= 1.0

access_violations contains v if {
	pig_option_applied
	not pig_density_met
	v := {
		"rule_id": "O616-PIG-001",
		"message": "Zuschlag Schweinefütterung: weniger als 1,00 GVE Schweine je ha Ackerfläche im Jahresdurchschnitt",
	}
}

access_violations contains v if {
	pig_option_applied
	start := object.get(pig_option, "start_year", year)
	app := object.get(pig_option, "application_date", null)
	app != null
	app > application_deadline(start)
	v := {
		"rule_id": "O616-APP-001",
		"message": "Zuschlag Schweinefütterung nicht fristgerecht im Maßnahmenantrag beantragt",
	}
}

access_violations contains v if {
	pig_option_applied
	object.get(pig_option, "start_year", year) > 2028
	v := {
		"rule_id": "O616-APP-003",
		"message": "Letzter Einstieg in den Zuschlag Schweinefütterung ist mit Förderjahr 2028 (Beantragung bis 31.12.2027) möglich",
	}
}

access_violations contains v if {
	pig_option_applied
	participates("9_pig_feeding")
	v := {
		"rule_id": "O616-PIG-002",
		"message": "Keine gleichzeitige Teilnahme an der Schweinefütterung in Maßnahme 16 und in Maßnahme 9 möglich",
	}
}

# Zuschlag Schweinefütterung verlängert sich automatisch, wenn er nicht abgemeldet wird
pig_option_auto_renewed if {
	pig_option_applied
	object.get(pig_option, "deregistered", false) == false
}

# --- Option AG und Zuschlag Cultan: jeweils mindestens ein Schlag ---
ag_parcels := [p | some p in parcels; is_ag_parcel(p)]

cul_parcels := [p | some p in parcels; is_cul_parcel(p)]

ag_option_participation if count(ag_parcels) > 0

cultan_participation if count(cul_parcels) > 0

access_violations contains v if {
	cultan_participation
	year < 2025
	v := {
		"rule_id": "O616-CUL-001",
		"message": "Zuschlag Cultan-Düngung erst ab Antragsjahr 2025",
	}
}

access_violations contains v if {
	some p in cul_parcels
	not parcel_in_area(p)
	v := {
		"rule_id": "O616-CUL-001",
		"parcel_id": p.parcel_id,
		"message": "CUL-Schlag liegt nicht in der Gebietskulisse gemäß Anhang G",
	}
}

default access_eligible := false

access_eligible if count(access_violations) == 0
