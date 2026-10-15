# Modul: o6_22 – Melde-, Antrags- und Dokumentationspflichten
package oepul.o6_22

# ---------------------------------------------------------------------------
# Tierliste (O622-APP-004, O622-APP-005, O622-REP-006)
# ---------------------------------------------------------------------------

# O622-APP-005: Tierliste bis spätestens 15. April des Antragsjahres.
violations contains {
	"rule_id": "O622-APP-005",
	"message": sprintf("Tierliste am %v eingereicht – Frist 15. April %v überschritten", [mfa.tierliste_submitted_on, year]),
} if {
	count(active_categories) > 0
	is_string(object.get(mfa, "tierliste_submitted_on", null))
	mfa.tierliste_submitted_on > year_date(year, params.tierliste_deadline_mm_dd)
}

# O622-APP-004: bei schwankenden Tierbeständen Durchschnittsbestand erfassen.
violations contains {
	"rule_id": "O622-APP-004",
	"message": "Schwankender Schweinebestand: Durchschnittstierliste für das Kalenderjahr erforderlich",
} if {
	count(active_categories) > 0
	object.get(mfa, "stock_fluctuates", false) == true
	not uses_average_list
}

average_list_corrections := object.get(mfa, "average_list_corrections", [])

# Korrektur bis zum Ablauf der vierwöchigen Einspruchsfrist nach Erhalt der Auszahlungsmitteilung.
correction_in_time(corr) if {
	notice := object.get(mfa, "payment_notice_received_on", null)
	is_string(notice)
	days_between(notice, corr.corrected_on) <= params.average_list_correction_period_days_after_payment_notice
}

correction_in_time(corr) if {
	not is_string(object.get(mfa, "payment_notice_received_on", null))
	is_string(corr.corrected_on)
}

violations contains {
	"rule_id": "O622-APP-004",
	"message": sprintf("Korrektur des Jahresdurchschnitts vom %v nach Ablauf der vierwöchigen Einspruchsfrist", [corr.corrected_on]),
} if {
	some corr in average_list_corrections
	not correction_in_time(corr)
}

violations contains {
	"rule_id": "O622-REP-006",
	"message": sprintf("Korrektur der Tierliste vom %v ohne hochgeladene Nachweise (Lieferscheine, Rechnungen, Bestandsverzeichnis)", [corr.corrected_on]),
} if {
	some corr in average_list_corrections
	object.get(corr, "proofs_uploaded", false) != true
}

# O622-REP-006 (2026): Nachweise sollten Verkaufsdatum, Anzahl und Verkaufsgewicht enthalten.
warnings contains {
	"rule_id": "O622-REP-006",
	"message": sprintf("Nachweis zur Korrektur vom %v sollte Angabe '%v' enthalten", [corr.corrected_on, field]),
} if {
	some corr in average_list_corrections
	object.get(corr, "reason", "") in lists.tierliste_correction_reasons
	some field in lists.tierliste_correction_proof_fields
	not field in object.get(corr, "proof_fields", [])
}

# O622-REP-006: Bestandsänderung durch Verkauf, Verendung, Schlachtung ohne Anpassung.
violations contains {
	"rule_id": "O622-REP-006",
	"message": "Anzahl beantragter Schweine durch Verkauf, Verendung oder Schlachtung geändert, Jahresdurchschnitt in der Tierliste jedoch nicht angepasst",
} if {
	count(active_categories) > 0
	object.get(mfa, "stock_change_by_sale_death_slaughter", false) == true
	count(average_list_corrections) == 0
	object.get(mfa, "average_reflects_stock_changes", false) != true
}

# ---------------------------------------------------------------------------
# Stallskizze und Belegungsplan (O622-DOC-001, O622-DOC-003)
# ---------------------------------------------------------------------------

stall_sketch_required if {
	year <= params.stall_sketch_required_until_year
	some g in pig_groups
	group_measure_category(g) in active_categories
	stall_housed(g)
}

violations contains {
	"rule_id": "O622-DOC-001",
	"message": "Bis einschließlich Antragsjahr 2024: Stallskizze und Belegungsplan je Kategorie und Stallabteil müssen am Betrieb aufliegen",
} if {
	stall_sketch_required
	object.get(pig_farm, ["documentation", "stall_sketch_and_occupancy_plan"], false) != true
}

# ---------------------------------------------------------------------------
# Meldungen an VIS (O622-REP-004, O622-REP-005)
# ---------------------------------------------------------------------------

violations contains {
	"rule_id": "O622-REP-004",
	"message": "Zu- und Abgänge von Schweinen sind nicht vollständig an das VIS gemeldet",
} if {
	count(pig_groups) > 0
	object.get(pig_farm, "vis_reports_complete", false) != true
}

# ---------------------------------------------------------------------------
# Abmeldung bei Nichteinhaltung (O622-REP-001, O622-REP-003)
# ---------------------------------------------------------------------------

# Nichteinhaltbare Haltung für einzelne Tiere -> umgehende Abmeldung (Beilage
# "Tierwohl – Weide/Stallhaltung"); bei Abmeldung keine Prämie (O622-REP-002).
violations contains {
	"rule_id": "O622-REP-001",
	"message": sprintf("Gruppe %v: Abmeldung nicht umgehend nach Eintritt der Nichteinhaltbarkeit erfolgt", [group_label(i, g)]),
} if {
	some i, g in pig_groups
	dereg := object.get(g, ["pig_welfare", "deregistration"], null)
	is_object(dereg)
	dereg.reported_immediately == false
}
