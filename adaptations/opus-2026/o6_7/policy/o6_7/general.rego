# Allgemeine ÖPUL-Bedingungen mit Wirkung auf System Immergrün
# (Allgemeine Teilnahmebedingungen 2026-04; SRL 1.6, 1.7, 1.12) sowie
# Dürre-Erleichterungen 2026 zur Ernteverpflichtung.
package o6_7.general

import data.o6_7.lib

region := object.get(input, ["farm", "region"], {})

parcel_district(p) := p.district if p.district

parcel_district(p) := region.district if not p.district

parcel_state(p) := p.federal_state if p.federal_state

parcel_state(p) := region.federal_state if not p.federal_state

# Gebietskulisse Dürre 2026 (Ernteverpflichtung, automatische höhere Gewalt).
drought_region(state, _) if {
	some r in lib.notices.drought_harvest_exemption_regions
	r.federal_state == state
	r.all_districts == true
}

drought_region(state, district) if {
	some r in lib.notices.drought_harvest_exemption_regions
	r.federal_state == state
	district in r.districts
}

harvest_exempt_drought_2026(p) if {
	lib.year == lib.params.drought_2026.year
	p.no_harvestable_crop_due_to_drought == true
	drought_region(parcel_state(p), parcel_district(p))
}

harvest_exempt(p) if harvest_exempt_drought_2026(p)

harvest_exempt(p) if p.force_majeure_recognised == true

# Mindestbewirtschaftung Ackerflächen (ohne Ackerfutter): Ernte und Verbringen
# des Erntegutes auf zumindest 85 % des Schlages; sonst Code OP erforderlich.
harvest_obligation_breach contains p.parcel_id if {
	some p in lib.arable_parcels
	p.usage_category == "main_crop"
	p.harvested_share < lib.params.general.min_harvest_share_arable
	not harvest_exempt(p)
}

# Unterjährige Weitergabe ohne Weiterführung durch den Übernehmer bis
# Jahresende: betroffene Flächen mit OP-Code, keine Prämie.
transfer_not_continued contains p.parcel_id if {
	some p in lib.arable_parcels
	p.transfer.transferred_during_year == true
	not p.transfer.successor_continues_until_year_end == true
}

violations contains {
	"rule_id": "O67-GEN-HARVEST-OBLIGATION",
	"code": "harvest_below_85_percent_op_code_required",
	"parcel_id": pid,
} if {
	some pid in harvest_obligation_breach
	some p in lib.arable_parcels
	p.parcel_id == pid
	not "OP" in object.get(p, "oepul_codes", [])
}

violations contains {
	"rule_id": "O67-GEN-COMMITMENT-PERIOD",
	"code": "transferred_parcel_not_continued_op_code_required",
	"parcel_id": pid,
} if {
	some pid in transfer_not_continued
	some p in lib.arable_parcels
	p.parcel_id == pid
	not "OP" in object.get(p, "oepul_codes", [])
}

violations contains {
	"rule_id": "O67-GEN-LOCATION-AUSTRIA",
	"code": "parcel_outside_austria",
	"parcel_id": p.parcel_id,
} if {
	some p in lib.arable_parcels
	p.is_in_austria == false
}

# Sanktionsstufen: ab 2027 statt Verwarnung Einbehalt von 1 %.
warning_replaced_by_retention if lib.year >= lib.params.general.warning_replaced_by_retention_from_year

sanction_steps := [s | some s in lib.general.sanction_steps]

sanction_step_reduction(code) := 0.01 if {
	code == "warning"
	warning_replaced_by_retention
} else := s.reduction_share if {
	some s in lib.general.sanction_steps
	s.code == code
}

# Verweigerung der Kontrolle (außer höhere Gewalt): Antrag abzulehnen, keine
# Prämie für das laufende Jahr, bestehende Verträge beendet.
control_refused if {
	input.farm.oepul.control_refused == true
	not input.farm.oepul.control_refusal_force_majeure == true
}

violations contains {
	"rule_id": "O67-GEN-CONTROL-ACCESS",
	"code": "control_refused_application_rejected",
} if {
	control_refused
}
