# Betriebliche Optionen und flächenbezogene Zuschläge: Landschaftselemente, Streuobst,
# Mehrnutzenhecken, Bio-Bienenhaltung, Naturschutz-Monitoring, Transaktionskosten,
# seltene Kulturpflanzen, Wildkräuter- und Brutflächen, Pheromonfallen (Kap. 7, 8.5, 8.8, 8.9, 10).
package oepul.o6_1b

# --- 7.1 / 7.2 Punktförmige Landschaftselemente und Streuobstbäume ----------------------

lse_cfg := general.lse

point_elements := object.get(input, ["land", "point_landscape_elements"], [])

lse_eligible(e) if {
	object.get(e, "distance_to_farmland_m", 0) <= lse_cfg.max_distance_to_farmland_m
	object.get(e, "crown_diameter_m", 0) >= lse_cfg.min_crown_diameter_m
	object.get(e, "area_m2", 0) <= lse_cfg.max_area_m2
	object.get(e, "min_distance_to_other_element_m", 0) >= lse_cfg.min_spacing_m
	object.get(e, "in_control", true) == true
	object.get(e, "on_alm_or_hutweide", false) == false
	object.get(e, "is_gloez_element", false) == false
	object.get(e, "retained_full_year", true) == true
	object.get(e, "applied_as", "LSE Bäume/Büsche") == "LSE Bäume/Büsche"
}

streuobst_species_allowed(sp) if {
	some s in lists.streuobst_species
	s.species == sp
	s.from_year <= year
}

streuobst_eligible(e) if {
	lse_eligible(e)
	"SO" in object.get(e, "oepul_codes", [])
	streuobst_species_allowed(object.get(e, "fruit_species", ""))
	object.get(e, "stem_form", "") in lists.streuobst_stem_forms
	object.get(e, "has_permanent_support_frame", false) == false
	streuobst_form_ok(e)
}

streuobst_form_ok(e) if object.get(e, "is_wild_form", false) == false

streuobst_form_ok(e) if {
	object.get(e, "is_wild_form", false) == true
	e.fruit_species in lists.streuobst_wild_forms_allowed
}

lse_kind(e) := "streuobst" if streuobst_eligible(e)

lse_kind(e) := "other" if {
	lse_eligible(e)
	not streuobst_eligible(e)
}

field_piece_area(fp_id) := fp.area_ha if {
	some fp in field_pieces
	fp.field_piece_id == fp_id
}

lse_cap(fp_id) := floor(caps.lse_max_per_ha_field_piece * field_piece_area(fp_id))

lse_count(fp_id, kind) := count([e | some e in point_elements; object.get(e, "field_piece_id", "") == fp_id; lse_kind(e) == kind])

lse_field_piece_ids := {object.get(e, "field_piece_id", "") | some e in point_elements}

# Streuobstbäume werden bei Überschreitung der 80 Elemente/ha vorrangig berücksichtigt (Annahme A-07)
lse_paid_streuobst(fp_id) := min2(lse_count(fp_id, "streuobst"), lse_cap(fp_id))

lse_paid_other(fp_id) := min2(lse_count(fp_id, "other"), clamp0(lse_cap(fp_id) - lse_paid_streuobst(fp_id)))

lse_paid(fp_id, "streuobst") := lse_paid_streuobst(fp_id)

lse_paid(fp_id, "other") := lse_paid_other(fp_id)

lse_paid_total(kind) := sum([lse_paid(fp, kind) | some fp in lse_field_piece_ids])

violations contains {"rule_id": "O61B-LE-001", "message": sprintf("Punktförmiges Landschaftselement %s erfüllt die Definition nicht", [e.element_id])} if {
	some e in point_elements
	not lse_eligible(e)
	object.get(e, "is_gloez_element", false) == false
}

violations contains {"rule_id": "O61B-SO-001", "message": sprintf("Streuobstbaum %s (Code SO) erfüllt die Förderkriterien nicht", [e.element_id])} if {
	some e in point_elements
	"SO" in object.get(e, "oepul_codes", [])
	not streuobst_eligible(e)
}

# --- 7.3 Mehrnutzenhecken ----------------------------------------------------------------------

hedge_cfg := general.hedge

hedge_eligible(h) if {
	h.planted_date >= hedge_cfg.planted_from
	h.planted_date <= sprintf("%d-%s", [year, hedge_cfg.planted_until_month_day])
	object.get(h, "avg_width_m", 0) >= hedge_cfg.min_avg_width_m
	object.get(h, "avg_width_m", 0) <= hedge_cfg.max_avg_width_m
	object.get(h, "herbaceous_share_percent", 0) >= hedge_cfg.min_herbaceous_share_percent
	object.get(h, "adjoins_own_arable_field_piece", false) == true
	object.get(h, "long_side_adjoins_forest_or_flat_lse", false) == false
	object.get(h, "state_concept", false) == true
	object.get(h, "confirmed_by_state_in_gis", false) == true
	object.get(h, "fertilizer_or_psm_used", false) == false
	object.get(h, "herbaceous_area_used", false) == false
	object.get(h, "mostly_shrubs_and_fruit_trees", true) == true
}

violations contains {"rule_id": "O61B-MH-002", "message": sprintf("Mehrnutzenhecke %s erfüllt die Förderverpflichtungen nicht", [h.hedge_id])} if {
	some h in hedges
	not hedge_eligible(h)
}

hedge_area_paid_ha := sum([h.area_ha | some h in hedges; hedge_eligible(h)])

# --- 7.4 Bio-Bienenhaltung ----------------------------------------------------------------------

beekeeping := object.get(o6_1b_input, "beekeeping", {})

bee_hives_eligible := min2(object.get(beekeeping, "economic_colony_hives", 0), caps.bee_hives_max_per_farm) if {
	object.get(beekeeping, "organic_control", false) == true
	object.get(beekeeping, "declared_in_mfa", false) == true
	object.get(beekeeping, "sector_programme_organic_feed_or_wax_compensated", false) == false
}

bee_hives_eligible := 0 if not bee_premium_conditions

bee_premium_conditions if {
	object.get(beekeeping, "organic_control", false) == true
	object.get(beekeeping, "declared_in_mfa", false) == true
	object.get(beekeeping, "sector_programme_organic_feed_or_wax_compensated", false) == false
}

# --- 7.5 Naturschutz-Monitoring -------------------------------------------------------------------

monitoring := object.get(o6_1b_input, "monitoring", [])

farm_nat_auflagen := {a | some p in parcels; some a in nat_auflagen(p)} | {a | some a in object.get(o6_1b_input, "nat_auflagen_farm", [])}

monitoring_programme(id) := m if {
	some m in lists.monitoring_programmes
	m.id == id
}

monitoring_combination_ok(prog) if prog.requires_measure == null

monitoring_combination_ok(prog) if {
	prog.requires_measure != null
	prog.requires_measure in participating_measures
	count(farm_nat_auflagen & {a | some a in prog.requires_any_auflage}) > 0
}

monitoring_eligible(m) if {
	prog := monitoring_programme(m.programme)
	monitoring_combination_ok(prog)
	object.get(m, "participation_confirmation", false) == true
	object.get(m, "data_complete", false) == true
	object.get(m, "applied_in_measure_application", false) == true
	intro_ok(m)
}

intro_ok(m) if object.get(m, "first_year", false) == false

intro_ok(m) if {
	object.get(m, "first_year", false) == true
	object.get(m, "intro_event_completed", false) == true
}

violations contains {"rule_id": "O61B-MO-002", "message": sprintf("Monitoringprogramm %s ohne erforderliche Kombination mit Naturschutz-Auflage", [m.programme])} if {
	some m in monitoring
	prog := monitoring_programme(m.programme)
	not monitoring_combination_ok(prog)
}

violations contains {"rule_id": "O61B-MO-001", "message": sprintf("Monitoringprogramm %s: Teilnahmebestätigung, Einführungsveranstaltung oder Datenerfassung fehlt", [m.programme])} if {
	some m in monitoring
	prog := monitoring_programme(m.programme)
	monitoring_combination_ok(prog)
	not monitoring_eligible(m)
}

violations contains {"rule_id": "O61B-VZ-004", "message": "Einstieg in Naturschutz-Monitoring nach dem Förderjahr 2028 nicht möglich"} if {
	some m in monitoring
	object.get(m, "first_year", false) == true
	year > general.deadlines.monitoring_last_entry_year
}

# --- 8.5 Seltene, regional wertvolle landwirtschaftliche Kulturpflanzen (SLK) --------------------

variety_row(name) := v if {
	some v in data.o6_1b.rare_varieties.varieties
	v.variety == name
	v.valid_from_year <= year
}

slk_variety_pure(p) if object.get(p, ["crop", "is_variety_pure"], false) == true

slk_variety_pure(p) if object.get(p, ["crop", "poppy_strip_cultivation"], false) == true

slk_first_use_year(p) if object.get(p, ["crop", "multi_year"], false) == false

slk_first_use_year(p) if {
	object.get(p, ["crop", "multi_year"], false) == true
	object.get(p, ["crop", "first_year_of_use"], false) == true
}

slk_eligible(p) if {
	is_arable(p)
	has_code(p, "SLK")
	_ := variety_row(object.get(p, ["crop", "variety"], ""))
	slk_variety_pure(p)
	slk_first_use_year(p)
	object.get(p, ["crop", "seed_documented"], false) == true
}

violations contains {"rule_id": "O61B-ZA-004", "message": sprintf("SLK-Schlag %s: Sorte nicht in der Sortenliste, nicht sortenrein, nicht dokumentiert oder nicht im ersten Nutzungsjahr", [p.parcel_id])} if {
	some p in parcels
	has_code(p, "SLK")
	not slk_eligible(p)
}

# --- 8.8 Wildkräuter- und Brutflächen (WB) -------------------------------------------------------

wb_cfg := general.wildkraeuter

wb_ban_end(p) := d if {
	th := [e.date | some e in use_events(p); e.type == "thresh"; date_year(e.date) == year]
	count(th) > 0
	d := min2(min(th), sprintf("%d-%s", [year, wb_cfg.ban_end]))
}

wb_ban_end(p) := sprintf("%d-%s", [year, wb_cfg.ban_end]) if {
	count([e | some e in use_events(p); e.type == "thresh"; date_year(e.date) == year]) == 0
}

wb_in_ban(p, d) if {
	d >= sprintf("%d-%s", [year, wb_cfg.ban_start])
	d < wb_ban_end(p)
}

wb_forbidden_activity(p) if {
	some f in fertilizer_applications(p)
	wb_in_ban(p, f.date)
}

wb_forbidden_activity(p) if {
	some v in object.get(p, ["operations", "driving_events"], [])
	object.get(v, "crossing_only", false) == false
	wb_in_ban(p, v.date)
}

wb_forbidden_activity(p) if {
	some d in object.get(p, ["operations", "psm_application_dates"], [])
	wb_in_ban(p, d)
}

wb_forbidden_activity(p) if {
	some d in object.get(p, ["operations", "mechanical_weeding_dates"], [])
	wb_in_ban(p, d)
}

# Bis 30.6. ist als Ernte nur der Drusch erlaubt
wb_forbidden_activity(p) if {
	some e in use_events(p)
	e.type in {"harvest", "mow", "chop", "graze"}
	date_year(e.date) == year
	md(e.date) <= wb_cfg.ban_end
}

wb_sowing_ok(p) if object.get(p, ["crop", "summer_cereal"], false) == false

wb_sowing_ok(p) if {
	object.get(p, ["crop", "summer_cereal"], false) == true
	md(object.get(p, ["operations", "sowing_date"], "0000-12-31")) < wb_cfg.summer_cereal_sow_before
}

wb_eligible(p) if {
	is_arable(p)
	has_code(p, "WB")
	is_cereal(p)
	object.get(p, ["operations", "row_spacing_cm"], 0) >= wb_cfg.min_row_spacing_cm
	object.get(p, ["operations", "undersown"], false) == false
	wb_sowing_ok(p)
	not wb_forbidden_activity(p)
}

violations contains {"rule_id": "O61B-ZA-012", "message": sprintf("Wildkräuter- und Brutfläche %s erfüllt die Förderbedingungen nicht", [p.parcel_id])} if {
	some p in parcels
	has_code(p, "WB")
	not wb_eligible(p)
}

# --- 8.9 Pheromonfallen bei Zuckerrüben (PZR) -----------------------------------------------------

pzr_cfg := general.pheromone

pzr_land_use_ok(p) if land_use_type(p) in lists.pheromone_land_use_types

pzr_land_use_ok(p) if object.get(p, ["operations", "sugar_beet_previous_year"], false) == true

traps(p) := object.get(p, ["operations", "pheromone_traps"], {})

pzr_eligible(p) if {
	year >= 2025
	is_arable(p)
	has_code(p, "PZR")
	pzr_land_use_ok(p)
	t := traps(p)
	object.get(t, "traps_per_ha", 0) >= pzr_cfg.min_traps_per_ha
	object.get(t, "installed_within_days_after_sowing", 999) <= pzr_cfg.install_within_days_after_sowing
	object.get(t, "days_in_field", 0) >= pzr_cfg.min_days_in_field
	object.get(t, "emptying_count", 0) >= pzr_cfg.min_emptyings
	object.get(t, "removed_before_harvest", false) == true
	object.get(t, "records_complete", false) == true
	object.get(t, "pheromone_receipts_kept", false) == true
}

violations contains {"rule_id": "O61B-ZA-013", "message": sprintf("Pheromonfallen-Schlag %s (Code PZR) erfüllt die Förderbedingungen nicht", [p.parcel_id])} if {
	some p in parcels
	has_code(p, "PZR")
	not pzr_eligible(p)
}
