package oepul.o6_14

import data.almtabellen as tab
import rego.v1

ernteausnahme(f, y) if {
	y == 2026
	f.nutzungsart == "A"
	f.spaetkultur
	f.duerre_kein_erntbarer_bestand
	some zeile in tab.duerre_acker_bezirke
	zeile.land == f.bundesland
	zeile.bezirk in {"*", f.bezirk}
}

# Die Listen verwenden die Bezeichnungen und Einschränkungen des Merkblatts.
vertragsklasse(m) := "mehrjaehrig" if m in tab.mehrjaehrige_massnahmen

else := "einjaehrig" if m in tab.einjaehrige_massnahmen

zugangsbegrenzung_gelistet(m) if m in tab.flaechenzugang_begrenzt
einzelfalluebernahme_gelistet(m) if m in tab.uebernahme_einzelfall
ausnahmekatalog := {
	"oeffentliche_traeger": tab.oeffentliche_ausnahmen,
	"mindestbewirtschaftung": tab.bewirtschaftungsausnahmen,
}

feststellungen contains {"regel": "o6_14.almdauer", "alm": id, "tage": w.bestossungstage} if {
	some id, w in almwerte
	w.mindestdauer_erreicht == false
}

feststellungen contains {"regel": "o6_14.besatz", "alm": id, "besatz": w.besatz_rgve_ha, "grenze": w.grenze_rgve_ha} if {
	some id, w in almwerte
	w.ueberbesatz
}

feststellungen contains {"regel": "o6_14.ausschluss_option", "alm": a.id} if {
	some a in antrag.almen
	a.naturschutz
	some andere in antrag.almen
	andere.almweideplan
}

feststellungen contains {"regel": "o6_14.feldliste", "alm": a.id} if {
	some a in antrag.almen
	tag(a.feldliste_am) > tag(feldfrist(jahr))
}

feststellungen contains {"regel": "o6_14.auftriebsliste", "alm": a.id} if {
	some a in antrag.almen
	tag(a.auftriebsliste_am) > tag(listenfrist(jahr))
	not listenbefreiung(a, antrag.tiere, jahr)
}

feststellungen contains {"regel": "o6_14.futterbasis", "alm": a.id} if {
	some a in antrag.almen
	a.natuerliches_futter_ausreichend == false
}

feststellungen contains {"regel": "o6_14.psm", "alm": a.id, "schlag": e.parcel_id} if {
	some a in antrag.almen
	some e in a.psm
	some w in e.wirkstoffe
	w.bio_2018_848 == false
}

feststellungen contains {"regel": "o6_14.natabau", "alm": a.id, "eingriff": e.art} if {
	some a in antrag.almen
	a.naturschutz
	some e in a.eingriffe
	e.art in {"Gelaendekorrektur", "Neuentwaesserung"}
}

optionstarif(a, ha, y) := 0 if {
	a.naturschutz == false
	a.almweideplan == false
}

else := planzuschlag(ha, y) if {
	a.almweideplan
	a.naturschutz == false
}

else := gesamt if {
	a.naturschutz
	a.almweideplan == false
	auflagen := a.projekt.auflagen
	is_array(auflagen)
	saetze := [projektsatz(p.code, p.anteil_prozent, y) | some p in auflagen]
	count(saetze) == count(auflagen)
	count({substring(p.code, 0, 3) | some p in auflagen}) == count(auflagen)
	gesamt := ha * (natursatz(y) + sum(saetze))
}

# Tarifrechnung vor Bescheid und Abstufung wegen Verstößen. Liefert erst
# einen Betrag bei vollständigen Berechnungsdaten und vereinbaren Optionen.
tarifbetraege[a.id] := {"basis_eur": basis, "zuschlag_eur": zusatz, "modulationsfaktor": faktor, "moduliert_eur": (basis + zusatz) * faktor} if {
	some a in antrag.almen
	not betriebsweiter_optionskonflikt
	w := almwerte[a.id]
	w.mindestdauer_erreicht
	w.ueberbesatz == false
	basis := w.grundpraemie_vor_modulation_eur
	zusatz := optionstarif(a, w.praemienflaeche_ha_vor_auflagenpruefung, jahr)
	faktor := betriebsfaktor
}

betriebsweiter_optionskonflikt if {
	some a in antrag.almen
	a.naturschutz
	some b in antrag.almen
	b.almweideplan
}

alm_lage(f) if f.almkataster
alm_lage(f) if f.almgebiet
alm_grenze(f) if f.sichtbarer_unterschied
alm_grenze(f) if f.deutliche_grenze
alm_bewuchs(f) if f.futtervegetation
alm_bewuchs(f) if f.feuchtstandortbewuchs

almweideflaeche(f) if {
	f.beweidet
	f.vom_heimgut_bewirtschaftet == false
	alm_lage(f)
	alm_grenze(f)
	alm_bewuchs(f)
}

# Die Vergleichbarkeit ist ein erhobener Sachverhalt. Bei einer nicht
# ganzzahligen Mittelstufe ist eine behördliche Einstufung erforderlich.
erschliessung(teile, vergleichbar) := stufe if {
	count(teile) > 0
	every teil in teile { teil.stufe in {1, 2, 3} }
	count({t.stufe | some t in teile}) == 1
	stufe := teile[0].stufe
	is_boolean(vergleichbar)
}

else := stufe if {
	vergleichbar == false
	every t in teile { is_number(t.rgve_tage); t.rgve_tage >= 0; t.stufe in {1, 2, 3}}
	hoechste := max([t.rgve_tage | some t in teile])
	stufen := {t.stufe | some t in teile; t.rgve_tage == hoechste}
	count(stufen) == 1
	some stufe in stufen
}

else := stufe if {
	vergleichbar == true
	count(teile) > 0
	every t in teile { t.stufe in {1, 2, 3} }
	stufe := sum([t.stufe | some t in teile]) / count(teile)
	stufe in {1, 2, 3}
}

erschliessungsbezug(gebaeude, teil) if {
	gebaeude
	is_number(teil.zentrumsabstand_m)
	teil.zentrumsabstand_m >= 0
	teil.zentrumsabstand_m <= 50
}

erschliessungsbezug(gebaeude, teil) if {
	gebaeude == false
	teil.zugang_zur_flaeche
}

# Rückgabe benennt das Verfahren. Die Anerkennung selbst trifft die AMA.
abgangsverfahren(t, s) := "Erneut mit neuer Heimbetriebsnummer aufmelden" if {
	t.art in {"Schaf", "Ziege"}
	true in [t.tierwohl_weide, t.rassenerhaltung]
	s.abgangsgrund == "Verkauf"
	s.verkauf_ohne_abtrieb
}

else := "Automatischer Abtrieb aus der Abgangsmeldung am Heimbetrieb" if {
	t.art in {"Schaf", "Ziege"}
	true in [t.tierwohl_weide, t.rassenerhaltung]
	s.abgangsgrund in {"Verkauf", "Verendung", "Schlachtung"}
}

meldeart(art) := {"formular": "Alm-/Weidemeldung Rinder", "einheit": "Einzeltier"} if art == "Rind"

else := {"formular": "Alm/Gemeinschaftsweide-Auftriebsliste", "einheit": "Einzeltier mit Ohrmarke"} if art in {"Schaf", "Ziege"}

else := {"formular": "Alm/Gemeinschaftsweide-Auftriebsliste", "einheit": "Stück"} if art in {"Equide", "Neuweltkamel"}

kursbestaetigung(k) if k.bestaetigung_angefordert == false
kursbestaetigung(k) if k.uebermittlung_durch_anbieter
kursbestaetigung(k) if k.bestaetigung_uebermittelt

natur_pruefung[a.id] := {"projekt_und_codierung": projekt, "weiterbildung": kurs} if {
	some a in antrag.almen
	a.naturschutz
	is_array(a.projekt.schlaege)
	is_array(antrag.personen)
	projekt := count({1 | naturschutz_voraussetzungen(a, jahr)}) == 1
	kurs := count({1 | weiterbildung_erfuellt(antrag.personen, "Naturschutz", antrag.naturschutz_startjahr)}) == 1
}

plan_pruefung := {"plan_alle_almen": plaene, "weiterbildung": kurs} if {
	some a in antrag.almen
	a.almweideplan
	is_array(antrag.personen)
	planjahr(antrag.plan_startjahr)
	plaene := count({1 | plan_erfuellt(antrag.almen, jahr, antrag.plan_startjahr)}) == 1
	kurs := count({1 | weiterbildung_erfuellt(antrag.personen, "Almweideplan", antrag.plan_startjahr)}) == 1
}

# Datum und Gegenstand eines MFA-Eintrags werden getrennt geprüft.
feldliste_fristgerecht(a, y) if tag(a.feldliste_am) <= tag(feldfrist(y))
listenpflicht_erfuellt(a, tiere, y) if listenbefreiung(a, tiere, y)

listenpflicht_erfuellt(a, tiere, y) if {
	is_array(tiere)
	tag(a.auftriebsliste_am) <= tag(listenfrist(y))
}

feststellungen contains {"regel": "o6_14.silage", "alm": a.id, "futtergabe": i} if {
	some a in antrag.almen
	some i, f in a.futtergaben
	f.art == "Silage"
	f.almeigen == false
}

feststellungen contains {"regel": "o6_14.silage", "alm": a.id, "futtergabe": i} if {
	jahr < 2025
	some a in antrag.almen
	some i, f in a.futtergaben
	f.art == "Silage"
}

feststellungen contains {"regel": "o6_14.silage", "alm": a.id, "futtergabe": i} if {
	jahr >= 2025
	some a in antrag.almen
	some i, f in a.futtergaben
	f.art == "Silage"
	f.almeigen
	f.gesamt_auf_erzeugeralm == false
}

feststellungen contains {"regel": "o6_14.gruenfutter", "alm": a.id, "futtergabe": i} if {
	some a in antrag.almen
	some i, f in a.futtergaben
	f.art == "Gruenfutter"
	f.almeigen == false
}

feststellungen contains {"regel": "o6_14.herkunft", "alm": a.id, "duengung": i} if {
	some a in antrag.almen
	some i, d in a.duengungen
	d.art in {"Klaerschlamm", "Kompostierter_Klaerschlamm"}
}

feststellungen contains {"regel": "o6_14.herkunft", "alm": a.id, "duengung": i} if {
	some a in antrag.almen
	some i, d in a.duengungen
	d.art in {"Jauche", "Guelle", "Separierte_Guelle"}
	d.im_almstall_angefallen == false
}

feststellungen contains {"regel": "o6_14.duenger", "alm": a.id, "duengung": i} if {
	some a in antrag.almen
	some i, d in a.duengungen
	d.bio_2018_848 == false
}

feststellungen contains {"regel": "o6_14.nataduenger", "alm": a.id, "duengung": i} if {
	some a in antrag.almen
	a.naturschutz
	some i, d in a.duengungen
	d.standort in {"Moor", "Feuchtflaeche", "Kalkmagerrasen", "Silikatmagerrasen"}
	d.borstgrasrasen == false
}

feststellungen contains {"regel": "o6_14.almstall", "tier": t.id} if {
	some t in antrag.tiere
	t.almstall_grund in {"Arbeitswirtschaft", "Tiergesundheit"}
	t.almstall_stunden > 12
}

feststellungen contains {"regel": "o6_14.melken", "tier": t.id} if {
	some t in antrag.tiere
	t.heimstall_nur_melken == false
}

feststellungen contains {"regel": "o6_14.weideausfall", "tier": t.id, "folge": "AMA-Meldung und keine Tierprämie"} if {
	some t in antrag.tiere
	t.weidezugang == false
}

feststellungen contains {"regel": "o6_14.natatraenke", "alm": a.id, "eingriff": i} if {
	some a in antrag.almen
	a.naturschutz
	some i, e in a.eingriffe
	e.art == "Traenkestelle"
	true in [object.get(e, "feuchtflaeche", null), object.get(e, "quellflur", null)]
}

div_variante(code) := row if {
	some row in tab.div_varianten_2026
	row.code == code
}

div_wechsel(von, nach, datum) if {
	some w in tab.div_variantenwechsel
	w.von == von
	w.nach == nach
	tag(datum) > tag("2026-04-15")
	tag(datum) <= tag(termin(2026, w.bis))
}

jaehrlich_verfuegbare_einheiten(m) if m in tab.jaehrlich_verfuegbar
ausgeschlossene_nutzung(nutzung) if nutzung in tab.nicht_foerderfaehige_nutzungen
