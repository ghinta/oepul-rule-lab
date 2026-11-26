package oepul.o6_20

import data.weide_tables as t
import rego.v1

# Tagesnummer in UTC. Alle Zeiträume haben inklusive Grenzen.
day(date) := time.parse_rfc3339_ns(concat("", [date, "T00:00:00Z"])) / 86400000000000

year_date(year, suffix) := sprintf("%d-%s", [year, suffix])
season_start := day(year_date(input.farm.year, "04-01"))
season_end := day(year_date(input.farm.year, "10-31"))
season_length := (season_end - season_start) + 1

period_days(periods) := {d |
	some p in periods
	lo := max([season_start, day(p.start)])
	hi := min([season_end, day(p.end)])
	lo <= hi
	some d in numbers.range(lo, hi)
}

completed_months(birth, d) := months if {
	[y, m, n] := time.date(d * 86400000000000)
	[by, bm, bn] := time.date(day(birth) * 86400000000000)
	months := (((12 * (y - by)) + m) - bm) - to_number_before(n, bn)
}

to_number_before(a, b) := 1 if a < b

else := 0

below_upper(_, null) := true

below_upper(age, upper) if {
	is_number(upper)
	age < upper
}

matches_sex(row, _) if row.sex == "any"
matches_sex(row, a) if row.sex == a.sex

category(a, d) := row.id if {
	some row in t.categories
	row.species == a.species
	matches_sex(row, a)
	age := completed_months(a.birth_date, d)
	age >= row.min_months
	below_upper(age, row.max_months_exclusive)
}

factor_class(a) := "dwarf_cattle" if {
	a.species == "cattle"
	a.breed in t.dwarf_breeds
} else := "cattle" if {
	a.species == "cattle"
	is_string(a.breed)
	a.breed != ""
} else := "small_equid" if {
	a.species == "equid"
	is_number(a.breed_height_m)
	is_number(a.breed_adult_kg)
	a.breed_height_m <= 1.48
	a.breed_adult_kg <= 300
} else := "large_equid" if {
	a.species == "equid"
	is_number(a.breed_height_m)
	a.breed_height_m > 1.48
} else := "large_equid" if {
	a.species == "equid"
	is_number(a.breed_adult_kg)
	a.breed_adult_kg > 300
} else := a.species if a.species in {"camelid", "goat", "sheep"}

factor_row(a, d) := row if {
	some row in t.rgve
	row.group == factor_class(a)
	age := completed_months(a.birth_date, d)
	age >= row.min_months
	below_upper(age, row.max_months_exclusive)
}

factor(a, d) := factor_row(a, d).rgve

required_days(false) := 120
required_days(true) := 150
april_deadline(y) := year_date(y, "04-17") if y in {2023, 2028}

else := year_date(y, "04-15")

entry_on_time(y, date) if {
	y >= 2023
	y <= 2027
	day(date) <= day(year_date(y - 1, "12-31"))
}

movement_deadline(date) := min([day(date) + 7, season_end]) if {
	day(date) > season_start
	day(date) <= season_end
}

credit_start(event, report) := max([day(event), day(report) - 7])

# Eine Zeile je tatsächlich vorhandenem Tier. Aufenthalte grenzen die Zurechnung zum Betrieb ab.
presence(a, c) := {d |
	some p in a.stays
	p.country == "AT"
	p.farm_id == input.farm.farm_id
	some d in period_days([p])
	category(a, d) == c
}

# Bei vorab gemeldeten Jungtieren hält die Kategorieprüfung das Mindestalter ein.
registered_at(a, _, _) if a.species == "cattle"

registered_at(a, p, d) if {
	a.species in {"sheep", "goat"}
	day(p.start) <= season_start
	object.get(p, "entry_event", "stock") != "age_threshold"
	day(p.reported_on) <= day(april_deadline(input.farm.year))
	d >= max([day(p.start), season_start])
}

registered_at(a, p, d) if {
	a.species in {"sheep", "goat"}
	day(p.start) > season_start
	object.get(p, "entry_event", "purchase") != "age_threshold"
	day(p.reported_on) <= season_end
	d >= credit_start(p.start, p.reported_on)
}

# Meldung beim Hineinwachsen eines nicht vorangemeldeten, bereits gehaltenen Jungtiers.
registered_at(a, p, d) if {
	a.species in {"sheep", "goat"}
	p.entry_event == "age_threshold"
	day(p.category_entry) > season_start
	day(p.reported_on) <= season_end
	d >= credit_start(max_date(p.start, p.category_entry), p.reported_on)
}

max_date(a, b) := a if day(a) >= day(b)

else := b

registered_days(a, c) := {d |
	not c in a.withdrawn_categories
	some p in a.stays
	p.country == "AT"
	p.farm_id == input.farm.farm_id
	some d in period_days([p])
	category(a, d) == c
	registered_at(a, p, d)
}

grazing_days(a, c) := (period_days(a.grazing) & presence(a, c)) - period_days(a.interruptions)

animals := input.livestock.weide_animals
claims := input.farm.weide_categories

claim(c) := x if {
	some x in claims
	x.category == c
}

individual_species := {"cattle", "sheep", "goat"}

participating_days(a, c) := registered_days(a, c) if a.species in individual_species

else := presence(a, c) if {
	a.species in {"equid", "camelid"}
	not c in a.withdrawn_categories
	some line in input.livestock.weide_count_claims
	line.category == c
	some slot in line.slots
	a.id in slot
}

category_presence(c) := {d | some a in animals; some d in participating_days(a, c)}

female_pair := {"heifer", "cow"}
female_pair_days(a, c) := {d |
	c in female_pair
	every f in female_pair { claim(f) }
	some f in female_pair
	some d in participating_days(a, f)
}

presence_ok(c) if count(category_presence(c)) >= required_days(claim(c).bonus)

presence_ok(c) if {
	some a in animals
	count(participating_days(a, c)) > 0
	count(female_pair_days(a, c)) >= required_days(claim(c).bonus)
}

# Planmäßige Weidetage der zugehörigen Gruppe (inklusive Alpung und Fremdweide).
# Nur nachgewiesene alters- oder abgangsbedingte Verkürzung erlaubt anteilige Anrechnung.
short_service_ok(a, c) if {
	a.short_reason_by_category[c] in {"age", "registered_departure"}
	planned := period_days(a.group_grazing[c])
	count(planned) >= required_days(claim(c).bonus)
	due := planned & presence(a, c)
	count(due - grazing_days(a, c)) == 0
}

day_requirement_ok(a, c) if {
	count(grazing_days(a, c) & registered_days(a, c)) >= required_days(claim(c).bonus)
}

day_requirement_ok(a, c) if short_service_ok(a, c)

individual_rgve(a, c) := rgve_days(a, c) / season_length

rgve_days(a, c) := sum([factor(a, d) | some d in registered_days(a, c)]) if {
	a.species in individual_species
	count(registered_days(a, c)) > 0
	day_requirement_ok(a, c)
	every d in registered_days(a, c) { is_number(factor(a, d)) }
}

animal(id) := a if {
	some a in animals
	a.id == id
}

valid_slot_member(a, line) if {
	not line.category in a.withdrawn_categories
	some d in presence(a, line.category)
	factor_row(a, d).band == line.band
}

# Je beantragtem Platz werden bei Ersatz nur die Tage nach dem Abgang des Vorgängers angerechnet.
replacement_ok(old, new, c) if {
	c in {"equid", "camelid"}
	old.departure_reason in {"sale", "slaughter", "death"}
	category(new, season_end) == c
	not category(new, season_start - 1)
	max(presence(new, c)) > max(presence(old, c))
}

# Beispiel auf S. 11: Hineinwachsen in die angemeldete Gruppe der mindestens dreijährigen Pferde.
replacement_for_line(old, new, line) if replacement_ok(old, new, line.category)

replacement_for_line(old, new, line) if {
	line.category == "equid"
	old.departure_reason in {"sale", "slaughter", "death"}
	factor_row(new, season_end).band == line.band
	factor_row(new, season_start - 1).band != line.band
	max(presence(new, "equid")) > max(presence(old, "equid"))
}

slot_ok(line, slot) if {
	count(slot) > 0
	count({id | some id in slot}) == count(slot)
	every id in slot { valid_slot_member(animal(id), line) }
	every i, id in slot { valid_predecessor(slot, i, id, line) }
	days := {d |
		some i, id in slot
		a := animal(id)
		some d in grazing_days(a, line.category)
		after_predecessor(slot, i, d, line.category)
		factor_row(a, d).band == line.band
	}
	count(days) >= required_days(claim(line.category).bonus)
}

valid_predecessor(_, 0, _, _) := true

valid_predecessor(slot, i, id, line) if {
	i > 0
	replacement_for_line(animal(slot[i - 1]), animal(id), line)
}

after_predecessor(_, 0, _, _) := true

after_predecessor(slot, i, d, c) if {
	i > 0
	d > max(presence(animal(slot[i - 1]), c))
}

payable_count(line) := min([line.applied_count, count([1 | some slot in line.slots; slot_ok(line, slot)])]) if {
	day(line.filed_on) <= day(april_deadline(input.farm.year))
	line.applied_count >= 0
	line.applied_count == floor(line.applied_count)
	line.category in {"equid", "camelid"}
	count(all_slot_ids) == count({id | some id in all_slot_ids})
}

all_slot_ids := [id | some line in input.livestock.weide_count_claims; some slot in line.slots; some id in slot]

count_rgve(line) := payable_count(line) * row.rgve if {
	some row in t.rgve
	row.band == line.band
}

# Die Schwelle auf der ungerundeten Summe prüfen. Erst nach Summierung durch 214 teilen.
weighted_days(c) := sum([rgve_days(a, c) | some a in animals]) + (season_length * sum([count_rgve(line) | some line in input.livestock.weide_count_claims; line.category == c])) if presence_ok(c)
category_rgve(c) := weighted_days(c) / season_length

total_rgve := sum([v | some x in claims; v := weighted_days(x.category)]) / season_length if {
	is_array(claims)
	is_array(animals)
	is_array(input.livestock.weide_count_claims)
}

farm_minimum if total_rgve >= 2

base_multiplier(species, alpine, coupled) := 0.5 if {
	species in individual_species
	alpine == true
	coupled == true
} else := 1 if {
	is_boolean(alpine)
	is_boolean(coupled)
}

premium_band(rgve, bonus, multiplier) := {bound: amount |
	some bound in {"min", "max"}
	amount := rgve * ((t.premium.base[bound] * multiplier) + option_rate(bonus, bound))
}

option_rate(false, _) := 0
option_rate(true, bound) := t.premium.bonus[bound]

# Bruttoband nach der betrieblichen und kategorieweisen Mindestteilnahme, vor Sanktionen.
individual_amount(a, c, b) := premium_band(individual_rgve(a, c), claim(c).bonus, base_multiplier(a.species, a.alpine, a.coupled))[b]
count_amount(line, b) := premium_band(count_rgve(line), claim(line.category).bonus, 1)[b]

gross_band := {b: amount |
	farm_minimum
	some b in {"min", "max"}
	individuals := [individual_amount(a, c, b) | some a in animals; some x in claims; c := x.category; presence_ok(c)]
	counted := [count_amount(line, b) | some line in input.livestock.weide_count_claims; presence_ok(line.category)]
	amount := sum(individuals) + sum(counted)
} if {
	farm_minimum
	input.farm.year >= 2023
	input.farm.year <= 2028
}

birth_group_ok(total, stall, bonus, documented) if {
	documented == true
	stall >= 0
	total - stall >= required_days(bonus)
}

welfare_findings contains {"group": i, "obligation": code} if {
	some i, g in input.livestock.species_groups
	p := g.housing.pasture
	p.weide_participating == true
	some code in {"water_availability", "forage_predominantly_grazed", "substantial_day_or_night"}
	p[code] == false
}

welfare_findings contains {"group": i, "obligation": "shelter"} if {
	some i, g in input.livestock.species_groups
	p := g.housing.pasture
	p.weide_participating == true
	p.shelter == false
	p.rapid_return == false
}

# Zwischenwerte und Handlungsbedarf je beantragter Kategorie.
category_results[c] := {"days_required": target, "presence_ok": enough, "qualifying_rgve": v} if {
	some x in claims
	c := x.category
	target := required_days(x.bonus)
	enough := presence_status(c)
	v := candidate_rgve(c)
}

presence_status(c) if presence_ok(c)

else := false

candidate_rgve(c) := v if v := category_rgve(c)

else := 0

report_actions contains {"animal": a.id, "category": c, "action": action} if {
	some a in animals
	a.species in individual_species
	some x in claims
	c := x.category
	count(registered_days(a, c)) > 0
	not day_requirement_ok(a, c)
	action := removal_method(a.species)
}

removal_method("cattle") := "eAMA_Ohrmarke_unverzueglich_abmelden"
removal_method(s) := "bei_Verbleib_loeschen_bei_echtem_Abgang_melden" if s in {"sheep", "goat"}

report_actions contains {"category": line.category, "band": line.band, "action": "Stueckzahl_reduzieren", "count": n} if {
	some line in input.livestock.weide_count_claims
	n := payable_count(line)
	n < line.applied_count
}

# Nur der ausdrücklich festgehaltene Sachverhalt löst den Prüfhinweis aus.
drought_review if {
	input.farm.year == 2026
	input.farm.weide_drought.affected
	input.farm.weide_drought.on_site_control
}

diary_findings contains {"entry": i, "field": field} if {
	some i, entry in input.documentation.weide_diary
	some field in {"group", "places", "start", "end"}
	object.get(entry, field, null) in {null, "", []}
}

diary_findings contains {"entry": i, "field": "change_recorded_on"} if {
	some i, entry in input.documentation.weide_diary
	some change in entry.significant_changes
	change.date != change.recorded_on
}

diary_findings contains {"entry": i, "field": "interruption"} if {
	some i, entry in input.documentation.weide_diary
	some event in entry.interruptions
	not interruption_record_ok(event)
}

interruption_record_ok(e) if {
	is_string(e.reason)
	e.reason != ""
	is_string(e.date)
	is_string(e.animal_id)
	e.animal_id != ""
}

interruption_record_ok(e) if {
	e.species in {"sheep", "goat"}
	e.reason == "birth"
	e.stalled_count > 0
	birth_group_ok(e.group_days, e.stall_days, e.bonus, true)
}

movement_action(e) := "nur_Weidetagebuch" if {
	e.species in {"sheep", "goat"}
	e.temporary_pasture
	e.control_retained_or_temporary_care
} else := "keine_Weidebeilagenmeldung" if {
	e.species in {"sheep", "goat"}
	day(e.date) > season_end
} else := "Zugang_melden" if {
	e.species in {"sheep", "goat"}
	movement_deadline(e.date)
	e.type in {"purchase", "age_entry"}
	e.predeclared == false
} else := "Abgang_melden" if {
	e.species in {"sheep", "goat"}
	movement_deadline(e.date)
	e.type in {"sale", "death", "slaughter"}
}

movement_results contains result if {
	some e in input.livestock.weide_movements
	action := movement_action(e)
	result := {"animal": e.animal_id, "date": e.date, "action": action}
}

modulated_band := {b: value |
	some b in {"min", "max"}
	value := gross_band[b] * modulation(input.land.home_mfa_ha)
}

# Durchgehende Mitweide derselben Kalbin in beiden beantragten Alterskategorien.
day_requirement_ok(a, c) if {
	c in female_pair
	every f in female_pair { claim(f) }
	count(registered_days(a, c)) > 0
	grazed := {d | some f in female_pair; some d in (grazing_days(a, f) & registered_days(a, f))}
	count(grazed) >= required_days(claim(c).bonus)
}

continued_or_new_contract(x) if {
	x.renewal == true
	x.eligible_previous_year == true
}

continued_or_new_contract(x) if entry_on_time(input.farm.year, x.entry_filed_on)

continued_or_new_contract(x) if {
	x.recognition_of_late_application == true
	x.written_request_filed == true
	input.farm.year <= 2027
	day(x.entry_filed_on)
}

withdrawn_for_year(x) if {
	time.date(day(x.withdrawal_on) * 86400000000000)[0] == input.farm.year
}

effective_bonus(x) := false if x.bonus == false

else := false if x.bonus_removed == true

else if {
	x.bonus == true
	day(x.bonus_filed_on) <= day(april_deadline(input.farm.year))
} else := false if {
	x.bonus == true
	day(x.bonus_filed_on) > day(april_deadline(input.farm.year))
}

effective_claims := [corrected |
	some x in claims
	some row in t.categories
	row.id == x.category
	continued_or_new_contract(x)
	not withdrawn_for_year(x)
	x.payment_application_filed == true
	corrected := object.union(x, {"bonus": effective_bonus(x)})
]

# Nur auswerten, wenn Kerndaten vorliegen. Prüfergebnisse und Beträge bleiben getrennt.
assessment := {"categories": cats, "rgve": v, "minimum_met": enough, "actions": actions, "welfare_findings": welfare_findings, "diary_findings": diary_findings, "modulated_range_before_sanctions_eur": band} if {
	y := input.farm.year
	y >= 2023
	y <= 2028
	operator_ok
	area_ok
	is_array(claims)
	is_array(animals)
	is_array(input.livestock.weide_count_claims)
	complete_records
	is_number(input.land.home_mfa_ha)
	xs := effective_claims
	cats := category_results with claims as xs
	v := total_rgve with claims as xs
	enough := v >= 2
	actions := report_actions with claims as xs
	band := assessment_band(v, xs)
}

assessment_band(v, _) := {"min": 0, "max": 0} if v < 2

assessment_band(v, xs) := b if {
	v >= 2
	b := modulated_band with claims as xs
}

complete_records if {
	count(claims) == count({x.category | some x in claims})
	every x in claims {
		is_boolean(x.bonus)
		is_boolean(x.renewal)
		is_boolean(x.payment_application_filed)
		known_contract_facts(x)
		is_boolean(effective_bonus(x))
		some r in t.categories
		r.id == x.category
		object.get(x, "withdrawal_on", "missing") != "missing"
	}
	count(animals) == count({a.id | some a in animals})
	every a in animals {
		is_string(a.birth_date)
		day(a.birth_date)
		is_array(a.stays)
		is_array(a.grazing)
		is_array(a.interruptions)
		is_array(a.withdrawn_categories)
		sex_known(a)
		every p in a.stays { valid_period(p); is_string(p.country); is_string(p.farm_id); known_registration(a, p)}
		every p in array.concat(a.grazing, a.interruptions) { valid_period(p) }
		factor_class(a)
		is_boolean(a.alpine)
		is_boolean(a.coupled)
	}
	count(all_slot_ids) == count({id | some id in all_slot_ids})
	every line in input.livestock.weide_count_claims {
		is_number(line.applied_count)
		line.applied_count >= 0
		line.applied_count == floor(line.applied_count)
		day(line.filed_on)
		is_array(line.slots)
		some row in t.rgve
		row.band == line.band
		correct_count_group(line.category, row.group)
		every slot in line.slots { is_array(slot); every id in slot { animal(id) }}
	}
}

correct_count_group("equid", g) if g in {"small_equid", "large_equid"}
correct_count_group("camelid", "camelid") := true
valid_period(p) if day(p.start) <= day(p.end)
sex_known(a) if a.species in {"camelid", "equid"}
sex_known(a) if a.sex in {"female", "male"}
known_registration(a, _) if not a.species in {"sheep", "goat"}
known_registration(_, p) if object.get(p, "reported_on", "missing") != "missing"

known_contract_facts(x) if {
	x.renewal == true
	is_boolean(x.eligible_previous_year)
}

known_contract_facts(x) if {
	x.renewal == false
	object.get(x, "entry_filed_on", "missing") != "missing"
}

vis_findings contains {"animal": e.animal_id, "action": "VIS_Tierbewegung_melden"} if {
	some e in input.livestock.weide_movements
	e.species in {"sheep", "goat"}
	e.type in {"purchase", "sale", "live_arrival", "live_departure"}
	e.vis_reported == false
}

vis_findings contains {"animal": a.id, "action": "UELN_erforderlich"} if {
	some a in animals
	a.species == "equid"
	object.get(a, "ueln", null) in {null, ""}
}

vis_findings contains {"animal": a.id, "action": field} if {
	some a in animals
	a.species == "equid"
	some field in {"vis_reported", "equine_database_reported"}
	a[field] == false
}

movement_findings contains {"animal": e.animal_id, "action": "verspaetete_Beilagenmeldung", "deadline": date_string(due)} if {
	some e in input.livestock.weide_movements
	movement_action(e) in {"Zugang_melden", "Abgang_melden"}
	due := movement_deadline(e.date)
	day(e.reported_on) > due
}

movement_findings contains {"animal": e.animal_id, "action": "Abtrieb_automatisch"} if {
	some e in input.livestock.weide_movements
	movement_action(e) == "Abgang_melden"
	e.alpine_or_common == true
	day(e.reported_on)
}

date_string(d) := time.format([d * 86400000000000, "UTC", "2006-01-02"])

administrative_findings contains {"category": x.category, "action": "Kategorie_fuer_Folgejahr_neu_beantragen"} if {
	some x in effective_claims
	xs := effective_claims
	v := candidate_rgve(x.category) with claims as xs
	v == 0
}

administrative_findings contains {"category": x.category, "action": "Zuschlag_im_MFA_korrigieren"} if {
	some x in claims
	x.bonus == true
	x.bonus_removed == false
	x.category_grazing_ended == true
	is_array(x.category_grazing)
	days := period_days(x.category_grazing)
	count(days) >= 120
	count(days) < 150
}

administrative_findings contains {"category": x.category, "action": "Tierangaben_im_Zahlungsantrag_ergaenzen"} if {
	some x in claims
	x.payment_application_filed == false
	not withdrawn_for_year(x)
}

administrative_findings contains {"category": x.category, "action": "Wiedereinstieg_schriftliches_Ersuchen"} if {
	some x in claims
	x.eligible_previous_year == false
	x.written_request_filed == false
	day(x.entry_filed_on) > day(year_date(input.farm.year - 1, "12-31"))
	input.farm.year <= 2027
}

sanction_effect(y, level, full_cuts) := {"exclude": true, "reclaim_contract_premiums": true, "reduction_percent": 100} if {
	level == "cut_100"
	full_cuts >= 2
	t.sanctions.second_full_cut == "exclude_and_reclaim"
} else := {"exclude": false, "reclaim_contract_premiums": false, "reduction_percent": sanction_rate(y, level)}
