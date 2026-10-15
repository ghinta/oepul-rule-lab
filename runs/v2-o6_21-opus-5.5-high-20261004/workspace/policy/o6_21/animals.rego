# Teilnahmefähige Tiere, Einhaltung der Haltungsbedingungen je Tier, Abmeldungen und RGVE (o6_21).
package oepul.o6_21.animals

import data.oepul.o6_21.application
import data.oepul.o6_21.housing
import data.oepul.o6_21.lib

mi := lib.measure_input

animals := housing.animals

deregistrations := object.get(mi, "deregistered_animals", [])

deregistered_tags contains d.ear_tag if {
	some d in deregistrations
}

# --- Teilnahme je Tier und Kategorie ------------------------------------------------------------

# O6_21-ELIG-03 / O6_21-CAT-01: Teilnahme mit Rindern der beantragten Kategorien gemäß RGVE-Schlüssel.
participating_categories(a) := {cat_id |
	some cat_id in application.valid_categories
	lib.animal_in_category(a, cat_id)
	not milk_delivery_excluded(cat_id)
	lib.category_days(a, cat_id) > 0
}

# O6_21-ELIG-04: Betriebe mit Milchanlieferung (auch saisonal auf der Alm) sind von der Kategorie
# weibliche Rinder ab ½ bis unter 2 Jahre ausgeschlossen.
milk_delivery_excluded(cat_id) if {
	lib.category_def(cat_id).excluded_with_milk_delivery
	milk_delivery
}

milk_delivery if object.get(input, ["farm", "dairy", "milk_delivery_to_dairy"], false)

milk_delivery if object.get(input, ["farm", "dairy", "seasonal_alpine_milk_delivery"], false)

participation_intervals(a) := [iv |
	some cat_id in participating_categories(a)
	some band in lib.category_def(cat_id).age_bands
	lib.band_days(a, band) > 0
	iv := [
		max([lib.presence_start_ns(a), lib.age_band_interval(a, band)[0]]),
		min([lib.presence_end_ns(a), lib.age_band_interval(a, band)[1]]),
	]
]

period_overlaps_participation(a, p) if {
	some iv in participation_intervals(a)
	lib.overlap_days(lib.parse_date(p.start), lib.parse_date(p.end), iv[0], iv[1]) > 0
}

# --- Einhaltung je Tier ---------------------------------------------------------------------------

# O6_21-GROUP-02: Einzelhaltung kranker/verletzter Tiere max. 10 Tage, eingestreut, dokumentiert.
individual_period_days(p) := lib.days_between(p.start, p.end) + 1

animal_issue(a, "tethering") if {
	some p in object.get(a, "tethering_periods", [])
	period_overlaps_participation(a, p)
}

animal_issue(a, "full_slatted_floor") if {
	some p in object.get(a, "full_slatted_periods", [])
	period_overlaps_participation(a, p)
}

animal_issue(a, "sick_separation_over_10_days") if {
	some p in object.get(a, "individual_housing_periods", [])
	p.reason in {"illness", "injury"}
	period_overlaps_participation(a, p)
	individual_period_days(p) > lib.thresholds.max_individual_housing_days_sick_or_injured
}

animal_issue(a, "individual_housing_not_bedded") if {
	some p in object.get(a, "individual_housing_periods", [])
	period_overlaps_participation(a, p)
	not object.get(p, "bedded", false)
}

# O6_21-GROUP-03: Kälber unter 21 Tagen dürfen einzeln auf eingestreutem System mit Sozialkontakt gehalten werden.
animal_issue(a, "calf_individual_housing_too_old") if {
	some p in object.get(a, "individual_housing_periods", [])
	p.reason == "calf_under_21_days"
	period_overlaps_participation(a, p)
	lib.age_days_at(a, p.end) >= lib.thresholds.calf_individual_housing_max_age_days_exclusive
}

animal_issue(a, "calf_individual_housing_without_social_contact") if {
	some p in object.get(a, "individual_housing_periods", [])
	p.reason == "calf_under_21_days"
	period_overlaps_participation(a, p)
	not object.get(p, "social_contact", false)
}

animal_issue(a, "individual_housing_not_permitted") if {
	some p in object.get(a, "individual_housing_periods", [])
	not p.reason in {"illness", "injury", "calf_under_21_days"}
	period_overlaps_participation(a, p)
}

animal_issue(a, "compartment_noncompliant") if {
	count(participation_intervals(a)) > 0
	object.get(a, "stall_compartment_id", null) in housing.noncompliant_compartments
}

# O6_21-COMB-02: Tiere in ganzjähriger Freilandhaltung ohne entsprechendes Stallsystem sind nicht förderfähig.
animal_issue(a, "no_stall_year_round_outdoor") if {
	object.get(a, "year_round_outdoor_without_stall", false)
}

animal_issue(a, "no_stall_assigned") if {
	count(participation_intervals(a)) > 0
	not object.get(a, "year_round_outdoor_without_stall", false)
	object.get(a, "stall_compartment_id", null) == null
}

# Dokumentationspflicht (kein Förderausschluss, aber Verstoß gegen Förderverpflichtung).
documentation_issue(a, "individual_housing_not_documented") if {
	some p in object.get(a, "individual_housing_periods", [])
	p.reason in {"illness", "injury"}
	period_overlaps_participation(a, p)
	not object.get(p, "documented", false)
}

issues_of(a) := {code | some code in issue_codes; animal_issue(a, code)}

issue_codes := {
	"tethering",
	"full_slatted_floor",
	"sick_separation_over_10_days",
	"individual_housing_not_bedded",
	"calf_individual_housing_too_old",
	"calf_individual_housing_without_social_contact",
	"individual_housing_not_permitted",
	"compartment_noncompliant",
	"no_stall_year_round_outdoor",
	"no_stall_assigned",
}

# GSP-AV § 6 Abs. 4 Z 1: bei anerkannter höherer Gewalt bleibt der Anspruch für die zum Zeitpunkt
# des Eintretens förderfähigen Tiere bestehen.
force_majeure_excused(a) if {
	ev_id := object.get(a, "noncompliance_force_majeure_event_id", null)
	ev_id != null
	ev_id in data.oepul.o6_21.administration.recognised_force_majeure_events
}

noncompliant(a) if {
	count(issues_of(a)) > 0
	not force_majeure_excused(a)
}

# --- Abmeldepflicht (Kapitel 6.5) ----------------------------------------------------------------

# O6_21-REP-01: gesonderte Meldepflicht, wenn die Stallhaltung für einzelne Tiere nicht einhaltbar ist
# und die Tiere am Betrieb verbleiben.
deregistration_required contains a.ear_tag if {
	some a in animals
	noncompliant(a)
	count(participation_intervals(a)) > 0
}

# Verstoß: nicht eingehaltene Haltungsbedingungen ohne Abmeldung.
missing_deregistrations contains tag if {
	some tag in deregistration_required
	not tag in deregistered_tags
}

# --- Ermittlung der Tiere (GSP-AV § 43) --------------------------------------------------------

# O6_21-CTRL-03: Rinder gelten nur als ermittelt, wenn sie aus der Rinderdatenbank ermittelt werden;
# bei Kontrollen nicht vorgefundene Tiere werden nicht berücksichtigt.
determined(a) if {
	object.get(a, "registered_in_cattle_database", true)
	object.get(a, "determined_at_control", true) != false
}

# O6_21-ELIG-02: geförderte Tiere müssen in Österreich gehalten werden.
kept_in_austria(a) if object.get(a, "kept_in_austria", true)

# Prämienfähig: teilnehmende Kategorie, nicht abgemeldet (O6_21-REP-02 Abmeldung = ganzjährig keine Prämie
# in allen Kategorien), Haltungsbedingungen eingehalten, ermittelt, in Österreich gehalten.
premium_eligible(a) if {
	count(participating_categories(a)) > 0
	not a.ear_tag in deregistered_tags
	not noncompliant(a)
	determined(a)
	kept_in_austria(a)
}

eligible_flag(a) if premium_eligible(a)

eligible_flag(a) := false if not premium_eligible(a)

# --- RGVE (Kapitel 9 und 10) ---------------------------------------------------------------------

# O6_21-RGVE-01/02: anteilige RGVE je Tier über die teilnehmenden Kategorien (taggenau, Jahresdurchschnitt).
animal_rgve(a) := sum([lib.category_rgve(a, cat_id) | some cat_id in participating_categories(a)])

eligible_animal_rgve[a.ear_tag] := lib.r4(animal_rgve(a)) if {
	some a in animals
	premium_eligible(a)
}

# Bruttowert aller Tiere in beantragten Kategorien (förderbare Rinder, vor Abmeldungen) – Basis für TGD-Schwelle.
gross_category_rgve := lib.r4(sum([animal_rgve(a) |
	some a in animals
	count(participating_categories(a)) > 0
	kept_in_austria(a)
]))

eligible_rgve := lib.r4(sum([v | some v in eligible_animal_rgve]))

rgve_by_category[cat_id] := lib.r4(total) if {
	some cat_id in application.valid_categories
	total := sum([lib.category_rgve(a, cat_id) |
		some a in animals
		premium_eligible(a)
		cat_id in participating_categories(a)
	])
}

# O6_21-APP-06: Kategorie ohne mindestens ein prämienfähiges Tier im Förderjahr erlischt automatisch.
categories_lapsing contains cat_id if {
	some cat_id in application.valid_categories
	count([a |
		some a in animals
		premium_eligible(a)
		cat_id in participating_categories(a)
	]) == 0
}

# O6_21-PREM-02: reduzierter Satz bei Alm, Tierwohl – Weide oder gekoppelter Stützung für Almrinder.
reduced_rate_animal(a) if object.get(a, "alpine_pasture_measure_premium", false)

reduced_rate_animal(a) if object.get(a, "pasture_measure_o6_20", false)

reduced_rate_animal(a) if object.get(a, "coupled_support_alpine", false)

animal_rate_id(a) := "reduced_overlap" if reduced_rate_animal(a)

animal_rate_id(a) := "standard" if not reduced_rate_animal(a)

animal_premium[a.ear_tag] := lib.r2(eligible_animal_rgve[a.ear_tag] * lib.rate(animal_rate_id(a), lib.year)) if {
	some a in animals
	premium_eligible(a)
}

animal_findings[a.ear_tag] := {
	"participating_categories": participating_categories(a),
	"issues": issues_of(a),
	"premium_eligible": eligible_flag(a),
	"deregistered": a.ear_tag in deregistered_tags,
} if {
	some a in animals
}
