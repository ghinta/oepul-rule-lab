# Betriebsbezogene Teilnahme-, Antrags- und Ausstiegsbedingungen der Maßnahme o6_6.
package oepul.o6_6

fv(rid, msg) := {"rule_id": rid, "message": msg}

arable_area_ha := object.get(input, ["land", "arable_area_ha"], 0)

# Mindestteilnahme: jedes Teilnahmejahr mindestens 1,50 ha Ackerfläche.
min_arable_area_met if arable_area_ha >= gc.measure.min_arable_area_ha

# Mindestens ein beantragter begrünter Schlag.
greened_parcel_applied if {
	some p in cover_parcels
	not cc(p).variant_withdrawn == true
}

contract_lapse_reasons contains fv("O6_6-MIN-ARABLE", "Weniger als 1,50 ha Ackerfläche gemäß Mehrfachantrag") if {
	not min_arable_area_met
}

contract_lapse_reasons contains fv("O6_6-CONTRACT-LAPSE", "Kein begrünter Schlag beantragt") if {
	not greened_parcel_applied
}

# Bei Erlöschen ist ein neuer fristgerechter Maßnahmenantrag für eine Wiederteilnahme erforderlich.
contract_lapses if count(contract_lapse_reasons) > 0

# Betriebsmindestgröße im ersten ÖPUL-Teilnahmejahr.
first_oepul_year if input.farm.oepul.first_participation_year == year

farm_min_size_first_year_met if {
	some r in gc.farm_minimum_size_first_year.rows
	r.basis == "protected_cultivation_area_ha"
	object.get(input, ["land", "protected_cultivation_area_ha"], 0) >= r.min_ha
}

farm_min_size_first_year_met if {
	some r in gc.farm_minimum_size_first_year.rows
	r.basis == "agricultural_area_ha"
	object.get(input, ["land", "total_area_ha"], 0) >= r.min_ha
}

farm_violations contains fv("O6_6-GEN-FARM-MIN-SIZE", "Betriebsmindestgröße im ersten ÖPUL-Teilnahmejahr nicht erreicht") if {
	first_oepul_year
	not farm_min_size_first_year_met
}

# Förderwerbende Person: Gebietskörperschaften sind bei o6_6 zugelassen.
public_body_allowed if {
	some r in gc.public_body_exempt_measures.rows
	r.measure_code == gc.measure.measure_code
	r.from_year <= year
	year <= r.to_year
}

applicant_eligible if {
	input.farm.applicant.legal_form in {"natural_person", "registered_partnership"}
}

applicant_eligible if {
	some r in gc.applicant_types.rows
	r.legal_form == input.farm.applicant.legal_form
	is_number(r.max_public_body_share_percent)
	object.get(input.farm.applicant, "public_body_share_percent", 0) <= r.max_public_body_share_percent
}

applicant_eligible if {
	input.farm.applicant.legal_form in {"public_body", "legal_person", "association"}
	public_body_allowed
}

farm_violations contains fv("O6_6-GEN-APPLICANT", "Keine zulässige förderwerbende Person") if {
	input.farm.applicant.legal_form
	not applicant_eligible
}

farm_violations contains fv("O6_6-GEN-APPLICANT", "Kein aktiver Landwirt bzw. keine landwirtschaftliche Tätigkeit") if {
	input.farm.applicant.is_active_farmer == false
}

# Keine gleichzeitige Teilnahme an o6_6 und o6_7 (System Immergrün).
farm_violations contains fv("O6_6-NO-O6_7", "Gleichzeitige Teilnahme an Zwischenfruchtanbau und System Immergrün nicht möglich") if {
	"6" in measure_codes
	some r in data.o6_6.combination_table.farm_level_exclusions.rows
	r.measure == "6"
	r.excluded_with in measure_codes
	not o6_7_replaces_o6_6_this_year
}

# Umstieg auf System Immergrün: ersetzt o6_6 ab 1. Jänner des Folgejahres.
o6_7_replaces_o6_6_this_year if {
	some m in input.farm.oepul.measures
	m.measure_code == "7"
	m.contract_start_year == year
	ns(o6_6_measure.withdrawal_date) < ns_md(year, "01-01")
}

switch_to_o6_7_allowed(target_year) if {
	target_year <= gc.measure.last_switch_to_o6_7_funding_year
}

# Maßnahmenantrag bis 31.12. vor Vertragsbeginn; letzter Einstieg Förderjahr 2027.
farm_violations contains fv("O6_6-MEASURE-APPLICATION", "Maßnahmenantrag nicht bis 31.12. vor Vertragsbeginn gestellt") if {
	m := o6_6_measure
	ns(m.applied_on) > ns_md(m.contract_start_year - 1, gc.measure.measure_application_deadline_mmdd)
}

farm_violations contains fv("O6_6-LAST-ENTRY", "Einstieg nach dem Förderjahr 2027 nicht mehr möglich") if {
	o6_6_measure.contract_start_year > gc.measure.last_entry_funding_year
}

# Ausstieg/Abmeldung.
withdrawn_in_current_year if {
	w := ns(o6_6_measure.withdrawal_date)
	w >= ns_md(year, "01-01")
	w <= ns_md(year, "12-31")
	withdrawal_effective
}

withdrawal_effective if {
	not input.farm.oepul.inspection_announced_on
}

withdrawal_effective if {
	ns(o6_6_measure.withdrawal_date) <= ns(input.farm.oepul.inspection_announced_on)
}

farm_violations contains fv("O6_6-EXIT", "Abmeldung im laufenden Förderjahr: Maßnahme im betroffenen Förderjahr nicht mehr gültig") if {
	withdrawn_in_current_year
}

farm_violations contains fv("O6_6-GEN-EXIT-UNTIL-INSPECTION", "Ausstieg nach Ankündigung/Durchführung einer Vor-Ort-Kontrolle nicht mehr wirksam") if {
	o6_6_measure.withdrawal_date
	not withdrawal_effective
}

farm_violations contains fv("O6_6-EXIT-TIMING", sprintf("Ausstieg im Folgejahr vor Ende des Begrünungszeitraums von Schlag %s (Variante %d)", [p.parcel_id, cc(p).variant])) if {
	w := ns(o6_6_measure.withdrawal_date)
	w > ns_md(year, "12-31")
	some p in cover_parcels
	row_of(p).exit_next_year_only_after_period_end
	w < period_end_ns(p)
}

# Flächenweitergabe: Nachfolgebetrieb muss Bedingungen der Variante einhalten.
transfer_blocks_premium(p) if {
	t := p.transfer
	not t.successor_complies == true
	not lease_to_immergruen_continued(p)
}

lease_to_immergruen_continued(p) if {
	t := p.transfer
	t.successor_measure_code == "7"
	row_of(p).lease_to_immergruen_counts_as_continued
	ns(t.transferred_on) > ns_md(year, "12-31")
}

# Anschließende Teilnahme an Erosionsschutz Acker (Mulchsaat, Direktsaat, Strip-Till).
erosion_protection_followup_eligible contains p.parcel_id if {
	some p in cover_parcels
	row_of(p).erosion_protection_followup_allowed
	cc(p).following_main_crop.sowing_method in {"mulch", "direct", "strip_till"}
}

# Dauerhafte flächen- oder bewirtschaftungsverändernde Umstände nach Anlage der Begrünung.
permanent_circumstance_premium_possible contains p.parcel_id if {
	some p in cover_parcels
	sc := p.special_circumstance
	sc.type == "permanent"
	sc.reported == true
	ns(sc.occurred_on) >= establishment_ns(p)
}

# Ernteverpflichtung nicht erfüllt: maßnahmenbezogene OP-Codes statt OP/OPZWF verwenden.
advice contains {"parcel_id": p.parcel_id, "rule_id": "O6_6-GEN-OP-UNHARVESTED", "message": "Ernteverpflichtung nicht erfüllt: flächenbezogene OP-Codes (z. B. OPBIO) vergeben, nicht OP oder OPZWF, damit die o6_6-Prämie ausbezahlt werden kann"} if {
	some p in cover_parcels
	object.get(p, ["operations", "main_crop_harvest_share_percent"], 100) < gc.minimum_management_arable.min_harvest_share_percent
	not harvest_obligation_waived_2026
}
