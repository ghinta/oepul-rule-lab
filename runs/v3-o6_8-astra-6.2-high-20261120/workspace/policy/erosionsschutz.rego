package oepul.o6_8

import data.erosionsdaten as tab
import rego.v1

jahr := input.farm.year
antrag := input.farm.oepul
tag(d) := time.parse_rfc3339_ns(concat("", [d, "T00:00:00Z"])) / 86400000000000
stichtag(y, md) := sprintf("%04d-%s", [y, md])

vertrag_aktiv if {
	antrag.vertrag_fortgefuehrt
	some v in tab.vertraege
	v.beginn == antrag.beginn
	jahr >= v.beginn
	jahr <= 2028
	tag(antrag.antragsdatum) <= tag(stichtag(v.beginn - 1, "12-31"))
}

vertrag_aktiv if {
	antrag.vertrag_fortgefuehrt
	uebernahme_ok
	jahr >= antrag.uebernahme.jahr
	jahr <= 2028
}

uebernahmefrist(y) := "04-17" if y in {2023, 2028}

else := "04-15"

uebernahme_ok if {
	uebernahme := antrag.uebernahme
	some v in tab.vertraege
	uebernahme.ursprungsbeginn == v.beginn
	uebernahme.jahr >= v.beginn
	uebernahme.jahr <= 2028
	uebernahme.erstteilnahme
	uebernahme.ama_genehmigt
	uebernahme.uebernommen_ha > 0
	uebernahme.zusaetzlich_ha >= 0
	uebernahme.zusaetzlich_ha <= uebernahme.uebernommen_ha / 2
	tag(uebernahme.antragsdatum) >= tag(stichtag(uebernahme.jahr, "01-01"))
	tag(uebernahme.antragsdatum) <= tag(stichtag(uebernahme.jahr, uebernahmefrist(uebernahme.jahr)))
}

groesse_ok if {
	is_number(antrag.oepul_teilnahmejahr)
	antrag.oepul_teilnahmejahr > 1
}

groesse_ok if {
	antrag.oepul_teilnahmejahr == 1
	antrag.geschuetzt_at_ha >= 0.5
}

groesse_ok if {
	antrag.oepul_teilnahmejahr == 1
	antrag.mindestgroesse_at_ha >= 1.5
}

person_ok if {
	antrag.rechtsform in {"natuerliche_person", "eingetragene_personengesellschaft"}
	antrag.gebietseinrichtung == false
}

person_ok if {
	antrag.rechtsform in {"juristische_person", "personenvereinigung"}
	antrag.oeffentlich_prozent >= 0
	antrag.oeffentlich_prozent <= 25
	antrag.gebietseinrichtung == false
}

betrieb_ok if {
	person_ok
	groesse_ok
	antrag.eigener_name_und_rechnung
	antrag.aktiver_landwirt
	antrag.landwirtschaftliche_taetigkeit
}

partnerflaeche_ok if input.land.arable_area_ha >= 1.5
partner(m) if m in antrag.massnahmen
normalname(n) := replace(replace(replace(lower(trim_space(n)), " /", "/"), "/ ", "/"), "ackerbohnen-erbsengemenge", "ackerbohnen/erbsengemenge")

kultur_ok(p, c) if {
	some r in tab.kulturen
	c in r.codes
	jahr >= r.ab
	normalname(r.nutzung) == normalname(p.crop.crop_name)
	bestand_ok(r, p)
}

kultur_ok(p, "US") if {
	lower(p.crop.crop_name) == "sonnenblumen"
	some r in tab.kulturen
	r.nutzung == "Sonnenblume"
	"US" in r.codes
	jahr >= r.ab
}

kultur_ok(p, c) if {
	c in {"MS", "DS"}
	lower(p.crop.crop_name) == "sonnenblume"
	some r in tab.kulturen
	r.nutzung == "Sonnenblumen"
	c in r.codes
	jahr >= r.ab
}

bestand_ok(r, _) if r.nur_bestand == false

bestand_ok(r, p) if {
	r.nur_bestand
	p.erosion.baw.altbestand
}

kulturgruppe(name) := {r.gruppe |
	some r in tab.kulturgruppen
	lower(name) == lower(r.kultur)
	jahr >= r.ab
}

variante(v, y) := row if {
	some row in tab.varianten
	row.variante == v
	y >= row.ab
	y <= row.bis
}

variante6_kultur(name) if name in tab.variante6_arten

vorfrucht_ok(p) if {
	partnerflaeche_ok
	some m in {"6", "7"}
	partner(m)
	antrag.erster_fruehling_nach_immergruen == false
	z := p.erosion.vorfrucht
	z.jahr == jahr - 1
	vorfrucht_nachgewiesen(z)
	vorher_ok(z)
}

vorher_ok(z) if {
	z.programm == "ZWF2023"
	z.variante in {2, 4, 5, 6}
	variante(z.variante, z.jahr)
}

vorher_ok(z) if {
	jahr == 2023
	z.programm == "ZWF2015"
	z.variante in {4, 5, 6}
}

vorher_ok(z) if {
	jahr == 2025
	z.programm == "NPF"
	z.variante in {2, 4, 5, 6}
}

vorher_ok(z) if {
	z.programm == "Immergruen"
	partner("7")
	z.ueberwintert
}

lockerung_ok(m) if m.tiefenlockerung == false

lockerung_ok(m) if {
	m.tiefenlockerung
	m.begruenung_erhalten
}

mulch_ok(p) if {
	m := p.erosion.saat
	p.operations.tillage_type == "mulch"
	m.flach_nichtwendend
	m.tief_mischend == false
	m.oberflaechenmulch
	lockerung_ok(m)
	tage := tag(m.hauptsaat) - tag(m.erste_bearbeitung)
	tage >= 0
	tage <= 28
}

saattechnik_ok(p) if {
	p.operations.tillage_type == "no_till"
	p.erosion.saat.schlitz_in_bestand
	p.erosion.saat.vollflaechig == false
}

saattechnik_ok(p) if {
	p.operations.tillage_type == "strip_till"
	p.erosion.saat.nur_saatstreifen
	p.erosion.saat.rest_zwischen_streifen
}

reihen_ok(_, a) if a.reihen == "alle_ausser_fahrgassen"

reihen_ok(p, a) if {
	normalname(p.crop.crop_name) == "saatkartoffeln"
	a.reihen == "jede_vierte_frei"
	a.unkrautkontrolle_und_personenschutz_erforderlich
	a.notwendigkeit_plausibel
}

geraet_ok(a) if a.geraet == "legegeraet"

geraet_ok(a) if {
	a.geraet == "dammfraese"
	a.abgesetztes_legen
	a.zeitnah
}

anhaeufung_ok(p) if {
	a := p.erosion.ah
	a.max_abstand_m > 0
	a.max_abstand_m <= 2
	reihen_ok(p, a)
	geraet_ok(a)
	a.wirksame_erdanhaeufung
	a.bis_krautminderung
}

kg_gelistet(nr) if {
	some k in tab.katastralgemeinden
	to_number(k.kg_nr) == to_number(nr)
}

baw_lage_ok(p) if {
	b := p.erosion.baw
	kg_gelistet(b.kg_nr)
	b.gis_ueberlappung_ha > 0
	b.gis_ueberlappung_ha <= p.area_ha
	p.area_ha <= 4 * b.gis_ueberlappung_ha
}

baw_anlage_ok(p) if {
	p.erosion.baw.altbestand

	# Nur bestehende Grünbrache bzw. Ackerfutter aus der Positivliste.
	kultur_ok(p, "BAW")
}

baw_anlage_ok(p) if {
	b := p.erosion.baw
	b.altbestand == false
	b.winterharte_mischung
	b.leguminosen_prozent >= 0
	b.leguminosen_prozent < 50
	tag(b.saatdatum) >= tag(stichtag(b.anlagejahr, "01-01"))
	tag(b.saatdatum) <= tag(stichtag(b.anlagejahr, "05-15"))
}

baw_umbruch_ok(b) if b.umbruchdatum == null
baw_umbruch_ok(b) if tag(b.umbruchdatum) >= tag(stichtag(b.anlagejahr + 1, "09-15"))

baw_pflege_ok(p) if {
	b := p.erosion.baw
	baw_mittel_ok(b)
	baw_pflegeintervall(p)
	b.beweidet == false
	b.gedroschen == false
	b.begruenung_erhalten
}

gloez_abzug(b) := b.gloez4_oder_8_ha if jahr <= 2024

else := b.gloez4_ha

baw_zahlflaeche(p) := area if {
	b := p.erosion.baw
	b.gruenland_mfa2020 == false
	not npf_stilllegung(p)
	abzug := gloez_abzug(b)
	abzug >= 0
	abzug <= p.area_ha
	area := p.area_ha - abzug
}

npf_stilllegung(p) if {
	jahr <= 2024
	"NPF" in p.erosion.codes
	normalname(p.crop.crop_name) == "grünbrache"
}

us_datum_ok(p) if {
	u := p.erosion.us
	normalname(p.crop.crop_name) != "winterackerbohnen"
	tage := tag(u.saatdatum) - tag(p.erosion.saat.hauptsaat)
	tage >= 0
	tage <= 56
	tag(u.saatdatum) >= tag(stichtag(jahr, "01-01"))
	tag(u.saatdatum) <= tag(stichtag(jahr, "06-30"))
}

us_datum_ok(p) if {
	normalname(p.crop.crop_name) == "winterackerbohnen"
	u := p.erosion.us
	u.vergleichbarer_fruehjahrszeitraum
	tag(u.saatdatum) >= tag(stichtag(jahr, "01-01"))
	tag(u.saatdatum) <= tag(stichtag(jahr, "04-30"))
}

us_nachweis_ok(u) if u.partner_ersichtlich
us_nachweis_ok(u) if u.nachweis in {"Rechnung", "Etikett"}

us_deckung_ok(u) if {
	u.flaechendeckend
	u.ausreichender_aufgang
}

us_deckung_ok(u) if {
	jahr == 2026
	u.ordnungsgemaesse_anlage
	count({s | some s in u.mischungspartner}) >= 3
}

untersaat_ok(p) if {
	u := p.erosion.us
	u.ordnungsgemaesse_anlage
	u.aktiv_zwischen_reihen
	count({s | some s in u.mischungspartner}) >= 3
	us_datum_ok(p)
	us_nachweis_ok(u)
	us_deckung_ok(u)
	u.bearbeitung_bis_ernte == false
	u.herbizid_bis_ernte == false
	u.erhalten_bis_ernte
	u.mitgeerntet == false
}

matrixzelle(m, n) := row if {
	some row in tab.kombinationen
	row.zeile == m
	row.spalte == n
}

matrixhinweis(n) := r.inhalt if {
	some r in tab.matrix_hinweise
	r.nr == n
}

weitere_praemien_ok(p, "BAW") if {
	every z in p.erosion.weitere_praemien { z.massnahme in {"1A", "1B"}; z.nur_lse}
}

weitere_praemien_ok(p, c) if {
	c != "BAW"
	every z in p.erosion.weitere_praemien { matrixzelle("8", z.massnahme).zeichen == "x"; z.ausgeschlossene_teilflaeche == false}
}

vertraeglich(p, c) if {
	c in {"MS", "DS"}
	not "AH" in p.erosion.codes
	count({k | some k in p.erosion.codes; k in {"MS", "DS"}}) == 1
}

vertraeglich(p, "AH") if {
	not "MS" in p.erosion.codes
	not "DS" in p.erosion.codes
}

vertraeglich(_, c) if c in {"BAW", "US"}

saatpraemie_ok(_) if antrag.wien_zuschlag == false
saatpraemie_ok(p) if p.erosion.bundesland != "Wien"

div_anrechenbar(p) if {
	some m in {"1A", "1B"}
	partner(m)
	verfahren(p, "BAW")
	"DIV" in p.erosion.codes
	p.crop.crop_name in {"Grünbrache", "Sonstiges Feldfutter"}
	p.erosion.baw.div_pflege_und_nutzung
}

wechsel_moeglich(ziel, datum) if {
	some r in tab.wechsel
	r.von == "8-BAW"
	r.nach == ziel
	tag(datum) <= tag(stichtag(r.bis_jahr, "12-31"))
}

ernteausnahme(p) if {
	jahr == 2026
	p.erosion.ernte.spaetsommer_herbst_hitzeanfaellig
	p.erosion.ernte.duerrebedingter_totalausfall
	some b in tab.duerrebezirke
	b.land == p.erosion.bundesland
	bezirk_gilt(b, p)
}

bezirk_gilt(b, _) if b.bezirk == "alle Bezirke"
bezirk_gilt(b, p) if b.bezirk == p.erosion.bezirk

ernte_ok(p) if p.erosion.ernte.geerntet_und_verbracht_prozent >= 85
ernte_ok(p) if ernteausnahme(p)
ernte_ok(p) if p.erosion.ernte.ausnahme_anerkannt

bewirtschaftung_ok(_, "BAW") if ausnahme_mindestpflege("BAW", "8", jahr)

bewirtschaftung_ok(p, c) if {
	c != "BAW"
	p.erosion.ernte.ordnungsgemaesser_anbau
	p.erosion.ernte.jaehrliche_pflege
	ernte_ok(p)
}

nationalpark_ok(p) if {
	not p.erosion.nationalpark in {"Neusiedlersee", "Donau-Auen"}
	is_string(p.erosion.nationalpark)
	p.erosion.nationalpark_auflagen == false
}

basisflaeche_ok(p) if {
	p.land_use == "arable"
	p.area_ha > 0
	p.erosion.in_oesterreich
	p.erosion.verfuegungsgewalt
	p.erosion.mfa_referenz_richtig
	p.erosion.hauptsaechlich_landwirtschaftlich
	p.erosion.ueberlappende_oeffentliche_leistung == false
	p.erosion.jahresverpflichtung_erfuellt
	nationalpark_ok(p)
	every c in p.erosion.codes { not c in {"OP", "OPEROA", "VF"} }
}

technik(p, "MS") if {
	vorfrucht_ok(p)
	mulch_ok(p)
}

technik(p, "DS") if {
	vorfrucht_ok(p)
	saattechnik_ok(p)
}

technik(p, "AH") if anhaeufung_ok(p)
technik(p, "US") if untersaat_ok(p)

technik(p, "BAW") if {
	baw_lage_ok(p)
	p.erosion.baw.anlagejahr <= jahr
	baw_anlage_ok(p)
	baw_umbruch_ok(p.erosion.baw)
	baw_pflege_ok(p)
}

verfahren(p, c) if {
	p.land_use == "arable"
	p.area_ha > 0
	c in p.erosion.codes
	kultur_ok(p, c)
	technik(p, c)
}

teilnahme_ha := sum([p.area_ha | some p in input.land.parcels; p.erosion.in_oesterreich; p.erosion.verfuegungsgewalt; count({c | some c in p.erosion.codes; verfahren(p, c)}) > 0])
mindestflaeche_erreicht if teilnahme_ha >= 0.10

zahlflaeche(p, "BAW") := baw_zahlflaeche(p)
zahlflaeche(p, c) := p.area_ha if c in {"MS", "DS", "AH", "US"}

satz(c) := r.euro_ha if {
	some r in tab.saetze
	c == r.code
	jahr >= r.ab
	jahr <= r.bis
}

us_zuschlag := satz("US_BIO") if partner("1B")

else := 0 if is_array(antrag.massnahmen)

hektarsatz("US") := satz("US") + us_zuschlag
hektarsatz(c) := satz(c) if c != "US"

standortzahlung(p, c) if {
	c in {"MS", "DS"}
	saatpraemie_ok(p)
}

standortzahlung(_, c) if c in {"AH", "BAW", "US"}

# Grundbetrag vor Obergrenzen, Betriebsgrößenmodulation und Verwaltungssanktionen.
grundbetraege contains {"schlag": p.parcel_id, "code": c, "ha": a, "eur_ha": s, "eur": a * s} if {
	vertrag_aktiv
	betrieb_ok
	mindestflaeche_erreicht
	some p in input.land.parcels
	some c in p.erosion.codes
	verfahren(p, c)
	basisflaeche_ok(p)
	bewirtschaftung_ok(p, c)
	vertraeglich(p, c)
	weitere_praemien_ok(p, c)
	standortzahlung(p, c)
	a := zahlflaeche(p, c)
	a > 0
	s := hektarsatz(c)
}

obergrenze_ha(titel) := r if {
	some r in tab.obergrenzen
	r.titel == titel
	jahr >= r.ab
	jahr <= r.bis
}

stufenende(r, ha) := ha if r.bis == null

else := min({r.bis, ha})

modulationsfaktor(ha) := sum([anteil | some r in tab.modulation; anteil := max({0, stufenende(r, ha) - r.von}) * r.faktor]) / ha if ha > 0

sanktionssatz(stufe) := r.bis_2026 if {
	jahr < 2027
	some r in tab.sanktionen
	r.stufe == stufe
}

else := r.ab_2027 if {
	jahr >= 2027
	some r in tab.sanktionen
	r.stufe == stufe
}

abgangstoleranz(vorjahr_ha) := max({0.5, min({5, vorjahr_ha * 0.05})}) if vorjahr_ha >= 0

hangfall(p) if {
	p.land_use == "arable"
	p.area_ha > 0.5
	p.slope_percent >= 10
	p.erosion.erosionsgefaehrdete_kultur
	p.erosion.minderndes_verfahren == false
}

hangfaktor(p, "1A") := 0 if hangfall(p)

hangfaktor(p, "1B") := 0 if {
	hangfall(p)
	jahr <= 2024
}

hangfaktor(p, "1B") := 0.5 if {
	hangfall(p)
	jahr >= 2025
}

# Datierte Kontrollangaben gelten für den jeweils bezeichneten Schlag.
kuerzungsreihenfolge := tab.kuerzungsfolge

gve_faktor(kategorie) := r if {
	some r in tab.gve
	r.kategorie == kategorie
}

tierhaltend if {
	tierbemessung := input.livestock.bemessung
	tierbemessung.futterflaeche_ha > 0
	every t in tierbemessung.durchschnittsbestaende { gve_faktor(t.kategorie); t.anzahl_inland >= 0}
	rgve := sum([einheiten |
		some t in tierbemessung.durchschnittsbestaende
		r := gve_faktor(t.kategorie)
		r.einheit == "RGVE"
		einheiten := r.faktor * t.anzahl_inland
	])
	rgve >= 0.30 * tierbemessung.futterflaeche_ha
}

vertragsgruppen(m) := {r.gruppe | some r in tab.vertragsgruppen; r.massnahme == m}

ausnahme_mindestpflege(f, m, y) if {
	some r in tab.ausnahmen_bewirtschaftung
	r.flaeche == f
	m in split(r.massnahme, "/")
	y <= r.bis
}

uebernahme_nur_einzelfall(m) if m in tab.uebernahme_einzelfaelle

gebietseinrichtung_zugelassen(m, y) if {
	some r in tab.oeffentliche_ausnahmen
	r.massnahme == m
	y >= r.ab
	y <= r.bis
}

# Deckung mehrerer Maßnahmen auf demselben Schlag. Geldbeträge vor Aufteilung
# einer allfälligen Kappung auf die einzelnen Maßnahmen.
gekappte_schlagsumme(titel, ha, zahlungen) := summe if {
	ha > 0
	r := obergrenze_ha(titel)
	every z in zahlungen { is_number(z.eur); z.eur >= 0; is_string(z.massnahme)}
	anrechenbar := sum([z.eur | some z in zahlungen; not z.massnahme in r.ausgenommen])
	extra := sum([z.eur | some z in zahlungen; z.massnahme in r.ausgenommen])
	summe := extra + min({ha * r.euro_ha, anrechenbar})
}

sanktionsfolge(stufe, bisherige_vollkuerzungen) := {"prozent": sanktionssatz(stufe), "ausschluss": ausschluss, "rueckforderung_bisheriger_praemien": ausschluss} if {
	bisherige_vollkuerzungen >= 0
	ausschluss := stufe == 6

	# Ausschluss erst bei erneuter Vollkürzung im selben Vertragszeitraum.
	bisherige_vollkuerzungen > 0
}

else := {"prozent": sanktionssatz(stufe), "ausschluss": false, "rueckforderung_bisheriger_praemien": false} if bisherige_vollkuerzungen == 0

# Prüfung der zeitlichen Eingrenzung anhand vollständiger Maßnahmenaufzeichnungen.
baw_mittelzeitraum(b, e) if {
	tag(e.datum) >= tag(stichtag(b.erstes_mfa_jahr, "01-01"))
	vor_ende(e, b.umbruchdatum)
	vor_ende(e, b.anderweitige_deklaration)
}

vor_ende_valid(ende) if ende == null
vor_ende_valid(ende) if is_number(tag(ende))
vor_ende(_, ende) if ende == null
vor_ende(e, ende) if tag(e.datum) < tag(ende)

vor_ende(e, ende) if {
	e.datum == ende
	object.get(e, "nach_beendigung_am_selben_tag", false) != true
}

baw_mittel_ok(b) if {
	object.get(b, "mittelereignisse", null) == null
	b.psm_im_verbotszeitraum == false
	b.duengung_im_verbotszeitraum == false
}

baw_mittel_ok(b) if {
	is_number(b.erstes_mfa_jahr)
	vor_ende_valid(b.umbruchdatum)
	vor_ende_valid(b.anderweitige_deklaration)
	is_array(b.mittelereignisse)
	every e in b.mittelereignisse {
		is_number(tag(e.datum))
		not baw_mittelzeitraum(b, e)
	}
	object.get(b, "psm_im_verbotszeitraum", false) == false
	object.get(b, "duengung_im_verbotszeitraum", false) == false
}

baw_pflegeintervall(p) if p.erosion.baw.pflegeintervall_eingehalten

baw_pflegeintervall(p) if {
	b := p.erosion.baw
	b.anlagejahr == jahr
	object.get(b, "pflegeintervall_eingehalten", true)
}

baw_pflegeintervall(p) if {
	b := p.erosion.baw
	b.anlagejahr < jahr
	some d in array.concat(p.operations.cutting_dates, b.haeckseldaten)
	tag(d) >= tag(stichtag(jahr - 1, "01-01"))
	tag(d) <= tag(stichtag(jahr, "12-31"))
	object.get(b, "pflegeintervall_eingehalten", true)
}

# Einzelfallprüfung von Dürrefristen im System Immergrün 2026.
immer_duerre_nachsaat(x) if {
	jahr == 2026
	x.vorausschauend_plausibel
	x.anlagevoraussetzungen_fehlten
	x.fruehestmoeglich_nachgeholt
	tag(x.anlage) >= tag(stichtag(jahr, "01-01"))
	tag(x.anlage) <= tag(stichtag(jahr, "12-31"))
	immer_endfrist(x)
}

immer_endfrist(x) if x.kulturtyp == "Hauptfrucht"

immer_endfrist(x) if {
	x.kulturtyp == "Zwischenfrucht"
	x.dauer_tage >= 42
	x.ueberwiegend_winterhart == true
	tag(x.anlage) <= tag(stichtag(jahr, "10-15"))
}

immer_endfrist(x) if {
	x.kulturtyp == "Zwischenfrucht"
	x.dauer_tage >= 42
	x.ueberwiegend_winterhart == false
	tag(x.anlage) <= tag(stichtag(jahr, "09-20"))
}

# Sachangaben zu Varianten 2, 4, 5 und 6 können statt einer bereits
# geprüften Vorbegrünung unmittelbar für das Saatverfahren vorgelegt werden.
vorfrucht_nachgewiesen(z) if {
	object.get(z, "variantenanlage", null) == null
	z.ordnungsgemaess
}

vorfrucht_nachgewiesen(z) if {
	z.programm in {"NPF", "ZWF2023"}
	object.get(z, "ordnungsgemaess", true)
	x := z.variantenanlage
	x.weitere_auflagen_erfuellt
	variantenanlage_ok(z.variante, z.jahr, x)
}

variantenanlage_ok(v, y, x) if {
	v in {2, 4, 5, 6}
	r := variante(v, y)
	tag(x.anlage) >= tag(stichtag(y, "01-01"))
	tag(x.anlage) <= tag(stichtag(y, r.anlage))
	tag(x.umbruch) >= tag(stichtag(y + 1, r.umbruch))
	variantenmischung_ok(r, x)
}

variantenmischung_ok(r, x) if {
	r.variante in {2, 4, 5}
	is_array(x.partner)
	count({s.art | some s in x.partner}) >= r.partner
	count({s.familie | some s in x.partner}) >= r.familien
}

variantenmischung_ok(r, x) if {
	r.variante == 6
	count(x.partner) > 0
	every s in x.partner { variante6_kultur(s.art) }
}

zwischenfrucht_aus_untersaat(p, v, y, erntedatum) if {
	v in {1, 2, 3, 4, 5, 6}
	r := variante(v, y)
	tag(erntedatum) >= tag(stichtag(y, "01-01"))
	tag(erntedatum) < tag(stichtag(y, r.anlage))
	p.erosion.us.folgende_variantenauflagen_erfuellt
}

zugangsfolge(vertragsjahr) := "kein_vertrag" if vertragsjahr == 1

else := "keine_jahrespraemie" if vertragsjahr >= 2

duerre_div_code(anteil_vor_august, art, nutzungen) if {
	jahr == 2026
	art in {"Mahd", "Häckseln"}
	anteil_vor_august > 0.25
	nutzungen <= 3
}

duerre_div_code(_, art, nutzungen) if {
	jahr == 2026
	art == "Beweidung vor August"
	nutzungen <= 3
}

duerre_div_code(_, _, nutzungen) if {
	jahr == 2026
	nutzungen == 3
}

# Die Beantragung ist bei nicht erfüllbaren Förderbedingungen unverzüglich
# anzupassen. Die Frist wird nicht in eine erfundene Tageszahl umgerechnet.
korrekturbedarf contains {"schlag": p.parcel_id, "code": c, "regel": "o6_8.korrektur"} if {
	some p in input.land.parcels
	some c in p.erosion.nicht_erfuellbare_codes
	c in p.erosion.codes
	c in {"MS", "DS", "BAW", "AH", "US"}
}
