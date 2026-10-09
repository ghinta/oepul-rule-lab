package oepul.o6_7

import rego.v1

thresholds := data.o6_7_thresholds

# The generated profile-change proposals place measure facts under farm.oepul;
# the explicit measure object remains accepted for backwards-compatible runs.
measure := object.get(input, "measure", {}).o6_7
farm_measure := object.get(object.get(input, "farm", {}), "oepul", {})
drought_2026 := object.get(farm_measure, "drought_2026", {})
facts := object.union(object.union(farm_measure, drought_2026), measure)

participating if {
	facts.participating == true
}

default green_cover_exception_applies := false

default harvest_exception_applies := false

default late_planting_exception_applies := false

default eligible := false

green_cover_exception_applies if {
	input.farm.year == 2026
	facts.proper_establishment == true
	facts.field_emergence_full_cover == false
}

green_cover_exception_applies if {
	input.farm.year == 2026
	facts.proper_establishment == true
	facts.volunteer_cereal_share_percent > 50
}

harvest_exception_applies if {
	input.farm.year == 2026
	facts.drought_no_harvestable_stand == true
	state := input.farm.region.federal_state
	districts := data.duerre_2026.harvest_obligation_exception.states[state]
	districts[_] == "all_districts"
}

harvest_exception_applies if {
	input.farm.year == 2026
	facts.drought_no_harvestable_stand == true
	state := input.farm.region.federal_state
	district := input.farm.region.district
	districts := data.duerre_2026.harvest_obligation_exception.states[state]
	districts[_] == district
}

late_planting_exception_applies if {
	input.farm.year == 2026
	facts.credible_forward_management == true
	facts.planting_conditions_unavailable == true
}

gap_exceeds(gap) if {
	gap.main_harvest_to_intercrop > thresholds.maximum_gap_days.main_harvest_to_intercrop
}

gap_exceeds(gap) if {
	gap.intercrop_turnover_to_main_sowing > thresholds.maximum_gap_days.intercrop_turnover_to_main_sowing
}

gap_exceeds(gap) if {
	gap.main_harvest_to_main_sowing > thresholds.maximum_gap_days.main_harvest_to_main_sowing
}

violations contains {"rule_id": "O6_7_MIN_AREA", "message": "Mindestens 1,50 ha Ackerfläche sind erforderlich."} if {
	participating
	input.land.arable_area_ha < thresholds.minimum_arable_area_ha
}

violations contains {"rule_id": "O6_7_COVER_SHARE", "message": "Mindestens 85 % der Ackerflächen müssen jederzeit begrünt sein."} if {
	participating
	facts.cover_share_percent < thresholds.minimum_cover_share_percent
	not green_cover_exception_applies
}

violations contains {"rule_id": "O6_7_HARVEST_SHARE", "message": "Auf mindestens 85 % jedes Ackerschlags muss geerntet und das Erntegut verbracht werden."} if {
	participating
	facts.harvest_share_percent < 85
	not harvest_exception_applies
}

violations contains {"rule_id": "O6_7_RECORDS", "message": "Schlagbezogene Aufzeichnungen sind vollständig und durchgehend zu führen."} if {
	participating
	facts.field_records_complete != true
}

violations contains {"rule_id": "O6_7_MEASURE_6_CONFLICT", "message": "Eine gleichzeitige Teilnahme an Maßnahme 6 ist nicht möglich."} if {
	participating
	facts.measure_6_participating == true
}

violations contains {"rule_id": "O6_7_GAP_LIMIT", "parcel_id": p.parcel_id, "message": "Ein begrünungsfreier Zeitraum überschreitet die maßnahmenspezifische Höchstdauer."} if {
	participating
	some p in input.land.parcels
	gap := p.operations.cover_crop.gap_days
	gap_exceeds(gap)
	not late_planting_exception_applies
}

violations contains {"rule_id": "O6_7_INTERCROP_LATEST_PLANTING", "parcel_id": p.parcel_id, "message": "Zwischenfrüchte sind spätestens am 15. Oktober aktiv anzulegen."} if {
	participating
	some p in input.land.parcels
	p.operations.cover_crop.is_used == true
	p.operations.cover_crop.active_planting_day_of_year > 288
}

violations contains {"rule_id": "O6_7_INTERCROP_DURATION", "parcel_id": p.parcel_id, "message": "Eine Zwischenfrucht muss mindestens 42 Kalendertage bestehen bleiben."} if {
	participating
	some p in input.land.parcels
	p.operations.cover_crop.is_used == true
	p.operations.cover_crop.duration_days < thresholds.intercrop.minimum_duration_days
}

violations contains {"rule_id": "O6_7_MIXTURE", "parcel_id": p.parcel_id, "message": "Die Zwischenfrucht erfüllt die Anforderungen an Mischungspartner und Pflanzenfamilien nicht."} if {
	participating
	some p in input.land.parcels
	p.operations.cover_crop.is_used == true
	p.operations.cover_crop.active_planting_day_of_year <= 263
	count(p.operations.cover_crop.mixture_partners) < thresholds.intercrop.minimum_mixture_partners
}

violations contains {"rule_id": "O6_7_MIXTURE", "parcel_id": p.parcel_id, "message": "Die Zwischenfrucht erfüllt die Anforderungen an Mischungspartner und Pflanzenfamilien nicht."} if {
	participating
	some p in input.land.parcels
	p.operations.cover_crop.is_used == true
	p.operations.cover_crop.active_planting_day_of_year <= 263
	count({partner.plant_family | partner := p.operations.cover_crop.mixture_partners[_]}) < thresholds.intercrop.minimum_plant_families
}

violations contains {"rule_id": "O6_7_WINTER_HARDINESS", "parcel_id": p.parcel_id, "message": "Nach dem 20. September angelegte Zwischenfrüchte müssen überwiegend winterhart sein."} if {
	participating
	input.farm.year >= 2025
	some p in input.land.parcels
	p.operations.cover_crop.is_used == true
	p.operations.cover_crop.active_planting_day_of_year > 263
	p.operations.cover_crop.winter_hardy_share_percent <= 50
}

violations contains {"rule_id": "O6_7_EARLIEST_TURNOVER", "parcel_id": p.parcel_id, "message": "Nach dem 20. September angelegte Zwischenfrüchte dürfen frühestens am 15. Februar umgebrochen werden."} if {
	participating
	some p in input.land.parcels
	p.operations.cover_crop.is_used == true
	p.operations.cover_crop.active_planting_day_of_year > 263
	p.operations.cover_crop.turnover_day_of_year < 46
}

violations contains {"rule_id": "O6_7_MINERAL_N", "parcel_id": p.parcel_id, "message": "Während des Begrünungszeitraums ist mineralische N-Düngung verboten."} if {
	participating
	some p in input.land.parcels
	p.operations.cover_crop.is_used == true
	p.operations.fertilizer.mineral_n_kg_per_ha > 0
}

violations contains {"rule_id": "O6_7_MINERAL_N", "parcel_id": p.parcel_id, "message": "Während des Begrünungszeitraums ist mineralische N-Düngung verboten."} if {
	participating
	some p in input.land.parcels
	p.operations.cover_crop.is_used == true
	p.operations.fertilizer.combined_sowing_fertilization == true
}

violations contains {"rule_id": "O6_7_PSM", "parcel_id": p.parcel_id, "message": "Während des Begrünungszeitraums ist der Einsatz von Pflanzenschutzmitteln verboten."} if {
	participating
	some p in input.land.parcels
	p.operations.cover_crop.is_used == true
	p.operations.psm_used == true
}

violations contains {"rule_id": "O6_7_FORBIDDEN_TILLAGE", "parcel_id": p.parcel_id, "message": "Bodenbearbeitung, die die Begrünung absterben lässt, ist nicht zulässig."} if {
	participating
	some p in input.land.parcels
	p.operations.cover_crop.is_used == true
	p.operations.cover_crop.tillage_kills_cover == true
}

violations contains {"rule_id": "O6_7_ROLLING", "parcel_id": p.parcel_id, "message": "Walzen ist nur unmittelbar nach der Anlage zur Rückverfestigung zulässig."} if {
	participating
	some p in input.land.parcels
	p.operations.cover_crop.is_used == true
	p.operations.cover_crop.rolling == true
	not p.operations.cover_crop.rolling_immediately_after_sowing
}

violations contains {"rule_id": "O6_7_OVERWINTER_MAINTENANCE", "parcel_id": p.parcel_id, "message": "Bei überwinternden Zwischenfrüchten ist Pflege bis einschließlich 31. Oktober verboten."} if {
	participating
	some p in input.land.parcels
	p.operations.cover_crop.overwintering == true
	p.operations.cover_crop.maintenance_day_of_year <= 304
}

violations contains {"rule_id": "O6_7_MECHANICAL_REMOVAL", "parcel_id": p.parcel_id, "message": "Zwischenfrüchte dürfen nur mechanisch beseitigt werden."} if {
	participating
	some p in input.land.parcels
	p.operations.cover_crop.is_used == true
	p.operations.cover_crop.mechanical_removal == false
}

violations contains {"rule_id": "O6_7_THRESHING", "parcel_id": p.parcel_id, "message": "Zwischenfrüchte dürfen nicht gedroschen werden."} if {
	participating
	some p in input.land.parcels
	p.operations.cover_crop.is_used == true
	p.operations.cover_crop.threshed == true
}

violations contains {"rule_id": "O6_7_APPLICATION", "message": "Der Maßnahmenantrag muss fristgerecht vor Vertragsbeginn vorliegen."} if {
	participating
	facts.application_submitted == false
}

violations contains {"rule_id": "O6_7_CONDITIONALITY", "message": "Die Konditionalitätsvorschriften müssen eingehalten werden."} if {
	participating
	facts.conditionality_compliant == false
}

violations contains {"rule_id": "O6_7_LOCATION", "parcel_id": p.parcel_id, "message": "Geförderte Flächen müssen in Österreich liegen."} if {
	participating
	some p in input.land.parcels
	p.country != null
	p.country != "AT"
}

violations contains {"rule_id": "O6_7_OP_CODE", "parcel_id": p.parcel_id, "message": "Flächen mit Code OP erhalten im Förderjahr keine ÖPUL-Prämie."} if {
	participating
	some p in input.land.parcels
	p.code == "OP"
}

violations contains {"rule_id": "O6_7_GLOEZ8_2024_EXCLUSION", "parcel_id": p.parcel_id, "message": "GLÖZ-8-NPF-Zwischenfrüchte der Varianten 1 bis 6 sind 2024 in o6_7 nicht förderbar."} if {
	participating
	input.farm.year == 2024
	some p in input.land.parcels
	p.gloez8_variant in {"1_NPF", "2_NPF", "3_NPF", "4_NPF", "5_NPF", "6_NPF"}
}

violations contains {"rule_id": "O6_7_FEED_USE_REGROWTH", "parcel_id": p.parcel_id, "message": "Bodennah genutzte Zwischenfrüchte müssen danach weiterwachsen, sonst beginnt ab der Nutzung ein begrünungsfreier Zeitraum."} if {
	participating
	some p in input.land.parcels
	p.operations.cover_crop.feed_use == true
	p.operations.cover_crop.regrowth_after_use == false
}

eligible if {
	participating
	input.land.arable_area_ha >= thresholds.minimum_arable_area_ha
	count(violations) == 0
}

compliance := {
	"measure": "o6_7",
	"eligible": eligible,
	"violations": violations,
	"premium_band_eur_per_ha": thresholds.premium_band_eur_per_ha,
	"green_cover_exception_applies": green_cover_exception_applies,
	"harvest_exception_applies": harvest_exception_applies,
	"late_planting_exception_applies": late_planting_exception_applies,
}
