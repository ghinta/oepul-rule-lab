# Findings (violations / notices) and the aggregated decision document.
package oepul.o6_9

violations contains {"rule_id": "o6_9.contract.application_deadline", "message": "Kein fristgerechter Maßnahmenantrag (bis 31.12. vor Vertragsbeginn, letzter Einstieg 2027) für o6_9 vorhanden."} if {
	not measure_contract_valid
}

violations contains {"rule_id": "o6_9.contract.lapse_no_quantity", "message": "Keine Menge bodennah ausgebracht bzw. separiert und keine Teilnahme an stark N-reduzierter Fütterung: Vertrag erlischt."} if {
	contract_lapses_this_year
}

violations contains {"rule_id": "o6_9.declaration.deadline_30_november", "message": "Mengen nicht bis 30.11. des Förderjahres prämienfähig im Mehrfachantrag beantragt."} if {
	declared_slurry_total_m3 + declared_separation_m3 > 0
	not volumes_declared_in_time
}

violations contains {"rule_id": "o6_9.feeding.application_deadline", "message": "Stark N-reduzierte Fütterung ohne fristgerechten Maßnahmenantrag (bis 31.12. vor Vertragsbeginn, ab 2025, letzter Einstieg 2028) oder ohne gültige Maßnahmenteilnahme."} if {
	some a in n_feeding_applications
	application_active(a, year)
	not participates_n_feeding
}

violations contains {"rule_id": "o6_9.feeding.access_min_1_gve_per_ha", "message": sprintf("Zugangsvoraussetzung verfehlt: %.3f GVE Schweine je ha Ackerfläche (mindestens 1,00).", [pig_gve_per_arable_ha])} if {
	participates_n_feeding
	not n_feeding_density_met
}

violations contains {"rule_id": "o6_9.feeding.protein_limits", "message": "Rohproteingrenzen der stark N-reduzierten Fütterung nicht bei allen Schweinen eingehalten bzw. nicht nachgewiesen."} if {
	participates_n_feeding
	not protein_limits_met
}

violations contains {"rule_id": "o6_9.feeding.recipe_evidence", "message": "Kein Nachweis über Rezepturen mit ausgewiesenem Rohproteingehalt je kg (88 % TM)."} if {
	participates_n_feeding
	object.get(pig_feeding, "recipe_evidence_available", false) != true
}

violations contains {"rule_id": "o6_9.feeding.phase_feeding_plausibility", "message": "Phasenfütterung angegeben, technische Durchführbarkeit nicht plausibel gemacht."} if {
	participates_n_feeding
	count(phase_rations) > 0
	object.get(pig_feeding, "phase_feeding_plausible", false) != true
}

violations contains {"rule_id": "o6_9.feeding.protein_value_source", "message": sprintf("Unzulässige Grundlage für Rohproteingehalt: %v.", [r.protein_value_source])} if {
	participates_n_feeding
	some r in rations
	not valid_protein_source(r.protein_value_source)
}

violations contains {"rule_id": "o6_9.combination.o6_16_n_feeding", "message": "Gleichzeitige Teilnahme an stark N-reduzierter Fütterung in o6_9 und am gleichlautenden Zuschlag in o6_16 nicht möglich."} if {
	n_feeding_combination_conflict
}

violations contains {"rule_id": "o6_9.slurry.records_support_declaration", "message": sprintf("Beantragte Menge %s (%v m³) übersteigt aufgezeichnete förderfähige Menge (%v m³).", [c, declared_m3(c), recorded_eligible_m3(c)])} if {
	some c in params.slurry_application_categories
	declared_m3(c) > recorded_eligible_m3(c)
}

violations contains {"rule_id": "o6_9.slurry.record_keeping", "message": "Schlagbezogene, chronologische Aufzeichnungen zur bodennahen Ausbringung unvollständig."} if {
	declared_slurry_total_m3 > 0
	not slurry_records_ok
}

slurry_records_ok if {
	object.get(documentation, "application_logs_complete", false) == true
	every r in application_records {
		record_complete(r)
		grouped_record_area_ok(r)
	}
	records_chronological
}

violations contains {"rule_id": "o6_9.slurry.external_equipment_evidence", "message": "Ausbringung mit betriebsfremden Geräten ohne Rechnung/gleichwertigen Nachweis."} if {
	some r in application_records
	r.equipment_source == "external_service"
	object.get(evidence, "external_service_invoices_available", false) != true
}

violations contains {"rule_id": "o6_9.slurry.shared_equipment", "message": "Gemeinschaftlich angeschafftes Güllefass: Gerät nicht kontrollierbar oder Rechnung nicht an teilnehmende Betriebe ausgestellt."} if {
	some r in application_records
	r.equipment_source == "shared_purchase"
	not shared_equipment_ok
}

shared_equipment_ok if {
	evidence.shared_equipment_inspectable == true
	evidence.shared_equipment_invoice_to_participants == true
}

violations contains {"rule_id": "o6_9.slurry.biogas_input_evidence", "message": "Ausbringung von Biogasgülle ohne geeignete Nachweise über die Ausgangsprodukte."} if {
	some r in application_records
	r.manure_kind == "biogasguelle"
	object.get(evidence, "biogas_input_evidence_available", false) != true
}

violations contains {"rule_id": "o6_9.separation.records_support_declaration", "message": sprintf("Beantragte separierte Menge (%v m³) übersteigt aufgezeichnete Menge betriebseigener Rindergülle (%v m³).", [declared_separation_m3, recorded_separation_m3])} if {
	declared_separation_m3 > recorded_separation_m3
}

violations contains {"rule_id": "o6_9.separation.record_keeping", "message": "Aufzeichnungen über Datum und Menge der Gülleseparierung unvollständig."} if {
	declared_separation_m3 > 0
	not separation_records_ok
}

separation_records_ok if {
	object.get(documentation, "separation_records_complete", false) == true
	every r in separation_records {
		separation_record_complete(r)
	}
}

violations contains {"rule_id": "o6_9.separation.external_equipment_evidence", "message": "Separierung mit betriebsfremden Geräten ohne Rechnung/gleichwertigen Nachweis."} if {
	some r in separation_records
	r.equipment_source == "external_service"
	object.get(evidence, "external_separator_invoices_available", false) != true
}

violations contains {"rule_id": "o6_9.separation.shared_equipment", "message": "Gemeinschaftlich angeschaffter Separator: Gerät nicht kontrollierbar oder Rechnung nicht an teilnehmende Betriebe ausgestellt."} if {
	some r in separation_records
	r.equipment_source == "shared_purchase"
	not shared_separator_ok
}

shared_separator_ok if {
	evidence.shared_separator_inspectable == true
	evidence.shared_separator_invoice_to_participants == true
}

violations contains {"rule_id": "o6_9.general.applicant", "message": "Förderwerbende Person nicht förderfähig (Rechtsform, Beteiligung Gebietskörperschaften > 25 % oder kein aktiver Landwirt)."} if {
	not applicant_eligible
}

violations contains {"rule_id": "o6_9.general.min_farm_size_first_year", "message": "Betriebsmindestgröße im ersten ÖPUL-Teilnahmejahr nicht erreicht (1,50 ha bzw. 0,50 ha geschützter Anbau)."} if {
	not first_year_min_size_met
}

violations contains {"rule_id": "o6_9.general.min_management_harvest", "message": sprintf("Ernteverpflichtung (85 %%) auf Ackerschlag %v nicht erfüllt und nicht mit Code OP gekennzeichnet.", [p.parcel_id])} if {
	participates_n_feeding
	some p in parcels
	p.land_use == "arable"
	not harvest_obligation_met(p)
	not parcel_has_op_code(p)
}

notices contains {"rule_id": "o6_9.premium.slurry_cap_50_m3_per_ha", "message": sprintf("Beantragte Ausbringungsmenge %v m³ über Obergrenze %v m³ (50 m³/ha düngungswürdige Fläche) – anteilige Kürzung.", [declared_slurry_total_m3, slurry_cap_m3])} if {
	slurry_cap_exceeded
}

notices contains {"rule_id": "o6_9.premium.separation_cap_20_m3_per_gve", "message": sprintf("Separierte Menge %v m³ über Obergrenze %v m³ (20 m³ je Rinder-GVE).", [declared_separation_m3, separation_cap_m3])} if {
	separation_cap_exceeded
}

notices contains {"rule_id": "o6_9.payment.min_amount", "message": "Auszahlungsbetrag nicht über 50 EUR – von der Gewährung kann abgesehen werden."} if {
	premium_basis_ok
	payment_may_be_withheld
}

notices contains {"rule_id": "o6_9.slurry.ineligible_records", "message": sprintf("Aufzeichnung %v nicht förderfähig: %v", [x.index, x.reasons])} if {
	some x in ineligible_application_records
}

notices contains {"rule_id": "o6_9.separation.only_own_cattle_slurry", "message": sprintf("Separierungsaufzeichnung %v nicht förderfähig (betriebsfremde bzw. keine Rindergülle).", [i])} if {
	some i in ineligible_separation_records
}

decision := {
	"measure": "o6_9",
	"year": year,
	"measure_contract_valid": measure_contract_valid,
	"minimum_participation_met": minimum_participation_met,
	"participates_n_feeding": participates_n_feeding,
	"n_feeding_eligible": n_feeding_eligible,
	"fertilisable_area_ha": fertilisable_area_ha,
	"slurry_cap_m3": slurry_cap_m3,
	"separation_cap_m3": separation_cap_m3,
	"premium_components": premium_components,
	"premium_total_eur": premium_total_eur,
	"modulation_factor": modulation_factor(total_area_ha),
	"premium_after_modulation_eur": premium_after_modulation_eur,
	"violations": violations,
	"notices": notices,
}
