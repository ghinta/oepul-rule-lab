package oepul.o6_17.common

# Gemeinsame Hilfsregeln für die Maßnahme „Humuserhalt und Bodenschutz auf
# umbruchsfähigem Grünland“ (SRL 2.17, Maßnahmencode 17).

cfg := data.o6_17_tables

year := input.farm.year

o6 := object.get(input, ["farm", "oepul", "o6_17"], {})

measures := {m | some m in object.get(input, ["farm", "oepul", "participating_measures"], [])}

parcels := object.get(input, ["land", "parcels"], [])

grassland_parcels := [p | some p in parcels; p.land_use == "grassland"]

use_type(p) := object.get(p, "grassland_use_type", "unknown")

use_types_by_id := {t.id: t | some t in cfg.grassland_use_types}

use_type_info(p) := use_types_by_id[use_type(p)]

codes(p) := {c | some c in object.get(p, "codes", [])}

parcel_measures(p) := {m | some m in object.get(p, "oepul_measures", [])}

slope(p) := object.get(p, "slope_percent", null)

slope_below_18(p) if {
	s := slope(p)
	is_number(s)
	s < cfg.premium_rates.base_slope_limit_percent
}

slope_from_18(p) if {
	s := slope(p)
	is_number(s)
	s >= cfg.premium_rates.base_slope_limit_percent
}

# GLÖZ 2, GLÖZ 4 oder GLÖZ 9 Umbruchsverbot auf dem Schlag.
gloez_ban(p) if {
	some s in cfg.obligation_lists.gloez_ploughing_ban_standards
	object.get(p, ["gloez_ploughing_ban", s.id], false) == true
}

normalize(s) := n if {
	l := lower(s)
	u := replace(replace(replace(replace(l, "ä", "ae"), "ö", "oe"), "ü", "ue"), "ß", "ss")
	n := replace(replace(trim_space(u), "-", "_"), " ", "_")
}

round2(x) := round(x * 100) / 100

round3(x) := round(x * 1000) / 1000

contract_start_year := object.get(o6, "contract_start_year", null)

exit_date := object.get(o6, "exit_date", null)

exited_in_or_before_year if {
	is_string(exit_date)
	to_number(substring(exit_date, 0, 4)) <= year
}

# Vertrag läuft im Antragsjahr (Beginn 2023, 2024 oder 2025, Ende 31.12.2028).
contract_active if {
	is_number(contract_start_year)
	contract_start_year <= year
	year <= to_number(substring(cfg.general_framework.contract_end_date, 0, 4))
	not exited_in_or_before_year
}

is_first_year if year == contract_start_year

in_measure(codes_any) if {
	some m in measures
	m in codes_any
}

default contract_active := false
