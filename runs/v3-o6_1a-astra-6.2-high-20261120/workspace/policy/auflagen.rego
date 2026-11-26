package oepul.o6_1a

import data.ubb_tabellen as t
import rego.v1

antragsfrist_ok(beginn, datum) if {
	some z in t.vertraege
	z.beginn == beginn
	tag(datum) <= stichtag(beginn - 1, "12-31")
}

wechselziel(von, nach, jahr) if {
	some z in t.massnahmenwechsel
	z.von == von
	z.nach == nach
	jahr <= z.letztjahr
}

projektkapitel("T") := "A"
projektkapitel(k) := k if k != "T"

projektkombination(a, b) := z.zeichen if {
	some z in t.projektmatrix
	z.von == projektkapitel(a)
	z.nach == projektkapitel(b)
}

projektpflege(code) := z if {
	some z in t.projektpflege
	z.code == code
}

kuerzungsreihenfolge := t.reihenfolge_kuerzungen

gruenlandvariante(code) := z if {
	some z in t.div_varianten
	z.code == code
}

ist_getreide(name) if name in t.getreide
ist_feldgemuese(name) if name in t.feldgemuese

ist_obst(name, jahr) if {
	some z in t.obstarten
	z.art == name
	jahr >= z.ab
}

bhg_kultur(name) if name in t.bhg

altbegruenung_ok(nutzung, code) if {
	nutzung == "Grünbrache"
	code == ""
}

altbegruenung_ok(nutzung, code) if {
	nutzung in t.ackerfutter
	code in t.altcodes
}

altbegruenung_ok(nutzung, code) if {
	nutzung == "Grünbrache"
	code in t.altcodes
}

biomittel_ok(p) if p.operations.psm_used == false

biomittel_ok(p) if {
	p.operations.psm_used
	p.operations.nur_bio_wirkstoffe
}

punktfoerderzahl(anzahl, feld_ha) := min([anzahl, floor(80 * feld_ha)])
seltene_flaeche(ha) := min([ha, 10]) if ha >= 0
wildkraeuter_flaeche(ha) := min([ha, 20]) if ha >= 0

brache_basis(ha, acker) := min([ha, 0.2 * acker]) if {
	ha >= 0
	acker >= 0
}

div_zuschlagsflaeche(ha, basis) := min([ha, basis * 0.2]) if {
	ha >= 0
	basis >= 0
}

bodenzahl(teile) := sum([wert | some z in teile; wert := z.ha * z.zahl]) / sum([z.ha | some z in teile]) if {
	count(teile) > 0
	every z in teile { z.ha > 0; is_number(z.zahl)}
}

bodenzuschlag_ok("arable", teile) if bodenzahl(teile) >= 50
bodenzuschlag_ok("grassland", teile) if bodenzahl(teile) >= 30

wb_anlage_ok(p, jahr) if {
	p.land_use == "arable"
	p.wb.getreideanteil_prozent >= 50
	p.wb.doppelter_reihenabstand
	p.wb.reihenabstand_cm >= 20
	p.wb.untersaat == false
	tag(p.wb.anbau) < stichtag(jahr, "03-15")
}

wb_sperrtag(jahr, datum, drusch) if {
	tag(datum) >= stichtag(jahr, "03-15")
	tag(datum) <= stichtag(jahr, "06-30")
	drusch == null
}

wb_sperrtag(jahr, datum, drusch) if {
	tag(datum) >= stichtag(jahr, "03-15")
	tag(datum) <= min([tag(drusch), stichtag(jahr, "06-30")])
}

lse_topup_eur(hang, maehha, bundesland_bewilligt, fristgerecht, mittel) := 50 * maehha if {
	hang >= 50
	bundesland_bewilligt
	fristgerecht
	mittel
}

antragsteller_ok(p) if {
	p.aktiv
	p.eigener_name_rechnung
	p.verfuegungsgewalt
	p.landwirtschaftliche_taetigkeit
	p.gebietseinrichtung == false
	personenkreis_ok(p)
}

personenkreis_ok(p) if p.rechtsform in {"Natürliche Person", "Eingetragene Personengesellschaft"}

personenkreis_ok(p) if {
	p.rechtsform in {"Juristische Person", "Personenvereinigung"}
	is_number(p.gebietskoerperschaft_prozent)
	p.gebietskoerperschaft_prozent <= 25
}

kurs_ok(k) if {
	k.anerkannter_anbieter
	k.biodiversitaet
	k.datum >= "2022-01-01"
	k.datum <= "2025-12-31"
	k.anderweitig_angerechnet == false
	k.stunden > 0
}

bis_stichtag_gebunden(austritt) if austritt == null

bis_stichtag_gebunden(austritt) if {
	is_string(austritt)
	austritt >= "2025-12-31"
}

geschulte_person_ok(person) if {
	person.betriebsrolle in {"Betriebsleitung", "Betrieblich erforderlich und maßgeblich mitbewirtschaftend"}
	bis_stichtag_gebunden(person.austritt)
	kurse := [k | some k in person.kurse; kurs_ok(k)]

	# Eine Veranstaltung kann derselben Person nur einmal gutgeschrieben werden.
	count(kurse) == count({k.veranstaltung_id | some k in kurse})
	sum([k.stunden | some k in kurse]) >= 3
}

bildung_erfuellt if {
	some p in input.documentation.biodiversitaetsschulung
	geschulte_person_ok(p)
}

# Sämtliche Ereignisse eines Schlages sind chronologisch und vollständig zu liefern.
reinigung_ohne_abfuhr(e, p, jahr) if {
	jahr >= 2025
	e.art == "Reinigungsschnitt"
	e.abtransport == false
	p.div.neuansaat_erstes_antragsjahr
}

weidenachpflege(e, jahr) if {
	jahr >= 2025
	e.art in {"Häckseln", "Pflegemahd"}
	e.unmittelbar_nach_weide
	e.abtransport == false
}

zaehlt_acker(e, p, jahr) if {
	e.art in {"Mahd", "Häckseln", "Weide", "Reinigungsschnitt", "Pflegemahd"}
	not weidenachpflege(e, jahr)
	not reinigung_ohne_abfuhr(e, p, jahr)
}

max_nutzungen(p, jahr) := 3 if dritte_nutzung(p, jahr)

else := 2

acker_pflegeanzahl(p, jahr) := n if {
	is_array(p.operations.nutzungen)
	n := count([1 | some e in p.operations.nutzungen; zaehlt_acker(e, p, jahr)])
}

rs_brache_pflege_ok(p, jahr) if {
	jahr >= 2025
	p.mfa.nutzungsart == "Grünbrache"
	"DIVRS" in p.mfa.codes
	p.land_use == "arable"
	is_array(p.operations.nutzungen)
	anzahl := count(p.operations.nutzungen)
	anzahl <= 1
	anzahl + p.div.zaehlbare_pflege_vorjahr >= 1
	every e in p.operations.nutzungen { rs_brache_termin_ok(e, p, jahr) }
}

rs_brache_termin_ok(e, _, jahr) if {
	e.art == "Häckseln"
	tag(e.datum) >= stichtag(jahr, "10-01")
}

rs_brache_termin_ok(e, p, jahr) if reinigung_ohne_abfuhr(e, p, jahr)

rs_feldfutter_pflege_ok(p, jahr) if {
	p.mfa.nutzungsart == "Sonstiges Feldfutter"
	"DIVRS" in p.mfa.codes
	p.land_use == "arable"
	ereignisse := p.operations.nutzungen
	every e in ereignisse { rs_feldfutter_ereignis_ok(e, p, jahr) }
	schnitte := [1 | some e in ereignisse; e.abtransport]
	count(schnitte) in {1, 2}
}

rs_feldfutter_ereignis_ok(e, _, _) if {
	e.art == "Mahd"
	e.abtransport
}

rs_feldfutter_ereignis_ok(e, p, jahr) if reinigung_ohne_abfuhr(e, p, jahr)

rs_feldfutter_ereignis_ok(e, p, jahr) if {
	jahr >= 2025
	e.art == "Reinigungsschnitt"
	e.abtransport
	p.div.neuansaat_erstes_antragsjahr
}

agf_folge_ok(p) if p.div.verfuegungsgewalt_verloren

agf_folge_ok(p) if {
	p.div.lagegleich
	"DIVSZ" in p.mfa.codes
}

sanierung_ohne_meldung(p) if {
	p.div.ordnungsgemaess_fristgerecht_angelegt
	p.div.stark_verunkrautet
	p.div.nachweise_aufbewahrt
	p.div.zug_um_zug
}

pruefwerte["Biodiversitätsflächen"] := div_bilanz
pruefwerte["Feldstücke"] := feldbilanzen
pruefwerte["Anbaudiversifizierung"] := diversifizierung
pruefwerte["Tierhaltender Betrieb"] := tierhaltend
pruefwerte["Schlagbefunde"] := schlagbefunde
pruefwerte["Förderwürdige Ackerkulturen vor Modulation (Euro)"] := kulturzuschlag_eur
pruefwerte["Grünlandumwandlung innerhalb der Toleranz"] := gruenlandtoleranz_ok
pruefwerte["RGVE im Inland"] := rgve_bestand
