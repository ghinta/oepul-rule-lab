package oepul.o6_21

import rego.v1

cfg := data.o6_21_tables
claim := input.o6_21
year := input.farm.year
day_ns := 86400000000000

day(date) := time.parse_rfc3339_ns(sprintf("%sT00:00:00Z", [date])) / day_ns
jan(y) := day(sprintf("%04d-01-01", [y]))
days_in_year := jan(year + 1) - jan(year)

# Register intervals run from the first through the last attributed day.
# Age bands use calendar anniversaries of the registered date of birth.
category(sex, months) := row.code if {
	months >= 0
	some row in cfg.categories
	row.sex == sex
	months >= row.from_month
	below_limit(months, row.until_month)
}

below_limit(n, limit) if {
	is_number(n)
	limit == null
}

below_limit(n, limit) if {
	is_number(limit)
	n < limit
}

breed_class(breed) := "dwarf" if lower(breed) in cfg.dwarf_breeds

else := "standard" if {
	is_string(breed)
	breed != ""
}

rgve_per_head(breed, months) := row.factor if {
	some row in cfg.cattle_rgve
	row.class == breed_class(breed)
	months >= row.from_month
	below_limit(months, row.until_month)
}

milk_allows(code) if code != "female_6_24"
milk_allows("female_6_24") if claim.dairy_delivery == false

register_valid if {
	is_number(year)
	year == floor(year)
	year >= 2023
	year <= 2028
	is_array(claim.cattle)
	is_array(claim.categories)
	is_boolean(claim.dairy_delivery)
	every c in claim.categories {
		some r in cfg.categories
		c == r.code
	}
	tags := {a.tag | some a in claim.cattle}
	count(tags) == count(claim.cattle)
	every a in claim.cattle {
		is_string(a.tag)
		a.tag != ""
		a.sex in {"male", "female"}
		is_string(a.breed)
		a.breed != ""
		is_number(day(a.birth_date))
		is_boolean(a.withdrawn_for_year)
		is_boolean(a.animal_conditions_met)
		is_array(a.overlap_claims)
		every benefit in a.overlap_claims { benefit in cfg.overlap_claims }
		is_array(a.periods)
		every p in a.periods {
			day(p.first_day) <= day(p.last_day)
			is_string(p.country)
			p.country != ""
			day(p.first_day) >= day(a.birth_date)
		}
		not overlapping(a.periods)
	}
}

overlapping(periods) if {
	some i, j
	a := periods[i]
	b := periods[j]
	i < j
	a.first_day <= b.last_day
	b.first_day <= a.last_day
}

# Clamp an anniversary to month end when the birth day does not exist there.
anniversary(birth, months) := result if {
	[y, m, d] := time.date(day(birth) * day_ns)
	first := day(sprintf("%04d-%02d-01", [y, m])) * day_ns
	target := time.add_date(first, 0, months, 0) / day_ns
	following := time.add_date(first, 0, months + 1, 0) / day_ns
	result := min([(target + d) - 1, following - 1])
}

band_end(_, null) := jan(year + 1)
band_end(birth, months) := anniversary(birth, months) if is_number(months)

animal_rgve_days(a, code) := sum([amount |
	some p in a.periods
	p.country == "AT"
	some band in cfg.cattle_rgve
	band.class == breed_class(a.breed)
	category(a.sex, band.from_month) == code
	first := max([jan(year), day(p.first_day), anniversary(a.birth_date, band.from_month)])
	end := min([jan(year + 1), day(p.last_day) + 1, band_end(a.birth_date, band.until_month)])
	end > first
	amount := (end - first) * band.factor
])

eligible_tag(a) if {
	a.withdrawn_for_year == false
	a.animal_conditions_met == true
	not a.tag in animal_withdrawal_due
}

# Numerator is retained until totals are added (including in leap years).
credited_days(a, code) := animal_rgve_days(a, code) if {
	eligible_tag(a)
	milk_allows(code)
	code in claim.categories
} else := 0

annual_rgve := sum([total |
	some a in claim.cattle
	some r in cfg.categories
	total := credited_days(a, r.code)
]) / days_in_year if {
	register_valid
}

minimum_participation_met := annual_rgve >= 2

expired_categories contains code if {
	register_valid
	some code in claim.categories
	not represented(code)
}

represented(code) if {
	some a in claim.cattle
	credited_days(a, code) > 0
}

rates := r if {
	some r in cfg.premiums
	year >= r.from_year
	year <= r.through_year
}

base_rate(a) := rates.reduced if {
	some benefit in a.overlap_claims
	benefit in cfg.overlap_claims
} else := rates.basic

# Tariff calculation before administrative assessment and sanctions.
base_amount_eur := sum([amount |
	some a in claim.cattle
	some r in cfg.categories
	amount := credited_days(a, r.code) * base_rate(a)
]) / days_in_year if {
	register_valid
	minimum_participation_met
	rates.basic > 0
}

compost_amount_eur := annual_rgve * rates.compost if {
	minimum_participation_met
	claim.compost.requested
	compost_ok
} else := 0 if {
	minimum_participation_met
	claim.compost.requested == false
}

modulation_factor(ha) := 1 if ha == 0

else := weighted / ha if {
	is_number(ha)
	ha > 0
	weighted := sum([value |
		some r in cfg.modulation
		upper := min([ha, object.get(r, "through_ha", ha)])
		value := max([0, upper - r.from_ha]) * r.factor
	])
}

modulated_tariff_eur := (base_amount_eur + compost_amount_eur) * modulation_factor(input.farm.oepul.home_area_ha)

program_start(y) := sprintf("%d-04-15", [y]) if y == 2023

else := sprintf("%d-01-01", [y])

program_covers_year(program) if {
	program.recognised
	day(program.start) <= day(program_start(year))
	day(program.end) >= jan(year + 1) - 1
}

tgd_required := claim.eligible_cattle_rgve > 10 if {
	is_number(claim.eligible_cattle_rgve)
	claim.eligible_cattle_rgve >= 0
}

qplus_required := count({c | some c in claim.categories; some r in cfg.categories; r.code == c; r.sex == "female"}) > 0 if is_array(claim.categories)

tgd_met if tgd_required == false
tgd_met if program_covers_year(claim.tgd)
qplus_met if qplus_required == false
qplus_met if program_covers_year(claim.qplus)

proof_due(program) if {
	program.ama_requested
	program.transmitted_by_provider == false
}

proof_outstanding contains name if {
	some name in {"qplus", "tgd"}
	program_required(name)
	proof_due(claim[name])
	claim[name].submitted == false
}

default entry_timely(_, _, _) := false

entry_timely(kind, date, y) if {
	limit := {"category": 2027, "compost": 2028}[kind]
	y >= 2023
	y <= limit
	day(date) < jan(y)
}

entry_checks := [entry |
	some a in claim.applications
	entry := {"kind": a.kind, "date": a.date, "year": a.target_year, "timely": entry_timely(a.kind, a.date, a.target_year)}
] if {
	is_array(claim.applications)
}

program_required("tgd") if tgd_required
program_required("qplus") if qplus_required

# Explicit renewal/termination events, separate from the tariff calculation.
contract_effects contains "Maßnahmenvertrag wegen Mindestteilnahme erloschen" if minimum_participation_met == false

contract_effects contains "Abmeldung im laufenden Förderjahr wirksam" if {
	day(claim.withdrawal_date) >= jan(year)
	day(claim.withdrawal_date) < jan(year + 1)
}

contract_effects contains "Neuer Maßnahmenantrag erforderlich" if {
	claim.previous_status in {"withdrawn", "excluded", "mfa_missing_one_year"}
}

contract_effects contains "Online-Korrektur und schriftliches Ersuchen erforderlich" if {
	claim.previous_status == "category_empty"
	claim.immediate_reentry
	day(claim.reentry_application_date) >= jan(year)
}

contract_effects contains "Jährliche Weiterführung beantragt" if {
	claim.previous_status == "active"
	claim.withdrawal_date == null
	claim.current_mfa_with_units
	minimum_participation_met
	year <= 2028
}

per_animal_rgve[tag] := contributions if {
	register_valid
	some a in claim.cattle
	tag := a.tag
	contributions := {c: amount | some c in claim.categories; amount := credited_days(a, c) / days_in_year}
}
