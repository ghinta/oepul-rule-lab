# title: o6_5 – Förderbarkeit einzelner Tiere
# description: >-
#   Tierbezogene Voraussetzungen (Rassenliste, Reinrassigkeit, Tierkategorien,
#   Bestätigung der Zuchtorganisation, Beantragung). Ergebnis ist die Menge
#   base_failures mit Paaren [animal_id, rule_id].
package oepul.o6_5

# O6_5-ELIG-UNKNOWN-CATEGORY: nur die Tierkategorien der Maßnahme sind förderbar.
base_failures contains [a.animal_id, "O6_5-ELIG-UNKNOWN-CATEGORY"] if {
	some a in animals
	not category_meta[a.animal_category]
}

# O6_5-ELIG-BREED-LIST: reinrassige Tiere der Rassenliste (Anhang D / Kapitel 8).
base_failures contains [a.animal_id, "O6_5-ELIG-BREED-LIST"] if {
	some a in animals
	not breed_listed(a)
}

breed_listed(a) if {
	b := breed_meta[a.breed]
	b.species == species_of(a)
}

# O6_5-ELIG-PUREBRED-HERDBOOK: reinrassige Zuchttiere gemäß Tierzuchtgesetzen der
# Länder und genehmigten Zuchtprogrammen mit Zuchtziel Erhalt der Rasse.
base_failures contains [a.animal_id, "O6_5-ELIG-PUREBRED-HERDBOOK"] if {
	some a in animals
	not purebred_breeding_animal(a)
}

purebred_breeding_animal(a) if {
	a.is_purebred == true
	a.herdbook_registered == true
	a.approved_breeding_program == true
}

# O6_5-ELIG-REGULAR-BREEDING: regelmäßiger Zuchteinsatz im genehmigten Zuchtprogramm.
base_failures contains [a.animal_id, "O6_5-ELIG-REGULAR-BREEDING"] if {
	some a in animals
	not a.regular_breeding_use == true
}

# O6_5-ELIG-FEMALE-PUREBRED-MATING: weibliche Tiere nur reinrassige Anpaarung.
base_failures contains [a.animal_id, "O6_5-ELIG-FEMALE-PUREBRED-MATING"] if {
	some a in animals
	is_female(a)
	not a.purebred_mating_only == true
}

offspring_by_reference(a, field) if {
	d := val(a, field)
	d != null
	parse_date(d) <= requirement_ref_ns(a)
}

# O6_5-ELIG-FIRST-BIRTH-STICHTAG: Kuh gekalbt, Mutterschaf gelammt, Mutterziege
# gekitzt – jeweils bis spätestens am Stichtag 01.04.
base_failures contains [a.animal_id, "O6_5-ELIG-FIRST-BIRTH-STICHTAG"] if {
	some a in animals
	a.animal_category in {"kuh", "mutterschaf", "mutterziege"}
	not offspring_by_reference(a, "first_offspring_date")
}

# O6_5-ELIG-MARE-FOALING: Stute bis spätestens 31.05. einmal gefohlt.
base_failures contains [a.animal_id, "O6_5-ELIG-MARE-FOALING"] if {
	some a in animals
	a.animal_category == "stute"
	not offspring_by_reference(a, "first_offspring_date")
}

# O6_5-ELIG-MARE-REFOALING: weitere Abfohlung spätestens 3,5 Jahre nach der letzten.
base_failures contains [a.animal_id, "O6_5-ELIG-MARE-REFOALING"] if {
	some a in animals
	a.animal_category == "stute"
	not mare_refoaling_ok(a)
}

last_foaling_date(a) := val(a, "last_foaling_date") if {
	val(a, "last_foaling_date") != null
} else := val(a, "first_offspring_date")

mare_refoaling_ok(a) if {
	last := last_foaling_date(a)
	last != null
	requirement_ref_ns(a) <= time.add_date(parse_date(last), 0, params.mare_refoaling_max_months, 0)
}

# O6_5-ELIG-SOW-PUREBRED-FARROWING: Zuchtsau bis Stichtag zumindest einmal reinrassig geferkelt.
base_failures contains [a.animal_id, "O6_5-ELIG-SOW-PUREBRED-FARROWING"] if {
	some a in animals
	a.animal_category == "zuchtsau"
	not offspring_by_reference(a, "first_purebred_farrowing_date")
}

# O6_5-ELIG-SOW-LITTER-SHARE: mindestens jeder 2. Wurf reinrassig.
base_failures contains [a.animal_id, "O6_5-ELIG-SOW-LITTER-SHARE"] if {
	some a in animals
	a.animal_category == "zuchtsau"
	not sow_litter_share_ok(a)
}

sow_litter_share_ok(a) if {
	total := val(a, "litters_total")
	pure := val(a, "litters_purebred")
	is_number(total)
	is_number(pure)
	total >= 1
	pure <= total
	pure >= total * params.sow_min_purebred_litter_share
}

# O6_5-ELIG-MALE-ANNUAL-BREEDING: jährlicher Zuchteinsatz, ausgenommen im Jahr der Zulassung.
base_failures contains [a.animal_id, "O6_5-ELIG-MALE-ANNUAL-BREEDING"] if {
	some a in animals
	category_meta[a.animal_category].annual_breeding_use_required == true
	not annual_breeding_ok(a)
}

annual_breeding_ok(a) if a.breeding_use_in_year == true

annual_breeding_ok(a) if val(a, "breeding_approval_year") == year

# O6_5-ELIG-MALE-MIN-AGE / O6_5-ELIG-STALLION-MIN-AGE: Mindestalter am Bezugsdatum.
base_failures contains [a.animal_id, rule_id] if {
	some a in animals
	meta := category_meta[a.animal_category]
	meta.min_age_months != null
	rule_id := meta.min_age_rule_id
	not min_age_ok(a, meta.min_age_months)
}

min_age_ok(a, months) if {
	b := val(a, "birth_date")
	b != null
	time.add_date(parse_date(b), 0, months, 0) <= requirement_ref_ns(a)
}

# O6_5-ELIG-STALLION-OFFSPRING: Hengst am 31.05. älter als 5 Jahre -> lebend geborener
# Nachkomme in den letzten 2 Jahren im Zuchtbuch registriert.
base_failures contains [a.animal_id, "O6_5-ELIG-STALLION-OFFSPRING"] if {
	some a in animals
	a.animal_category == "zuchthengst"
	stallion_older_than_limit(a)
	not a.live_offspring_registered_last_2_years == true
}

stallion_older_than_limit(a) if {
	b := val(a, "birth_date")
	b != null
	time.add_date(parse_date(b), params.stallion_offspring_check_age_years, 0, 0) < requirement_ref_ns(a)
}

# O6_5-GEN-ANIMALS-IN-AUSTRIA: geförderte Tiere müssen in Österreich gehalten werden.
base_failures contains [a.animal_id, "O6_5-GEN-ANIMALS-IN-AUSTRIA"] if {
	some a in animals
	not a.kept_in_austria == true
}

# O6_5-OBL-BREEDING-ORG-CONFIRMATION: Bestätigung der Zuchtorganisation bis 10.02. des Folgejahres.
base_failures contains [a.animal_id, "O6_5-OBL-BREEDING-ORG-CONFIRMATION"] if {
	some a in animals
	not breeding_org_confirmed(a)
}

breeding_org_confirmed(a) if {
	c := a.breeding_org_confirmation
	c.status == "confirmed"
	not confirmation_late(c)
}

confirmation_late(c) if {
	val(c, "date") != null
	parse_date(c.date) > date_of(year + 1, params.breeding_org_confirmation_deadline_md)
}

# O6_5-APP-INDIVIDUAL-MFA: Pferde, Schafe, Ziegen, Schweine einzeln im Mehrfachantrag
# (Beilage "Gefährdete Nutztierrassen") mit Stichtag 01.04.; Rinder automatisch.
base_failures contains [a.animal_id, "O6_5-APP-INDIVIDUAL-MFA"] if {
	some a in animals
	category_meta[a.animal_category]
	not is_cattle(a)
	not is_replacement(a)
	not a.applied_in_mfa == true
}

# O6_5-OBL-HOLDING-PERIOD (Beginn): beantragte Tiere ab 01.04. am Betrieb.
base_failures contains [a.animal_id, "O6_5-OBL-HOLDING-PERIOD"] if {
	some a in animals
	not is_replacement(a)
	not on_farm_at_stichtag(a)
}

on_farm_at_stichtag(a) if {
	f := val(a, "on_farm_from")
	f != null
	parse_date(f) <= holding_start_ns
	not departed_before_holding_start(a)
}

departed_before_holding_start(a) if departure_date_ns(a) < holding_start_ns

# O6_5-OBL-TRANSFER-LIMITS: Weitergabe während der Haltedauer nur in den zulässigen Fällen.
base_failures contains [a.animal_id, "O6_5-OBL-TRANSFER-LIMITS"] if {
	some a in animals
	some t in object.get(a, "temporary_absences", [])
	not absence_permitted(a, t)
}

absence_days(t) := days_between_ns(parse_date(t.start_date), parse_date(t.end_date))

# O6_5-DEF-PASTURE-NOT-DEPARTURE
absence_permitted(_, t) if {
	t.type == "alpine_or_common_pasture"
	t.control_retained_or_care_only == true
}

# O6_5-OBL-TRANSFER-BREEDING-STATION-6M
absence_permitted(_, t) if {
	t.type == "breeding_station"
	val(t, "end_date") != null
	parse_date(t.end_date) <= time.add_date(parse_date(t.start_date), 0, params.breeding_station_max_months, 0)
}

# O6_5-OBL-TRANSFER-MALE-BREEDING-3M
absence_permitted(a, t) if {
	t.type == "male_breeding_use_other_farm"
	is_male(a)
	val(t, "end_date") != null
	parse_date(t.end_date) <= time.add_date(parse_date(t.start_date), 0, params.male_breeding_use_max_months, 0)
}

# O6_5-OBL-SHORT-ABSENCE-10-DAYS
absence_permitted(_, t) if short_documented_absence(t)

short_documented_absence(t) if {
	val(t, "end_date") != null
	absence_days(t) <= params.short_absence_max_days
	t.documented == true
}

# O6_5-PREM-RATES: für Kategorie/Prämienstufe muss ein Prämiensatz existieren.
base_failures contains [a.animal_id, "O6_5-PREM-RATES"] if {
	some a in animals
	breed_listed(a)
	not is_number(base_rate(a))
}

base_failed(id) if {
	some f in base_failures
	f[0] == id
}

base_ok(a) if not base_failed(a.animal_id)
