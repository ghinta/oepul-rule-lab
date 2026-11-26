package oepul.o6_15

import data.behirtung as tables
import rego.v1

year := input.farm.year
record := input.behirtung

# Ganzzahlige Kalendertage in UTC. Eine Periode ist rechts offen.
day(date) := time.parse_rfc3339_ns(concat("", [date, "T00:00:00Z"])) / 86400000000000
date_in_year(month_day) := sprintf("%d-%s", [year, month_day])

year_ok if {
	year >= 2023
	year <= 2028
}

age_months(a) := months if {
	birth := time.parse_rfc3339_ns(concat("", [a.birth_date, "T00:00:00Z"]))
	[y, m, d] := time.date(birth)
	offset := count({1 | d > 1})
	months := ((((year - y) * 12) + 7) - m) - offset
	months >= 0
}

breed_group(a) := "dwarf" if {
	a.species == "cattle"
	a.breed in tables.dwarf_breeds
}

else := "cattle" if {
	a.species == "cattle"
	is_string(a.breed)
	a.breed != ""
	not a.breed in tables.dwarf_breeds
}

else := "small_equids" if {
	a.species == "equids"
	a.breed_height_m > 0
	a.breed_height_m <= 1.48
	a.breed_weight_kg > 0
	a.breed_weight_kg <= 300
}

else := "large_equids" if {
	a.species == "equids"
	a.breed_height_m > 1.48
}

else := "large_equids" if {
	a.species == "equids"
	a.breed_weight_kg > 300
}

else := a.species if a.species in {"camelids", "goats", "sheep"}

factor(a) := r.factor if {
	some r in tables.rgve
	r.group == breed_group(a)
	months := age_months(a)
	months >= r.from_months
	below_limit(months, r.until_months)
}

below_limit(n, limit) if {
	is_number(limit)
	n < limit
}

below_limit(_, limit) if limit == null

milk_age_ok(a) if {
	a.species == "cattle"
	age_months(a) >= 24
	day(a.first_calving) <= day(date_in_year("07-01"))
}

milk_age_ok(a) if {
	a.species in {"sheep", "goats"}
	age_months(a) >= 12
}

dairy(a) if {
	milk_age_ok(a)
	count({d | some s in a.stays; some date in s.milking_dates; d := day(date); d in actual_days(s)}) >= 45
}

stay_category(a, s) := "dairy_cows" if {
	a.species == "cattle"
	dairy(a)
	milk_flag_valid(a, s)
}

else := "other_cattle" if a.species == "cattle"

else := a.species if a.species in tables.categories

report_channel(a) := reporting_by_species[a.species].channel
report_window(a) := reporting_by_species[a.species].days
arrival_ok(a) if {
	min([day(s.arrival) | some s in a.stays]) <= day(date_in_year("07-15"))
}

actual_days(s) := {d |
	first := max([day(s.arrival), day(date_in_year("01-01"))])
	last := min([day(s.departure) - 1, day(date_in_year("12-31"))])
	last >= first
	some d in numbers.range(first, last)
}

stay_days(a, s) := {d |
	s.channel == report_channel(a)
	some d in actual_days(s)
	d >= day(s.arrival_report) - report_window(a)
}

departure_ok(a, s) if {
	a.species in {"equids", "camelids"}
	s.expected_departure == s.departure
}

departure_ok(a, s) if {
	delta := day(s.departure_report) - day(s.departure)
	delta >= 0
	delta <= report_window(a)
}

flag_timely(a, s, when) if {
	a.species == "cattle"
	delta := day(when) - day(s.arrival)
	delta >= 0
	delta <= report_window(a)
}

flag_timely(a, s, when) if {
	a.species in {"sheep", "goats"}
	delta := day(when) - day(s.arrival)
	delta >= 0
	delta <= report_window(a)
	day(when) <= day(date_in_year("07-15"))
}

identification_ok(a) if {
	a.species in {"goats", "sheep"}
	a.count == 1
	is_string(a.ear_tag)
	a.ear_tag != ""
}

alp_by_id(id) := p if {
	some p in record.alps
	p.id == id
}

herded_on(a, s) if {
	s.herded
	p := alp_by_id(s.alp_id)
	p.in_austria
	stay_category(a, s) in p.categories
}

herded_days(a) := {d | some s in a.stays; herded_on(a, s); some d in stay_days(a, s)}
alpine_days(a) := {d | some s in a.stays; some d in stay_days(a, s)}
days_on(a, id) := {d | some s in a.stays; s.alp_id == id; herded_on(a, s); some d in stay_days(a, s)}
stocked_days(p) := {d | some a in record.animals; reporting_by_species[a.species]; some s in a.stays; s.alp_id == p.id; some d in actual_days(s)}

category_complete(p) if {
	every c in p.categories { c in tables.categories }
	every a in record.animals {
		every s in a.stays { category_duty(a, s, p) }
	}
}

category_duty(_, s, p) if s.alp_id != p.id

category_duty(a, s, p) if {
	s.alp_id == p.id
	not stay_category(a, s) in p.categories
}

category_duty(_, s, _) if s.herded

credited_rgve(a, p) := ((factor(a) * a.count) * count(days_on(a, p.id))) / count(alpine_days(a)) if {
	arrival_ok(a)
	count(herded_days(a)) >= 60
	count(stocked_days(p)) >= 60
	count(days_on(a, p.id)) > 0
	application_identity_ok(a)
	a.count > 0
	a.count == floor(a.count)
}

units(p) := sum([n | some a in record.animals; n := credited_rgve(a, p)])

milk_flag_valid(a, s) if {
	a.claimed_milk
	object.get(s, "milk_flag_added", null) == null
}

milk_flag_valid(a, s) if {
	a.claimed_milk
	flag_timely(a, s, s.milk_flag_added)
}

milk_units(p) := sum([n |
	some a in record.animals
	dairy(a)
	credit := credited_rgve(a, p)
	valid_days := {d | some s in a.stays; s.alp_id == p.id; herded_on(a, s); milk_flag_valid(a, s); some d in stay_days(a, s)}
	n := (credit * count(valid_days)) / count(days_on(a, p.id))
])

access if {
	year_ok
	record.almbewirtschaftung
	sum([n | some p in record.alps; p.applicant_alp; n := units(p)]) >= 3
}

boundary(p) if p.visible_management_difference
boundary(p) if p.clear_boundary
site(p) if p.in_alpine_register
site(p) if p.in_alpine_region

is_alp(p) if {
	site(p)
	boundary(p)
	p.grazed_forage_vegetation
	p.managed_from_home == false
}

night_ok(p) if p.night_care_needed == false
night_ok(p) if p.night_care_provided

care_ok(p) if {
	p.daily_care
	p.substantial_part_of_day
	night_ok(p)
	p.adequate_water
	p.animal_care
	p.treatment_arranged
	p.safety_measures
	p.site_adapted_grazing
	p.suitable_lodging
}

unique_herders(p) if {
	count(p.herder_ids) == count({h | some h in p.herder_ids})
	every h in p.herder_ids {
		count({q.id | some q in record.alps; h in q.herder_ids}) == 1
	}
}

dog_ok(d, p) if {
	d.trained_for_herd_protection
	d.permanent_herd_member
	d.day_and_night
	d.independent
	d.recognised_certificate_on_farm
	d.liability_insured
	d.id in p.claimed_dog_ids
	count({q.id | some q in record.alps; d.id in q.claimed_dog_ids}) == 1
	herd_days := {n | some a in record.animals; some s in a.stays; s.herd_id == d.herd_id; s.alp_id == p.id; herded_on(a, s); some n in actual_days(s)}
	deployed := {n | some span in d.deployments; span.alp_id == p.id; some n in actual_days(span)}
	count(deployed) >= 60
	count(herd_days) >= 60
	count(herd_days - deployed) == 0
}

prior_application(date, last_year) if {
	year_ok
	year <= last_year
	day(date) <= day(sprintf("%d-12-31", [year - 1]))
}

entry_timely if prior_application(record.entry_application, 2027)
dog_entry_timely if prior_application(record.dog_entry_application, 2028)
list_deadline := date_in_year("07-17") if year in {2023, 2028}

else := date_in_year("07-15")

list_timely(p) if day(p.list_submitted) <= day(list_deadline)

# Zuerst 50er-Blöcke füllen, innerhalb jedes Blocks bis zu 20 erhöhte Einheiten.
high_units(n) := (floor(n / 50) * 20) + min([n - (floor(n / 50) * 50), 20])

rate := r if {
	year_ok
	some r in tables.rates
	year >= r.from_year
	year <= r.to_year
}

premium(n, m, h, d) := amount if {
	n >= 0
	m >= 0
	m <= n
	h == floor(h)
	d == floor(d)
	h >= 0
	d >= 0
	paid := min([n, 50 * h])
	milk := min([m, paid])
	base_high := high_units(paid)
	milk_high := high_units(milk)
	base_tenths := (base_high * round(10 * rate.base_high)) + ((paid - base_high) * round(10 * rate.base_low))
	milk_tenths := (milk_high * round(10 * rate.milk_high)) + ((milk - milk_high) * round(10 * rate.milk_low))
	amount := ((base_tenths + milk_tenths) + ((min([d, 5]) * rate.dog) * 10)) / 10
}

modulation(p) := sum([part | some r in tables.modulation; basis := min([p.stocked_rgve, p.area_ha]); basis > 0; width := max([0, min([basis, object.get(r, "until", basis)]) - r.start]); part := width * r.factor]) / min([p.stocked_rgve, p.area_ha]) if {
	p.stocked_rgve > 0
	p.area_ha > 0
}

topup(p) := 40 * high_units(min([milk_units(p), 50 * count(p.herder_ids)])) if {
	record.state_topup.granted
	record.state_topup.funds_timely
	day(record.state_topup.notification) <= day(date_in_year("05-15"))
}

else := 0 if milk_units(p) == 0

else := 0 if record.state_topup.granted == false

else := 0 if record.state_topup.funds_timely == false

else := 0 if day(record.state_topup.notification) > day(date_in_year("05-15"))

# Beträge vor behördlicher Beurteilung, nur für die Almen des Antragstellers.
amounts[p.id] := {"rgve": n, "milk_rgve": m, "dogs": d, "gross_eur": gross, "state_topup_eur": extra, "modulation": f, "modulated_eur": (gross + extra) * f} if {
	some p in record.alps
	p.applicant_alp
	contract_current
	size_ok
	applicant_ok
	access
	p.in_austria
	is_alp(p)
	care_ok(p)
	category_complete(p)
	unique_herders(p)
	consistent_herd_records
	count(p.herder_ids) > 0
	list_timely(p)
	n := units(p)
	n > 0
	m := milk_units(p)
	d := count({dog.id | some dog in record.dogs; dog_ok(dog, p); dog_contract})
	gross := premium(n, m, count(p.herder_ids), d)
	extra := topup(p)
	f := modulation(p)
}

dog_contract if record.dog_option_active
dog_contract if dog_entry_timely

application_identity_ok(a) if a.species in {"cattle", "equids", "camelids"}
application_identity_ok(a) if identification_ok(a)

contract_basis if entry_timely
contract_basis if record.contract_continued
contract_basis if record.reentry_accepted_by_ama

contract_basis if {
	transfer_possible
	record.transfer.approved
}

contract_current if {
	year_ok
	contract_basis
	record.withdrawn_this_year == false
	record.annual_mfa
}

# Hinweise auf Meldepflichten sind getrennt von der rückwirkenden Tagesanrechnung.
report_findings contains {"animal": a.id, "alp": s.alp_id, "rule": "o6_15.channel"} if {
	some a in record.animals
	some s in a.stays
	s.channel != report_channel(a)
}

report_findings contains {"animal": a.id, "alp": s.alp_id, "rule": r} if {
	some a in record.animals
	some s in a.stays
	day(s.arrival_report) - day(s.arrival) > report_window(a)
	r := {"cattle": "o6_15.cattlereport", "sheep": "o6_15.smallreport", "goats": "o6_15.smallreport", "equids": "o6_15.countreport", "camelids": "o6_15.countreport"}[a.species]
}

report_findings contains {"animal": a.id, "alp": s.alp_id, "rule": r} if {
	some a in record.animals
	some s in a.stays
	not departure_ok(a, s)
	r := {"cattle": "o6_15.cattlereport", "sheep": "o6_15.smallreport", "goats": "o6_15.smallreport", "equids": "o6_15.departure", "camelids": "o6_15.departure"}[a.species]
}

report_findings contains {"animal": a.id, "alp": s.alp_id, "rule": r} if {
	some a in record.animals
	some s in a.stays
	is_string(s.milk_flag_added)
	not flag_timely(a, s, s.milk_flag_added)
	r := {"cattle": "o6_15.cowflag", "sheep": "o6_15.smallflag", "goats": "o6_15.smallflag"}[a.species]
}

report_findings contains {"animal": a.id, "rule": "o6_15.calving"} if {
	some a in record.animals
	a.species == "cattle"
	a.claimed_milk
	not dairy(a)
}

# Eindeutige Tier- und Almkennungen verhindern doppelte Gutschriften.
consistent_herd_records if {
	count(record.animals) == count({a.id | some a in record.animals})
	count(record.alps) == count({p.id | some p in record.alps})
	every a in record.animals {
		every s in a.stays {
			alp_by_id(s.alp_id)
			day(s.departure) > day(s.arrival)
		}
		not overlapping_alps(a)
	}
}

overlapping_alps(a) if {
	some s in a.stays
	some t in a.stays
	s.alp_id != t.alp_id
	day(s.arrival) < day(t.departure)
	day(t.arrival) < day(s.departure)
}

# Bei unmittelbarem Wiederanschluss nach Vertragsverlust unterscheidet sich
# der Antragsweg vor und nach dem 31. Dezember des Verlustjahres.
reentry_steps(expiry_year, desired_year, as_of) := ["Maßnahmenantrag im Mehrfachantrag"] if {
	desired_year == expiry_year + 1
	desired_year <= 2027
	day(as_of) <= day(sprintf("%d-12-31", [expiry_year]))
}

reentry_steps(expiry_year, desired_year, as_of) := ["Online-Korrektur des vorhergehenden Maßnahmenantrags", "Gesondertes schriftliches Ersuchen an die AMA"] if {
	desired_year == expiry_year + 1
	desired_year <= 2027
	day(as_of) > day(sprintf("%d-12-31", [expiry_year]))
}

withdrawal_effective_in(date) := y if {
	[y, _, _] := time.date(time.parse_rfc3339_ns(concat("", [date, "T00:00:00Z"])))
}

category_shortfalls contains {"alp": p.id, "category": stay_category(a, s), "animal": a.id} if {
	some p in record.alps
	some a in record.animals
	some s in a.stays
	s.alp_id == p.id
	s.herded == false
	stay_category(a, s) in p.categories
}

reporting_by_species[row.species] := row if some row in tables.reporting
