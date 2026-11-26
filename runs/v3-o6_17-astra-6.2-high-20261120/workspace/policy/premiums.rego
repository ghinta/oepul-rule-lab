package oepul.o6_17

import data.o17_tables as tab
import rego.v1

# Tarife und technische Bruttobeträge vor einzelbetrieblicher Bewilligung.
base_rate(year, score, slope) := row.eur_ha if {
	is_number(slope)
	slope >= 0
	slope < 18
	is_number(score)
	some row in tab.base_rates
	between_years(row, year)
	score >= row.min_score
	below_upper(score, row.below_score)
}

agl_rate(year, slope) := row.eur_ha if {
	is_number(slope)
	some row in tab.agl_rates
	between_years(row, year)
	slope >= row.min_slope
	below_upper(slope, row.below_slope)
}

ban_applies(code) if code in tab.gl_standard_bans

base_amounts[p.parcel_id] := (p.payable_ha - p.payable_ban_union_ha) * rate if {
	in_term
	some p in input.land.parcels
	count(object.get(parcel_exclusions, p.parcel_id, set())) == 0
	p.in_austrian_mfa
	p.land_use == "grassland"
	p.payable_ha >= p.payable_ban_union_ha
	p.payable_ban_union_ha >= 0
	p.area_ha >= p.payable_ha
	rate := base_rate(input.farm.year, p.grassland_score, p.slope_percent)
}

species_match(observed, row) if observed == row.name
species_match(observed, row) if observed == row.annex_h_name
species_match(observed, row) if observed in row.scientific_names

section_qualifies(section, year) if {
	names := {row.name |
		some visit in section.visits
		date_ok(visit.date)
		startswith(visit.date, sprintf("%d-", [year]))
		some obs in visit.observations
		obs.regularly_distributed
		obs.identified
		obs.flowers
		some row in tab.indicator_species
		species_match(obs.name, row)
	}
	count(names) >= 5
}

survey_recorded(s) if {
	s.form_complete
	s.transect_sketch
}

survey_recorded(s) if s.equivalent_records_complete

survey_recorded(s) if {
	s.ama_mfa_photos
	s.identifiable_geolocated_photos
	s.photos_distributed
}

agl_grass(p) if {
	p.in_austrian_mfa
	p.land_use == "grassland"
	p.mown
	p.mfa_use != "Bergmähder"
}

agl_candidate(p, _) if {
	agl_grass(p)
	p.mfa_use in {"Einmähdige Wiese", "Streuwiese"}
}

agl_candidate(p, y) if {
	agl_grass(p)
	p.mfa_use in {"Mähwiese/-weide zwei Nutzungen", "Mähwiese/-weide drei und mehr Nutzungen"}
	"AGL" in p.mfa_codes
	p.first_use == "Mahd"
	s := p.agl_survey
	s.longest_line
	s.edge_distance_m >= 5
	s.approx_two_m_wide
	survey_recorded(s)
	count(s.sections) > 0
	every section in s.sections { section_qualifies(section, y) }
}

agl_cap(y, mown_ha) := max([row.minimum_ha, mown_ha * row.share]) if {
	mown_ha >= 0
	some row in tab.agl_caps
	between_years(row, y)
}

agl_mown_ha := sum([p.area_ha | some p in input.land.parcels; agl_grass(p)]) if is_array(input.land.parcels)

agl_candidates[p.parcel_id] := {"ha": p.payable_ha, "eur_ha": r} if {
	in_term
	some p in input.land.parcels
	count(object.get(parcel_exclusions, p.parcel_id, set())) == 0
	p.area_ha >= p.payable_ha
	p.payable_ha >= 0
	agl_candidate(p, input.farm.year)
	r := agl_rate(input.farm.year, p.slope_percent)
}

agl_payable_area := min([agl_cap(input.farm.year, agl_mown_ha), sum([r.ha | some r in agl_candidates])]) if in_term

# Ohne Verteilungsregel für unterschiedlich tarifierte Flächen ist genau
# die Spanne der möglichen Beträge vor Modulation bestimmbar.
agl_amount_range := {"min_eur": (low * area) + ((high - low) * max([0, area - low_area])), "max_eur": (low * area) + ((high - low) * min([area, high_area]))} if {
	area := agl_payable_area
	rates := {r.eur_ha | some r in agl_candidates}
	count(rates) > 0
	low := min(rates)
	high := max(rates)
	low_area := sum([r.ha | some r in agl_candidates; r.eur_ha == low])
	high_area := sum([r.ha | some r in agl_candidates; r.eur_ha == high])
} else := {"min_eur": 0, "max_eur": 0} if agl_payable_area == 0

combination(a, b) := {"mark": cell.mark, "cell_notes": cell.footnotes, "row_column_notes": notes} if {
	some cell in tab.combination_matrix
	cell.row == a
	cell.column == b
	notes := [n | some n in tab.matrix_notes; applicable_matrix_note(n.number, a, b, cell)]
}

applicable_matrix_note(n, _, _, cell) if n in cell.footnotes
applicable_matrix_note(2, a, b, _) if "13" in {a, b}
applicable_matrix_note(4, a, b, _) if count({a, b} & {"8", "16"}) > 0

ceiling_rows(year) := [r | some r in tab.payment_ceilings; between_years(r, year)]
band_end(b, area) := area if b.up_to_ha == null

else := min([area, b.up_to_ha])

modulation(area) := sum([portion |
	some b in tab.modulation_bands
	portion := max([0, band_end(b, area) - b.above_ha]) * b.factor
]) / area if {
	area > 0
}

sanction_levels(y) := {r.level: r.before_2027 | some r in tab.sanctions} if {
	y >= 2023
	y < 2027
}

else := {r.level: r.from_2027 | some r in tab.sanctions} if y in {2027, 2028}

crop_members(group, y) := {r.name | some r in tab.crop_groups; r.group == group; r.from_year <= y}
program_list(group) := {r.name | some r in tab.program_groups; r.group == group}
public_exceptions(y) := {r.name | some r in tab.public_measures; between_years(r, y)}

switch_listed(a, b, y) if {
	some r in tab.switches
	r.source == a
	r.target == b
	y >= 2023
	y <= r.last_year
}

div_variant(code) := r.conditions if {
	some r in tab.div_variants
	r.code == code
}

div_change(a, b, d) if {
	date_ok(d)
	md := substring(d, 5, 5)
	md > "04-15"
	md <= "06-15"
	a == "DIVSZ"
	b in {"DIVNFZ", "DIVAGF"}
}

div_change(a, b, d) if {
	date_ok(d)
	md := substring(d, 5, 5)
	md > "04-15"
	md <= "08-15"
	a == "DIVNFZ"
	b == "DIVAGF"
}

district_matches(zone, _) if zone.district == "alle Bezirke"
district_matches(zone, p) if zone.district == p.district

drought_harvest_exception(p) if {
	input.farm.year == 2026
	p.land_use == "arable"
	p.harvest_drought.usual_late_harvest
	p.harvest_drought.heat_drought_affected
	p.harvest_drought.no_harvestable_stand
	date_ok(p.harvest_drought.assessment_date)
	startswith(p.harvest_drought.assessment_date, "2026-")
	some zone in tab.harvest_drought_districts
	p.harvest_drought.assessment_date >= zone.from_date
	zone.state == p.federal_state
	district_matches(zone, p)
}

# Für ein unvollständiges Ausgangsprofil werden nur belegte Einzelergebnisse
# ausgewiesen. Eine betriebliche Betragsprojektion verlangt vollständige
# Bezugsflächen und positive Zugangsprüfung.
premium_input_gaps contains {"bereich": "Betrieb", "angabe": "MFA-Schlagliste"} if not is_array(input.land.parcels)

premium_input_gaps contains {"bereich": "Schlag", "index": i, "angabe": "Inlands-MFA oder Nutzungsart"} if {
	some i, p in input.land.parcels
	not parcel_scope_known(p)
}

parcel_scope_known(p) if {
	is_boolean(p.in_austrian_mfa)
	is_string(p.land_use)
}

premium_input_gaps contains {"bereich": "Grünland", "index": i, "angabe": k} if {
	some i, p in input.land.parcels
	p.in_austrian_mfa
	p.land_use == "grassland"
	some k in {"area_ha", "payable_ha", "slope_percent"}
	not is_number(object.get(p, k, null))
}

premium_input_gaps contains {"bereich": "Grünland", "index": i, "angabe": "Mahd und MFA-Schlagnutzung"} if {
	some i, p in input.land.parcels
	p.in_austrian_mfa
	p.land_use == "grassland"
	not mowing_known(p)
}

mowing_known(p) if {
	is_boolean(p.mown)
	is_string(p.mfa_use)
}

premium_input_gaps contains {"bereich": "Grundprämie", "index": i, "angabe": k} if {
	some i, p in input.land.parcels
	p.in_austrian_mfa
	p.land_use == "grassland"
	is_number(p.slope_percent)
	p.slope_percent < 18
	p.payable_ha > 0
	some k in {"grassland_score", "payable_ban_union_ha"}
	not is_number(object.get(p, k, null))
}

premium_input_gaps contains {"bereich": "Grünland", "index": i, "angabe": "Förderfläche außerhalb der Schlagfläche"} if {
	some i, p in input.land.parcels
	p.in_austrian_mfa
	p.land_use == "grassland"
	p.payable_ha > p.area_ha
}

premium_input_gaps contains {"bereich": "Grundprämie", "index": i, "angabe": "Verbotsfläche über Förderfläche"} if {
	some i, p in input.land.parcels
	p.in_austrian_mfa
	p.land_use == "grassland"
	is_number(p.payable_ban_union_ha)
	p.payable_ban_union_ha > p.payable_ha
}

premium_input_gaps contains {"bereich": "AGL", "index": i, "angabe": "Jahrescodes"} if {
	some i, p in input.land.parcels
	agl_grass(p)
	p.mfa_use in {"Mähwiese/-weide zwei Nutzungen", "Mähwiese/-weide drei und mehr Nutzungen"}
	not is_array(p.mfa_codes)
}

premium_input_gaps contains {"bereich": "AGL", "index": i, "angabe": "Erhebungsdaten oder erste Nutzungsart"} if {
	some i, p in input.land.parcels
	agl_grass(p)
	"AGL" in p.mfa_codes
	p.mfa_use in {"Mähwiese/-weide zwei Nutzungen", "Mähwiese/-weide drei und mehr Nutzungen"}
	not survey_available(p)
}

survey_available(p) if {
	is_string(p.first_use)
	is_array(p.agl_survey.sections)
}

premium_projection := {
	"grundpraemie_eur": sum([v | some v in base_amounts]),
	"agl_ha": agl_payable_area,
	"agl_eur": agl_amount_range,
	"modulationsfaktor_heim": modulation(input.farm.home_area_ha),
} if {
	access_requirements_met
	count(premium_input_gaps) == 0
}

matrix_measure(code) := row if {
	some row in tab.matrix_measures
	row.code == code
}

combination_in_year(a, b, y) := combination(a, b) if {
	y >= matrix_measure(a).first_year
	y >= matrix_measure(b).first_year
	y <= 2028
	a != b
}

# Bei den expliziten Gattungsangaben umfasst die Kennart auch einen
# eindeutig bestimmten binomischen Namen dieser Gattung.
species_match(observed, row) if {
	some listed in row.scientific_names
	endswith(listed, " sp.")
	genus := trim_suffix(listed, " sp.")
	regex.match(sprintf("^%s [a-z][a-z-]+$", [genus]), observed)
}
