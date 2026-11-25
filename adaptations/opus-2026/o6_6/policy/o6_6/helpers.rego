# Hilfsfunktionen für die Maßnahme o6_6 "Begrünung von Ackerflächen – Zwischenfruchtanbau".
package oepul.o6_6

date_layout := "2006-01-02"

one_day_ns := 86400000000000

year := input.farm.year

# Datum "YYYY-MM-DD" in Nanosekunden.
ns(d) := time.parse_ns(date_layout, d)

# Datum aus Jahr und "MM-DD".
ns_md(y, mmdd) := time.parse_ns(date_layout, sprintf("%d-%s", [y, mmdd]))

parcels := object.get(input, ["land", "parcels"], [])

cc(p) := object.get(p, ["operations", "cover_crop"], {})

# Schläge mit beantragter Begrünungsvariante.
cover_parcels contains p if {
	some p in parcels
	is_number(object.get(cc(p), "variant", null))
}

# Variantenzeile passend zum Antragsjahr (data/o6_6/variants.json).
variant_row(v) := row if {
	some row in data.o6_6.variants.rows
	row.variant == v
	row.valid_from_year <= year
	year <= row.valid_to_year
}

row_of(p) := variant_row(cc(p).variant)

# Anlagedatum: bei Untersaaten gilt die Ernte der Hauptfrucht als Anlagedatum.
establishment_date(p) := cc(p).preceding_main_crop_harvest_date if {
	cc(p).establishment == "undersowing"
} else := cc(p).sowing_date

establishment_ns(p) := ns(establishment_date(p))

# Ende des Begrünungszeitraums (frühester Umbruch).
period_end_ns(p) := ns_md(year + row_of(p).period_end_year_offset, row_of(p).period_end) if {
	row_of(p).period_end_type == "fixed_date"
}

period_end_ns(p) := max({
	time.add_date(establishment_ns(p), 0, 0, row_of(p).min_days_after_sowing),
	ns_md(year, row_of(p).not_before),
}) if {
	row_of(p).period_end_type == "min_days_not_before"
}

events(p) := object.get(cc(p), "events", [])

# Ereignisse im Begrünungszeitraum [Anlage, Ende).
event_in_period(p, e) if {
	d := ns(e.date)
	d >= establishment_ns(p)
	d < period_end_ns(p)
}

has_event_type(p, t) if {
	some e in events(p)
	e.type == t
}

list_items(name) := {i | some i in data.o6_6.species_lists[name].items}

cereal_or_maize(s) if s in list_items("cereals_oepul")

cereal_or_maize(s) if contains(lower(s), "mais")

measure_codes := {m.measure_code | some m in object.get(input, ["farm", "oepul", "measures"], [])}

o6_6_measure := m if {
	some m in object.get(input, ["farm", "oepul", "measures"], [])
	m.measure_code == "6"
}

gc := data.o6_6.general_conditions
