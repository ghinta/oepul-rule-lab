package oepul.o6_6

import rego.v1

measure := object.get(input, "o6_6", {})

variant_record(v) := record if {
	some record in data.variants
	record.id == v
	record.application_year_from <= measure.application_year
	record.application_year_to == null
}

variant_record(v) := record if {
	some record in data.variants
	record.id == v
	record.application_year_from <= measure.application_year
	record.application_year_to != null
	measure.application_year <= record.application_year_to
}

variant_config := record if {
	measure.variant != null
	record := variant_record(measure.variant)
}

profile_fields := {"application_year", "variant", "sow_date", "break_date", "mixing_partner_count", "plant_family_count", "full_coverage", "mineral_n_applied", "psm_applied", "mechanical_removal", "area_ha", "arable_area_ha"}

profile_missing contains field if {
	field := profile_fields[_]
	object.get(measure, field, null) == null
}

variant_6_crop_allowed(crop) if {
	crop in data.variant_6_allowed_crops
}

variant_1_date_valid if {
	measure.variant == 1
	measure.application_year <= 2024
	measure.sow_date <= sprintf("%d-07-31", [measure.application_year])
	measure.break_date >= sprintf("%d-10-10", [measure.application_year])
}

variant_1_date_valid if {
	measure.variant == 1
	measure.application_year >= 2025
	measure.sow_date <= sprintf("%d-08-10", [measure.application_year])
	measure.break_date >= sprintf("%d-09-15", [measure.application_year])
	measure.days_between_sowing_and_break >= 70
}

variant_date_valid if {
	measure.variant == 1
	variant_1_date_valid
}

variant_date_valid if {
	measure.variant != 1
	measure.variant == 2
	cfg := variant_record(measure.variant)
	measure.sow_date <= sprintf("%d-%s", [measure.application_year, cfg.sow_by])
	measure.break_date >= sprintf("%d-%s", [measure.application_year + 1, cfg.earliest_break])
}

variant_date_valid if {
	measure.variant == 3
	cfg := variant_record(measure.variant)
	measure.sow_date <= sprintf("%d-%s", [measure.application_year, cfg.sow_by])
	measure.break_date >= sprintf("%d-%s", [measure.application_year, cfg.earliest_break])
}

variant_date_valid if {
	measure.variant in {4, 5, 6}
	cfg := variant_record(measure.variant)
	measure.sow_date <= sprintf("%d-%s", [measure.application_year, cfg.sow_by])
	measure.break_date >= sprintf("%d-%s", [measure.application_year + 1, cfg.earliest_break])
}

variant_date_valid if {
	measure.variant == 7
	measure.sow_date <= sprintf("%d-09-15", [measure.application_year])
	measure.break_date >= sprintf("%d-01-31", [measure.application_year + 1])
}

partner_count_valid if {
	measure.variant == 6
	count(measure.mixture_crops) >= 1
}

partner_count_valid if {
	measure.variant != 6
	cfg := variant_record(measure.variant)
	measure.mixing_partner_count >= cfg.partners
	measure.plant_family_count >= cfg.families
}

variant_6_crops_valid if {
	measure.variant == 6
	count(measure.mixture_crops) > 0
	every crop in measure.mixture_crops {
		variant_6_crop_allowed(crop)
	}
}

variant_1_composition_valid if {
	measure.variant == 1
	measure.insect_pollinated_partner_count >= 5
	measure.plant_family_count >= 2
	measure.non_insect_pollinated_share < 0.10
}

variant_7_composition_valid if {
	measure.variant == 7
	measure.crop == "winter_rape"
	measure.mixing_partner_count >= 3
	measure.plant_family_count >= 2
}

travel_ban_valid if {
	measure.variant != 1
}

travel_ban_valid if {
	measure.variant == 1
	measure.application_year <= 2024
	measure.travel_date == null
}

travel_ban_valid if {
	measure.variant == 1
	measure.application_year >= 2025
	measure.travel_date == null
}

mechanical_removal_valid if {
	measure.variant == 7
}

mechanical_removal_valid if {
	measure.variant <= 6
	measure.mechanical_removal == true
}

drought_2026_cover_exemption if {
	measure.application_year == 2026
	measure.proper_installation == true
	measure.full_coverage == false
}

drought_2026_cover_exemption if {
	measure.application_year == 2026
	measure.proper_installation == true
	measure.volunteer_grain_share > 0.50
}

harvest_85_exemption_districts := {
	"Burgenland": "all",
	"Wien": "all",
	"Niederösterreich": {"Amstetten", "Baden", "Bruck an der Leitha", "Gänserndorf", "Gmünd", "Hollabrunn", "Horn", "Korneuburg", "Krems an der Donau Stadt", "Krems Land", "Melk", "Mistelbach", "Mödling", "Neunkirchen", "Sankt Pölten Land", "Sankt Pölten Stadt", "Scheibbs", "Tulln", "Waidhofen an der Thaya", "Wiener Neustadt Land", "Wiener Neustadt Stadt", "Zwettl"},
	"Oberösterreich": {"Eferding", "Grieskirchen", "Kirchdorf", "Linz", "Linz-Land", "Perg", "Steyr", "Steyr-Land", "Urfahr-Umgebung", "Wels", "Wels-Land"},
	"Steiermark": {"Graz", "Graz-Umgebung", "Hartberg-Fürstenfeld", "Leibnitz", "Südoststeiermark", "Weiz"},
}

drought_2026_harvest_exemption if {
	measure.application_year == 2026
	measure.drought_no_harvestable_stock == true
	measure.federal_state in harvest_85_exemption_districts
	districts := harvest_85_exemption_districts[measure.federal_state]
	districts == "all"
	measure.crop_harvest_period == "late_summer_or_autumn"
}

drought_2026_harvest_exemption if {
	measure.application_year == 2026
	measure.drought_no_harvestable_stock == true
	measure.federal_state in harvest_85_exemption_districts
	districts := harvest_85_exemption_districts[measure.federal_state]
	districts != "all"
	measure.district in districts
	measure.crop_harvest_period == "late_summer_or_autumn"
}

violations contains {"code": "NO_MINIMUM_AREA", "message": "Mindestens 1,50 ha Ackerfläche müssen in jedem Teilnahmejahr bewirtschaftet werden."} if {
	measure.arable_area_ha < 1.50
}

violations contains {"code": "NO_GREENED_PARCEL", "message": "Wird kein begrünter Schlag beantragt, erlischt der Vertrag für die Maßnahme."} if {
	measure.has_greened_parcel == false
}

violations contains {"code": "NO_ARABLE_ELIGIBILITY", "message": "Die Maßnahme ist auf Ackerflächen mit aktiv angelegter Begrünung zwischen zwei Hauptfrüchten bzw. Begleitsaaten im Raps auszuführen."} if {
	measure.area_ha > 0
	measure.land_use != "arable"
}

violations contains {"code": "NOT_FULL_COVER", "message": "Eine flächendeckende Begrünung ist grundsätzlich erforderlich."} if {
	measure.full_coverage == false
	not drought_2026_cover_exemption
}

violations contains {"code": "NOT_ACTIVE", "message": "Die Begrünung muss aktiv durch Ansaat oder Untersaat angelegt werden."} if {
	measure.active_sowing == false
}

violations contains {"code": "VOLUNTEER_OR_SELF_GREENING", "message": "Ausfall, Druschausfall und selbstbegrünende Flächen zählen nicht als Zwischenfrucht."} if {
	measure.volunteer_or_self_greening == true
}

violations contains {"code": "INVALID_CROP_MIX", "message": "Getreide/Mais bzw. Mischungen mit mehr als 50 % Getreide und/oder Mais sind nicht zulässig, außer zulässige Grünschnittroggensorten in Variante 6."} if {
	measure.grain_maize_share > 0.50
	measure.variant != 6
}

violations contains {"code": "INVALID_VARIANT_DATE", "message": "Anlage und frühester Umbruch entsprechen nicht der gewählten Begrünungsvariante."} if {
	measure.variant != null
	not variant_date_valid
}

violations contains {"code": "INVALID_PARTNERS", "message": "Die erforderliche Zahl an Mischungspartnern und Pflanzenfamilien ist nicht erfüllt."} if {
	measure.variant != null
	not partner_count_valid
}

violations contains {"code": "INVALID_VARIANT_1_COMPOSITION", "message": "Variante 1 erfordert mindestens fünf insektenblütige Partner aus mindestens zwei Pflanzenfamilien; nicht-insektenblütige Pflanzen sind nur unter 10 % zulässig."} if {
	measure.variant == 1
	not variant_1_composition_valid
}

violations contains {"code": "INVALID_VARIANT_6_CROPS", "message": "Variante 6 erlaubt ausschließlich die in der Regel genannten winterharten Kulturen oder deren Mischungen."} if {
	measure.variant == 6
	not variant_6_crops_valid
}

violations contains {"code": "INVALID_VARIANT_7", "message": "Variante 7 erfordert Winterraps und mindestens drei Mischungspartner aus mindestens zwei Pflanzenfamilien."} if {
	measure.variant == 7
	not variant_7_composition_valid
}

violations contains {"code": "MINERAL_N", "message": "Mineralische Stickstoffdüngung ist vom Zeitpunkt der Anlage bis zum Ende des Begrünungszeitraums verboten; auch kombinierte Düngung bei der Ansaat ist unzulässig."} if {
	measure.mineral_n_applied == true
}

violations contains {"code": "PSM", "message": "Pflanzenschutzmittel dürfen grundsätzlich vom Zeitpunkt der Anlage bis zum Ende des Begrünungszeitraums nicht eingesetzt werden."} if {
	measure.psm_applied == true
	measure.variant != 7
	measure.psm_after_follow_crop_sowing != true
}

violations contains {"code": "VARIANT_7_HERBICIDE", "message": "Bei Variante 7 ist Herbizideinsatz nach dem Vierblattstadium des Rapses bis zum Ende des Begrünungszeitraums verboten."} if {
	measure.variant == 7
	measure.herbicide_after_four_leaf_stage == true
}

violations contains {"code": "SOIL_DISTURBANCE", "message": "Aktive Bodenbearbeitung, die die Begrünung absterben lässt oder den Zweck beeinträchtigt, ist während des Begrünungszeitraums nicht zulässig."} if {
	measure.harmful_soil_tillage == true
}

violations contains {"code": "KNIFE_ROLLER", "message": "Messerwalzen sind während des Begrünungszeitraums nicht zulässig."} if {
	measure.knife_roller_used == true
	measure.after_frost == false
}

violations contains {"code": "NO_REGROWTH", "message": "Häckseln/Pflegemahd während des Begrünungszeitraums ist nur zulässig, wenn Nachwachsen, Erosionsschutz, Nitratrückhalt und flächendeckende Begrünung gesichert sind."} if {
	measure.maintenance_action == "chopping_or_mowing"
	measure.regrowth_expected == false
}

violations contains {"code": "TRAVEL_BAN", "message": "Das Befahrungsverbot der Variante 1 bis zum maßgeblichen Stichtag ist einzuhalten; nur das Überqueren zur Bewirtschaftung von Nachbarflächen ist ausgenommen."} if {
	measure.variant == 1
	measure.travel_date != null
	measure.travel_is_neighbor_crossing != true
	measure.travel_date <= measure.travel_ban_until
}

violations contains {"code": "THRESHING", "message": "Zwischenfrüchte dürfen nicht gedroschen werden; bei Drusch ist die Kultur als Schlagnutzung zu beantragen."} if {
	measure.threshed == true
}

violations contains {"code": "NO_MECHANICAL_REMOVAL", "message": "Zwischenfruchtbegrünungen der Varianten 1 bis 6 müssen mechanisch beseitigt werden."} if {
	measure.variant <= 6
	measure.removal_done == true
	not mechanical_removal_valid
}

violations contains {"code": "INVALID_AUTUMN_MAIN_CROP", "message": "Nach Variante 1 ist verpflichtend eine Hauptkultur im Herbst anzubauen und im folgenden Mehrfachantrag zu beantragen."} if {
	measure.variant == 1
	measure.autumn_main_crop_planted != true
}

violations contains {"code": "VARIANT_7_NO_N", "message": "Auch bei Variante 7 gilt das Mineralstickstoffverbot bis zum Ende des Begrünungszeitraums."} if {
	measure.variant == 7
	measure.mineral_n_applied == true
}

violations contains {"code": "APPLICATION_LATE", "message": "Die Maßnahme muss vor Vertragsbeginn bis spätestens 31. Dezember des Vorjahres im Maßnahmenantrag beantragt werden."} if {
	measure.application_year != null
	measure.measure_application_date > sprintf("%d-12-31", [measure.application_year - 1])
}

violations contains {"code": "MFA_VARIANT_LATE", "message": "Die Begrünung ist im Mehrfachantrag fristgerecht zu beantragen: Varianten 1–3 bis 31. August, Varianten 4–7 bis 30. September."} if {
	measure.variant_application_date != null
	measure.variant <= 3
	measure.variant_application_date > sprintf("%d-08-31", [measure.application_year])
}

violations contains {"code": "MFA_VARIANT_LATE", "message": "Die Begrünung ist im Mehrfachantrag fristgerecht zu beantragen: Varianten 1–3 bis 31. August, Varianten 4–7 bis 30. September."} if {
	measure.variant_application_date != null
	measure.variant >= 4
	measure.variant_application_date > sprintf("%d-09-30", [measure.application_year])
}

violations contains {"code": "GLÖZ8_NPF_2024", "message": "Im Antragsjahr 2024 im Rahmen der Konditionalität beantragte Zwischenfrüchte Variante 1 NPF bis Variante 6 NPF sind nicht förderbar."} if {
	measure.application_year == 2024
	measure.gloez8_npf == true
}

violations contains {"code": "NO_CONCURRENT_IMMERGRUEN", "message": "Eine gleichzeitige Teilnahme an Zwischenfruchtanbau und System Immergrün ist nicht möglich."} if {
	measure.participates_immergruen == true
}

violations contains {"code": "HARVEST_85", "message": "Auf Ackerflächen ist grundsätzlich Ernte und Verbringen des Erntegutes auf mindestens 85 % des Schlages erforderlich."} if {
	measure.harvested_share < 0.85
	not drought_2026_harvest_exemption
}

violations contains {"code": "APPLICATION_NOT_CORRECTED", "message": "Wenn die beantragte Begrünungsvariante nicht angelegt werden kann, ist sie umgehend zu streichen, zu reduzieren oder auf eine spätere Variante zu ändern."} if {
	measure.application_year == 2026
	measure.sowing_will_not_occur == true
	measure.application_corrected != true
}

violations contains {"code": "CONDITIONALITY", "message": "Die Konditionalitätsbestimmungen sind von allen ÖPUL-Teilnehmern einzuhalten."} if {
	measure.conditionality_compliant == false
}

premium_band := data.premium_bands_eur_per_ha[sprintf("%d", [measure.variant])] if {
	measure.variant != null
}

premium_guaranteed_minimum := premium_band.min if {
	premium_band != null
}

eligible := count(violations) == 0

decision := {
	"eligible": eligible,
	"measure": "o6_6",
	"variant": object.get(measure, "variant", null),
	"violations": violations,
	"profile_missing": profile_missing,
	"premium_band_eur_per_ha": object.get(data.premium_bands_eur_per_ha, sprintf("%d", [object.get(measure, "variant", 0)]), null),
}
