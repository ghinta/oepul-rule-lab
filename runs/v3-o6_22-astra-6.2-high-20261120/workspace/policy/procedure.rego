package oepul.o6_22

import rego.v1

# Offene Handlungen bei ausdrücklich erfassten Sachverhalten.
required_actions contains {"rule_id": "22-tgd-nachweis", "action": "TGD-Nachweis an die AMA übermitteln"} if {
	tgd_required
	application.tgd.ama_requested
	application.tgd.sent_by_service == false
	application.tgd.sent_by_farm == false
}

required_actions contains {"rule_id": "22-abmeldung", "group_index": i, "action": "Unverzüglich Jahresdurchschnitt in der MFA-Beilage melden"} if {
	some i, g in input.livestock.species_groups
	g.species == "pigs"
	selected(g)
	g.held_in_austria
	g.full_category_period_conforming == false
	g.withdrawn_count < stock_count(g)
}

required_actions contains {"rule_id": "22-wild", "group_index": i, "action": "Freilandwildschweine abmelden"} if {
	some i, g in input.livestock.species_groups
	g.species == "pigs"
	g.category == "outdoor_wild_boar"
	g.claimed_in_measure
}

required_actions contains {"rule_id": "22-erloeschen", "category": cat, "action": "Kategorievertrag erloschen"} if {
	some cat in application.categories
	category_lapses(cat)
}

required_actions contains {"rule_id": "22-vis", "event_index": i, "action": "Lebendtierbewegung an das VIS melden"} if {
	some i, event in application.movements
	event.kind in {"arrival", "departure"}
	event.reported_to_vis == false
}

required_actions contains {"rule_id": "22-separierung-lang", "pen_index": i, "action": "Tier von der Kategorie abmelden"} if {
	some i, p in application.pens
	separation_deregistration(p.separation)
}

required_actions contains {"rule_id": "22-plan", "pen_index": i, "action": "Stallskizze bzw. Belegungsplan am Betrieb bereithalten"} if {
	plan_required
	some i, p in application.pens
	false in [object.get(p, "sketch_on_farm", null), object.get(p, "occupancy_plan_on_farm", null)]
}

pasture_log_ok(o) if {
	is_string(o.parcel_id)
	o.parcel_id != ""
	day(o.last_grazing_day) >= day(o.first_grazing_day)
	nonnegative(o.number_on_parcel)
	o.number_on_parcel == floor(o.number_on_parcel)
	o.recorded_continuously
}

valid_correction(c) if {
	correction_timely(c.payment_notice_received, c.correction_filed)
	c.online_tierliste
	c.movement_evidence_uploaded
	correction_sketch(c)
}

correction_sketch(_) if year >= 2025
correction_sketch(c) if c.sketch_attached

registration_checks[i] := valid if {
	some i, r in application.registrations
	is_number(day(r.filed))
	r.kind in {"category", "option"}
	valid := count([true | entry_timely(r.kind, r.filed, year)]) == 1
}

outdoor_findings[i] contains "records" if {
	some i, o in application.outdoors
	pasture_log_ok(o)
}

outdoor_findings[i] contains "group" if {
	some i, o in application.outdoors
	o.group_housed == true
}

contract_continues if {
	application.contract_events.prior_contract
	application.contract_events.annual_mfa_filed
	application.contract_events.deregistration_date == null
	minimum_met
}

withdrawn_in_year(e, y) if {
	is_number(day(e.deregistration_date))
	startswith(e.deregistration_date, sprintf("%d-", [y]))
}

required_actions contains {"rule_id": "22-nachtrag", "action": "Vorigen Maßnahmenantrag korrigieren und schriftliches Anerkennungsersuchen einreichen"} if {
	e := application.contract_events
	e.previous_category_expired
	e.immediate_reentry_requested
	e.entry_deadline_passed
	false in [object.get(e, "reapplication_filed", null), object.get(e, "separate_written_request", null)]
}

required_actions contains {"rule_id": "22-separierung-beleg", "pen_index": i, "action": "Krankheit oder Verletzung und Separierungsdauer dokumentieren"} if {
	some i, p in application.pens
	p.separation.reason in {"sick", "injured"}
	p.separation.reason_and_duration_recorded == false
}

outdoor_land_use(parcel) := expected if {
	parcel.freiland_use.unpaved_pig_range
	expected := {"arable": "Sonstige Ackerflächen", "grassland": "Sonstige Grünlandflächen"}[parcel.land_use]
}

required_actions contains {"rule_id": "22-freilandflaeche", "parcel_id": p.parcel_id, "action": "Schlagnutzungsart für unbefestigte Schweineweide berichtigen"} if {
	some p in input.land.parcels
	p.freiland_use.claimed_use != outdoor_land_use(p)
}

required_actions contains {"rule_id": "22-freilandflaeche", "parcel_id": p.parcel_id, "action": "Acker wieder in die Fruchtfolge aufnehmen"} if {
	some p in input.land.parcels
	p.land_use == "arable"
	p.freiland_use.prior_year_unpaved_pig_range
	p.freiland_use.back_in_rotation == false
}

required_actions contains {"rule_id": "22-freilandflaeche", "parcel_id": p.parcel_id, "action": "Grünland im Folgejahr ohne Freilandschweine bewirtschaften"} if {
	some p in input.land.parcels
	p.land_use == "grassland"
	p.freiland_use.prior_year_unpaved_pig_range
	p.freiland_use.grassland_without_pigs == false
}

transfer_approved if {
	t := application.transfer
	transfer_reviewable(t)
	t.ama_approved
}

animal_class_for_boar(weight_kg, used_for_service) := "breeding_boar" if {
	is_number(weight_kg)
	weight_kg >= 50
	used_for_service == true
} else := code if {
	is_number(weight_kg)
	weight_kg >= 32
	used_for_service == false
	code := fattening_weight_class(weight_kg)
}

fattening_weight_class(w) := "young_32" if w < 50

else := "fattening_50" if w < 80

else := "fattening_80" if w < 110

else := "fattening_110"

# Rechnerische Beträge und Nachweispflichten sind getrennt abfragbar. Fehlende
# Bestandsdaten bleiben bei den skalaren Ergebnissen ausdrücklich erkennbar.
default stock_assessment := {"status": "incomplete"}

stock_assessment := {"status": "calculated", "participating_gve": participating_gve, "minimum_met": minimum_met} if is_number(participating_gve)

default health_assessment := {"status": "incomplete"}

health_assessment := {"status": "calculated", "farm_eligible_pig_gve": farm_pig_gve, "tgd_required": tgd_required} if is_number(farm_pig_gve)

assessment := {
	"contract_checks": contract_checks,
	"stock": stock_assessment,
	"health_service": health_assessment,
	"confirmed_pen_checks": pen_findings,
	"confirmed_outdoor_checks": outdoor_findings,
	"tariff_components_eur": premium_components,
	"modulated_tariff_components_eur": modulated_components,
	"actions": required_actions,
}

default size_status := "incomplete"

size_status := "met" if farm_size_ok

else := "not_met" if {
	application.first_opul_year
	nonnegative(application.protected_cultivation_at_ha)
	nonnegative(application.qualifying_at_ha)
	application.protected_cultivation_at_ha < 0.50
	application.qualifying_at_ha < 1.50
}

default health_period_status := "incomplete"

health_period_status := "not_required" if tgd_required == false

else := "met" if tgd_period_ok

else := "not_met" if {
	tgd_required
	application.tgd.recognised_for_pigs == false
} else := "not_met" if {
	tgd_required
	day(application.tgd.start) > day(tgd_start(year))
} else := "not_met" if {
	tgd_required
	day(application.tgd.end) < day(sprintf("%d-12-31", [year]))
}

default person_status := "incomplete"

person_status := "met" if applicant_ok

else := "not_met" if {
	a := application.applicant
	true in [object.get(a, "public_body_or_institution", null), object.get(a, "controlled_subsidiary", null), object.get(a, "equivalent_public_control", null)]
} else := "not_met" if {
	a := application.applicant
	a.legal_form in {"association", "legal_person"}
	is_number(a.public_share_pct)
	a.public_share_pct > 25
} else := "not_met" if application.applicant.legal_form == "other"

else := "not_met" if {
	a := application.applicant
	some key in {"own_name", "own_account", "active_farmer", "agriculturally_active", "control_of_claimed_land"}
	a[key] == false
}

contract_checks := {"applicant": person_status, "holding_size": size_status, "animal_health_period": health_period_status}
