# o6_8 - Mulchsaat (MS), Direktsaat und Strip-Till (DS)
# Kombinationsverpflichtung, Vorfrucht-Begrünung und Verfahrensdefinitionen
# gemäß Kapitel 3.2 und 4.1 des Maßnahmeninformationsblatts und SRL 2.8.
package oepul.o6_8

has_ms_or_ds(p) if has_code(p, "MS")

has_ms_or_ds(p) if has_code(p, "DS")

# --- Kombinationsverpflichtung (Zugangsvoraussetzung) ----------------------

combination_obligation_applies if {
	some p in parcels
	has_ms_or_ds(p)
}

combination_obligation_met if {
	some m in params.combination_obligation.required_any_of_measures
	m in participating_measures
}

farm_violations contains farm_violation("o6_8.combination.ms_ds_requires_catch_crop_measure", "MS/DS erfordern die zeitgleiche Teilnahme an Zwischenfruchtanbau (6) oder System Immergrün (7).") if {
	combination_obligation_applies
	not combination_obligation_met
}

# --- Vorangehende Begrünung -------------------------------------------------

preceding(p) := object.get(p, ["oepul_o6_8", "preceding_catch_crop"], {})

preceding_variant_ok(r, _) if count(r.variants) == 0

preceding_variant_ok(r, pc) if object.get(pc, "variant", null) in r.variants

preceding_overwinter_ok(r, _) if r.requires_overwintering == false

preceding_overwinter_ok(r, pc) if {
	r.requires_overwintering == true
	object.get(pc, "overwintering", false) == true
}

# Nach Ende des Immergrün-Vertrags (Wechsel in Zwischenfruchtanbau) ist MS/DS
# nach Immergrün-Zwischenfrüchten nicht mehr prämienfähig.
preceding_scheme_active(r) if r.scheme != "oepul2023_immergruen"

preceding_scheme_active(r) if {
	r.scheme == "oepul2023_immergruen"
	"7" in participating_measures
}

preceding_catch_crop_valid(p) if {
	pc := preceding(p)
	some r in params.preceding_catch_crop
	r.scheme == object.get(pc, "scheme", null)
	year_in_range(r, year)
	preceding_variant_ok(r, pc)
	preceding_overwinter_ok(r, pc)
	preceding_scheme_active(r)
}

parcel_violations contains violation("o6_8.ms_ds.preceding_catch_crop", p, c, "MS/DS nur im Anschluss an ZWF-Varianten 2, 4, 5, 6 (ÖPUL 2023), ÖPUL-2015-Varianten 4, 5, 6 (2023), GLÖZ-8-NPF-Varianten 2, 4, 5, 6 (MFA 2025) oder überwinternde Immergrün-Zwischenfrüchte prämienfähig.") if {
	some p in parcels
	some c in codes(p)
	c in {"MS", "DS"}
	not preceding_catch_crop_valid(p)
}

# --- Mulchsaat ---------------------------------------------------------------

tillage(p) := object.get(p, ["oepul_o6_8", "tillage"], {})

main_crop_sowing_date(p) := object.get(p, ["oepul_o6_8", "main_crop_sowing_date"], null)

inverting_tillage(p) if object.get(tillage(p), "inverting_or_deep_mixing", false) == true

inverting_tillage(p) if object.get(p, ["operations", "tillage_type"], null) == "plough"

parcel_violations contains violation("o6_8.ms.no_inverting_tillage", p, c, "Wendende und tief mischende Bodenbearbeitung ist bei MS/DS unzulässig.") if {
	some p in parcels
	some c in codes(p)
	c in {"MS", "DS"}
	inverting_tillage(p)
}

parcel_violations contains violation("o6_8.ms.definition_flat_non_inverting", p, "MS", "Bei Mulchsaat muss Pflanzenmulch der Zwischenfrucht an der Oberfläche verbleiben.") if {
	some p in parcels
	has_code(p, "MS")
	object.get(tillage(p), "plant_mulch_on_surface", true) == false
}

deep_loosening_permitted(p) if {
	object.get(tillage(p), "deep_loosening", false) == true
	object.get(tillage(p), "deep_loosening_cover_preserved", false) == true
}

parcel_violations contains violation("o6_8.ms.deep_loosening_cover_preserved", p, c, "Tiefenlockerung nur mit maßgeblichem Erhalt der Begrünungskultur zulässig.") if {
	some p in parcels
	some c in codes(p)
	c in {"MS", "DS"}
	object.get(tillage(p), "deep_loosening", false) == true
	not deep_loosening_permitted(p)
}

ms_days_first_tillage_to_sowing(p) := days_between(tillage(p).first_tillage_date, main_crop_sowing_date(p))

parcel_violations contains violation("o6_8.ms.max_4_weeks_tillage_to_sowing", p, "MS", sprintf("Zwischen erster Bodenbearbeitung und Anbau liegen %v Tage (max. 28).", [ms_days_first_tillage_to_sowing(p)])) if {
	some p in parcels
	has_code(p, "MS")
	ms_days_first_tillage_to_sowing(p) > params.ms_max_days_first_tillage_to_sowing
}

# --- Direktsaat / Strip-Till ------------------------------------------------

ds_method(p) := object.get(tillage(p), "ds_method", "direct_seeding")

parcel_violations contains violation("o6_8.ds.definition_direct_seeding", p, "DS", "Direktsaat: keine vollflächige Bodenbearbeitung, nur Einsaat im Schlitzverfahren direkt in den Begrünungsbestand.") if {
	some p in parcels
	has_code(p, "DS")
	ds_method(p) == "direct_seeding"
	object.get(tillage(p), "full_surface_tillage", false) == true
}

parcel_violations contains violation("o6_8.ds.definition_direct_seeding", p, "DS", "Direktsaat erfordert Einsaat mittels Schlitzverfahren.") if {
	some p in parcels
	has_code(p, "DS")
	ds_method(p) == "direct_seeding"
	object.get(tillage(p), "slot_seeding", true) == false
}

parcel_violations contains violation("o6_8.ds.definition_strip_till", p, "DS", "Strip-Till: Bearbeitung nur streifenförmig in der Saatreihe, Zwischenfrucht bzw. Pflanzenreste zwischen den Streifen erhalten.") if {
	some p in parcels
	has_code(p, "DS")
	ds_method(p) == "strip_till"
	strip_till_breach(p)
}

strip_till_breach(p) if object.get(tillage(p), "strip_only_in_seed_row", true) == false

strip_till_breach(p) if object.get(tillage(p), "cover_residues_retained_between_strips", true) == false

strip_till_breach(p) if object.get(tillage(p), "full_surface_tillage", false) == true

# --- Codekombinationen auf der Einzelfläche ----------------------------------

ms_ds_ah_conflict(p) if {
	has_ms_or_ds(p)
	has_code(p, "AH")
}

parcel_violations contains violation("o6_8.premium.ms_ds_ah_not_combinable", p, "AH", "MS/DS und AH sind auf der Einzelfläche nicht prämienfähig kombinierbar.") if {
	some p in parcels
	ms_ds_ah_conflict(p)
}

allowed_code_pair(a, b) if {
	some pair in params.allowed_same_parcel_code_pairs
	{a, b} == {x | some x in pair}
}

# Explizit zulässig sind nur MS+US und DS+US; andere Mehrfachcodierungen werden als
# offene Frage gemeldet (keine Prämienwirkung, siehe notes/assumptions.md).
unlisted_code_combinations contains {"parcel_id": pid(p), "codes": [a, b]} if {
	some p in parcels
	some a in codes(p)
	some b in codes(p)
	a < b
	not allowed_code_pair(a, b)
	not {a, b} in {{"MS", "AH"}, {"DS", "AH"}}
}

# Option "Humusaufbau und Erosionsschutz in Wien": keine MS/DS-Prämie auf Wiener Flächen.
vienna_humus_option_blocks(p) if {
	"16_humus_wien" in farm_options
	parcel_location(p).federal_state == "Wien"
}
