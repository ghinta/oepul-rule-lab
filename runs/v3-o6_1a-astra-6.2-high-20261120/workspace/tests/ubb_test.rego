package oepul.o6_1a_test

import data.oepul.o6_1a as u
import data.ubb_tabellen as t
import rego.v1

test_vertrag_und_option if {
	u.vertragsjahre(2023) == 6
	u.vertragsjahre(2025) == 4
	not u.vertragsjahre(2026)
	u.antragsfrist_ok(2025, "2024-12-31")
	not u.antragsfrist_ok(2025, "2025-01-01")
	u.wechselziel("UBB", "BIO", 2025)
	not u.wechselziel("BIO", "UBB", 2025)
}

test_betriebsmindestgroesse if {
	u.mindestgroesse_ok(1, 0.5, 0.5)
	u.mindestgroesse_ok(1, 0, 1.5)
	not u.mindestgroesse_ok(1, 0.49, 1.49)
	u.mindestgroesse_ok(2, 0, 0.2)
}

test_div_schwelle_und_ersatz if {
	u.anteil_soll(2) == 0
	u.anteil_soll(2.01) == 0.1407
	b := u.div_bilanz with input.land as {"arable_area_ha": 9, "maehgruenland_ohne_bergmaehder_ha": 5, "div_anrechenbar": {"acker_ha": 0.25, "gruenland_ha": 0.8}}
	b.gruenland_erfuellt
	b.acker_erfuellt_merkblatt
	b.klaerung_10_ha == false
}

test_zehn_hektar_beide_lesarten if {
	b := u.div_bilanz with input.land as {"arable_area_ha": 10, "maehgruenland_ohne_bergmaehder_ha": 5, "div_anrechenbar": {"acker_ha": 0, "gruenland_ha": 1.05}}
	b.acker_erfuellt_richtlinie
	b.acker_erfuellt_merkblatt == false
	b.klaerung_10_ha
}

test_gruenlandbedarf_nicht_doppelt_anrechnen if {
	b := u.div_bilanz with input.land as {"arable_area_ha": 9, "maehgruenland_ohne_bergmaehder_ha": 5, "div_anrechenbar": {"acker_ha": 0, "gruenland_ha": 0.97}}
	b.gruenland_erfuellt
	b.acker_erfuellt_merkblatt == false
}

test_feldstueck_und_betrieb_getrennt if {
	f := {"id": "F1", "nutzung": "Acker", "massgebliche_ha": 6, "div_ha": 0.04, "zugeordnete_gloez_lse_ha": 0.1, "zugeordnete_1c_agroforst_ha": 0.01}
	land := {"arable_area_ha": 10, "feldstuecke": [f], "div_anrechenbar": {"acker_ha": 0.04, "gruenland_ha": 0}, "maehgruenland_ohne_bergmaehder_ha": 0}
	jahr25 := u.feldbilanzen with input as {"farm": {"year": 2025}, "land": land}
	jahr24 := u.feldbilanzen with input as {"farm": {"year": 2024}, "land": land}
	jahr25.F1.erfuellt
	jahr24.F1.erfuellt == false
	b := u.div_bilanz with input.land as land
	b.acker_erfuellt_richtlinie == false
}

test_feldgrenze_azr if {
	f := {"nutzung": "Acker", "massgebliche_ha": 5.01, "gebeizte_rueben_2022": true, "andere_kulturen_2022_ha": 0.149, "alle_folgeschlaege_azr": true}
	u.feld_grenze(f, 2023) == 0 with input.land.arable_area_ha as 10
	u.feld_grenze(f, 2024) == 0.15 with input.land.arable_area_ha as 10
	u.feld_grenze(object.union(f, {"andere_kulturen_2022_ha": 0.15}), 2023) == 0.15 with input.land.arable_area_ha as 10
}

test_kulturanteile if {
	zeilen := [{"erstkultur": "Weizen", "botanische_art": "Weizen", "getreideanteil_prozent": 100, "ha": 5.5}, {"erstkultur": "Mais", "botanische_art": "Mais", "getreideanteil_prozent": 0, "ha": 2}, {"erstkultur": "Klee", "botanische_art": "Klee", "getreideanteil_prozent": 0, "ha": 2.5}]
	b := u.diversifizierung with input as {"land": {"arable_area_ha": 10, "hauptkulturen": zeilen}, "farm": {"year": 2026}}
	b.getreide_mais_ok
	count(b.ueber_55_prozent) == 0
	not u.getreide_oder_mais({"erstkultur": "Erbsen", "getreideanteil_prozent": 49.9})
	u.ausgenommene_kultur("Spargel", 2025)
	not u.ausgenommene_kultur("Spargel", 2024)
}

test_rgve_zeitanteile if {
	b := {"land": {"grassland_area_ha": 3, "ackerfutter_ha": 1}, "livestock": {"rgve_bestand_inland": [{"kategorie": "Rinder ab 2 Jahre", "jahresrelevante_stueck": 0.9}, {"kategorie": "Rinder ½ bis unter 2 Jahre", "jahresrelevante_stueck": 0.5}]}}
	u.rgve_bestand == 1.2 with input as b
	u.tierhaltend with input as b
	not u.rgve_bestand with input.livestock.rgve_bestand_inland as [{"kategorie": "unbekannt", "jahresrelevante_stueck": 1}]
}

test_bindung_und_zugang if {
	u.abgangstoleranz(5) == 0.5
	u.rueckzahlflaeche(20, 1.01) == 1.01
	u.abgangstoleranz(200) == 5
	u.zugang_praemienfaehig(2026, 6, 8) == 5
	u.zugang_praemienfaehig(2025, 6, 8) == 8
}

test_praemienuebergaenge if {
	u.praemiensatz("acker_basis", 2023) == 70
	u.praemiensatz("acker_basis", 2024) == 75.6
	u.praemiensatz("acker_basis", 2025) == 85
	not u.praemiensatz("pheromonfallen", 2024)
	u.praemiensatz("pheromonfallen", 2026) == 150
	u.praemiensatz("acker_divrs_brache", 2026) == 324
	u.praemiensatz("gruen_basis_tierhaltend", 2026) == 75.6
}

test_mehrflaeche_deckel if {
	u.mehr_div_ha(100, 7) == 0
	u.mehr_div_ha(100, 25) == 13
	u.mehr_div_ha(100, 8) == 1
	not u.verteilungszuschlag_ok(6.01, [0.1, 0.1, 0.05])
	u.verteilungszuschlag_ok(6.01, [0.1, 0.1, 0.051])
}

test_foerderkulturen_beispiel_1836 if {
	s := [{"ha": 5, "gruppen": ["leguminosen", "feldfutter"]}, {"ha": 10, "gruppen": ["sonnenblume"]}, {"ha": 10, "gruppen": ["feldfutter"]}]
	u.kulturzuschlag_eur == 1836 with input as {"land": {"arable_area_ha": 50, "div_anrechenbar": {"acker_ha": 0}, "foerderkulturschlaege": s}, "farm": {"year": 2026}}
	not u.flaechenanteil_foerderkulturen_ok(100, 10, 12)
	u.flaechenanteil_foerderkulturen_ok(100, 10, 13)
}

test_modulation_stufen if {
	abs(u.modulationsfaktor(220) - (218 / 220)) < 0.00000001
	u.modulationsfaktor(200) == 1
	u.obergrenze("allgemein", 2025).ausgenommen == ["6", "7", "1C"]
	u.kuerzung("Verwarnungsstufe", 2027) == 1
}

test_matrix_und_projektvorrang if {
	count(t.kombinationsmatrix) == 441
	u.kombinationszelle("1A", "18") == "x1)"
	u.kombinationszelle("1A", "16") == "x"
	u.kombinationszelle("1A", "1B") == ""
	u.projektkombination("T", "S") == "nein"
	u.projektkombination("G", "L") == "ja"
	u.monitoring_kombination_ok("schnittzeit", true, ["GL15"])
	not u.monitoring_kombination_ok("schnittzeit", true, ["GL14"])
}

test_duerre_schlagbezirk if {
	p := {"land_use": "arable", "mfa": {"bundesland": "Steiermark", "bezirk": "Weiz"}, "ernte": {"spaetsommer_herbst": true, "besonders_hitzeempfindlich": true, "duerrebedingt_kein_erntbarer_bestand": true}}
	u.automatische_ernteausnahme(p, 2026)
	not u.automatische_ernteausnahme(p, 2025)
	not u.duerregebiet("Steiermark", "Liezen")
	u.duerregebiet("Wien", "Donaustadt")
	not u.automatische_ernteausnahme(object.union(p, {"ernte": {"spaetsommer_herbst": false}}), 2026)
}

parzelle(codes) := {"land_use": "arable", "mfa": {"codes": codes, "weitere_nutzungsvorgaben": false}}

test_acker_duerre_code if {
	u.fruehe_acker_nutzung(parzelle(["DIV"]), 2026, "Mahd", 0.5, 2)
	not u.fruehe_acker_nutzung(parzelle(["DIV"]), 2026, "Weide", 0.1, 2)
	u.fruehe_acker_nutzung(parzelle(["DIV", "OPUBB"]), 2026, "Weide", 0.1, 2)
	not u.dritte_nutzung(parzelle(["DIV", "OPBIO"]), 2026)
	u.dritte_nutzung(parzelle(["DIV", "OPUBB"]), 2026)
	not u.dritte_nutzung(parzelle(["DIV", "OPUBB", "NAT"]), 2026)
	not u.dritte_nutzung(parzelle(["DIV", "OPUBB"]), 2025)
}

wiese(codes) := object.union(parzelle(codes), {"land_use": "grassland"})

test_nfz_volle_kalendertage if {
	p := wiese(["DIVNFZ"])
	not u.nfz_folge_ok(p, 2026, "2026-06-24", "2026-08-26")
	u.nfz_folge_ok(p, 2026, "2026-06-24", "2026-08-27")
	u.nfz_folge_ok(wiese(["DIVNFZ", "OPUBB"]), 2026, "2026-06-24", "2026-08-13")
	not u.nfz_folge_ok(wiese(["DIVNFZ", "OPUBB"]), 2026, "2026-06-24", "2026-08-12")
}

test_sz_vergleich_unabhaengiger_julitermin if {
	u.sz_regulaer(2025, 0, false, null, "2025-07-15")
	not u.sz_regulaer(2025, 0, false, null, "2025-07-14")
	u.sz_regulaer(2025, 0, true, null, "2025-06-15")
	u.sz_duerre(wiese(["DIVSZ", "OPUBB"]), 2026, 7, "2026-05-25", "2026-05-25")
	not u.sz_duerre(wiese(["DIVSZ", "OPUBB"]), 2026, 7, "2026-05-26", "2026-05-25")
}

test_variantenwechsel_frist if {
	u.variantenwechsel("DIVSZ", "DIVNFZ", "2026-06-15")
	not u.variantenwechsel("DIVSZ", "DIVNFZ", "2026-06-16")
	u.variantenwechsel("DIVNFZ", "DIVAGF", "2026-08-15")
	not u.variantenwechsel("DIVNFZ", "DIVSZ", "2026-04-16")
}

test_umbruch_und_problempflanzen if {
	u.umbruch_ab(2025, true) == u.tag("2026-08-01")
	u.umbruch_ab(2025, false) == u.tag("2026-09-15")
	not u.problemmahd_ok(1, 4, "Ragweed", true)
	u.problemmahd_ok(1.01, 4, "Ragweed", true)
}

test_artenlisten_sortenstufen if {
	count(t.slk_sorten) == 85
	count(t.arten_acker) == 74
	count(t.arten_gruenland) == 68
	u.listenart("grassland", "Spitz-Wegerich").familie == "Wegerichgewächse"
	not u.listenart("arable", "Spitz-Wegerich")
	u.slk_stufe("Sonnenblume (Helianthus annuus L.)", "Soblus", 2025) == "A"
	not u.slk_stufe("Sonnenblume (Helianthus annuus L.)", "Soblus", 2024)
}

test_regionalmischung if {
	arten := array.slice(t.arten_acker, 0, 40)
	partner := [{"art": a.deutsch, "gewichtsprozent": 2.5, "regional_belegt": true, "oekotyp_zertifiziert": false} | some a in arten]
	mix := {"kg_ha": 20, "etiketten": true, "bezugsrechnungen": true, "partner": partner}
	u.regionalmischung_ok("arable", mix)
	not u.regionalmischung_ok("arable", object.union(mix, {"kg_ha": 19.9}))
	not u.rs_standort_ok(30, 18)
	u.rs_standort_ok(30, 17.99)
}

test_zaehlung_reinigung_je_variante if {
	e := {"art": "Reinigungsschnitt", "abtransport": false, "datum": "2026-05-22"}
	p := {"land_use": "arable", "div": {"neuansaat_erstes_antragsjahr": true, "zaehlbare_pflege_vorjahr": 0}, "mfa": {"nutzungsart": "Grünbrache", "codes": ["DIVRS"]}, "operations": {"nutzungen": [e]}}
	u.rs_brache_pflege_ok(p, 2026)
	not u.rs_brache_pflege_ok(object.union(p, {"operations": {"nutzungen": [e, {"art": "Häckseln", "datum": "2026-10-01"}]}}), 2026)
	u.acker_pflegeanzahl(p, 2026) == 0
}

test_fallen_zeitplan if {
	f := {"folgekultur": false, "bezugsdatum": "2026-04-01", "anlage": "2026-04-15", "entfernung": "2026-05-20", "ernte": "2026-10-01", "anzahl": 15, "leerungen": ["2026-04-25", "2026-05-12"]}
	u.fallen_zeitplan_ok({"area_ha": 1, "pheromonfallen": f})
	not u.fallen_zeitplan_ok({"area_ha": 1.01, "pheromonfallen": f})
	not u.fallen_zeitplan_ok({"area_ha": 1, "pheromonfallen": object.union(f, {"entfernung": "2026-05-19"})})
}

test_fehlende_eingaben if {
	not u.div_bilanz with input as {}
	not u.tierhaltend with input as {}
	not u.kulturzuschlag_eur with input as {}
}

test_lse_und_streuobst if {
	e := {"art": "Baum", "verfuegungsgewalt": true, "beantragt": true, "ganzjaehrig_erhalten": true, "gloez": false, "alm_oder_hutweide": false, "abstand_lf_m": 5, "kronendurchmesser_m": 2, "flaeche_m2": 100, "abstand_naechstes_element_m": 5, "obstart": "Pfirsich", "starkwuechsig": true, "grosskronig": true, "stamm": "Halbstamm", "baumuebergreifendes_stuetzgeruest": false, "wildform": false}
	u.streuobst_ok(e, 2025)
	not u.streuobst_ok(e, 2024)
	not u.lse_punkt_ok(object.union(e, {"abstand_naechstes_element_m": 4.99}))
	u.punktfoerderzahl(81, 1) == 80
}

test_schulung_personengebunden if {
	k := {"anerkannter_anbieter": true, "biodiversitaet": true, "datum": "2022-01-01", "anderweitig_angerechnet": false, "stunden": 3, "veranstaltung_id": "K1"}
	person := {"betriebsrolle": "Betriebsleitung", "austritt": null, "kurse": [k]}
	u.bildung_erfuellt with input.documentation.biodiversitaetsschulung as [person]
	not u.geschulte_person_ok(object.union(person, {"austritt": "2025-12-30"}))
	not u.geschulte_person_ok(object.union(person, {"kurse": [object.union(k, {"anderweitig_angerechnet": true})]}))
}

test_gewichteter_mittelwert if {
	teile := [{"ha": 0.25, "zahl": 80}, {"ha": 0.75, "zahl": 40}]
	u.bodenzahl(teile) == 50
	u.bodenzuschlag_ok("arable", teile)
	not u.bodenzuschlag_ok("arable", [{"ha": 1, "zahl": 49.9}])
}

test_projektcodes if {
	nat := {"land_use": "grassland", "mfa": {"codes": ["NAT", "DIVSZ"], "projektauflagen": ["GL25"]}}
	u.div_projekt_gruen_ok(nat)
	not u.div_projekt_gruen_ok({"land_use": "grassland", "mfa": {"codes": ["NAT", "DIVSZ"], "projektauflagen": ["GL26"]}})
	not u.div_projekt_gruen_ok({"land_use": "grassland", "mfa": {"codes": ["NAT"], "projektauflagen": ["GL25"]}})
}

test_schutz_bei_erosionskulturen if {
	p := {"land_use": "arable", "crop": {"crop_name": "Mais"}, "area_ha": 0.51, "mfa": {"ueberwiegende_hangneigung_prozent": 10}, "erosion": {"massnahme_8": true, "anerkanntes_verfahren": true, "art": "Direktsaat", "begruenungsmassnahme": "keine"}}
	u.ackerbasis_erosion_gesperrt(p)
	not u.ackerbasis_erosion_gesperrt(object.union(p, {"area_ha": 0.5}))
	not u.ackerbasis_erosion_gesperrt(object.union(p, {"erosion": object.union(p.erosion, {"begruenungsmassnahme": "7"})}))
}

test_agf_letzte_nutzung if {
	p := {"land_use": "grassland", "mfa": {"codes": ["DIVAGF"]}, "div": {"altgras_ueber_winter": true}, "operations": {"nutzungen": [{"art": "Mahd", "datum": "2026-08-15", "abtransport": true}]}}
	u.agf_jahresnutzung_ok(p, 2026)
	not u.agf_jahresnutzung_ok(object.union(p, {"operations": {"nutzungen": [{"art": "Mahd", "datum": "2026-08-16", "abtransport": true}]}}), 2026)
}

test_projektfreigabe_ohne_praemienverzicht if {
	nat := {"mfa": {"codes": ["NAT", "DIVSZ"], "nutzungstermin_festgelegt": true}}
	u.nat_terminfreigabe(nat, 2026, "2026-08-12")
	not u.nat_terminfreigabe(nat, 2026, "2026-08-11")
	u.entgelt_bei_op(nat, 180) == 180
	u.entgelt_bei_op(parzelle(["OPUBB"]), 180) == 0
}

test_uebernahme_und_sorten if {
	u.uebernahmeantrag_ok(2028, "2028-04-17", 10, 5)
	not u.uebernahmeantrag_ok(2026, "2026-04-16", 10, 5)
	not u.uebernahmeantrag_ok(2026, "2026-04-15", 10, 5.01)
	u.slk_gruppenstufe("Einkorn (Triticum monococcum) und Emmer (Triticum dicoccum)", "Emmer", 2026) == "A"
}
