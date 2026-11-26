package oepul.o6_1c_test

import data.oepul.o6_1c as m
import rego.v1

betrieb := {"year": 2026, "oepul": {"home_modulation_ha": 100}}
profil(parcels) := {"farm": betrieb, "land": {"arable_area_ha": 100, "parcels": parcels}}
schlag(id, ha, q, cuts) := {"parcel_id": id, "area_ha": ha, "o6_1c": q, "operations": {"cutting_dates": cuts}}
brachenbasis := {"category": "NPA", "first_npa_year": 2026, "establishment": "Neuansaat", "mulching_dates": [], "weed_cleaning_dates": [], "break_date": null, "redeclaration_date": null}
brache(id, ha, delta, cuts) := schlag(id, ha, object.union(brachenbasis, delta), cuts)
streifen(q) := schlag("s", 1, object.union({"category": "AFS"}, q), [])
befunde(p) := object.get(b, p.parcel_id, set()) if b := m.schlagbefunde with input as profil([p])
vertrag := {"category": "NPA", "entry_year": 2025, "application_date": "2024-12-31", "annual_payment_application": true, "uninterrupted": true, "withdrawal_date": null}

test_erster_letzter_einstieg if {
	m.einstieg_fristgerecht(vertrag)
	m.einstieg_fristgerecht({"entry_year": 2027, "application_date": "2026-12-31"})
	not m.einstieg_fristgerecht({"entry_year": 2027, "application_date": "2027-01-01"})
	not m.einstieg_fristgerecht({"entry_year": 2028, "application_date": "2027-12-31"})
	not m.einstieg_fristgerecht({"entry_year": 2024, "application_date": "2023-12-01"})
}

test_fortfuehrung_2028 if {
	"NPA" in m.antrag_jahreskriterien with input as {"farm": {"year": 2028, "oepul": {"contracts": [vertrag]}}}
	c := object.union(vertrag, {"withdrawal_date": "2028-12-31"})
	count(m.antrag_jahreskriterien) == 0 with input as {"farm": {"year": 2028, "oepul": {"contracts": [c]}}}
}

test_kombination_betrieb if {
	m.npa_konflikt == {"o6_1c.bio"} with input as {"farm": {"year": 2026, "oepul": {"contracts": [vertrag], "bio": "gesamt"}}}
	m.npa_konflikt == set() with input as {"farm": {"year": 2026, "oepul": {"contracts": [vertrag], "bio": "teilbetrieb_wein_obst_hopfen"}}}
	m.npa_konflikt == {"o6_1c.ubb"} with input as {"farm": {"year": 2026, "oepul": {"contracts": [vertrag], "ubb": true, "bio": "teilbetrieb_wein_obst_hopfen"}}}
	c := object.union(vertrag, {"category": "AFS"})
	m.npa_konflikt == set() with input as {"farm": {"year": 2026, "oepul": {"contracts": [c], "ubb": true}}}
}

test_mindestgroesse if {
	m.mindestgroesse_erreicht with input as {"farm": {"year": 2026, "oepul": {"first_oepul_year": 2026, "protected_at_ha": 0.5}}}
	m.mindestgroesse_erreicht with input as {"farm": {"year": 2026, "oepul": {"first_oepul_year": 2026, "qualifying_at_ha": 1.5}}}
	m.betriebsbefunde == {"o6_1c.mindestgroesse"} with input as {"farm": {"year": 2026, "oepul": {"first_oepul_year": 2026, "qualifying_at_ha": 1.49, "protected_at_ha": 0.49}}}
	m.mindestgroesse_erreicht with input as {"farm": {"year": 2026, "oepul": {"first_oepul_year": 2025}}}
}

test_anlage_und_umbruch if {
	every row in [["keine", "09-14", "umbruch"], ["Winterung", "07-31", "fruehumbruch"], ["Zwischenfrucht", "07-31", "fruehumbruch"]] {
		p := brache("n", 1, {"break_date": concat("", ["2026-", row[1]]), "following_crop": row[0]}, [])
		concat("", ["o6_1c.", row[2]]) in befunde(p)
	}
	every row in [["keine", "09-15"], ["Zwischenfrucht", "08-01"], ["Winterung", "08-01"]] {
		p := brache("n", 1, {"break_date": concat("", ["2026-", row[1]]), "following_crop": row[0], "sowing_date": "2026-05-15"}, [])
		befunde(p) == set()
	}
	"o6_1c.npa_saat" in befunde(brache("n", 1, {"sowing_date": "2026-05-16"}, []))
}

test_verbot_nach_umbruch if {
	p := brache("n", 1, {"break_date": "2026-09-15", "utilization_dates": ["2026-12-31"]}, [])
	"o6_1c.nutzung_umbruch" in befunde(p)
	befunde(brache("n", 1, {"break_date": "2026-09-15", "utilization_dates": ["2027-01-01"]}, [])) == set()
}

test_npa_betriebsmittelzeitraum if {
	spritzung := {"date": "2026-01-01", "all_active_organic": false}
	p := brache("n", 1, {"fertilization_dates": ["2026-01-01"], "psm_events": [spritzung]}, [])
	befunde(p) == {"o6_1c.npa_duenger", "o6_1c.npa_psm"}
	q := brache("n", 1, {"redeclaration_date": "2026-07-20", "fertilization_dates": ["2025-12-31", "2026-07-21"], "psm_events": [{"date": "2026-04-01", "all_active_organic": true}]}, [])
	befunde(q) == set()
}

test_zweijahrespflege if {
	p := brache("n", 1, {"first_npa_year": 2025, "previous_year_care": false}, [])
	befunde(p) == {"o6_1c.pflege_min"}
	befunde(brache("n", 1, {"first_npa_year": 2025, "previous_year_care": true}, [])) == set()
}

test_reinigung_neuansaat if {
	p := brache("n", 1, {"sowing_date": "2025-10-01", "weed_cleaning_dates": ["2026-05-20"], "mulching_dates": ["2026-09-10"]}, ["2026-05-20", "2026-08-01"])
	befunde(p) == set()
	m.pflegeanteil.frueh_ha == 0 with input as profil([p])
	q := brache("n", 1, {"establishment": "bestehende Grünbrache", "weed_cleaning_dates": ["2026-05-20"], "mulching_dates": ["2026-09-10"]}, ["2026-05-20", "2026-08-01"])
	befunde(q) == {"o6_1c.reinigung", "o6_1c.pflege_max"}
	m.pflegeanteil.ueberschritten with input as profil([q])
}

test_anteil_flaechengewichtet if {
	a := brache("klein", 2, {}, ["2026-06-01", "2026-07-31"])
	b := brache("spaet", 2, {}, ["2026-08-01"])
	m.pflegeanteil == {"frueh_ha": 2, "gesamt_ha": 4, "ueberschritten": false} with input as profil([a, b])
	c := brache("frueh", 0.01, {"mulching_dates": ["2026-07-31"]}, [])
	"o6_1c.fruehanteil" in m.betriebsbefunde with input as profil([a, b, c])
}

test_dritte_nutzung_keine_npa_ausnahme if {
	p := brache("n", 1, {"codes": ["NPA", "OPUBB"], "mulching_dates": ["2026-10-01"], "grazed": true}, ["2026-08-12", "2026-09-01"])
	befunde(p) == {"o6_1c.pflege_max", "o6_1c.weide"}
}

test_geometrie if {
	every w in [2, 10] { every n in [10, 25] { befunde(streifen({"average_width_m": w, "tree_count": n, "length_m": 100, "max_tree_gap_m": 15, "planting_date": "2020-01-01"})) == set() } }
	befunde(streifen({"average_width_m": 10.1, "tree_count": 26, "length_m": 100, "max_tree_gap_m": 15.1, "planting_date": "2019-12-31"})) == {"o6_1c.afs_breite", "o6_1c.afs_dichte", "o6_1c.afs_abstand", "o6_1c.afs_lage"}
	befunde(streifen({"average_width_m": 1.99, "tree_count": 19, "length_m": 200})) == {"o6_1c.afs_breite", "o6_1c.afs_dichte"}
}

test_taxa if {
	count(m.werte.negativliste) == 14
	every r in m.werte.negativliste { m.negativgehoelz({"taxon": r.taxon, "fertile": true}) }
	m.negativgehoelz({"taxon": "Elaeagnus angustifolia"})
	not m.negativgehoelz({"taxon": "Paulownia tomentosa", "fertile": false})
	not m.negativgehoelz({"taxon": "Malus domestica"})
}

test_entnahme if {
	q := {"removal_date": "2026-04-01", "criteria_maintained": false, "replant_date": "2026-05-15"}
	befunde(streifen({"removals": [q]})) == set()
	every date in [null, "2026-05-16", "2026-03-31"] {
		"o6_1c.entnahme" in befunde(streifen({"removals": [object.union(q, {"replant_date": date})]}))
	}
	befunde(streifen({"removals": [object.union(q, {"criteria_maintained": true, "replant_date": null})]})) == set()
}

test_afs_betriebsmittel if {
	e := {"date": "2026-05-15", "purpose": "Verbissschutz", "target": "Strauch", "organic_approved": true}
	befunde(streifen({"psm_events": [e], "fertilization_dates": ["2025-12-31"]})) == set()
	every patch in [{"purpose": "Unkrautbekämpfung"}, {"target": "krautiger Bereich"}, {"organic_approved": false}] {
		"o6_1c.afs_psm" in befunde(streifen({"psm_events": [object.union(e, patch)]}))
	}
	befunde(streifen({"fertilization_dates": ["2026-12-31"]})) == {"o6_1c.afs_duenger"}
}

test_acker_und_agroforst_praemien if {
	a := brache("a", 6, {"assessed_before_gloez4_ha": 6, "gloez4_overlap_ha": 1}, [])
	b := streifen({"assessed_before_gloez4_ha": 1})
	m.praemienrahmen == {"npa_ha": 4, "afs_ha": 1, "untergrenze_eur": 2000, "obergrenze_eur": 2600, "modulationsfaktor": 1} with input as profil([a, b])
	c := brache("c", 4, {"assessed_before_gloez4_ha": 4, "gloez4_overlap_ha": 1}, [])
	m.praemienrahmen.npa_ha == 3 with input as profil([c, b])
}

test_fehlende_daten if {
	not m.praemienrahmen with input as profil([streifen({})])
	not m.pflegeanteil with input as profil([schlag("x", 2, {"category": "NPA"}, [])])
}

test_anrechnung if {
	p := streifen({"assigned_arable_field_ha": 5.01, "recognised_strip": true})
	i := {"farm": {"year": 2026, "oepul": {"ubb": true}}, "land": {"arable_area_ha": 10, "parcels": [p]}}
	m.feldstueck_gutschrift == {"s": 1} with input as i
	m.feldstueck_gutschrift == {} with input as i with input.land.arable_area_ha as 9.99
	m.feldstueck_gutschrift == {} with input as i with input.land.parcels as [streifen({"assigned_arable_field_ha": 5, "recognised_strip": true})]
}

test_matrix if {
	count(m.werte.kombinationen) == 441
	every r in m.werte.matrix_achsen { m.kombinationszelle("1C", r.code).zeichen == ""; m.kombinationszelle(r.code, "1C").zeichen == ""}
	m.kombinationszelle("16", "1B").zeichen == "a"
	m.kombinationszelle("1B", "10").fussnote_zelle == 3
	count(m.matrix_hinweise("1A", "4")) == 1
}

test_stufen if {
	m.modulationsfaktor(200) == 1
	m.modulationsfaktor(220) == 218 / 220
	m.modulationsfaktor(1001) == (((200 + 90) + 595) + 0.75) / 1001
	m.stufenprozent("Verwarnungsstufe", 2026) == 0
	m.stufenprozent("Verwarnungsstufe", 2027) == 1
	"1C" in m.obergrenze("allgemein", 2025).ausgenommen
}

test_uebernahme if {
	u := {"application_date": "2028-04-17", "online_mfa": true, "ama_approved": true, "previously_participating": false, "transferred_ha": 2, "additional_ha": 1}
	m.uebernahme_formalkriterien with input as {"farm": {"year": 2028, "oepul": {"transfer": u}}}
	not m.uebernahme_formalkriterien with input as {"farm": {"year": 2028, "oepul": {"transfer": object.union(u, {"additional_ha": 1.01})}}}
}

test_ernteausnahme if {
	p := {"land_use": "arable", "drought": {"harvest_required": true, "late_summer_or_autumn_crop": true, "no_harvestable_crop_due_to_drought": true, "federal_state": "Steiermark", "district": "Weiz"}}
	m.ernteausnahme_2026(p, "2026-08-12") with input.farm.year as 2026
	not m.ernteausnahme_2026(p, "2026-08-11") with input.farm.year as 2026
	not m.ernteausnahme_2026(object.union(p, {"o6_1c": {"category": "NPA"}}), "2026-08-12") with input.farm.year as 2026
}

test_positive_agroforstdefinition if {
	q := {"planting_date": "2020-01-01", "adjoins_arable": true, "woody_stock": true, "special_crop_gsp25_4": false, "average_width_m": 2, "tree_count": 10, "length_m": 100, "max_tree_gap_m": 15, "woody_plants": [{"taxon": "Quercus robur"}, {"taxon": "Corylus avellana"}], "long_side_neighbors": ["Acker"]}
	m.agroforst_definition_erfuellt == {"s"} with input as profil([streifen(q)])
	every patch in [{"long_side_neighbors": ["Wald"]}, {"special_crop_gsp25_4": true}, {"woody_plants": [{"taxon": "Paulownia tomentosa"}]}, {"woody_plants": [{"taxon": "Elaeagnus angustifolia"}]}, {"woody_plants": []}, {"planting_date": "2019-12-31"}] {
		m.agroforst_definition_erfuellt == set() with input as profil([streifen(object.union(q, patch))])
	}
}

test_015_ha_und_sieben_prozent if {
	a := schlag("s", 0.15, {"category": "AFS", "recognised_strip": true, "assigned_arable_field_id": "F", "assigned_arable_field_ha": 5.02}, [])
	m.div_anrechnung == {"s": {"feldstueck_id": "F", "beitrag_zu_015_ha": 0.15, "beitrag_zur_sieben_prozent_quote_ha": 0}} with input as profil([a]) with input.farm.oepul.ubb as true
}

test_code_und_standort if {
	p := brache("n", 1, {"mfa_use": "Ackerweide", "codes": [], "country": "DE", "other_paid_measures": ["16"], "credited_to_other_obligation": true}, [])
	befunde(p) == {"o6_1c.npa_deklaration", "o6_1c.inland", "o6_1c.einzelflaeche", "o6_1c.matrix", "o6_1c.anrechnung_npa"}
}

test_krautbereich_und_baumpflege if {
	p := streifen({"herb_permanently_green": true, "herb_use": "Pflegemahd ohne Abtransport", "planting_date": "2026-05-15", "mfa_use": "LSE Agroforststreifen"})
	befunde(p) == set()
	q := streifen({"herb_use": "Weide", "stakes_after_planting": false, "planting_date": "2026-05-16"})
	befunde(q) == {"o6_1c.krautschicht", "o6_1c.baumpflege", "o6_1c.afs_anlage"}
}

test_fremdverschulden_meldeweg if {
	a := brache("n", 1, {"third_party_fault_only": true, "whole_year_obligations_met": false}, [])
	m.meldeweg.n == "maßnahmenbezogener OP-Code, Nachweis am Betrieb" with input as profil([a])
}

test_antrag_verspaetet if {
	c := object.union(vertrag, {"entry_year": 2026, "application_date": "2026-01-01"})
	"o6_1c.antrag" in m.betriebsbefunde with input as {"farm": {"year": 2026, "oepul": {"contracts": [c]}}}
	"o6_1c.einstieg" in m.betriebsbefunde with input as {"farm": {"year": 2028, "oepul": {"contracts": [object.union(c, {"entry_year": 2028})]}}}
}

test_kanonische_duengemengen if {
	p := brache("n", 1, {}, [])
	a := object.union(p, {"operations": {"fertilizer": {"organic_n_kg_per_ha": 0.5}}})
	"o6_1c.npa_duenger" in befunde(a)
	b := object.union(a, {"o6_1c": {"break_date": "2026-08-01", "following_crop": "Winterung"}})
	not "o6_1c.npa_duenger" in befunde(b)
	c := object.union(streifen({}), {"operations": {"fertilizer": {"mineral_n_kg_per_ha": 1}}})
	"o6_1c.afs_duenger" in befunde(c)
}

test_zweimal_hundert_im_selben_vertrag if {
	i := {"farm": {"year": 2027, "oepul": {"assessment": {"stage": "100 %", "prior_full_reductions_in_contract": 1}}}}
	m.beurteilungsfolge.folge == "Ausschluss und Rückforderung" with input as i
	m.beurteilungsfolge == {"stufe": "Verwarnungsstufe", "einbehalt_prozent": 1} with input as i with input.farm.oepul.assessment.stage as "Verwarnungsstufe"
}

test_flaechensperren_gehen_der_berechnung_vor if {
	every merkmal in [{"codes": ["OP"]}, {"measure_specific_op": true}, {"country": "DE"}, {"national_park": "Donau-Auen"}, {"approved_trial_prevents_compliance": true}, {"public_obligation_overlap": true}, {"mfa_identification_correct": false}, {"other_excluded_use": true}, {"whole_year_obligations_met": false}] {
		p := brache("n", 4, object.union({"assessed_before_gloez4_ha": 4, "gloez4_overlap_ha": 0.1}, merkmal), [])
		m.praemienrahmen.npa_ha == 0 with input as profil([p])
	}
}

test_allgemeine_verfahrensregeln if {
	m.antragsteller_zulaessige_form with input as {"farm": {"year": 2025, "oepul": {"applicant_form": "Gebietskörperschaft", "public_capital_percent": 100}}}
	m.bestimmender_einfluss with input.farm.oepul.public_capital_percent as 25.01
	not m.bestimmender_einfluss with input.farm.oepul.public_capital_percent as 25
	m.korrektur_zulaessig with input.farm.oepul.correction as {"incompatible_combination": true, "payment_notice_received": false, "control_objection": false}
	not m.ausstieg_vor_kontrolle with input.farm.oepul.exit_control as {"inspection_announced": true, "inspection_conducted": false, "administrative_result_notified": false}
	m.auszahlungsfrist(2026) == "2027-06-30"
	m.max_teilzahlung(400) == 300 with input.farm.oepul.administrative_checks_complete as true
	not m.max_teilzahlung(400) with input.farm.oepul.administrative_checks_complete as false
}

test_definitionen_und_mehrjahresabgrenzung if {
	m.gve_stueck("Rinder unter ½ Jahr", 3) == {"einheit": "RGVE", "wert": 1.2}
	m.zwergrind("Dexter")
	m.tierhaltend(3, 8, 2)
	not m.tierhaltend(2.99, 8, 2)
	m.kulturgruppen("Papau", 2025) == {"Obst"}
	m.kulturgruppen("Papau", 2024) == set()
	m.mehrjaehrige_toleranz(2) == 0.5
	m.mehrjaehrige_toleranz(200) == 5
	not m.wechsel_erlaubt("1C", "1B", 2025)
	m.wechsel_erlaubt("1A", "1B", 2025)
	not m.mehrjaehriger_zugang("Nichtproduktive Ackerflächen und Agroforststreifen", 2026, 20)
	m.vertragsgruppe("Nichtproduktive Ackerflächen und Agroforststreifen") == {"einjährig"}
	m.mehrjahresdauer(2025).jahre == 4
}
