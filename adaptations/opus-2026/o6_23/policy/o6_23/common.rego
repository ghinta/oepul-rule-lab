# ÖPUL 2023 – Natura 2000 und andere Schutzgebiete – Landwirtschaft (o6_23)
# Gemeinsame Datenreferenzen und Hilfsfunktionen.
package oepul.o6_23

params := data.o6_23

rates_table := data.o6_23

combinations := data.o6_23

measure_code := params.measure.srl_measure_code

year := input.farm.year

parcels := object.get(input, ["land", "parcels"], [])

o6_23_input := object.get(input, ["farm", "oepul", "o6_23"], {})

# Natura-2000-spezifische Schlagangaben (Profilerweiterung, siehe rules/profile_changes.json).
n2(p) := object.get(p, ["constraints", "natura2000"], {})

parcel_oepul(p) := object.get(p, "oepul", {})

parcel_eligibility(p) := object.get(p, "eligibility", {})

date_ns(s) := time.parse_ns("2006-01-02", s)

year_end_ns(y) := date_ns(sprintf("%d-12-31", [y]))

year_start_ns(y) := date_ns(sprintf("%d-01-01", [y]))

# Alle Auflagencodes der Maßnahme (Anhang I gleichinhaltlich, Kapitel 7 Informationsblatt).
known_codes := {r.code | some r in rates_table.premium_rates}

rate_row(code) := r if {
	some r in rates_table.premium_rates
	r.code == code
}

gi_codes := {r.code | some r in rates_table.premium_rates; r.group == "GI"}

gl_codes := {r.code | some r in rates_table.premium_rates; r.group == "GL"}

eligible_grassland_types := {t.type | some t in rates_table.eligible_grassland_types}

excluded_grassland_types := {t.type | some t in rates_table.excluded_grassland_types}

# Auflagencodes laut Projektbestätigung, die prämienrelevant sind.
parcel_codes(p) := {c | some c in object.get(n2(p), "project_confirmation_codes", []); c in known_codes}

parcel_unknown_codes(p) := {c | some c in object.get(n2(p), "project_confirmation_codes", []); not c in known_codes}

# Schläge, die im Mehrfachantrag mit dem Code N2 gekennzeichnet sind.
n2_parcels contains p if {
	some p in parcels
	object.get(n2(p), "n2_code_marked", false) == true
}

n2_parcel_ids := {p.parcel_id | some p in n2_parcels}
