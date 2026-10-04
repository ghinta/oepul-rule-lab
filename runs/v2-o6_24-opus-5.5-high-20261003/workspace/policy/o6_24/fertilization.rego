package oepul.o6_24

import rego.v1

# Förderverpflichtung Stickstoffdüngung (Maßnahmenblatt 4.1; SRL 2.24 lit. a und b)
# in Verbindung mit GWSP § 4 und Anlage 3 Punkt 1 bis 3 (LGBl. Nr. 47/2026).

tab2 := data.o6_24.gwsp_n_limits_acker.rows

tab3 := data.o6_24.gwsp_n_limits_gemuese.rows

termine := data.o6_24.gwsp_duengetermine

default_class := data.o6_24.gwsp_duengeklassen.default_class_if_unassigned

# Düngeklassenanteile eines Schlages; nicht zugeordnete Flächen gelten als Klasse C.
assigned_classes(p) := object.get(wrrl_of(p), "fertilization_classes", [])

assigned_area(p) := sum([c.area_ha | some c in assigned_classes(p)])

class_shares(p) := array.concat(assigned_classes(p), [{"class": default_class, "area_ha": p.area_ha - assigned_area(p)}]) if {
	p.area_ha - assigned_area(p) > 0.00005
} else := assigned_classes(p)

crop_limits(p) := tab2[crop_name_of(p)]

crop_limits(p) := tab3[crop_name_of(p)] if not tab2[crop_name_of(p)]

# Gewichtetes Mittel der Düngeobergrenzen (Maßnahmenblatt 4.1, Anlage 3 Hinweis 3).
weighted_limit_terms(p) := [term |
	limits := crop_limits(p)
	some c in class_shares(p)
	term := limits[c.class] * c.area_ha
]

base_n_limit(p) := round((sum(weighted_limit_terms(p)) / sum([c.area_ha | some c in class_shares(p)])) * 100) / 100

# Anlage 3 Punkt 2: Erhöhung um 10 % im Ackerbau bei winterharter Gründecke.
increase_10pct_claimed(p) if object.get(wrrl_of(p), ["increase_10pct", "claimed"], false) == true

increase_10pct_valid(p) if {
	is_arable_tab2(p)
	inc := wrrl_of(p).increase_10pct
	inc.claimed == true
	inc.winter_hardy_cover_directly_after_main_crop == true
	inc.cover_fertilized == false
	inc.cover_same_field_and_area == true
	inc.cover_contains_legumes == false
	inc.cover_removed_only_before_spring_sowing == true
	inc.written_notice_before_fertilization == true
}

increase_10pct_invalid_conditions(p) := {k |
	inc := object.get(wrrl_of(p), "increase_10pct", {})
	some k, want in {
		"winter_hardy_cover_directly_after_main_crop": true,
		"cover_fertilized": false,
		"cover_same_field_and_area": true,
		"cover_contains_legumes": false,
		"cover_removed_only_before_spring_sowing": true,
		"written_notice_before_fertilization": true,
	}
	object.get(inc, k, null) != want
}

n_limit_kg_per_ha[p.parcel_id] := round(base_n_limit(p) * 110) / 100 if {
	some p in area_arable_parcels
	increase_10pct_valid(p)
}

n_limit_kg_per_ha[p.parcel_id] := base_n_limit(p) if {
	some p in area_arable_parcels
	crop_limits(p)
	not increase_10pct_valid(p)
}

# Anlage 3 Punkt 1: anzurechnende N-Menge = jahreswirksame Düngung + Nachlieferung aus
# Vorfrucht/Ernterückständen + Stickstoff im Gießwasser.
n_fertilizer_effective(p) := sum([a.n_effective_kg_per_ha | some a in applications_of(p)])

n_accounted_kg_per_ha[p.parcel_id] := total if {
	some p in area_arable_parcels
	total := (n_fertilizer_effective(p) + object.get(wrrl_of(p), "previous_crop_n_credit_kg_per_ha", 0)) + object.get(wrrl_of(p), "irrigation_n_kg_per_ha", 0)
}

n_limit_exceeded[pid] := {"accounted": n_accounted_kg_per_ha[pid], "limit": limit} if {
	some pid, limit in n_limit_kg_per_ha
	n_accounted_kg_per_ha[pid] > limit
}

# Kulturen ohne Tabellenwert: Verweis auf die NAPV-Düngeobergrenzen (Anlage 3 nach Tab. 2,
# Hinweis 1 zu Tab. 3) – NAPV ist nicht Teil der Quellen dieses Runs.
napv_limit_required[p.parcel_id] if {
	some p in area_arable_parcels
	count(applications_of(p)) > 0
	not crop_limits(p)
	not is_fallow(p)
}

# Maßnahmenblatt 4.1: Teilflächen mit höherer Düngeklasse separat düngen -> eigener Schlag
# und separate Aufzeichnungen.
separate_plot_required[p.parcel_id] if {
	some p in area_arable_parcels
	count(assigned_classes(p)) > 1
	object.get(wrrl_of(p), "fertilize_subareas_by_class", false) == true
}

# --- Düngetermine (Anlage 3 Punkt 3, Tab. 4) ---

period_row_name(p) := wrrl_of(p).gwsp_period_crop if {
	is_string(object.get(wrrl_of(p), "gwsp_period_crop", null))
} else := row.row if {
	some row in termine.rows
	crop_name_of(p) in row.crops_tab2_tab3
} else := termine.fallback_row

period_row(p) := row if {
	some row in termine.rows
	row.row == period_row_name(p)
}

period_row_assumed[p.parcel_id] if {
	some p in area_arable_parcels
	not is_string(object.get(wrrl_of(p), "gwsp_period_crop", null))
	crop_name_of(p) in {c | some c in termine.ambiguous_tab2_crops_require_explicit_period_row}
}

period_exempt_type(a) if a.fertilizer_type in {t | some t in termine.excluded_fertilizer_types}

application_in_regular_period(p, a) if {
	row := period_row(p)
	md_in_window(a.date, row.from, row.to)
}

is_winter_barley(p) if period_row_name(p) == "Wintergerste"

winter_barley_special_window(a) if md_in_window(a.date, termine.winter_barley_special.from, termine.winter_barley_special.to)

winter_barley_special_apps(p) := [a |
	some a in applications_of(p)
	not period_exempt_type(a)
	winter_barley_special_window(a)
]

increase_10pct_claimed_bool(p) if {
	increase_10pct_claimed(p)
} else := false

# *) Sonderregelung Wintergerste: verletzte Bedingungen.
winter_barley_special_conditions_violated(p) := {k |
	some k, v in {
		"n_over_30kg": sum([a.n_effective_kg_per_ha | some a in winter_barley_special_apps(p)]) > termine.winter_barley_special.max_n_kg_per_ha,
		"sowing_later_than_6_days": winter_barley_sowing_late(p),
		"no_legume_free_cover_after_harvest": object.get(wrrl_of(p), ["winter_barley_special", "legume_free_cover_or_n_consuming_crop_after_harvest"], false) == false,
		"cover_removed_before_spring": object.get(wrrl_of(p), ["winter_barley_special", "cover_removed_only_before_spring_sowing"], false) == false,
		"increase_10pct_used": increase_10pct_claimed_bool(p),
		"no_written_notice": object.get(wrrl_of(p), ["winter_barley_special", "written_notice_before_fertilization"], false) == false,
	}
	v == true
}

winter_barley_sowing_late(p) if {
	sow := object.get(wrrl_of(p), "sowing_date", null)
	some a in winter_barley_special_apps(p)
	not winter_barley_sowing_ok(a, sow)
} else := false

winter_barley_sowing_ok(a, sow) if {
	is_string(sow)
	days_between(a.date, sow) >= 0
	days_between(a.date, sow) <= termine.winter_barley_special.max_days_fertilization_to_sowing
	month_day(sow) <= termine.winter_barley_special.latest_sowing_md
}

application_allowed_in_period(_, a) if period_exempt_type(a)

application_allowed_in_period(p, a) if {
	not period_exempt_type(a)
	application_in_regular_period(p, a)
}

application_allowed_in_period(p, a) if {
	not period_exempt_type(a)
	is_winter_barley(p)
	winter_barley_special_window(a)
	count(winter_barley_special_conditions_violated(p)) == 0
}

applications_outside_period[p.parcel_id] contains a.date if {
	some p in area_arable_parcels
	not is_fallow(p)
	some a in applications_of(p)
	not application_allowed_in_period(p, a)
}

# Anlage 3 Hinweis zu Tab. 4: Düngung von Begrünungen und brachliegenden Flächen
# grundsätzlich bewilligungspflichtig.
fallow_or_cover_fertilized[p.parcel_id] if {
	some p in area_arable_parcels
	is_fallow(p)
	count(applications_of(p)) > 0
}

# Anlage 3 Hinweis zu Tab. 4: Sojabohne – Düngung nur bei nicht beimpftem Saatgut,
# mangelndem Knöllchenbesatz oder erstmaligem Anbau.
soy_fertilization_not_justified[p.parcel_id] if {
	some p in area_arable_parcels
	crop_name_of(p) == "Sojabohne"
	count(applications_of(p)) > 0
	not object.get(wrrl_of(p), "soy_fertilization_reason", null) in {"non_inoculated_seed", "lacking_nodules", "first_cultivation"}
}

increase_10pct_not_valid[p.parcel_id] := increase_10pct_invalid_conditions(p) if {
	some p in area_arable_parcels
	increase_10pct_claimed(p)
	not increase_10pct_valid(p)
}
