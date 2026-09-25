# title: o6_5 – Haltedauer, Abgang und Nachbesetzung
# description: >-
#   Prüft die Haltedauer 01.04.–31.12. (2026: bis 31.08.), zulässige
#   Rinder-Weitergaben nach dem 30.09. und Nachbesetzungen binnen 5 Wochen.
#   Nachbesetzungsketten werden bis zur zweiten Ebene ausgewertet.
package oepul.o6_5

# Abgang innerhalb der (ggf. jahresspezifisch verkürzten) Haltedauer.
departure_in_holding_period(a) if {
	d := departure_date_ns(a)
	d >= holding_start_ns
	d <= holding_end_ns
	not cattle_transfer_permitted(a)
}

# O6_5-OBL-CATTLE-TRANSFER-AFTER-0930: Weitergabe von Rindern nach dem 30.09. an
# andere Betriebe zulässig, sofern nicht vor dem 01.01. des Folgejahres ins Ausland
# verbracht, geschlachtet oder verendet.
cattle_transfer_permitted(a) if {
	is_cattle(a)
	a.departure.reason in {"sale", "transfer"}
	departure_date_ns(a) > date_of(year, params.cattle_transfer_after_md)
	a.departure.exported_slaughtered_or_died_before_next_jan1 == false
}

# O6_5-OBL-REPLACEMENT-5-WEEKS: Nachbesetzung binnen 5 Wochen mit förderbaren Tieren
# der gleichen Rasse; Frist gilt auch über den 31.12. hinaus.
timely_same_breed_replacement(orig, r) if {
	val(r, "replaces_animal_id") == orig.animal_id
	r.breed == orig.breed
	val(r, "replacement_date") != null
	d := departure_date_ns(orig)
	rd := parse_date(r.replacement_date)
	rd >= d
	days_between_ns(d, rd) <= params.replacement_window_days
}

replacement_deadline(a) := time.format([time.add_date(departure_date_ns(a), 0, 0, params.replacement_window_days), "UTC", "2006-01-02"])

# Ersatztier der zweiten Ebene: förderbar und ohne eigenen Abgang in der Haltedauer.
final_replacement_ok(r) if {
	base_ok(r)
	not departure_in_holding_period(r)
}

# Ersatztier der ersten Ebene: förderbar und entweder ohne Abgang oder selbst
# fristgerecht nachbesetzt.
replacement_ok(r) if final_replacement_ok(r)

replacement_ok(r) if {
	base_ok(r)
	departure_in_holding_period(r)
	some r2 in animals
	timely_same_breed_replacement(r, r2)
	final_replacement_ok(r2)
}

# Haltedauer für den beantragten Förderplatz erfüllt.
slot_holding_ok(a) if not departure_in_holding_period(a)

slot_holding_ok(a) if {
	departure_in_holding_period(a)
	some r in animals
	timely_same_breed_replacement(a, r)
	replacement_ok(r)
}

holding_failures contains [a.animal_id, "O6_5-OBL-REPLACEMENT-5-WEEKS"] if {
	some a in applied_animals
	not slot_holding_ok(a)
}

applied_animals := [a | some a in animals; not is_replacement(a)]

replacement_animals := [a | some a in animals; is_replacement(a)]

# Tatsächlich herangezogene Ersatztiere eines Förderplatzes (Ebene 1 und 2).
used_replacements(a) := {r.animal_id | some r in animals; departure_in_holding_period(a); timely_same_breed_replacement(a, r); replacement_ok(r)} | {r2.animal_id |
	some r in animals
	departure_in_holding_period(a)
	timely_same_breed_replacement(a, r)
	replacement_ok(r)
	departure_in_holding_period(r)
	some r2 in animals
	timely_same_breed_replacement(r, r2)
	final_replacement_ok(r2)
}

all_failures contains f if some f in base_failures

all_failures contains f if some f in holding_failures

failures_of(id) := {rule_id | some f in all_failures; f[0] == id; rule_id := f[1]}

slot_eligible(a) if {
	base_ok(a)
	slot_holding_ok(a)
}

# O6_5-PREM-REPLACEMENT-LOWER-PREMIUM: bei Nachbesetzung wird der geringere Prämienbetrag
# (beantragtes Tier bzw. Ersatztier) ausbezahlt.
slot_premium(a) := min({animal_premium(a)} | {animal_premium(animal_by_id[id]) | some id in used_replacements(a)})

eligible_slot_ids := {a.animal_id | some a in applied_animals; slot_eligible(a)}

# O6_5-MIN-PARTICIPATION: mindestens ein förderbares Tier im Förderjahr.
eligible_animal_count := count(eligible_slot_ids)

minimum_participation_met if eligible_animal_count >= params.min_eligible_animals_per_year
