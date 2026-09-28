# Prämienberechnung EBW gemäß Anhang K (Prämienermittlung) und allgemeinen Kürzungsregeln.
package oepul.o6_19

import rego.v1

rates := tables.premium_rates

# R-O619-RATE-VALIDITY: Prämiensätze gelten ab 01.01.2024 (für 2023 liegen keine Sätze in den Quellen vor).
rates_applicable if year >= rates.valid_from_year

# R-O619-RATE-WIESEN: Wiesen je Biotoptyp, Erhaltungszustand und Erschwernisklasse.
base_rate(e) := r if {
	rates_applicable
	e.premium_table == "wiesen"
	some row in rates.wiesen
	row.habitat == e.premium_habitat
	r := row.rates[e.conservation_status][e.difficulty]
	is_number(r)
}

# R-O619-RATE-WEIDEN / R-O619-RATE-ACKER: je Biotoptyp und Erhaltungszustand.
base_rate(e) := r if {
	rates_applicable
	e.premium_table in {"weiden", "acker"}
	some row in rates[e.premium_table]
	row.habitat == e.premium_habitat
	r := row.rates[e.conservation_status]
	is_number(r)
}

# R-O619-RATE-VOEGEL: spezielle Grünland-Vogelarten (Braunkehlchen bis/ab 2025, Wachtelkönig).
base_rate(e) := r if {
	rates_applicable
	e.premium_table == "voegel"
	some row in rates.voegel
	row.habitat == e.premium_habitat
	year >= row.valid_from_year
	year <= row.valid_to_year
	r := row.rates[e.conservation_status]
	is_number(r)
}

surcharge_def(code) := s if {
	some s in rates.surcharges
	s.code == code
}

parcel_surcharge_codes(e) := {c | some c in object.get(e, "surcharge_codes", [])}

parcel_ebba_codes(e) := {c | some c in parcel_surcharge_codes(e); startswith(c, "EBBA")}

ebba_reason(e) := r if {
	some r in tables.ebba_reasons.reasons
	r.reason_id == e.ebba_reason_id
}

indicator_code_set(e) := {i.code | some i in object.get(e, "indicators", [])}

# R-O619-EBBA-REASON-LIST: Zuschlag nur bei Zutreffen eines Grundes der Entscheidungsliste mit dessen Einschränkungen.
ebba_issue_reason_missing(e) if not ebba_reason(e)

ebba_issue_difficulty_not_allowed(e) if {
	r := ebba_reason(e)
	is_array(r.allowed_difficulty)
	not e.difficulty in r.allowed_difficulty
}

ebba_issue_area_too_large(e) if {
	r := ebba_reason(e)
	is_number(r.max_area_ha)
	num(e.parcel_area_ha) > r.max_area_ha
}

ebba_issue_habitat_excluded(e) if {
	r := ebba_reason(e)
	e.premium_habitat in r.excluded_habitats
}

ebba_issue_required_indicator_missing(e) if {
	r := ebba_reason(e)
	prefixes := object.get(r, "required_indicator_prefixes", [])
	count(prefixes) > 0
	not has_indicator_with_prefix(e, prefixes)
}

ebba_issue_conservation_status_not_allowed(e) if {
	r := ebba_reason(e)
	allowed := object.get(r, "allowed_conservation_status", null)
	is_array(allowed)
	not e.conservation_status in allowed
}

ebba_issue_min_cuts_not_met(e) if {
	r := ebba_reason(e)
	is_number(object.get(r, "min_cuts_per_year", null))
	num(object.get(e, "cuts_per_year", 0)) < r.min_cuts_per_year
}

ebba_issue_previous_year_not_arable(e) if {
	r := ebba_reason(e)
	object.get(r, "requires_previous_year_arable", false) == true
	not object.get(e, "previous_year_land_use", "") == "arable"
}

ebba_issue_animal_indicator_excluded_for_habitat(e) if {
	r := ebba_reason(e)
	r.reason_id == "tierziel"
	animal := {c | some c in indicator_code_set(e); prefix_match(c, ["EBAT", "EBGT"])}
	excluded := {c | some pair in r.excluded_indicator_habitat_pairs; pair.habitat == e.premium_habitat; some c in pair.indicators}
	count(animal - excluded) == 0
}

ebba_reason_issues(e) := {name |
	some name, bad in {
		"reason_missing": ebba_issue_reason_missing(e),
		"difficulty_not_allowed": ebba_issue_difficulty_not_allowed(e),
		"area_too_large": ebba_issue_area_too_large(e),
		"habitat_excluded": ebba_issue_habitat_excluded(e),
		"required_indicator_missing": ebba_issue_required_indicator_missing(e),
		"conservation_status_not_allowed": ebba_issue_conservation_status_not_allowed(e),
		"min_cuts_not_met": ebba_issue_min_cuts_not_met(e),
		"previous_year_not_arable": ebba_issue_previous_year_not_arable(e),
		"animal_indicator_excluded_for_habitat": ebba_issue_animal_indicator_excluded_for_habitat(e),
	}
	bad == true
}

default ebba_issue_reason_missing(_) := false

default ebba_issue_difficulty_not_allowed(_) := false

default ebba_issue_area_too_large(_) := false

default ebba_issue_habitat_excluded(_) := false

default ebba_issue_required_indicator_missing(_) := false

default ebba_issue_conservation_status_not_allowed(_) := false

default ebba_issue_min_cuts_not_met(_) := false

default ebba_issue_previous_year_not_arable(_) := false

default ebba_issue_animal_indicator_excluded_for_habitat(_) := false

has_indicator_with_prefix(e, prefixes) if {
	some c in indicator_code_set(e)
	prefix_match(c, prefixes)
}

prefix_match(code, prefixes) if {
	some pre in prefixes
	startswith(code, pre)
}

# R-O619-EBBA01 / R-O619-EBBA02: 108 EUR/ha bzw. (ab 2025, sehr guter Erhaltungszustand) 162 EUR/ha, nur einmal pro Fläche.
ebba_rate(e) := 0 if count(parcel_ebba_codes(e)) == 0

ebba_rate(e) := s.rate if {
	count(parcel_ebba_codes(e)) == 1
	some code in parcel_ebba_codes(e)
	s := surcharge_def(code)
	year >= s.valid_from_year
	object.get(s, "required_conservation_status", e.conservation_status) == e.conservation_status
	count(ebba_reason_issues(e)) == 0
}

ebba_invalid(e) if {
	count(parcel_ebba_codes(e)) > 0
	not ebba_rate(e)
}

# R-O619-EBHG: Habitatzuschlag 108 EUR/ha, wenn >= 50 % der Fläche im Layer "Schutzgutflächen" und von der Landesdienststelle gemeldet.
ebhg_rate(e, land_use) := s.rate if {
	some code in parcel_surcharge_codes(e)
	startswith(code, "EBHG")
	s := surcharge_def(code)
	s.land_use == land_use
	year >= s.valid_from_year
	num(object.get(e, "schutzgut_layer_share_percent", 0)) >= s.min_schutzgut_layer_share_percent
	e.habitat_area_reported_in_gis == true
}

default_zero_ebhg(e, land_use) := r if r := ebhg_rate(e, land_use)

default_zero_ebhg(e, land_use) := 0 if not ebhg_rate(e, land_use)

# Prämiensatz je Schlag (EUR/ha) vor Kürzungen.
parcel_rate[pid] := round2((base + ebba) + ebhg) if {
	some pid, p in ebw_parcels
	e := object.union(parcel_ebw(p), {"parcel_area_ha": p.area_ha})
	base := base_rate(e)
	ebba := ebba_rate(e)
	ebhg := default_zero_ebhg(e, p.land_use)
}

rate_issues[pid] contains "base_rate_not_found" if {
	some pid, p in ebw_parcels
	not base_rate(parcel_ebw(p))
}

rate_issues[pid] contains "ebba_not_admissible" if {
	some pid, p in ebw_parcels
	ebba_invalid(object.union(parcel_ebw(p), {"parcel_area_ha": p.area_ha}))
}

# R-O619-SETASIDE-CAP: Ackerstilllegungen max. 25 % der Ackerfläche, jedenfalls 2,00 ha förderfähig.
set_aside_area_total := sum([a |
	some pid, p in ebw_parcels
	parcel_is_set_aside(p)
	a := parcel_eligible_area[pid]
])

set_aside_cap_ha := max([params.set_aside_max_share_of_arable * num(input.land.arable_area_ha), params.set_aside_min_cap_ha])

set_aside_factor := 1 if set_aside_area_total <= set_aside_cap_ha

set_aside_factor := set_aside_cap_ha / set_aside_area_total if set_aside_area_total > set_aside_cap_ha

parcel_premium_area[pid] := a * set_aside_factor if {
	some pid, p in ebw_parcels
	parcel_is_set_aside(p)
	a := parcel_eligible_area[pid]
}

parcel_premium_area[pid] := parcel_eligible_area[pid] if {
	some pid, p in ebw_parcels
	not parcel_is_set_aside(p)
}

# R-O619-GEN-SANCTION-STAGES: Kürzungsstufen inhaltlicher Verstöße (maßnahmenbezogen inkl. Zuschläge).
sanction_stage := object.get(ebw, ["sanctions", "stage"], null)

sanction_reduction_percent := 0 if not is_number(sanction_stage)

sanction_reduction_percent := s.reduction_percent if {
	is_number(sanction_stage)
	some s in general_tables.sanction_stages
	s.stage == sanction_stage
	year >= object.get(s, "year_from", 0)
	year <= object.get(s, "year_to", 9999)
}

# R-O619-GEN-EXCLUSION-TWO-100: zweimalige 100 %-Kürzung -> Ausschluss und Rückforderung.
excluded_from_measure if object.get(ebw, ["sanctions", "count_100_percent"], 0) >= 2

# R-O619-GEN-MODULATION: Betriebsgrößenmodulation.
modulation_factor := 1 if num(input.land.total_area_ha) <= 0

modulation_factor := f if {
	total := num(input.land.total_area_ha)
	total > 0
	parts := [part |
		some b in general_tables.modulation_bands
		upper := band_upper(b, total)
		width := max([0, upper - b.from_ha])
		part := width * b.factor
	]
	f := sum(parts) / total
}

band_upper(b, total) := min([b.to_ha, total]) if is_number(b.to_ha)

band_upper(b, total) := total if not is_number(b.to_ha)

# R-O619-PREMIUM-CAP: Obergrenze für Flächenzahlungen 1.300 (2023) bzw. 1.500 EUR/ha (ab 2024) bei EBW-Teilnahme.
premium_cap_eur_per_ha := c.cap if {
	some c in general_tables.premium_caps_eur_per_ha
	c.scope == "naturschutz_or_ebw"
	year >= c.year_from
	year <= c.year_to
}

parcel_rate_after_reductions[pid] := capped if {
	some pid, p in ebw_parcels
	r := parcel_rate[pid]
	reduced := (r * (1 - (sanction_reduction_percent / 100))) * modulation_factor
	other := get_num(p, ["oepul", "other_area_payments_eur_per_ha"])
	capped := min([reduced, max([0, premium_cap_eur_per_ha - other])])
}

# R-O619-GEN-AREA-INCREASE: Flächenzugänge ab 2026 max. +50 % bzw. +5 ha auf Basis 2025.
area_2025 := object.get(ebw, "ebw_area_2025_ha", null)

area_increase_allowed_ha := area_2025 + max([area_2025 * general_tables.area_increase_limit.max_increase_share, general_tables.area_increase_limit.min_increase_ha]) if {
	is_number(area_2025)
}

premium_area_total := sum([a | some pid in ebw_parcel_ids; a := parcel_premium_area[pid]])

access_increase_factor := area_increase_allowed_ha / premium_area_total if {
	year > 2025
	is_number(area_increase_allowed_ha)
	premium_area_total > area_increase_allowed_ha
}

default access_increase_factor := 1

parcel_premium_eur[pid] := round2((a * r) * access_increase_factor) if {
	some pid in ebw_parcel_ids
	a := parcel_premium_area[pid]
	r := parcel_rate_after_reductions[pid]
}

area_premium_eur := round2(sum([v | some _, v in parcel_premium_eur]))

regional_plan_surcharge_after_reductions := round2((regional_plan_surcharge_eur * (1 - (sanction_reduction_percent / 100))) * modulation_factor)

measure_premium_eur := 0 if access_consequence != "none"

measure_premium_eur := 0 if excluded_from_measure

measure_premium_eur := round2(area_premium_eur + regional_plan_surcharge_after_reductions) if {
	access_consequence == "none"
	not excluded_from_measure
}

# R-O619-GEN-MIN-PAYMENT: Auszahlung kann unterbleiben, wenn der Betrag 50 EUR nicht überschreitet.
payment_may_be_withheld if measure_premium_eur <= params.min_payment_eur
