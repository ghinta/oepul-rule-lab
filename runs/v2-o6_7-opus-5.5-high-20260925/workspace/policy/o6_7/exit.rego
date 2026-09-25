# Vertragszeitraum, Verlängerung, Ausstieg/Abmeldung, Maßnahmenwechsel und
# Folgewirkungen (Kapitel 3.1, 6 und 7 Merkblatt; SRL 1.7.1.1, 1.10.5.2).
package o6_7.exit

import data.o6_7.lib

o67 := object.get(input, ["farm", "oepul", "o6_7"], {})

# Abmeldung im Zeitraum 1.1.–31.12. des Förderjahres: Maßnahme im betroffenen
# Förderjahr nicht mehr gültig.
withdrawn_in_year if lib.year_of(o67.withdrawal_date) == lib.year

# Ausstieg erst nach Erfüllung des einjährigen Vertragszeitraums möglich.
withdrawal_effective_year := lib.year_of(o67.withdrawal_date) if o67.withdrawal_date

violations contains {
	"rule_id": "O67-EXIT-DURING-YEAR",
	"code": "withdrawal_during_year_measure_invalid",
	"withdrawal_date": o67.withdrawal_date,
} if {
	withdrawn_in_year
}

# Bei Abmeldung ist „Erosionsschutz Acker“ mit Mulchsaat, Direktsaat oder
# Strip-Till im Folgejahr nicht mehr möglich.
es_acker_mulch_blocked if {
	lib.year_of(o67.withdrawal_date) == lib.year
	not lib.participates("6")
}

violations contains {
	"rule_id": "O67-EXIT-ES-ACKER",
	"code": "erosion_mulch_direct_striptill_after_withdrawal",
} if {
	es_acker_mulch_blocked
	some m in object.get(input, ["farm", "oepul", "participations"], [])
	m.measure_code == "8"
	object.get(m, "year", lib.year) == lib.year
	"mulch_direct_strip_till" in object.get(m, "options", [])
}

# Vertrag erlischt bei Unterschreiten der Mindestteilnahme; ein neuer,
# fristgerechter Maßnahmenantrag ist für eine Wiederteilnahme erforderlich.
contract_lapsed_in_year if lib.arable_area_ha < lib.params.access.min_arable_area_ha

violations contains {
	"rule_id": "O67-CONTRACT-LAPSE-REAPPLY",
	"code": "reentry_without_new_measure_application",
} if {
	lapsed := o67.contract_lapsed_year
	lapsed < lib.year
	not _new_application_after(lapsed)
}

_new_application_after(lapsed) if {
	lib.day(o67.application_date) > lib.mmdd_day(lapsed, "01-01")
	lib.day(o67.application_date) <= lib.mmdd_day(lib.year - 1, lib.params.contract.application_deadline_mmdd)
}

# Wiedereinstieg nach Ausstieg, Ausschluss oder einjähriger Nichtabgabe des
# Mehrfachantrages nur mit neuerlichem Maßnahmenantrag.
violations contains {
	"rule_id": "O67-REENTRY-NEW-APPLICATION",
	"code": "reentry_after_exit_or_missing_mfa_without_new_application",
} if {
	o67.reentry_after_exit_or_missing_mfa == true
	not o67.new_measure_application_submitted == true
}

# Wechsel in „Begrünung von Ackerflächen – Zwischenfruchtanbau“: Beantragung bis
# 31.12. im Maßnahmenantrag, spätester Umstieg 31.12.2026 für 2027.
switch_to_6_valid if {
	d := lib.day(o67.switch_to_6_application_date)
	d <= lib.day(lib.params.contract.last_switch_to_measure_6_date)
}

violations contains {
	"rule_id": "O67-SWITCH-TO-6",
	"code": "switch_to_6_after_last_date",
	"application_date": o67.switch_to_6_application_date,
} if {
	o67.switch_to_6_application_date
	not switch_to_6_valid
}

# Feldfuttermischung nach Hauptkultur, im Frühjahr genutzt und als
# Doppelnutzung beantragt, ist Hauptfrucht: keine Teilnahme an „Erosionsschutz
# Acker“ (Mulchsaat/Direktsaat/Strip-Till) auf dieser Fläche.
violations contains {
	"rule_id": "O67-FIELD-FODDER-DOUBLE-USE",
	"code": "es_acker_mulch_on_double_use_field_fodder",
	"parcel_id": e.parcel_id,
} if {
	some e in lib.segments
	e.seg.double_use_field_fodder == true
	some p in lib.arable_parcels
	p.parcel_id == e.parcel_id
	p.es_acker_mulch_direct_strip_till == true
}

# Automatische Verlängerung um ein weiteres Förderjahr ohne Abmeldung.
auto_renewed_next_year if {
	not o67.withdrawal_date
	not contract_lapsed_in_year
}
