# Biodiversitätsflächen auf Ackerflächen (Kap. 6.1, 8.1-8.4, 10; SRL 2.1 B Anlage von
# Biodiversitätsflächen auf Ackerflächen lit. a-g).
package oepul.o6_1b

arable_div_cfg := general.arable_div

is_arable_div(p) if {
	p.land_use == "arable"
	not land_use_type(p) in {"LSE Mehrnutzenhecke", "GLÖZ-Landschaftselement", "Agroforststreifen"}
	count(codes(p) & {"DIV", "DIVRS"}) > 0
}

div_from_other_measure(p) if count(codes(p) & {c | some c in lists.arable_div_other_measure_codes}) > 0

div_gloez4(p) if object.get(div_info(p), "gloez4_buffer_strip", false) == true

div_gloez8(p) if object.get(div_info(p), "gloez8_fallow", false) == true

# "reine" DIV-Fläche ohne zusätzlichen Maßnahmencode und ohne GLÖZ 4-Pufferstreifen (Kap. 8.1)
div_pure(p) if {
	is_arable_div(p)
	not div_from_other_measure(p)
	not div_gloez4(p)
}

nat_auflagen(p) := {a | some a in object.get(div_info(p), "nat_auflagen", [])}

# Anrechenbarkeit für die 7 %-Mindestanlage (Kap. 6.1.3)
arable_div_creditable(p) if {
	is_arable_div(p)
	not has_code(p, "K20")
	not div_from_other_measure(p)
	not div_gloez8(p)
}

arable_div_creditable(p) if {
	is_arable_div(p)
	not has_code(p, "K20")
	not div_from_other_measure(p)
	div_gloez8(p)
	year <= 2024
}

arable_div_creditable(p) if {
	is_arable_div(p)
	has_code(p, "NAT")
	lists.parameters.arable_div_nat_required_auflage in nat_auflagen(p)
	object.get(div_info(p), "nat_area_used", false) == false
}

arable_div_creditable(p) if {
	is_arable_div(p)
	has_code(p, "EBW")
	object.get(div_info(p), "ebw_fallow", true) == true
}

arable_div_creditable(p) if {
	is_arable_div(p)
	count(codes(p) & {"BAW", "AG"}) > 0
	object.get(div_info(p), "care_rules_6_1_4_2_met", true) == true
}

hedges := object.get(input, ["land", "multi_use_hedges"], [])

hedge_div_creditable(h) if {
	object.get(h, "div_coded", false) == true
	object.get(h, "herbaceous_care_rules_met", false) == true
}

arable_div_credit_ha := sum([area(p) | some p in parcels; arable_div_creditable(p)]) + sum([object.get(h, "area_ha", 0) | some h in hedges; hedge_div_creditable(h)])

arable_div_total_ha := sum([area(p) | some p in parcels; is_arable_div(p)])

arable_div_pure_ha := sum([area(p) | some p in parcels; div_pure(p)])

arable_div_obligation_applies if arable_area_ha > arable_div_cfg.threshold_ha_exclusive

arable_div_required_ha := arable_div_cfg.min_share * arable_area_ha if arable_div_obligation_applies

arable_div_required_ha := 0 if not arable_div_obligation_applies

# Erfüllung direkt auf Acker
arable_div_minimum_met if arable_div_credit_ha >= arable_div_required_ha

# Betriebe unter 10 ha Acker: Erfüllung auch über zusätzliche Grünland-Biodiversitätsflächen (Kap. 6.1.1)
arable_div_minimum_met if {
	arable_area_ha < arable_div_cfg.grassland_substitution_below_ha
	grassland_div_credit_ha >= grassland_div_required_ha
	arable_div_credit_ha + grassland_div_credit_ha >= arable_div_required_ha + grassland_div_required_ha
}

violations contains {"rule_id": "O61B-DA-001", "message": sprintf("Acker-Biodiversitätsflächen %v ha unter erforderlichen 7 %% (%v ha)", [round2(arable_div_credit_ha), round2(arable_div_required_ha)])} if {
	arable_div_obligation_applies
	not arable_div_minimum_met
}

# --- Feldstücksbezogene Anlageverpflichtung (Kap. 6.1.2) ---------------------------------

field_piece_div_ha(fp_id) := sum([area(p) | some p in parcels; object.get(p, "field_piece_id", "") == fp_id; field_piece_div_counts(p)])

field_piece_div_counts(p) if arable_div_creditable(p)

field_piece_div_counts(p) if {
	is_arable_div(p)
	not arable_div_creditable(p)
	div_from_other_measure(p)
}

field_piece_extra_ha(fp) := object.get(fp, "gloez_lse_area_ha", 0) + object.get(fp, "agroforest_strip_area_ha", 0) if year >= 2025

field_piece_extra_ha(fp) := object.get(fp, "gloez_lse_area_ha", 0) if year < 2025

violations contains {"rule_id": "O61B-DA-004", "message": sprintf("Acker-Feldstück %s (> 5 ha) mit weniger als 0,15 ha Biodiversitätsflächen", [fp.field_piece_id])} if {
	arable_area_ha >= arable_div_cfg.field_piece_rule_min_farm_arable_ha
	some fp in field_pieces
	fp.land_use == "arable"
	fp.area_ha > arable_div_cfg.field_piece_threshold_ha_exclusive
	field_piece_div_ha(fp.field_piece_id) + field_piece_extra_ha(fp) < arable_div_cfg.field_piece_min_ha
}

# --- Ansaat (Kap. 6.1.4.1) -----------------------------------------------------------------

# Flächen, für die alle Bewirtschaftungsauflagen gem. 6.1.4 gelten
div_full_rules_apply(p) if {
	is_arable_div(p)
	not div_from_other_measure(p)
}

seed_mixture(p) := object.get(div_info(p), "seed_mixture", {})

first_declared_year(p) := object.get(div_info(p), "first_declared_year", year)

sowing_exempt(p) if object.get(div_info(p), "sowing_exempt_existing", false) == true

is_new_sowing(p) if object.get(div_info(p), "is_new_sowing", false) == true

violations contains {"rule_id": "O61B-DA-010", "message": sprintf("Acker-Biodiversitätsfläche %s: Neuansaat einer Bienenmischung erforderlich", [p.parcel_id])} if {
	some p in parcels
	div_full_rules_apply(p)
	first_declared_year(p) == year
	not sowing_exempt(p)
	not is_new_sowing(p)
}

violations contains {"rule_id": "O61B-DA-010", "message": sprintf("Acker-Biodiversitätsfläche %s: Saatgutmischung erfüllt nicht 7 insektenblütige Partner aus 3 Familien mit max. 10 %% nicht insektenblütigen Partnern", [p.parcel_id])} if {
	some p in parcels
	div_full_rules_apply(p)
	is_new_sowing(p)
	not bee_mixture_ok(seed_mixture(p))
}

bee_mixture_ok(m) if {
	object.get(m, "insect_pollinated_partners", 0) >= arable_div_cfg.min_insect_partners
	object.get(m, "plant_families", 0) >= arable_div_cfg.min_families
	object.get(m, "non_insect_share_percent", 100) <= arable_div_cfg.max_non_insect_share_percent
}

violations contains {"rule_id": "O61B-DA-012", "message": sprintf("Acker-Biodiversitätsfläche %s: Neuansaat nach dem 15. Mai", [p.parcel_id])} if {
	some p in parcels
	div_full_rules_apply(p)
	is_new_sowing(p)
	sd := object.get(div_info(p), "sowing_date", null)
	sd != null
	date_year(sd) == year
	md(sd) > arable_div_cfg.sowing_deadline
}

# --- Umbruch / Zweijährigkeit (Kap. 6.1.4.1, 6.1.5) ------------------------------------------

earliest_break_date(p) := sprintf("%d-07-31", [first_declared_year(p) + 1]) if {
	object.get(div_info(p), "followed_by_winter_crop_or_catch_crop", false) == true
}

earliest_break_date(p) := sprintf("%d-09-15", [first_declared_year(p) + 1]) if {
	object.get(div_info(p), "followed_by_winter_crop_or_catch_crop", false) != true
}

break_before_allowed(p, bd) if {
	object.get(div_info(p), "followed_by_winter_crop_or_catch_crop", false) == true
	bd <= earliest_break_date(p)
}

break_before_allowed(p, bd) if {
	object.get(div_info(p), "followed_by_winter_crop_or_catch_crop", false) != true
	bd < earliest_break_date(p)
}

two_year_exception(p) if object.get(div_info(p), "loss_of_control", false) == true

two_year_exception(p) if object.get(div_info(p), "converted_to_grassland", false) == true

violations contains {"rule_id": "O61B-DA-012", "message": sprintf("Acker-Biodiversitätsfläche %s vor Ablauf der Zweijährigkeit umgebrochen", [p.parcel_id])} if {
	some p in parcels
	is_arable_div(p)
	bd := object.get(div_info(p), "break_date", null)
	bd != null
	break_before_allowed(p, bd)
	not two_year_exception(p)
}

violations contains {"rule_id": "O61B-DA-012", "message": sprintf("Umgebrochene Grünbrache-Biodiversitätsfläche %s vor 31.12. genutzt", [p.parcel_id])} if {
	some p in parcels
	is_arable_div(p)
	land_use_type(p) == "Grünbrache"
	bd := object.get(div_info(p), "break_date", null)
	bd != null
	some e in use_events(p)
	e.date > bd
	date_year(e.date) == date_year(bd)
	e.type in {"mow", "graze", "harvest"}
}

# --- Pflege-/Nutzungsauflagen (Kap. 6.1.4.2) -------------------------------------------------

# Reinigungsschnitt im Jahr der ersten Beantragung auf Neuansaatflächen (ab 2025) ohne Verbringung
# zählt weder zur Maximalanzahl noch zur 25 %-Grenze.
is_uncounted_cleaning_cut(p, e) if {
	object.get(e, "cleaning_cut", false) == true
	object.get(e, "removed", false) == false
	first_declared_year(p) == year
	is_new_sowing(p)
	year >= 2025
}

# Häckseln / Pflegemahd ohne Verbringung unmittelbar nach dem Weidegang zählt nicht (ab 2025)
is_uncounted_after_grazing(e) if {
	year >= 2025
	object.get(e, "after_grazing_care", false) == true
	object.get(e, "removed", false) == false
}

counted_use(p, e) if {
	e.type in {"mow", "chop", "graze"}
	not is_uncounted_cleaning_cut(p, e)
	not is_uncounted_after_grazing(e)
}

counted_uses(p) := [e | some e in use_events(p); counted_use(p, e); date_year(e.date) == year]

invasive_exception(p) if {
	object.get(o6_1b_input, "invasive_species_over_25_percent_of_arable_div", false) == true
	object.get(div_info(p), "invasive_species_present", false) == true
}

# Flächen mit vorrangiger Projektbestätigung (NAT/EBW)
div_project_precedence(p) if count(codes(p) & {"NAT", "EBW"}) > 0

early_used(p) if {
	some e in counted_uses(p)
	md(e.date) < arable_div_cfg.late_use_date
}

early_use_area(pred) := sum([area(p) | some p in parcels; is_arable_div(p); early_used(p); early_use_class(p) == pred])

early_use_class(p) := "project" if div_project_precedence(p)

early_use_class(p) := "invasive" if {
	not div_project_precedence(p)
	invasive_exception(p)
}

early_use_class(p) := "opted_out" if {
	not div_project_precedence(p)
	not invasive_exception(p)
	opted_out(p)
}

early_use_class(p) := "regular" if {
	not div_project_precedence(p)
	not invasive_exception(p)
	not opted_out(p)
}

arable_div_early_share := share(early_use_area("regular") + early_use_area("project"), arable_div_total_ha)

violations contains {"rule_id": "O61B-DA-018", "message": sprintf("Mehr als 25 %% der Acker-Biodiversitätsflächen vor dem 1. August genutzt (%v %%)", [round2(arable_div_early_share * 100)])} if {
	early_use_area("regular") > 0
	arable_div_early_share > 1 - arable_div_cfg.late_use_share
}

violations contains {"rule_id": "O61B-DA-019", "message": sprintf("Acker-Biodiversitätsfläche %s: Beweidung vor dem 1. August bzw. (bis 2024) Beweidung unzulässig", [p.parcel_id])} if {
	some p in parcels
	div_full_rules_apply(p)
	not opted_out(p)
	some e in use_events(p)
	e.type == "graze"
	date_year(e.date) == year
	grazing_not_allowed(e)
}

grazing_not_allowed(_) if year <= 2024

grazing_not_allowed(e) if {
	year >= 2025
	md(e.date) < arable_div_cfg.late_use_date
}

violations contains {"rule_id": "O61B-DA-019", "message": sprintf("Acker-Biodiversitätsfläche %s: Drusch nicht erlaubt", [p.parcel_id])} if {
	some p in parcels
	is_arable_div(p)
	some e in use_events(p)
	e.type == "thresh"
}

violations contains {"rule_id": "O61B-DA-019", "message": sprintf("Acker-Biodiversitätsfläche %s: mehr als 2 Nutzungen im Jahr", [p.parcel_id])} if {
	some p in parcels
	is_arable_div(p)
	not div_project_precedence(p)
	count(counted_uses(p)) > arable_div_cfg.max_uses_per_year
	not invasive_exception(p)
	not third_use_2026_allowed(p)
}

violations contains {"rule_id": "O61B-DA-020", "message": sprintf("Acker-Biodiversitätsfläche %s: nach Mahd vor dem 1. August max. 1 Beweidung", [p.parcel_id])} if {
	some p in parcels
	div_full_rules_apply(p)
	year >= 2025
	some m in counted_uses(p)
	m.type in {"mow", "chop"}
	md(m.date) < arable_div_cfg.late_use_date
	count([g | some g in counted_uses(p); g.type == "graze"]) > 1
}

violations contains {"rule_id": "O61B-DA-018", "message": sprintf("Acker-Biodiversitätsfläche %s: keine Mahd/Häckseln/Weide innerhalb von zwei Jahren", [p.parcel_id])} if {
	some p in parcels
	div_full_rules_apply(p)
	first_declared_year(p) < year
	object.get(div_info(p), "used_previous_year", false) == false
	count(counted_uses(p)) == 0
	object.get(div_info(p), "year_complete", false) == true
}

violations contains {"rule_id": "O61B-DA-023", "message": sprintf("Acker-Biodiversitätsfläche %s: Reinigungsschnitt nur im Jahr der ersten Beantragung auf Neuansaatflächen zulässig", [p.parcel_id])} if {
	some p in parcels
	is_arable_div(p)
	some e in use_events(p)
	object.get(e, "cleaning_cut", false) == true
	md(e.date) < arable_div_cfg.late_use_date
	not cleaning_cut_allowed(p)
}

cleaning_cut_allowed(p) if {
	first_declared_year(p) == year
	is_new_sowing(p)
	year >= 2025
}

# --- Betriebsmitteleinsatz und Befahren (Kap. 6.1.4.3, 6.1.4.4) -------------------------------

violations contains {"rule_id": "O61B-DA-025", "message": sprintf("Düngung auf Acker-Biodiversitätsfläche %s", [p.parcel_id])} if {
	some p in parcels
	div_full_rules_apply(p)
	some f in fertilizer_applications(p)
	f.date >= sprintf("%d-01-01", [first_declared_year(p)])
}

violations contains {"rule_id": "O61B-DA-026", "message": sprintf("Beseitigung der Biodiversitätsfläche %s nicht mit mechanischen Methoden", [p.parcel_id])} if {
	some p in parcels
	is_arable_div(p)
	method := object.get(div_info(p), "removal_implement", null)
	method != null
	not method in lists.div_mechanical_removal_implements
}

violations contains {"rule_id": "O61B-DA-027", "message": sprintf("Acker-Biodiversitätsfläche %s: unzulässige Nutzung (%s)", [p.parcel_id, u])} if {
	some p in parcels
	is_arable_div(p)
	some u in object.get(p, ["operations", "prohibited_uses"], [])
	u in {"irrigation_installation", "driving", "machine_parking", "trailer_parking", "storage", "turning_area"}
}

# --- Zuschlag Neuansaat mit regionaler Acker-Saatgutmischung DIVRS (Kap. 6.1.5) -------------

is_arable_divrs(p) if {
	is_arable_div(p)
	has_code(p, "DIVRS")
}

regional_mixture_ok(m) if {
	object.get(m, "species_count", 0) >= data.o6_1b.regional_seed_species.requirements.min_species
	object.get(m, "family_count", 0) >= data.o6_1b.regional_seed_species.requirements.min_families
	object.get(m, "seed_rate_kg_ha", 0) >= data.o6_1b.regional_seed_species.requirements.min_seed_rate_kg_ha
	object.get(m, "regional_origin_certified", false) == true
	object.get(m, "documented", false) == true
	species_list_ok(m)
}

# Ohne Ökotypensaatgut: nur Arten aus Kapitel 14 und max. 5 Gewichtsprozent je Art
species_list_ok(m) if object.get(m, "ecotype_seed_used", false) == true

species_list_ok(m) if {
	object.get(m, "ecotype_seed_used", false) == false
	object.get(m, "max_single_species_weight_percent", 100) <= data.o6_1b.regional_seed_species.requirements.max_single_species_weight_percent
	object.get(m, "species_outside_list", 0) == 0
}

divrs_seed_ok(p) if {
	not object.get(div_info(p), "divrs_interrupted", false) == true
	regional_mixture_ok(seed_mixture(p))
}

divrs_seed_ok(p) if {
	object.get(div_info(p), "divrs_interrupted", false) == true
	is_new_sowing(p)
	regional_mixture_ok(seed_mixture(p))
}

divrs_arable_variant(p) := object.get(div_info(p), "divrs_variant", "sonstiges_feldfutter")

mowings_with_removal(p) := [e | some e in counted_uses(p); e.type == "mow"; object.get(e, "removed", false) == true]

chops(p) := [e | some e in use_events(p); e.type == "chop"; date_year(e.date) == year]

divrs_arable_care_ok(p) if {
	year <= 2024
	count(mowings_with_removal(p)) >= 1
	count(mowings_with_removal(p)) <= 2
	count(chops(p)) == 0
}

divrs_arable_care_ok(p) if {
	year >= 2025
	divrs_arable_variant(p) == "sonstiges_feldfutter"
	count(mowings_with_removal(p)) >= general.divrs_arable.variant_sonstiges_feldfutter.min_mowings
	count(mowings_with_removal(p)) <= general.divrs_arable.variant_sonstiges_feldfutter.max_mowings
	count([e | some e in counted_uses(p); e.type in {"chop", "graze"}]) == 0
}

divrs_arable_care_ok(p) if {
	year >= 2025
	divrs_arable_variant(p) == "gruenbrache"
	count(chops(p)) <= general.divrs_arable.variant_gruenbrache.max_chop_per_year
	every e in chops(p) {
		gruenbrache_chop_date_ok(p, e)
	}
	count([e | some e in use_events(p); e.type in {"mow", "graze"}; date_year(e.date) == year]) == 0
}

gruenbrache_chop_date_ok(_, e) if md(e.date) >= general.divrs_arable.variant_gruenbrache.chop_earliest

gruenbrache_chop_date_ok(p, e) if {
	object.get(e, "cleaning_cut", false) == true
	object.get(e, "removed", false) == false
	first_declared_year(p) == year
}

# Pflegeprüfung erst nach Ablauf des Jahres bzw. wenn Nutzungsdaten vollständig sind
divrs_arable_care_checkable(p) if object.get(div_info(p), "year_complete", false) == true

violations contains {"rule_id": "O61B-DA-028", "message": sprintf("DIVRS-Fläche %s: Anforderungen an die regionale Acker-Saatgutmischung nicht erfüllt", [p.parcel_id])} if {
	some p in parcels
	is_arable_divrs(p)
	not divrs_seed_ok(p)
}

violations contains {"rule_id": "O61B-DA-030", "message": sprintf("DIVRS-Fläche %s: Pflege-/Nutzungsauflagen der gewählten Variante nicht eingehalten", [p.parcel_id])} if {
	some p in parcels
	is_arable_divrs(p)
	divrs_arable_care_checkable(p)
	not divrs_arable_care_ok(p)
}

violations contains {"rule_id": "O61B-DA-029", "message": "DIVRS-Beantragung ohne neuerliche Ansaat nur bis längstens 2028"} if {
	some p in parcels
	is_arable_divrs(p)
	year > general.divrs_arable.last_year_without_resowing
}

# --- Beantragung (Kap. 10) ---------------------------------------------------------------------

arable_div_land_use_allowed(p) if {
	has_code(p, "DIVRS")
	some r in lists.arable_divrs_land_use_types
	r.land_use == land_use_type(p)
	r.from_year <= year
}

arable_div_land_use_allowed(p) if {
	not has_code(p, "DIVRS")
	some r in lists.arable_div_land_use_types
	r.land_use == land_use_type(p)
	r.from_year <= year
}

violations contains {"rule_id": "O61B-AN-003", "message": sprintf("Acker-Biodiversitätsfläche %s mit unzulässiger Schlagnutzungsart %s", [p.parcel_id, land_use_type(p)])} if {
	some p in parcels
	is_arable_div(p)
	not arable_div_land_use_allowed(p)
}

violations contains {"rule_id": "O61B-AN-004", "message": sprintf("Aus Naturschutz/EBW angerechnete Biodiversitätsfläche %s muss als Grünbrache beantragt werden", [p.parcel_id])} if {
	some p in parcels
	is_arable_div(p)
	count(codes(p) & {"NAT", "EBW"}) > 0
	land_use_type(p) != "Grünbrache"
}

violations contains {"rule_id": "O61B-DA-005", "message": sprintf("K20-Ackerfläche %s ist nicht als Biodiversitätsfläche anrechenbar", [p.parcel_id])} if {
	some p in parcels
	is_arable_div(p)
	has_code(p, "K20")
}
