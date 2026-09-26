# o6_10 – Förderverpflichtungen (Begrünung, Bodenbearbeitung, Nutzung, Pflanzenschutz, Aufzeichnungen)
package oepul.o6_10

greening(p) := object.get(p, ["operations", "inter_row_greening"], {})

# Begrünungspflicht auf allen Wein-, Obst- und Hopfenflächen außer Terrassen (O610-GREEN-TERRACE-EXEMPT)
greening_required(p) if {
	vfh_parcel(p)
	not is_terrace(p)
}

greening_parcels := [p | some p in parcels; greening_required(p)]

# O610-2026-DROUGHT-GREENING: 2026 keine Beanstandung bei ordnungsgemäßer Anlage
drought_2026_relief(p) if {
	year == data.o6_10.drought_2026.year
	params.measure_code in {m | some m in data.o6_10.drought_2026.greening_coverage_relief_measures}
	object.get(greening(p), "properly_established", false) == true
}

drought_2026_relief_parcels contains p.parcel_id if {
	some p in greening_parcels
	drought_2026_relief(p)
	coverage_or_volunteer_cereal_shortfall(p)
}

coverage_or_volunteer_cereal_shortfall(p) if object.get(greening(p), "full_coverage_all_inter_rows_all_year", false) != true

coverage_or_volunteer_cereal_shortfall(p) if cereal_share_exceeded(p)

cereal_share_exceeded(p) if {
	share := object.get(greening(p), "max_cereal_maize_share_percent", null)
	share != null
	share > params.max_cereal_maize_share_percent
	object.get(greening(p), "cereal_is_oat_or_spring_barley_nurse_crop", false) != true
}

# --- Ganzjährige, flächendeckende Begrünung ------------------------------------------

obligation_violations contains {
	"parcel_id": p.parcel_id,
	"rule_id": "O610-GREEN-ALLYEAR-FULL",
	"reason": "Keine ganzjährige, flächendeckende Begrünung in allen Fahrgassen",
} if {
	some p in greening_parcels
	object.get(greening(p), "full_coverage_all_inter_rows_all_year", false) != true
	not drought_2026_relief(p)
}

obligation_violations contains {
	"parcel_id": p.parcel_id,
	"rule_id": "O610-GREEN-ESTABLISHMENT",
	"reason": "Weder Einsaat einer Begrünungsmischung noch Belassen einer bestehenden Begrünung",
} if {
	some p in greening_parcels
	not object.get(greening(p), "establishment_method", "none") in {"sown_mixture", "existing_greening_retained"}
}

obligation_violations contains {
	"parcel_id": p.parcel_id,
	"rule_id": "O610-GREEN-ESTABLISHMENT",
	"reason": sprintf("Einsaat mit nur %v winterharten Mischungspartnern (mindestens 3)", [n]),
} if {
	some p in greening_parcels
	object.get(greening(p), "establishment_method", "none") == "sown_mixture"
	n := object.get(greening(p), "winter_hardy_mixture_partners", 0)
	n < params.min_winter_hardy_mixture_partners
}

# --- Unzulässige Begrünungskulturen ---------------------------------------------------

invalid_cover_rule := {
	"organic_mulch": "O610-GREEN-INVALID-MULCH",
	"self_greening": "O610-GREEN-INVALID-SELF",
	"none": "O610-GREEN-ALLYEAR-FULL",
}

obligation_violations contains {
	"parcel_id": p.parcel_id,
	"rule_id": invalid_cover_rule[t.cover_type],
	"reason": sprintf("Unzulässige Bodenbedeckung: %s", [t.label]),
} if {
	some p in greening_parcels
	some t in defs.invalid_greening_cover_types
	object.get(greening(p), "cover_type", "living_greening") == t.cover_type
}

obligation_violations contains {
	"parcel_id": p.parcel_id,
	"rule_id": "O610-GREEN-INVALID-CEREAL-MAIZE",
	"reason": "Einsaat von Getreide (ausgenommen Grünschnittroggensorten) oder Mais ist keine gültige Begrünungskultur",
} if {
	some p in greening_parcels
	object.get(greening(p), "contains_pure_cereal_or_maize", false) == true
	object.get(greening(p), "is_green_cut_rye_variety", false) != true
}

obligation_violations contains {
	"parcel_id": p.parcel_id,
	"rule_id": "O610-GREEN-CEREAL-SHARE-50",
	"reason": "Anteil Getreide bzw. Mais im Bestand über 50 %",
} if {
	some p in greening_parcels
	cereal_share_exceeded(p)
	not drought_2026_relief(p)
}

# --- Offenhalten des Stammbereichs / 60 %-Regel ----------------------------------------

open_strip_max_cm(p) := defs.greening_open_strip_max_cm[effective_crop_type(p)]

open_strip_exceeded(p) if {
	w := object.get(greening(p), "open_strip_width_cm", null)
	w != null
	w > open_strip_max_cm(p)
}

single_row_system(p) if object.get(p, ["permanent_crop", "planting_system"], "single_row") == "single_row"

obligation_violations contains {
	"parcel_id": p.parcel_id,
	"rule_id": "O610-GREEN-OPEN-STRIP",
	"reason": sprintf("Offengehaltener Bereich um die Stämme breiter als %v cm", [open_strip_max_cm(p)]),
} if {
	some p in greening_parcels
	single_row_system(p)
	open_strip_exceeded(p)
}

obligation_violations contains {
	"parcel_id": p.parcel_id,
	"rule_id": "O610-GREEN-60PCT-ALT-SYSTEMS",
	"reason": "Abweichendes Pflanzsystem: weniger als 60 % der Gesamtfläche begrünt",
} if {
	some p in greening_parcels
	not single_row_system(p)
	open_strip_exceeded(p)
	object.get(greening(p), "greened_share_of_total_area_percent", 0) < params.alternative_planting_min_greened_share_percent
}

# --- Bodenbearbeitung, Erneuerung, Neuanlage -------------------------------------------

events(p) := object.get(greening(p), "events", [])

destructive_event(e) if e.event_type in {"break", "clearing"}

destructive_event(e) if {
	e.event_type == "other_tillage"
	object.get(e, "destroys_greening", true) == true
}

renewal_event(e) if e.event_type == "break"

renewal_event(e) if {
	e.event_type == "other_tillage"
	object.get(e, "destroys_greening", true) == true
}

# Anker des Neuanlagefensters: bei Rodung ggf. die nachfolgende Neuauspflanzung (Annahme A-06)
window_anchor(p, e) := max([date_ns(r.date) |
	some r in events(p)
	r.event_type == "replanting"
	date_ns(r.date) >= date_ns(e.date)
]) if {
	e.event_type == "clearing"
	count([1 |
		some r in events(p)
		r.event_type == "replanting"
		date_ns(r.date) >= date_ns(e.date)
	]) > 0
}

else := date_ns(e.date)

late_clearing(e) if {
	e.event_type == "clearing"
	date_ns(e.date) > md_ns(year_of(e.date), params.late_clearing_after_month_day)
}

# Rodung nach dem 15.09.: Fläche darf bis 15.05. des Folgejahres unbegrünt bleiben
late_clearing_deadline_ns(e) := md_ns(year_of(e.date) + 1, params.late_clearing_ungreened_until_month_day)

# Sonst: innerhalb von 8 Wochen, jedoch spätestens bis 01.10.
regular_deadline_ns(p, e) := min_num(
	window_anchor(p, e) + (params.reestablishment_max_days_after_break * nanos_per_day),
	md_ns(year_of(e.date), params.reestablishment_latest_month_day),
)

establishment_between(p, from_ns, to_ns) if {
	some r in events(p)
	r.event_type == "establishment"
	date_ns(r.date) >= from_ns
	date_ns(r.date) <= to_ns
}

reestablished(p, e) if {
	late_clearing(e)
	establishment_between(p, date_ns(e.date), late_clearing_deadline_ns(e))
}

reestablished(p, e) if {
	not late_clearing(e)
	establishment_between(p, date_ns(e.date), regular_deadline_ns(p, e))
}

# Neuanlage bis 15.05. des Folgejahres liegt ggf. außerhalb der Jahresaufzeichnungen:
# nur prüfen, wenn Folgejahr-Ereignisse vorliegen oder die Frist im Auswertungsjahr endet (Annahme A-07)
late_clearing_pending(p, e) if {
	late_clearing(e)
	count([r |
		some r in events(p)
		year_of(r.date) > year_of(e.date)
	]) == 0
}

obligation_violations contains {
	"parcel_id": p.parcel_id,
	"rule_id": rule_id,
	"reason": sprintf("Keine fristgerechte Neuanlage der Begrünung nach '%s' am %s", [e.event_type, e.date]),
} if {
	some p in greening_parcels
	some e in events(p)
	destructive_event(e)
	not reestablished(p, e)
	not late_clearing_pending(p, e)
	rule_id := tillage_rule_id(e)
}

# Offene Frist nach später Rodung (Neuanlage bis 15.05. des Folgejahres)
pending_reestablishments contains {
	"parcel_id": p.parcel_id,
	"rule_id": "O610-TILLAGE-LATE-CLEARING",
	"deadline": sprintf("%d-%s", [year_of(e.date) + 1, params.late_clearing_ungreened_until_month_day]),
} if {
	some p in greening_parcels
	some e in events(p)
	late_clearing_pending(p, e)
	not reestablished(p, e)
}

tillage_rule_id(e) := "O610-TILLAGE-LATE-CLEARING" if late_clearing(e)

else := "O610-TILLAGE-REESTABLISH-8W"

obligation_violations contains {
	"parcel_id": p.parcel_id,
	"rule_id": "O610-TILLAGE-RENEWAL-ONCE",
	"reason": sprintf("%d Erneuerungen der Begrünung im Jahr %d (zulässig: einmal im Jahr)", [n, year]),
} if {
	some p in greening_parcels
	n := count([e |
		some e in events(p)
		renewal_event(e)
		year_of(e.date) == year
	])
	n > params.max_renewals_per_year
}

# --- Nutzungsverbot, Beweidung ---------------------------------------------------------

obligation_violations contains {
	"parcel_id": p.parcel_id,
	"rule_id": "O610-USE-BAN",
	"reason": "Nutzung des Begrünungsaufwuchses bzw. Abtransport des Mähguts",
} if {
	some p in greening_parcels
	object.get(greening(p), "growth_used_or_removed", false) == true
}

obligation_violations contains {
	"parcel_id": p.parcel_id,
	"rule_id": "O610-USE-GRAZING-EXC",
	"reason": sprintf("Unzulässige Beweidung: %s", [g.label]),
} if {
	some p in greening_parcels
	some g in defs.grazing_types
	g.grazing == object.get(greening(p), "grazing", "none")
	g.allowed == false
}

# --- Pflanzenschutz auf der Begrünung ---------------------------------------------------

obligation_violations contains {
	"parcel_id": p.parcel_id,
	"rule_id": "O610-PSM-BAN-GREENING",
	"reason": "Pflanzenschutzmitteleinsatz auf der Begrünung der Fahrgassen",
} if {
	some p in greening_parcels
	object.get(greening(p), "psm_applied_on_greening", false) == true
}

obligation_violations contains {
	"parcel_id": p.parcel_id,
	"rule_id": "O610-REMOVAL-MECHANICAL",
	"reason": sprintf("Beseitigung der Begrünung nicht mechanisch: %s", [m.label]),
} if {
	some p in greening_parcels
	some m in defs.greening_removal_methods
	m.method == object.get(greening(p), "removal_method", "none")
	m.allowed == false
}

# --- Kennzeichnungspflichten (Code OP) --------------------------------------------------

obligation_violations contains {
	"parcel_id": p.parcel_id,
	"rule_id": "O610-FRUIT-GRAFTED",
	"reason": "Unveredelte Obstbäume sind mit dem Code OP zu beantragen",
} if {
	some p in vfh_parcels
	effective_crop_type(p) == "fruit"
	object.get(p, ["permanent_crop", "is_grafted_planting_material"], null) == false
	not params.op_code in parcel_codes(p)
}

obligation_violations contains {
	"parcel_id": p.parcel_id,
	"rule_id": "O610-GEN-TRANSFER-MIDYEAR",
	"reason": "Weitergegebene Fläche ohne Weiterführung durch Übernehmer ist mit Code OP bzw. maßnahmenbezogenem OP-Code zu versehen",
} if {
	some p in vfh_parcels
	object.get(p, ["transfer", "transferred_during_year"], false) == true
	object.get(p, ["transfer", "successor_continues_until_year_end"], false) != true
	not params.op_code in parcel_codes(p)
	not params.measure_code in {m | some m in object.get(p, "op_excluded_measures", [])}
}

# --- Aufzeichnungen (O610-REC-GREENING) --------------------------------------------------

greening_record_items := {i | some i in object.get(input, ["documentation", "o6_10_greening_record_items"], [])}

missing_greening_record_items contains r.item if {
	count(vfh_parcels) > 0
	some r in data.o6_10.record_requirements.greening_records
	not r.item in greening_record_items
}

farm_obligation_violations contains {
	"rule_id": "O610-REC-GREENING",
	"reason": sprintf("Aufzeichnungen zur Begrünung unvollständig, es fehlen: %v", [sort(missing_greening_record_items)]),
} if {
	count(missing_greening_record_items) > 0
}
