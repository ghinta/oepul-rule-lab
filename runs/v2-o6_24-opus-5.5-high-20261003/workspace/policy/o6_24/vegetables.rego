package oepul.o6_24

import rego.v1

# GWSP Anlage 3 Punkt 5: Feldgemüsebau (Fruchtfolge Tab. 5, Nmin-Untersuchung,
# Gießwasseruntersuchung) sowie Speiseerdäpfel.

fruchtfolge := {r.family: r | some r in data.o6_24.gwsp_fruchtfolge_gemuese.rows}

crop_history(p) := object.get(wrrl_of(p), "crop_history", [])

# Hauptkulturen einer Pflanzenfamilie im Zeitfenster [farm_year - window + 1, farm_year].
family_main_crop_count(p, family, window) := count([h |
	some h in crop_history(p)
	h.plant_family == family
	object.get(h, "is_main_crop", true) == true
	h.year > farm_year - window
	h.year <= farm_year
	not h.crop_name in {x | some x in fruchtfolge[family].excludes}
])

rotation_violations[p.parcel_id] contains family if {
	some p in area_arable_parcels
	some family, rule in fruchtfolge
	is_number(rule.window_years)
	family_main_crop_count(p, family, rule.window_years) > rule.max_main_crop_count
}

# Mehrjährige Kulturen: Mindest-Anbaupause nach Kulturende.
rotation_violations[p.parcel_id] contains sprintf("%s (Anbaupause mehrjährige Kultur)", [family]) if {
	some p in area_arable_parcels
	some family, rule in fruchtfolge
	is_number(rule.perennial_min_break_years)
	some h in crop_history(p)
	h.plant_family == family
	object.get(h, "is_perennial", false) == true
	is_number(object.get(h, "culture_end_year", null))
	some n in crop_history(p)
	n.plant_family == family
	n.year > h.culture_end_year
	(n.year - h.culture_end_year) - 1 < rule.perennial_min_break_years
}

# Erdbeeren: Kulturdauer max. 3 Jahre, Kulturpause 2 Jahre (ausgenommen Strohkultur).
rotation_violations[p.parcel_id] contains "Erdbeeren (Kulturdauer)" if {
	some p in area_arable_parcels
	some h in crop_history(p)
	h.plant_family == "Erdbeeren"
	object.get(h, "straw_culture", false) == false
	object.get(h, "culture_duration_years", 0) > fruchtfolge.Erdbeeren.max_culture_duration_years
}

rotation_violations[p.parcel_id] contains "Erdbeeren (Kulturpause)" if {
	some p in area_arable_parcels
	some h in crop_history(p)
	h.plant_family == "Erdbeeren"
	object.get(h, "straw_culture", false) == false
	is_number(object.get(h, "culture_end_year", null))
	some n in crop_history(p)
	n.plant_family == "Erdbeeren"
	n.year > h.culture_end_year
	(n.year - h.culture_end_year) - 1 < fruchtfolge.Erdbeeren.min_culture_break_years
}

is_vegetable_parcel(p) if is_vegetable_tab3(p)

is_vegetable_parcel(p) if object.get(wrrl_of(p), "is_vegetable_or_strawberry", false) == true

# Nmin-Untersuchung jährlich vor Anbau (jedenfalls vor der ersten Düngung).
first_event_date(p) := min(array.concat(
	[a.date | some a in applications_of(p)],
	[d | d := object.get(wrrl_of(p), "sowing_date", null); is_string(d)],
))

nmin_missing[p.parcel_id] if {
	some p in area_arable_parcels
	is_vegetable_tab3(p)
	not nmin_ok(p)
}

nmin_ok(p) if {
	t := object.get(wrrl_of(p), "nmin_test_date", null)
	is_string(t)
	year_of(t) == farm_year
	t <= first_event_date(p)
}

nmin_ok(p) if {
	t := object.get(wrrl_of(p), "nmin_test_date", null)
	is_string(t)
	year_of(t) == farm_year
	count(applications_of(p)) == 0
	not is_string(object.get(wrrl_of(p), "sowing_date", null))
}

# Gießwasseruntersuchung auf Nitrat mindestens alle drei Jahre je Wasserentnahmestelle;
# visuelles Ablesen von Messstreifen nicht ausreichend.
water_tests := object.get(input, ["documentation", "irrigation_water_nitrate_tests"], [])

valid_water_test(src) if {
	some t in water_tests
	t.water_source_id == src
	t.method in {"authorized_body", "suitable_method"}
	farm_year - year_of(t.test_date) < 3
}

irrigation_water_test_missing[p.parcel_id] contains src if {
	some p in area_arable_parcels
	is_vegetable_parcel(p)
	some src in object.get(wrrl_of(p), "irrigation_water_sources", [])
	not valid_water_test(src)
}

# Speiseerdäpfel: ganzjähriges Offenhalten des Bodens nicht geringfügig.
potato_soil_open_all_year[p.parcel_id] if {
	some p in area_arable_parcels
	crop_name_of(p) == "Speisekartoffel, Industriekartoffel"
	object.get(wrrl_of(p), "table_potato", true) == true
	object.get(wrrl_of(p), "soil_open_all_year", false) == true
}

vegetable_findings[pid] contains "Fruchtfolge" if {
	some pid, _ in rotation_violations
}

vegetable_findings[pid] contains "Nmin-Untersuchung" if nmin_missing[pid]

vegetable_findings[pid] contains "Gießwasseruntersuchung" if {
	some pid, _ in irrigation_water_test_missing
}

vegetable_findings[pid] contains "Speiseerdäpfel ganzjährig offener Boden" if potato_soil_open_all_year[pid]
