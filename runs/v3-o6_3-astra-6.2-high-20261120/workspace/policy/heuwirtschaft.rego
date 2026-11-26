package oepul.o6_3

import rego.v1

tab := data.heutabellen
jahr := input.farm.year
vertrag := input.farm.heuwirtschaft
antrag := input.farm.oepul_antrag
verfahren := input.farm.heuverfahren

vertrag_im_zeitraum if {
	some row in tab.vertraege
	vertrag.vertragsbeginn == row.beginn
	vertrag.erstes_teilnahmejahr >= row.beginn
	jahr >= vertrag.erstes_teilnahmejahr
	jahr <= row.ende
}

datum_gueltig(tag) if {
	regex.match(`^[0-9]{4}-[0-9]{2}-[0-9]{2}$`, tag)
	is_number(time.parse_ns("2006-01-02", tag))
}

neuantrag_fristgerecht if {
	some row in tab.vertraege
	row.beginn == vertrag.vertragsbeginn
	datum_gueltig(vertrag.antragsdatum)
	vertrag.antragsdatum <= sprintf("%d-12-31", [row.beginn - 1])
}

option_beantragt := vertrag.option_kreuz if {
	vertrag_im_zeitraum
	is_boolean(vertrag.option_kreuz)
}

kombination_erfuellt if {
	some m in vertrag.parallele_massnahmen
	m in {"1A", "1B", "BIO-Teilbetrieb"}
}

ackerfutter(p) if {
	p.land_use == "arable"
	p.mfa.zweitkultur == false
	some row in tab.futterkulturen
	lower(p.crop.crop_name) == lower(row.kultur)
}

inlandsantrag(p) if {
	p.mfa.beantragt == true
	p.mfa.in_at == true
}

# Die Flächenliste muss auch für nicht zahlbare Schläge klassifizierbar sein.
futterangaben(p) if p.land_use != "arable"

futterangaben(p) if {
	p.land_use == "arable"
	is_string(p.crop.crop_name)
	is_boolean(p.mfa.zweitkultur)
}

flaechenliste if {
	is_array(input.land.parcels)
	every p in input.land.parcels {
		is_number(p.area_ha)
		p.area_ha >= 0
		is_string(p.land_use)
		is_boolean(p.mfa.beantragt)
		is_boolean(p.mfa.in_at)
		futterangaben(p)
	}
}

futterparzelle(p) if p.land_use == "grassland"
futterparzelle(p) if ackerfutter(p)

futter_ha := sum([p.area_ha | some p in input.land.parcels; inlandsantrag(p); futterparzelle(p)]) if flaechenliste

maehwiese(p) if {
	p.land_use == "grassland"
	p.mfa.schlagnutzung in {"Mähwiese", "Mähweide"}
}

mahd_im_jahr(p) if {
	some tag in p.operations.cutting_dates
	datum_gueltig(tag)
	startswith(tag, sprintf("%d-", [jahr]))
}

gruenland_bestimmt(p) if p.land_use != "grassland"
gruenland_bestimmt(p) if is_string(p.mfa.schlagnutzung)

einstiegsflaeche_ha := sum([p.area_ha | some p in input.land.parcels; inlandsantrag(p); maehwiese(p)]) if {
	flaechenliste
	every p in input.land.parcels { gruenland_bestimmt(p) }
}

kleiner_equide(t) if {
	t.widerristhoehe_m > 0
	t.endgewicht_kg > 0
	t.widerristhoehe_m <= 1.48
	t.endgewicht_kg <= 300
} else := false if {
	is_number(t.widerristhoehe_m)
	t.widerristhoehe_m > 1.48
}

else := false if {
	is_number(t.endgewicht_kg)
	t.endgewicht_kg > 300
}

tierklasse(t) := "zwergrind" if {
	t.art == "rind"
	t.rasse in tab.zwerg_rassen
} else := "rind" if {
	t.art == "rind"
	is_string(t.rasse)
	t.rasse != ""
} else := t.art if t.art in {"schaf", "ziege"}

else := "equide_klein" if {
	t.art == "equide"
	kleiner_equide(t)
} else := "equide_gross" if {
	t.art == "equide"
	kleiner_equide(t) == false
} else := "wild_kamel_jung" if {
	wildart(t)
	t.wildhaltung_auf_lf == true
	t.alter_jahre < 1
} else := "dam_oder_zuchtwild" if {
	t.art in {"damwild", "zuchtwild"}
	t.wildhaltung_auf_lf == true
} else := t.art if {
	t.art in {"rotwild", "neuweltkamel"}
	t.wildhaltung_auf_lf == true
}

wildart(t) if t.art in {"rotwild", "damwild", "zuchtwild", "neuweltkamel"}

unter_altersgrenze(alter, grenze) if {
	is_number(alter)
	grenze == null
}

unter_altersgrenze(alter, grenze) if {
	is_number(grenze)
	alter < grenze
}

rgve_faktor(t) := row.rgve_pro_stueck if {
	some row in tab.rgve_schluessel
	row.klasse == tierklasse(t)
	is_number(t.alter_jahre)
	t.alter_jahre >= row.alter_ab_jahren
	unter_altersgrenze(t.alter_jahre, row.alter_unter_jahren)
}

massgeblicher_bestand(t) := t.jahresmittel_rinderdatenbank if {
	t.art == "rind"
	is_number(t.jahresmittel_rinderdatenbank)
} else := t.durchschnittsliste if {
	t.art != "rind"
	is_number(t.durchschnittsliste)
} else := t.bestand_1_april if {
	t.art != "rind"
	t.durchschnittsliste == null
	t.bestand_schwankt == false
	is_number(t.bestand_1_april)
}

gruppen_rgve(t) := 0 if t.in_at == false

else := 0 if t.art == "kein_rgve"

else := 0 if {
	wildart(t)
	t.wildhaltung_auf_lf == false
} else := anzahl * rgve_faktor(t) if {
	t.in_at == true
	anzahl := massgeblicher_bestand(t)
	anzahl >= 0
}

rgve := sum(werte) if {
	gruppen := input.livestock.species_groups
	is_array(gruppen)
	werte := [gruppen_rgve(g.rgve_angaben) | some g in gruppen]
	count(werte) == count(gruppen)
}

tierhaltend := rgve >= (0.30 * futter_ha) if futter_ha > 0

jahreszugang if {
	vertrag_im_zeitraum
	kombination_erfuellt
	jahr == vertrag.erstes_teilnahmejahr
	einstiegsflaeche_ha >= 2
	tierhaltend
}

jahreszugang if {
	vertrag_im_zeitraum
	kombination_erfuellt
	jahr > vertrag.erstes_teilnahmejahr
}

satz_eur_ha := row.euro_ha if {
	vertrag_im_zeitraum
	some row in tab.praemiensaetze
	jahr >= row.ab
	jahr <= row.bis
	tierhaltend == row.tierhaltend
	satzoption(row.option)
}

satzoption(o) if o == null

satzoption(o) if {
	is_boolean(o)
	o == option_beantragt
}

kombizelle(a, b) := tab.kombinationen[a][b]

park_ausschluss(p) if p.mfa.nationalpark in {"Neusiedlersee", "Neusiedler See-Seewinkel", "Donau-Auen"}

park_ausschluss(p) if {
	is_string(p.mfa.nationalpark)
	p.mfa.nationalpark != ""
	p.mfa.relevante_parkauflagen == true
}

ausschlusscode(p) if {
	some code in p.mfa.codes
	code in {"OP", "VF", "AG", "BAW", "K20"}
}

maehnutzung(p) if maehwiese(p)

maehnutzung(p) if {
	ackerfutter(p)
	some row in tab.futterkulturen
	lower(p.crop.crop_name) == lower(row.kultur)
	row.maehbar
}

zahlbar(p) if {
	inlandsantrag(p)
	maehnutzung(p)
	mahd_im_jahr(p)
	p.mfa.heuwirtschaft_beantragt == true
	p.mfa.referenz_korrekt == true
	p.mfa.allgemein_praemienfaehig == true
	not park_ausschluss(p)
	not ausschlusscode(p)
	p.mfa.op_heuwirtschaft == false
	every m in p.mfa.andere_schlagpraemien { kombizelle("3", m) == "x" }
	p.constraints.is_contract_nature_area == false
}

abrechnungsangaben(p) if not inlandsantrag(p)

abrechnungsangaben(p) if {
	not maehnutzung(p)
	gruenland_bestimmt(p)
}

abrechnungsangaben(p) if {
	gruenland_bestimmt(p)
	is_array(p.operations.cutting_dates)
	every tag in p.operations.cutting_dates { datum_gueltig(tag) }
	is_boolean(p.mfa.heuwirtschaft_beantragt)
	is_boolean(p.mfa.referenz_korrekt)
	is_boolean(p.mfa.allgemein_praemienfaehig)
	is_boolean(p.constraints.is_contract_nature_area)
	is_array(p.mfa.codes)
	is_boolean(p.mfa.op_heuwirtschaft)
	is_array(p.mfa.andere_schlagpraemien)
	every m in p.mfa.andere_schlagpraemien { is_string(kombizelle("3", m)) }
	object.get(p.mfa, "nationalpark", "fehlend") != "fehlend"
	is_boolean(p.mfa.relevante_parkauflagen)
	zugangsdaten(p)
}

zugangsdaten(p) if {
	jahr <= 2025
	is_object(p)
}

zugangsdaten(p) if p.land_use != "grassland"
zugangsdaten(p) if is_boolean(p.mfa.neuzugang_seit_2025)

zugangslimit_ha := max([5, 0.5 * vertrag.gruenland_2025_ha]) if {
	jahr >= 2026
	jahr <= 2028
	is_number(vertrag.gruenland_2025_ha)
	vertrag.gruenland_2025_ha >= 0
}

neuer_zugang(p) if {
	jahr >= 2026
	p.land_use == "grassland"
	p.mfa.neuzugang_seit_2025 == true
}

anrechenbarer_zugang(ha) := 0 if ha == 0

else := min([ha, zugangslimit_ha])

praemienflaeche_ha := bestand + anrechenbarer_zugang(zugang) if {
	flaechenliste
	every p in input.land.parcels { abrechnungsangaben(p) }
	bestand := sum([p.area_ha | some p in input.land.parcels; zahlbar(p); not neuer_zugang(p)])
	zugang := sum([p.area_ha | some p in input.land.parcels; zahlbar(p); neuer_zugang(p)])
}

# Tarifbetrag vor Verwaltungskürzungen und Zahlungsobergrenzen.
flaechenbetrag_eur := praemienflaeche_ha * satz_eur_ha if jahreszugang

gm01_eur_ha(p) := 108 if {
	vertrag_im_zeitraum
	p.constraints.is_contract_nature_area
	maehwiese(p)
	p.mfa.gm01_bestaetigt
	p.mfa.anzahl_nutzungen >= 2
	verfahren.silage_bereitet == false
}

gruenverfahren_erlaubt(v) if {
	v.gaerung_ausgeschlossen == true
	v.art in {"Grünmais sofort verfüttern", "Eingrasen"}
}

gruenverfahren_erlaubt(v) if {
	v.gaerung_ausgeschlossen == true
	v.art in {"gehäckselter Grünmais trocknen und pelletieren", "Grünfutter trocknen und pelletieren"}
	v.rasche_verbringung == true
	v.eigenverwendung == true
}

produkt_erlaubt(p) := false if p.siliert == true

else := row.zulaessig if {
	some row in tab.futterprodukte
	lower(row.produkt) == lower(p.produkt)
} else if p.siliert == false

ist_aufbereiter(g) if {
	g.trocknungszweck == true
	g.wirkung in {"quetschen", "knicken", "zerkleinern"}
}

gruentage(gruppe) := count(tage) if {
	termine := [gruppe.eingrasen, gruppe.weide, gruppe.alm, gruppe.gemeinschaftsweide]
	every liste in termine { is_array(liste); every tag in liste { datum_gueltig(tag) }}
	tage := {tag | some liste in termine; some tag in liste; tag >= sprintf("%d-04-01", [jahr]); tag <= sprintf("%d-09-30", [jahr])}
}

# Nur festgestellte Sachverhalte melden. Ein leerer Befund belegt keine Vollständigkeit.
verstoesse contains id if {
	vertrag_im_zeitraum
	some feld, id in {"silage_bereitet": "o6_3.silage.bereitung", "silage_verfuettert": "o6_3.silage.fuetterung", "silage_gelagert": "o6_3.lagerung", "altvorrat_verbraucht": "o6_3.lagerung", "folienbeduerftiges_gut_gepresst": "o6_3.silage.pressen", "einmal_gekreiselt_abgefahren": "o6_3.kreiseln", "silagenutzung_veranlasst": "o6_3.kreiseln", "heulage": "o6_3.heulage"}
	verfahren[feld] == true
}

verstoesse contains "o6_3.abgabe" if {
	vertrag_im_zeitraum
	some a in verfahren.abgaben
	is_string(a.form)
	a.form != "trockenes Heu"
}

verstoesse contains "o6_3.nebenprodukt" if {
	vertrag_im_zeitraum
	some p in verfahren.futtermittel
	produkt_erlaubt(p) == false
}

verstoesse contains "o6_3.gruenmais" if {
	vertrag_im_zeitraum
	some v in verfahren.gruenverfahren
	v.gaerung_ausgeschlossen == false
}

verstoesse contains "o6_3.gruenfuetterung" if {
	vertrag_im_zeitraum
	verfahren.heu_gewonnen == false
}

verstoesse contains "o6_3.gruenfuetterung" if {
	vertrag_im_zeitraum
	some gruppe in verfahren.raufuttergruppen
	gruppe.ganze_periode_am_betrieb == true
	gruentage(gruppe) < 92
}

verstoesse contains "o6_3.option.einsatz" if {
	option_beantragt
	some g in verfahren.geraete
	ist_aufbereiter(g)
	g.eingesetzt == true
}

verstoesse contains "o6_3.option.besitz" if {
	option_beantragt
	some g in verfahren.geraete
	ist_aufbereiter(g)
	g.am_betrieb == true
}

privater_traeger(a) if a.personenart in {"natürliche Person", "eingetragene Personengesellschaft"}

privater_traeger(a) if {
	a.personenart in {"juristische Person", "Personenvereinigung"}
	is_number(a.oeffentlicher_anteil_prozent)
	a.oeffentlicher_anteil_prozent >= 0
	a.oeffentlicher_anteil_prozent <= 25
}

person_zulaessig if {
	privater_traeger(antrag)
	antrag.oeffentlich_beherrscht == false
	antrag.eigener_name_rechnung
	antrag.verfuegungsgewalt
	antrag.aktiver_landwirt
	antrag.landwirtschaftliche_taetigkeit
}

betriebsgroesse_erfuellt if antrag.erstes_oepul_jahr < jahr

betriebsgroesse_erfuellt if {
	antrag.erstes_oepul_jahr == jahr
	antrag.geschuetzt_at_ha >= 0.5
}

betriebsgroesse_erfuellt if {
	antrag.erstes_oepul_jahr == jahr
	antrag.mindestgroesse_at_ha >= 1.5
}

uebernahme_stichtag(y) := "04-17" if y in {2023, 2028}

else := "04-15"

uebernahme_moeglich if {
	u := input.farm.massnahmenuebernahme
	u.vorher_teilgenommen == false
	u.ama_genehmigt == true
	u.uebernommen_ha > 0
	u.zusatz_ha >= 0
	u.zusatz_ha <= 0.5 * u.uebernommen_ha
	datum_gueltig(u.mfa_datum)
	jahr >= 2023
	jahr <= 2028
	u.mfa_datum >= sprintf("%d-01-01", [jahr])
	u.mfa_datum <= sprintf("%d-%s", [jahr, uebernahme_stichtag(jahr)])
}

abgang_toleranz_ha := max([0.5, min([5, 0.05 * vertrag.vorjahr_gebunden_ha])]) if {
	vertrag.vorjahr_gebunden_ha >= 0
}

rueckzahlung_differenz_ha := vertrag.relevanter_abgang_ha if {
	vertrag.relevanter_abgang_ha > abgang_toleranz_ha
} else := 0 if {
	vertrag.relevanter_abgang_ha >= 0
	vertrag.relevanter_abgang_ha <= abgang_toleranz_ha
}

obergrenze_eur_ha(gruppe, y) := row.eur_ha if {
	some row in tab.obergrenzen
	row.gruppe == gruppe
	y >= row.ab
	y <= row.bis
}

stufenende(ha, bis) := ha if bis == null

else := min([ha, bis])

modulationsfaktor := sum(beitraege) / ha if {
	ha := antrag.heimflaeche_ha
	ha > 0
	beitraege := [betrag | some row in tab.modulation; betrag := max([0, stufenende(ha, row.bis) - row.von]) * row.faktor]
}

kuerzungsprozent := row.prozent if {
	some row in tab.sanktionsstufen
	antrag.kuerzungsstufe == row.stufe
	jahr >= object.get(row, "ab", 2023)
	jahr <= object.get(row, "bis", 2028)
}

sanktionsausschluss if antrag.anzahl_vollkuerzungen >= 2

kulturgruppe(name, y) := row.gruppe if {
	some row in tab.kulturen
	lower(row.kultur) == lower(name)
	y >= row.ab
}

vertragsart(code) := row.art if {
	some row in tab.vertragsarten
	row.massnahme == code
}

uebernahme_sonderfall(code) if code in tab.uebernahme_sonderfaelle

wechselpaar(von, nach, y) if {
	some r in tab.wechselpaare
	r.von == von
	r.nach == nach
	y >= 2023
	y <= r.bis
}

div_variante(code) := r.nutzungsregel if {
	some r in tab.div_varianten
	r.code == code
}

div_wechsel(von, nach, tag) if {
	jahr == 2026
	datum_gueltig(tag)
	some r in tab.div_wechsel
	r.von == von
	r.nach == nach
	tag > "2026-04-15"
	tag <= concat("", ["2026-", r.bis])
}

gebietszeile(r, d) if {
	r.land == d.bundesland
	r.bezirk == "alle Bezirke"
}

gebietszeile(r, d) if {
	r.land == d.bundesland
	r.bezirk == d.bezirk
}

ernteausnahme_2026(p) if {
	jahr == 2026
	p.land_use == "arable"
	not ackerfutter(p)
	futterangaben(p)
	p.mfa.in_at
	p.duerre.spaetsommer_herbstkultur
	p.duerre.hitze_und_trockenheit
	p.duerre.erntbarer_bestand == false
	some row in tab.duerregebiete_2026
	gebietszeile(row, p.duerre)
}

nat_kapitelzelle(a, b) := tab.nat_kapitelkombination[a][b]

schwein_gve(kategorie) := row.gve_pro_stueck if {
	some row in tab.schweine_gve
	row.kategorie == kategorie
}

# Die Nutzungsgruppe richtet sich nach den beantragten Flächen und dem Produktionsstatus.
mindestbewirtschaftung(p, gruppe) if {
	gruppe == "Grünland/Ackerfutter"
	jahr in p.bewirtschaftung.vollmahd_mit_abtransport_jahre
}

mindestbewirtschaftung(p, gruppe) if {
	gruppe == "Grünland/Ackerfutter"
	jahr in p.bewirtschaftung.vollweide_jahre
}

mindestbewirtschaftung(p, gruppe) if {
	gruppe == "Bergmähder"
	some y in p.bewirtschaftung.vollmahd_mit_abtransport_jahre
	y in {jahr, jahr - 1}
}

mindestbewirtschaftung(p, gruppe) if {
	gruppe in {"Acker ohne Ackerfutter", "geschützter Anbau"}
	p.bewirtschaftung.anbau_ordnungsgemaess
	p.bewirtschaftung.jaehrliche_pflege
	p.bewirtschaftung.ernte_und_abtransport_prozent >= 85
}

mindestbewirtschaftung(p, gruppe) if {
	gruppe == "Acker ohne Ackerfutter"
	p.bewirtschaftung.anbau_ordnungsgemaess
	p.bewirtschaftung.jaehrliche_pflege
	ernteausnahme_2026(p)
}

mindestbewirtschaftung(p, gruppe) if {
	gruppe == "aus Produktion"
	grundecke(p.bewirtschaftung)
	some y in p.bewirtschaftung.pflege_jahre
	y in {jahr, jahr - 1}
}

grundecke(b) if b.grundecke == true
grundecke(b) if b.selbstbegruenung_1c == true

# Prüfung der zeitlichen DIV-Ausnahmen aus den zwei Veröffentlichungen.
div_op(d) if {
	d.op_massnahme in {"OPUBB", "OPBIO"}
	d.andere_vorgaben == false
}

mindestabstand_tage(frueher, spaeter) := (b - a) / 86400000000000 if {
	datum_gueltig(frueher)
	datum_gueltig(spaeter)
	a := time.parse_ns("2006-01-02", frueher)
	b := time.parse_ns("2006-01-02", spaeter)
}

div_nfz_abstand(d) := 49 if {
	jahr == 2026
	d.variante == "DIVNFZ"
	d.trockenheitsausnahme
	div_op(d)
} else := 63 if d.variante == "DIVNFZ"

div_nfz_zeitlich_erfuellt(p) if {
	d := p.div_nutzung
	termine := sort({t | some t in d.nutzungstage; datum_gueltig(t); startswith(t, sprintf("%d-", [jahr]))})
	count(termine) >= 2
	mindestabstand_tage(termine[0], termine[1]) >= div_nfz_abstand(d)
}

divsz_vorzeitig(p, tag) if {
	jahr == 2026
	d := p.div_nutzung
	d.variante == "DIVSZ"
	d.trockenheitsausnahme
	div_op(d)
	tage := d.bezirk_vorverlegung_tage
	tage in {4, 5, 6, 7}
	datum_gueltig(d.zweite_vergleichsmahd)
	startswith(d.zweite_vergleichsmahd, "2026-")
	d.zweite_vergleichsmahd <= tag
	startswith(tag, "2026-")
	mindestabstand_tage(tag, "2026-06-15") <= tage + 14
}

div_drittnutzung_2026(p) if {
	jahr == 2026
	p.land_use == "arable"
	p.constraints.biodiversity_area.is_biodiversity_area
	div_op(p.div_nutzung)
	count(p.div_nutzung.nutzungstage) == 3
	every t in p.div_nutzung.nutzungstage { datum_gueltig(t); startswith(t, "2026-")}
}

# Aus den vorhandenen Angaben nachweisbare Zugangsprobleme.
zugangsprobleme contains "o6_3.kombination" if {
	vertrag_im_zeitraum
	is_array(vertrag.parallele_massnahmen)
	not kombination_erfuellt
}

zugangsprobleme contains "o6_3.einstieg.flaeche" if {
	vertrag_im_zeitraum
	jahr == vertrag.erstes_teilnahmejahr
	einstiegsflaeche_ha < 2
}

zugangsprobleme contains "o6_3.einstieg.tiere" if {
	vertrag_im_zeitraum
	jahr == vertrag.erstes_teilnahmejahr
	tierhaltend == false
}

zugangsstatus := "Voraussetzung verfehlt" if count(zugangsprobleme) > 0

else := "erfüllt" if jahreszugang

else := "außerhalb Vertragszeitraum" if {
	is_number(jahr)
	is_number(vertrag.vertragsbeginn)
	is_number(vertrag.erstes_teilnahmejahr)
	not vertrag_im_zeitraum
} else := "Angaben fehlen"

kennzahlen["einstiegsflaeche_ha"] := einstiegsflaeche_ha
kennzahlen["futter_ha"] := futter_ha
kennzahlen["rgve"] := rgve
kennzahlen["tierhaltend"] := tierhaltend
kennzahlen["praemienflaeche_ha"] := praemienflaeche_ha
kennzahlen["satz_eur_ha"] := satz_eur_ha
kennzahlen["formaler_und_fachlicher_zugang_belegt"] if formaler_zugang
kennzahlen["flaechenbetrag_eur"] := flaechenbetrag_eur
kennzahlen["modulationsfaktor"] := modulationsfaktor

pruefung := {
	"massnahmenspezifischer_jahreszugang": zugangsstatus,
	"zugangsprobleme": zugangsprobleme,
	"festgestellte_bewirtschaftungsverstoesse": verstoesse,
	"kennzahlen": kennzahlen,
}

oeffentliche_massnahme(code, y) if {
	some r in tab.oeffentliche_ausnahmen
	r.massnahme == code
	y >= r.ab
	y <= r.bis
}

befreite_nutzung(code, massnahme, y) if {
	some r in tab.bewirtschaftungsausnahmen
	code == r.code
	massnahme in r.massnahmen
	y >= r.ab
	y <= r.bis
}

zulaessige_umwandlung(von, nach, massnahme) if {
	some r in tab.umwandlungen
	von in r.von
	nach in r.nach
	umwandlung_massnahme(r.massnahmen, massnahme)
}

umwandlung_massnahme(liste, code) if {
	count(liste) == 0
	is_string(code)
}

umwandlung_massnahme(liste, code) if code in liste

ebw_heutrocknung(code, anzahl_maehden, y) if {
	anzahl_maehden >= 2
	code in {"GM01", "GM02"}
	y >= 2023
}

ebw_heutrocknung(code, anzahl_maehden, y) if {
	anzahl_maehden >= 2
	code == "BH01"
	y >= 2025
}

op_wegen_weitergabe(p) if {
	p.foerderumstand.art == "unterjährige Weitergabe"
	p.foerderumstand.nachfolger_fuehrt_fort == false
}

op_wegen_ueberschneidung(p) if p.foerderumstand.oeffentliche_ueberschneidung == true
op_wegen_fremdverschulden(p) if p.foerderumstand.reines_fremdverschulden == true

teilzahlung_max_eur(voraussichtlicher_betrag) := voraussichtlicher_betrag * 0.75 if {
	input.documentation.oepul_verfahren.verwaltungskontrollen_abgeschlossen == true
	is_number(voraussichtlicher_betrag)
	voraussichtlicher_betrag >= 0
}

konditionalitaet_erfuellt if {
	input.documentation.oepul_verfahren.konditionalitaet_erfuellt == true
	input.documentation.oepul_verfahren.soziale_konditionalitaet_erfuellt == true
}

kontrollvereitelung if {
	kontrollverfahren := input.documentation.oepul_verfahren
	kontrollverfahren.kontrolle_verhindert == true
	kontrollverfahren.aussergewoehnliche_umstaende_anerkannt == false
}

# Ein Leistungsmerkmal betrifft die Bereitung zur anschließenden Eigenverwendung.
verstoesse contains "o6_3.gruenmais" if {
	vertrag_im_zeitraum
	some v in verfahren.gruenverfahren
	v.art in {"gehäckselter Grünmais trocknen und pelletieren", "Grünfutter trocknen und pelletieren"}
	false in [object.get(v, "rasche_verbringung", null), object.get(v, "eigenverwendung", null)]
}

mindestbewirtschaftung(p, gruppe) if {
	gruppe in {"Dauer- und Spezialkultur", "Wein"}
	p.bewirtschaftung.anbau_ordnungsgemaess
	p.bewirtschaftung.jaehrliche_pflege
	p.bewirtschaftung.ernte_und_verbringen
}

# Herkunft des bestehenden Vertrags und formale Eingangsvoraussetzungen.
vertragseinstieg_belegt if {
	vertrag.einstiegsart == "Neuantrag"
	vertrag.erstes_teilnahmejahr == vertrag.vertragsbeginn
	neuantrag_fristgerecht
	vertrag.ama_genehmigt
}

vertragseinstieg_belegt if {
	vertrag.einstiegsart == "Übernahme"
	uebernahme_moeglich with jahr as vertrag.erstes_teilnahmejahr
}

vertragseinstieg_belegt if {
	vertrag.einstiegsart == "Bewirtschafterwechsel"
	vertrag.fortgefuehrter_vertrag
}

formaler_zugang if {
	jahreszugang
	person_zulaessig
	betriebsgroesse_erfuellt
	vertragseinstieg_belegt
	vertrag.zahlungsantrag_im_jahr
}
