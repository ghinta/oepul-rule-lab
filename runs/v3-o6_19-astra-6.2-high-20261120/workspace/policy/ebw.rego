package oepul.o6_19

import data.ebw_tabellen as tab
import rego.v1

programmjahr(y) if {
	y in numbers.range(2023, 2028)
}

datum(d) if {
	is_string(d)
	regex.match(`^\d{4}-\d{2}-\d{2}$`, d)
	time.parse_rfc3339_ns(concat("", [d, "T00:00:00Z"]))
}

vertragsjahre(start) := tab.vertragsjahre[sprintf("%d", [start])]

einstieg_fristgerecht(art, jahr, antrag) if {
	programmjahr(jahr)
	grenze := {"EBW": 2025, "Regionaler Naturschutzplan": 2028}[art]
	jahr <= grenze
	datum(antrag)
	antrag <= sprintf("%d-12-31", [jahr - 1])
}

plan_verlaengerbar if {
	programmjahr(input.farm.year)
	input.farm.ebw.plan_vorjahr
	input.farm.ebw.plan_abgemeldet == false
	input.farm.ebw.plan_bestaetigt
}

plan_aktiv if input.farm.ebw.plan_beantragt
plan_aktiv if plan_verlaengerbar

plan_satz := tab.plan_euro_betrieb[sprintf("%d", [input.farm.year])] if {
	plan_aktiv
	input.farm.ebw.plan_bestaetigt
	input.farm.ebw.projektbestaetigung
	input.farm.ebw.plan_auflagen_erfuellt
}

projektflaeche(p) if {
	p.land_use in {"arable", "grassland"}
	"EBW" in p.ebw.codes
	p.ebw.projekt_bestaetigt
	p.ebw.referenz_ha > 0
}

mindestteilnahme if {
	input.farm.year == input.farm.ebw.erstjahr
	input.farm.ebw.foerderfaehige_ha >= 1
}

mindestteilnahme if {
	input.farm.year > input.farm.ebw.erstjahr
	input.farm.ebw.bewirtschaftete_schlaege >= 1
}

pflege_im_intervall(p) if {
	p.ebw.letztes_pflegejahr in {input.farm.year, input.farm.year - 1}
}

beobachtung_erfuellt(p) if {
	p.ebw.laufend_beobachtet
	p.ebw.datenbank_strukturgerecht
}

abweichung_zulaessig(p) if {
	p.ebw.ruecksprache_vor_aenderung
	p.ebw.schriftliche_aenderung_vor_umsetzung
}

geeignete_person(t) if t.betriebsleitung

geeignete_person(t) if {
	t.betriebliche_erfordernisse
	t.massgeblich_taetig
	t.in_bewirtschaftung
}

person_bis_frist(t) if t.austritt == null

person_bis_frist(t) if {
	datum(t.austritt)
	t.austritt > "2026-12-31"
}

treffen_anrechenbar(t) if {
	datum(t.datum)
	t.datum <= "2026-12-31"
	t.regionales_vernetzungstreffen
	geeignete_person(t)
	person_bis_frist(t)
	t.anzahl_betriebe == 1
	t.anzahl_verpflichtungen == 1
}

nachweis_erforderlich if {
	input.documentation.ebw.ama_aufforderung
	input.documentation.ebw.durch_stelle_uebermittelt == false
}

ubb_bio if {
	some m in input.farm.ebw.massnahmen
	m in {"1A", "1B"}
}

div_anrechenbar(p) if {
	ubb_bio
	projektflaeche(p)
	p.land_use == "arable"
	p.ebw.schlagnutzung == "Grünbrache"
	"DIV" in p.ebw.codes
}

div_anrechenbar(p) if {
	ubb_bio
	projektflaeche(p)
	p.land_use == "grassland"
	"DIVSZ" in p.ebw.codes
	p.ebw.schnittzeitpunktauflage
	p.ebw.zustand_anrechenbar
	some row in tab.div_lebensraeume
	row.lebensraum == p.ebw.div_lebensraum
	p.ebw.schlagnutzung in row.nutzungen
}

feldstueck_soll_ha(f) := 0.15 if {
	ubb_bio
	f.art == "Acker"
	input.land.arable_area_ha >= 10
	f.massgebliche_ha > 5
}

feldstueck_soll_ha(f) := 0.15 if {
	ubb_bio
	f.art == "Mähgrünland"
	input.land.maehgruenland_ohne_bergmaehder_ha >= 10
	f.massgebliche_ha > 5
}

gloez8_anrechenbar(p) if {
	input.farm.year in {2023, 2024}
	p.land_use == "arable"
	p.ebw.schlagnutzung == "Grünbrache"
	{"EBW", "NPF"} - {c | some c in p.ebw.codes} == set()
}

# Überlappung beider Ausschlussgründe nur einmal abziehen.
gloez_bereinigte_ha(p) := rest if {
	p.land_use == "arable"
	programmjahr(input.farm.year)
	base := min([p.area_ha, p.ebw.referenz_ha])
	e := p.ebw
	e.gloez4_ha >= 0
	aus := gloez_ausschluss(e, input.farm.year)
	aus <= base
	rest := base - aus
}

gloez_ausschluss(e, y) := e.gloez4_ha if y >= 2025

gloez_ausschluss(e, y) := (e.gloez4_ha + e.gloez8_ha) - e.gloez4_8_ueberlappung_ha if {
	y <= 2024
	e.gloez4_8_ueberlappung_ha >= 0
	e.gloez4_8_ueberlappung_ha <= min([e.gloez4_ha, e.gloez8_ha])
}

brache_ha := min([input.farm.ebw.foerderfaehige_stilllegung_ha, max([2, input.land.arable_area_ha * 0.25])])

ebw_kombinationen := zeile.kombinationen if {
	some zeile in tab.kombinationsmatrix
	zeile.massnahme == "19"
}

einzelflaeche_kombinierbar(m, gegenstand) if {
	ebw_kombinationen[m] == "x"
	gegenstand != ""
}

einzelflaeche_kombinierbar(m, gegenstand) if {
	ebw_kombinationen[m] == "x1)"
	gegenstand == "punktförmiges Landschaftselement"
}

kombinationshinweis(m) := tab.kombinationslegende["1"] if ebw_kombinationen[m] == "x1)"

basis_eur_ha(p) := row.euro_ha if {
	some row in tab.basistarife
	row.typ == p.ebw.praemientyp
	row.gruppe == p.ebw.tarifgruppe
	row.zustand == p.ebw.zustand
	row.erschwernis == object.get(p.ebw, "erschwernis", null)
	row.von <= input.farm.year
	input.farm.year <= row.bis
	is_number(row.euro_ha)
}

basis_eur_ha(p) := p.ebw.bestaetigter_basissatz_2023 if {
	input.farm.year == 2023
	p.ebw.projekt_bestaetigt
	is_number(p.ebw.bestaetigter_basissatz_2023)
	p.ebw.bestaetigter_basissatz_2023 >= 0
}

grenzwert(r, _) := r.grenze if is_number(r.grenze)
grenzwert(r, i) := i.parameter[r.grenze] if is_string(r.grenze)

vergleich(a, op, b) if {
	op == ">="
	a >= b
}

vergleich(a, op, b) if {
	op == "<="
	a <= b
}

vergleich(a, op, b) if {
	op == "<"
	a < b
}

vergleich(a, op, b) if {
	op == ">"
	a > b
}

messbar(r, i) if {
	is_number(i.messungen[r.messgroesse])
	i.messungen[r.messgroesse] >= 0
	is_number(grenzwert(r, i))
}

fehlender_projektbezug(row, i) if {
	some name in row.datumsparameter
	not datum(object.get(i, ["parameter", name], ""))
}

zielarten_vorhanden(i) if {
	is_array(i.zielarten)
	count(i.zielarten) > 0
	every art in i.zielarten { is_string(art); trim_space(art) != ""}
}

fehlender_projektbezug(row, i) if {
	row.artenliste_erforderlich
	not zielarten_vorhanden(i)
}

fehlender_projektbezug(row, i) if {
	row.code == "EBAT04"
	i.parameter["$1"] > i.parameter["$2"]
}

fehlender_projektbezug(row, i) if {
	row.projektwortlaut_erforderlich
	trim_space(object.get(i, "konkreter_projektwortlaut", "")) == ""
}

befund(row, i) := "offen" if fehlender_projektbezug(row, i)

else := "verfehlt" if {
	some r in row.messregeln
	messbar(r, i)
	not vergleich(i.messungen[r.messgroesse], r.operator, grenzwert(r, i))
} else := "erfüllt" if {
	count(row.messregeln) > 0
	every r in row.messregeln {
		messbar(r, i)
		vergleich(i.messungen[r.messgroesse], r.operator, grenzwert(r, i))
	}
} else := "erfüllt" if {
	not row.messregeln
	i.fachbefund == true
} else := "verfehlt" if {
	not row.messregeln
	i.fachbefund == false
} else := "offen"

indikatorbefunde contains result if {
	some p in input.land.parcels
	some i in p.ebw.indikatoren
	some row in tab.indikatoren
	row.gruppe == i.gruppe
	row.code == i.code
	result := {"schlag": p.parcel_id, "code": i.code, "gruppe": i.gruppe, "pflicht": i.pflicht, "befund": befund(row, i), "regel": row.regel}
}

indikatorbefunde contains result if {
	some p in input.land.parcels
	some i in p.ebw.indikatoren
	not bekannter_indikator(i)
	result := {"schlag": p.parcel_id, "code": i.code, "gruppe": i.gruppe, "pflicht": i.pflicht, "befund": "offen", "regel": "o6_19.indikator"}
}

bekannter_indikator(i) if {
	some row in tab.indikatoren
	row.gruppe == i.gruppe
	row.code == i.code
}

pflichtindikatoren_erfuellt(p) if {
	p.ebw.indikatorliste_vollstaendig
	required := [i | some i in p.ebw.indikatoren; i.pflicht == true]
	count(required) > 0
	every i in required {
		some row in tab.indikatoren
		row.code == i.code
		row.gruppe == i.gruppe
		befund(row, i) == "erfüllt"
	}
}

zuschlagsatz(code) := row.euro_ha if {
	programmjahr(input.farm.year)
	some row in tab.zuschlaege
	row.code == code
	input.farm.year >= row.von
}

aufwand_stufe(p) if p.ebw.aufwand_code == "EBBA01"

aufwand_stufe(p) if {
	p.ebw.aufwand_code == "EBBA02"
	p.ebw.zustand == "A"
}

# Vergabe und fachliche Prüfung des benannten Grundes lt. Erhebungsbogen.
aufwand_eur_ha(p) := zuschlagsatz(p.ebw.aufwand_code) if {
	aufwand_stufe(p)
	p.ebw.aufwand_bestaetigt
	some grund in tab.aufwandsgruende
	grund.grund == p.ebw.aufwand_grund
	grund_zulaessig(grund.grund, p)
}

schutzgut(p) if p.ebw.schutzgut_typ in tab.schutzgut_typen

schutzgut(p) if {
	some row in tab.schutzgut_arten
	row.art == p.ebw.schutzgut_art
}

habitat_eur_ha(p) := zuschlagsatz(p.ebw.habitat_code) if {
	code := {"arable": "EBHG02", "grassland": "EBHG01"}[p.land_use]
	p.ebw.habitat_code == code
	schutzgut(p)
	p.ebw.landesmeldung
	p.ebw.ama_gis
	p.ebw.schutzgut_prozent >= 50
	p.ebw.schutzgut_prozent <= 100
	p.ebw.habitatindikatoren_erfuellt
	p.ebw.habitatzuschlag_bestaetigt
}

wechsel_moeglich(von, nach, d) if {
	some row in tab.wechsel
	row.von == von
	row.nach == nach
	datum(d)
	d <= row.bis
}

uebernahmefrist(y) := sprintf("%d-04-17", [y]) if y in {2023, 2028}

else := sprintf("%d-04-15", [y])

uebernahme_art(t) if t.art == "EBW"

uebernahme_art(t) if {
	t.art == "Regionaler Naturschutzplan"
	t.struktur in {"Betriebsauflösung", "Betriebsteilung", "Betriebszusammenlegung"}
}

uebernahme_moeglich(t) if {
	y := input.farm.year
	programmjahr(y)
	datum(t.datum)
	t.datum >= sprintf("%d-01-01", [y])
	t.datum <= uebernahmefrist(y)
	t.bisher_teilnahme == false
	t.online_mfa
	t.ama_genehmigt
	t.uebernommen_ha > 0
	t.ausweitung_ha >= 0
	t.ausweitung_ha <= t.uebernommen_ha * 0.5
	uebernahme_art(t)
}

rechtsform_zulaessig if {
	input.farm.antragsteller.gebietseinrichtung == false
	input.farm.antragsteller.gleichwertiger_oeffentlicher_einfluss == false
	input.farm.antragsteller.form in {"Natürliche Person", "Eingetragene Personengesellschaft"}
}

rechtsform_zulaessig if {
	input.farm.antragsteller.gebietseinrichtung == false
	input.farm.antragsteller.gleichwertiger_oeffentlicher_einfluss == false
	input.farm.antragsteller.form in {"Juristische Person", "Personenvereinigung"}
	input.farm.antragsteller.oeffentlich_prozent >= 0
	input.farm.antragsteller.oeffentlich_prozent <= 25
}

betriebsgroesse_erfuellt if input.farm.year > input.farm.oepul_erstjahr

betriebsgroesse_erfuellt if {
	input.farm.year == input.farm.oepul_erstjahr
	input.land.mfa_geschuetzt_at_ha >= 0.5
}

betriebsgroesse_erfuellt if {
	input.farm.year == input.farm.oepul_erstjahr
	input.land.mfa_gesamt_at_ha >= 1.5
}

ernteanteil_erfuellt(p) if {
	p.ebw.geerntet_und_verbracht_prozent >= 85
	p.ebw.geerntet_und_verbracht_prozent <= 100
}

ernteanteil_erfuellt(p) if duerre_erntebefreiung(p)

duerre_erntebefreiung(p) if {
	input.farm.year == 2026
	p.land_use == "arable"
	p.ebw.spaetsommer_herbsternte
	p.ebw.hitze_und_duerreempfindlich
	p.ebw.duerrebedingt_kein_erntbarer_bestand
	some row in tab.duerregebiete
	row.land == p.ebw.bundesland
	row.bezirk in {"alle Bezirke", p.ebw.bezirk}
}

div_variantenauflage(code) := tab.div_varianten[code]

kulturgruppen(kultur, jahr) := {row.gruppe | some row in tab.kulturen; row.kultur == kultur; row.ab <= jahr}

gve_faktor(gruppe, kategorie) := row if {
	some row in tab.gve
	row.gruppe == gruppe
	row.kategorie == kategorie
}

ausnahme_mindestkriterien(p) if {
	p.land_use == "arable"
	some row in tab.mindestbewirtschaftung_ausnahmen
	"19" in row.massnahmen
	p.ebw.schlagnutzung == row.nutzung
	row.code in p.ebw.codes
	input.farm.year <= row.bis
}

abgang_toleranz_ha := max([0.5, min([5, input.farm.ebw.vorjahr_ha * 0.05])])
rueckzahlung_flaeche_ha := input.farm.ebw.abgang_ohne_ausnahme_ha if input.farm.ebw.abgang_ohne_ausnahme_ha > abgang_toleranz_ha

else := 0 if input.farm.ebw.abgang_ohne_ausnahme_ha <= abgang_toleranz_ha

zugang_foerderbar_ha := input.farm.ebw.neuzugang_ha + input.farm.ebw.vorbelegter_zugang_ha if input.farm.year in {2024, 2025}

zugang_foerderbar_ha := input.farm.ebw.vorbelegter_zugang_ha + min([input.farm.ebw.neuzugang_ha, rest]) if {
	input.farm.year in {2026, 2027, 2028}
	rest := max([0, max([5, input.farm.ebw.basis_2025_ha * 0.5]) - input.farm.ebw.bereits_genutzter_zugang_ha])
}

gedeckelt_eur_ha(summe) := min([summe, row.euro_ha]) if {
	summe >= 0
	some row in tab.obergrenzen
	row.art == "18/19"
	input.farm.year >= row.von
	input.farm.year <= row.bis
}

bandende(row, ha) := ha if row.bis_ha == null

else := min([row.bis_ha, ha])

modulationsfaktor := sum(anteile) / ha if {
	ha := input.land.heimflaeche_ha
	ha > 0
	anteile := [teil | some row in tab.modulation; teil := max([0, bandende(row, ha) - row.von_ha]) * row.faktor]
}

sanktionsfolge(stufe, anzahl_100, jahr) := {"folge": "Ausschluss und Rückforderung seit Vertragsbeginn"} if {
	stufe == 100
	anzahl_100 >= 2
	programmjahr(jahr)
} else := {"kuerzung_prozent": 1} if {
	stufe == "Verwarnung"
	programmjahr(jahr)
	jahr >= 2027
} else := {"kuerzung_prozent": 0, "folge": "Verwarnung"} if {
	stufe == "Verwarnung"
	jahr in {2023, 2024, 2025, 2026}
} else := {"kuerzung_prozent": stufe} if {
	is_number(stufe)
	stufe in tab.sanktionsstufen
	anzahl_100 < 2
	programmjahr(jahr)
}

schnittreduktion(p) if p.ebw.aufwand.schnitte_weniger >= 2

schnittreduktion(p) if {
	p.ebw.aufwand.artenschutz_nala
	p.ebw.aufwand.schnitte_weniger >= 1
}

grund_zulaessig("Extensivierung", p) if {
	p.ebw.erschwernis == "leicht"
	p.ebw.aufwand.gunstlage
	p.ebw.aufwand.gebietskulisse_eingehalten
	schnittreduktion(p)
}

grund_zulaessig("Ungünstige Form", p) if {
	p.ebw.erschwernis == "leicht"
	p.area_ha <= 1
}

grund_zulaessig("Kleinflächigkeit", p) if {
	p.land_use == "grassland"
	p.ebw.erschwernis == "leicht"
	p.area_ha <= 0.3
}

grund_zulaessig("Entfernung über 10 km", p) if {
	p.ebw.aufwand.maehflaechentyp in {"Bergmähder", "Lärchenwiese"}
	p.ebw.aufwand.entfernung_km > 10
}

grund_zulaessig("Entfernung über 5 km", p) if {
	p.ebw.aufwand.maehflaechentyp == "Bergmähder"
	p.ebw.aufwand.entfernung_km > 5
}

grund_zulaessig("Entfernung über 5 km", p) if {
	p.ebw.aufwand.maehflaechentyp == "Sonstige Mähfläche"
	p.ebw.aufwand.begruendete_ausnahme
	p.ebw.aufwand.entfernung_km > 5
}

grund_zulaessig("Erschwertes Trocknen", p) if p.ebw.aufwand.verbringen_und_wiederauflegen_noetig

grund_zulaessig("Problempflanzenbekämpfung", p) if {
	p.ebw.zustand in {"B", "C"}
	some i in p.ebw.indikatoren
	regex.match(`^EB(NE|PR)[0-9]{2}$`, i.code)
	bekannter_indikator(i)
}

grund_zulaessig("Balkenmähwerk am Traktor", p) if p.ebw.erschwernis == "leicht"
grund_zulaessig("Heutrocknung auf der Fläche", p) if p.ebw.aufwand.maehdigkeit >= 2
grund_zulaessig("Erhöhter Zaunaufwand", p) if p.ebw.tarifgruppe == "Weide"
grund_zulaessig("Ausmähen von Baumwiesen", p) if p.ebw.praemientyp != "Streuobstbestand"
grund_zulaessig("Errichten von Sitzwarten", p) if p.ebw.praemientyp != "Braunkehlchen"

grund_zulaessig("Regionales Saatgut", p) if {
	p.land_use == "arable"
	p.ebw.aufwand.begruente_anlage_regionales_saatgut
}

tierziel_ausgeschlossen(typ, code) if {
	typ == "Lärchenwiese"
	code == "EBGT13"
}

tierziel_ausgeschlossen(typ, code) if {
	typ == "Braunkehlchen"
	code in {"EBGT14", "EBGT15", "EBGT16", "EBGT17"}
}

tierziel_ausgeschlossen(typ, code) if {
	typ == "Wachtelkönig"
	code in {"EBGT18", "EBGT19"}
}

grund_zulaessig("Zusatzaufwand Tierziel", p) if {
	some i in p.ebw.indikatoren
	bekannter_indikator(i)
	regex.match(`^EB(AT|GT)[0-9]{2}$`, i.code)
	p.ebw.aufwand.tierziel_code == i.code
	typ := p.ebw.praemientyp
	not tierziel_ausgeschlossen(typ, i.code)
}

grund_zulaessig("Umwandlung Acker in Grünland", p) if {
	p.land_use == "grassland"
	p.ebw.aufwand.vorjahr_rechtmaessiger_acker
}

# Teilentscheidungen. Fehlende Nachweise bleiben sichtbar.

schlagbewertung[p.parcel_id] := result if {
	some p in input.land.parcels
	"EBW" in p.ebw.codes
	befunde := {b | some b in indikatorbefunde; b.schlag == p.parcel_id}
	result := {"indikatoren": befunde, "tabellensatz_eur_ha": object.get(basissaetze, p.parcel_id, null)}
}

basissaetze[p.parcel_id] := satz if {
	some p in input.land.parcels
	projektflaeche(p)
	satz := basis_eur_ha(p)
}

tierhaltend(rgve, futter_ha) if {
	futter_ha > 0
	rgve >= 0.30 * futter_ha
}

massnahmenmerkmale(name) := {merkmal |
	listen := {"mehrjährig": tab.mehrjaehrige_massnahmen, "einjährig": tab.einjaehrige_massnahmen, "jährlich variable Einheiten": tab.variable_einheiten, "Zugangsgrenze": tab.zugangsbeschraenkte_massnahmen, "Übernahme nur im Einzelfall": tab.uebernahme_einzelfaelle}
	some merkmal, liste in listen
	name in liste
}

ausnahmen_gebietseinrichtung := tab.gebietseinrichtungen_ausnahmen
kuerzungsgruende := tab.kuerzungsgruende

div_soll_ha(flaeche) := flaeche * 0.07 if {
	ubb_bio
	flaeche > 2
} else := 0 if {
	ubb_bio
	flaeche >= 0
	flaeche <= 2
}

# Beurteilt die zusätzliche dritte Nutzung im Jahr 2026.
# Der maßnahmenbezogene Prämienausschluss betrifft UBB/BIO.
passender_op(p) if {
	"1A" in input.farm.ebw.massnahmen
	"OPUBB" in p.ebw.codes
}

passender_op(p) if {
	"1B" in input.farm.ebw.massnahmen
	"OPBIO" in p.ebw.codes
}

duerre_div_nutzung(p) := "Dritte Nutzung projektkonform, UBB/BIO ohne Prämie" if {
	input.farm.year == 2026
	p.land_use == "arable"
	{"EBW", "DIV"} - {c | some c in p.ebw.codes} == set()
	passender_op(p)
	p.ebw.nutzungen_im_jahr == 3
	p.ebw.nutzung_gemaess_projekt
}

weiterbildungsstand := "erfüllt" if {
	some t in input.documentation.ebw.treffen
	treffen_anrechenbar(t)
} else := "Frist läuft" if {
	datum(input.documentation.ebw.stichtag)
	input.documentation.ebw.stichtag <= "2026-12-31"
} else := "fachlich zu klären" if {
	some t in input.documentation.ebw.treffen
	t.austritt == "2026-12-31"
} else := "verfehlt" if {
	input.documentation.ebw.nachweise_vollstaendig
	is_array(input.documentation.ebw.treffen)
	datum(input.documentation.ebw.stichtag)
	input.documentation.ebw.stichtag > "2026-12-31"
} else := "offen"

# Komponenten vor Modulation und eventuellen Kürzungen. Ein unbestätigter
# Zuschlag hat nur bei ausdrücklich fehlender Vergabe den Wert null Euro.
aufwandsbetrag(p) := 0 if p.ebw.aufwand_bestaetigt == false

else := aufwand_eur_ha(p)

habitatbetrag(p) := 0 if p.ebw.habitatzuschlag_bestaetigt == false

else := habitat_eur_ha(p)

projektpraemie_eur_ha(p) := (basis_eur_ha(p) + aufwandsbetrag(p)) + habitatbetrag(p) if {
	projektflaeche(p)
}

# Nur explizit bekannte Sachverhalte lösen einen Verstoß aus.
verstoesse contains {"regel": "o6_19.minimum_erstjahr"} if {
	input.farm.year == input.farm.ebw.erstjahr
	is_number(input.farm.ebw.foerderfaehige_ha)
	input.farm.ebw.foerderfaehige_ha < 1
}

verstoesse contains {"regel": "o6_19.minimum_folgejahr"} if {
	programmjahr(input.farm.year)
	input.farm.year > input.farm.ebw.erstjahr
	input.farm.ebw.bewirtschaftete_schlaege == 0
}

verstoesse contains {"regel": "o6_19.pflege", "schlag": p.parcel_id} if {
	some p in input.land.parcels
	projektflaeche(p)
	is_number(p.ebw.letztes_pflegejahr)
	p.ebw.letztes_pflegejahr < input.farm.year - 1
}

verstoesse contains {"regel": b.regel, "schlag": b.schlag, "indikator": b.code} if {
	some b in indikatorbefunde
	b.pflicht == true
	b.befund == "verfehlt"
	some p in input.land.parcels
	p.parcel_id == b.schlag
	"EBW" in p.ebw.codes
}

verstoesse contains {"regel": "o6_19.treffen"} if weiterbildungsstand == "verfehlt"

kuerzungsreihenfolge := tab.kuerzungsreihenfolge

kleinbetrag if {
	betrag := input.farm.ebw.auszahlungsbetrag_eur
	is_number(betrag)
	betrag >= 0
	betrag <= 50
}

zugangsfolge := "Kein EBW-Vertrag" if {
	input.farm.ebw.zugangsvoraussetzung_verfehlt
	input.farm.year == input.farm.ebw.erstjahr
}

zugangsfolge := "Keine EBW-Prämie im betroffenen Jahr" if {
	input.farm.ebw.zugangsvoraussetzung_verfehlt
	programmjahr(input.farm.year)
	input.farm.year > input.farm.ebw.erstjahr
}

praemienausschluesse contains {"schlag": p.parcel_id, "grund": "OP"} if {
	some p in input.land.parcels
	"EBW" in p.ebw.codes
	"OP" in p.ebw.codes
}

praemienausschluesse contains {"schlag": p.parcel_id, "grund": "VF"} if {
	some p in input.land.parcels
	"EBW" in p.ebw.codes
	"VF" in p.ebw.codes
}

praemienausschluesse contains {"schlag": p.parcel_id, "grund": "Auslandsfläche"} if {
	some p in input.land.parcels
	"EBW" in p.ebw.codes
	p.ebw.allgemeine_nachweise.in_oesterreich == false
}

praemienausschluesse contains {"schlag": p.parcel_id, "grund": "Flächenidentifikation"} if {
	some p in input.land.parcels
	"EBW" in p.ebw.codes
	p.ebw.allgemeine_nachweise.identifikation_korrekt == false
}

praemienausschluesse contains {"schlag": p.parcel_id, "grund": "Nationalpark"} if {
	some p in input.land.parcels
	"EBW" in p.ebw.codes
	p.ebw.allgemeine_nachweise.nationalpark in {"Neusiedlersee", "Donau-Auen"}
}

praemienausschluesse contains {"schlag": p.parcel_id, "grund": "Nationalpark"} if {
	some p in input.land.parcels
	"EBW" in p.ebw.codes
	p.ebw.allgemeine_nachweise.parkauflagen
}

praemienausschluesse contains {"schlag": p.parcel_id, "grund": "Leistungsüberschneidung"} if {
	some p in input.land.parcels
	"EBW" in p.ebw.codes
	p.ebw.allgemeine_nachweise.oeffentliche_ueberschneidung
}

praemienausschluesse contains {"schlag": p.parcel_id, "grund": "Ausgleichsfläche"} if {
	some p in input.land.parcels
	"EBW" in p.ebw.codes
	p.ebw.allgemeine_nachweise.vorgeschriebener_ausgleich
}

praemienausschluesse contains {"schlag": p.parcel_id, "grund": "GLÖZ-Landschaftselement"} if {
	some p in input.land.parcels
	"EBW" in p.ebw.codes
	p.ebw.allgemeine_nachweise.gloez_lse
}

praemienausschluesse contains {"schlag": p.parcel_id, "grund": "überwiegend nichtlandwirtschaftlich"} if {
	some p in input.land.parcels
	"EBW" in p.ebw.codes
	p.ebw.allgemeine_nachweise.ueberwiegend_landwirtschaftlich == false
}

# Ergebnis für das aktuelle Betriebsprofil. Beträge sind gesondert
# ausgewiesene Rechenschritte, keine Bewilligung oder Zahlungsanweisung.
praemienbausteine[p.parcel_id] := betrag if {
	some p in input.land.parcels
	betrag := projektpraemie_eur_ha(p)
}

bewertung := {
	"schlaege": schlagbewertung,
	"projektpraemien_vor_kuerzung_eur_ha": praemienbausteine,
	"weiterbildung": weiterbildungsstand,
	"festgestellte_verstoesse": verstoesse,
	"allgemeine_flaechenausschluesse": praemienausschluesse,
}
