# Allgemeine Förderbedingungen der Maßnahme: PSM-Codierung, Erhaltung des Grünlandausmaßes,
# Anbaudiversifizierung, Weiterbildung, Flächenförderfähigkeit und Mindestbewirtschaftung
# (Kap. 3.2, 5.2-5.5, 10; ATB 4, 5.4-5.6; SRL 1.5.3, 1.6, 2.1 B).
package oepul.o6_1b

# --- 5.2 Angabe von Pflanzenschutzmitteleinsätzen ------------------------------------

psm_coding_required if year <= general.deadlines.psm_coding_last_year

violations contains {"rule_id": "O61B-PSM-001", "message": sprintf("Flächiger PSM-Einsatz auf Schlag %s ohne Code PSMBIO/PSMCS", [p.parcel_id])} if {
	psm_coding_required
	some p in parcels
	object.get(p, ["operations", "psm_used"], false) == true
	count(codes(p) & {c | some c in lists.psm_codes_until_2025}) == 0
}

# --- 5.3 Erhaltung des Grünlandausmaßes -------------------------------------------------

grassland_input := object.get(o6_1b_input, "grassland", {})

grassland_reference_ha := object.get(grassland_input, "reference_area_ha", null)

# Umgewandeltes Grünland abzüglich Grünlandneuanlagen (Neuanlagen füllen die Toleranz wieder auf)
grassland_net_conversion_ha := object.get(grassland_input, "converted_ha", 0) - object.get(grassland_input, "new_grassland_ha", 0)

grassland_reduction_ha := max2(grassland_net_conversion_ha, grassland_reference_ha - grassland_area_ha) if grassland_reference_ha != null

grassland_reduction_ha := grassland_net_conversion_ha if grassland_reference_ha == null

violations contains {"rule_id": "O61B-GL-001", "message": sprintf("Grünlandumbruch von %v ha überschreitet die Toleranz von 1,00 ha", [round2(grassland_reduction_ha)])} if {
	grassland_reduction_ha > general.tolerances.grassland_conversion_tolerance_ha
}

# --- 5.4 Anbaudiversifizierung auf Ackerflächen -----------------------------------------

crop_base_name(p) := object.get(p, ["crop", "mixture_main_component"], crop_name(p))

crop_species(p) := s if {
	s := object.get(p, ["crop", "species"], null)
	s != null
}

crop_species(p) := s if {
	object.get(p, ["crop", "species"], null) == null
	s := lists.crop_species_map[crop_base_name(p)]
}

crop_species(p) := crop_base_name(p) if {
	object.get(p, ["crop", "species"], null) == null
	not lists.crop_species_map[crop_base_name(p)]
}

is_cereal(p) if {
	crop_species(p) in lists.cereals
	object.get(p, ["crop", "cereal_share_percent"], 100) >= 50
}

is_maize(p) if crop_species(p) in lists.maize

diversification_applies if arable_area_ha > general.diversification.arable_threshold_ha_exclusive

cereal_maize_area_ha := sum([area(p) | some p in parcels; is_arable(p); cereal_or_maize(p)])

cereal_or_maize(p) if is_cereal(p)

cereal_or_maize(p) if {
	not is_cereal(p)
	is_maize(p)
}

cereal_maize_share := share(cereal_maize_area_ha, arable_area_ha)

exempt_from_55(p) if land_use_type(p) in lists.arable_forage

exempt_from_55(p) if crop_species(p) in lists.arable_forage

exempt_from_55(p) if {
	year >= 2025
	land_use_type(p) in lists.diversification_55_exempt_from_2025
}

exempt_from_55(p) if {
	year >= 2025
	crop_species(p) in lists.diversification_55_exempt_from_2025
}

crop_shares[s] := share(a, arable_area_ha) if {
	some p in parcels
	is_arable(p)
	not exempt_from_55(p)
	s := crop_species(p)
	a := sum([area(q) | some q in parcels; is_arable(q); not exempt_from_55(q); crop_species(q) == s])
}

violations contains {"rule_id": "O61B-AD-001", "message": sprintf("Getreide- und Maisanteil %v %% über 75 %%", [round2(cereal_maize_share * 100)])} if {
	diversification_applies
	cereal_maize_share > general.diversification.max_cereal_maize_share
}

violations contains {"rule_id": "O61B-AD-002", "message": sprintf("Kultur %s hat einen Anteil von %v %% an der Ackerfläche (max. 55 %%)", [s, round2(v * 100)])} if {
	diversification_applies
	some s, v in crop_shares
	v > general.diversification.max_single_crop_share
}

# --- 5.5 Weiterbildung ------------------------------------------------------------------

training_courses := object.get(o6_1b_input, ["training", "courses"], [])

creditable_course(c) if {
	c.date >= general.training.creditable_from
	c.date <= general.training.deadline
	object.get(c, "provider_recognized", false) == true
	object.get(c, "credited_elsewhere", false) == false
	object.get(c, "attendee_left_before_deadline", false) == false
}

training_hours(topic) := sum([c.hours | some c in training_courses; c.topic == topic; creditable_course(c)])

training_deadline_passed if year > date_year(general.training.deadline)

violations contains {"rule_id": "O61B-WB-001", "message": "Weiterbildung zu biodiversitätsrelevanten Themen (mind. 3 Stunden) nicht fristgerecht bis 31.12.2025 absolviert"} if {
	training_deadline_passed
	training_hours("biodiversity") < general.training.biodiversity_min_hours
}

violations contains {"rule_id": "O61B-WB-002", "message": "Weiterbildung zur biologischen Wirtschaftsweise (mind. 5 Stunden) nicht fristgerecht bis 31.12.2025 absolviert"} if {
	training_deadline_passed
	training_hours("organic") < general.training.organic_min_hours
}

# --- 3.2 / ATB 5.5 Förderfähigkeit von Flächen -----------------------------------------

violations contains {"rule_id": "O61B-FL-006", "message": sprintf("Obstanlage %s ohne veredeltes Pflanzgut muss mit Code OP beantragt werden", [p.parcel_id])} if {
	some p in parcels
	is_special_crop(p)
	is_fruit(p)
	object.get(p, ["crop", "is_grafted"], true) == false
	not opted_out(p)
}

is_fruit(p) if {
	some o in lists.obst
	o.crop == crop_name(p)
	o.from_year <= year
}

in_national_park_without_premium(p) if object.get(p, "national_park", "") in general.national_parks_no_area_premium

located_outside_austria(p) if object.get(p, "in_austria", true) == false

# Mindestbewirtschaftung: Ernte auf zumindest 85 % des Schlages (ATB 5.4; SRL 1.6.3.1)
harvest_required(p) if {
	is_arable(p)
	not is_arable_forage(p)
	not is_arable_div(p)
	not opted_out(p)
	land_use_type(p) != "Grünbrache"
}

violations contains {"rule_id": "O61B-ATB-004", "message": sprintf("Ernteverpflichtung (85 %%) auf Schlag %s nicht erfüllt", [p.parcel_id])} if {
	some p in parcels
	harvest_required(p)
	object.get(p, ["operations", "harvested_share_percent"], 100) < 85
	not drought_harvest_waiver(p)
}

violations contains {"rule_id": "O61B-ATB-004", "message": sprintf("Grünland-/Ackerfutterfläche %s ohne jährliche vollflächige Mahd mit Verbringung oder Beweidung", [p.parcel_id])} if {
	some p in parcels
	is_forage_parcel(p)
	not is_bergmaehder(p)
	not is_arable_div(p)
	not is_grassland_div(p)
	object.get(p, ["operations", "annual_full_use_done"], true) == false
}
