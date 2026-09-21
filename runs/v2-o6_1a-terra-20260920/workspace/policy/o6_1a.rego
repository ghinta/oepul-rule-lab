package oepul.o6_1a

import rego.v1

# Input is the discover-mode extension proposed in rules/profile_changes.json.
required_arable_biodiversity_ha := input.ubb.arable_area_ha * 0.07 if input.ubb.arable_area_ha > 2
required_arable_biodiversity_ha := 0 if input.ubb.arable_area_ha <= 2

required_grassland_biodiversity_ha := input.ubb.mown_grassland_area_ha * 0.07 if input.ubb.mown_grassland_area_ha > 2
required_grassland_biodiversity_ha := 0 if input.ubb.mown_grassland_area_ha <= 2

is_livestock_farm if input.ubb.rgve_total / input.ubb.fodder_area_ha >= 0.3

rgve_factor(category) := factor if {
	row := data.rgve_factors_full[_]
	row.category == category
	factor := object.get(row, "rgve_per_head", object.get(row, "gve_per_head", null))
	factor != null
}

premium_eligible_access_ha := input.ubb.access.added_area_ha if input.ubb.access.year <= 2025

premium_eligible_access_ha := input.ubb.access.added_area_ha if input.ubb.access.previously_under_same_measure == true

premium_eligible_access_ha := max([input.ubb.access.measure_area_ha_2025 * 0.5, 5]) if {
	input.ubb.access.year >= 2026
	input.ubb.access.previously_under_same_measure != true
}

divnfz_2026_exception(p) if {
	input.farm.year == 2026
	p.biodiversity.op_ubb_or_bio == true
	p.biodiversity.rest_days >= 49
}

violations contains v if {
	input.ubb.arable_area_ha > 5
	input.ubb.cereal_maize_area_ha / input.ubb.arable_area_ha > 0.75
	v := {"rule_id": "o6_1a.crop.cereal_maize_limit", "message": "Getreide und Mais übersteigen 75 % der Ackerfläche."}
}

violations contains v if {
	some crop in input.ubb.crop_shares
	crop.exempt_55pct != true
	crop.area_ha / input.ubb.arable_area_ha > 0.55
	v := {"rule_id": "o6_1a.crop.single_crop_limit", "message": sprintf("Kultur %s übersteigt 55 %% der Ackerfläche.", [crop.name])}
}

violations contains v if {
	input.ubb.arable_biodiversity_eligible_ha < required_arable_biodiversity_ha
	v := {"rule_id": "o6_1a.biodiv.arable_minimum", "message": "Die erforderlichen 7 % Acker-Biodiversitätsfläche werden nicht erreicht."}
}

violations contains v if {
	input.ubb.mown_grassland_biodiversity_eligible_ha < required_grassland_biodiversity_ha
	v := {"rule_id": "o6_1a.biodiv.grassland_minimum", "message": "Die erforderlichen 7 % Grünland-Biodiversitätsfläche werden nicht erreicht."}
}

violations contains v if {
	some p in input.ubb.parcels
	p.biodiversity.code == "DIV"
	p.biodiversity.insect_flowering_partners < 7
	v := {"rule_id": "o6_1a.biodiv.arable_seed_mix", "message": "DIV-Ansaat hat weniger als sieben insektenblütige Mischungspartner."}
}

violations contains v if {
	some p in input.ubb.parcels
	p.biodiversity.code == "DIV"
	p.biodiversity.plant_families < 3
	v := {"rule_id": "o6_1a.biodiv.arable_seed_mix", "message": "DIV-Ansaat hat weniger als drei Pflanzenfamilien."}
}

violations contains v if {
	some p in input.ubb.parcels
	p.biodiversity.code == "DIVRS"
	p.biodiversity.species_count < 30
	v := {"rule_id": "o6_1a.biodiv.regional_seed", "message": "DIVRS-Ansaat hat weniger als 30 Arten."}
}

violations contains v if {
	some p in input.ubb.parcels
	p.biodiversity.code == "DIVRS"
	p.biodiversity.family_count < 7
	v := {"rule_id": "o6_1a.biodiv.regional_seed", "message": "DIVRS-Ansaat hat weniger als sieben Pflanzenfamilien."}
}

violations contains v if {
	some p in input.ubb.parcels
	p.biodiversity.code == "DIVRS"
	p.biodiversity.seed_rate_kg_ha < 20
	v := {"rule_id": "o6_1a.biodiv.regional_seed", "message": "DIVRS-Saatstärke liegt unter 20 kg/ha."}
}

violations contains v if {
	some p in input.ubb.parcels
	p.biodiversity.is_arable
	p.biodiversity.drusch == true
	v := {"rule_id": "o6_1a.biodiv.arable_no_harvest", "message": "Drusch auf Acker-Biodiversitätsfläche ist verboten."}
}

violations contains v if {
	some p in input.ubb.parcels
	p.biodiversity.is_arable
	p.biodiversity.fertilized == true
	v := {"rule_id": "o6_1a.biodiv.arable_inputs", "message": "Düngung auf Acker-Biodiversitätsfläche ist verboten."}
}

violations contains v if {
	some p in input.ubb.parcels
	p.biodiversity.is_grassland
	p.biodiversity.pesticide_non_bio == true
	v := {"rule_id": "o6_1a.biodiv.grassland_inputs", "message": "Nicht-Bio-Pflanzenschutzmittel auf Grünland-Biodiversitätsfläche."}
}

violations contains v if {
	some p in input.ubb.parcels
	p.biodiversity.code == "DIVNFZ"
	p.biodiversity.rest_days < 63
	not divnfz_2026_exception(p)
	v := {"rule_id": "o6_1a.biodiv.divnfz_rest", "message": "DIVNFZ hat keinen nutzungsfreien Zeitraum von mindestens 63 Tagen."}
}

violations contains v if {
	input.ubb.training.biodiversity_hours < 3
	v := {"rule_id": "o6_1a.training.minimum", "message": "Dreistündige biodiversitätsrelevante Weiterbildung fehlt."}
}

premium_rate := 85 if input.farm.year >= 2025
premium_rate := 75.6 if input.farm.year == 2024
premium_rate := 70 if input.farm.year == 2023

premium_rate_grassland := 75.6 if is_livestock_farm
premium_rate_grassland := 27 if not is_livestock_farm

rare_cultivar_tier[cultivar] := tier if {
	row := data.rare_cultivars[_]
	cultivar := row.cultivar
	tier := row.tier
	not row.from_year
}

rare_cultivar_tier[cultivar] := tier if {
	row := data.rare_cultivars[_]
	cultivar := row.cultivar
	tier := row.tier
	row.from_year <= input.farm.year
}
