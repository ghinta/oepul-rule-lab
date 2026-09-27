# Aggregation der Prüfergebnisse, Sanktionsstufen, höhere Gewalt / 2026-Hinweise
# und Gesamtentscheidung für Tierwohl – Behirtung (o6_15).
package oepul.o6_15

# ---------------------------------------------------------------------------
# Zugangs- und Fördervoraussetzungen (Betriebsebene)
# ---------------------------------------------------------------------------

eligibility_failures contains {"rule_id": "o6_15.gen.applicant", "message": "Förderwerbende Person nicht teilnahmeberechtigt (Rechtsform, Beteiligung Gebietskörperschaften, aktiver Landwirt oder nicht almbewirtschaftende Person)"} if {
	not applicant_eligible
}

eligibility_failures contains {"rule_id": "o6_15.elig.combination_almbewirtschaftung", "message": "Keine zeitgleiche Teilnahme an der Maßnahme Almbewirtschaftung"} if {
	not combination_obligation_met
}

eligibility_failures contains {"rule_id": "o6_15.elig.min_rgve", "message": sprintf("Mindestteilnahme von 3,00 behirteten RGVE nicht erreicht (%.2f RGVE)", [farm_herded_rgve])} if {
	not min_participation_met
}

eligibility_failures contains {"rule_id": "o6_15.app.measure_application", "message": "Kein gültiger Vertrag: Maßnahmenantrag fehlt, verspätet oder Einstieg nach dem Förderjahr 2027"} if {
	not contract_concluded
}

eligibility_failures contains {"rule_id": "o6_15.exit.deregistration_in_year", "message": "Abmeldung im laufenden Förderjahr: Maßnahme im betroffenen Jahr nicht mehr gültig"} if {
	deregistered_in_year
}

eligibility_failures contains {"rule_id": "o6_15.gen.min_farm_size", "message": "Betriebsmindestgröße im ersten ÖPUL-Teilnahmejahr nicht erreicht"} if {
	not min_farm_size_met
}

eligibility_failures contains {"rule_id": "o6_15.ctrl.refusal", "message": "Kontrolle verweigert oder verhindert: Antrag abzulehnen"} if {
	control_refused
}

eligibility_failures contains {"rule_id": "o6_15.app.takeover", "message": "Maßnahmenübernahme nur bei Betriebsauflösung, -teilung oder -zusammenlegung mit Tieren und Flächen vom selben Vorbetrieb zulässig"} if {
	object.get(takeover, "is_takeover", false) == true
	not takeover_allowed
}

# ---------------------------------------------------------------------------
# Förderverpflichtungen und Antragsangaben je Alm bzw. Tier
# ---------------------------------------------------------------------------

obligation_violations contains {"rule_id": rule_id, "alm_id": alm.alm_id, "subject": alm.alm_id} if {
	some alm in alms
	some rule_id in alm_failures(alm)
}

obligation_violations contains {"rule_id": "o6_15.obl.all_animals_per_category", "alm_id": alm.alm_id, "subject": animal_id} if {
	some alm in alms
	some animal_id in unherded_animals_in_claimed_category(alm)
}

obligation_violations contains {"rule_id": "o6_15.cat.herding_categories", "alm_id": alm.alm_id, "subject": c} if {
	some alm in alms
	some c in invalid_claimed_categories(alm)
}

obligation_violations contains {"rule_id": "o6_15.def.dairy", "alm_id": alm.alm_id, "subject": object.get(a, "animal_id", "unknown")} if {
	some alm in alms
	some a in alm_animals(alm)
	a.behirtung_category == "dairy_cows"
	not is_dairy_qualified(a)
}

obligation_violations contains {"rule_id": "o6_15.app.milked_flag_deadline", "alm_id": alm.alm_id, "subject": object.get(a, "animal_id", "unknown")} if {
	some alm in alms
	some a in alm_animals(alm)
	object.get(a, "milked", false) == true
	not milked_flag_timely(a)
}

obligation_violations contains {"rule_id": "o6_15.app.drive_up_by_july_15", "alm_id": alm.alm_id, "subject": object.get(a, "animal_id", "unknown")} if {
	some alm in alms
	some a in alm_animals(alm)
	animal_in_claimed_category(alm, a)
	not driven_up_by_deadline(a)
}

obligation_violations contains {"rule_id": "o6_15.obl.min_herding_per_animal", "alm_id": alm.alm_id, "subject": object.get(a, "animal_id", "unknown")} if {
	some alm in alms
	some a in alm_animals(alm)
	animal_in_claimed_category(alm, a)
	not meets_min_herding_duration(a)
}

obligation_violations contains {"rule_id": "o6_15.app.species_eligible", "alm_id": alm.alm_id, "subject": object.get(a, "animal_id", "unknown")} if {
	some alm in alms
	some a in alm_animals(alm)
	animal_in_claimed_category(alm, a)
	not a.species in params.eligible_species
}

obligation_violations contains {"rule_id": "o6_15.cat.category_species_match", "alm_id": alm.alm_id, "subject": object.get(a, "animal_id", "unknown")} if {
	some alm in alms
	some a in alm_animals(alm)
	animal_in_claimed_category(alm, a)
	not category_matches_species(a)
}

obligation_violations contains {"rule_id": "o6_15.gen.animals_kept_in_austria", "alm_id": alm.alm_id, "subject": object.get(a, "animal_id", "unknown")} if {
	some alm in alms
	some a in alm_animals(alm)
	not animal_kept_in_austria(a)
}

obligation_violations contains {"rule_id": "o6_15.app.drive_up_report_deadline", "alm_id": alm.alm_id, "subject": object.get(a, "animal_id", "unknown")} if {
	some alm in alms
	some a in alm_animals(alm)
	drive_up_reported_late(a)
}

obligation_violations contains {"rule_id": "o6_15.app.drive_down_report_deadline", "alm_id": alm.alm_id, "subject": object.get(a, "animal_id", "unknown")} if {
	some alm in alms
	some a in alm_animals(alm)
	drive_down_reported_late(a)
}

obligation_violations contains {"rule_id": "o6_15.app.drive_down_report_deadline", "alm_id": alm.alm_id, "subject": object.get(a, "animal_id", "unknown")} if {
	some alm in alms
	some a in alm_animals(alm)
	drive_down_report_missing(a)
}

obligation_violations contains {"rule_id": "o6_15.app.sheep_goat_ear_tag", "alm_id": alm.alm_id, "subject": object.get(a, "animal_id", "unknown")} if {
	some alm in alms
	some a in alm_animals(alm)
	reporting_rule(a.species).individual_ear_tag_required
	object.get(a, "ear_tag", null) == null
}

obligation_violations contains {"rule_id": "o6_15.app.one_alm_per_herder", "alm_id": alm.alm_id, "subject": h.person_id} if {
	some alm in alms
	some h in object.get(alm, "herders", [])
	not herder_valid(alm, h)
}

obligation_violations contains {"rule_id": "o6_15.app.herder_count_declared", "alm_id": alm.alm_id, "subject": alm.alm_id} if {
	some alm in alms
	declared := object.get(alm, "declared_herder_count", null)
	declared != null
	declared != count(object.get(alm, "herders", []))
}

obligation_violations contains {"rule_id": "o6_15.opt.dog_requirements", "alm_id": alm.alm_id, "subject": d.dog_id} if {
	dog_supplement_active
	some alm in alms
	some d in object.get(alm, "herd_protection_dogs", [])
	not dog_eligible(alm, d)
}

obligation_violations contains {"rule_id": "o6_15.opt.dog_max_per_alm", "alm_id": alm.alm_id, "subject": alm.alm_id} if {
	dog_supplement_active
	some alm in alms
	count(eligible_dogs(alm)) > rates.limits.max_herd_protection_dogs_per_alm
}

deadline_findings contains {"rule_id": "o6_15.app.payment_application_deadline", "message": "Alm/Gemeinschaftsweide-Auftriebsliste (Zahlungsantrag) nach dem 15. Juli (2023/2028: 17. Juli) eingereicht oder fehlt"} if {
	count(alms) > 0
	not payment_application_timely
}

deadline_findings contains {"rule_id": "o6_15.opt.dog_last_entry", "message": "Zuschlag Herdenschutzhunde: Einstieg nach Förderjahr 2028 bzw. Antrag nach 31.12. des Vorjahres"} if {
	object.get(herding_application, "dog_supplement_requested", false) == true
	not dog_supplement_entry_ok
}

# ---------------------------------------------------------------------------
# Sanktionsstufen bei Verstößen gegen inhaltliche Förderverpflichtungen
# ---------------------------------------------------------------------------

sanction_level(level_id) := l if {
	some l in reductions.sanction_levels
	l.id == level_id
}

# Ab 2027 wird statt der Verwarnung ein Einbehalt von 1 % ausgesprochen
sanction_share(level_id) := sanction_level("retention_1_percent").reduction_share if {
	level_id == "warning"
	year >= 2027
}

sanction_share(level_id) := sanction_level(level_id).reduction_share if {
	level_id != "warning"
}

sanction_share(level_id) := 0 if {
	level_id == "warning"
	year < 2027
}

exclusion_from_measure if object.get(o6_15_record, "full_reductions_in_contract_period", 0) >= 2

# Reihenfolge bei Mehrfachkürzungen (SRL Punkt 1.12.2)
multiple_reduction_order := [step.id | some step in reductions.multiple_reduction_order]

# ---------------------------------------------------------------------------
# Höhere Gewalt, besondere Umstände und 2026-Hinweise
# ---------------------------------------------------------------------------

advisories contains {"rule_id": "o6_15.notice2026.drought_force_majeure", "alm_id": alm.alm_id, "message": "Förderverpflichtungen aufgrund der Trockenheit nicht einhaltbar (z. B. fehlende Wasserversorgung auf Almen): Antrag auf höhere Gewalt über www.eama.at, Register Eingaben"} if {
	year == 2026
	some alm in alms
	object.get(alm, "water_supply_failed_due_to_drought", false) == true
}

# Im Nationalpark Kalkalpen ist die Almbewirtschaftung nicht prämienfähig
advisories contains {"rule_id": "o6_15.gen.np_kalkalpen", "alm_id": alm.alm_id, "message": "Alm im Nationalpark Kalkalpen: Maßnahme Almbewirtschaftung nicht prämienfähig; Auswirkung auf die Kombinationsverpflichtung prüfen"} if {
	some alm in alms
	object.get(alm, "national_park", null) == "Kalkalpen"
}

advisories contains {"rule_id": "o6_15.gen.animal_id_reporting_independent", "alm_id": null, "message": "Meldungen nach Tierkennzeichnungsvorschriften (Rinderdatenbank, VIS) sind unabhängig von der Förderbeantragung durchzuführen"} if {
	count(alms) > 0
}

earliest_drive_up_ns(alm) := min([date_ns(a.drive_up_date) | some a in alm_animals(alm)])

# Dauerhafte flächen-/bewirtschaftungsverändernde Umstände: Prämie im Eintrittsjahr
# grundsätzlich nicht, außer höhere Gewalt oder Eintritt nach dem Almauftrieb
permanent_circumstance_premium_possible(alm) if {
	object.get(alm, "permanent_circumstance_date", null) != null
	date_ns(alm.permanent_circumstance_date) > earliest_drive_up_ns(alm)
}

permanent_circumstance_premium_possible(alm) if {
	object.get(alm, "permanent_circumstance_date", null) != null
	object.get(alm, "permanent_circumstance_force_majeure", false) == true
}

permanent_circumstance_no_premium contains alm.alm_id if {
	some alm in alms
	object.get(alm, "permanent_circumstance_date", null) != null
	not permanent_circumstance_premium_possible(alm)
}

# ---------------------------------------------------------------------------
# Gesamtentscheidung
# ---------------------------------------------------------------------------

default eligible := false

eligible if {
	contract_status == "valid"
	count(eligibility_failures) == 0
}

payable_premium := net_premium if eligible

payable_premium := 0 if not eligible

decision := {
	"measure": "o6_15",
	"year": year,
	"contract_status": contract_status,
	"eligible": eligible,
	"eligibility_failures": eligibility_failures,
	"obligation_violations": obligation_violations,
	"deadline_findings": deadline_findings,
	"advisories": advisories,
	"farm_herded_rgve": round2(farm_herded_rgve),
	"alm_results": alm_results,
	"gross_premium_eur": gross_premium,
	"modulation_basis": round2(modulation_basis),
	"modulation_factor": modulation_factor,
	"net_premium_eur": net_premium,
	"payable_premium_eur": payable_premium,
	"payout_may_be_waived": payout_may_be_waived_bool,
	"max_advance_payment_eur": max_advance_payment,
	"payment_deadline": payment_deadline,
}

payout_may_be_waived_bool if payout_may_be_waived

payout_may_be_waived_bool := false if not payout_may_be_waived
