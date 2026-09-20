package oepul.o6_16

import rego.v1

default eligible := false

eligible if {
	input.oepul.o6_16.enrolled
	input.oepul.o6_16.cover_crop_measure in {"zwischenfruchtanbau", "system_immergruen"}
	input.oepul.o6_16.first_year_area_in_eligible_zone_ha >= 2
}

violations contains v if {
	input.oepul.o6_16.enrolled
	not eligible
	v := {"rule_id": "o6_16.entry", "message": "Mindestfläche oder Begrünungs-Kombinationsverpflichtung fehlt."}
}

violations contains v if {
	input.oepul.o6_16.business_plan_date > "2026-02-28"
	v := {"rule_id": "o6_16.records.plan", "message": "Voraussichtliche Düngeplanung ist verspätet."}
}

violations contains v if {
	input.oepul.o6_16.business_balance_date > "2027-01-31"
	v := {"rule_id": "o6_16.records.balance", "message": "Betriebliche Düngebilanz ist verspätet."}
}

violations contains v if {
	some p in input.oepul.o6_16.parcels
	p.in_eligible_zone
	p.crop_area_ha > 0.3
	not p.electronic_field_record
	v := {"rule_id": "o6_16.field_records", "parcel_id": p.parcel_id, "message": "Elektronische schlagbezogene Aufzeichnung fehlt."}
}

violations contains v if {
	some p in input.oepul.o6_16.parcels
	p.in_eligible_zone
	p.record_completion_days_after_event > 14
	v := {"rule_id": "o6_16.field_records.timeliness", "parcel_id": p.parcel_id, "message": "Schlagaufzeichnung wurde nicht binnen 14 Tagen fertiggestellt."}
}

nitrogen_transfer_factor(high_reduction_area) := 0.8 if {
	high_reduction_area
}

nitrogen_transfer_factor(high_reduction_area) := 0.6 if {
	not high_reduction_area
}

nitrogen_transfer_kg_per_ha(saldo, year, high_reduction_area) := transfer if {
	year <= 2024
	saldo > 10
	factor := nitrogen_transfer_factor(high_reduction_area)
	transfer := saldo * factor
}

nitrogen_transfer_kg_per_ha(saldo, year, high_reduction_area) := transfer if {
	year >= 2025
	saldo > 20
	capped := min([saldo, 100])
	factor := nitrogen_transfer_factor(high_reduction_area)
	transfer := capped * factor
}

violations contains v if {
	some p in input.oepul.o6_16.parcels
	p.in_eligible_zone
	required := nitrogen_transfer_kg_per_ha(p.previous_nitrogen_surplus_kg_per_ha, input.farm.year, p.high_reduction_area)
	p.nitrogen_reduction_next_crop_kg_per_ha < required
	v := {"rule_id": "o6_16.nitrogen.transfer", "parcel_id": p.parcel_id, "required_reduction": required, "message": "Stickstoffüberschuss wurde nicht ausreichend auf die Folgekultur angerechnet."}
}

violations contains v if {
	some p in input.oepul.o6_16.parcels
	p.in_eligible_zone
	p.previous_nitrogen_surplus_kg_per_ha > 30
	not p.autumn_follow_crop_or_eligible_cover_by_15_nov
	not p.harvest_after_30_sep
	v := {"rule_id": "o6_16.nitrogen.autumn_crop", "parcel_id": p.parcel_id, "message": "Erforderliche Herbstfolge- oder Zwischenfrucht fehlt."}
}

violations contains v if {
	input.oepul.o6_16.training_hours < 10
	v := {"rule_id": "o6_16.training", "message": "Mindestens zehn Weiterbildungsstunden fehlen."}
}

violations contains v if {
	not input.oepul.o6_16.water_protection_concept_completed
	v := {"rule_id": "o6_16.water_concept", "message": "Betriebsbezogenes Gewässerschutzkonzept fehlt."}
}

required_soil_samples(area) := ceil(area / 5)

violations contains v if {
	required := required_soil_samples(input.oepul.o6_16.arable_area_eligible_zone_2026_ha)
	input.oepul.o6_16.accredited_soil_samples_submitted < required
	v := {"rule_id": "o6_16.soil_samples", "required": required, "message": "Mindestanzahl akkreditierter Bodenproben nicht erfüllt."}
}

violations contains v if {
	some p in input.oepul.o6_16.parcels
	p.in_eligible_zone
	p.crop in data.restricted_crops
	some a in p.active_ingredients
	a in data.banned_active_ingredients
	v := {"rule_id": "o6_16.psm.ban", "parcel_id": p.parcel_id, "active_ingredient": a, "message": "Unzulässiger Pflanzenschutzwirkstoff."}
}

violations contains v if {
	some p in input.oepul.o6_16.parcels
	p.upper_austria
	p.lightly_soluble_n_application_date >= "2026-10-15"
	p.lightly_soluble_n_application_date <= "2027-02-15"
	not p.is_arable_fodder
	v := {"rule_id": "o6_16.upper_austria.closed_period", "parcel_id": p.parcel_id, "message": "Leichtlöslicher Stickstoff im Sperrzeitraum ausgebracht."}
}

violations contains v if {
	some p in input.oepul.o6_16.parcels
	p.ag_option
	p.average_soil_number > 40
	v := {"rule_id": "o6_16.ag.soil_number", "parcel_id": p.parcel_id, "message": "AG-Option nur bis durchschnittlicher Ackerzahl 40."}
}

violations contains v if {
	some p in input.oepul.o6_16.parcels
	p.ag_option
	p.ag_sown_date > "2026-05-15"
	not p.existing_green_fallow_or_arable_fodder
	v := {"rule_id": "o6_16.ag.sowing", "parcel_id": p.parcel_id, "message": "Winterharte Begrünung nicht fristgerecht angelegt."}
}

violations contains v if {
	some p in input.oepul.o6_16.parcels
	p.ag_option
	p.ag_uses_fertilizer_or_psm
	v := {"rule_id": "o6_16.ag.no_inputs", "parcel_id": p.parcel_id, "message": "Auf AG-Fläche sind Düngung und Pflanzenschutz verboten."}
}

violations contains v if {
	input.oepul.o6_16.wien_humus_option
	some p in input.oepul.o6_16.parcels
	p.in_wien_zone
	p.plough_used
	not p.tillage_after_maize
	v := {"rule_id": "o6_16.wien.no_plough", "parcel_id": p.parcel_id, "message": "Wendende Bodenbearbeitung in Wien unzulässig."}
}

violations contains v if {
	input.oepul.o6_16.pig_feed_option
	input.oepul.o6_16.pig_gve_per_arable_ha < 1
	v := {"rule_id": "o6_16.pig_feed.minimum_gve", "message": "Mindestens 1,00 GVE Schweine je ha Ackerfläche fehlen."}
}

violations contains v if {
	input.oepul.o6_16.cultan_option
	some p in input.oepul.o6_16.parcels
	p.cultan_claimed
	not p.cultan_ammonium_depot_injected
	v := {"rule_id": "o6_16.cultan.application", "parcel_id": p.parcel_id, "message": "Cultan-Ammoniumdepot-Injektion fehlt."}
}

premium_base_eur_per_ha := amount if {
	input.farm.year == 2023
	amount := data.premiums_eur_per_ha["2023"].base
}

premium_base_eur_per_ha := amount if {
	input.farm.year >= 2024
	amount := data.premiums_eur_per_ha["2024_plus"].base
}

# The Anhang-G list is deliberately kept as data, rather than duplicating 1,566
# Katastralgemeinden in policy.  A KG number is the stable GIS-facing key.
kg_in_eligible_zone(kg_number) if {
	some row in data.eligible_katastralgemeinden
	row.kg_number == kg_number
}

premium_base_for_participation_eur_per_ha(year, bio_or_eb) := amount if {
	year == 2023
	bio_or_eb
	amount := data.premiums_eur_per_ha["2023"].base_bio_or_eb
}

premium_base_for_participation_eur_per_ha(year, bio_or_eb) := amount if {
	year == 2023
	not bio_or_eb
	amount := data.premiums_eur_per_ha["2023"].base
}

premium_base_for_participation_eur_per_ha(year, bio_or_eb) := amount if {
	year >= 2024
	bio_or_eb
	amount := data.premiums_eur_per_ha["2024_plus"].base_bio_or_eb
}

premium_base_for_participation_eur_per_ha(year, bio_or_eb) := amount if {
	year >= 2024
	not bio_or_eb
	amount := data.premiums_eur_per_ha["2024_plus"].base
}

violations contains v if {
	some p in input.oepul.o6_16.parcels
	p.in_eligible_zone
	p.upper_austria
	p.is_maize
	p.lightly_soluble_n_application_date >= "2026-10-15"
	p.lightly_soluble_n_application_date <= "2027-03-21"
	v := {"rule_id": "o6_16.upper_austria.maize_closed_period", "parcel_id": p.parcel_id, "message": "Leichtlöslicher Stickstoff bei Mais im erweiterten Sperrzeitraum ausgebracht."}
}

violations contains v if {
	some p in input.oepul.o6_16.parcels
	p.in_eligible_zone
	p.upper_austria
	p.nitrogen_application_kg_per_ha > 80
	not p.delayed_release_fertilizer
	not p.nitrogen_gift_split
	v := {"rule_id": "o6_16.upper_austria.split_gift", "parcel_id": p.parcel_id, "message": "Stickstoffgabe über 80 kg/ha wurde nicht geteilt."}
}

violations contains v if {
	some p in input.oepul.o6_16.parcels
	p.in_eligible_zone
	p.upper_austria
	p.cover_crop_variant == 3
	v := {"rule_id": "o6_16.upper_austria.no_cover_crop_variant_3", "parcel_id": p.parcel_id, "message": "Begrünungsvariante 3 ist in Oberösterreich unzulässig."}
}

violations contains v if {
	some p in input.oepul.o6_16.parcels
	p.in_eligible_zone
	p.upper_austria
	p.chemical_psm_used
	not p.pre_psm_field_inspection_documented
	not p.warndienst_notice_documented
	v := {"rule_id": "o6_16.upper_austria.integrated_psm", "parcel_id": p.parcel_id, "message": "Kontrollgang oder Warndienstmeldung vor chemischer Pflanzenschutzmaßnahme fehlt."}
}

violations contains v if {
	some p in input.oepul.o6_16.parcels
	p.ag_option
	p.ag_plough_date < p.ag_second_year_september_15
	v := {"rule_id": "o6_16.ag.minimum_duration", "parcel_id": p.parcel_id, "message": "AG-Fläche vor dem 15. September des zweiten Jahres umgebrochen."}
}

violations contains v if {
	some p in input.oepul.o6_16.parcels
	p.ag_option
	not p.ag_mown_or_mulched_in_two_years
	v := {"rule_id": "o6_16.ag.maintenance", "parcel_id": p.parcel_id, "message": "AG-Fläche wurde nicht mindestens einmal in zwei Jahren gemäht oder gehäckselt."}
}

violations contains v if {
	some p in input.oepul.o6_16.parcels
	p.ag_option
	p.ag_grazed_or_harvested
	v := {"rule_id": "o6_16.ag.no_grazing_or_harvest", "parcel_id": p.parcel_id, "message": "Beweidung oder Drusch auf AG-Fläche ist unzulässig."}
}

violations contains v if {
	input.oepul.o6_16.wien_humus_option
	not input.oepul.o6_16.wien_project_participation_confirmation
	v := {"rule_id": "o6_16.wien.project_confirmation", "message": "Teilnahmebestätigung der wissenschaftlichen Begleitung fehlt."}
}

violations contains v if {
	input.oepul.o6_16.wien_humus_option
	input.oepul.o6_16.wien_training_hours < 3
	v := {"rule_id": "o6_16.wien.additional_training", "message": "Drei zusätzliche Stunden Bildung und Beratung fehlen."}
}

required_wien_soil_samples(area) := ceil(area / 5) * 2

violations contains v if {
	input.oepul.o6_16.wien_humus_option
	required := required_wien_soil_samples(input.oepul.o6_16.wien_zone_arable_area_2026_ha)
	input.oepul.o6_16.wien_accredited_soil_samples_submitted < required
	v := {"rule_id": "o6_16.wien.soil_samples", "required": required, "message": "Doppelte Mindestanzahl Wiener Bodenproben nicht erfüllt."}
}

violations contains v if {
	input.oepul.o6_16.pig_feed_option
	some category, values in input.oepul.o6_16.pig_protein_g_per_kg_88_tm
	limits := data.protein_limits_g_per_kg_88_tm[category]
	values.average > limits.average_max
	v := {"rule_id": "o6_16.pig_feed.protein_average", "category": category, "message": "Rohprotein-Durchschnittsgrenze überschritten."}
}

violations contains v if {
	input.oepul.o6_16.pig_feed_option
	some category, values in input.oepul.o6_16.pig_protein_g_per_kg_88_tm
	limits := data.protein_limits_g_per_kg_88_tm[category]
	values.phase > limits.phase_max
	v := {"rule_id": "o6_16.pig_feed.protein_phase", "category": category, "message": "Rohprotein-Phasengrenze überschritten."}
}

violations contains v if {
	input.oepul.o6_16.pig_feed_option
	not input.oepul.o6_16.pig_feed_recipe_evidence
	v := {"rule_id": "o6_16.pig_feed.evidence", "message": "Rezeptur- oder Fütterungsnachweis fehlt."}
}

violations contains v if {
	input.oepul.o6_16.cultan_option
	input.farm.year < 2025
	v := {"rule_id": "o6_16.cultan.start_year", "message": "Cultan-Zuschlag erst ab Antragsjahr 2025 verfügbar."}
}

violations contains v if {
	input.oepul.o6_16.cultan_option
	some p in input.oepul.o6_16.parcels
	p.cultan_claimed
	not p.cultan_field_record_complete
	v := {"rule_id": "o6_16.cultan.field_record", "parcel_id": p.parcel_id, "message": "Schlagbezogene Cultan-Aufzeichnung fehlt."}
}

violations contains v if {
	input.oepul.o6_16.cultan_option
	some p in input.oepul.o6_16.parcels
	p.cultan_claimed
	p.cultan_contractor_equipment
	not p.cultan_contractor_evidence
	v := {"rule_id": "o6_16.cultan.contractor_evidence", "parcel_id": p.parcel_id, "message": "Nachweis für betriebsfremdes Cultan-Gerät fehlt."}
}

ag_option_premium_area_ha(total_arable_area_ha, ag_claimed_area_ha) := min([ag_claimed_area_ha, total_arable_area_ha * 0.2])
