package oepul.o6_5

import data.o6_5_tabellen as tab
import rego.v1

jahr := input.farm.year if {
	input.farm.year in numbers.range(2023, 2028)
}

tag(y, md) := sprintf("%04d-%s", [y, md])
stichtag := tag(jahr, "04-01")
halteende := "2026-08-31" if jahr == 2026

else := tag(jahr, "12-31")

ns(d) := time.parse_ns("2006-01-02", d)

datum(d) if {
	is_string(d)
	time.format([ns(d), "UTC", "2006-01-02"]) == d
}

seit(d, n) := time.format([ns(d) + (n * 86400000000000), "UTC", "2006-01-02"])

# Kalendermonate, mit Begrenzung auf den letzten Tag des Zielmonats.
monate(d, n) := out if {
	[y, m, t] := time.date(ns(d))
	first := time.parse_ns("2006-01-02", sprintf("%04d-%02d-01", [y, m]))
	next := time.add_date(first, 0, n + 1, 0)
	last := time.date(next - 86400000000000)
	out := sprintf("%04d-%02d-%02d", [last[0], last[1], min([t, last[2]])])
}

fristgerecht(ereignis, meldung, tage) if {
	datum(meldung)
	ereignis <= meldung
	meldung <= seit(ereignis, tage)
}

haltungszeit(d) if {
	datum(d)
	d >= stichtag
	d <= halteende
}

rasse(t) := r if {
	r := rassen_nach_name[t.rasse]
	r.tierart == kategorien_nach_name[t.kategorie].tierart
}

person_ok(p) if {
	p.rechtsform in {"natuerliche_person", "eingetragene_personengesellschaft", "juristische_person", "personenvereinigung"}
	p.oeffentliche_einrichtung == false
	p.gleichwertiger_oeffentlicher_einfluss == false
	is_number(p.oeffentliches_kapital_prozent)
	p.oeffentliches_kapital_prozent >= 0
	p.oeffentliches_kapital_prozent <= 25
}

betrieb_ok if {
	p := input.farm.oepul
	person_ok(p)
	p.aktiver_landwirt
	p.landwirtschaftliche_taetigkeit
	p.eigener_name_und_rechnung
	p.verfuegungsgewalt
	groesse_ok
}

groesse_ok if {
	is_number(input.farm.oepul.erstes_oepul_jahr)
	input.farm.oepul.erstes_oepul_jahr >= 2023
	input.farm.oepul.erstes_oepul_jahr < jahr
} else if {
	input.farm.oepul.erstes_oepul_jahr == jahr
	input.land.geschuetzter_anbau_at_ha >= 0.5
} else if {
	input.farm.oepul.erstes_oepul_jahr == jahr
	input.land.anrechenbare_mfa_flaeche_at_ha >= 1.5
}

einstieg(d) if {
	datum(d)
	jahr <= 2027
	d <= tag(jahr - 1, "12-31")
}

abmeldejahr(d) := time.date(ns(d))[0]

uebernahme_ok(u) if {
	u.grund in {"Betriebsauflösung", "Betriebsteilung", "Betriebszusammenlegung"}
	u.vorbetrieb_tiere != ""
	u.vorbetrieb_tiere == u.vorbetrieb_flaechen
	u.online_im_mfa
	u.ama_genehmigt
}

bestaetigt(t) if {
	b := t.bestaetigung
	zustaendig(t, b.organisation)
	b.zuchtbuch
	b.kategorie
	b.programm
	b.eama
	datum(b.datum)
	b.datum >= tag(jahr, "01-01")
	b.datum <= tag(jahr + 1, "02-10")
}

beantragt(t) if {
	rasse(t).tierart == "Rind"
	t.rinderdatenbank_stichtag
} else if {
	rasse(t).tierart in {"Schaf", "Ziege", "Schwein"}
	t.mfa_beilage_stichtag
} else if {
	rasse(t).tierart == "Pferd"
	t.mfa_beilage_stichtag
	is_string(t.ueln)
	t.ueln != ""
	t.mfa_kennzeichnung == t.ueln
}

jahreseinsatz(t, bezugsjahr) if t.zuchteinsatz_im_jahr

else if t.zuchtzulassungsjahr == bezugsjahr

hengst_nachweis(t, grenze) if monate(t.geburtsdatum, 60) >= grenze

else if {
	some kind in t.nachkommen
	kind.lebend_geboren
	datum(kind.registriert_am)
	kind.registriert_am >= monate(grenze, -24)
	kind.registriert_am <= grenze
}

# Geburten werden chronologisch, vollständig und bis zum Bewertungsende erfasst.
geburten_geordnet(t) if {
	is_array(t.geburten)
	every i, g in t.geburten {
		datum(g.datum)
		g.datum >= t.geburtsdatum
		g.datum <= t.beurteilt_bis
		vor := array.slice(t.geburten, 0, i)
		every v in vor { v.datum < g.datum }
	}
}

wurffolge_ok(t) if {
	every i, g in t.geburten {
		is_boolean(g.reinrassig)
		paar_ok(t.geburten, i)
	}
}

paar_ok(gs, i) if i == 0

else if gs[i].reinrassig

else if gs[i - 1].reinrassig

abfohlungen_ok(t) if {
	every i, g in t.geburten {
		ende := folgetermin(t, i)
		ende <= monate(g.datum, 42)
	}
}

folgetermin(t, i) := t.geburten[i + 1].datum if i + 1 < count(t.geburten)

else := t.beurteilt_bis

stutenfolge(t) if t.kategorie != "Stute"

else if abfohlungen_ok(t)

sauenfolge(t, grenze) if t.kategorie != "Zuchtsau"

else if {
	some g in t.geburten
	g.reinrassig
	g.datum <= grenze
	wurffolge_ok(t)
}

kategorie_ok(t, grenze) if {
	c := kategorien_nach_name[t.kategorie]
	c.geschlecht == "w"
	t.reinrassige_anpaarung
	geburten_geordnet(t)
	some g in t.geburten
	g.datum <= grenze
	stutenfolge(t)
	sauenfolge(t, grenze)
} else if {
	c := kategorien_nach_name[t.kategorie]
	c.geschlecht == "m"
	monate(t.geburtsdatum, c.alter_monate) <= grenze
	maennlicher_einsatz(t, grenze)
}

maennlicher_einsatz(t, grenze) if {
	t.kategorie == "Zuchthengst"
	hengst_nachweis(t, grenze)
} else if {
	t.kategorie != "Zuchthengst"
	jahreseinsatz(t, time.date(ns(grenze))[0])
}

zuchttier(t, grenze) if {
	rasse(t)
	t.haltungsland == "AT"
	t.reinrassig
	t.zuchtprogramm_genehmigt_mit_erhaltungsziel
	t.tierzuchtrecht_erfuellt
	t.regelmaessiger_zuchteinsatz
	datum(t.geburtsdatum)
	datum(t.beurteilt_bis)
	kategorie_ok(t, grenze)
	bestaetigt(t)
}

gepzuschlag(t, satz) := 0 if rasse(t).gep == false

else := 0 if t.gep_umgesetzt == false

else := satz if t.gep_umgesetzt

milchzuschlag(t, _) := 0 if t.kategorie != "Kuh"

else := 0 if t.bestaetigung.milchleistungskontrolle == false

milchzuschlag(t, satz) := satz if {
	t.kategorie == "Kuh"
	t.bestaetigung.milchleistungskontrolle
}

tarif(t) := betrag if {
	gruppe := min([jahr, 2024])
	some r in tab.tarife
	r.ab == gruppe
	r.kategorie == t.kategorie
	basis := r[rasse(t).stufe]
	is_number(basis)
	cent := (round(basis * 100) + round(gepzuschlag(t, r.gep) * 100)) + round(milchzuschlag(t, r.milch) * 100)
	betrag := to_number(sprintf("%d.%02d", [floor(cent / 100), cent % 100]))
}

niedrigerer_satz(a, b) if {
	kategorien_nach_name[a.kategorie].geschlecht == "w"
	kategorien_nach_name[b.kategorie].geschlecht == "m"
}

niedrigerer_satz(a, b) if {
	a.kategorie == "Kuh"
	a.bestaetigung.milchleistungskontrolle
	milchzuschlag(b, 1) == 0
}

ersatztarif(a, b) := tarif(a) if {
	a.rasse == b.rasse
	tarif(a) == tarif(b)
} else := min([tarif(a), tarif(b)]) if {
	a.rasse == b.rasse
	niedrigerer_satz(a, b)
}

ersatz_ok(a, b) if {
	a.tier_id != b.tier_id
	a.rasse == b.rasse
	haltungszeit(a.abgang)
	fristgerecht(a.abgang, b.beginn, 35)
	ersatzquelle(b)
	datum(b.beurteilt_bis)
	b.beurteilt_bis >= b.beginn
	b.bestaetigung.datum >= b.beginn
	zuchttier(b, b.beginn)
}

ersatzquelle(t) if rasse(t).tierart != "Rind"

else if t.rinderdatenbank_zugang

weide(e) if {
	e.art in {"Zinsweide", "Almweide", "Gemeinschaftsweide"}
	e.voruebergehend
	e.verfuegungsgewalt_am_heimbetrieb
}

weide(e) if {
	e.art in {"Almweide", "Gemeinschaftsweide"}
	e.voruebergehend
	e.nur_zur_betreuung
}

abtrieb(art, weideart, heimmeldung) if {
	art in {"Schaf", "Ziege"}
	weideart in {"Almweide", "Gemeinschaftsweide"}
	heimmeldung
}

kurzaufenthalt(e) if {
	e.voruebergehend
	e.belegt
	fristgerecht(e.von, e.rueckkehr, 10)
}

zuchtaufenthalt(t, e) if {
	rasse(t)
	e.art == "Zuchtstation"
	e.zuchtzweck
	e.voruebergehend
	datum(e.rueckkehr)
	e.von <= e.rueckkehr
	e.rueckkehr <= monate(e.von, 6)
} else if {
	kategorien_nach_name[t.kategorie].geschlecht == "m"
	e.art == "Landwirtschaftsbetrieb"
	e.zuchtzweck
	e.voruebergehend
	datum(e.rueckkehr)
	e.von <= e.rueckkehr
	e.rueckkehr <= monate(e.von, 3)
}

rinderweitergabe(t) if {
	rasse(t).tierart == "Rind"
	datum(t.abgang)
	t.abgang > tag(jahr, "09-30")
	t.abgang <= tag(jahr, "12-31")
	t.weitergabe_an_betrieb
	t.im_inland_und_lebend_bis_jahresende
}

zucht_meldeweg(t, e) := "Rinderdatenbank" if rasse(t).tierart == "Rind"

else := "keine gesonderte AMA-Meldung" if kurzaufenthalt(e)

else := "eAMA vor Weitergabe" if rasse(t).tierart in {"Pferd", "Schaf", "Schwein", "Ziege"}

registerpflichten(art) := ["UELN", "Österreichische Equidendatenbank", "VIS"] if art in {"Pferd", "Pony", "Esel", "Equidenkreuzung"}

registerpflichten(art) := ["VIS"] if art in {"Schaf", "Ziege"}

registerpflichten(art) := ["Rinderdatenbank"] if art == "Rind"

bewegungsmeldung(t) := "Rinderdatenbank" if {
	rasse(t).tierart == "Rind"
	datum(t.abgang)
} else := "eAMA – Beilage Gefährdete Nutztierrassen" if {
	rasse(t).tierart in {"Pferd", "Schaf", "Ziege", "Schwein"}
	datum(t.abgang)
	meldezeitraum(t.abgang)
}

meldezeitraum(d) if haltungszeit(d)

else if {
	jahr == 2026
	d >= stichtag
	d <= tag(jahr, "12-31")
}

ersatz_meldeweg(t) := "Rinderdatenbank" if rasse(t).tierart == "Rind"

else := "keine gesonderte Nachbesetzungsmeldung" if {
	jahr == 2026
	datum(t.beginn)
	t.beginn > halteende
	t.beginn <= tag(jahr, "12-31")
} else := "eAMA – Beilage Gefährdete Nutztierrassen" if rasse(t).tierart in {"Pferd", "Schaf", "Schwein", "Ziege"}

# Eine Position enthält das Stichtagstier und seine tatsächlichen Ersatztiere in Reihenfolge.
weiterhaltung(t, ende) if {
	datum(t.beurteilt_bis)
	t.beurteilt_bis >= ende
	t.abgang == null
} else if {
	datum(t.abgang)
	t.abgang > ende
	t.beurteilt_bis >= ende
} else if {
	rinderweitergabe(t)
	t.beurteilt_bis >= t.abgang
}

aufenthalt_ok(t, e) if weide(e)

else if zuchtaufenthalt(t, e)

else if {
	e.art in {"Leistungsprüfung", "Zuchtveranstaltung", "Sportveranstaltung"}
	kurzaufenthalt(e)
}

aufenthalt_im_jahr_ok(t, e) if {
	datum(e.von)
	datum(e.rueckkehr)
	e.von <= e.rueckkehr
	zeitraum_ok(t, e)
}

zeitraum_ok(t, e) if e.rueckkehr <= stichtag

else if e.von > halteende

else if aufenthalt_ok(t, e)

kette_ok(k) if {
	original := k.tiere[0]
	beantragt(original)
	datum(original.beginn)
	original.beginn <= stichtag
	zuchttier(original, tag(jahr, kategorien_nach_name[original.kategorie].stichtag))
	letztes := count(k.tiere) - 1
	every i, t in k.tiere {
		is_string(t.tier_id)
		t.tier_id != ""
		eindeutig(t.tier_id)
		datum(t.beginn)
		t.beginn <= t.beurteilt_bis
		is_array(t.aufenthalte)
		every e in t.aufenthalte { aufenthalt_im_jahr_ok(t, e) }
		kettenglied(k.tiere, i, letztes)
	}
}

kettenglied(tiere, i, letztes) if {
	i == letztes
	weiterhaltung(tiere[i], halteende)
} else if {
	i < letztes
	a := tiere[i]
	a.abgang >= a.beginn
	a.beurteilt_bis >= a.abgang
	ersatz_ok(a, tiere[i + 1])
}

eindeutig(id) if {
	count([1 | some k in input.livestock.foerderpositionen; some t in k.tiere; t.tier_id == id]) == 1
}

positionen contains k.tiere[0].tier_id if {
	some k in input.livestock.foerderpositionen
	kette_ok(k)
}

minimum_erreicht if {
	some k in input.livestock.foerderpositionen
	t := k.tiere[0]
	is_string(t.tier_id)
	t.tier_id != ""
	beantragt(t)
	eindeutig(t.tier_id)
	datum(t.beginn)
	t.beginn <= stichtag
	am_stichtag(t)
	zuchttier(t, tag(jahr, kategorien_nach_name[t.kategorie].stichtag))
}

am_stichtag(t) if t.abgang == null

else if {
	datum(t.abgang)
	t.abgang >= stichtag
}

positionsbetrag(k) := min(saetze) if {
	kette_ok(k)
	erst := tarif(k.tiere[0])
	folge := [betrag | some i, t in k.tiere; i > 0; betrag := ersatztarif(k.tiere[i - 1], t)]
	count(folge) == count(k.tiere) - 1
	saetze := array.concat([erst], folge)
}

grundbetraege[k.tiere[0].tier_id] := positionsbetrag(k) if some k in input.livestock.foerderpositionen

stufenende(stufe, ha) := ha if stufe.bis == null

else := min([stufe.bis, ha])

modulationsfaktor(ha) := 1 if ha == 0

else := sum(anteile) / ha if {
	is_number(ha)
	ha > 0
	anteile := [wert | some stufe in tab.modulation; wert := stufe.faktor * max([0, stufenende(stufe, ha) - stufe.ab])]
}

sanktionssatz(stufe) := s.prozent if {
	some s in tab.sanktionen
	s.stufe == stufe
	is_number(s.prozent)
	jahr >= s.ab
	is_number(s.bis)
	jahr <= s.bis
}

sanktionssatz(stufe) := s.prozent if {
	some s in tab.sanktionen
	s.stufe == stufe
	is_number(s.prozent)
	s.bis == null
	jahr >= s.ab
}

gve_wert(kategorie, anzahl) := {"einheit": r.einheit, "wert": r.faktor * anzahl} if {
	is_number(anzahl)
	anzahl >= 0
	some r in tab.gve
	r.kategorie == kategorie
}

zwergrind(r) if r in tab.zwergrinder

tierhalter(rgve, futter_ha) if {
	futter_ha > 0
	rgve / futter_ha >= 0.30
}

# Fristen sind unabhängig vom Ergebnis der Halte- und Tarifprüfung sichtbar.
meldeauftraege contains eintrag if {
	some k in input.livestock.foerderpositionen
	some t in k.tiere
	weg := bewegungsmeldung(t)
	weg != "Rinderdatenbank"
	eintrag := {"tier_id": t.tier_id, "ereignis": "Abgang", "weg": weg, "ereignistag": t.abgang, "frist": seit(t.abgang, 7), "status": meldestatus(t.abgang, object.get(t, "abgang_gemeldet_am", null))}
}

meldeauftraege contains eintrag if {
	some k in input.livestock.foerderpositionen
	some i, t in k.tiere
	i > 0
	weg := ersatz_meldeweg(t)
	start := t.beginn
	eintrag := ersatzeintrag(t.tier_id, start, weg, object.get(t, "ersatz_gemeldet_am", null))
}

ersatzeintrag(id, d, weg, m) := {"tier_id": id, "ereignis": "Nachbesetzung", "ereignistag": d, "weg": weg, "frist": seit(d, 7), "status": meldestatus(d, m)} if startswith(weg, "eAMA")

else := {"tier_id": id, "ereignis": "Nachbesetzung", "ereignistag": d, "weg": weg}

meldestatus(_, m) := "kein Meldedatum belegt" if m == null
meldestatus(d, m) := "fristgerecht" if fristgerecht(d, m, 7)

else := "außerhalb der Frist" if datum(m)

meldeauftraege contains {"tier_id": t.tier_id, "ereignis": "Abgang", "ereignistag": t.abgang, "weg": "Rinderdatenbank"} if {
	some k in input.livestock.foerderpositionen
	some t in k.tiere
	bewegungsmeldung(t) == "Rinderdatenbank"
}

meldeauftraege contains eintrag if {
	some k in input.livestock.foerderpositionen
	some t in k.tiere
	some e in t.aufenthalte
	haltungszeit(e.von)
	weide(e) == true
	eintrag := {"tier_id": t.tier_id, "ereignis": "Weideaufenthalt", "ereignistag": e.von, "weg": "keine Abgangsmeldung"}
}

meldeauftraege contains eintrag if {
	some k in input.livestock.foerderpositionen
	some t in k.tiere
	some e in t.aufenthalte
	haltungszeit(e.von)
	not weide(e)
	weg := zucht_meldeweg(t, e)
	eintrag := {"tier_id": t.tier_id, "ereignis": "Weitergabe", "ereignistag": e.von, "weg": weg, "status": vorabstatus(weg, e)}
}

vorabstatus(weg, _) := "gesonderten Meldeweg beachten" if weg != "eAMA vor Weitergabe"

vorabstatus(weg, e) := "vor Weitergabe belegt" if {
	weg == "eAMA vor Weitergabe"
	e.vor_weitergabe_gemeldet
}

vorabstatus(weg, e) := "Vorabmeldung offen" if {
	weg == "eAMA vor Weitergabe"
	not e.vor_weitergabe_gemeldet
}

kein_ausstieg(d) if d == null

else if abmeldejahr(d) > jahr

antragsgrund(v) if einstieg(v.massnahmenantrag_am)

else if v.vorjahresvertrag_aufrecht

else if {
	jahr <= 2027
	v.unmittelbarer_wiedereinstieg
	v.vorjahresantrag_online_korrigiert
	v.schriftliches_ersuchen
	v.korrektur_genehmigt
} else if uebernahme_ok(v.uebernahme)

teilnahme_belegt if {
	betrieb_ok
	v := input.farm.oepul.vertrag
	antragsgrund(v)
	v.zahlungsantrag_eingereicht
	kein_ausstieg(v.abmeldung_am)
	minimum_erreicht
}

# Nur die vor inhaltlichen Kürzungen vollständig bezifferbaren Positionen.
modulierte_tarifsumme := sum([b | some _, b in grundbetraege]) * modulationsfaktor(input.land.heimflaeche_mfa_ha) if {
	teilnahme_belegt
	count(grundbetraege) == count(input.livestock.foerderpositionen)
}

status_position(k) := "Tier- und Halteprüfung belegt, Tarif bestimmbar" if positionsbetrag(k)

else := "Tier- und Halteprüfung belegt, Tarif offen" if kette_ok(k)

else := "Voraussetzungen nicht vollständig belegt"

pruefung := {
	"jahr": jahr,
	"stichtag": stichtag,
	"halteende_einschliesslich": halteende,
	"bestaetigungsfrist": tag(jahr + 1, "02-10"),
	"positionen": [{"index": i, "status": status_position(k)} | some i, k in input.livestock.foerderpositionen],
	"einzeltarife_eur": grundbetraege,
	"mindestteilnahme": mindeststatus,
	"teilnahme": teilnahmestatus,
	"modulierte_tarifsumme_vor_sanktionen_eur": tarifsumme_oder_null,
	"nachbesetzungsfristen": ersatzfristen,
	"meldeauftraege": meldeauftraege,
} if {
	is_array(input.livestock.foerderpositionen)
}

ackerfutter(kultur) if kultur in tab.ackerfutter

kuerzungsreihenfolge(schritte) := [schritt | some schritt in tab.kuerzungsreihenfolge; schritt in schritte]

mindeststatus := "erreicht" if minimum_erreicht

else := "kein Tier beantragt" if input.livestock.foerderpositionen == []

else := "kein förderbares Stichtagstier belegt"

teilnahmestatus := "Zugang und Anmeldung belegt" if teilnahme_belegt

else := "Zugang oder Anmeldung nicht belegt"

tarifsumme_oder_null := modulierte_tarifsumme if is_number(modulierte_tarifsumme)

else := null

ersatzfristen contains {"tier_id": t.tier_id, "abgang": t.abgang, "spaetestens": seit(t.abgang, 35), "rasse": t.rasse} if {
	some k in input.livestock.foerderpositionen
	some t in k.tiere
	haltungszeit(t.abgang)
	not rinderweitergabe(t)
}

kontrollfolge := "Ausschluss und Rückforderung der Maßnahmenprämien im Vertragszeitraum" if input.documentation.oepul_kontrolle.anzahl_vollkuerzungen_im_vertrag >= 2

# Prüft erfasste Programmnachweise. Die förmliche Entscheidung des Verbands bleibt ein eigener Nachweis.
abstammungspruefung(n, t) if n.mehrere_hauptklassen == false

else if n.neue_oberste_klasse == false

else if {
	n.mehrere_hauptklassen
	n.neue_oberste_klasse
	abstammungsseiten(n, t)
	methode_ok(n, t)
}

abstammungsseiten(n, t) if {
	kategorien_nach_name[t.kategorie].geschlecht == "m"
	n.vater_abgesichert
	n.mutter_abgesichert
}

abstammungsseiten(n, t) if {
	kategorien_nach_name[t.kategorie].geschlecht == "w"
	n.beidseitig_moeglich
	n.vater_abgesichert
	n.mutter_abgesichert
}

abstammungsseiten(n, t) if {
	kategorien_nach_name[t.kategorie].geschlecht == "w"
	n.beidseitig_moeglich == false
	eine_seite(n)
}

eine_seite(n) if n.vater_abgesichert

else if n.mutter_abgesichert

methode_ok(_, t) if rasse(t).tierart != "Rind"

methode_ok(n, t) if {
	rasse(t).tierart == "Rind"
	n.snp_bei_rind
}

genbanknutzung_ok(n) if n.genbanknutzung_technisch_moeglich == false

else if n.einvernehmen_oengene_bedarf == false

else if n.genbank_im_paarungsplan

programmnachweise_ok(n, t) if {
	rasse(t).gep
	t.rasse == n.rasse
	zustaendig(t, n.organisation)
	abstammungspruefung(n, t)
	n.anpaarungsplan_umgesetzt
	n.methoden_beschrieben
	n.arbeitskollektion_nach_stand_und_verfuegbarkeit
	genbanknutzung_ok(n)
	n.erbfehlermanagement
	n.vatertiermonitoring
}

kombinationszelle(zeile, spalte) := wert if {
	some z in tab.einzelflaechenmatrix
	z.code == zeile
	wert := z.spalten[spalte]
}

matrix_fussnote(nummer) := tab.matrix_fussnoten[sprintf("%d", [nummer])]

zustaendig(t, name) if {
	r := rasse(t)
	name in {r.organisation, r.organisation_merkblatt}
}

bestand_rgve := sum(werte) if {
	bestand := input.livestock.bestandsberechnung
	is_array(bestand)
	every b in bestand { gve_wert(b.gve_kategorie, b.durchschnittsanzahl) }
	werte := [w.wert |
		some b in bestand
		w := gve_wert(b.gve_kategorie, b.durchschnittsanzahl)
		w.einheit == "RGVE"
	]
}

tierhalter_nach_futterflaeche if tierhalter(bestand_rgve, input.land.grassland_area_ha + input.land.ackerfutterflaeche_ha)

rassen_nach_name[zeile.rasse] := object.remove(zeile, ["rasse"]) if {
	some zeile in tab.rassen
}

kategorien_nach_name[zeile.kategorie] := zeile if {
	some zeile in tab.kategorien
}
