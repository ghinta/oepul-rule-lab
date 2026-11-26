package oepul.o6_19_test

import data.oepul.o6_19 as ebw
import rego.v1

test_letzter_einstieg if {
	ebw.einstieg_fristgerecht("EBW", 2025, "2024-12-31")
	not ebw.einstieg_fristgerecht("EBW", 2025, "2025-01-01")
	not ebw.einstieg_fristgerecht("EBW", 2026, "2025-12-15")
	ebw.einstieg_fristgerecht("Regionaler Naturschutzplan", 2028, "2027-12-31")
	ebw.vertragsjahre(2023) == 6
	ebw.vertragsjahre(2025) == 4
}

test_mindestflaeche_im_ersten_ebw_jahr if {
	ebw.mindestteilnahme with input.farm as {"year": 2025, "ebw": {"erstjahr": 2025, "foerderfaehige_ha": 1}}
	not ebw.mindestteilnahme with input.farm as {"year": 2025, "ebw": {"erstjahr": 2025, "foerderfaehige_ha": 0.999}}
	ebw.mindestteilnahme with input.farm as {"year": 2026, "ebw": {"erstjahr": 2025, "bewirtschaftete_schlaege": 1}}
}

test_oepul_erstjahr_unabhaengig if {
	ebw.betriebsgroesse_erfuellt with input as {"farm": {"year": 2025, "oepul_erstjahr": 2025}, "land": {"mfa_geschuetzt_at_ha": 0.5}}
	not ebw.betriebsgroesse_erfuellt with input as {"farm": {"year": 2025, "oepul_erstjahr": 2025}, "land": {"mfa_geschuetzt_at_ha": 0.49, "mfa_gesamt_at_ha": 1.49}}
	ebw.betriebsgroesse_erfuellt with input.farm as {"year": 2025, "oepul_erstjahr": 2023}
}

test_projektcode_und_referenz if {
	p := {"land_use": "grassland", "ebw": {"codes": ["EBW"], "referenz_ha": 0.1, "projekt_bestaetigt": true}}
	ebw.projektflaeche(p)
	not ebw.projektflaeche(object.union(p, {"land_use": "alpine_pasture"}))
	not ebw.projektflaeche(object.union(p, {"ebw": {"referenz_ha": 0}}))
}

test_ackerstilllegungsgrenze if {
	ebw.brache_ha == 2 with input.land.arable_area_ha as 4 with input.farm.ebw.foerderfaehige_stilllegung_ha as 3
	ebw.brache_ha == 5 with input.land.arable_area_ha as 20 with input.farm.ebw.foerderfaehige_stilllegung_ha as 6
	ebw.brache_ha == 0.4 with input.land.arable_area_ha as 1 with input.farm.ebw.foerderfaehige_stilllegung_ha as 0.4
}

test_indikator_mehrfachschwelle if {
	row := [r | some r in data.ebw_tabellen.indikatoren; r.code == "EBAB02"][0]
	ebw.befund(row, {"messungen": {"arten": 20, "einjaehrige_arten": 10}}) == "erfüllt"
	ebw.befund(row, {"messungen": {"arten": 19, "einjaehrige_arten": 10}}) == "verfehlt"
	ebw.befund(row, {"messungen": {"arten": 20}}) == "offen"
	ebw.befund(row, {"fachbefund": true}) == "offen"
}

test_projektparameter if {
	row := [r | some r in data.ebw_tabellen.indikatoren; r.code == "EBNE05"][0]
	ebw.befund(row, {"zielarten": ["Projektart"], "messungen": {"exemplare_je_ar": 2}, "parameter": {"$1": 2}}) == "erfüllt"
	ebw.befund(row, {"zielarten": ["Projektart"], "messungen": {"exemplare_je_ar": 2}, "parameter": {"$1": 1}}) == "verfehlt"
	ebw.befund(row, {"zielarten": ["Projektart"], "messungen": {"exemplare_je_ar": 2}}) == "offen"
}

test_zusatzindikator_nicht_bindend if {
	i := {"gruppe": "Ackerbrachen", "code": "EBAB03", "pflicht": true, "messungen": {"arten": 10}}
	z := {"gruppe": "Ackerbrachen", "code": "EBAB05", "pflicht": false, "fachbefund": false}
	p := {"parcel_id": "S1", "land_use": "arable", "ebw": {"codes": ["EBW"], "indikatoren": [i, z], "indikatorliste_vollstaendig": true}}
	ebw.pflichtindikatoren_erfuellt(p)
	out := ebw.schlagbewertung with input.land.parcels as [p]
	count(out.S1.indikatoren) == 2
	out.S1.tabellensatz_eur_ha == null
	not ebw.pflichtindikatoren_erfuellt({"ebw": {"indikatorliste_vollstaendig": true, "indikatoren": []}})
}

test_tarife_zeilen_spalten_und_jahre if {
	p := {"ebw": {"tarifgruppe": "Wiese", "praemientyp": "Feuchte bis nasse Fettwiese", "zustand": "A", "erschwernis": "schwer"}}
	ebw.basis_eur_ha(p) == 1124 with input.farm.year as 2024
	v := {"ebw": {"tarifgruppe": "Vogel", "praemientyp": "Braunkehlchen", "zustand": "A"}}
	ebw.basis_eur_ha(v) == 837 with input.farm.year as 2024
	ebw.basis_eur_ha(v) == 1053 with input.farm.year as 2025
	not ebw.basis_eur_ha(v) with input.farm.year as 2023
	not ebw.basis_eur_ha({"ebw": {"tarifgruppe": "Wiese", "praemientyp": "Lärchenwiese", "zustand": "A", "erschwernis": "leicht"}}) with input.farm.year as 2026
}

test_habitatschwelle if {
	p := {"land_use": "grassland", "ebw": {"habitat_code": "EBHG01", "schutzgut_typ": "6210", "landesmeldung": true, "ama_gis": true, "schutzgut_prozent": 50, "habitatindikatoren_erfuellt": true, "habitatzuschlag_bestaetigt": true}}
	ebw.habitat_eur_ha(p) == 108 with input.farm.year as 2026
	not ebw.habitat_eur_ha(object.union(p, {"ebw": {"schutzgut_prozent": 49.99}})) with input.farm.year as 2026
	not ebw.habitat_eur_ha(object.union(p, {"land_use": "arable"})) with input.farm.year as 2026
}

test_ebba_stufe_und_begruendung if {
	p := {"area_ha": 0.3, "land_use": "grassland", "ebw": {"zustand": "A", "erschwernis": "leicht", "aufwand_grund": "Kleinflächigkeit", "aufwand_bestaetigt": true, "aufwand_code": "EBBA02"}}
	not ebw.aufwand_eur_ha(p) with input.farm.year as 2024
	ebw.aufwand_eur_ha(p) == 162 with input.farm.year as 2025
	not ebw.aufwand_eur_ha(object.union(p, {"area_ha": 0.31})) with input.farm.year as 2025
	not ebw.aufwand_eur_ha(object.union(p, {"ebw": {"zustand": "B"}})) with input.farm.year as 2025
}

test_divsz_passende_nutzung if {
	p := {"land_use": "grassland", "ebw": {"projekt_bestaetigt": true, "referenz_ha": 2, "schnittzeitpunktauflage": true, "zustand_anrechenbar": true, "codes": ["EBW", "DIVSZ"], "div_lebensraum": "Trockenrasen", "schlagnutzung": "Einmähdige Wiese"}}
	ebw.div_anrechenbar(p) with input.farm.ebw.massnahmen as ["1B", "19"]
	not ebw.div_anrechenbar(object.union(p, {"ebw": {"schlagnutzung": "Mähwiese/-weide zwei Nutzungen"}})) with input.farm.ebw.massnahmen as ["1B", "19"]
	not ebw.div_anrechenbar(p) with input.farm.ebw.massnahmen as ["19"]
}

test_feldstueck_anwendungsgrenze if {
	ebw.feldstueck_soll_ha({"art": "Mähgrünland", "massgebliche_ha": 5.01}) == 0.15 with input.farm.ebw.massnahmen as ["1A"] with input.land.maehgruenland_ohne_bergmaehder_ha as 10
	not ebw.feldstueck_soll_ha({"art": "Mähgrünland", "massgebliche_ha": 5}) with input.farm.ebw.massnahmen as ["1A"] with input.land.maehgruenland_ohne_bergmaehder_ha as 10
}

test_gloez_antragsjahr_und_ueberlappung if {
	p := {"land_use": "arable", "area_ha": 3, "ebw": {"referenz_ha": 2.5, "codes": ["EBW", "NPF"], "schlagnutzung": "Grünbrache", "gloez4_ha": 0.2, "gloez8_ha": 1, "gloez4_8_ueberlappung_ha": 0.1}}
	ebw.gloez8_anrechenbar(p) with input.farm.year as 2024
	not ebw.gloez8_anrechenbar(p) with input.farm.year as 2025
	ebw.gloez_bereinigte_ha(p) == 1.4 with input.farm.year as 2024
	ebw.gloez_bereinigte_ha(p) == 2.3 with input.farm.year as 2025
}

test_vernetzung_person_und_frist if {
	t := {"datum": "2026-12-31", "austritt": null, "regionales_vernetzungstreffen": true, "betriebsleitung": false, "betriebliche_erfordernisse": true, "massgeblich_taetig": true, "in_bewirtschaftung": true, "anzahl_betriebe": 1, "anzahl_verpflichtungen": 1}
	ebw.treffen_anrechenbar(t)
	not ebw.treffen_anrechenbar(object.union(t, {"datum": "2027-01-01"}))
	not ebw.treffen_anrechenbar(object.union(t, {"austritt": "2026-12-30"}))
	not ebw.treffen_anrechenbar(object.union(t, {"anzahl_verpflichtungen": 2}))
}

test_kombination_einzelflaeche if {
	ebw.einzelflaeche_kombinierbar("23", "Flächenprämie")
	ebw.einzelflaeche_kombinierbar("1A", "punktförmiges Landschaftselement")
	not ebw.einzelflaeche_kombinierbar("1A", "Flächenprämie")
	not ebw.einzelflaeche_kombinierbar("18", "Flächenprämie")
	not ebw.einzelflaeche_kombinierbar("24", "Flächenprämie")
}

test_kombinationsmatrix_anhang_l if {
	zeilen := data.ebw_tabellen.kombinationsmatrix
	massnahmen := {"1A", "1B", "1C", "2", "3", "4", "6", "7", "8", "9", "10", "11", "12", "13", "14", "16", "17", "18", "19", "23", "24"}
	count(zeilen) == count(massnahmen)
	{zeile.massnahme | some zeile in zeilen} == massnahmen
	every zeile in zeilen {
		object.keys(zeile.kombinationen) == massnahmen
	}
	{m: wert | some m, wert in ebw.ebw_kombinationen; wert != ""} == {"1A": "x1)", "1B": "x1)", "23": "x"}
	ebw.kombinationshinweis("1B") == data.ebw_tabellen.kombinationslegende["1"]
}

test_uebernahme_option if {
	t := {"art": "Regionaler Naturschutzplan", "struktur": "Betriebsteilung", "datum": "2028-04-17", "bisher_teilnahme": false, "online_mfa": true, "ama_genehmigt": true, "uebernommen_ha": 2, "ausweitung_ha": 1}
	ebw.uebernahme_moeglich(t) with input.farm.year as 2028
	not ebw.uebernahme_moeglich(object.union(t, {"ausweitung_ha": 1.01})) with input.farm.year as 2028
	not ebw.uebernahme_moeglich(object.union(t, {"struktur": "Pacht"})) with input.farm.year as 2028
}

test_abgang_gesamte_differenz if {
	ebw.rueckzahlung_flaeche_ha == 0.51 with input.farm.ebw as {"vorjahr_ha": 4, "abgang_ohne_ausnahme_ha": 0.51}
	ebw.rueckzahlung_flaeche_ha == 0 with input.farm.ebw as {"vorjahr_ha": 4, "abgang_ohne_ausnahme_ha": 0.5}
	ebw.abgang_toleranz_ha == 5 with input.farm.ebw.vorjahr_ha as 300
}

test_zugang_kumulativ if {
	ebw.zugang_foerderbar_ha == 4 with input.farm as {"year": 2027, "ebw": {"basis_2025_ha": 20, "bereits_genutzter_zugang_ha": 8, "neuzugang_ha": 6, "vorbelegter_zugang_ha": 2}}
	ebw.zugang_foerderbar_ha == 8 with input.farm as {"year": 2025, "ebw": {"neuzugang_ha": 6, "vorbelegter_zugang_ha": 2}}
}

test_duerre_schlaglage_und_kultur if {
	p := {"land_use": "arable", "ebw": {"bundesland": "Steiermark", "bezirk": "Weiz", "spaetsommer_herbsternte": true, "hitze_und_duerreempfindlich": true, "duerrebedingt_kein_erntbarer_bestand": true}}
	ebw.ernteanteil_erfuellt(p) with input.farm.year as 2026
	not ebw.duerre_erntebefreiung(p) with input.farm.year as 2025
	not ebw.duerre_erntebefreiung(object.union(p, {"ebw": {"bezirk": "Liezen"}})) with input.farm.year as 2026
	not ebw.duerre_erntebefreiung(object.union(p, {"ebw": {"spaetsommer_herbsternte": false}})) with input.farm.year as 2026
}

test_deckel_modulation_sanktion if {
	ebw.gedeckelt_eur_ha(1570) == 1500 with input.farm.year as 2024
	ebw.gedeckelt_eur_ha(1570) == 1300 with input.farm.year as 2023
	ebw.modulationsfaktor == 218 / 220 with input.land.heimflaeche_ha as 220
	ebw.sanktionsfolge("Verwarnung", 0, 2027).kuerzung_prozent == 1
	ebw.sanktionsfolge(100, 2, 2025).folge == "Ausschluss und Rückforderung seit Vertragsbeginn"
}

test_braunkehlchen_varianten if {
	a := [r | some r in data.ebw_tabellen.indikatoren; r.gruppe == "Braunkehlchen Variante A"; r.code == "EBGT17"][0]
	b := [r | some r in data.ebw_tabellen.indikatoren; r.gruppe == "Braunkehlchen Variante B"; r.code == "EBGT17"][0]
	i := {"messungen": {"groesster_sitzwartenabstand_im_altgras_m": 50, "sitzwarten_im_altgras": 2}, "parameter": {"$1": 3}}
	ebw.befund(a, i) == "erfüllt"
	ebw.befund(b, i) == "verfehlt"
}

test_unbekannte_art_oder_fehlender_termin if {
	r := [v | some v in data.ebw_tabellen.indikatoren; v.code == "EBAT04"][0]
	i := {"messungen": {"brutstoerende_vorgaenge_im_projektzeitraum": 0}}
	ebw.befund(r, i) == "offen"
	ebw.befund(r, object.union(i, {"parameter": {"$1": "2026-05-10", "$2": "2026-06-20"}})) == "erfüllt"
}

test_ebw_dritte_nutzung_nur_projektkonform if {
	p := {"land_use": "arable", "ebw": {"codes": ["EBW", "DIV", "OPUBB"], "nutzungen_im_jahr": 3, "nutzung_gemaess_projekt": true}}
	ebw.duerre_div_nutzung(p) with input.farm as {"year": 2026, "ebw": {"massnahmen": ["1A", "19"]}}
	not ebw.duerre_div_nutzung(object.union(p, {"ebw": {"nutzung_gemaess_projekt": false}})) with input.farm as {"year": 2026, "ebw": {"massnahmen": ["1A", "19"]}}
	not ebw.duerre_div_nutzung(p) with input.farm as {"year": 2025, "ebw": {"massnahmen": ["1A", "19"]}}
}

test_plan_jaehrlich_nur_einmal if {
	p := {"year": 2027, "ebw": {"massnahmen": ["18", "19"], "plan_vorjahr": true, "plan_abgemeldet": false, "plan_bestaetigt": true, "projektbestaetigung": true, "plan_auflagen_erfuellt": true}}
	ebw.plan_satz == 270 with input.farm as p
	not ebw.plan_satz with input.farm as object.union(p, {"ebw": {"plan_bestaetigt": false}})
}

test_gesamtbetrag_und_offene_vergabe if {
	p := {"area_ha": 0.3, "land_use": "grassland", "ebw": {"projekt_bestaetigt": true, "codes": ["EBW"], "referenz_ha": 0.3, "praemientyp": "Frische Magerwiese", "tarifgruppe": "Wiese", "zustand": "A", "erschwernis": "leicht", "aufwand_grund": "Kleinflächigkeit", "aufwand_bestaetigt": true, "aufwand_code": "EBBA02", "habitatzuschlag_bestaetigt": false}}
	ebw.projektpraemie_eur_ha(p) == 1015.2 with input.farm.year as 2025
	not ebw.projektpraemie_eur_ha(object.union(p, {"ebw": {"aufwand_grund": "Unbekannt"}})) with input.farm.year as 2025
}

test_verstoss_von_offenem_nachweis_unterscheiden if {
	count(ebw.verstoesse) == 0 with input as {}
	ebw.verstoesse == {{"regel": "o6_19.minimum_folgejahr"}} with input.farm as {"year": 2026, "ebw": {"erstjahr": 2025, "bewirtschaftete_schlaege": 0}}
	ebw.weiterbildungsstand == "fachlich zu klären" with input.documentation.ebw as {"treffen": [{"austritt": "2026-12-31"}], "stichtag": "2027-01-01", "nachweise_vollstaendig": true}
}

test_oeffentlicher_einfluss if {
	a := {"form": "Juristische Person", "gebietseinrichtung": false, "gleichwertiger_oeffentlicher_einfluss": false, "oeffentlich_prozent": 25}
	ebw.rechtsform_zulaessig with input.farm.antragsteller as a
	not ebw.rechtsform_zulaessig with input.farm.antragsteller as object.union(a, {"gleichwertiger_oeffentlicher_einfluss": true})
	not ebw.rechtsform_zulaessig with input.farm.antragsteller as object.union(a, {"oeffentlich_prozent": 25.1})
}
