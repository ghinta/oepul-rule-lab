# Gemeinsame Hilfsfunktionen und Datenzugriffe für die Maßnahme
# „Begrünung von Ackerflächen – System Immergrün“ (ÖPUL 2023, Maßnahme 7).
package o6_7.lib

params := data.oepul.o6_7.parameters

lists := data.oepul.o6_7.lists

general := data.oepul.o6_7.general

combinations := data.oepul.o6_7.combinations

notices := data.oepul.o6_7.notices_2026

ns_per_day := 86400000000000

year := input.farm.year

# Tagesnummer (Tage seit 1970-01-01, UTC) eines ISO-Datums "YYYY-MM-DD".
day(date_str) := floor(time.parse_ns("2006-01-02", date_str) / ns_per_day)

# Tagesnummer eines Monats-/Tagesstichtags "MM-DD" im angegebenen Jahr.
mmdd_day(y, mmdd) := day(sprintf("%d-%s", [y, mmdd]))

# ISO-Datum zu einer Tagesnummer.
date_of(d) := time.format([d * ns_per_day, "UTC", "2006-01-02"])

year_of(date_str) := to_number(substring(date_str, 0, 4))

days_between(a, b) := day(b) - day(a)

year_start_day := mmdd_day(year, "01-01")

year_end_day := mmdd_day(year, "12-31")

# Liste der Maßnahmencodes, an denen der Betrieb im Bewertungsjahr teilnimmt.
participating_codes contains code if {
	some m in object.get(input, ["farm", "oepul", "participations"], [])
	object.get(m, "year", year) == year
	code := m.measure_code
}

participates(code) if code in participating_codes

arable_parcels contains p if {
	some p in object.get(input, ["land", "parcels"], [])
	p.land_use == "arable"
}

# Ackerfläche gemäß Mehrfachantrag: bevorzugt Summe der Ackerschläge,
# sonst aggregierter Wert des Profils.
arable_area_ha := sum([p.area_ha | some p in arable_parcels]) if {
	count(arable_parcels) > 0
} else := object.get(input, ["land", "arable_area_ha"], 0)

approx_gt(a, b) if a - b > 0.000000001

# Alle Begrünungsabschnitte (Haupt-/Zwischenfrüchte, Brachen, Selbstbegrünung)
# aller Ackerschläge, geschlüsselt als "<parcel_id>/<segment_id>".
segments[key] := {"parcel_id": p.parcel_id, "seg": s} if {
	some p in arable_parcels
	some i, s in object.get(p, ["greening", "segments"], [])
	key := sprintf("%s/%v", [p.parcel_id, object.get(s, "segment_id", i)])
}
