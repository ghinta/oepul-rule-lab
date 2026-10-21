# ÖPUL 2023 Erosionsschutz Acker (o6_8) - gemeinsame Hilfsfunktionen
# Zugriff auf Eingabe (Canonical Farm Profile plus vorgeschlagene
# Erweiterungen unter farm.oepul und land.parcels[].oepul_o6_8) und auf
# die Datentabellen unter data.o6_8.
package oepul.o6_8

params := data.o6_8.measure_parameters

general := data.o6_8.general_conditions

rate_table := data.o6_8.premium_rates

crop_lists := data.o6_8.eligible_crops

definitions := data.o6_8.oepul_definitions

year := input.farm.year

parcels := object.get(input, ["land", "parcels"], [])

oepul := object.get(input, ["farm", "oepul"], {})

o68 := object.get(oepul, "o6_8", {})

participating_measures := {m | some m in object.get(oepul, "participating_measures", [])}

farm_options := {o | some o in object.get(oepul, "options", [])}

all_codes := {c.code | some c in params.codes}

pinfo(p) := object.get(p, "oepul_o6_8", {})

pid(p) := object.get(p, "parcel_id", null)

codes(p) := {c | some c in object.get(p, ["oepul_o6_8", "codes"], [])}

has_code(p, c) if c in codes(p)

parcel_area(p) := object.get(p, "area_ha", 0)

# Schlagnutzungsart laut Mehrfachantrag; Rückfall auf crop.crop_name.
usage(p) := u if {
	u := object.get(p, ["oepul_o6_8", "crop_usage_type"], null)
	u != null
} else := object.get(p, ["crop", "crop_name"], null)

# Lage des Schlages; Rückfall auf die Betriebsregion.
parcel_location(p) := {
	"country": object.get(p, ["oepul_o6_8", "location", "country"], "AT"),
	"federal_state": object.get(p, ["oepul_o6_8", "location", "federal_state"], object.get(input, ["farm", "region", "federal_state"], null)),
	"district": object.get(p, ["oepul_o6_8", "location", "district"], object.get(input, ["farm", "region", "district"], null)),
	"kg_nr": object.get(p, ["oepul_o6_8", "location", "kg_nr"], null),
	"national_park": object.get(p, ["oepul_o6_8", "location", "national_park"], null),
}

ns_per_day := 86400000000000

date_ns(d) := time.parse_ns("2006-01-02", d)

days_between(a, b) := (date_ns(b) - date_ns(a)) / ns_per_day

on_or_before(d, limit) if date_ns(d) <= date_ns(limit)

after(d, limit) if date_ns(d) > date_ns(limit)

date_year(d) := time.date(date_ns(d))[0]

ymd(y, mmdd) := sprintf("%d-%s", [y, mmdd])

# Gültigkeitsbereich einer Tabellenzeile mit year_from / year_to (null = offen).
year_in_range(r, y) if {
	object.get(r, "year_from", 0) <= y
	object.get(r, "year_to", null) == null
}

year_in_range(r, y) if {
	object.get(r, "year_from", 0) <= y
	to := object.get(r, "year_to", null)
	to != null
	y <= to
}

round2(x) := round(x * 100) / 100

violation(rule_id, p, code, msg) := {
	"rule_id": rule_id,
	"parcel_id": pid(p),
	"code": code,
	"message": msg,
}

farm_violation(rule_id, msg) := {
	"rule_id": rule_id,
	"parcel_id": null,
	"code": null,
	"message": msg,
}
