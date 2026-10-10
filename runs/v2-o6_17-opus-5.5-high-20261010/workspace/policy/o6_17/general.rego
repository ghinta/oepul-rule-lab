package oepul.o6_17.general

# Allgemeine Teilnahmebedingungen mit Bezug zur Maßnahme 17 sowie 2026-Hinweise
# (Allgemeine Teilnahmebedingungen 5.4 bis 7.2; SRL 1.4.2, 1.6.3, 1.7;
# GSP-AV § 6; AMA-Hinweise 2026).

import data.oepul.o6_17.common
import data.oepul.o6_17.livestock

fw := data.o6_17_tables.general_framework

drought := data.o6_17_tables.drought_2026

day_ns := ((24 * 60) * 60) * 1000000000

days_between(a, b) := (time.parse_ns("2006-01-02", b) - time.parse_ns("2006-01-02", a)) / day_ns

# ---------------------------------------------------------------------------
# Höhere Gewalt (GSP-AV § 6): Meldung binnen drei Wochen ab Möglichkeit.

force_majeure_claims := object.get(input, ["farm", "oepul", "force_majeure_claims"], [])

claim_in_time(c) if days_between(c.able_to_notify_date, c.notification_date) <= fw.force_majeure.notification_period_days

case_row(id) := r if {
	some r in fw.force_majeure.additional_cases
	r.id == id
}

claim_area_ok(c) if case_row(c.case_id).min_area_ha == null

claim_area_ok(c) if {
	is_number(case_row(c.case_id).min_area_ha)
	object.get(c, "area_ha", 0) >= case_row(c.case_id).min_area_ha
}

claim_area_ok(c) if not case_row(c.case_id)

force_majeure_recognisable contains c.claim_id if {
	some c in force_majeure_claims
	claim_in_time(c)
	claim_area_ok(c)
}

late_force_majeure_claims contains c.claim_id if {
	some c in force_majeure_claims
	not claim_in_time(c)
}

# ---------------------------------------------------------------------------
# Maßnahmenübernahme (Allgemeine Teilnahmebedingungen 6.3, SRL 1.7.3.1)

takeover := object.get(common.o6, "takeover", null)

takeover_deadline := sprintf("%d-%s", [common.year, fw.takeover.deadline_month_day_2023_2028]) if {
	common.year in {2023, 2028}
} else := sprintf("%d-%s", [common.year, fw.takeover.deadline_month_day])

takeover_problems contains "deadline_missed" if {
	is_object(takeover)
	takeover.application_date > takeover_deadline
}

takeover_problems contains "taker_already_participating" if {
	is_object(takeover)
	object.get(takeover, "taker_previously_participating", false) == true
}

takeover_problems contains "expansion_over_50_percent" if {
	is_object(takeover)
	takeover.expansion_to_other_area_ha > takeover.taken_over_area_ha * fw.takeover.max_expansion_share
}

takeover_valid if {
	is_object(takeover)
	count(takeover_problems) == 0
}

# ---------------------------------------------------------------------------
# Maßnahmenwechsel: Maßnahme 17 ist nicht als Ausgangsmaßnahme vorgesehen.

conversion_from_o6_17_possible if {
	some c in fw.measure_conversions
	c.from == "17"
}

# ---------------------------------------------------------------------------
# Einstieg und letzte Beantragung

agl_application_possible if {
	common.contract_active
	common.year <= fw.last_agl_year
}

# ---------------------------------------------------------------------------
# Unterjährige Flächenweitergabe ohne Weiterführung: Code OP erforderlich.

violations contains v if {
	common.contract_active
	some p in common.parcels
	object.get(p, ["o6_17", "transferred_during_year"], false) == true
	object.get(p, ["o6_17", "recipient_continues_commitment"], false) == false
	not "OP" in common.codes(p)
	v := {"rule_id": "o6_17.general.intra_year_transfer_op_code", "parcel_id": p.parcel_id, "detail": "Weitergegebene Fläche ohne Weiterführung durch Übernehmer ist mit Code OP zu versehen"}
}

# Fläche außerhalb Österreichs ist nicht förderfähig.
violations contains v if {
	some p in common.parcels
	object.get(p, "located_in_austria", true) == false
	v := {"rule_id": "o6_17.general.parcels_in_austria", "parcel_id": p.parcel_id, "detail": "Flächen außerhalb Österreichs werden nicht gefördert"}
}

# ---------------------------------------------------------------------------
# Mindestbewirtschaftung auf Grünland (ausgenommen Biodiversitätsflächen).

is_biodiversity_area(p) if {
	some c in common.codes(p)
	startswith(c, "DIV")
}

mown_or_grazed(p) if count(object.get(p, ["operations", "cutting_dates"], [])) > 0

mown_or_grazed(p) if object.get(p, ["operations", "full_grazing"], false) == true

violations contains v if {
	common.contract_active
	some p in common.grassland_parcels
	common.use_type(p) != "bergmaehder"
	common.use_type_info(p).base_premium_possible == true
	not is_biodiversity_area(p)
	not mown_or_grazed(p)
	object.get(p, ["operations", "season_completed"], false) == true
	v := {"rule_id": "o6_17.general.minimum_management_grassland", "parcel_id": p.parcel_id, "detail": "Keine jährliche vollflächige Mahd mit Verbringung bzw. vollflächige Beweidung"}
}

violations contains v if {
	common.contract_active
	some p in common.grassland_parcels
	common.use_type(p) == "bergmaehder"
	object.get(p, ["operations", "last_full_mowing_year"], 0) < common.year - 1
	v := {"rule_id": "o6_17.general.minimum_management_bergmaehder", "parcel_id": p.parcel_id, "detail": "Bergmähder: mindestens alle 2 Jahre einmal vollflächige Mahd und Verbringen des Mähgutes"}
}

# ---------------------------------------------------------------------------
# Kombinationsmaßnahmen: zusätzliche Weiterbildungsverpflichtungen (Hinweis
# im Informationsblatt 6.4).

related_training_obligations contains {"measure": "1A/1B", "topic": "biodiversity", "min_hours": 3} if common.in_measure({"1A", "1B", "1B_TB"})

related_training_obligations contains {"measure": "1B", "topic": "organic", "min_hours": 5} if common.in_measure({"1B", "1B_TB"})

# ---------------------------------------------------------------------------
# Dürre 2026: Ernteverpflichtung auf Ackerflächen in den betroffenen Bezirken.

farm_state := object.get(input, ["farm", "region", "federal_state"], "")

parcel_district(p) := object.get(p, "district", object.get(input, ["farm", "region", "district"], ""))

parcel_state(p) := object.get(p, "federal_state", farm_state)

in_drought_relief_area(p) if {
	some r in drought.harvest_relief_districts
	r.federal_state == parcel_state(p)
	r.district in {"*", parcel_district(p)}
}

harvest_share(p) := object.get(p, ["operations", "harvest", "harvested_share_percent"], 100)

no_harvestable_crop_due_to_drought(p) if object.get(p, ["operations", "harvest", "no_harvestable_crop_due_to_drought"], false) == true

harvest_relief_2026(p) if {
	common.year == drought.application_year
	p.land_use == "arable"
	in_drought_relief_area(p)
	no_harvestable_crop_due_to_drought(p)
}

parcels_with_harvest_relief_2026 contains p.parcel_id if {
	some p in common.parcels
	harvest_relief_2026(p)
}

violations contains v if {
	some p in common.parcels
	p.land_use == "arable"
	not livestock.is_arable_fodder(p)
	harvest_share(p) < drought.min_harvest_share_percent
	not harvest_relief_2026(p)
	not object.get(p, ["operations", "harvest", "force_majeure_claim_id"], null) in force_majeure_recognisable
	v := {"rule_id": "o6_17.general.harvest_obligation_arable", "parcel_id": p.parcel_id, "detail": "Ernte und Verbringen des Erntegutes auf mindestens 85 % des Schlages nicht erfolgt"}
}

summary := {
	"force_majeure_recognisable": force_majeure_recognisable,
	"late_force_majeure_claims": late_force_majeure_claims,
	"takeover_valid": takeover_valid,
	"takeover_problems": takeover_problems,
	"conversion_from_o6_17_possible": conversion_from_o6_17_possible,
	"agl_application_possible": agl_application_possible,
	"related_training_obligations": related_training_obligations,
	"parcels_with_harvest_relief_2026": parcels_with_harvest_relief_2026,
}

default takeover_valid := false

default conversion_from_o6_17_possible := false

default agl_application_possible := false
