package oepul.o6_24

import rego.v1

# Wasserrechtliche Basisanforderungen des Grundwasserschutzprogramms Graz bis
# Bad Radkersburg 2018 (§ 4 Z 4 bis 7, § 6, Anlage 3 Punkt 4 und 5, Hinweis 2).
# Diese Anforderungen sind nicht als ÖPUL-Förderverpflichtungen in SRL 2.24 genannt;
# Abweichungen bedürfen einer wasserrechtlichen Bewilligung (§ 4 Z 7).

# Anlage 3 Punkt 4: Gaben von mehr als 100 kg N/ha in einem Abstand von weniger als drei
# Wochen sind nicht geringfügig (Gleitfenster 21 Tage; siehe Annahmen).
max_n_within_3_weeks := 100

window_n_sum(p, start) := sum([b.n_effective_kg_per_ha |
	some b in applications_of(p)
	days_between(start, b.date) >= 0
	days_between(start, b.date) < 21
])

n_over_100_within_3_weeks[p.parcel_id] contains a.date if {
	some p in area_arable_parcels
	some a in applications_of(p)
	window_n_sum(p, a.date) > max_n_within_3_weeks
}

# Anlage 3 Punkt 4: Zeitraum zwischen N-Düngung und Anbau maximal 10 Tage (ausgenommen Mist
# von Huf- und Klauentieren, Kompost; Wintergerste 6 Tage).
max_days_fertilization_to_sowing := 10

pre_sowing_apps(p) := [a |
	sow := object.get(wrrl_of(p), "sowing_date", null)
	is_string(sow)
	some a in applications_of(p)
	not a.fertilizer_type in {"solid_manure_hoof_claw", "compost"}
	days_between(a.date, sow) >= 0
]

fertilization_too_early_before_sowing[p.parcel_id] contains a.date if {
	some p in area_arable_parcels
	some a in pre_sowing_apps(p)
	days_between(a.date, wrrl_of(p).sowing_date) > max_days_fertilization_to_sowing
}

# Anlage 3 Hinweis 2 / § 32 Abs. 2 lit. f WRG 1959: Bewilligungspflicht über 175 kg N/ha
# (ohne Gründeckung) bzw. 210 kg N/ha (mit Gründeckung, Dauergrünland oder N-zehrender
# Fruchtfolge); Wirtschaftsdünger in feldfallender Wirkung anzurechnen.
wrg_threshold(p) := 210 if {
	object.get(wrrl_of(p), "green_cover_or_n_consuming_rotation", object.get(p, ["operations", "cover_crop", "is_used"], false)) == true
} else := 175

n_field_total(p) := sum([object.get(a, "n_field_kg_per_ha", a.n_effective_kg_per_ha) | some a in applications_of(p)])

wrg_permit_required[p.parcel_id] := {"n_field": n_field_total(p), "threshold": wrg_threshold(p)} if {
	some p in parcels
	object.get(wrrl_of(p), "in_area", false) == true
	n_field_total(p) > wrg_threshold(p)
	object.get(wrrl_of(p), "wrg_permit", false) == false
}

# GWSP § 4 Z 7: jede Abweichung von Z 1 bis 6 bedarf einer wasserrechtlichen Bewilligung.
gwsp_permit_required_reasons[pid] contains "N-Höchstmenge Anlage 3 Punkt 1/2 überschritten" if {
	some pid, _ in n_limit_exceeded
	not has_increased_n_permit(pid)
}

gwsp_permit_required_reasons[pid] contains "Ausbringung außerhalb bewilligungsfreier Zeiträume (Anlage 3 Punkt 3)" if {
	some pid, _ in applications_outside_period
}

gwsp_permit_required_reasons[pid] contains "Düngung von Begrünungen oder brachliegenden Flächen" if {
	fallow_or_cover_fertilized[pid]
}

gwsp_permit_required_reasons[pid] contains "Art und Weise der Ausbringung (Anlage 3 Punkt 4)" if {
	some pid, _ in n_over_100_within_3_weeks
}

gwsp_permit_required_reasons[pid] contains "Art und Weise der Ausbringung (Anlage 3 Punkt 4)" if {
	some pid, _ in fertilization_too_early_before_sowing
}

gwsp_permit_required_reasons[pid] contains "Gemüsebau-Voraussetzungen (Anlage 3 Punkt 5)" if {
	some pid, _ in vegetable_findings
}

has_increased_n_permit(pid) if object.get(wrrl_of(area_arable_parcels[pid]), "increased_n_permit", false) == true

# GWSP § 6: zusätzliche Bewilligungspflichten im Widmungsgebiet 2 (Schongebiet).
wg2_items := {i.key: i | some i in data.o6_24.gwsp_widmungsgebiet2_bewilligungspflichten.items}

wg2_activity_requires_permit(act) if {
	item := wg2_items[act.key]
	not item.threshold_kg
	not item.threshold_ha
	not item.threshold_kg_n_per_ha
}

wg2_activity_requires_permit(act) if act.value > wg2_items[act.key].threshold_kg

wg2_activity_requires_permit(act) if act.value > wg2_items[act.key].threshold_ha

wg2_activity_requires_permit(act) if act.value > wg2_items[act.key].threshold_kg_n_per_ha

wg2_permit_missing contains act.key if {
	some act in object.get(input, ["farm", "gwsp_widmungsgebiet2_activities"], [])
	wg2_activity_requires_permit(act)
	object.get(act, "has_permit", false) == false
}
