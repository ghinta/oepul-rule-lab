package oepul.o6_4_test

import data.oepul.o6_4 as bm
import rego.v1

parcel := {
	"parcel_id": "Schlag A", "area_ha": 2,
	"operations": {"cutting_dates": ["2025-08-01", "2026-08-03"], "psm_used": false},
	"bergmahd": {
		"enrolled": true, "extensive_meadow": true, "above_settlement_limit": true,
		"difficult_management": true, "area_above_1200m_ha": 1.01, "above_home_farm": true,
		"full_cut": true, "crop_removed": true, "shredded": false, "grazing": [],
		"materials": [], "main_method": "Motormäher", "declared_code": "BM2",
		"declared_use": "Bergmähder", "other_payments": [], "country": "AT",
		"active_agricultural_use": true, "land_category": "Bergmähder", "mfa_identified": true,
		"mainly_agricultural": true, "gloez_element": false, "national_park": "kein",
		"trial_prevents_compliance": false, "op_applies": false, "public_overlap": false, "official_compensation": false,
	},
}

changed(attrs) := object.union(parcel, {"bergmahd": attrs})
no_cut := object.union(parcel, {"operations": {"cutting_dates": []}, "bergmahd": {"declared_code": "BM0", "bound_previous_year": true, "previous_full_cut_removed": true}})
at(p) := {"farm": {"year": 2026}, "land": {"parcels": [p]}}

checks(p) := output if {
	out := bm.parcel_checks with input as at(p)
	output := out[p.parcel_id]
}

test_schlag_vom_profil_bis_zum_tarif if {
	inp := at(parcel)
	review := bm.parcel_review with input as inp
	review["Schlag A"].status == "erfüllt"
	rates := bm.parcel_tariffs with input as inp
	rates["Schlag A"] == {"code": "BM2", "eur_ha": 594, "eur": 1188}
}

test_auswahl_und_keine_mindestschlaggroesse if {
	p := object.union(parcel, {"area_ha": 0.01, "bergmahd": {"area_above_1200m_ha": 0.009}})
	other := object.union(parcel, {"parcel_id": "B", "bergmahd": {"enrolled": false}})
	result := bm.parcel_review with input as {"farm": {"year": 2026}, "land": {"parcels": [p, other]}}
	object.keys(result) == {"Schlag A"}
	result["Schlag A"].status == "erfüllt"
}

test_strikte_hoehenmehrheit if {
	checks(changed({"area_above_1200m_ha": 1})).hoehe == false
	checks(changed({"area_above_1200m_ha": 1.0001})).hoehe
	checks(changed({"above_home_farm": false})).heimbetrieb == false
	checks(changed({"above_settlement_limit": false})).siedlungsgrenze == false
}

test_keine_bewilligung_bei_fehlenden_daten if {
	p := {"parcel_id": "B", "area_ha": 3, "bergmahd": {"enrolled": true}}
	r := bm.parcel_review with input as at(p)
	r.B.status == "offen"
	"hoehe" in r.B.missing_or_pending
	"mahdcode" in r.B.missing_or_pending
	not bm.expected_code(p, 2026)
}

test_bm0_auch_mit_nachweide_ohne_mahd if {
	p := object.union(no_cut, {"bergmahd": {"grazing": [{"date": "2026-08-16", "aftermath": true}]}})
	c := checks(p)
	c.weide
	c.zweijahresmahd
	c.mahdcode
	bm.expected_code(p, 2026) == "BM0"
	bm.tariff_eur_ha(2026, "BM0") == 0
}

test_jahresfenster_und_abtransport if {
	checks(object.union(no_cut, {"bergmahd": {"previous_full_cut_removed": false}})).zweijahresmahd == false
	checks(object.union(no_cut, {"bergmahd": {"bound_previous_year": false, "previous_full_cut_removed": false}})).zweijahresmahd == null
	checks(changed({"crop_removed": false, "previous_full_cut_removed": false, "bound_previous_year": true})).abtransport == false
	checks(changed({"full_cut": false, "previous_full_cut_removed": false, "bound_previous_year": true})).zweijahresmahd == false
}

test_hoechstens_eine_mahd_je_jahr if {
	c := checks(object.union(parcel, {"operations": {"cutting_dates": ["2026-06-03", "2026-07-04"]}}))
	c.maxmahd == false
	checks(parcel).maxmahd
}

test_nachweidegrenze_und_andere_jahre if {
	checks(changed({"grazing": [{"date": "2026-08-15", "aftermath": true}]})).weide == false
	checks(changed({"grazing": [{"date": "2026-08-16", "aftermath": false}]})).weide == false
	checks(changed({"grazing": [{"date": "2025-07-15", "aftermath": false}]})).weide
}

test_festmist_ausnahme if {
	checks(changed({"materials": [{"kind": "Festmist", "needs_based": true, "original_form": true}, {"kind": "eigene häusliche Abwässer"}]})).duenger
	checks(changed({"materials": [{"kind": "Festmist", "needs_based": false, "original_form": true}]})).duenger == false
	checks(changed({"materials": [{"kind": "Festmist", "needs_based": true, "original_form": false}]})).duenger == false
	checks(changed({"materials": [{"kind": "Festmist"}]})).duenger == null
}

test_duengerverbot_gilt_auch_ohne_mahd if {
	every material in ["Kalkdünger", "Gülle", "kompostierter Klärschlamm", "Klärschlamm", "fremde häusliche Abwässer"] {
		c := checks(object.union(no_cut, {"bergmahd": {"materials": [{"kind": material}]}}))
		c.duenger == false
	}
	checks(object.union(no_cut, {"bergmahd": {"shredded": true}})).haeckseln == false
	checks(object.union(parcel, {"operations": {"fertilizer": {"mineral_n_kg_per_ha": 1}}})).duenger == false
}

test_wirkstoffe_statt_biozertifizierung if {
	used := object.union(parcel, {"operations": {"psm_used": true}})
	checks(used).psm == null
	checks(object.union(used, {"bergmahd": {"only_organic_approved_actives": true}})).psm
	checks(object.union(used, {"bergmahd": {"only_organic_approved_actives": false}})).psm == false
}

test_verfahren_und_tarifwechsel if {
	every row in [["Traktor", "BM1", 350, 378], ["Mähtrak", "BM1", 350, 378], ["Motormäher", "BM2", 550, 594], ["Sense", "BM3", 900, 972], ["Motorsense", "BM3", 900, 972]] {
		bm.expected_code(changed({"main_method": row[0]}), 2026) == row[1]
		bm.tariff_eur_ha(2023, row[1]) == row[2]
		bm.tariff_eur_ha(2024, row[1]) == row[3]
	}
	checks(changed({"declared_code": "BM3"})).mahdcode == false
}

test_kombination_nur_punktfoermiges_lse if {
	every id in {"1A", "1B"} {
		bm.compatible_payment({"measure": id, "component": "punktförmiges Landschaftselement"})
		bm.compatible_payment({"measure": id, "component": "Basismodul"}) == false
	}
	not bm.compatible_payment({"measure": "18", "component": "punktförmiges Landschaftselement"})
	bm.matrix_cell("4", "18") == ""
	bm.matrix_cell("1B", "16") == "a"
}

test_nationalpark_und_flaechenausschluesse if {
	checks(changed({"national_park": "Donau-Auen", "relevant_park_restrictions": false})).nationalpark == false
	checks(changed({"national_park": "Kalkalpen", "relevant_park_restrictions": false})).nationalpark
	checks(changed({"country": "DE"})).lage == false
	checks(changed({"mfa_identified": false})).ausschluss == false
	checks(changed({"land_category": "Rebschule"})).ausschluss == false
	checks(changed({"op_applies": true})).op == false
}

test_vertragsbeginn_und_wechsel if {
	bm.contract_years(2023) == 6
	bm.contract_years(2024) == 5
	bm.contract_years(2025) == 4
	bm.entry_timely(2025, "2024-12-31")
	bm.entry_timely(2025, "2025-01-01") == false
	bm.entry_timely(2026, "2025-12-31") == false
	bm.switch_permitted(2025, "2025-12-31", "19")
	bm.switch_permitted(2025, "2026-01-01", "18") == false
	bm.switch_permitted(2025, "2025-12-31", "1B") == false
}

test_uebernahme_nach_letztem_einstieg if {
	bm.takeover_timely(2028, "2028-04-17")
	bm.takeover_timely(2028, "2028-04-18") == false
	bm.takeover_timely(2026, "2026-04-15")
	bm.takeover_timely(2026, "2026-04-16") == false
	t := {"date": "2026-04-15", "new_to_measure": true, "ama_approved": true, "submitted_online": true, "transferred_ha": 2, "additional_ha": 1}
	bm.takeover_possible(t, 2026)
	not bm.takeover_possible(object.union(t, {"additional_ha": 1.01}), 2026)
	not bm.takeover_possible(object.union(t, {"ama_approved": false}), 2026)
}

test_abgangsgrenzen_gesamte_differenz if {
	bm.loss_limit(4) == 0.5
	bm.loss_limit(40) == 2
	bm.loss_limit(200) == 5
	bm.recoverable_area(40, 2) == 0
	bm.recoverable_area(40, 2.01) == 2.01
	bm.conversion_allowed("G", "L")
	not bm.conversion_allowed("L", "G")
}

test_zugang_und_vorbindung if {
	bm.eligible_new_area(2025, 4, 8, 0) == 8
	bm.eligible_new_area(2026, 4, 8, 0) == 5
	bm.eligible_new_area(2027, 20, 12, 0) == 10
	bm.eligible_new_area(2028, 20, 12, 2) == 12
}

test_mindestbetrieb_im_ersten_oepul_jahr if {
	bm.farm_size_ok with input.farm as {"year": 2025, "oepul": {"first_year": 2025, "protected_at_ha": 0.5}}
	bm.farm_size_ok with input.farm as {"year": 2025, "oepul": {"first_year": 2025, "countable_at_ha": 1.5}}
	not bm.farm_size_ok with input.farm as {"year": 2025, "oepul": {"first_year": 2025, "countable_at_ha": 1.49, "protected_at_ha": 0.49}}
	bm.farm_size_ok with input.farm as {"year": 2025, "oepul": {"first_year": 2023}}
}

test_modulation_und_kappung if {
	bm.modulation_factor(200) == 1
	round(10000 * bm.modulation_factor(220)) == 9909
	bm.modulation_factor(1100) == (((200 + 90) + 595) + 75) / 1100
	bm.cap_eur_ha(2023, "Regel") == 1200
	bm.cap_eur_ha(2026, "Regel") == 1300
}

test_verwarnung_und_wiederholung if {
	bm.sanction_percent(2026, "Verwarnungsstufe") == 0
	bm.sanction_percent(2027, "Verwarnungsstufe") == 1
	bm.sanction_percent(2027, "25") == 25
	bm.repeated_full_reduction with input.farm.oepul.full_reductions_this_contract as 2
	not bm.repeated_full_reduction with input.farm.oepul.full_reductions_this_contract as 1
}

test_kontextregeln_der_zielmassnahmen if {
	bm.nat_distance_rate("GG04", 2024, 10, false) == 75.6
	bm.nat_distance_rate("GG04", 2025, 10, false) == 145.8
	not bm.nat_distance_rate("GG04", 2025, 5, false)
	bm.nat_distance_rate("GG01", 2026, 10.01, true) == 291.6
	bm.orchard_species_ok("Pfirsich", 2025)
	not bm.orchard_species_ok("Pfirsich", 2024)
	bm.drought_arable_area("Steiermark", "Weiz", 2026)
	not bm.drought_arable_area("Steiermark", "Weiz", 2025)
}

test_antragsteller_und_bestimmender_einfluss if {
	a := {"legal_form": "juristische Person", "public_share_pct": 25, "public_body_or_institution": false, "equivalent_public_control": false, "own_name_and_account": true, "disposal_of_claimed_land": true, "active_farmer": true, "agricultural_activity": true}
	bm.applicant_eligible with input.farm.oepul.applicant as a
	not bm.applicant_eligible with input.farm.oepul.applicant as object.union(a, {"public_share_pct": 25.01})
	not bm.applicant_eligible with input.farm.oepul.applicant as object.union(a, {"equivalent_public_control": true})
}

test_flaechengrenze_nach_modulation if {
	bm.modulated_capped_eur(1500, 1, 200, 2026) == 1300
	bm.modulated_capped_eur(1200, 1, 400, 2026) == 1125
}

test_lse_abstand_und_flaechengrenzen if {
	e := {"kind": "Streuobstbaum", "species": "Apfel", "distance_land_m": 5, "in_farm_control": true, "crown_diameter_m": 2, "area_m2": 100, "nearest_distance_m": 5, "claimed": true, "maintained_all_year": true, "alpine_or_rough_pasture": false, "gloez8": false, "tall_or_half_standard": true, "vigorous_large_crown": true, "shared_permanent_support": false}
	bm.streuobst_eligible(e, 2024)
	not bm.point_eligible(object.union(e, {"nearest_distance_m": 4.99}))
	not bm.point_eligible(object.union(e, {"distance_land_m": 5.01}))
	not bm.point_eligible(object.union(e, {"gloez8": true}))
}

test_betriebsgroesse_fehlende_werte if {
	bm.farm_size_result == null with input.farm as {"year": 2026, "oepul": {"first_year": null}}
	bm.farm_size_result == null with input.farm as {"year": 2026, "oepul": {"first_year": 2026, "protected_at_ha": 0}}
	bm.farm_size_result == false with input.farm as {"year": 2026, "oepul": {"first_year": 2026, "protected_at_ha": 0, "countable_at_ha": 1.49}}
}

test_amtliche_stichtage_und_abrechnungsregeln if {
	bm.advance_limit(800) == 600 with input.farm.oepul.administrative_checks_complete as true
	not bm.advance_limit(800) with input.farm.oepul.administrative_checks_complete as false
	bm.measure_in_group("Mehrjährige Bindung", "Bewirtschaftung von Bergmähdern")
	not bm.measure_in_group("Einjährige Maßnahmen", "Bewirtschaftung von Bergmähdern")
	count(bm.reduction_order) == 11
	bm.reduction_order[6] == "Modulation"
}

test_kulturen_und_rgve if {
	"Obst" in bm.crop_classes("Maulbeere", 2025)
	not "Obst" in bm.crop_classes("Maulbeere", 2024)
	bm.gve_factor("Rinder ab 2 Jahre").per_head == 1
	bm.stocking_class(3, 10)
	bm.stocking_class(2.99, 10) == false
}

test_almbetriebsstaette_und_hoehenmehrheit if {
	p := changed({"only_alpine_station": true, "above_home_farm": null, "area_above_1200m_ha": 1})
	checks(p).heimbetrieb
	checks(p).hoehe == false
	checks(changed({"only_alpine_station": false, "above_home_farm": null})).heimbetrieb == null
}

test_jahreswechsel_bei_unterjaehriger_uebergabe if {
	p := changed({"transfer": {"date": "2026-05-10", "successor_measure": "4", "continued_to_year_end": false}})
	r := bm.parcel_procedure with input as at(p)
	r["Schlag A"] == "melden, OP, keine Jahresprämie"
}

test_zugang_2024_ohne_spaetere_basis if {
	result := bm.farm_calculations with input.farm as {"year": 2024, "oepul": {"cumulative_gain_ha": 3.8}}
	result["Prämienfähiger Zuwachs ha"] == 3.8
}
