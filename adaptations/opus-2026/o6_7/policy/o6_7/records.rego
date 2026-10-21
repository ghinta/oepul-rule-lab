# Aufzeichnungsverpflichtung (Kapitel 5.3) und Angaben im Mehrfachantrag
# (Kapitel 6) der Maßnahme System Immergrün.
package o6_7.records

import data.o6_7.catch_crop
import data.o6_7.lib

violations contains {
	"rule_id": "O67-RECORDS",
	"code": "farm_field_records_incomplete",
} if {
	input.documentation.field_records_complete == false
}

# Schlagbezogene Aufzeichnungen über Ernte Hauptfrucht, Anlage und Umbruch der
# Zwischenfrucht sowie Anlage der Nachfolge-Hauptfrucht – ganzjährig und für die
# gesamte Ackerfläche (unabhängig von den 85 %).
violations contains {
	"rule_id": "O67-RECORDS",
	"code": "parcel_record_missing",
	"parcel_id": p.parcel_id,
	"event": ev,
} if {
	some p in lib.arable_parcels
	records := object.get(p, ["greening", "records"], {})
	some ev in lib.lists.record_events
	object.get(records, ev, true) == false
}

violations contains {
	"rule_id": "O67-RECORDS",
	"code": "records_not_kept_full_year",
	"parcel_id": p.parcel_id,
} if {
	some p in lib.arable_parcels
	object.get(p, ["greening", "records", "full_year_jan_to_dec"], true) == false
}

# Sämtliche Hauptfrüchte einschließlich Zweitkulturen sind im Mehrfachantrag zu
# beantragen.
violations contains {
	"rule_id": "O67-MFA-MAIN-CROPS",
	"code": "main_crop_not_declared_in_mfa",
	"parcel_id": e.parcel_id,
	"segment": object.get(e.seg, "segment_id", null),
} if {
	some e in lib.segments
	e.seg.kind == "main_crop"
	e.seg.declared_in_mfa == false
}

# Zwischenfrüchte dürfen nicht im Mehrfachantrag beantragt werden; eine
# beantragte Begrünung gilt als Hauptfrucht (Umqualifizierung, kein Verstoß).
reclassified_as_main_crop contains key if {
	some key, e in lib.segments
	e.seg.kind == "catch_crop"
	catch_crop.effective_kind(e.seg) == "main_crop"
}
