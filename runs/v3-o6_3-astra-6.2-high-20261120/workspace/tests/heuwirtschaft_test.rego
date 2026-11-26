package oepul.o6_3_test

import data.oepul.o6_3 as heu
import rego.v1

mfa := {
	"in_at": true, "beantragt": true, "schlagnutzung": "Mähwiese", "zweitkultur": false,
	"heuwirtschaft_beantragt": true, "referenz_korrekt": true, "allgemein_praemienfaehig": true,
	"codes": [], "op_heuwirtschaft": false, "andere_schlagpraemien": ["1A"], "nationalpark": null,
	"relevante_parkauflagen": false, "neuzugang_seit_2025": false,
}

parzelle(id, ha, nutzung, kultur, m) := {
	"parcel_id": id, "area_ha": ha, "land_use": nutzung, "crop": {"crop_name": kultur},
	"operations": {"cutting_dates": ["2024-06-01", "2025-06-01", "2026-06-01"]},
	"constraints": {"is_contract_nature_area": false}, "mfa": object.union(mfa, m),
}

wiese := parzelle("W", 8, "grassland", "Gras", {})
weide := parzelle("D", 2, "grassland", "Gras", {"schlagnutzung": "Dauerweide"})
klee := parzelle("K", 3, "arable", "Klee", {"schlagnutzung": "Klee"})
rind := {"art": "rind", "rasse": "Fleckvieh", "alter_jahre": 3, "in_at": true, "jahresmittel_rinderdatenbank": 5}
betrieb := {
	"farm": {"year": 2024, "heuwirtschaft": {
		"vertragsbeginn": 2024, "erstes_teilnahmejahr": 2024, "antragsdatum": "2023-12-31",
		"parallele_massnahmen": ["1A"], "option_kreuz": false, "gruenland_2025_ha": 8,
	}},
	"livestock": {"species_groups": [{"rgve_angaben": rind}]},
	"land": {"parcels": [wiese, weide, klee]},
}

test_ama_rechenbeispiel if {
	b := heu.pruefung with input as betrieb
	b.massnahmenspezifischer_jahreszugang == "erfüllt"
	b.kennzahlen.einstiegsflaeche_ha == 8
	b.kennzahlen.futter_ha == 13
	b.kennzahlen.rgve == 5
	b.kennzahlen.praemienflaeche_ha == 11
	b.kennzahlen.satz_eur_ha == 145.8
	b.kennzahlen.flaechenbetrag_eur == 1603.8
}

test_nat_zaehlt_zum_einstieg_und_besatz if {
	n := object.union(wiese, {"area_ha": 2, "constraints": {"is_contract_nature_area": true}})
	f := heu.pruefung with input as betrieb with input.land.parcels as [n]
	f.kennzahlen.einstiegsflaeche_ha == 2
	f.kennzahlen.futter_ha == 2
	f.kennzahlen.praemienflaeche_ha == 0
	f.massnahmenspezifischer_jahreszugang == "erfüllt"
}

test_ungemaehte_und_ausgeschlossene_flaechen if {
	f := [
		parzelle("s", 2, "grassland", "Gras", {"schlagnutzung": "Streuwiese"}),
		parzelle("b", 1, "grassland", "Gras", {"schlagnutzung": "Bergmähder"}),
		parzelle("a", 3, "arable", "Ackerweide", {}),
		parzelle("z", 7, "arable", "Klee", {"zweitkultur": true}),
		parzelle("x", 9, "grassland", "Gras", {"in_at": false}),
		parzelle("u", 5, "grassland", "Gras", {"beantragt": false}),
	]
	b := heu.pruefung with input as betrieb with input.land.parcels as f
	b.kennzahlen.futter_ha == 6
	b.kennzahlen.einstiegsflaeche_ha == 0
	b.kennzahlen.praemienflaeche_ha == 0
	"o6_3.einstieg.flaeche" in b.zugangsprobleme
}

test_dichte_grenzwert if {
	f := [parzelle("w", 10, "grassland", "Gras", {})]
	h := heu.pruefung with input as betrieb with input.land.parcels as f with input.livestock.species_groups as [{"rgve_angaben": object.union(rind, {"jahresmittel_rinderdatenbank": 3})}]
	h.kennzahlen.tierhaltend == true
	tief := heu.pruefung with input as betrieb with input.land.parcels as f with input.livestock.species_groups as [{"rgve_angaben": object.union(rind, {"jahresmittel_rinderdatenbank": 2.999})}]
	tief.massnahmenspezifischer_jahreszugang == "Voraussetzung verfehlt"
}

test_folgejahr_unter_zwei_ha_und_unter_besatz if {
	p := parzelle("w", 1, "grassland", "Gras", {})
	wert := heu.pruefung with input as betrieb with input.farm.year as 2025 with input.land.parcels as [p] with input.livestock.species_groups as [] with input.farm.heuverfahren.silage_bereitet as true
	wert.kennzahlen.flaechenbetrag_eur == 0
	wert.massnahmenspezifischer_jahreszugang == "erfüllt"
	"o6_3.silage.bereitung" in wert.festgestellte_bewirtschaftungsverstoesse
}

test_tarife_option_aktuell_und_historisch if {
	heu.satz_eur_ha == 167.4 with input as betrieb with input.farm.heuwirtschaft.option_kreuz as true
	alt := object.union(betrieb, {"farm": {"year": 2023, "heuwirtschaft": {"vertragsbeginn": 2023, "erstes_teilnahmejahr": 2023}}})
	heu.satz_eur_ha == 135 with input as alt
	heu.satz_eur_ha == 155 with input as alt with input.farm.heuwirtschaft.option_kreuz as true
}

test_antrag_stichtage if {
	heu.neuantrag_fristgerecht with input as betrieb
	not heu.neuantrag_fristgerecht with input as betrieb with input.farm.heuwirtschaft.antragsdatum as "2024-01-01"
	not heu.neuantrag_fristgerecht with input as betrieb with input.farm.heuwirtschaft.vertragsbeginn as 2026
	heu.option_beantragt with input as betrieb with input.farm.year as 2028 with input.farm.heuwirtschaft.option_kreuz as true
	not heu.option_beantragt with input as betrieb with input.farm.year as 2029 with input.farm.heuwirtschaft.option_kreuz as true
}

test_kombinationspartner if {
	every m in ["1A", "1B", "BIO-Teilbetrieb"] { heu.kombination_erfuellt with input.farm.heuwirtschaft.parallele_massnahmen as [m] }
	b := heu.pruefung with input as betrieb with input.farm.heuwirtschaft.parallele_massnahmen as []
	b.zugangsprobleme == {"o6_3.kombination"}
}

test_leere_oder_fehlende_bestaende if {
	b := heu.pruefung with input as {}
	b.massnahmenspezifischer_jahreszugang == "Angaben fehlen"
	not b.kennzahlen.flaechenbetrag_eur
	not heu.rgve with input.livestock.species_groups as [{"rgve_angaben": rind}, {}]
	not heu.tierhaltend with input as betrieb with input.land.parcels as []
}

test_zwerggrenzen if {
	heu.rgve_faktor(object.union(rind, {"rasse": "Kerry", "alter_jahre": 0.49})) == 0.2
	heu.rgve_faktor(object.union(rind, {"rasse": "Dexter", "alter_jahre": 0.5})) == 0.3
	heu.rgve_faktor(object.union(rind, {"rasse": "Dahomey", "alter_jahre": 2})) == 0.5
	heu.rgve_faktor(object.union(rind, {"alter_jahre": 0.5})) == 0.6
}

test_equiden_eine_grenze_genuegt if {
	p := {"art": "equide", "alter_jahre": 3, "widerristhoehe_m": 1.48, "endgewicht_kg": 300}
	heu.rgve_faktor(p) == 0.5
	heu.rgve_faktor(object.union(p, {"endgewicht_kg": 301})) == 1
	heu.rgve_faktor(object.union(p, {"widerristhoehe_m": 1.49, "alter_jahre": 0.5})) == 0.6
}

test_wild_und_sonstige_tiere if {
	p := {"art": "rotwild", "wildhaltung_auf_lf": true, "alter_jahre": 1}
	heu.rgve_faktor(p) == 0.25
	heu.rgve_faktor(object.union(p, {"art": "zuchtwild"})) == 0.15
	heu.rgve_faktor(object.union(p, {"art": "neuweltkamel", "alter_jahre": 0.9})) == 0.07
	heu.gruppen_rgve({"art": "zuchtwild", "wildhaltung_auf_lf": false}) == 0
	heu.gruppen_rgve({"art": "kein_rgve"}) == 0
}

test_bestandsquellen if {
	ziege := {"art": "ziege", "in_at": true, "alter_jahre": 1, "bestand_schwankt": false, "durchschnittsliste": null, "bestand_1_april": 2}
	heu.gruppen_rgve(ziege) == 0.3
	heu.gruppen_rgve(object.union(ziege, {"bestand_schwankt": true, "durchschnittsliste": 2.5})) == 0.375
	not heu.gruppen_rgve(object.union(ziege, {"bestand_schwankt": true}))
	heu.gruppen_rgve(object.union(rind, {"in_at": false})) == 0
}

test_gruenfutter_tage_zaehlen_pro_gruppe if {
	start := time.parse_ns("2006-01-02", "2024-04-01")
	termine := [time.format([start + (i * 86400000000000), "UTC", "2006-01-02"]) | some i in numbers.range(0, 91)]
	g := {"ganze_periode_am_betrieb": true, "eingrasen": ["2024-03-31", termine[0]], "alm": termine, "weide": [], "gemeinschaftsweide": ["2024-10-01"]}
	heu.gruentage(g) == 92 with input as betrieb
	v := heu.verstoesse with input as betrieb with input.farm.heuverfahren.raufuttergruppen as [g]
	not "o6_3.gruenfuetterung" in v
	v2 := heu.verstoesse with input as betrieb with input.farm.heuverfahren.raufuttergruppen as [g, object.union(g, {"alm": array.slice(termine, 0, 91)})]
	"o6_3.gruenfuetterung" in v2
}

test_aufbereiter_auch_ungenutzt_und_fremdgeraet if {
	g := {"trocknungszweck": true, "wirkung": "knicken", "am_betrieb": true, "eingesetzt": false}
	v := heu.verstoesse with input as betrieb with input.farm.heuwirtschaft.option_kreuz as true with input.farm.heuverfahren.geraete as [g, object.union(g, {"eingesetzt": true, "am_betrieb": false})]
	v == {"o6_3.option.einsatz", "o6_3.option.besitz"}
	heu.verstoesse == set() with input as betrieb with input.farm.heuverfahren.geraete as [g]
}

test_silage_abgabe_und_lagerung if {
	facts := {"silage_verfuettert": true, "altvorrat_verbraucht": true, "folienbeduerftiges_gut_gepresst": true, "abgaben": [{"form": "Grünfutter"}], "heulage": true}
	v := heu.verstoesse with input as betrieb with input.farm.heuverfahren as facts
	v == {"o6_3.silage.fuetterung", "o6_3.lagerung", "o6_3.silage.pressen", "o6_3.abgabe", "o6_3.heulage"}
}

test_futtermittel_herstellung if {
	heu.produkt_erlaubt({"produkt": "Biertrebern", "siliert": false}) == false
	heu.produkt_erlaubt({"produkt": "Flüssigmelasse", "siliert": false})
	heu.produkt_erlaubt({"produkt": "unbekannt", "siliert": true}) == false
	v := {"art": "gehäckselter Grünmais trocknen und pelletieren", "rasche_verbringung": true, "eigenverwendung": true, "gaerung_ausgeschlossen": true}
	heu.gruenverfahren_erlaubt(v)
	not heu.gruenverfahren_erlaubt(object.union(v, {"rasche_verbringung": false}))
}

test_gebundener_zugang_und_acker if {
	alt := parzelle("v", 5, "grassland", "Gras", {"neuzugang_seit_2025": false})
	neu := parzelle("n", 9, "grassland", "Gras", {"neuzugang_seit_2025": true})
	heu.praemienflaeche_ha == 13 with input as betrieb with input.farm.year as 2026 with input.land.parcels as [alt, neu, klee]
	heu.praemienflaeche_ha == 17 with input as betrieb with input.farm.year as 2025 with input.land.parcels as [alt, neu, klee]
}

test_opbio_park_und_kombination if {
	fl := [parzelle("a", 1, "grassland", "Gras", {"codes": ["OPBIO"]}), parzelle("b", 2, "grassland", "Gras", {"codes": ["OP"]}), parzelle("c", 4, "grassland", "Gras", {"nationalpark": "Donau-Auen"}), parzelle("d", 8, "grassland", "Gras", {"andere_schlagpraemien": ["19"]})]
	heu.praemienflaeche_ha == 1 with input as betrieb with input.land.parcels as fl
	heu.futter_ha == 15 with input as betrieb with input.land.parcels as fl
}

test_kombifeld_heuwirtschaft_alle_spalten if {
	erlaubte := {m | some m, v in data.heutabellen.kombinationen["3"]; v == "x"}
	erlaubte == {"1A", "1B", "2", "6", "7", "9", "16", "17", "24"}
	heu.kombizelle("1A", "18") == "x 1)"
	heu.kombizelle("1B", "16") == "a"
	count(data.heutabellen.kombinationen["3"]) == 21
}

test_uebernahme_2028 if {
	u := {"mfa_datum": "2028-04-17", "vorher_teilgenommen": false, "ama_genehmigt": true, "zusatz_ha": 5, "uebernommen_ha": 10}
	heu.uebernahme_moeglich with input.farm.year as 2028 with input.farm.massnahmenuebernahme as u
	not heu.uebernahme_moeglich with input.farm.year as 2028 with input.farm.massnahmenuebernahme as object.union(u, {"zusatz_ha": 5.01})
	not heu.uebernahme_moeglich with input.farm.year as 2028 with input.farm.massnahmenuebernahme as object.union(u, {"mfa_datum": "2028-04-18"})
}

test_abgang_toleranz if {
	heu.abgang_toleranz_ha == 0.5 with input.farm.heuwirtschaft.vorjahr_gebunden_ha as 4
	heu.rueckzahlung_differenz_ha == 0 with input.farm.heuwirtschaft as {"vorjahr_gebunden_ha": 60, "relevanter_abgang_ha": 3}
	heu.rueckzahlung_differenz_ha == 5.01 with input.farm.heuwirtschaft as {"vorjahr_gebunden_ha": 200, "relevanter_abgang_ha": 5.01}
}

test_modulation_und_jahreswechsel if {
	round(10000 * heu.modulationsfaktor) == 9909 with input.farm.oepul_antrag.heimflaeche_ha as 220
	heu.obergrenze_eur_ha("allgemein", 2023) == 1200
	heu.obergrenze_eur_ha("18/19", 2026) == 1500
	heu.kuerzungsprozent == 0 with input.farm.year as 2026 with input.farm.oepul_antrag.kuerzungsstufe as "Verwarnung"
	heu.kuerzungsprozent == 1 with input.farm.year as 2027 with input.farm.oepul_antrag.kuerzungsstufe as "Verwarnung"
}

test_duerre_schlag_und_gebietserweiterung if {
	p := object.union(parzelle("p", 2, "arable", "Mais", {}), {"duerre": {"bundesland": "Steiermark", "bezirk": "Weiz", "spaetsommer_herbstkultur": true, "hitze_und_trockenheit": true, "erntbarer_bestand": false}})
	heu.ernteausnahme_2026(p) with input.farm.year as 2026
	not heu.ernteausnahme_2026(object.union(p, {"duerre": {"bezirk": "Liezen"}})) with input.farm.year as 2026
	not heu.ernteausnahme_2026(object.union(p, {"crop": {"crop_name": "Klee"}})) with input.farm.year as 2026
	not heu.ernteausnahme_2026(p) with input.farm.year as 2025
}

test_div_varianten if {
	heu.div_wechsel("DIVSZ", "DIVNFZ", "2026-06-15") with input.farm.year as 2026
	not heu.div_wechsel("DIVSZ", "DIVNFZ", "2026-06-16") with input.farm.year as 2026
	p := {"div_nutzung": {"variante": "DIVNFZ", "op_massnahme": "OPBIO", "andere_vorgaben": false, "trockenheitsausnahme": true, "nutzungstage": ["2026-04-01", "2026-05-20"]}}
	heu.div_nfz_zeitlich_erfuellt(p) with input.farm.year as 2026
	not heu.div_nfz_zeitlich_erfuellt(object.union(p, {"div_nutzung": {"op_massnahme": ""}})) with input.farm.year as 2026
}

test_formaler_zugang_mit_und_ohne_antrag if {
	a := {"personenart": "juristische Person", "oeffentlicher_anteil_prozent": 25, "oeffentlich_beherrscht": false, "eigener_name_rechnung": true, "verfuegungsgewalt": true, "aktiver_landwirt": true, "landwirtschaftliche_taetigkeit": true, "erstes_oepul_jahr": 2024, "mindestgroesse_at_ha": 13}
	v := object.union(betrieb.farm.heuwirtschaft, {"einstiegsart": "Neuantrag", "ama_genehmigt": true, "zahlungsantrag_im_jahr": true})
	heu.formaler_zugang with input as betrieb with input.farm.oepul_antrag as a with input.farm.heuwirtschaft as v
	not heu.formaler_zugang with input as betrieb with input.farm.oepul_antrag as a with input.farm.heuwirtschaft as object.union(v, {"antragsdatum": "2024-01-01"})
	not heu.formaler_zugang with input as betrieb with input.farm.oepul_antrag as object.union(a, {"oeffentlicher_anteil_prozent": 25.1}) with input.farm.heuwirtschaft as v
}

test_pruefung_fehlende_schlagnutzung if {
	unvollstaendig := object.union(object.remove(wiese, {"mfa"}), {"mfa": object.remove(mfa, {"schlagnutzung"})})
	not heu.praemienflaeche_ha with input as betrieb with input.land.parcels as [unvollstaendig]
}

test_gm01_ist_eigene_naturschutzkomponente if {
	n := object.union(wiese, {"mfa": {"gm01_bestaetigt": true, "anzahl_nutzungen": 2}, "constraints": {"is_contract_nature_area": true}})
	heu.gm01_eur_ha(n) == 108 with input as betrieb with input.farm.heuverfahren.silage_bereitet as false
	heu.praemienflaeche_ha == 0 with input as betrieb with input.land.parcels as [n]
	not heu.gm01_eur_ha(object.union(n, {"mfa": {"anzahl_nutzungen": 1}})) with input as betrieb with input.farm.heuverfahren.silage_bereitet as false
	heu.nat_kapitelzelle("G", "W") == "nein"
	heu.nat_kapitelzelle("G", "L") == "ja"
}

test_divsz_vergleichsmahd_und_ausnahmen if {
	p := {"div_nutzung": {"variante": "DIVSZ", "op_massnahme": "OPUBB", "andere_vorgaben": false, "trockenheitsausnahme": true, "zweite_vergleichsmahd": "2026-05-24", "bezirk_vorverlegung_tage": 7}}
	heu.divsz_vorzeitig(p, "2026-05-25") with input.farm.year as 2026
	not heu.divsz_vorzeitig(p, "2026-05-24") with input.farm.year as 2026
	not heu.divsz_vorzeitig(object.union(p, {"div_nutzung": {"zweite_vergleichsmahd": "2026-06-01"}}), "2026-05-25") with input.farm.year as 2026
}

test_mindestbewirtschaftung_und_kulturen if {
	p := {"bewirtschaftung": {"anbau_ordnungsgemaess": true, "jaehrliche_pflege": true, "ernte_und_abtransport_prozent": 85, "vollmahd_mit_abtransport_jahre": [2025]}}
	heu.mindestbewirtschaftung(p, "Acker ohne Ackerfutter")
	heu.mindestbewirtschaftung(p, "Bergmähder") with input.farm.year as 2026
	not heu.mindestbewirtschaftung(p, "Grünland/Ackerfutter") with input.farm.year as 2026
	heu.befreite_nutzung("K20", "K20", 2024)
	not heu.befreite_nutzung("K20", "K20", 2025)
	heu.kulturgruppe("Papau", 2025) == "Obst"
	not heu.kulturgruppe("Papau", 2024)
}

test_teilzahlung_und_kontrollvereitelung if {
	v := {"verwaltungskontrollen_abgeschlossen": true, "kontrolle_verhindert": true, "aussergewoehnliche_umstaende_anerkannt": false}
	heu.teilzahlung_max_eur(1000) == 750 with input.documentation.oepul_verfahren as v
	heu.kontrollvereitelung with input.documentation.oepul_verfahren as v
	not heu.teilzahlung_max_eur(1000) with input.documentation.oepul_verfahren.verwaltungskontrollen_abgeschlossen as false
}

test_grundwasser_sonderflaeche_trotz_matrixkreuz if {
	p := parzelle("ag", 3, "arable", "Klee", {"andere_schlagpraemien": ["16"], "codes": ["AG"]})
	heu.kombizelle("3", "16") == "x"
	heu.praemienflaeche_ha == 0 with input as betrieb with input.land.parcels as [p]
	heu.futter_ha == 3 with input as betrieb with input.land.parcels as [p]
}

test_vertragsuebernahme_auch_im_folgejahr_belegbar if {
	u := {"mfa_datum": "2026-04-15", "vorher_teilgenommen": false, "ama_genehmigt": true, "zusatz_ha": 0, "uebernommen_ha": 8}
	v := object.union(betrieb.farm.heuwirtschaft, {"einstiegsart": "Übernahme", "erstes_teilnahmejahr": 2026})
	heu.vertragseinstieg_belegt with input as betrieb with input.farm.heuwirtschaft as v with input.farm.year as 2027 with input.farm.massnahmenuebernahme as u
}
