# o6_16 – Option AG (4.8), Zuschläge Wien (4.9), Schweinefütterung (4.10) und Cultan (4.11)
package oepul.o6_16

# ---------------------------------------------------------------------------
# 4.8 Option Bewirtschaftung auswaschungsgefährdeter Ackerflächen (Code AG)
# ---------------------------------------------------------------------------

ag := params.leaching_risk_area

ag_option(p) := object.get(p, "leaching_option", {})

ag_first_year(p) := object.get(ag_option(p), "previous_farm_first_ag_year", null) if {
	is_number(object.get(ag_option(p), "previous_farm_first_ag_year", null))
} else := object.get(ag_option(p), "first_ag_year", year)

# Schlag-Eignung
ag_parcel_eligible(p) if {
	in_area(p)
	is_arable(p)
	ackerzahl := object.get(ag_option(p), "ackerzahl_avg", null)
	is_number(ackerzahl)
	ackerzahl <= ag.max_avg_ackerzahl
	object.get(ag_option(p), "grassland_in_mfa_2020", false) == false
	not ag_npf_no_premium(p)
}

violations contains {
	"rule_id": "o6_16.ag.eligibility",
	"parcel_id": p.parcel_id,
	"message": "AG-Schlag nicht förderfähig (außerhalb Gebietskulisse, Ackerzahl > 40 bzw. unbekannt oder im MFA 2020 Grünland).",
} if {
	some p in ag_parcels
	not ag_parcel_eligible(p)
	not ag_npf_no_premium(p)
}

# förderfähiges Ausmaß ohne GLÖZ-4-Pufferstreifen und (bis 2024) GLÖZ-8-Stilllegung
ag_eligible_area(p) := max([0, (p.area_ha - object.get(ag_option(p), "gloez4_area_ha", 0)) - gloez8_deduction(p)])

gloez8_deduction(p) := object.get(ag_option(p), "gloez8_area_ha", 0) if year <= params.application.npf_until_year

gloez8_deduction(_) := 0 if year > params.application.npf_until_year

# Einsaat winterharte Mischung ohne Leguminosen bis 15.05. oder Belassen eines Bestandes
ag_establishment_ok(p) if {
	object.get(ag_option(p), "existing_stand_retained", false) == true
	object.get(p, ["oepul", "usage_type"], "") in {u | some u in ag.existing_stand_usage_types}
}

ag_establishment_ok(p) if {
	d := ag_option(p).sowing_date
	is_date(d)
	date_le(d, md_date(date_year(d), ag.sowing_deadline_month_day))
	ag_option(p).mix_winter_hardy == true
	ag_option(p).mix_contains_legumes == false
}

violations contains {
	"rule_id": "o6_16.ag.establishment",
	"parcel_id": p.parcel_id,
	"message": "AG: Einsaat einer winterharten Begrünungsmischung ohne Leguminosen bis 15.05. bzw. Belassen eines Grünbrache-/Ackerfutterbestandes fehlt.",
} if {
	some p in ag_parcels
	ag_first_year(p) == year
	not ag_establishment_ok(p)
}

# Umbruch frühestens am 15.09. des 2. Jahres (betriebsübergreifend gerechnet)
ag_earliest_breakup(p) := md_date(ag_first_year(p) + 1, ag.earliest_breakup_month_day_second_year)

violations contains {
	"rule_id": "o6_16.ag.breakup_date",
	"parcel_id": p.parcel_id,
	"message": sprintf("AG: Umbruch am %v vor dem frühestmöglichen Termin %v.", [d, ag_earliest_breakup(p)]),
} if {
	some p in ag_parcels
	d := ag_option(p).breakup_date
	is_date(d)
	date_lt(d, ag_earliest_breakup(p))
}

# kein Einsatz von Pflanzenschutz- und Düngemitteln
ag_inputs_used(p) if object.get(p, ["operations", "psm_used"], false) == true

ag_inputs_used(p) if count(psm_applications(p)) > 0

ag_inputs_used(p) if count(fertilizer_applications(p)) > 0

ag_inputs_used(p) if object.get(p, ["operations", "fertilizer", "mineral_n_kg_per_ha"], 0) > 0

ag_inputs_used(p) if object.get(p, ["operations", "fertilizer", "organic_n_kg_per_ha"], 0) > 0

violations contains {
	"rule_id": "o6_16.ag.no_psm_no_fertilizer",
	"parcel_id": p.parcel_id,
	"message": "AG: Einsatz von Pflanzenschutz- oder Düngemitteln ab 1.1. des ersten AG-Jahres nicht erlaubt.",
} if {
	some p in ag_parcels
	ag_inputs_used(p)
}

# Mahd/Häckseln mindestens einmal jedes zweite Jahr
ag_mown_in(p, yr) if yr in {y | some y in object.get(ag_option(p), "mowing_or_mulching_years", [])}

ag_mown_in(p, yr) if {
	some d in object.get(p, ["operations", "cutting_dates"], [])
	date_year(d) == yr
}

violations contains {
	"rule_id": "o6_16.ag.mowing_every_second_year",
	"parcel_id": p.parcel_id,
	"message": "AG: Mahd oder Häckseln mindestens einmal jedes zweite Jahr fehlt.",
} if {
	some p in ag_parcels
	year >= ag_first_year(p) + 1
	not ag_mown_in(p, year)
	not ag_mown_in(p, year - 1)
}

violations contains {
	"rule_id": "o6_16.ag.no_grazing_no_threshing",
	"parcel_id": p.parcel_id,
	"message": "AG: Beweidung und Drusch sind nicht erlaubt.",
} if {
	some p in ag_parcels
	ag_grazed_or_threshed(p)
}

ag_grazed_or_threshed(p) if object.get(ag_option(p), "grazed", false) == true

ag_grazed_or_threshed(p) if object.get(ag_option(p), "threshed", false) == true

# Prämienfläche AG: max. 20 % der Ackerfläche des Betriebes
ag_premium_area_uncapped := sum([ag_eligible_area(p) | some p in ag_parcels; ag_parcel_eligible(p)])

ag_premium_area := min([ag_premium_area_uncapped, ag.premium_max_share_of_farm_arable * farm_arable_ha])

# ---------------------------------------------------------------------------
# 4.9 Zuschlag Humusaufbau und Erosionsschutz in Wien
# ---------------------------------------------------------------------------

humus_vienna if option_applied("humus_erosion_vienna")

violations contains {
	"rule_id": "o6_16.vienna.area_required",
	"parcel_id": null,
	"message": "Zuschlag Humusaufbau und Erosionsschutz in Wien setzt Ackerflächen in der Gebietskulisse Wien voraus.",
} if {
	humus_vienna
	count(vienna_arable) == 0
}

previous_crop_maize(p) if object.get(p, ["previous_crop", "crop_category"], "") == "maize"

previous_crop_maize(p) if name_in(object.get(p, ["previous_crop", "crop_name"], ""), ["Mais", "Körnermais", "Silomais", "Corn-Cob-Mix", "Zuckermais", "Saatmaisvermehrung"])

violations contains {
	"rule_id": "o6_16.vienna.no_inversion_tillage",
	"parcel_id": p.parcel_id,
	"message": "Wendende Bodenbearbeitung auf Ackerflächen der Gebietskulisse Wien unzulässig (ausgenommen nach Mais).",
} if {
	humus_vienna
	some p in vienna_arable
	object.get(p, ["operations", "tillage_type"], "") == "plough"
	not previous_crop_maize(p)
}

violations contains {
	"rule_id": "o6_16.vienna.scientific_project",
	"parcel_id": null,
	"message": "Teilnahmebestätigung für das anerkannte Projekt (wissenschaftliche Begleitung) fehlt bzw. Daten nicht bereitgestellt.",
} if {
	humus_vienna
	not vienna_project_ok
}

vienna_project_ok if {
	o16.humus_erosion_vienna.project_confirmation == true
	object.get(o16, ["humus_erosion_vienna", "data_provided_on_request"], true) == true
}

vienna_training_fulfilled if vienna_extra_training_hours >= params.vienna_humus.extra_training_hours

violations contains {
	"rule_id": "o6_16.vienna.extra_training",
	"parcel_id": null,
	"message": "Zusätzliche 3 Stunden Bildung und Beratung (Bodenproben, Humusaufbau, pfluglose Bodenbearbeitung) nicht bis 31.12.2026 absolviert.",
} if {
	humus_vienna
	not vienna_training_fulfilled
	deadline_passed(params.training.deadline)
}

vienna_soil_samples_required := params.vienna_humus.soil_sample_multiplier * soil_samples_required(vienna_arable_ha)

vienna_creditable_samples := [s | some s in creditable_soil_samples; object.get(s, "area", "") == "wien_gebiet"]

violations contains {
	"rule_id": "o6_16.vienna.double_soil_samples",
	"parcel_id": null,
	"message": sprintf("Wien: %v Bodenproben erforderlich (2 je angefangene 5 ha), %v vorhanden.", [vienna_soil_samples_required, count(vienna_creditable_samples)]),
} if {
	humus_vienna
	count(vienna_creditable_samples) < vienna_soil_samples_required
	deadline_passed(params.soil_samples.deadline)
}

# Auf Wiener Teilnahmeflächen keine Prämie aus o6_8 für Mulchsaat, Direktsaat, Strip-Till
o6_8_premium_excluded contains p.parcel_id if {
	humus_vienna
	some p in vienna_arable
	some practice in object.get(p, ["oepul", "o6_8_practices"], [])
	practice in {x | some x in params.vienna_humus.excluded_o6_8_variants}
}

# ---------------------------------------------------------------------------
# 4.10 Zuschlag stark stickstoffreduzierte Fütterung von Schweinen
# ---------------------------------------------------------------------------

protein_limits(category) := [row | some row in params.crude_protein_limits; row.feeding_category == category]

average_limit(category) := row.max_g_per_kg_88_tm if {
	some row in protein_limits(category)
	row.basis == "average"
}

feeding(sg) := object.get(sg, "feeding", {})

# Durchschnittswert eingehalten
pig_group_average_ok(sg) if {
	cp := feeding(sg).crude_protein_avg_g_per_kg
	is_number(cp)
	cp <= average_limit(feeding(sg).feeding_category)
}

# Phasenfütterung (nur Jung-/Mastschweine, ungedeckte Jungsauen): jede Phase unter Höchstgrenze
phase_limit(category, phase) := row.max_g_per_kg_88_tm if {
	some row in protein_limits(category)
	row.basis == "phase"
	row.weight_from_kg == phase.weight_from_kg
}

pig_group_phase_ok(sg) if {
	feeding(sg).feeding_category == "jung_mast_jungsau_ungedeckt"
	feeding(sg).phase_feeding == true
	phases := feeding(sg).phases
	count(phases) > 0
	every ph in phases {
		ph.crude_protein_g_per_kg <= phase_limit(feeding(sg).feeding_category, ph)
	}
}

pig_group_protein_ok(sg) if pig_group_average_ok(sg)

pig_group_protein_ok(sg) if pig_group_phase_ok(sg)

violations contains {
	"rule_id": "o6_16.pig_feeding.crude_protein_limits",
	"parcel_id": null,
	"message": sprintf("Schweinegruppe %v: Rohproteingrenze (je kg bei 88 %% TM) nicht eingehalten.", [object.get(feeding(sg), "feeding_category", "?")]),
} if {
	option_applied("n_reduced_pig_feeding")
	some sg in pig_groups
	not pig_group_protein_ok(sg)
}

violations contains {
	"rule_id": "o6_16.pig_feeding.evidence",
	"parcel_id": null,
	"message": "Nachweis über Rezepturen mit ausgewiesenem Rohproteingehalt (88 % TM) bzw. Plausibilisierung der Phasenfütterung fehlt.",
} if {
	option_applied("n_reduced_pig_feeding")
	some sg in pig_groups
	not pig_feeding_evidence_ok(sg)
}

pig_feeding_evidence_ok(sg) if {
	feeding(sg).recipe_evidence_available == true
	not feeding(sg).phase_feeding == true
}

pig_feeding_evidence_ok(sg) if {
	feeding(sg).recipe_evidence_available == true
	feeding(sg).phase_feeding == true
	feeding(sg).phase_feeding_plausible == true
}

pig_feeding_eligible if {
	option_applied("n_reduced_pig_feeding")
	pig_feeding_min_density_met
	not participates(params.pig_feeding_excluded_with)
}

# ---------------------------------------------------------------------------
# 4.11 Zuschlag Cultan-Düngung (ab 2025)
# ---------------------------------------------------------------------------

cultan_applications(p) := [a | some a in fertilizer_applications(p); a.method == "cultan_injection"]

cultan_parcel_ok(p) if {
	year >= params.cultan.from_year
	in_area(p)
	is_arable(p)
	not is_ag(p)
	count(cultan_applications(p)) > 0
	every a in cultan_applications(p) {
		object.get(a, "recorded", false) == true
		cultan_contractor_ok(a)
	}
}

cultan_contractor_ok(a) if object.get(a, "external_contractor", false) == false

cultan_contractor_ok(a) if {
	a.external_contractor == true
	a.contractor_invoice_available == true
}

violations contains {
	"rule_id": "o6_16.cultan.requirements",
	"parcel_id": p.parcel_id,
	"message": "CUL-Schlag: keine dokumentierte Cultan-Injektion (Ammoniumdepot), fehlende Aufzeichnung oder fehlender Nachweis bei betriebsfremden Geräten bzw. außerhalb Gebietskulisse/vor 2025.",
} if {
	some p in cul_parcels
	not cultan_parcel_ok(p)
}
