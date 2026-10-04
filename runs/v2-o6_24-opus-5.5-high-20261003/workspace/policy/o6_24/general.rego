package oepul.o6_24

import rego.v1

# Allgemeine Teilnahmebedingungen (Stand April 2026), SRL ÖPUL 2023 Allgemeiner Teil
# und GSP-AV, soweit für o6_24 entscheidungsrelevant.

applicant := object.get(input, ["farm", "applicant"], {})

foerderwerber := data.o6_24.oepul_foerderwerber

# 5.2 / SRL 1.4: zulässige Rechtsformen; Gebietskörperschaften nur bei bestimmten
# Maßnahmen zulässig – o6_24 zählt nicht dazu.
applicant_legal_form_ok if {
	applicant.legal_form in {"natural_person", "registered_partnership"}
}

applicant_legal_form_ok if {
	applicant.legal_form in {"legal_person", "association"}
	object.get(applicant, "public_body_share_percent", 0) <= foerderwerber.max_public_body_share_percent
}

# 5.2 / SRL 1.4: aktiver Landwirt, Bewirtschaftung im eigenen Namen und auf eigene
# Rechnung, Verfügungsgewalt über die beantragten Flächen.
applicant_eligible if {
	applicant_legal_form_ok
	object.get(applicant, "is_active_farmer", false) == true
	object.get(applicant, "own_name_and_account", true) == true
	object.get(applicant, "has_disposal_over_areas", true) == true
}

min_size := data.o6_24.oepul_betriebsmindestgroesse

first_participation_year := object.get(oepul, "first_participation_year", null)

# 5.3 / SRL 1.6.1: Betriebsmindestgröße nur im ersten ÖPUL-Teilnahmejahr.
is_first_oepul_year if first_participation_year == farm_year

minimum_farm_size_met if not is_first_oepul_year

minimum_farm_size_met if {
	is_first_oepul_year
	object.get(input, ["land", "total_area_ha"], 0) >= min_size.agricultural_area_min_ha
}

minimum_farm_size_met if {
	is_first_oepul_year
	object.get(input, ["land", "protected_cultivation_area_ha"], 0) >= min_size.protected_cultivation_min_ha
}

# 5.6 / SRL 1.4.2.1: geförderte Flächen müssen in Österreich liegen.
parcel_outside_austria(p) if object.get(p, "in_austria", true) == false

# 5.4 / SRL 1.6.3.1: Mindestbewirtschaftung auf Ackerflächen (ausgenommen Ackerfutter).
min_harvest_share := 85

harvest_obligation_met(p) if {
	is_arable_forage(p)
}

harvest_obligation_met(p) if {
	is_fallow(p)
}

harvest_obligation_met(p) if {
	not is_arable_forage(p)
	not is_fallow(p)
	object.get(management_of(p), "harvested_share_percent", 100) >= min_harvest_share
}

harvest_obligation_met(p) if drought_harvest_exemption[p.parcel_id]

harvest_obligation_met(p) if object.get(management_of(p), "force_majeure_recognised", false) == true

min_management_met(p) if {
	not is_arable_forage(p)
	not is_fallow(p)
	object.get(management_of(p), "properly_sown", true) == true
	object.get(management_of(p), "properly_maintained", true) == true
	harvest_obligation_met(p)
}

# 5.4 / SRL 1.6.3.3: Ackerfutterflächen jährlich mindestens einmal vollflächige Mahd
# mit Verbringen des Mähgutes oder vollflächige Beweidung.
min_management_met(p) if {
	is_arable_forage(p)
	object.get(management_of(p), "full_mowing_or_grazing", true) == true
}

# 5.4 / SRL 1.6.3.4: aus der Produktion genommene Flächen: Gründecke und Häckseln/Pflegemahd
# zumindest jedes zweite Jahr.
min_management_met(p) if {
	is_fallow(p)
	object.get(management_of(p), "green_cover_established", true) == true
	object.get(management_of(p), "mulched_within_two_years", true) == true
}

# Anhang L: auf der Einzelfläche mit o6_24 prämienmäßig kombinierbare Maßnahmen.
combinable_with_24 := {c | some c in data.o6_24.srl_anhang_l.row_24_combinable}

combination_conflicts[p.parcel_id] := conflicts if {
	some p in parcels
	measure_code in measures_of(p)
	conflicts := {m | some m in measures_of(p); m != measure_code; not m in combinable_with_24}
	count(conflicts) > 0
}

# 5.5.2: Leistungsüberschneidung – gesetzlich vorgeschriebene Auflagen führen bei o6_24
# nicht zur OP-Codierung (SRL 1.6.2.3 Ausnahme), vertragliche Leistungsüberschneidung schon.
op_required_reasons[p.parcel_id] contains "Leistungsüberschneidung aus Vereinbarung mit der öffentlichen Hand" if {
	some p in parcels
	object.get(p, ["oepul", "public_funding_agreement_overlap"], false) == true
}

op_required_reasons[p.parcel_id] contains "Ernteverpflichtung nicht erfüllt" if {
	some p in area_arable_parcels
	not harvest_obligation_met(p)
}

op_required_reasons[p.parcel_id] contains "unterjährige Flächenweitergabe ohne Weiterführung bis Jahresende" if {
	some p in parcels
	object.get(p, ["oepul", "transferred_mid_year"], false) == true
	object.get(p, ["oepul", "successor_continues_obligations"], false) == false
}

op_required_reasons[p.parcel_id] contains "behördlich vorgeschriebene Ausgleichsfläche/Infrastrukturnutzung" if {
	some p in parcels
	object.get(p, ["oepul", "official_compensation_area"], false) == true
}

op_required_reasons[p.parcel_id] contains "Nichterfüllung durch reines Fremdverschulden" if {
	some p in parcels
	object.get(p, ["oepul", "third_party_fault"], false) == true
}

# 5.5.1 / SRL 1.6.2.2: Nationalparkflächen bleiben bei o6_24 prämienfähig.
national_park_excludes_premium := false

# GSP-AV § 6 Abs. 2: höhere Gewalt binnen drei Wochen ab Möglichkeit geltend machen.
force_majeure_cases := object.get(oepul, "force_majeure_cases", [])

force_majeure_notified_in_time(c) if {
	days_between(c.able_to_notify_date, c.notified_date) <= data.o6_24.gsp_av_hoehere_gewalt.notification_days
}

force_majeure_late contains c if {
	some c in force_majeure_cases
	not c.covered_by_general_recognition == true
	not force_majeure_notified_in_time(c)
}

# GSP-AV § 14 Abs. 2: Betriebsübertragung binnen vier Wochen anzeigen.
farm_transfer_notice_late if {
	t := object.get(oepul, "farm_transfer", null)
	is_object(t)
	days_between(t.effective_date, t.notified_date) > data.o6_24.oepul_fristen.farm_transfer_notification_days
}

# GSP-AV § 27 Abs. 2: Mindestgröße je förderfähiger Fläche 50 m².
parcel_below_min_size(p) if p.area_ha * 10000 < data.o6_24.gsp_av_flaechensanktion.min_parcel_m2

# GSP-AV § 28 Abs. 2: nicht-landwirtschaftliche Nutzung während der Vegetationsperiode
# höchstens 14 Kalendertage und vorab zu melden.
non_agricultural_use_excess(p) if {
	object.get(p, ["oepul", "non_agricultural_use_days_in_vegetation_period"], 0) > data.o6_24.gsp_av_nichtlandwirtschaftliche_nutzung.max_non_agri_days_in_vegetation_period
}

non_agricultural_use_excess(p) if {
	object.get(p, ["oepul", "non_agricultural_use_days_in_vegetation_period"], 0) > 0
	object.get(p, ["oepul", "non_agricultural_use_notified_in_advance"], false) == false
}

# GSP-AV § 9 Abs. 7 / SRL 1.11.1.2: verhinderte Kontrolle -> keine Fördermittel.
controls_obstructed if object.get(oepul, "controls_obstructed", false) == true
