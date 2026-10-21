# o6_8 - Begrünte Abflusswege (BAW)
# Kapitel 4.3, 5 und 6 des Maßnahmeninformationsblatts, SRL 2.8 und Anhang F
# (Gebietsabgrenzung der Erosions-Eintragspfade nach Katastralgemeinden).
package oepul.o6_8

baw(p) := object.get(p, ["oepul_o6_8", "baw"], {})

baw_field(p, f) := object.get(baw(p), f, null)

# --- Gebietskulisse Anhang F -----------------------------------------------

anhang_f_kg_nrs := {r.kg_nr | some r in data.o6_8.anhang_f_erosion_pathway_kgs.rows}

kg_in_anhang_f(kg_nr) if kg_nr in anhang_f_kg_nrs

parcel_violations contains violation("o6_8.baw.anhang_f_area", p, "BAW", sprintf("Katastralgemeinde %v liegt nicht in der Gebietsabgrenzung für Begrünte Abflusswege (Anhang F).", [parcel_location(p).kg_nr])) if {
	some p in parcels
	has_code(p, "BAW")
	parcel_location(p).kg_nr != null
	not kg_in_anhang_f(parcel_location(p).kg_nr)
}

# --- Lage auf dem Erosions-Eintragspfad ------------------------------------

baw_path_area_ha(p) := baw_field(p, "erosion_path_area_ha")

baw_path_share(p) := s if {
	s := baw_field(p, "erosion_path_share")
	s != null
} else := baw_path_area_ha(p) / parcel_area(p) if {
	baw_path_area_ha(p) != null
	parcel_area(p) > 0
}

parcel_violations contains violation("o6_8.baw.erosion_path_quarter_share", p, "BAW", sprintf("Nur %v des Schlages liegen auf einem ausgewiesenen Erosions-Eintragspfad (mind. ein Viertel erforderlich).", [baw_path_share(p)])) if {
	some p in parcels
	has_code(p, "BAW")
	baw_path_share(p) < params.baw_min_erosion_path_share
}

# --- Höchstausmaß: vierfache Eintragspfadfläche ----------------------------

baw_max_area_ha(path_area_ha) := path_area_ha * rate_table.baw_max_factor_of_erosion_path_area

# Hinweis zur Antragstellung: der BAW-Schlag darf höchstens das Vierfache des
# Eintragspfades ausmachen; die Prämie wird höchstens für diese Fläche gewährt.
application_notices contains violation("o6_8.baw.max_four_times_erosion_path", p, "BAW", sprintf("Mit BAW beantragte Fläche %v ha übersteigt das Vierfache des Eintragspfades (%v ha).", [parcel_area(p), baw_max_area_ha(baw_path_area_ha(p))])) if {
	some p in parcels
	has_code(p, "BAW")
	baw_path_area_ha(p) != null
	parcel_area(p) > baw_max_area_ha(baw_path_area_ha(p))
}

# Prämienfähige BAW-Fläche: höchstens 4-fache Eintragspfadfläche, abzüglich
# GLÖZ-4-Pufferstreifen und (bis 2024) GLÖZ-8-Stilllegungsanteil.
baw_gloez_excluded_ha(p) := object.get(baw(p), "gloez4_buffer_area_ha", 0) + gloez8_part(p)

gloez8_part(p) := object.get(baw(p), "gloez8_fallow_area_ha", 0) if {
	year <= params.baw_gloez8_npf_credit_until_year
} else := 0

baw_eligible_area_ha(p) := max([0, min([parcel_area(p), baw_max_area_ha(baw_path_area_ha(p))]) - baw_gloez_excluded_ha(p)]) if {
	baw_path_area_ha(p) != null
} else := max([0, parcel_area(p) - baw_gloez_excluded_ha(p)])

# --- Anlage ----------------------------------------------------------------

baw_new_sowing(p) if baw_field(p, "existing_stand_retained") != true

parcel_violations contains violation("o6_8.baw.sowing_by_15_may", p, "BAW", "Einsaat der Begrünungsmischung hat bis spätestens 15. Mai des Kalenderjahres zu erfolgen.") if {
	some p in parcels
	has_code(p, "BAW")
	baw_new_sowing(p)
	d := baw_field(p, "sowing_date")
	d != null
	after(d, ymd(date_year(d), params.baw_sowing_deadline_mmdd))
}

parcel_violations contains violation("o6_8.baw.sowing_by_15_may", p, "BAW", "Neueinsaat muss eine winterharte Begrünungsmischung sein.") if {
	some p in parcels
	has_code(p, "BAW")
	baw_new_sowing(p)
	baw_field(p, "winter_hardy_mixture") == false
}

parcel_violations contains violation("o6_8.baw.sowing_by_15_may", p, "BAW", sprintf("Leguminosenanteil der Neueinsaat %v %% (muss unter 50 %% liegen).", [baw_field(p, "legume_share_percent")])) if {
	some p in parcels
	has_code(p, "BAW")
	baw_new_sowing(p)
	baw_field(p, "legume_share_percent") >= params.baw_max_legume_share_percent_new_sowing
}

parcel_violations contains violation("o6_8.baw.existing_stand_without_resowing", p, "BAW", "Ohne Neueinsaat kann nur ein bestehender Grünbrache- oder Feldfutterbestand belassen werden.") if {
	some p in parcels
	has_code(p, "BAW")
	baw_field(p, "existing_stand_retained") == true
	not baw_field(p, "existing_stand_type") in {"gruenbrache", "feldfutter"}
}

# --- Umbruch ---------------------------------------------------------------

# Bei lagegenauer Übernahme zählt das Anlagejahr des Vorbewirtschafters.
baw_establishment_year(p) := baw_field(p, "establishment_year")

baw_earliest_ploughing_date(p) := ymd(baw_establishment_year(p) + 1, params.baw_earliest_ploughing_mmdd)

parcel_violations contains violation("o6_8.baw.ploughing_earliest_15_sep_year2", p, "BAW", sprintf("Umbruch am %v vor dem frühestmöglichen Termin %v.", [baw_field(p, "ploughing_date"), baw_earliest_ploughing_date(p)])) if {
	some p in parcels
	has_code(p, "BAW")
	baw_field(p, "ploughing_date") != null
	baw_establishment_year(p) != null
	date_ns(baw_field(p, "ploughing_date")) < date_ns(baw_earliest_ploughing_date(p))
}

# Für den abgebenden Betrieb gilt die Flächenweitergabe als Verlust der Verfügungsgewalt
# (ohne Rückzahlungsverpflichtung); der lagegenau weiterführende Folgebetrieb übernimmt
# das Anlagejahr des Vorbewirtschafters.
baw_transfer_consequence(role) := "loss_of_disposal_no_repayment" if {
	role == "transferring_holder"
} else := "establishment_year_of_previous_holder_applies" if {
	role == "successor_continuing_in_place"
}

# --- Betriebsmitteleinsatz -------------------------------------------------

baw_inputs_used(p) if baw_field(p, "psm_used_since_first_declaration") == true

baw_inputs_used(p) if baw_field(p, "fertilized_since_first_declaration") == true

baw_inputs_used(p) if object.get(p, ["operations", "psm_used"], false) == true

baw_inputs_used(p) if object.get(p, ["operations", "fertilizer", "mineral_n_kg_per_ha"], 0) > 0

baw_inputs_used(p) if object.get(p, ["operations", "fertilizer", "organic_n_kg_per_ha"], 0) > 0

parcel_violations contains violation("o6_8.baw.no_psm_no_fertilizer", p, "BAW", "Kein Einsatz von Pflanzenschutz- und Düngemitteln ab 1. Jänner des Jahres der ersten Angabe als BAW bis zum Umbruch.") if {
	some p in parcels
	has_code(p, "BAW")
	baw_inputs_used(p)
}

# --- Pflege und Nutzung ----------------------------------------------------

baw_mowing_gap_breached(p) if {
	first := baw_field(p, "first_declared_year")
	first != null
	first <= year - 1
	last := baw_field(p, "last_mowing_or_mulching_year")
	last != null
	year - last >= params.baw_mowing_interval_years
}

baw_mowing_gap_breached(p) if {
	first := baw_field(p, "first_declared_year")
	first != null
	first <= year - 1
	baw_field(p, "last_mowing_or_mulching_year") == null
	baw_field(p, "mowing_records_complete") == true
}

parcel_violations contains violation("o6_8.baw.mow_or_mulch_every_second_year", p, "BAW", "Mahd oder Häckseln mindestens einmal jedes zweite Jahr erforderlich.") if {
	some p in parcels
	has_code(p, "BAW")
	baw_mowing_gap_breached(p)
}

parcel_violations contains violation("o6_8.baw.no_grazing_no_threshing", p, "BAW", "Beweidung und Drusch sind auf begrünten Abflusswegen nicht erlaubt.") if {
	some p in parcels
	has_code(p, "BAW")
	some f in ["grazed", "threshed"]
	baw_field(p, f) == true
}

parcel_violations contains violation("o6_8.baw.green_cover_maintained", p, "BAW", "Die Begrünung muss jedenfalls erhalten bleiben.") if {
	some p in parcels
	has_code(p, "BAW")
	baw_field(p, "green_cover_maintained") == false
}

# --- Förderfähigkeit -------------------------------------------------------

parcel_violations contains violation("o6_8.baw.not_eligible_grassland_2020", p, "BAW", "Ackerflächen, die im MFA-Flächen 2020 als Grünland beantragt waren, sind nicht als BAW förderfähig.") if {
	some p in parcels
	has_code(p, "BAW")
	baw_field(p, "grassland_in_mfa_2020") == true
}

baw_npf_no_premium(p) if {
	baw_field(p, "npf_code") == true
	year <= params.baw_gloez8_npf_credit_until_year
}

other_measures_on_parcel(p) := {m | some m in object.get(p, ["oepul_o6_8", "other_measures_on_parcel"], [])}

# Zulässig ist nur die Abgeltung der Landschaftselemente in UBB (1A) bzw. BIO (1B).
baw_other_measure_conflicts(p) := {m |
	some m in other_measures_on_parcel(p)
	not m in {"1A_LSE", "1B_LSE"}
}

parcel_violations contains violation("o6_8.premium.baw_no_other_measure", p, "BAW", sprintf("BAW ist auf der Einzelfläche mit keiner anderen Maßnahme kombinierbar (beantragt: %v).", [baw_other_measure_conflicts(p)])) if {
	some p in parcels
	has_code(p, "BAW")
	count(baw_other_measure_conflicts(p)) > 0
}

# --- Anrechnung als Biodiversitätsfläche (UBB/BIO) --------------------------

parcel_violations contains violation("o6_8.baw.counts_as_div_ubb_bio", p, "BAW", "Anrechnung als DIV nur bei Teilnahme an UBB oder BIO und Schlagnutzung Grünbrache oder Sonstiges Feldfutter.") if {
	some p in parcels
	has_code(p, "BAW")
	baw_field(p, "div_code") == true
	not baw_div_credit_allowed(p)
}

baw_div_credit_allowed(p) if {
	some m in {"1A", "1B"}
	m in participating_measures
	usage(p) in {"Grünbrache", "Sonstiges Feldfutter"}
}

# --- Umwandlung in Naturschutz / Ergebnisorientierte Bewirtschaftung ---------

baw_conversion_allowed(target_measure, application_date) if {
	measure_switch_allowed("8_BAW", target_measure, application_date)
}
