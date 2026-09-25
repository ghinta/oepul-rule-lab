# Biodiversitätsflächen auf Grünlandflächen (Kap. 6.2, 9.1-9.5, 10; SRL 2.1 B Anlage von
# Biodiversitätsflächen auf Grünland lit. a-d).
package oepul.o6_1b

gl_div_cfg := general.grassland_div

grassland_div_code(p) := c if {
	some c in lists.grassland_div_variant_codes
	has_code(p, c)
}

is_grassland_div(p) if {
	is_grassland(p)
	count(codes(p) & {c | some c in lists.grassland_div_variant_codes}) > 0
}

gl_div_from_other_measure(p) if count(codes(p) & {c | some c in lists.grassland_div_other_measure_codes}) > 0

# Anrechenbarkeit (Kap. 6.2.3)
grassland_div_creditable(p) if {
	is_grassland_div(p)
	not is_bergmaehder(p)
	not gl_div_from_other_measure(p)
}

grassland_div_creditable(p) if {
	is_grassland_div(p)
	has_code(p, "NAT")
	count(nat_auflagen(p) & {a | some a in lists.grassland_div_nat_creditable_auflagen}) > 0
}

grassland_div_creditable(p) if {
	is_grassland_div(p)
	has_code(p, "EBW")
	not is_bergmaehder(p)
	object.get(div_info(p), "ebw_habitat_creditable", false) == true
	not land_use_type(p) in {"Hutweide", "Dauerweide", "Bergmähder"}
}

grassland_div_creditable(p) if {
	is_grassland_div(p)
	has_code(p, "N2")
	count(nat_auflagen(p) & {a | some a in lists.grassland_div_n2_creditable_auflagen}) > 0
}

grassland_div_credit_ha := sum([area(p) | some p in parcels; grassland_div_creditable(p)])

grassland_div_pure(p) if {
	is_grassland_div(p)
	not gl_div_from_other_measure(p)
	not div_gloez4(p)
	not is_bergmaehder(p)
}

grassland_div_pure_ha := sum([area(p) | some p in parcels; grassland_div_pure(p)])

grassland_div_obligation_applies if mown_grassland_area_ha > gl_div_cfg.threshold_ha_exclusive

grassland_div_required_ha := gl_div_cfg.min_share * mown_grassland_area_ha if grassland_div_obligation_applies

grassland_div_required_ha := 0 if not grassland_div_obligation_applies

violations contains {"rule_id": "O61B-DG-001", "message": sprintf("Grünland-Biodiversitätsflächen %v ha unter erforderlichen 7 %% der gemähten Grünlandfläche (%v ha)", [round2(grassland_div_credit_ha), round2(grassland_div_required_ha)])} if {
	grassland_div_obligation_applies
	grassland_div_credit_ha < grassland_div_required_ha
}

# --- Feldstücksbezogene Anlageverpflichtung (Kap. 6.2.2) ---------------------------------

gl_field_piece_div_ha(fp_id) := sum([area(p) | some p in parcels; object.get(p, "field_piece_id", "") == fp_id; is_grassland_div(p)])

violations contains {"rule_id": "O61B-DG-003", "message": sprintf("Grünland-Feldstück %s (> 5 ha gemäht) mit weniger als 0,15 ha Biodiversitätsflächen", [fp.field_piece_id])} if {
	mown_grassland_area_ha >= gl_div_cfg.field_piece_rule_min_farm_mown_ha
	some fp in field_pieces
	fp.land_use == "grassland"
	object.get(fp, "mown_area_ha", 0) > gl_div_cfg.field_piece_threshold_ha_exclusive
	gl_field_piece_div_ha(fp.field_piece_id) + object.get(fp, "gloez_lse_area_ha", 0) < gl_div_cfg.field_piece_min_ha
}

# --- Beantragung (Kap. 10, 6.2.4) --------------------------------------------------------------

violations contains {"rule_id": "O61B-AN-005", "message": sprintf("Grünland-Biodiversitätsfläche %s mit unzulässiger Schlagnutzungsart %s", [p.parcel_id, land_use_type(p)])} if {
	some p in parcels
	is_grassland_div(p)
	not gl_div_from_other_measure(p)
	not land_use_type(p) in lists.grassland_div_land_use_types
}

violations contains {"rule_id": "O61B-AN-005", "message": sprintf("Aus NAT/EBW/N2 angerechnete Grünland-Biodiversitätsfläche %s ist mit DIVSZ zu kennzeichnen", [p.parcel_id])} if {
	some p in parcels
	is_grassland_div(p)
	gl_div_from_other_measure(p)
	not has_code(p, "DIVSZ")
}

violations contains {"rule_id": "O61B-DG-006", "message": sprintf("Grünland-Biodiversitätsfläche %s mit mehr als einem Varianten-Code", [p.parcel_id])} if {
	some p in parcels
	is_grassland(p)
	count(codes(p) & {c | some c in lists.grassland_div_variant_codes}) > 1
}

# Jede Variante: mindestens eine Mahd mit Verbringung des Mähgutes im Jahr (Kap. 6.2.4)
gl_mowings_with_removal(p) := [e |
	some e in use_events(p)
	e.type == "mow"
	object.get(e, "removed", false) == true
	date_year(e.date) == year
]

gl_uses(p) := [e | some e in use_events(p); e.type in {"mow", "graze"}; date_year(e.date) == year; not gl_uncounted_cleaning_cut(p, e)]

gl_uncounted_cleaning_cut(p, e) if {
	object.get(e, "cleaning_cut", false) == true
	object.get(e, "removed", false) == false
	first_declared_year(p) == year
}

gl_year_complete(p) if object.get(div_info(p), "year_complete", false) == true

gl_rules_apply(p) if {
	is_grassland_div(p)
	not gl_div_from_other_measure(p)
}

violations contains {"rule_id": "O61B-DG-006", "message": sprintf("Grünland-Biodiversitätsfläche %s ohne Mahd mit Verbringung des Mähgutes im Jahr", [p.parcel_id])} if {
	some p in parcels
	gl_rules_apply(p)
	gl_year_complete(p)
	count(gl_mowings_with_removal(p)) == 0
}

sorted_gl_uses(p) := sort([e.date | some e in gl_uses(p)])

first_use_date(p) := sorted_gl_uses(p)[0] if count(sorted_gl_uses(p)) > 0

# --- DIVSZ (Kap. 6.2.4.1) -------------------------------------------------------------------------

phenology_shift_days(p) := min2(object.get(div_info(p), "phenology_shift_days", 0), gl_div_cfg.divsz.max_phenology_shift_days)

divsz_earliest(p) := add_days(sprintf("%d-%s", [year, gl_div_cfg.divsz.earliest]), (0 - phenology_shift_days(p)) - drought_advance_days(p))

divsz_in_any_case(p) := add_days(sprintf("%d-%s", [year, gl_div_cfg.divsz.in_any_case]), (0 - phenology_shift_days(p)) - drought_advance_days(p))

is_one_cut_meadow(p) if land_use_type(p) == "Einmähdige Wiese"

# Frühester zulässiger Nutzungstermin: 2. Mahd vergleichbarer Schläge, frühestens 15.6.,
# jedenfalls ab 15.7. (bei einmähdigen Wiesen nur 15.6.)
divsz_allowed_from(p) := divsz_earliest(p) if is_one_cut_meadow(p)

divsz_allowed_from(p) := d if {
	not is_one_cut_meadow(p)
	cmp := object.get(div_info(p), "comparable_second_cut_date", null)
	cmp != null
	d := min2(max2(cmp, divsz_earliest(p)), divsz_in_any_case(p))
}

divsz_allowed_from(p) := divsz_in_any_case(p) if {
	not is_one_cut_meadow(p)
	object.get(div_info(p), "comparable_second_cut_date", null) == null
}

violations contains {"rule_id": "O61B-DG-007", "message": sprintf("DIVSZ-Fläche %s: erste Nutzung am %s vor dem zulässigen Termin %s", [p.parcel_id, first_use_date(p), divsz_allowed_from(p)])} if {
	some p in parcels
	gl_rules_apply(p)
	has_code(p, "DIVSZ")
	first_use_date(p) < divsz_allowed_from(p)
}

violations contains {"rule_id": "O61B-DG-010", "message": sprintf("DIVSZ-Fläche %s: Düngung vor der ersten Nutzung", [p.parcel_id])} if {
	some p in parcels
	gl_rules_apply(p)
	has_code(p, "DIVSZ")
	some f in fertilizer_applications(p)
	date_year(f.date) == year
	fertilized_before_first_use(p, f)
}

fertilized_before_first_use(p, f) if f.date < first_use_date(p)

fertilized_before_first_use(p, _) if count(sorted_gl_uses(p)) == 0

violations contains {"rule_id": "O61B-DG-010", "message": sprintf("DIVSZ-Fläche %s: Häckseln vor der ersten Nutzung", [p.parcel_id])} if {
	some p in parcels
	gl_rules_apply(p)
	has_code(p, "DIVSZ")
	some e in use_events(p)
	e.type == "chop"
	date_year(e.date) == year
	chop_before_first_use(p, e)
}

chop_before_first_use(p, e) if e.date < first_use_date(p)

chop_before_first_use(p, _) if count(sorted_gl_uses(p)) == 0

# --- DIVNFZ (Kap. 6.2.4.2) -----------------------------------------------------------------------

divnfz_rest_days(p) := data.o6_1b.notices_2026.early_use_2026.divnfz_reduced_rest_days if drought_2026_opt_out(p)

divnfz_rest_days(p) := gl_div_cfg.divnfz.min_rest_days if not drought_2026_opt_out(p)

# Beginn des nutzungsfreien Zeitraums: Tag nach letzter Überfahrt/Ballenabtransport bzw.
# nach Weidepflege im Anschluss an den letzten Weidegang.
divnfz_period_start(p) := d if {
	d := object.get(div_info(p), "first_use_completed_date", null)
	d != null
}

divnfz_period_start(p) := first_use_date(p) if object.get(div_info(p), "first_use_completed_date", null) == null

divnfz_first_allowed_date(p) := add_days(divnfz_period_start(p), divnfz_rest_days(p) + 1)

violations contains {"rule_id": "O61B-DG-011", "message": sprintf("DIVNFZ-Fläche %s: Nutzung/Befahren/Düngung am %s innerhalb des nutzungsfreien Zeitraums", [p.parcel_id, d])} if {
	some p in parcels
	gl_rules_apply(p)
	has_code(p, "DIVNFZ")
	some d in divnfz_activity_dates(p)
	d > divnfz_period_start(p)
	d < divnfz_first_allowed_date(p)
}

divnfz_activity_dates(p) := ({d |
	some e in use_events(p)
	e.type in {"mow", "graze", "chop", "mulch"}
	date_year(e.date) == year
	d := e.date
} | {d |
	some f in fertilizer_applications(p)
	date_year(f.date) == year
	d := f.date
}) | {d |
	some v in object.get(p, ["operations", "driving_events"], [])
	object.get(v, "crossing_only", false) == false
	date_year(v.date) == year
	d := v.date
}

violations contains {"rule_id": "O61B-DG-011", "message": sprintf("DIVNFZ-Fläche %s: Häckseln des Aufwuchses nicht erlaubt", [p.parcel_id])} if {
	some p in parcels
	gl_rules_apply(p)
	has_code(p, "DIVNFZ")
	some e in use_events(p)
	e.type == "chop"
	date_year(e.date) == year
}

violations contains {"rule_id": "O61B-DG-013", "message": sprintf("DIVNFZ-Fläche %s: keine zweite Nutzung im Kalenderjahr", [p.parcel_id])} if {
	some p in parcels
	gl_rules_apply(p)
	has_code(p, "DIVNFZ")
	gl_year_complete(p)
	count(gl_uses(p)) < 2
}

# --- DIVAGF (Kap. 6.2.4.3) -----------------------------------------------------------------------

violations contains {"rule_id": "O61B-DG-015", "message": sprintf("DIVAGF-Fläche %s: Nutzung, Befahren oder Düngung nach dem 15. August", [p.parcel_id])} if {
	some p in parcels
	gl_rules_apply(p)
	has_code(p, "DIVAGF")
	some d in divnfz_activity_dates(p)
	md(d) > gl_div_cfg.divagf.last_use
}

violations contains {"rule_id": "O61B-DG-016", "message": sprintf("Altgrasfläche %s des Vorjahres ist im Folgejahr lagegenau als DIVSZ zu beantragen", [p.parcel_id])} if {
	some p in parcels
	is_grassland(p)
	object.get(div_info(p), "previous_year_code", "") == "DIVAGF"
	object.get(div_info(p), "loss_of_control", false) == false
	not has_code(p, "DIVSZ")
}

# --- DIVRS Grünland (Kap. 6.2.4.4) ------------------------------------------------------------

is_grassland_divrs(p) if {
	is_grassland_div(p)
	has_code(p, "DIVRS")
}

grassland_divrs_site_ok(p) if {
	object.get(p, "gruenlandzahl", 0) >= gl_div_cfg.divrs.min_gruenlandzahl
	object.get(p, "slope_percent", 100) < gl_div_cfg.divrs.max_slope_percent_exclusive
}

grassland_divrs_seed_ok(p) if {
	grassland_divrs_site_ok(p)
	divrs_seed_ok(p)
	sowing_date_ok_divrs(p)
}

sowing_date_ok_divrs(p) if {
	sd := object.get(div_info(p), "sowing_date", null)
	sd != null
	md(sd) <= gl_div_cfg.divrs.sowing_deadline
}

sowing_date_ok_divrs(p) if {
	sd := object.get(div_info(p), "sowing_date", null)
	sd != null
	date_year(sd) < first_declared_year(p)
}

violations contains {"rule_id": "O61B-DG-018", "message": sprintf("DIVRS-Grünlandfläche %s: Standort-, Saatgut- oder Ansaatbedingungen nicht erfüllt", [p.parcel_id])} if {
	some p in parcels
	is_grassland_divrs(p)
	not grassland_divrs_seed_ok(p)
}

violations contains {"rule_id": "O61B-DG-020", "message": sprintf("DIVRS-Grünlandfläche %s: erste Nutzung vor dem 15. Juli", [p.parcel_id])} if {
	some p in parcels
	is_grassland_divrs(p)
	some e in gl_uses(p)
	not cleaning_cut_counted_as_use(p, e)
	md(e.date) < gl_div_cfg.divrs.first_use_earliest
}

# Verbrachter Reinigungsschnitt zählt als Nutzung, darf aber vor dem 15. Juli erfolgen
cleaning_cut_counted_as_use(p, e) if {
	object.get(e, "cleaning_cut", false) == true
	first_declared_year(p) == year
}

violations contains {"rule_id": "O61B-DG-020", "message": sprintf("DIVRS-Grünlandfläche %s: mehr als 2 Nutzungen bzw. Häckseln", [p.parcel_id])} if {
	some p in parcels
	is_grassland_divrs(p)
	divrs_grassland_use_violation(p)
}

divrs_grassland_use_violation(p) if count(gl_uses(p)) > gl_div_cfg.divrs.max_uses

divrs_grassland_use_violation(p) if {
	some e in use_events(p)
	e.type == "chop"
	date_year(e.date) == year
}

violations contains {"rule_id": "O61B-DG-021", "message": sprintf("DIVRS-Grünlandfläche %s: Düngung außer Festmist/Festmistkompost", [p.parcel_id])} if {
	some p in parcels
	is_grassland_divrs(p)
	some f in fertilizer_applications(p)
	date_year(f.date) == year
	not f.type in gl_div_cfg.divrs.allowed_fertilizers
}

violations contains {"rule_id": "O61B-DG-022", "message": "Grünland-DIVRS-Beantragung ohne neuerliche Einsaat nur bis längstens 2028"} if {
	some p in parcels
	is_grassland_divrs(p)
	year > general.divrs_arable.last_year_without_resowing
}
