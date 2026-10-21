# Prämienberechnung (Kap. 7-9, 11; SRL 2.1 B Höhe der Förderung; ATB 9.2, 9.3).
package oepul.o6_1b

# --- Prämienfähigkeit einzelner Schläge ---------------------------------------------------

premium_eligible(p) if {
	not excluded_land_use(p)
	not opted_out(p)
	not in_national_park_without_premium(p)
	not located_outside_austria(p)
	not land_use_type(p) in lists.non_premium_measure_land_use_types
	not has_code(p, "VF")
	not has_code(p, "K20")
	not other_measure_div(p)
}

# Aus anderen Maßnahmen angerechnete Biodiversitätsflächen erhalten deren Prämie (Kap. 11.2, 11.3)
other_measure_div(p) if {
	is_arable_div(p)
	div_from_other_measure(p)
}

other_measure_div(p) if {
	is_grassland_div(p)
	gl_div_from_other_measure(p)
}

# --- 11.2 Ackerflächen: Basismodulprämie ---------------------------------------------------

arable_base_parcel(p) if {
	is_arable(p)
	premium_eligible(p)
	land_use_type(p) != "Grünbrache"
	land_use_type(p) != "Sonstige Ackerflächen"
}

arable_base_parcel(p) if {
	is_arable(p)
	premium_eligible(p)
	land_use_type(p) == "Grünbrache"
	is_arable_div(p)
}

is_fallow_div(p) if {
	arable_base_parcel(p)
	land_use_type(p) == "Grünbrache"
}

erosion_crop(p) := lists.erosion_prone_crop_aliases[crop_name(p)]

erosion_crop(p) := crop_name(p) if {
	not lists.erosion_prone_crop_aliases[crop_name(p)]
	crop_name(p) in lists.erosion_prone_crops
}

erosion_affected(p) if {
	area(p) > caps.erosion_min_parcel_ha_exclusive
	object.get(p, "slope_percent", 0) >= caps.erosion_min_slope_percent
	_ := erosion_crop(p)
	not erosion_full_premium(p)
}

erosion_full_premium(p) if {
	lists.erosion_reducing_measures_full_base.required_measure in participating_measures
	object.get(p, ["operations", "erosion_reducing_method"], false) == true
	not mulch_without_greening(p)
}

mulch_without_greening(p) if {
	object.get(p, ["operations", "mulch_direct_striptill"], false) == true
	count(participating_measures & {m | some m in lists.erosion_reducing_measures_full_base.if_mulch_direct_striptill_also_one_of}) == 0
}

erosion_factor(p) := 1 if not erosion_affected(p)

erosion_factor(p) := 0 if {
	erosion_affected(p)
	year <= 2024
}

erosion_factor(p) := caps.erosion_reduction_factor_from_2025 if {
	erosion_affected(p)
	year >= 2025
}

arable_base_non_fallow_eff_ha := sum([(area(p) * erosion_factor(p)) | some p in parcels; arable_base_parcel(p); not is_fallow_div(p)])

arable_fallow_div_ha := sum([area(p) | some p in parcels; is_fallow_div(p)])

arable_fallow_div_paid_ha := min2(arable_fallow_div_ha, caps.grassland_fallow_base_max_share_of_arable * arable_area_ha)

arable_base_premium := (arable_base_non_fallow_eff_ha + arable_fallow_div_paid_ha) * rate("arable_base")

# --- Zuschläge Acker-Biodiversitätsflächen (Kap. 8.1-8.4, 6.1.5) -------------------------------

div_cap_arable := caps.arable_div_supplement_max_share_of_arable * arable_area_ha

div_bio_paid(p) if {
	is_arable_div(p)
	premium_eligible(p)
}

arable_div_paid_ha := sum([area(p) | some p in parcels; div_bio_paid(p)])

arable_div_pure_paid_ha := sum([area(p) | some p in parcels; div_bio_paid(p); div_pure(p)])

arable_div_over7_ha := clamp0(min2(arable_div_pure_paid_ha, div_cap_arable) - (arable_div_cfg.min_share * arable_area_ha))

arable_div_over7_premium := arable_div_over7_ha * rate("arable_div_over_7")

arable_div_ackerzahl_ha := min2(sum([area(p) | some p in parcels; div_bio_paid(p); object.get(p, "ackerzahl", 0) >= 50]), div_cap_arable)

arable_div_ackerzahl_premium := arable_div_ackerzahl_ha * rate("arable_div_ackerzahl_50")

arable_div_parcels_gt_5a := count([p | some p in parcels; is_arable_div(p); area(p) > arable_div_cfg.per_3ha_min_parcel_ha_exclusive])

arable_div_per_3ha_required := ceil_int(arable_area_ha / 3)

arable_div_per_3ha_met if {
	arable_area_ha > 0
	arable_div_parcels_gt_5a >= arable_div_per_3ha_required
}

arable_div_per_3ha_premium := min2(arable_div_paid_ha, div_cap_arable) * rate("arable_div_per_3ha") if arable_div_per_3ha_met

arable_div_per_3ha_premium := 0 if not arable_div_per_3ha_met

divrs_arable_paid(p) if {
	is_arable_divrs(p)
	div_bio_paid(p)
	divrs_seed_ok(p)
	not divrs_care_failed(p)
	year <= general.divrs_arable.last_year_without_resowing
}

divrs_care_failed(p) if {
	divrs_arable_care_checkable(p)
	not divrs_arable_care_ok(p)
}

divrs_arable_rate(_) := rate("arable_divrs_sonstiges_feldfutter") if year <= 2024

divrs_arable_rate(p) := rate("arable_divrs_sonstiges_feldfutter") if {
	year >= 2025
	divrs_arable_variant(p) == "sonstiges_feldfutter"
}

divrs_arable_rate(p) := rate("arable_divrs_gruenbrache") if {
	year >= 2025
	divrs_arable_variant(p) == "gruenbrache"
}

divrs_arable_ha := sum([area(p) | some p in parcels; divrs_arable_paid(p)])

divrs_arable_cap := caps.divrs_arable_max_share_of_arable * arable_area_ha

divrs_arable_factor := 1 if divrs_arable_ha <= divrs_arable_cap

divrs_arable_factor := divrs_arable_cap / divrs_arable_ha if divrs_arable_ha > divrs_arable_cap

divrs_arable_premium := sum([(area(p) * divrs_arable_rate(p)) | some p in parcels; divrs_arable_paid(p)]) * divrs_arable_factor

# --- 8.5 SLK -----------------------------------------------------------------------------------

slk_varieties := {p.crop.variety | some p in parcels; slk_eligible(p); premium_eligible(p)}

slk_variety_ha(v) := sum([area(p) | some p in parcels; slk_eligible(p); premium_eligible(p); p.crop.variety == v])

slk_rate(v) := rate("slk_stufe_a") if variety_row(v).tier == "A"

slk_rate(v) := rate("slk_stufe_b") if variety_row(v).tier == "B"

slk_premium := sum([(min2(slk_variety_ha(v), caps.slk_max_ha_per_variety) * slk_rate(v)) | some v in slk_varieties])

# --- 8.6 Förderwürdige Ackerkulturen -------------------------------------------------------------

crop_names_of(p) := {n |
	some n in [crop_name(p), crop_base_name(p), land_use_type(p), object.get(p, ["crop", "second_crop_name"], "")]
	n != ""
}

bhg_counts(p) if {
	some n in crop_names_of(p)
	n in lists.bhg_crops
	not object.get(p, ["crop", "autochthonous_seed_production"], false) == true
}

bhg_counts(p) if {
	has_code(p, "BHG")
	object.get(p, ["crop", "autochthonous_seed_production"], false) == true
	object.get(p, ["crop", "seed_harvest_year"], false) == true
}

bhg_counts(p) if {
	has_code(p, "BHG")
	object.get(p, ["crop", "autochthonous_seed_production"], false) == false
	land_use_type(p) in lists.bhg_code_land_use_types
	object.get(p, ["crop", "additional_text"], "") in lists.bhg_crops
}

fw_group_rates(p) := {rate(g.rate_id) |
	some g in lists.foerderwuerdige_groups
	g.group != "bhg"
	some n in crop_names_of(p)
	n in g.crops
} | {rate("fw_bhg") | bhg_counts(p)}

fw_parcel(p) if {
	is_arable(p)
	premium_eligible(p)
	not is_arable_div(p)
	count(fw_group_rates(p)) > 0
	not npf_excluded(p)
}

npf_excluded(p) if {
	year <= 2024
	has_code(p, "NPF")
}

fw_rate(p) := max(fw_group_rates(p))

fw_area_ha := sum([area(p) | some p in parcels; fw_parcel(p)])

fw_share := share(fw_area_ha + clamp0(arable_div_total_ha - (arable_div_cfg.min_share * arable_area_ha)), arable_area_ha)

fw_threshold_met if fw_share > caps.foerderwuerdige_min_share_exclusive

fw_cap_ha := caps.foerderwuerdige_max_share_of_arable * arable_area_ha

fw_rates := {fw_rate(p) | some p in parcels; fw_parcel(p)}

fw_area_at(r) := sum([area(p) | some p in parcels; fw_parcel(p); fw_rate(p) == r])

fw_area_above(r) := sum([area(p) | some p in parcels; fw_parcel(p); fw_rate(p) > r])

fw_paid_area(r) := min2(fw_area_at(r), clamp0(fw_cap_ha - fw_area_above(r)))

fw_premium := sum([(fw_paid_area(r) * r) | some r in fw_rates]) if fw_threshold_met

fw_premium := 0 if not fw_threshold_met

# --- 8.7 Feldgemüse und Erdbeeren --------------------------------------------------------------

vegetable_parcel(p) if {
	is_arable(p)
	premium_eligible(p)
	crop_name(p) in array.concat(lists.feldgemuese, lists.erdbeeren)
}

vegetable_premium := sum([area(p) | some p in parcels; vegetable_parcel(p)]) * rate("feldgemuese_erdbeeren")

# --- 8.8 Wildkräuter- und Brutflächen ----------------------------------------------------------

wb_premium := min2(sum([area(p) | some p in parcels; wb_eligible(p); premium_eligible(p)]), caps.wildkraeuter_brutflaechen_max_ha) * rate("wildkraeuter_brutflaechen")

# --- 8.9 Pheromonfallen ---------------------------------------------------------------------------

pzr_premium := sum([area(p) | some p in parcels; pzr_eligible(p); premium_eligible(p)]) * rate_or_zero("pheromonfallen_zuckerrueben")

# --- 8.10 Kreislaufwirtschaft Acker ----------------------------------------------------------------

kreislauf_acker_parcel(p) if {
	is_arable(p)
	some n in crop_names_of(p)
	n in lists.kreislauf_acker_crops
}

kreislauf_acker_ha := sum([area(p) | some p in parcels; kreislauf_acker_parcel(p)])

kreislauf_acker_met if {
	year >= 2025
	share(kreislauf_acker_ha, arable_area_ha) > caps.kreislauf_acker_min_share_exclusive
	stocking_below_1_4
}

kreislauf_acker_premium := sum([area(p) | some p in parcels; kreislauf_acker_parcel(p); premium_eligible(p)]) * rate("kreislauf_acker") if kreislauf_acker_met

kreislauf_acker_premium := 0 if not kreislauf_acker_met

# --- 11.3 Grünland ---------------------------------------------------------------------------------

grassland_base_parcel(p) if {
	is_grassland(p)
	premium_eligible(p)
}

grassland_base_rate := rate("grassland_base_non_livestock") if livestock_category == "non_livestock"

grassland_base_rate := rate("grassland_base_livestock_lt_1_4") if livestock_category == "livestock_lt_1_4"

grassland_base_rate := rate("grassland_base_livestock_ge_1_4") if livestock_category == "livestock_ge_1_4"

grassland_base_ha := sum([area(p) | some p in parcels; grassland_base_parcel(p)])

grassland_base_premium := grassland_base_ha * grassland_base_rate

gl_div_cap := caps.grassland_div_supplement_max_share_of_mown_grassland * mown_grassland_area_ha

gl_div_bio_paid(p) if {
	is_grassland_div(p)
	premium_eligible(p)
	not is_bergmaehder(p)
}

gl_div_paid_ha := sum([area(p) | some p in parcels; gl_div_bio_paid(p)])

gl_div_pure_paid_ha := sum([area(p) | some p in parcels; gl_div_bio_paid(p); grassland_div_pure(p)])

gl_div_over7_ha := clamp0(min2(gl_div_pure_paid_ha, gl_div_cap) - (gl_div_cfg.min_share * mown_grassland_area_ha))

gl_div_over7_premium := gl_div_over7_ha * rate("grassland_div_over_7")

gl_div_glz_premium := min2(sum([area(p) | some p in parcels; gl_div_bio_paid(p); object.get(p, "gruenlandzahl", 0) >= 30]), gl_div_cap) * rate("grassland_div_gruenlandzahl_30")

gl_div_parcels_gt_5a := count([p | some p in parcels; is_grassland_div(p); area(p) > gl_div_cfg.per_3ha_min_parcel_ha_exclusive])

gl_div_per_3ha_met if {
	mown_grassland_area_ha > 0
	gl_div_parcels_gt_5a >= ceil_int(mown_grassland_area_ha / 3)
}

gl_div_per_3ha_premium := min2(gl_div_paid_ha, gl_div_cap) * rate("grassland_div_per_3ha") if gl_div_per_3ha_met

gl_div_per_3ha_premium := 0 if not gl_div_per_3ha_met

divagf_premium := min2(sum([area(p) | some p in parcels; gl_div_bio_paid(p); has_code(p, "DIVAGF")]), gl_div_cap) * rate_or_zero("grassland_divagf")

divrs_grassland_premium := min2(
	sum([area(p) | some p in parcels; gl_div_bio_paid(p); is_grassland_divrs(p); grassland_divrs_seed_ok(p)]),
	caps.divrs_grassland_max_share_of_mown_grassland * mown_grassland_area_ha,
) * rate("grassland_divrs")

# --- 9.6 Gemähte Steilflächen -------------------------------------------------------------------

steep_parcel(p) if {
	grassland_base_parcel(p)
	land_use_type(p) in lists.steep_slope_land_use_types
	object.get(p, "slope_percent", 0) >= caps.steep_slope_min_percent
	object.get(p, "is_mown", false) == true
}

steep_ha := sum([area(p) | some p in parcels; steep_parcel(p)])

steep_topup_rate := rate("topup_steep_mown_ge_50") if object.get(o6_1b_input, "land_topup_steep_granted", false) == true

steep_topup_rate := 0 if object.get(o6_1b_input, "land_topup_steep_granted", false) != true

steep_premium := steep_ha * (rate("steep_mown_ge_50") + steep_topup_rate)

# --- 9.7 Kreislaufwirtschaft Grünland ----------------------------------------------------------

species_rich_ha := sum([area(p) | some p in parcels; is_grassland(p); object.get(p, "species_rich_grassland_o6_17", false) == true])

auto_credited_o6_17_ha := sum([area(p) |
	some p in parcels
	is_grassland(p)
	"o6_17" in participating_measures
	land_use_type(p) in {"Einmähdige Wiese", "Streuwiese"}
	not is_grassland_div(p)
	object.get(p, "species_rich_grassland_o6_17", false) == false
])

kreislauf_gl_share := share((grassland_div_credit_ha + species_rich_ha) + auto_credited_o6_17_ha, mown_grassland_area_ha)

kreislauf_gl_met if {
	year >= 2025
	is_livestock_farm
	stocking_below_1_4
	kreislauf_gl_share > caps.kreislauf_gruenland_min_div_share_exclusive
}

kreislauf_gl_premium := grassland_base_ha * rate("kreislauf_gruenland") if kreislauf_gl_met

kreislauf_gl_premium := 0 if not kreislauf_gl_met

# --- 11.4 Wein-, Obst- und Hopfenflächen -------------------------------------------------------

woh_parcel(p) if {
	is_special_crop(p)
	premium_eligible(p)
	object.get(p, ["crop", "crop_category"], "") in lists.woh_crop_categories
	not ungrafted_fruit(p)
}

ungrafted_fruit(p) if {
	is_fruit(p)
	object.get(p, ["crop", "is_grafted"], true) == false
}

woh_rate(p) := rate("woh_walnuss_edelkastanie") if crop_name(p) in lists.woh_walnut_chestnut

woh_rate(p) := rate("woh_wein_obst_hopfen") if not crop_name(p) in lists.woh_walnut_chestnut

woh_premium := sum([(area(p) * woh_rate(p)) | some p in parcels; woh_parcel(p)])

# --- 11.1 Betriebliche Optionen ------------------------------------------------------------------

lse_premium := (lse_paid_total("streuobst") * rate("lse_streuobst")) + (lse_paid_total("other") * rate("lse_other"))

hedge_premium := hedge_area_paid_ha * rate("multi_use_hedge")

bee_premium := (min2(bee_hives_eligible, caps.bee_hives_first_tier) * rate("bee_hive_first_100")) + (clamp0(bee_hives_eligible - caps.bee_hives_first_tier) * rate("bee_hive_from_101"))

monitoring_premium := sum([rate(monitoring_programme(m.programme).rate_id) | some m in monitoring; monitoring_eligible(m)])

transaction_cost_premium := rate_or_zero("transaction_costs")

# --- Summen, Modulation (ATB 9.3; SRL 1.9.2.2) -----------------------------------------------

premium_components := {
	"arable_base": arable_base_premium,
	"arable_div_over_7": arable_div_over7_premium,
	"arable_div_ackerzahl_50": arable_div_ackerzahl_premium,
	"arable_div_per_3ha": arable_div_per_3ha_premium,
	"arable_divrs": divrs_arable_premium,
	"slk": slk_premium,
	"foerderwuerdige_kulturen": fw_premium,
	"feldgemuese_erdbeeren": vegetable_premium,
	"wildkraeuter_brutflaechen": wb_premium,
	"pheromonfallen": pzr_premium,
	"kreislauf_acker": kreislauf_acker_premium,
	"grassland_base": grassland_base_premium,
	"grassland_div_over_7": gl_div_over7_premium,
	"grassland_div_gruenlandzahl_30": gl_div_glz_premium,
	"grassland_div_per_3ha": gl_div_per_3ha_premium,
	"grassland_divagf": divagf_premium,
	"grassland_divrs": divrs_grassland_premium,
	"steep_mown": steep_premium,
	"kreislauf_gruenland": kreislauf_gl_premium,
	"wine_fruit_hops": woh_premium,
	"landscape_elements": lse_premium,
	"multi_use_hedges": hedge_premium,
	"bio_bee_hives": bee_premium,
	"monitoring": monitoring_premium,
	"transaction_costs": transaction_cost_premium,
}

premium_total_gross := sum([v | some v in premium_components])

total_farm_area_ha := object.get(input, ["land", "total_area_ha"], sum([area(p) | some p in parcels]))

modulated_area(a) := (min2(a, 200) + (clamp0(min2(a, 300) - 200) * 0.90)) + ((clamp0(min2(a, 1000) - 300) * 0.85) + (clamp0(a - 1000) * 0.75))

modulation_factor := modulated_area(total_farm_area_ha) / total_farm_area_ha if total_farm_area_ha > 0

modulation_factor := 1 if total_farm_area_ha <= 0

premium_total_modulated := premium_total_gross * modulation_factor

# Von der Gewährung kann abgesehen werden, wenn der Auszahlungsbetrag 50 Euro nicht überschreitet.
payout_may_be_withheld if premium_total_modulated <= general.payment.min_payout_eur_exclusive

# Obergrenze für Flächenzahlungen je Schlag (ATB 9.2; SRL 1.9.2.1)
area_payment_cap(cap_id) := c.eur_per_ha if {
	some c in general.area_payment_caps
	c.id == cap_id
	c.from_year <= year
	within_to_year(c.to_year, year)
}

parcel_cap_id(p) := "naturschutz_ebw" if count(codes(p) & {"NAT", "EBW"}) > 0

parcel_cap_id(p) := "general" if count(codes(p) & {"NAT", "EBW"}) == 0

capped_parcels contains {"parcel_id": p.parcel_id, "cap_eur_per_ha": area_payment_cap(parcel_cap_id(p))} if {
	some p in parcels
	object.get(p, "oepul_area_payment_eur_per_ha", 0) > area_payment_cap(parcel_cap_id(p))
}
