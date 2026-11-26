package oepul.o6_8_test

import data.oepul.o6_8 as e
import rego.v1

betrieb := {
	"year": 2026,
	"oepul": {
		"massnahmen": ["1B", "6", "8"], "beginn": 2025, "antragsdatum": "2024-12-31", "vertrag_fortgefuehrt": true, "wien_zuschlag": false, "erster_fruehling_nach_immergruen": false,
		"oepul_teilnahmejahr": 2, "rechtsform": "natuerliche_person", "gebietseinrichtung": false, "eigener_name_und_rechnung": true, "aktiver_landwirt": true, "landwirtschaftliche_taetigkeit": true,
	},
}

mais := {"parcel_id": "A", "area_ha": 0.1, "land_use": "arable", "crop": {"crop_name": "Körnermais"}, "operations": {"tillage_type": "no_till"}, "erosion": {
	"codes": ["DS", "US"], "in_oesterreich": true, "verfuegungsgewalt": true, "mfa_referenz_richtig": true, "hauptsaechlich_landwirtschaftlich": true,
	"bundesland": "Wien", "nationalpark": "", "nationalpark_auflagen": false, "ueberlappende_oeffentliche_leistung": false, "jahresverpflichtung_erfuellt": true, "weitere_praemien": [],
	"vorfrucht": {"jahr": 2025, "programm": "ZWF2023", "variante": 2, "ordnungsgemaess": true},
	"ernte": {"ordnungsgemaesser_anbau": true, "jaehrliche_pflege": true, "geerntet_und_verbracht_prozent": 85},
	"saat": {"hauptsaat": "2026-05-05", "vollflaechig": false, "schlitz_in_bestand": true},
	"us": {"saatdatum": "2026-06-30", "ordnungsgemaesse_anlage": true, "aktiv_zwischen_reihen": true, "mischungspartner": ["A", "B", "C"], "partner_ersichtlich": false, "nachweis": "Rechnung", "flaechendeckend": false, "ausreichender_aufgang": false, "bearbeitung_bis_ernte": false, "herbizid_bis_ernte": false, "erhalten_bis_ernte": true, "mitgeerntet": false},
}}

profil := {"farm": betrieb, "land": {"arable_area_ha": 1.5, "parcels": [mais]}}

test_zwei_verfahren_eine_flaeche_mit_bio_und_duerre if {
	actual := e.grundbetraege with input as profil
	actual == {
		{"schlag": "A", "code": "DS", "ha": 0.1, "eur_ha": 86.4, "eur": 8.64},
		{"schlag": "A", "code": "US", "ha": 0.1, "eur_ha": 97.2, "eur": 9.72},
	}
	a := e.teilnahme_ha with input as profil
	a == 0.10
}

test_mindestflaeche_nicht_doppelt if {
	p := object.union(mais, {"area_ha": 0.099})
	actual := e.grundbetraege with input as profil with input.land.parcels as [p]
	count(actual) == 0
}

test_unvollstaendige_angaben_begruenden_keinen_grundbetrag if {
	actual := e.grundbetraege with input as {"farm": {"year": 2026}, "land": {"parcels": [{"parcel_id": "A", "area_ha": 7}]}}
	count(actual) == 0
}

test_auslandsflaeche_zaehlt_nicht if {
	p := object.union(mais, {"erosion": {"in_oesterreich": false}})
	a := e.teilnahme_ha with input as profil with input.land.parcels as [p]
	a == 0
}

test_zeitgrenzen_vertrag if {
	e.vertrag_aktiv with input as profil
	not e.vertrag_aktiv with input as profil with input.farm.oepul.antragsdatum as "2025-01-01"
	not e.vertrag_aktiv with input as profil with input.farm.year as 2029
	not e.vertrag_aktiv with input as profil with input.farm.oepul.vertrag_fortgefuehrt as false
}

test_uebernahme_nach_regulaerem_einstieg if {
	u := {"jahr": 2028, "ursprungsbeginn": 2023, "erstteilnahme": true, "ama_genehmigt": true, "uebernommen_ha": 2, "zusaetzlich_ha": 1, "antragsdatum": "2028-04-17"}
	e.uebernahme_ok with input.farm.oepul.uebernahme as u
	not e.uebernahme_ok with input.farm.oepul.uebernahme as object.union(u, {"zusaetzlich_ha": 1.01})
	not e.uebernahme_ok with input.farm.oepul.uebernahme as object.union(u, {"antragsdatum": "2028-04-18"})
}

test_betriebsschwellen_und_beteiligung if {
	a := {"oepul_teilnahmejahr": 1, "geschuetzt_at_ha": 0.5, "mindestgroesse_at_ha": 1.49, "rechtsform": "juristische_person", "oeffentlich_prozent": 25, "gebietseinrichtung": false}
	e.groesse_ok with input.farm.oepul as a
	not e.groesse_ok with input.farm.oepul as object.union(a, {"geschuetzt_at_ha": 0.49})
	e.person_ok with input.farm.oepul as a
	not e.person_ok with input.farm.oepul as object.union(a, {"oeffentlich_prozent": 25.1})
}

test_untersaat_jahr_und_kultur if {
	e.kultur_ok(mais, "US") with input.farm.year as 2025
	not e.kultur_ok(mais, "US") with input.farm.year as 2024
	kartoffel := {"crop": {"crop_name": "Speisekartoffeln/Feldgemüse"}}
	e.kultur_ok(kartoffel, "MS") with input.farm.year as 2023
	not e.kultur_ok(kartoffel, "DS") with input.farm.year as 2026
}

test_us_frist_56_tage_und_kalenderende if {
	e.us_datum_ok(mais) with input.farm.year as 2026
	not e.us_datum_ok(object.union(mais, {"erosion": {"saat": {"hauptsaat": "2026-05-04"}}})) with input.farm.year as 2026
	not e.us_datum_ok(object.union(mais, {"erosion": {"saat": {"hauptsaat": "2026-06-01"}, "us": {"saatdatum": "2026-07-01"}}})) with input.farm.year as 2026
}

test_winterackerbohnen if {
	p := {"crop": {"crop_name": "Winterackerbohnen"}, "erosion": {"us": {"saatdatum": "2026-04-30", "vergleichbarer_fruehjahrszeitraum": true}}}
	e.us_datum_ok(p) with input.farm.year as 2026
	not e.us_datum_ok(object.union(p, {"erosion": {"us": {"saatdatum": "2026-05-01"}}})) with input.farm.year as 2026
}

test_duerre_keine_ausnahme_von_mischung_herbizid_und_nachweis if {
	e.untersaat_ok(mais) with input as profil
	not e.us_deckung_ok(mais.erosion.us) with input.farm.year as 2025
	every aenderung in [{"mischungspartner": ["A", "A", "B"]}, {"herbizid_bis_ernte": true}, {"bearbeitung_bis_ernte": true}, {"nachweis": "Lieferschein"}, {"mitgeerntet": true}] {
		p := object.union(mais, {"erosion": {"us": aenderung}})
		not e.untersaat_ok(p) with input as profil
	}
}

test_vorfrucht_uebergaenge if {
	z := {"ordnungsgemaess": true, "jahr": 2022, "programm": "ZWF2015", "variante": 4}
	e.vorfrucht_ok(object.union(mais, {"erosion": {"vorfrucht": z}})) with input as profil with input.farm.year as 2023
	not e.vorfrucht_ok(object.union(mais, {"erosion": {"vorfrucht": object.union(z, {"variante": 2})}})) with input as profil with input.farm.year as 2023
	n := {"ordnungsgemaess": true, "jahr": 2024, "programm": "NPF", "variante": 6}
	e.vorfrucht_ok(object.union(mais, {"erosion": {"vorfrucht": n}})) with input as profil with input.farm.year as 2025
	not e.vorfrucht_ok(mais) with input as profil with input.farm.oepul.erster_fruehling_nach_immergruen as true
}

test_immergruen_ueberwintert_und_aktuell if {
	p := object.union(mais, {"erosion": {"vorfrucht": {"programm": "Immergruen", "ueberwintert": true}}})
	e.vorfrucht_ok(p) with input as profil with input.farm.oepul.massnahmen as ["7"]
	not e.vorfrucht_ok(p) with input as profil
}

test_mulch_maximal_vier_wochen if {
	p := {"operations": {"tillage_type": "mulch"}, "erosion": {"saat": {"erste_bearbeitung": "2024-02-10", "hauptsaat": "2024-03-09", "flach_nichtwendend": true, "tief_mischend": false, "oberflaechenmulch": true, "tiefenlockerung": true, "begruenung_erhalten": true}}}
	e.mulch_ok(p)
	not e.mulch_ok(object.union(p, {"erosion": {"saat": {"hauptsaat": "2024-03-10"}}}))
	not e.mulch_ok(object.union(p, {"erosion": {"saat": {"begruenung_erhalten": false}}}))
}

test_technik_strip_till if {
	p := {"operations": {"tillage_type": "strip_till"}, "erosion": {"saat": {"nur_saatstreifen": true, "rest_zwischen_streifen": true}}}
	e.saattechnik_ok(p)
	not e.saattechnik_ok(object.union(p, {"erosion": {"saat": {"rest_zwischen_streifen": false}}}))
}

test_kartoffel_ausnahme_jede_vierte if {
	a := {"reihen": "jede_vierte_frei", "unkrautkontrolle_und_personenschutz_erforderlich": true, "notwendigkeit_plausibel": true, "geraet": "dammfraese", "abgesetztes_legen": true, "zeitnah": true, "wirksame_erdanhaeufung": true, "bis_krautminderung": true, "max_abstand_m": 2}
	p := {"crop": {"crop_name": "Saatkartoffeln"}, "erosion": {"ah": a}}
	e.anhaeufung_ok(p)
	not e.anhaeufung_ok(object.union(p, {"crop": {"crop_name": "Speisekartoffeln"}}))
	not e.anhaeufung_ok(object.union(p, {"erosion": {"ah": {"max_abstand_m": 2.01}}}))
	not e.anhaeufung_ok(object.union(p, {"erosion": {"ah": {"zeitnah": false}}}))
}

baw := object.union(mais, {"parcel_id": "B", "area_ha": 0.4, "crop": {"crop_name": "Grünbrache"}, "erosion": {"codes": ["BAW"], "baw": {
	"kg_nr": "31001", "gis_ueberlappung_ha": 0.1, "anlagejahr": 2025, "altbestand": false, "winterharte_mischung": true, "saatdatum": "2025-05-15", "leguminosen_prozent": 49.9,
	"umbruchdatum": "2026-09-15", "psm_im_verbotszeitraum": false, "duengung_im_verbotszeitraum": false, "pflegeintervall_eingehalten": true, "beweidet": false, "gedroschen": false, "begruenung_erhalten": true,
	"gruenland_mfa2020": false, "gloez4_ha": 0.05, "gloez4_oder_8_ha": 0.12,
}}})

test_baw_teilflaeche_volle_kette if {
	a := e.grundbetraege with input as profil with input.land.parcels as [baw]
	a == {{"schlag": "B", "code": "BAW", "ha": 0.35, "eur_ha": 594, "eur": 207.9}}
}

test_baw_viertel_und_kulisse if {
	e.baw_lage_ok(baw)
	not e.baw_lage_ok(object.union(baw, {"area_ha": 0.401}))
	not e.baw_lage_ok(object.union(baw, {"erosion": {"baw": {"kg_nr": "99999"}}}))
	e.kg_gelistet("09113")
}

test_baw_bestand_und_neueinsaat if {
	not e.baw_anlage_ok(object.union(baw, {"erosion": {"baw": {"leguminosen_prozent": 50}}}))
	not e.baw_anlage_ok(object.union(baw, {"erosion": {"baw": {"saatdatum": "2025-05-16"}}}))
	k := object.union(baw, {"crop": {"crop_name": "Kleegras"}, "erosion": {"baw": {"leguminosen_prozent": 65}}})
	not e.kultur_ok(k, "BAW") with input as profil
	e.baw_anlage_ok(object.union(k, {"erosion": {"baw": {"altbestand": true}}})) with input as profil
}

test_baw_umbruch_und_pflege if {
	b := baw.erosion.baw
	e.baw_umbruch_ok(b)
	not e.baw_umbruch_ok(object.union(b, {"umbruchdatum": "2026-09-14"}))
	not e.baw_pflege_ok(object.union(baw, {"erosion": {"baw": {"beweidet": true}}})) with input as profil
}

test_baw_verbotszeitraum if {
	b := {"erstes_mfa_jahr": 2025, "umbruchdatum": "2026-09-15", "anderweitige_deklaration": null, "mittelereignisse": [{"datum": "2024-12-31"}]}
	e.baw_mittel_ok(b)
	not e.baw_mittel_ok(object.union(b, {"mittelereignisse": [{"datum": "2025-01-01"}]}))
	not e.baw_mittel_ok(object.union(b, {"mittelereignisse": [{"datum": "2026-09-14"}]}))
}

test_baw_gloez_und_gruenland if {
	e.baw_zahlflaeche(baw) == 0.28 with input.farm.year as 2024
	e.baw_zahlflaeche(baw) == 0.35 with input.farm.year as 2025
	not e.baw_zahlflaeche(object.union(baw, {"erosion": {"codes": ["BAW", "NPF"]}})) with input.farm.year as 2024
	not e.baw_zahlflaeche(object.union(baw, {"erosion": {"baw": {"gruenland_mfa2020": true}}})) with input.farm.year as 2026
}

test_kombinationen if {
	e.weitere_praemien_ok(object.union(baw, {"erosion": {"weitere_praemien": [{"massnahme": "1A", "nur_lse": true}]}}), "BAW")
	not e.weitere_praemien_ok(object.union(baw, {"erosion": {"weitere_praemien": [{"massnahme": "1A", "nur_lse": false}]}}), "BAW")
	not e.vertraeglich(object.union(mais, {"erosion": {"codes": ["AH", "MS"]}}), "AH")
	e.matrixzelle("8", "24").zeichen == "x"
	e.matrixzelle("8", "18").zeichen == ""
	e.matrixzelle("1B", "16").zeichen == "a"
}

test_wien_nur_saatpraemie_entfaellt if {
	a := e.grundbetraege with input as profil with input.farm.oepul.wien_zuschlag as true
	a == {{"schlag": "A", "code": "US", "ha": 0.1, "eur_ha": 97.2, "eur": 9.72}}
}

test_distrikt_und_erntezeit if {
	p := {"erosion": {"bundesland": "Steiermark", "bezirk": "Weiz", "ernte": {"spaetsommer_herbst_hitzeanfaellig": true, "duerrebedingter_totalausfall": true}}}
	e.ernteausnahme(p) with input as profil
	not e.ernteausnahme(object.union(p, {"erosion": {"bezirk": "Liezen"}})) with input as profil
	not e.ernteausnahme(object.union(p, {"erosion": {"ernte": {"spaetsommer_herbst_hitzeanfaellig": false}}})) with input as profil
	not e.ernteausnahme(p) with input.farm.year as 2025
}

test_modulation_obergrenze_sanktion if {
	e.modulationsfaktor(220) == 218 / 220
	e.modulationsfaktor(1200) == (((200 + 90) + 595) + 150) / 1200
	z := [{"massnahme": "8", "eur": 600}, {"massnahme": "1A", "eur": 900}, {"massnahme": "6", "eur": 100}]
	e.gekappte_schlagsumme("allgemein", 1, z) == 1400 with input.farm.year as 2026
	e.sanktionssatz(0) == 0 with input.farm.year as 2026
	e.sanktionssatz(0) == 1 with input.farm.year as 2027
	e.sanktionsfolge(6, 1).ausschluss with input.farm.year as 2027
	e.abgangstoleranz(4) == 0.5
	e.abgangstoleranz(300) == 5
}

test_tarife_2023_2024 if {
	every r in [["MS", 50, 54], ["DS", 80, 86.4], ["AH", 150, 162], ["BAW", 550, 594], ["US", 75, 81], ["US_BIO", 15, 16.2]] {
		e.satz(r[0]) == r[1] with input.farm.year as 2023
		e.satz(r[0]) == r[2] with input.farm.year as 2024
	}
}

test_immergruen_duerre_maximalfrist if {
	x := {"kulturtyp": "Zwischenfrucht", "anlage": "2026-10-15", "vorausschauend_plausibel": true, "anlagevoraussetzungen_fehlten": true, "fruehestmoeglich_nachgeholt": true, "dauer_tage": 42, "ueberwiegend_winterhart": true}
	e.immer_duerre_nachsaat(x) with input.farm.year as 2026
	not e.immer_duerre_nachsaat(object.union(x, {"anlage": "2026-10-16"})) with input.farm.year as 2026
	not e.immer_duerre_nachsaat(object.union(x, {"dauer_tage": 41})) with input.farm.year as 2026
}

test_variante2_anzahl_und_termine if {
	partner := [{"art": sprintf("Art%d", [i]), "familie": sprintf("Familie%d", [i % 3])} | some i in numbers.range(1, 7)]
	x := {"anlage": "2025-08-05", "umbruch": "2026-02-15", "partner": partner, "weitere_auflagen_erfuellt": true}
	p := object.union(mais, {"erosion": {"vorfrucht": {"variantenanlage": x}}})
	e.vorfrucht_ok(p) with input as profil
	not e.vorfrucht_ok(object.union(p, {"erosion": {"vorfrucht": {"variantenanlage": {"umbruch": "2026-02-14"}}}})) with input as profil
	not e.variantenanlage_ok(2, 2025, object.union(x, {"anlage": "2025-08-06"}))
	not e.variantenanlage_ok(2, 2025, object.union(x, {"partner": array.slice(partner, 0, 6)}))
}

test_variante6_arten if {
	x := {"anlage": "2025-10-15", "umbruch": "2026-03-21", "partner": [{"art": "Winterackerbohne"}]}
	e.variantenanlage_ok(6, 2025, x)
	not e.variantenanlage_ok(6, 2025, object.union(x, {"partner": [{"art": "Sommerackerbohne"}]}))
}

test_untersaat_als_zwischenfrucht if {
	p := object.union(mais, {"erosion": {"us": {"folgende_variantenauflagen_erfuellt": true}}})
	e.zwischenfrucht_aus_untersaat(p, 4, 2026, "2026-08-30")
	not e.zwischenfrucht_aus_untersaat(p, 4, 2026, "2026-08-31")
}

test_erneuerung_baw_pflege_intervall if {
	p := {"operations": {"cutting_dates": ["2025-06-01"]}, "erosion": {"baw": {"anlagejahr": 2024, "haeckseldaten": []}}}
	e.baw_pflegeintervall(p) with input.farm.year as 2026
	not e.baw_pflegeintervall(p) with input.farm.year as 2027
}

test_anrechnung_div_und_wechsel if {
	p := object.union(baw, {"erosion": {"codes": ["BAW", "DIV"], "baw": {"div_pflege_und_nutzung": true}}})
	e.div_anrechenbar(p) with input as profil
	not e.div_anrechenbar(p) with input as profil with input.farm.oepul.massnahmen as ["6", "8"]
	e.wechsel_moeglich("19", "2025-12-31")
	not e.wechsel_moeglich("19", "2026-01-01")
}

test_nationalpark_op_und_vf if {
	every code in ["OP", "OPEROA", "VF"] {
		not e.basisflaeche_ok(object.union(mais, {"erosion": {"codes": ["US", code]}}))
	}
	not e.basisflaeche_ok(object.union(mais, {"erosion": {"nationalpark": "Donau-Auen"}}))
	e.basisflaeche_ok(object.union(mais, {"erosion": {"codes": ["US", "OPBIO"]}}))
}

test_hanggrenzen if {
	p := {"land_use": "arable", "area_ha": 0.51, "slope_percent": 10, "erosion": {"erosionsgefaehrdete_kultur": true, "minderndes_verfahren": false}}
	e.hangfaktor(p, "1B") == 0.5 with input.farm.year as 2025
	e.hangfaktor(p, "1B") == 0 with input.farm.year as 2024
	e.hangfaktor(p, "1A") == 0 with input.farm.year as 2025
	not e.hangfall(object.union(p, {"area_ha": 0.5}))
}

test_allgemeine_tabellen if {
	e.kulturgruppe("Papau") == {"Obst"} with input.farm.year as 2025
	e.kulturgruppe("Papau") == set() with input.farm.year as 2024
	e.tierhaltend with input.livestock.bemessung as {"futterflaeche_ha": 2, "durchschnittsbestaende": [{"kategorie": "Rinder ½ bis unter 2 Jahre", "anzahl_inland": 1}]}
	e.vertragsgruppen("8") == {"mehrjährig", "jährlich wechselnde Einheiten"}
	not e.gebietseinrichtung_zugelassen("8", 2026)
	e.gebietseinrichtung_zugelassen("6", 2026)
	e.matrixhinweis(1) == "Nur Abgeltung der Landschaftselemente."
	e.kuerzungsreihenfolge[6] == "Modulation"
}

test_korrekturbedarf_und_ausnahme_div if {
	p := object.union(mais, {"erosion": {"nicht_erfuellbare_codes": ["US"]}})
	a := e.korrekturbedarf with input.land.parcels as [p]
	a == {{"schlag": "A", "code": "US", "regel": "o6_8.korrektur"}}
	not e.duerre_div_code(0.25, "Mahd", 2) with input.farm.year as 2026
	e.duerre_div_code(0.26, "Mahd", 2) with input.farm.year as 2026
	e.duerre_div_code(0, "Mahd", 3) with input.farm.year as 2026
}

test_baw_einsatz_am_umbruchtag if {
	b := {"erstes_mfa_jahr": 2025, "umbruchdatum": "2026-09-15", "anderweitige_deklaration": null}
	not e.baw_mittel_ok(object.union(b, {"mittelereignisse": [{"datum": "2026-09-15"}]}))
	e.baw_mittel_ok(object.union(b, {"mittelereignisse": [{"datum": "2026-09-15", "nach_beendigung_am_selben_tag": true}]}))
}
