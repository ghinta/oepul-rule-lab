package oepul.o6_14

# Foerderverpflichtungen der Grundmassnahme: Bestossung, Viehbesatz,
# Futtergrundlage, Pflanzenschutz, Duengung, Anwesenheit der Tiere, Meldungen.

# --- Bestossung / Mindestweidedauer ---------------------------------------

obligation_violations contains v if {
	some alm_id, _ in alm_by_id
	not alm_min_occupancy_met(alm_id)
	v := {"rule_id": "O614-GRAZE-001", "category": "obligation", "subject": alm_id, "message": sprintf("Mindestbestossungsdauer von 60 Tagen auf der Alm nicht erreicht (%d Tage).", [alm_occupied_days[alm_id]])}
}

animal_notices contains v if {
	some id, a in animal_by_id
	not meets_min_grazing(id)
	v := {"rule_id": "O614-GRAZE-001", "category": "animal_not_eligible", "subject": id, "message": sprintf("Mindestweidedauer pro Tier von 60 angerechneten Alpungstagen nicht erreicht (%d Tage); keine Praemie fuer dieses Tier.", [total_credited_days[id]])}
}

animal_notices contains v if {
	some id, a in animal_by_id
	not species_eligible(a)
	v := {"rule_id": "O614-ANIMAL-001", "category": "animal_not_eligible", "subject": id, "message": "Tierart ist keine teilnahmefaehige RGVE."}
}

animal_notices contains v if {
	some id, a in animal_by_id
	count([s | some s in stays(a); valid_stay(s)]) > 0
	not driven_up_in_time(a)
	v := {"rule_id": "O614-APPL-010", "category": "animal_not_eligible", "subject": id, "message": "Tier nicht bis spaetestens 15. Juli aufgetrieben; keine Anerkennung fuer die Auszahlung."}
}

# Tiere muessen sich grundsaetzlich Tag und Nacht auf der Alm befinden.
animal_notices contains v if {
	some id, a in animal_by_id
	not presence_compliant(a)
	v := {"rule_id": "O614-GRAZE-008", "category": "animal_not_eligible", "subject": id, "message": "Anwesenheit auf der Alm (Tag und Nacht, max. halber Tag im Almstall) nicht erfuellt; keine Praemie."}
}

reporting_violations contains v if {
	some id, a in animal_by_id
	not presence_compliant(a)
	is_false(a, "non_compliance_reported")
	v := {"rule_id": "O614-GRAZE-008", "category": "reporting", "subject": id, "message": "Nichteinhaltung der Anwesenheit ist der AMA zu melden (bei Rindern online ueber eAMA)."}
}

obligation_violations contains v if {
	some id, a in animal_by_id
	is_false(a, "home_stable_only_for_milking")
	some s in stays(a)
	alm_by_id[s.alm_id].adjacent_to_home_farm == true
	v := {"rule_id": "O614-GRAZE-009", "category": "obligation", "subject": id, "message": "Bei an das Heimgut angrenzenden Almen duerfen die Tiere im Heimstall nur fuer die Dauer des Melkvorganges verbleiben."}
}

# --- Maximaler Viehbesatz ----------------------------------------------------

obligation_violations contains v if {
	some alm_id, _ in alm_by_id
	overstocked(alm_id)
	v := {"rule_id": "O614-STOCK-001", "category": "obligation", "subject": alm_id, "message": sprintf("Ueberbesatz: %.2f RGVE/ha > zulaessig %.2f RGVE/ha.", [alm_stocking_density[alm_id], alm_max_stocking_limit[alm_id]])}
}

# --- Natuerliche Futtergrundlage --------------------------------------------

feeding(alm) := object.get(alm, "feeding", {})

obligation_violations contains v if {
	some alm in alms
	is_true(feeding(alm), "basic_fodder_supplementation")
	v := {"rule_id": "O614-FEED-001", "category": "obligation", "subject": alm.alm_id, "message": "Zufuetterung mit Grundfutter ist nicht erlaubt (nur Ausgleichsfuetterung)."}
}

obligation_violations contains v if {
	some alm in alms
	is_true(feeding(alm), "alm_foreign_green_fodder_fed")
	v := {"rule_id": "O614-FEED-003", "category": "obligation", "subject": alm.alm_id, "message": "Verfuetterung von almfremdem Gruenfutter ist verboten."}
}

obligation_violations contains v if {
	some alm in alms
	is_true(feeding(alm), "silage_fed")
	not silage_feeding_allowed(alm)
	v := {"rule_id": "O614-FEED-003", "category": "obligation", "subject": alm.alm_id, "message": "Verfuetterung von Silage ist verboten (ab 2025 nur almeigene Silage)."}
}

silage_feeding_allowed(alm) if {
	year >= 2025
	is_true(feeding(alm), "silage_alm_own")
	not heuwirtschaft_own_alm(alm)
}

obligation_violations contains v if {
	some alm in alms
	is_true(feeding(alm), "alm_silage_moved_to_home_farm")
	v := {"rule_id": "O614-FEED-004", "category": "obligation", "subject": alm.alm_id, "message": "Auf der Almweideflaeche produzierte Silage muss gaenzlich auf der jeweiligen Alm verfuettert werden."}
}

heuwirtschaft_own_alm(alm) if {
	participates_in("heuwirtschaft")
	is_true(alm, "is_own_alm")
}

obligation_violations contains v if {
	some alm in alms
	heuwirtschaft_own_alm(alm)
	silage_activity(feeding(alm))
	v := {"rule_id": "O614-FEED-006", "category": "obligation", "subject": alm.alm_id, "message": "Eigenalm bei Teilnahme an Heuwirtschaft: keine Silage erzeugen, fuettern oder lagern (auch nicht auf der Alm)."}
}

silage_activity(f) if is_true(f, "silage_fed")

silage_activity(f) if is_true(f, "silage_produced")

silage_activity(f) if is_true(f, "silage_stored")

# --- Pflanzenschutz ----------------------------------------------------------

plant_protection(alm) := object.get(alm, "plant_protection", {})

obligation_violations contains v if {
	some alm in alms
	is_true(plant_protection(alm), "non_organic_psm_used")
	v := {"rule_id": "O614-PSM-001", "category": "obligation", "subject": alm.alm_id, "message": "Einsatz von Pflanzenschutzmitteln, die nicht gemaess VO (EU) 2018/848 zulaessig sind."}
}

psm_coding_required(y) if {
	some c in proc.psm_codes
	y <= c.required_until_year
}

required_psm_code(types) := "PSMCS" if "chemical_synthetic" in types

required_psm_code(types) := "PSMBIO" if {
	"organic" in types
	not "chemical_synthetic" in types
}

reporting_violations contains v if {
	psm_coding_required(year)
	some alm in alms
	some plot in object.get(alm, "plots", [])
	types := object.get(plot, "area_wide_psm_types", [])
	count(types) > 0
	code := required_psm_code(types)
	not psm_code_present(plot, code)
	v := {"rule_id": "O614-PSM-002", "category": "reporting", "subject": plot.plot_id, "message": sprintf("Flaechiger PSM-Einsatz bis Antragsjahr 2025 mit Code %s zu erfassen.", [code])}
}

psm_code_present(plot, code) if code in object.get(plot, "codes", [])

# --- Duengung ------------------------------------------------------------------

fertilisation(alm) := object.get(alm, "fertilisation", {})

fertiliser_breaches := {
	"non_organic_fertiliser_used": ["O614-FERT-001", "Ausbringung von Duengemitteln, die nicht gemaess VO (EU) 2018/848 zugelassen sind."],
	"alm_foreign_slurry_applied": ["O614-FERT-002", "Ausbringung almfremder Guelle oder Jauche."],
	"sewage_sludge_applied": ["O614-FERT-003", "Ausbringung von Klaerschlamm oder kompostiertem Klaerschlamm."],
	"home_farm_separated_slurry_solids_applied": ["O614-FERT-004", "Separierter Guelleanteil in fester Form vom Heimbetrieb ist nicht zulaessig."],
}

obligation_violations contains v if {
	some alm in alms
	some key, spec in fertiliser_breaches
	is_true(fertilisation(alm), key)
	v := {"rule_id": spec[0], "category": "obligation", "subject": alm.alm_id, "message": spec[1]}
}

# --- Meldefristen Auf- und Abtrieb ------------------------------------------

reporting_violations contains v if {
	some id, a in animal_by_id
	w := reporting_window(a.species)
	some s in stays(a)
	valid_stay(s)
	s.drive_up_report_date
	days_between(s.drive_up_date, s.drive_up_report_date) > w.drive_up_report_days
	v := {"rule_id": "O614-GRAZE-006", "category": "reporting", "subject": id, "message": sprintf("Auftrieb nicht binnen %d Tagen gemeldet; Anrechnung erst %d Tage vor dem Meldedatum.", [w.drive_up_report_days, w.max_credit_days_before_report])}
}

reporting_violations contains v if {
	some id, a in animal_by_id
	w := reporting_window(a.species)
	some s in stays(a)
	valid_stay(s)
	down_report_late(a, s, w)
	v := {"rule_id": "O614-GRAZE-007", "category": "reporting", "subject": id, "message": sprintf("Abtrieb/Abgang nicht binnen %d Tagen ab dem tatsaechlichen Abtrieb gemeldet.", [w.drive_down_report_days])}
}

# Equiden und Neuweltkamele: stimmt das beim Auftrieb angegebene
# voraussichtliche Abtriebsdatum, ist keine Nachmeldung erforderlich.
down_report_late(a, s, w) if {
	not planned_date_matches(a, s)
	s.drive_down_report_date
	days_between(s.drive_down_date, s.drive_down_report_date) > w.drive_down_report_days
}

down_report_late(a, s, _) if {
	not planned_date_matches(a, s)
	not s.drive_down_report_date
}

planned_date_matches(a, s) if {
	a.species in {"equine", "new_world_camelid"}
	s.planned_drive_down_date == s.drive_down_date
}

reporting_violations contains v if {
	some id, a in animal_by_id
	a.species in {"sheep", "goat"}
	not a.ear_tag
	v := {"rule_id": "O614-APPL-012", "category": "reporting", "subject": id, "message": "Schafe und Ziegen sind einzeltierbezogen mit Ohrmarke zu beantragen."}
}

reporting_violations contains v if {
	some id, a in animal_by_id
	a.species in {"sheep", "goat"}
	is_true(a, "sold_without_drive_down")
	is_true(a, "in_tierwohl_weide_or_rare_breeds")
	is_false(a, "new_drive_up_report_with_new_home_farm")
	v := {"rule_id": "O614-APPL-013", "category": "reporting", "subject": id, "message": "Verkauf ohne Abtrieb: erneute Auftriebsmeldung mit der neuen Heimbetriebsnummer erforderlich."}
}

violations := ((((access_violations | deadline_violations) | obligation_violations) | reporting_violations) | nata_violations) | awp_violations

default obligations_met := false

obligations_met if count(obligation_violations | nata_violations) == 0
