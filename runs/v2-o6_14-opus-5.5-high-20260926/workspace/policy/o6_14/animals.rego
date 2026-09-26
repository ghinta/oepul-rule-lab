package oepul.o6_14

# RGVE-Schluessel (Kapitel 8 Merkblatt, Anhang A SRL), Altersstichtag 1. Juli,
# Alpungstage je Tier und Alm sowie Meldefristen.

reference_date := sprintf("%d-%s", [year, rgve_key.age_reference_month_day])

reference_ns := date_ns(reference_date)

eligible_species := {s.species | some s in rgve_key.eligible_species}

species_eligible(animal) if animal.species in eligible_species

size_class(animal) := "dwarf" if {
	animal.species == "cattle"
	animal.breed in rgve_key.dwarf_cattle_breeds
}

size_class(animal) := "standard" if {
	animal.species == "cattle"
	not dwarf_breed(animal)
}

size_class(animal) := animal.equine_size_class if animal.species == "equine"

size_class(animal) := "standard" if animal.species in {"sheep", "goat", "new_world_camelid"}

dwarf_breed(animal) if animal.breed in rgve_key.dwarf_cattle_breeds

born_after_reference(animal) if date_ns(animal.birth_date) > reference_ns

age_months(animal) := 0 if born_after_reference(animal)

age_months(animal) := m if {
	not born_after_reference(animal)
	d := time.diff(reference_ns, date_ns(animal.birth_date))
	m := (d[0] * 12) + d[1]
}

category_matches(c, animal) if {
	c.species == animal.species
	c.size_class == size_class(animal)
	age_months(animal) >= c.min_age_months
	upper_age_ok(c, age_months(animal))
}

upper_age_ok(c, _) if c.max_age_months_exclusive == null

upper_age_ok(c, m) if {
	c.max_age_months_exclusive != null
	m < c.max_age_months_exclusive
}

# Optional kann die Kategorie direkt angegeben werden; sonst Ableitung aus
# Tierart, Rasse/Groesse und Geburtsdatum zum Stichtag 1. Juli.
rgve_category(animal) := animal.rgve_category_id if animal.rgve_category_id

rgve_category(animal) := c.category_id if {
	not animal.rgve_category_id
	some c in rgve_key.categories
	category_matches(c, animal)
}

rgve_per_head(animal) := c.rgve if {
	some c in rgve_key.categories
	c.category_id == rgve_category(animal)
}

animal_count(animal) := object.get(animal, "count", 1)

animal_rgve(animal) := rgve_per_head(animal) * animal_count(animal)

animal_rgve_by_id[id] := animal_rgve(a) if some id, a in animal_by_id

# --- Alpungstage ---------------------------------------------------------

reporting_window(species) := w if {
	some w in proc.reporting_windows
	w.species == species
}

stays(animal) := object.get(animal, "stays", [])

valid_stay(s) if {
	s.drive_up_date
	s.drive_down_date
	object.get(s, "in_austria", true) == true
	date_ns(s.drive_down_date) >= date_ns(s.drive_up_date)
}

# Auftriebstag zaehlt, Abtriebstag nicht.
actual_days(s) := days_between(s.drive_up_date, s.drive_down_date)

# Anrechnung maximal 7 (Rinder 14) Tage vor dem Meldedatum.
credited_start_ns(animal, s) := max([date_ns(s.drive_up_date), date_ns(s.drive_up_report_date) - (reporting_window(animal.species).max_credit_days_before_report * day_ns)])

credited_days(animal, s) := max([0, round((date_ns(s.drive_down_date) - credited_start_ns(animal, s)) / day_ns)]) if s.drive_up_report_date

credited_days(_, s) := 0 if not s.drive_up_report_date

total_actual_days[id] := n if {
	some id, a in animal_by_id
	n := sum([actual_days(s) | some s in stays(a); valid_stay(s)])
}

total_credited_days[id] := n if {
	some id, a in animal_by_id
	n := sum([credited_days(a, s) | some s in stays(a); valid_stay(s)])
}

first_drive_up_date(animal) := d if {
	d := min([s.drive_up_date | some s in stays(animal); valid_stay(s)])
}

min_grazing_days := 60

# Mindestweidedauer pro Tier (Summe ueber alle Almen) von 60 Tagen.
meets_min_grazing(id) if total_credited_days[id] >= min_grazing_days

# Tiere zaehlen fuer den Maximalviehbesatz nur bei >= 60 Alpungstagen und
# wenn sie nicht nach dem 1. Juli geboren wurden.
counts_for_stocking(id) if {
	a := animal_by_id[id]
	total_actual_days[id] >= min_grazing_days
	not born_after_reference(a)
}

presence_compliant(animal) if object.get(animal, "presence_compliant", true) == true

driven_up_in_time(animal) if on_or_before(first_drive_up_date(animal), deadline_date("latest_drive_up_for_payment", year))

# Tier ist fuer die Praemie anrechenbar.
animal_premium_eligible(id) if {
	a := animal_by_id[id]
	species_eligible(a)
	meets_min_grazing(id)
	driven_up_in_time(a)
	presence_compliant(a)
}

# Anteilige RGVE je Alm fuer den Maximalviehbesatz (tatsaechliche Tage).
stocking_rgve_share(id, alm_id) := x if {
	a := animal_by_id[id]
	x := sum([(animal_rgve(a) * (actual_days(s) / total_actual_days[id])) |
		some s in stays(a)
		valid_stay(s)
		s.alm_id == alm_id
	])
}

# Anteilige RGVE je Alm fuer die Praemie (angerechnete Tage).
premium_rgve_share(id, alm_id) := x if {
	a := animal_by_id[id]
	total_credited_days[id] > 0
	x := sum([(animal_rgve(a) * (credited_days(a, s) / total_credited_days[id])) |
		some s in stays(a)
		valid_stay(s)
		s.alm_id == alm_id
	])
}

# Tage, an denen die Alm bestossen war (Vereinigung aller Aufenthalte).
alm_occupied_days[alm_id] := n if {
	some alm_id, _ in alm_by_id
	n := count({d |
		some a in animals
		some s in stays(a)
		valid_stay(s)
		s.alm_id == alm_id
		actual_days(s) > 0
		some d in numbers.range(day_number(s.drive_up_date), day_number(s.drive_down_date) - 1)
	})
}

alm_species(alm_id) := {a.species |
	some a in animals
	some s in stays(a)
	s.alm_id == alm_id
}

cattle_only_alm(alm_id) if alm_species(alm_id) == {"cattle"}
