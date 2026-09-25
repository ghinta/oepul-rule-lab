# Schlagbezogene Förderbedingungen der Maßnahme o6_6 (Maßnahmenblatt Kapitel 3 bis 5, SRL 2.6).
package oepul.o6_6

# severity "ineligible": Schlag ist nicht als Begrünung anrechenbar.
# severity "obligation": Verstoß gegen inhaltliche Förderverpflichtung (Sanktion gemäß Stufenschema).
pv(p, rid, sev, msg) := {"parcel_id": p.parcel_id, "rule_id": rid, "severity": sev, "message": msg}

# --- Variante und Flächenart ---------------------------------------------

parcel_violations contains pv(p, "O6_6-VARIANT-VALID", "ineligible", "Begrünungsvariante im Antragsjahr nicht angeboten") if {
	some p in cover_parcels
	not row_of(p)
}

parcel_violations contains pv(p, "O6_6-ARABLE-ONLY", "ineligible", "Zwischenfruchtbegrünung nur auf Ackerflächen") if {
	some p in cover_parcels
	p.land_use != "arable"
}

parcel_violations contains pv(p, "O6_6-NPF-2024", "ineligible", "Im Antragsjahr 2024 im Rahmen von GLÖZ 8 beantragte NPF-Zwischenfrüchte sind nicht förderbar") if {
	some p in cover_parcels
	year == gc.measure.npf_gloez8_not_fundable_year
	cc(p).is_npf_gloez8 == true
}

# --- Anlage -----------------------------------------------------------------

parcel_violations contains pv(p, "O6_6-SOWING-DEADLINE", "ineligible", "Anlage nach dem spätesten Anlagetermin der Variante") if {
	some p in cover_parcels
	establishment_ns(p) > ns_md(year, row_of(p).sowing_deadline)
}

parcel_violations contains pv(p, "O6_6-DEF-ACTIVE-ESTABLISHMENT", "ineligible", "Keine aktive Anlage (Ansaat/Untersaat) der Begrünung") if {
	some p in cover_parcels
	not establishment_date(p)
}

parcel_violations contains pv(p, "O6_6-INADMISSIBLE-VOLUNTEER-SELF-GREENING", "ineligible", "Ausfall, Druschausfall oder Selbstbegrünung gelten nicht als Zwischenfrucht") if {
	some p in cover_parcels
	cc(p).only_volunteer_or_self_seeded == true
}

parcel_violations contains pv(p, "O6_6-INADMISSIBLE-CEREAL-MAIZE", "ineligible", "Getreide/Mais oder Mischung mit mehr als 50 % Getreide und/oder Mais") if {
	some p in cover_parcels
	cc(p).variant != 6
	cc(p).cereal_maize_share_percent > 50
	not drought_2026_cereal_excused(p)
}

parcel_violations contains pv(p, "O6_6-INADMISSIBLE-CEREAL-MAIZE", "ineligible", "Reinbestand aus Getreide und/oder Mais") if {
	some p in cover_parcels
	cc(p).variant != 6
	species := object.get(cc(p), "species", [])
	count(species) > 0
	every s in species {
		cereal_or_maize(s)
	}
}

parcel_violations contains pv(p, "O6_6-FULL-COVERAGE", "ineligible", "Keine flächendeckende Begrünung erreicht") if {
	some p in cover_parcels
	cc(p).full_coverage_achieved == false
	not drought_2026_coverage_excused(p)
}

parcel_violations contains pv(p, "O6_6-SEED-PROOF", "obligation", "Anzahl der Mischungspartner am Feld nicht ersichtlich und kein Saatgutnachweis (Rechnung/Etikett)") if {
	some p in cover_parcels
	cc(p).partners_visible_in_field == false
	not cc(p).seed_proof_available == true
}

parcel_violations contains pv(p, "O6_6-MIXING-PARTNERS", "ineligible", "Mindestanzahl an Mischungspartnern der Variante unterschritten") if {
	some p in cover_parcels
	cc(p).mixture_partner_count < row_of(p).min_mixing_partners
}

parcel_violations contains pv(p, "O6_6-PLANT-FAMILIES", "ineligible", "Mindestanzahl an Pflanzenfamilien der Variante unterschritten") if {
	some p in cover_parcels
	cc(p).plant_family_count < row_of(p).min_plant_families
}

# Anzahl insektenblütiger Mischungspartner: Eingabe oder Abgleich mit der Beispielliste.
insect_pollinated_count(p) := cc(p).insect_pollinated_partner_count if {
	is_number(cc(p).insect_pollinated_partner_count)
} else := count({s | some s in object.get(cc(p), "species", []); s in list_items("insect_pollinated_examples")})

parcel_violations contains pv(p, "O6_6-V1-INSECT-POLLINATED", "ineligible", "Variante 1: weniger als 5 insektenblütige Mischungspartner") if {
	some p in cover_parcels
	row_of(p).insect_pollinated_required
	insect_pollinated_count(p) < row_of(p).min_mixing_partners
}

parcel_violations contains pv(p, "O6_6-V1-NON-INSECT-SHARE", "ineligible", "Variante 1: nicht-insektenblütige Pflanzen nicht nur in untergeordnetem Ausmaß (unter 10 %)") if {
	some p in cover_parcels
	row_of(p).insect_pollinated_required
	cc(p).non_insect_pollinated_share_percent >= row_of(p).max_non_insect_pollinated_share_percent
}

parcel_violations contains pv(p, "O6_6-V6-SPECIES", "ineligible", sprintf("Variante 6: unzulässiger Mischungspartner %s", [s])) if {
	some p in cover_parcels
	row_of(p).restricted_winter_hardy_species_only
	some s in object.get(cc(p), "species", [])
	not s in list_items("variant6_allowed_crops")
}

allowed_green_rye_varieties := list_items("green_rye_varieties_austrian_list") | list_items("green_rye_varieties_eu_catalogue")

parcel_violations contains pv(p, "O6_6-V6-GREEN-RYE-VARIETIES", "ineligible", sprintf("Variante 6: Grünschnittroggensorte %s nicht gemäß Saatgutgesetz zulässig", [v])) if {
	some p in cover_parcels
	row_of(p).restricted_winter_hardy_species_only
	some v in object.get(cc(p), "green_rye_varieties", [])
	not v in allowed_green_rye_varieties
}

parcel_violations contains pv(p, "O6_6-V6-FARM-SAVED-SEED", "obligation", "Variante 6: Nachbausaatgut ohne Nachweis am Betrieb") if {
	some p in cover_parcels
	row_of(p).restricted_winter_hardy_species_only
	cc(p).farm_saved_seed_used == true
	not cc(p).farm_saved_seed_proof == true
}

parcel_violations contains pv(p, "O6_6-V7-WINTER-RAPE", "ineligible", "Variante 7: Begleitsaat nur bei Winterraps") if {
	some p in cover_parcels
	row_of(p).herbicide_ban_after_rape_four_leaf
	not object.get(p, ["crop", "crop_name"], "") in list_items("winter_rape_crop_names")
}

# --- Zwischenfrucht-Eigenschaft --------------------------------------------

parcel_violations contains pv(p, "O6_6-NOT-MAIN-CROP-NEXT-MFA", "ineligible", "Zwischenfrucht scheint im nächsten Mehrfachantrag als Hauptfrucht/Schlagnutzung auf") if {
	some p in cover_parcels
	cc(p).declared_as_main_crop_next_mfa == true
}

parcel_violations contains pv(p, "O6_6-DEF-FOLLOWING-MAIN-CROP", "ineligible", "Auf die Zwischenfrucht folgt keine aktiv angelegte Hauptfrucht") if {
	some p in cover_parcels
	object.get(cc(p), ["following_main_crop", "actively_established"], true) == false
}

parcel_violations contains pv(p, "O6_6-NO-THRESHING", "ineligible", "Gedroschene Kultur zählt nicht als Zwischenfrucht") if {
	some p in cover_parcels
	has_event_type(p, "threshing")
}

# --- Verbote im Begrünungszeitraum -----------------------------------------

parcel_violations contains pv(p, "O6_6-NO-MINERAL-N", "obligation", sprintf("Mineralische Stickstoffdüngung am %s im Begrünungszeitraum", [e.date])) if {
	some p in cover_parcels
	some e in events(p)
	e.type == "mineral_n_fertilization"
	event_in_period(p, e)
}

parcel_violations contains pv(p, "O6_6-NO-PSM", "obligation", sprintf("Pflanzenschutzmitteleinsatz am %s im Begrünungszeitraum", [e.date])) if {
	some p in cover_parcels
	row_of(p).psm_ban_during_period
	some e in events(p)
	e.type in {"psm_application", "herbicide_application"}
	event_in_period(p, e)
}

mechanically_removed_before(p, d) if {
	some m in data.o6_6.management.termination_methods.rows
	m.method == cc(p).termination_method
	m.creditable_as_mechanical
	ns(cc(p).termination_date) <= d
}

parcel_violations contains pv(p, "O6_6-PSM-AFTER-NONMECH", "obligation", sprintf("PSM-Einsatz am %s ohne vorherige mechanische Beseitigung vor der Saat der Folgekultur", [e.date])) if {
	some p in cover_parcels
	row_of(p).mechanical_removal_required
	some e in events(p)
	e.type in {"psm_application", "herbicide_application"}
	d := ns(e.date)
	d >= period_end_ns(p)
	not mechanically_removed_before(p, d)
	not following_sown_before(p, d)
}

following_sown_before(p, d) if {
	ns(cc(p).following_main_crop.sowing_date) <= d
}

parcel_violations contains pv(p, "O6_6-NO-TILLAGE", "obligation", sprintf("Bodenbearbeitung (%s) am %s im Begrünungszeitraum", [e.type, e.date])) if {
	some p in cover_parcels
	some e in events(p)
	e.type in {"tillage", "knife_roller"}
	event_in_period(p, e)
}

parcel_violations contains pv(p, "O6_6-DEEP-LOOSENING-STRIP-TILL", "obligation", sprintf("%s am %s ohne maßgeblichen Erhalt der Begrünung bzw. vollflächig", [e.type, e.date])) if {
	some p in cover_parcels
	some e in events(p)
	e.type in {"deep_loosening", "strip_till_preparation"}
	event_in_period(p, e)
	cover_not_preserved(e)
}

cover_not_preserved(e) if e.cover_preserved == false

cover_not_preserved(e) if {
	e.type == "strip_till_preparation"
	e.full_surface == true
}

parcel_violations contains pv(p, "O6_6-ADDITIONAL-SOWING", "obligation", sprintf("Nachsaat am %s nicht ausschließlich mit Bodeneingriff der Säschare", [e.date])) if {
	some p in cover_parcels
	some e in events(p)
	e.type == "additional_sowing_winter_hardy"
	event_in_period(p, e)
	e.only_drill_coulters == false
}

care_allowed_from_ns(p) := ns_md(year, row_of(p).care_chopping_mowing_allowed_from)

problem_weed_exception(p, e) if {
	e.ground_level == false
	some w in object.get(cc(p), "problem_weeds", [])
	w in list_items("problem_weeds_early_chopping")
	cc(p).problem_weed_evidence_kept == true
	not e.coverage_maintained == false
}

parcel_violations contains pv(p, "O6_6-CARE-DATES", "obligation", sprintf("Häckseln/Pflegemahd am %s vor dem zulässigen Termin", [e.date])) if {
	some p in cover_parcels
	is_string(row_of(p).care_chopping_mowing_allowed_from)
	some e in events(p)
	e.type in {"care_chopping", "care_mowing"}
	event_in_period(p, e)
	ns(e.date) < care_allowed_from_ns(p)
	not problem_weed_exception(p, e)
}

parcel_violations contains pv(p, "O6_6-CARE-CONDITIONS", "obligation", sprintf("Häckseln/Pflegemahd am %s ohne Erhalt der flächendeckenden Begrünung bzw. Nachwachsen", [e.date])) if {
	some p in cover_parcels
	some e in events(p)
	e.type in {"care_chopping", "care_mowing"}
	event_in_period(p, e)
	care_condition_failed(e)
}

care_condition_failed(e) if e.coverage_maintained == false

care_condition_failed(e) if e.regrowth_expected == false

parcel_violations contains pv(p, "O6_6-GROUND-CHOPPING-FROST", "obligation", sprintf("Bodennahes Häckseln am %s ohne vollständiges Abfrosten", [e.date])) if {
	some p in cover_parcels
	some e in events(p)
	e.type == "ground_level_chopping"
	event_in_period(p, e)
	not e.plants_fully_frost_killed == true
}

rolling_permitted(_, e) if e.immediately_after_sowing == true

rolling_permitted(p, e) if ns(e.date) >= ns_md(year, row_of(p).rolling_allowed_from)

rolling_permitted(_, e) if {
	e.on_frozen_ground == true
	e.coverage_maintained == true
}

parcel_violations contains pv(p, "O6_6-ROLLING", "obligation", sprintf("Walzen am %s außerhalb der zulässigen Zeitpunkte", [e.date])) if {
	some p in cover_parcels
	is_string(row_of(p).rolling_allowed_from)
	some e in events(p)
	e.type == "rolling"
	event_in_period(p, e)
	not rolling_permitted(p, e)
}

parcel_violations contains pv(p, "O6_6-USE", "obligation", sprintf("Nutzung (%s) am %s ohne Erhalt der flächendeckenden Begrünung bzw. Weiterwachsen", [e.type, e.date])) if {
	some p in cover_parcels
	some e in events(p)
	e.type in {"use_mowing_removal", "grazing"}
	event_in_period(p, e)
	care_condition_failed(e)
}

# --- Variante 1 ----------------------------------------------------------

parcel_violations contains pv(p, "O6_6-V1-DRIVING-BAN", "obligation", sprintf("Variante 1: Befahren am %s während des Befahrungsverbots", [e.date])) if {
	some p in cover_parcels
	is_string(row_of(p).driving_ban_until)
	some e in events(p)
	e.type == "driving"
	d := ns(e.date)
	d >= establishment_ns(p)
	d <= ns_md(year, row_of(p).driving_ban_until)
	not e.crossing_only == true
}

parcel_violations contains pv(p, "O6_6-V1-FOLLOW-UP-CROP", "obligation", "Variante 1: kein Anbau einer Hauptkultur im Herbst nach dem Umbruch bzw. keine Beantragung im nachfolgenden Mehrfachantrag") if {
	some p in cover_parcels
	row_of(p).follow_up_main_crop_in_autumn_required
	not v1_follow_up_ok(p)
}

v1_follow_up_ok(p) if {
	f := cc(p).following_main_crop
	s := ns(f.sowing_date)
	s >= ns(cc(p).termination_date)
	s <= ns_md(year, "12-31")
	f.declared_in_next_mfa == true
}

# --- Variante 7 ----------------------------------------------------------

parcel_violations contains pv(p, "O6_6-V7-HERBICIDE", "obligation", sprintf("Variante 7: Herbizideinsatz am %s nach dem Vierblattstadium des Rapses", [e.date])) if {
	some p in cover_parcels
	row_of(p).herbicide_ban_after_rape_four_leaf
	some e in events(p)
	e.type == "herbicide_application"
	event_in_period(p, e)
	ns(e.date) > ns(cc(p).rape_four_leaf_stage_date)
}

parcel_violations contains pv(p, "O6_6-V7-HERBICIDE", "obligation", sprintf("Variante 7: Herbizideinsatz am %s beeinträchtigt die Begleitsaat", [e.date])) if {
	some p in cover_parcels
	row_of(p).herbicide_ban_after_rape_four_leaf
	some e in events(p)
	e.type == "herbicide_application"
	e.impairs_companion_crop == true
}

# --- Umbruch und Beseitigung -----------------------------------------------

parcel_violations contains pv(p, "O6_6-PERIOD-END", "obligation", sprintf("Umbruch am %s vor dem Ende des Begrünungszeitraums", [cc(p).termination_date])) if {
	some p in cover_parcels
	ns(cc(p).termination_date) < period_end_ns(p)
}

termination_method_row(p) := m if {
	some m in data.o6_6.management.termination_methods.rows
	m.method == cc(p).termination_method
}

parcel_violations contains pv(p, "O6_6-MECH-REMOVAL", "obligation", sprintf("Beseitigung '%s' ist keine anrechenbare mechanische Beseitigung", [cc(p).termination_method])) if {
	some p in cover_parcels
	row_of(p).mechanical_removal_required
	is_string(cc(p).termination_method)
	not mechanical_method_ok(p)
}

mechanical_method_ok(p) if {
	m := termination_method_row(p)
	m.creditable_as_mechanical
	cc(p).variant in m.variants
	not frost_only_method_violated(p, m)
}

frost_only_method_violated(p, m) if {
	m.requires_only_frost_killed_components
	cc(p).winter_hardiness != "frost_killed"
}

# --- Kombination mit anderen Maßnahmen auf dem Schlag -----------------------

parcel_violations contains pv(p, "O6_6-SRL-GW-OOE-NO-V3", "obligation", "Vorbeugender Grundwasserschutz im Gebiet Oberösterreich: Verzicht auf Variante 3") if {
	some p in cover_parcels
	cc(p).variant == 3
	"16" in measure_codes
	object.get(p, ["constraints", "groundwater_protection_area_ooe"], false) == true
}

combinable_with_6 := {c.with | some r in data.o6_6.combination_table.rows; r.measure == "6"; some c in r.cells}

combination_conflicts contains {"parcel_id": p.parcel_id, "measure": m, "rule_id": "O6_6-SRL-COMBINATION-TABLE"} if {
	some p in cover_parcels
	some m in object.get(p, "oepul_measures", [])
	m != "6"
	not m in combinable_with_6
}

# --- Fehlende Eingaben, ohne die eine Regel nicht bewertet werden kann ------

missing_inputs contains {"parcel_id": p.parcel_id, "field": "operations.cover_crop.rape_four_leaf_stage_date", "rule_id": "O6_6-V7-HERBICIDE"} if {
	some p in cover_parcels
	row_of(p).herbicide_ban_after_rape_four_leaf
	has_event_type(p, "herbicide_application")
	not cc(p).rape_four_leaf_stage_date
}

missing_inputs contains {"parcel_id": p.parcel_id, "field": "operations.cover_crop.termination_date", "rule_id": "O6_6-PERIOD-END"} if {
	some p in cover_parcels
	not cc(p).termination_date
}

missing_inputs contains {"parcel_id": p.parcel_id, "field": "operations.cover_crop.following_main_crop", "rule_id": "O6_6-DEF-FOLLOWING-MAIN-CROP"} if {
	some p in cover_parcels
	not cc(p).following_main_crop
}
