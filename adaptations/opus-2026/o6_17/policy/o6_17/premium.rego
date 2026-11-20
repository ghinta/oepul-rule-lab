# Modul:
#   o6_17 – Prämienberechnung (Grundprämie, Zuschlag artenreiches Grünland, Modulation, Obergrenze)
package oepul.o6_17

rates := cfg.premium_rates

# ---------------------------------------------------------------------------
# Grundprämie: umbruchsfähiges Grünland mit Hangneigung < 18 %, gestaffelt nach Grünlandzahl
# ---------------------------------------------------------------------------
base_premium_eligible(p) if {
	is_grassland(p)
	field_use_row(p)
	is_number(p.slope_percent)
	p.slope_percent < rates.slope_threshold_percent
	is_number(object.get(p, "grassland_figure", null))
	not gloez_conversion_ban(p)
	not parcel_excluded_general(p)
}

base_rate_eur_per_ha(p) := row.eur_per_ha if {
	some row in rates.base_premium_rates
	year_in_range(application_year, row)
	value_at_least(p.grassland_figure, row.grassland_figure_min)
	value_below(p.grassland_figure, row.grassland_figure_max_exclusive)
}

base_premium_parcel_eur[pid] := amount if {
	some p in parcels
	base_premium_eligible(p)
	pid := p.parcel_id
	amount := p.area_ha * base_rate_eur_per_ha(p)
}

base_premium_area_ha := sum([p.area_ha | some p in parcels; base_premium_eligible(p)])

# ---------------------------------------------------------------------------
# Optionaler Zuschlag artenreiches Grünland (Code AGL)
# ---------------------------------------------------------------------------
agl_slope_class(p) := "lt18" if p.slope_percent < rates.slope_threshold_percent

agl_slope_class(p) := "ge18" if p.slope_percent >= rates.slope_threshold_percent

agl_rate_eur_per_ha(p) := row.eur_per_ha if {
	some row in rates.agl_premium_rates
	row.slope_class == agl_slope_class(p)
	year_in_range(application_year, row)
}

agl_requested(p) if field_use_attr(p, "agl_automatic") == true

agl_requested(p) if {
	field_use_attr(p, "agl_requires_code_and_survey") == true
	cfg.lists.agl.code in parcel_codes(p)
}

kennart_matches(k, name) if lower(trim_space(name)) == lower(k.common_name)

kennart_matches(k, name) if {
	some alt in k.alternative_names
	lower(trim_space(name)) == lower(alt)
}

kennart_matches(k, name) if {
	some s in k.scientific_names
	lower(trim_space(name)) == lower(s)
}

section_species(section) := {k.id | some name in object.get(section, "kennarten", []); some k in cfg.kennarten.species; kennart_matches(k, name)}

agl_sections(p) := object.get(p, ["agl_survey", "sections"], [])

kennarten_sections_ok(p) if {
	count(agl_sections(p)) > 0
	every section in agl_sections(p) {
		count(section_species(section)) >= cfg.kennarten.minimum_species_per_section
	}
}

first_use_is_mowing(p) if object.get(p, ["operations", "first_use_type"], "") == "mowing"

agl_documented(p) if object.get(p, ["agl_survey", "documented"], false) == true

agl_conditions_met(p) if field_use_attr(p, "agl_automatic") == true

agl_conditions_met(p) if {
	field_use_attr(p, "agl_requires_code_and_survey") == true
	kennarten_sections_ok(p)
	first_use_is_mowing(p)
	agl_documented(p)
}

# GLÖZ 2/4/9 schließen den Zuschlag AGL nicht aus
agl_eligible(p) if {
	is_grassland(p)
	field_use_attr(p, "is_bergmaehder") == false
	is_number(p.slope_percent)
	agl_requested(p)
	agl_conditions_met(p)
	not parcel_excluded_general(p)
	agl_rate_eur_per_ha(p)
}

mown_grassland_ha := sum([p.area_ha | some p in parcels; is_mown_grassland(p)])

is_mown_grassland(p) if {
	is_grassland(p)
	field_use_attr(p, "is_mown") == true
	field_use_attr(p, "is_bergmaehder") == false
}

agl_cap_row := row if {
	some row in rates.agl_area_caps
	year_in_range(application_year, row)
}

agl_area_cap_ha := max([agl_cap_row.max_share_of_mown_grassland * mown_grassland_ha, agl_cap_row.minimum_cap_ha])

agl_requested_area_ha := sum([p.area_ha | some p in parcels; agl_eligible(p)])

agl_paid_share := 1 if agl_requested_area_ha <= agl_area_cap_ha

agl_paid_share := agl_area_cap_ha / agl_requested_area_ha if agl_requested_area_ha > agl_area_cap_ha

agl_premium_parcel_eur[pid] := amount if {
	some p in parcels
	agl_eligible(p)
	pid := p.parcel_id
	amount := (p.area_ha * agl_rate_eur_per_ha(p)) * agl_paid_share
}

# ---------------------------------------------------------------------------
# Prämienfähigkeit von Flächenzugängen (ab 2026: max. 50 % auf Basis 2025, jedenfalls 5 ha)
# ---------------------------------------------------------------------------
area_addition_cfg := cfg.general.area_addition_limits

premium_eligible_area_limit_ha := limit if {
	application_year > area_addition_cfg.reference_year
	ref := o617.committed_area_2025_ha
	is_number(ref)
	increase := max([ref * area_addition_cfg.max_increase_share, area_addition_cfg.always_allowed_increase_ha])
	limit := (ref + increase) + object.get(o617, "additions_previously_committed_ha", 0)
}

addition_scale := base_premium_area_ha_limited / base_premium_area_ha if base_premium_area_ha > 0

addition_scale := 1 if base_premium_area_ha == 0

base_premium_area_ha_limited := min([base_premium_area_ha, premium_eligible_area_limit_ha])

base_premium_area_ha_limited := base_premium_area_ha if not premium_eligible_area_limit_ha

# ---------------------------------------------------------------------------
# Modulation (Betriebsgröße, Heimfläche ohne Almweideflächen)
# ---------------------------------------------------------------------------
modulation_area_ha := utilised_area_excl_alpine_ha

tier_upper(a, t) := a if t.to_ha == null

tier_upper(_, t) := t.to_ha if is_number(t.to_ha)

tier_overlap(a, t) := max([0, min([a, tier_upper(a, t)]) - t.from_ha])

modulation_factor := 1 if modulation_area_ha <= 0

modulation_factor := f if {
	modulation_area_ha > 0
	weighted := sum([w | some t in cfg.general.modulation_tiers; w := tier_overlap(modulation_area_ha, t) * t.payment_share])
	f := weighted / modulation_area_ha
}

# ---------------------------------------------------------------------------
# Obergrenze für Flächenzahlungen je Schlag (allgemeine Obergrenze)
# ---------------------------------------------------------------------------
area_payment_cap_eur_per_ha := row.eur_per_ha if {
	some row in cfg.general.area_payment_caps
	row.scope == "general"
	year_in_range(application_year, row)
}

parcel_gross_eur(pid) := (object.get(base_premium_parcel_eur, pid, 0) * addition_scale) + object.get(agl_premium_parcel_eur, pid, 0)

premium_parcel_ids := {pid | some pid, _ in base_premium_parcel_eur} | {pid | some pid, _ in agl_premium_parcel_eur}

parcel_by_id(pid) := p if {
	some p in parcels
	p.parcel_id == pid
}

parcel_cap_room_eur(pid) := room if {
	p := parcel_by_id(pid)
	room := max([0, (area_payment_cap_eur_per_ha * p.area_ha) - object.get(p, "other_area_payments_eur", 0)])
}

premium_parcel_eur[pid] := amount if {
	some pid in premium_parcel_ids
	amount := min([parcel_gross_eur(pid) * modulation_factor, parcel_cap_room_eur(pid)])
}

premium_total_before_modulation_eur := sum([parcel_gross_eur(pid) | some pid in premium_parcel_ids])

premium_total_eur := 0 if premium_blocked_by_access_conditions

premium_total_eur := sum([a | some a in premium_parcel_eur]) if not premium_blocked_by_access_conditions

# Von der Gewährung kann abgesehen werden, wenn der Betrag 50 Euro nicht überschreitet
payment_may_be_withheld_minimum if premium_total_eur <= cfg.general.minimum_payment_eur
