package oepul.o6_14_test

import data.oepul.o6_14 as alm
import rego.v1

aufenthalt(id, von, bis, meldung) := {"alm_id": id, "in_oesterreich": true, "von": von, "bis": bis, "auftrieb_gemeldet": meldung}
tier(art, geburt, stueck, orte) := {"art": art, "rasse": "Fleckvieh", "geburt": geburt, "stueck": stueck, "aufenthalte": orte, "weidezugang": true}
frueh := aufenthalt("A", "2026-06-01", "2026-07-01", "2026-06-01")
spaet := aufenthalt("B", "2026-07-01", "2026-08-20", "2026-07-01")
schaf := tier("Schaf", "2025-07-01", 1, [frueh, spaet])

test_einstieg_betrieb_und_folgejahre if {
	alm.mindestteilnahme(2025, 2025, 3, 3)
	not alm.mindestteilnahme(2025, 2025, 2.99, 3)
	not alm.mindestteilnahme(2025, 2025, 3, 2.99)
	alm.mindestteilnahme(2025, 2026, 2, 1)
	not alm.mindestteilnahme(2026, 2026, 4, 4)
}

test_altersgrenzen if {
	alm.rgve_pro_stueck(schaf, 2026) == 0.15
	alm.rgve_pro_stueck(object.union(schaf, {"geburt": "2025-07-02"}), 2026) == 0.07
	alm.rgve_pro_stueck(tier("Rind", "2026-01-01", 1, []), 2026) == 0.6
	alm.rgve_pro_stueck(tier("Rind", "2026-01-02", 1, []), 2026) == 0.4
	alm.rgve_pro_stueck(object.union(tier("Rind", "2024-07-01", 1, []), {"rasse": "Dexter"}), 2026) == 0.5
	not alm.rgve_pro_stueck(tier("Rotwild", "2025-01-01", 1, []), 2026)
}

test_equiden_groesse if {
	p := object.union(tier("Equide", "2023-07-01", 1, []), {"rassenhoehe_m": 1.48, "rassenendgewicht_kg": 300})
	alm.rgve_pro_stueck(p, 2026) == 0.5
	alm.rgve_pro_stueck(object.union(p, {"rassenendgewicht_kg": 301}), 2026) == 1
	alm.rgve_pro_stueck(object.union(p, {"rassenhoehe_m": 1.49}), 2026) == 1
}

test_aliquot_alm_und_tier if {
	count(alm.weidetage(schaf, 2026)) == 80
	alm.bestossungstage([schaf], "A", 2026) == 30
	alm.anteil(schaf, "A", 2026) == 30 / 80
	alm.anteil(schaf, "B", 2026) == 50 / 80
}

test_doppelbelegung_und_luecke if {
	a := tier("Rind", "2020-01-01", 2, [frueh])
	b := tier("Schaf", "2025-05-01", 3, [aufenthalt("A", "2026-07-10", "2026-08-09", "2026-07-10")])
	alm.bestossungstage([a, a, b], "A", 2026) == 60
	alm.besatz_rgve([a, b], "A", 2026) == 0
}

test_verspaetete_meldung if {
	s := aufenthalt("A", "2026-06-20", "2026-06-30", "2026-07-10")
	alm.auftriebstage("Rind", s, 2026) == {alm.tag("2026-06-26"), alm.tag("2026-06-27"), alm.tag("2026-06-28"), alm.tag("2026-06-29")}
	count(alm.auftriebstage("Schaf", s, 2026)) == 0
	alm.abtrieb_fristgerecht("Rind", object.union(s, {"abtrieb_gemeldet": "2026-07-14"}))
	not alm.abtrieb_fristgerecht("Ziege", object.union(s, {"abtrieb_gemeldet": "2026-07-08"}))
	alm.abtrieb_fristgerecht("Equide", object.union(s, {"prognose_abtrieb": s.bis}))
}

test_almbeispiel_zwei_almen if {
	kuehe := tier("Rind", "2020-06-01", 20, [aufenthalt("A", "2026-05-01", "2026-08-29", "2026-05-02")])
	kaelber := tier("Rind", "2026-02-01", 4, [frueh, spaet])
	kalbinnen := tier("Rind", "2023-06-01", 2, [aufenthalt("A", "2026-04-12", "2026-07-01", "2026-04-12"), spaet])
	b := [aufenthalt("B", "2026-05-01", "2026-08-29", "2026-05-02")]
	tiere := [kuehe, kaelber, kalbinnen, tier("Schaf", "2024-03-01", 9, b), tier("Schaf", "2026-03-01", 10, b)]
	round(100 * alm.besatz_rgve(tiere, "A", 2026)) == 2183
	round(100 * alm.besatz_rgve(tiere, "B", 2026)) == 382
}

test_stichtage_besatz_und_zahlung if {
	s := aufenthalt("A", "2028-07-16", "2028-09-14", "2028-07-16")
	t := tier("Rind", "2022-01-01", 1, [s])
	alm.listenfrist(2028) == "2028-07-17"
	alm.feldfrist(2028) == "2028-04-17"
	alm.besatz_rgve([t], "A", 2028) == 1
	alm.zahl_rgve([t], "A", 2028) == 0
	alm.besatz_rgve([object.union(t, {"geburt": "2028-07-02"})], "A", 2028) == 0
}

test_unvollstaendige_daten_keine_teilsumme if {
	not alm.besatz_rgve([schaf, {"art": "Equide"}], "A", 2026)
	not alm.bestossungstage([{"art": "Schaf", "stueck": 1}], "A", 2026)
}

test_zuschlaege_und_ersatzgrenzen if {
	a := {"naturschutz": false, "almweideplan": true, "intensitaet": {"beantragt": true, "oekologisch_erforderlich": true, "begruendung_im_plan": true, "listenantrag": "2026-07-15"}}
	alm.besatzgrenze(a, 2026) == 2.4
	alm.besatzgrenze(object.union(a, {"intensitaet": {"listenantrag": "2026-07-16"}}), 2026) == 2
	alm.besatzgrenze({"naturschutz": true, "almweideplan": false}, 2026) == 1.5
	not alm.optionen_vereinbar(true, true)
	alm.planzuschlag(43, 2026) == 400
	alm.projektsatz("NAW1", 5, 2026) == 2.2
	alm.projektsatz("NAD2", 20, 2024) == 4.3
	alm.projektsatz("NAB3", 20.01, 2025) == 43.2
	not alm.projektsatz("NAB1", 1, 2025)
	not alm.projektsatz("NAB1", 5, 2023)
}

test_schlag_und_betriebsgrenzen if {
	alm.praemienflaeche(50, 43) == 43
	alm.praemienflaeche(50, 67) == 50
	alm.modulationsbasis([120, 60], [150, 100]) == 180
	alm.modulationsfaktor(250) == 0.98
	alm.modulationsfaktor(1100) == (((200 + 90) + 595) + 75) / 1100
	alm.abgangstoleranz(3) == 0.5
	alm.abgangstoleranz(60) == 3
	alm.abgangstoleranz(180) == 5
}

test_betriebseinstieg_normaleingabe if {
	a := {"id": "A", "stufe": 2, "inland_ha": 1.5, "praemienfaehige_inland_ha": 1.5, "naturschutz": false, "almweideplan": false}
	s := aufenthalt("A", "2025-06-01", "2025-06-30", "2025-06-01")
	p := {"farm": {"year": 2025}, "almwirtschaft": {"startjahr": 2025, "aufgetriebene_rgve_betrieb": 3, "almen": [a, object.union(a, {"id": "B"})], "tiere": [tier("Rind", "2021-01-01", 3, [s])]}}
	alm.einstieg_erfuellt with input as p
	werte := alm.almwerte with input as p
	werte.A.bestossungstage == 29
	werte.A.mindestdauer_erreicht == false
}

test_natur_futter_und_psm if {
	s := {"art": "Silage", "almeigen": true, "eigenalm_heuwirtschaft": false}
	not alm.futter_zulaessig(s, 2024)
	alm.futter_zulaessig(s, 2025)
	not alm.futter_zulaessig(object.union(s, {"eigenalm_heuwirtschaft": true}), 2026)
	not alm.psm_zulaessig([{"bio_2018_848": true}, {"bio_2018_848": false}])
	alm.psm_code({"flaechig": true, "chemisch_synthetisch": true, "bio_einsatz": true}, 2025) == "PSMCS"
	alm.psm_code({}, 2026) == null
	d := {"art": "Mist", "bio_2018_848": true, "naturschutz": true, "standort": "Moor", "borstgrasrasen": false}
	not alm.duenger_zulaessig(d)
	alm.duenger_zulaessig(object.union(d, {"borstgrasrasen": true}))
	not alm.duenger_zulaessig(object.union(d, {"art": "Klaerschlamm", "naturschutz": false}))
}

test_kombination_und_sanktion if {
	alm.kombizelle("14", "18").markierung == ""
	alm.kombizelle("1B", "16").markierung == "a"
	alm.sanktionsfolge("Verwarnstufe", 2027, 0).prozent == 1
	alm.sanktionsfolge("100", 2026, 1).ausschluss
	alm.park_ausschluss("Kalkalpen", false)
	not alm.park_ausschluss("Hohe Tauern", false)
}

test_kombinationsmatrix_vollstaendig if {
	zeilen := data.almtabellen.kombinationen
	codes := {"1A", "1B", "1C", "2", "3", "4", "6", "7", "8", "9", "10", "11", "12", "13", "14", "16", "17", "18", "19", "23", "24"}
	is_array(zeilen)
	count(zeilen) == count(codes)
	{zeile.code | some zeile in zeilen} == codes
	every zeile in zeilen {
		object.keys(zeile.zellen) == codes
	}
	every andere in codes - {"14"} {
		alm.kombizelle("14", andere).markierung == ""
		alm.kombizelle(andere, "14").markierung == ""
	}
	not alm.kombizelle("14", "14")
}

test_ausland_entlastet_nur_besatz if {
	a := {"inland_ha": 10, "ausland_angrenzend_ha": 4, "ausland_jahresmeldung_mit_nachweis": true}
	alm.besatzflaeche(a) == 14
	alm.besatzflaeche(object.union(a, {"ausland_jahresmeldung_mit_nachweis": false})) == 10
	alm.praemienflaeche(a.inland_ha, 18) == 10
}

test_befreiung_nur_rinder_stufe_eins if {
	a := {"id": "A", "stufe": 1, "behirtung": false, "intensitaet": {"beantragt": false}}
	r := tier("Rind", "2021-05-01", 1, [frueh])
	alm.listenbefreiung(a, [r], 2026)
	not alm.listenbefreiung(a, [r, schaf], 2026)
	not alm.listenbefreiung(object.union(a, {"behirtung": true}), [r], 2026)
	not alm.listenbefreiung(object.union(a, {"intensitaet": {"beantragt": true}}), [r], 2026)
}

test_antrag_uebernahme_grenzen if {
	f := {"option": "Basis", "bisher_teilnehmend": false, "uebernommen_ha": 4, "ausweitung_ha": 2, "online_antrag": "2028-07-17", "ama_genehmigt": true}
	alm.uebernahme_moeglich(f, 2028)
	not alm.uebernahme_moeglich(object.union(f, {"ausweitung_ha": 2.01}), 2028)
	not alm.uebernahme_moeglich(object.union(f, {"option": "Almweideplan", "struktur": "Verkauf"}), 2028)
	alm.uebernahme_moeglich(object.union(f, {"option": "Almweideplan", "struktur": "Teilung"}), 2028)
}

test_weiterbildung_je_person_und_veranstaltung if {
	k := {"id": "eins", "option": "Naturschutz", "datum": "2022-01-01", "stunden": 2, "anbieter_anerkannt": true, "fachthema_erfuellt": true, "nur_dieser_betrieb": true, "nur_diese_verpflichtung": true}
	p := {"massgeblich_eingebunden": true, "austritt": null, "kurse": [k, k, object.union(k, {"id": "zwei", "datum": "2025-12-31"})]}
	alm.kursstunden(p, "Naturschutz", 2024) == 4
	not alm.weiterbildung_erfuellt([object.union(p, {"kurse": [k]}), object.union(p, {"kurse": [k]})], "Naturschutz", 2024)
	not alm.weiterbildung_erfuellt([object.union(p, {"austritt": "2025-12-30"})], "Naturschutz", 2024)
	alm.weiterbildung_erfuellt([object.union(p, {"austritt": "2026-01-01"})], "Naturschutz", 2024)
}

test_plan_ueberpruefung_alle_almen if {
	p := {"jahr": 2026, "erstellt_am": "2026-07-15", "standort_ertrag": true, "oekologische_wertigkeit": true, "ziele_management": true, "lenkung_je_teilflaeche": true, "kommuniziert": true, "angefordert": false, "jaehrlich_geprueft": true, "pruefung_dokumentiert": true, "aenderungsbedarf": true, "aktualisiert": true}
	alm.plan_erfuellt([{"plan": p}], 2026, 2025)
	not alm.plan_erfuellt([{"plan": p}, {"plan": object.union(p, {"aktualisiert": false})}], 2026, 2025)
	not alm.plan_erfuellt([{"plan": object.union(p, {"erstellt_am": "2026-07-16"})}], 2026, 2026)
}

test_tarif_normalfall_mit_plan if {
	s := aufenthalt("A", "2026-06-01", "2026-08-01", "2026-06-03")
	a := {"id": "A", "stufe": 1, "inland_ha": 25, "praemienfaehige_inland_ha": 25, "naturschutz": false, "almweideplan": true, "intensitaet": {"beantragt": false}}
	x := {"farm": {"year": 2026}, "almwirtschaft": {"almen": [a], "tiere": [tier("Rind", "2020-06-01", 25, [s])]}}
	preis := alm.tarifbetraege with input as x
	preis.A.basis_eur == 1080
	preis.A.zuschlag_eur == 400
	preis.A.moduliert_eur == 1480
}

test_einzelfall_und_ackerduerre if {
	f := {"nutzungsart": "A", "spaetkultur": true, "duerre_kein_erntbarer_bestand": true, "bundesland": "Steiermark", "bezirk": "Weiz"}
	alm.ernteausnahme(f, 2026)
	not alm.ernteausnahme(object.union(f, {"nutzungsart": "L"}), 2026)
	not alm.ernteausnahme(f, 2025)
	alm.duerre_ansuchen(2026, true)
}

test_erschliessungszeit if {
	teile := [{"stufe": 1, "rgve_tage": 3750}, {"stufe": 3, "rgve_tage": 4800}]
	alm.erschliessung(teile, true) == 2
	alm.erschliessung(teile, false) == 3
	alm.erschliessungsbezug(true, {"zentrumsabstand_m": 50})
	not alm.erschliessungsbezug(true, {"zentrumsabstand_m": 50.01})
}

test_feststellungen_nata_ohne_grundvertragssanktion if {
	a := {"id": "N", "naturschutz": true, "eingriffe": [{"art": "Neuentwaesserung"}, {"art": "Traenkestelle", "quellflur": true}]}
	f := alm.feststellungen with input as {"almwirtschaft": {"almen": [a]}}
	{"regel": "o6_14.natabau", "alm": "N", "eingriff": "Neuentwaesserung"} in f
	{"regel": "o6_14.natatraenke", "alm": "N", "eingriff": 1} in f
}

test_div_fristen_begleitmassnahmen if {
	alm.div_wechsel("DIVSZ", "DIVNFZ", "2026-06-15")
	not alm.div_wechsel("DIVSZ", "DIVNFZ", "2026-06-16")
	not alm.div_wechsel("DIVNFZ", "DIVSZ", "2026-05-31")
	alm.div_variante("DIVRS").max_nutzungen == 2
}

test_keine_doppelzuordnung_eines_tieres if {
	t := tier("Rind", "2019-01-01", 1, [frueh, object.union(frueh, {"alm_id": "B"})])
	not alm.besatz_rgve([t], "A", 2026)
}

test_grenzalm_zuschlagsbesatz if {
	a := {"inland_ha": 10, "ausland_angrenzend_ha": 2, "ausland_jahresmeldung_mit_nachweis": true}
	not alm.besatzflaeche_fuer_grenze(a, 1.5)
	alm.besatzflaeche_fuer_grenze(object.union(a, {"ausland_in_zuschlagsgrenze_anerkannt": true}), 1.5) == 12
	alm.besatzflaeche_fuer_grenze(object.union(a, {"ausland_in_zuschlagsgrenze_anerkannt": false}), 1.5) == 10
}

test_kultur_und_listenzuordnung if {
	"Obst" in alm.kulturgruppen("Haselnuss", 2026)
	not "Obst" in alm.kulturgruppen("Papau", 2024)
	"Obst" in alm.kulturgruppen("Papau", 2025)
	alm.jaehrlich_verfuegbare_einheiten("Almbewirtschaftung")
	alm.ausgeschlossene_nutzung("Rebschulflächen")
}
