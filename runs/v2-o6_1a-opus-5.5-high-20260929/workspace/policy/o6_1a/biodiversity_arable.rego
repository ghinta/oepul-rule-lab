# METADATA
# title: UBB (o6_1a) – Biodiversitätsflächen auf Ackerflächen (Kapitel 6.1)
package oepul.o6_1a.biodiversity_arable

import data.oepul.o6_1a.biodiversity_grassland
import data.oepul.o6_1a.common

bio(p) := object.get(p, "biodiversity", {})

first_year(p) := object.get(bio(p), "first_declared_year", common.year)

year_events(p) := [e | some e in object.get(p, ["operations", "use_events"], []); common.date_year(e.date) == common.year]

# ---------------------------------------------------------------------------
# Anrechenbarkeit (UBB-DIVA-ANR-001..006)
# ---------------------------------------------------------------------------
creditable_blocked(p) if common.has_code(p, "K20")

# Naturschutz-Ackerstilllegungen nur mit Auflage SA01; genutzte Naturschutzflächen nicht anrechenbar.
creditable_blocked(p) if {
	common.has_code(p, "NAT")
	count(common.conditions(p) & {c | some c in common.tables.o6_1a_naturschutz_arable_set_aside_conditions}) == 0
}

creditable_blocked(p) if {
	common.has_code(p, "NAT")
	object.get(bio(p), "nature_area_used", false)
}

creditable_blocked(p) if {
	some c in {"NAT", "EBW"}
	common.has_code(p, c)
	common.schlagnutzungsart(p) != "Grünbrache"
}

# BAW/AG nur, wenn die Pflege-/Nutzungsauflagen für Biodiversitätsflächen eingehalten werden.
creditable_blocked(p) if {
	some c in {"BAW", "AG"}
	common.has_code(p, c)
	object.get(bio(p), "div_care_compliant", true) == false
}

# GLÖZ 8-Stilllegungen nur bis einschließlich Antragsjahr 2024.
creditable_blocked(p) if {
	common.has_code(p, "GLOEZ8")
	common.year >= 2025
}

creditable_blocked(p) if {
	some c in {"GLOEZ4", "GLOEZ8"}
	common.has_code(p, c)
	object.get(bio(p), "div_conditions_compliant", true) == false
}

creditable_arable_div(p) if {
	common.is_arable_div(p)
	not creditable_blocked(p)
}

# Mehrnutzenhecken sind anrechenbar, wenn der krautige Bereich die Pflegeauflagen erfüllt.
creditable_arable_div(p) if {
	common.area_kind(p) == "mehrnutzenhecke"
	common.has_code(p, "DIV")
	object.get(p, ["hedge", "herbaceous_div_care_compliant"], true)
}

creditable_parcels := [p | some p in common.parcels; creditable_arable_div(p)]

arable_div_area_ha := sum([common.area(p) | some p in creditable_parcels])

# ---------------------------------------------------------------------------
# Mindestanlage 7 % (UBB-DIVA-MIN-001..003)
# ---------------------------------------------------------------------------
min_share := common.limits.div_minimum_share

obligation_applies if common.arable_area_ha > 2.0

required_arable_div_ha := common.arable_area_ha * min_share if obligation_applies

default minimum_met := false

minimum_met if not obligation_applies

minimum_met if {
	obligation_applies
	arable_div_area_ha >= required_arable_div_ha - common.eps
}

# Betriebe bis 10 ha Ackerfläche: Erfüllung auch über zusätzliche Grünland-Biodiversitätsflächen.
minimum_met if {
	obligation_applies
	common.arable_area_ha <= 10.0
	combined := arable_div_area_ha + biodiversity_grassland.grassland_div_area_ha
	combined >= (min_share * (common.arable_area_ha + common.mown_grassland_area_ha)) - common.eps
	biodiversity_grassland.grassland_div_area_ha >= biodiversity_grassland.required_grassland_div_ha_or_zero - common.eps
}

violations contains {"rule_id": "UBB-DIVA-MIN-001", "subject": "farm", "message": sprintf("Acker-Biodiversitätsflächen %v ha unter Mindestanlage %v ha (7 %% der Ackerfläche)", [arable_div_area_ha, required_arable_div_ha])} if {
	obligation_applies
	not minimum_met
}

# ---------------------------------------------------------------------------
# Feldstücksbezogene Anlageverpflichtung (UBB-DIVA-FS-001..004)
# ---------------------------------------------------------------------------
field_pieces := {common.field_piece(p) | some p in common.arable_parcels}

fp_arable_area(fp) := sum([common.area(p) | some p in common.arable_parcels; common.field_piece(p) == fp])

fp_credit_kind(p) if creditable_arable_div(p)

fp_credit_kind(p) if common.area_kind(p) == "gloez_landscape_element"

fp_credit_kind(p) if {
	common.area_kind(p) == "agroforststreifen"
	common.year >= 2025
}

fp_div_credit(fp) := sum([common.area(p) | some p in common.parcels; common.field_piece(p) == fp; fp_credit_kind(p)])

# Ausnahme 2023: Feldstücke mit Neonicotinoid-gebeizten Zuckerrüben 2022 (alle Schläge Code AZR).
azr_exempt(fp) if {
	common.year == 2023
	fp_parcels := [p | some p in common.arable_parcels; common.field_piece(p) == fp]
	count(fp_parcels) > 0
	every p in fp_parcels {
		common.has_code(p, "AZR")
	}
}

field_piece_obligation_applies if common.arable_area_ha >= 10.0

violations contains {"rule_id": "UBB-DIVA-FS-001", "subject": fp, "message": sprintf("Feldstück %s (%v ha Acker): nur %v ha Biodiversitätsflächen/anrechenbare Flächen (mind. 0,15 ha)", [fp, fp_arable_area(fp), fp_div_credit(fp)])} if {
	field_piece_obligation_applies
	some fp in field_pieces
	fp_arable_area(fp) > 5.0
	fp_div_credit(fp) < 0.15 - common.eps
	not azr_exempt(fp)
}

violations contains {"rule_id": "UBB-DIVA-FS-003", "subject": common.parcel_id(p), "message": "Code AZR nur im Antragsjahr 2023 zulässig"} if {
	some p in common.parcels
	common.has_code(p, "AZR")
	common.year != 2023
}

# ---------------------------------------------------------------------------
# Bewirtschaftungsauflagen – Ansaat (UBB-DIVA-ANS-001..006)
# ---------------------------------------------------------------------------
own_managed(p) if {
	common.is_arable_div(p)
	not common.has_code(p, "NAT")
	not common.has_code(p, "EBW")
}

sowing_obligation(p) if {
	own_managed(p)
	not common.has_code(p, "BAW")
	not common.has_code(p, "AG")
}

exemption_valid(p) if {
	object.get(bio(p), "sowing_exemption", "none") in {"existing_fallow_since_2020", "oepul2015_div_sown_2021_2022"}
	object.get(bio(p), "exemption_evidence_ok", false)
	object.get(bio(p), "ploughed_since", false) == false
}

new_sowing_year(p) if {
	sowing_obligation(p)
	first_year(p) == common.year
	not exemption_valid(p)
}

mix(p) := object.get(bio(p), "seed_mixture", {})

violations contains {"rule_id": "UBB-DIVA-ANS-001", "subject": common.parcel_id(p), "message": "Bienenmischung erfüllt nicht mind. 7 insektenblütige Mischungspartner aus mind. 3 Pflanzenfamilien bei max. 10 % nicht insektenblütigen Partnern"} if {
	some p in common.parcels
	new_sowing_year(p)
	not seed_mix_ok(p)
}

seed_mix_ok(p) if {
	object.get(mix(p), "insect_pollinated_partners", 0) >= 7
	object.get(mix(p), "plant_families", 0) >= 3
	object.get(mix(p), "non_insect_pollinated_share_percent", 100) <= 10
}

violations contains {"rule_id": "UBB-DIVA-ANS-002", "subject": common.parcel_id(p), "message": "Neuansaat der Biodiversitätsfläche nicht bis 15. Mai erfolgt"} if {
	some p in common.parcels
	new_sowing_year(p)
	not sown_in_time(p)
}

sown_in_time(p) if {
	d := object.get(bio(p), "sowing_date", null)
	d != null
	d <= sprintf("%d-05-15", [common.year])
}

# Umbruch frühestens 15.09. des 2. Jahres; bei Winterung/Zwischenfrucht nach dem 31.07. des 2. Jahres.
second_year(p) := object.get(bio(p), "establishment_year", first_year(p)) + 1

earliest_breakup(p) := sprintf("%d-08-01", [second_year(p)]) if object.get(bio(p), "followed_by_winter_crop_or_catch_crop", false)

earliest_breakup(p) := sprintf("%d-09-15", [second_year(p)]) if not object.get(bio(p), "followed_by_winter_crop_or_catch_crop", false)

breakup_exception(p) if object.get(bio(p), "breakup_reason", "") in {"loss_of_control", "conversion_to_grassland"}

violations contains {"rule_id": "UBB-DIVA-ANS-003", "subject": common.parcel_id(p), "message": sprintf("Umbruch am %s vor dem frühestmöglichen Termin %s (Zweijährigkeit)", [bio(p).breakup_date, earliest_breakup(p)])} if {
	some p in common.parcels
	own_managed(p)
	object.get(bio(p), "breakup_date", null) != null
	bio(p).breakup_date < earliest_breakup(p)
	not breakup_exception(p)
}

violations contains {"rule_id": "UBB-DIVA-ANS-004", "subject": common.parcel_id(p), "message": "Nutzung einer umgebrochenen Grünbrache-Biodiversitätsfläche vor dem 31.12."} if {
	some p in common.parcels
	common.is_arable_div(p)
	common.schlagnutzungsart(p) == "Grünbrache"
	object.get(bio(p), "breakup_date", null) != null
	object.get(bio(p), "used_after_breakup_same_year", false)
}

violations contains {"rule_id": "UBB-DIVA-ANS-005", "subject": common.parcel_id(p), "message": "Neuanlage nach Zerstörung durch höhere Gewalt/Wildschweine ohne anerkanntes Ansuchen"} if {
	some p in common.parcels
	common.is_arable_div(p)
	object.get(bio(p), "resown_after_destruction", false)
	not object.get(bio(p), "force_majeure_recognized", false)
}

violations contains {"rule_id": "UBB-DIVA-ANS-006", "subject": common.parcel_id(p), "message": "Sanierung wegen Verunkrautung ohne aufbewahrte Nachweise"} if {
	some p in common.parcels
	common.is_arable_div(p)
	object.get(bio(p), "resown_due_to_weeds", false)
	not object.get(bio(p), "weed_evidence_kept", false)
}

violations contains {"rule_id": "UBB-DIVA-ANS-007", "subject": common.parcel_id(p), "message": "Biodiversitätsfläche nicht in zwei aufeinanderfolgenden Mehrfachanträgen lagegenau beantragt"} if {
	some p in common.parcels
	own_managed(p)
	object.get(bio(p), "breakup_date", null) != null
	object.get(bio(p), "consecutive_years_same_location", 2) < 2
	not breakup_exception(p)
}

# ---------------------------------------------------------------------------
# Pflege-/Nutzungsauflagen (UBB-DIVA-PFL-001..010)
# ---------------------------------------------------------------------------
no_premium_2026_code(p) if {
	common.year == 2026
	some c in common.tables.o6_1a_drought_2026_parameters.no_premium_codes
	common.has_code(p, c)
}

first_year_new_sowing(p) if {
	first_year(p) == common.year
	object.get(bio(p), "sowing_date", null) != null
}

# Reinigungsschnitt (ab 2025, nur Neuansaat im ersten Jahr) ohne Verbringung zählt nicht.
counts_as_use(_, e) if {
	e.type in {"mow", "mulch", "graze"}
	not post_grazing_care(e)
}

counts_as_use(p, e) if {
	e.type == "cleaning_cut"
	not free_cleaning_cut(p, e)
}

post_grazing_care(e) if {
	common.year >= 2025
	e.type in {"mow", "mulch"}
	object.get(e, "post_grazing_care", false)
	object.get(e, "material_removed", false) == false
}

free_cleaning_cut(p, e) if {
	common.year >= 2025
	e.type == "cleaning_cut"
	first_year_new_sowing(p)
	object.get(e, "material_removed", false) == false
}

use_count(p) := count([e | some e in year_events(p); counts_as_use(p, e)])

invasive_share := object.get(input, ["farm", "oepul", "ubb", "arable_div_invasive_share_percent"], 0)

invasive_exception(p) if {
	invasive_share > 25
	object.get(bio(p), "invasive_species_present", false)
	common.year <= first_year(p) + 1
}

max_uses(p) := 3 if no_premium_2026_code(p)

max_uses(p) := 2 if not no_premium_2026_code(p)

care_managed(p) if {
	own_managed(p)
	not common.has_code(p, "DIVRS")
}

violations contains {"rule_id": "UBB-DIVA-PFL-002", "subject": common.parcel_id(p), "message": sprintf("%d Nutzungen (Mähen/Häckseln/Weide) im Jahr, maximal %d erlaubt", [use_count(p), max_uses(p)])} if {
	some p in common.parcels
	care_managed(p)
	use_count(p) > max_uses(p)
	not invasive_exception(p)
}

violations contains {"rule_id": "UBB-DIVA-PFL-001", "subject": common.parcel_id(p), "message": "Biodiversitätsfläche nicht mindestens einmal in zwei Jahren gemäht/gehäckselt/beweidet"} if {
	some p in common.parcels
	own_managed(p)
	not common.has_code(p, "DIVRS")
	first_year(p) < common.year
	use_count(p) == 0
	object.get(bio(p), "used_previous_year", true) == false
}

violations contains {"rule_id": "UBB-DIVA-PFL-003", "subject": common.parcel_id(p), "message": "Drusch auf Biodiversitätsflächen nicht erlaubt"} if {
	some p in common.parcels
	common.is_arable_div(p)
	some e in year_events(p)
	e.type == "thresh"
}

violations contains {"rule_id": "UBB-DIVA-PFL-004", "subject": common.parcel_id(p), "message": "Beweidung von Acker-Biodiversitätsflächen bis einschließlich 2024 nicht erlaubt"} if {
	common.year <= 2024
	some p in common.parcels
	care_managed(p)
	some e in year_events(p)
	e.type == "graze"
}

violations contains {"rule_id": "UBB-DIVA-PFL-005", "subject": common.parcel_id(p), "message": "Beweidung von Acker-Biodiversitätsflächen erst ab 1. August zulässig"} if {
	common.year >= 2025
	some p in common.parcels
	care_managed(p)
	not no_premium_2026_code(p)
	some e in year_events(p)
	e.type == "graze"
	common.month_day(e.date) < "08-01"
}

mowed_before_august(p) if {
	some e in year_events(p)
	e.type in {"mow", "mulch", "cleaning_cut"}
	counts_as_use(p, e)
	common.month_day(e.date) < "08-01"
}

grazings_after_august(p) := count([e | some e in year_events(p); e.type == "graze"; common.month_day(e.date) >= "08-01"])

violations contains {"rule_id": "UBB-DIVA-PFL-006", "subject": common.parcel_id(p), "message": "Nach Mahd/Häckseln vor dem 1. August nur einmalige Beweidung ab 1. August zulässig"} if {
	common.year >= 2025
	some p in common.parcels
	care_managed(p)
	mowed_before_august(p)
	grazings_after_august(p) > 1
}

# 75 % der Acker-Biodiversitätsflächen frühestens ab 1. August (alle DIV-Flächen inkl. BAW, AG, NAT, EBW als Basis).
all_div_parcels := [p | some p in common.parcels; common.is_arable_div(p)]

all_div_area_ha := sum([common.area(p) | some p in all_div_parcels])

project_early_area_ha := sum([common.area(p) | some p in all_div_parcels; not own_managed(p); mowed_before_august(p)])

ubb_early_area_ha := sum([common.area(p) | some p in all_div_parcels; own_managed(p); mowed_before_august(p); not no_premium_2026_code(p); not invasive_exception(p)])

early_quota_ha := common.max_of(0, (all_div_area_ha * 0.25) - project_early_area_ha)

violations contains {"rule_id": "UBB-DIVA-PFL-007", "subject": "farm", "message": sprintf("Vor dem 1. August genutzte Biodiversitätsfläche %v ha überschreitet die zulässigen 25 %% (%v ha)", [ubb_early_area_ha, early_quota_ha])} if {
	ubb_early_area_ha > early_quota_ha + common.eps
}

violations contains {"rule_id": "UBB-DIVA-PFL-008", "subject": common.parcel_id(p), "message": "Reinigungsschnitt nur im Jahr der ersten Beantragung auf Flächen mit Neuansaat zulässig"} if {
	common.year >= 2025
	some p in common.parcels
	care_managed(p)
	some e in year_events(p)
	e.type == "cleaning_cut"
	not first_year_new_sowing(p)
	common.month_day(e.date) < "08-01"
}

# ---------------------------------------------------------------------------
# Betriebsmitteleinsatz und Befahren (UBB-DIVA-BM-001..003, UBB-DIVA-BEF-001)
# ---------------------------------------------------------------------------
violations contains {"rule_id": "UBB-DIVA-BM-001", "subject": common.parcel_id(p), "message": "Düngung auf Acker-Biodiversitätsfläche verboten"} if {
	some p in common.parcels
	sowing_obligation(p)
	some f in object.get(p, ["operations", "fertilization_events"], [])
	f.date >= sprintf("%d-01-01", [first_year(p)])
}

violations contains {"rule_id": "UBB-DIVA-BM-002", "subject": common.parcel_id(p), "message": "Pflanzenschutzmittel mit nicht gemäß VO (EU) 2018/848 zulässigen Wirkstoffen eingesetzt"} if {
	some p in common.parcels
	sowing_obligation(p)
	some a in object.get(p, ["operations", "psm_applications"], [])
	a.date >= sprintf("%d-01-01", [first_year(p)])
	not object.get(a, "organic_approved_only", false)
}

violations contains {"rule_id": "UBB-DIVA-BM-003", "subject": common.parcel_id(p), "message": "Beseitigung der Biodiversitätsfläche nur mechanisch (Häckseln oder Einarbeiten) zulässig"} if {
	some p in common.parcels
	common.is_arable_div(p)
	object.get(bio(p), "removal_method", "mechanical") != "mechanical"
}

violations contains {"rule_id": "UBB-DIVA-BEF-001", "subject": common.parcel_id(p), "message": sprintf("Unzulässige Verwendung der Biodiversitätsfläche: %s", [d.purpose])} if {
	some p in common.parcels
	sowing_obligation(p)
	some d in object.get(p, ["operations", "driving_events"], [])
	common.date_year(d.date) == common.year
	d.purpose != "crossing"
}

# ---------------------------------------------------------------------------
# Zuschlag Neuansaat mit regionaler Acker-Saatgutmischung DIVRS (UBB-DIVRSA-001..009)
# ---------------------------------------------------------------------------
divrs_parcels := [p | some p in common.arable_parcels; common.has_code(p, "DIVRS")]

regional_mix_ok(p) if {
	m := mix(p)
	object.get(m, "regional_list_species", 0) >= 30
	object.get(m, "regional_list_families", 0) >= 7
	object.get(m, "seed_rate_kg_per_ha", 0) >= 20
	single_species_ok(m)
	object.get(m, "regional_origin_certified", false)
	object.get(m, "documented_labels_invoices", false)
}

single_species_ok(m) if object.get(m, "max_single_species_weight_percent", 100) <= 5

single_species_ok(m) if object.get(m, "ecotype_seed_used", false)

divrs_eligible(p) if {
	common.has_code(p, "DIVRS")
	regional_mix_ok(p)
	common.year <= 2028
	object.get(bio(p), "divrs_continuous_since_sowing", true)
	not divrs_care_violation(p)
}

violations contains {"rule_id": "UBB-DIVRSA-001", "subject": common.parcel_id(p), "message": "Regionale Acker-Saatgutmischung erfüllt Vorgaben nicht (30 Arten/7 Familien, 20 kg/ha, max. 5 %, Herkunftsnachweis, Dokumentation)"} if {
	some p in divrs_parcels
	not regional_mix_ok(p)
}

violations contains {"rule_id": "UBB-DIVRSA-003", "subject": common.parcel_id(p), "message": "Unterbrochene DIVRS-Beantragung erfordert neuerliche Neuansaat"} if {
	some p in divrs_parcels
	object.get(bio(p), "divrs_continuous_since_sowing", true) == false
}

divrs_variant(p) := "gruenbrache" if {
	common.year >= 2025
	common.schlagnutzungsart(p) == "Grünbrache"
}

divrs_variant(p) := "sonstiges_feldfutter" if common.schlagnutzungsart(p) != "Grünbrache"

divrs_variant(p) := "sonstiges_feldfutter" if {
	common.year <= 2024
	common.schlagnutzungsart(p) == "Grünbrache"
}

mow_with_removal_count(p) := count([e | some e in year_events(p); e.type in {"mow", "cleaning_cut"}; object.get(e, "material_removed", false)])

mulch_count(p) := count([e | some e in year_events(p); e.type in {"mulch", "cleaning_cut"}; object.get(e, "material_removed", false) == false])

# Bis 2024 bzw. Variante Sonstiges Feldfutter: Mahd 1–2 x jährlich mit Verbringung, kein Häckseln (keine Weide).
divrs_care_violation(p) if {
	divrs_variant(p) == "sonstiges_feldfutter"
	mow_with_removal_count(p) < 1
}

divrs_care_violation(p) if {
	divrs_variant(p) == "sonstiges_feldfutter"
	mow_with_removal_count(p) > 2
}

divrs_care_violation(p) if {
	divrs_variant(p) == "sonstiges_feldfutter"
	some e in year_events(p)
	e.type == "mulch"
}

divrs_care_violation(p) if {
	divrs_variant(p) == "sonstiges_feldfutter"
	some e in year_events(p)
	e.type == "graze"
}

# Variante Grünbrache (ab 2025): Häckseln mind. 1 x in 2 Jahren, max. 1 x jährlich, frühestens ab 1. Oktober;
# Reinigungsschnitt im ersten Jahr darf früher erfolgen, zählt aber als Häckseln.
divrs_care_violation(p) if {
	divrs_variant(p) == "gruenbrache"
	mulch_count(p) > 1
}

divrs_care_violation(p) if {
	divrs_variant(p) == "gruenbrache"
	some e in year_events(p)
	e.type == "mulch"
	common.month_day(e.date) < "10-01"
}

divrs_care_violation(p) if {
	divrs_variant(p) == "gruenbrache"
	some e in year_events(p)
	e.type in {"mow", "graze"}
}

divrs_care_violation(p) if {
	divrs_variant(p) == "gruenbrache"
	mulch_count(p) == 0
	object.get(bio(p), "used_previous_year", true) == false
	first_year(p) < common.year
}

divrs_care_violation(p) if {
	some e in year_events(p)
	e.type == "cleaning_cut"
	not first_year_new_sowing(p)
}

violations contains {"rule_id": "UBB-DIVRSA-004", "subject": common.parcel_id(p), "message": "Pflege-/Nutzungsauflagen der DIVRS-Ackerfläche nicht eingehalten"} if {
	some p in divrs_parcels
	divrs_care_violation(p)
}

violations contains {"rule_id": "UBB-DIVRSA-002", "subject": common.parcel_id(p), "message": "DIVRS-Beantragung nur bis längstens 2028 möglich"} if {
	some p in divrs_parcels
	common.year > 2028
}

# ---------------------------------------------------------------------------
# Kennzeichnung/Schlagnutzungsarten (UBB-ANT-010..014)
# ---------------------------------------------------------------------------
allowed_div_sna(code) := {r.schlagnutzungsart |
	some r in common.tables.o6_1a_arable_div_schlagnutzungsarten
	r.from_year <= common.year
	code in r.codes
	sna_code_year_ok(r, code)
}

sna_code_year_ok(_, code) if code == "DIV"

sna_code_year_ok(r, code) if {
	code == "DIVRS"
	r.divrs_from_year != null
	r.divrs_from_year <= common.year
}

violations contains {"rule_id": "UBB-ANT-010", "subject": common.parcel_id(p), "message": sprintf("Code %s auf Schlagnutzungsart %s nicht zulässig", [c, common.schlagnutzungsart(p)])} if {
	some p in common.arable_parcels
	some c in {"DIV", "DIVRS"}
	common.has_code(p, c)
	not common.has_code(p, "NAT")
	not common.has_code(p, "EBW")
	not common.has_code(p, "BAW")
	not common.has_code(p, "AG")
	not common.schlagnutzungsart(p) in allowed_div_sna(c)
}

violations contains {"rule_id": "UBB-ANT-011", "subject": common.parcel_id(p), "message": "NAT/EBW-Biodiversitätsflächen sind als Grünbrache zu beantragen"} if {
	some p in common.arable_parcels
	common.has_code(p, "DIV")
	some c in {"NAT", "EBW"}
	common.has_code(p, c)
	common.schlagnutzungsart(p) != "Grünbrache"
}

violations contains {"rule_id": "UBB-ANT-012", "subject": common.parcel_id(p), "message": "BAW/AG-Biodiversitätsflächen sind als Grünbrache oder Sonstiges Feldfutter zu beantragen"} if {
	some p in common.arable_parcels
	common.has_code(p, "DIV")
	some c in {"BAW", "AG"}
	common.has_code(p, c)
	not common.schlagnutzungsart(p) in {"Grünbrache", "Sonstiges Feldfutter"}
}
