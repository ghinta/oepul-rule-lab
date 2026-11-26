package oepul.o6_17

import data.o17_tables as tab
import rego.v1

# Beide Kataloge verwenden die Artnamen der jeweiligen Quelle.
listed_seed(part) if {
	some row in tab.regional_grass_seed
	row.scientific_name == part.scientific_name
	row.family == part.family
}

valid_seed_part(m, p) if {
	m.certified_ecotype
	is_string(p.scientific_name)
	is_string(p.family)
	p.regional_origin_at_proven
	p.weight_percent > 0
} else if {
	listed_seed(p)
	p.weight_percent > 0
	p.weight_percent <= 5
	p.regional_origin_at_proven
}

weights_within_species_limit(m) if m.certified_ecotype
weights_within_species_limit(m) if {
	every name in {part.scientific_name | some part in m.parts} {
		total := sum([part.weight_percent | some part in m.parts; part.scientific_name == name])
		total <= 5
	}
}

regional_seed(p) if {
	p.land_use == "grassland"
	p.grassland_score >= 30
	p.slope_percent >= 0
	p.slope_percent < 18
	m := p.operations.regional_seed
	m.permanent_div_reseeding
	m.kg_per_ha >= 20
	m.seedbed_prepared
	date_ok(m.sowing_date)
	startswith(m.sowing_date, sprintf("%d-", [input.farm.year]))
	m.sowing_date <= sprintf("%d-05-15", [input.farm.year])
	m.labels_and_invoices
	count({s.scientific_name | some s in m.parts}) >= 30
	count({s.family | some s in m.parts}) >= 7
	weights_within_species_limit(m)
	every part in m.parts { valid_seed_part(m, part) }
}

allowed_disturbance(_, e) if {
	e.minor_deviation
	e.area_m2 >= 0
	e.area_m2 <= 300
	e.kind != "Aufschüttung"
}

allowed_disturbance(_, e) if {
	e.kind == "Aufschüttung"
	e.reseeded
	e.state_law_observed
	e.area_m2 >= 0
	e.area_m2 <= 300
}

allowed_disturbance(_, e) if {
	e.kind == "Aufschüttung"
	e.reseeded
	e.state_law_observed
	e.area_m2 > 300
	e.prior_authorisation
}

allowed_disturbance(_, e) if {
	e.kind == "Schädlingssanierung"
	e.necessary
	e.evidence_retained
}

allowed_disturbance(p, e) if {
	e.kind == "DIVRS-Neueinsaat"
	e.evidence_retained
	companion
	regional_seed(p)
}

# Befunde für gemeldete Vorgänge im ausgewerteten Vertragsjahr.
tillage_breaches contains {"parcel": p.parcel_id, "event": i, "reason": "Grünlandumbruch ohne belegte Ausnahme"} if {
	in_term
	some p in input.land.parcels
	p.land_use == "grassland"
	some i, e in p.operations.grass_events
	e.sward_destroyed
	not allowed_disturbance(p, e)
}

tillage_breaches contains {"parcel": p.parcel_id, "event": i, "reason": "Acker-Grünland-Flächentausch"} if {
	in_term
	some p in input.land.parcels
	some i, e in p.operations.grass_events
	e.kind == "Acker-Grünland-Flächentausch"
}

tillage_breaches contains {"parcel": p.parcel_id, "event": i, "reason": "Gerät für umbruchslose Erneuerung nicht zugelassen"} if {
	in_term
	some p in input.land.parcels
	p.land_use == "grassland"
	some i, e in p.operations.grass_events
	e.kind == "Umbruchslose Erneuerung"
	is_string(e.device)
	not e.device in tab.renewal_tools
}

tillage_breaches contains {"parcel": p.parcel_id, "event": i, "reason": "Ungenutzte Aufschüttung als Sonstige Grünlandflächen beantragen"} if {
	in_term
	some p in input.land.parcels
	p.land_use == "grassland"
	some i, e in p.operations.grass_events
	e.kind == "Aufschüttung"
	e.used_this_year == false
	p.mfa_use != "Sonstige Grünlandflächen"
}

eligible_person(c) if c.operator

eligible_person(c) if {
	c.operational_need
	c.substantially_involved
}

stayed(c) if c.departure_date == null

stayed(c) if {
	date_ok(c.departure_date)
	c.departure_date >= "2025-12-31"
}

credit_course(c, subject) if {
	c.subject == subject
	c.recognised_provider
	c.subject_requirements_met
	eligible_person(c)
	stayed(c)
	c.credited_farms == 1
	c.credited_obligations == 1

	# Auch widersprüchliche interne Buchungen derselben Veranstaltung erkennen.
	subjects := {x.subject | some x in input.documentation.courses; x.person_id == c.person_id; x.event_id == c.event_id}
	count(subjects) == 1
	date_ok(c.date)
	c.date >= "2022-01-01"
	c.date <= "2025-12-31"
	c.hours > 0
}

training_hours(person, subject) := sum([h |
	some event in {c.event_id | some c in input.documentation.courses; c.person_id == person}
	hs := {c.hours | some c in input.documentation.courses; c.person_id == person; c.event_id == event; credit_course(c, subject)}
	count(hs) == 1
	some h in hs
]) if {
	is_array(input.documentation.courses)
}

training_requirements := {"Grünlandbewirtschaftung": 5, "Biodiversität": 3, "Biologische Wirtschaftsweise": 5} if {
	some m in input.farm.o6_17.active_measures
	m in {"BIO", "BIO-Teilbetrieb"}
} else := {"Grünlandbewirtschaftung": 5, "Biodiversität": 3} if companion

training_outstanding contains topic if {
	some topic, hours in training_requirements
	is_array(input.documentation.courses)
	not trained(topic, hours)
}

trained(topic, hours) if {
	some c in input.documentation.courses
	training_hours(c.person_id, topic) >= hours
}

# Überlappende GLÖZ-Verbotsflächen sind je Schlag nur einmal abzuziehen.
soil_ha(p) := p.area_ha - p.gloez_ban_union_ha if {
	p.slope_percent >= 0
	p.slope_percent < 18
	p.gloez_ban_union_ha >= 0
	p.area_ha >= p.gloez_ban_union_ha
}

soil_ha(p) := 0 if p.slope_percent >= 18

required_samples := ceil(sum(values) / 5) if {
	rows := input.land.mfa_2025_grassland
	is_array(rows)
	values := [h | some p in rows; is_number(p.slope_percent); h := soil_ha(p)]
	count(values) == count(rows)
}

sample_mfa_year(s) if s.mfa_year == to_number(substring(s.drawn, 0, 4))

sample_mfa_year(s) if {
	s.autumn_acquisition
	s.mfa_year == to_number(substring(s.drawn, 0, 4)) + 1
}

credited_samples := count({s.sample_id |
	some s in input.documentation.soil_samples
	s.farm_id == input.farm.farm_id
	s.from_eligible_grassland
	date_ok(s.drawn)
	date_ok(s.sent)
	s.drawn >= "2022-01-01"
	s.sent >= s.drawn
	s.sent <= "2025-12-31"
	s.accredited_lab
	s.method in {"Richtlinien für sachgerechte Düngung", "EUF"}
	every k in {"pH", "P", "K", "Humus"} { k in s.analysed_parameters }
	s.gis_recorded
	sample_mfa_year(s)
}) if {
	is_array(input.documentation.soil_samples)
}

sample_deficit := max([0, required_samples - credited_samples])
