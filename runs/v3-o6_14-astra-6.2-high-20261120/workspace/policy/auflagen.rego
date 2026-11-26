package oepul.o6_14

import data.almtabellen as tab
import rego.v1

default futter_zulaessig(_, _) := false

futter_zulaessig(f, y) if {
	f.art in {"Heu", "Gruenfutter"}
	f.almeigen
	y >= 2023
}

futter_zulaessig(f, y) if {
	y >= 2023
	[f.art, f.zweck] in {["Heu", "Rohfaserausgleich"], ["Mineralstoff", "Mangelvermeidung"], ["Kraftfutter", "Milchleistung"]}
}

futter_zulaessig(f, y) if {
	y >= 2025
	f.art == "Silage"
	f.almeigen
	f.eigenalm_heuwirtschaft == false
}

silage_verbleib(f, y) if {
	y >= 2025
	f.almeigen
	f.art == "Silage"
	f.gesamt_auf_erzeugeralm
	f.eigenalm_heuwirtschaft == false
}

psm_zulaessig(wirkstoffe) if {
	count(wirkstoffe) > 0
	every w in wirkstoffe { w.bio_2018_848 == true }
}

psm_code(f, y) := null if y >= 2026

else := null if f.flaechig == false

else := tab.psm_codes.chemisch_synthetisch if {
	f.flaechig
	f.chemisch_synthetisch
}

else := tab.psm_codes.bio if {
	f.flaechig
	f.chemisch_synthetisch == false
	f.bio_einsatz
}

else := null if {
	f.bio_einsatz == false
	f.chemisch_synthetisch == false
}

duenger_stoff(d) if {
	d.art in {"Guelle", "Jauche"}
	d.im_almstall_angefallen
}

duenger_stoff(d) if {
	d.art in {"Mist", "Sonstiger", "Mineralduenger", "Kompost"}
}

duenger_stoff(d) if {
	d.art == "Separierte_Guelle"
	d.im_almstall_angefallen
}

flaechenduengung(d) if d.naturschutz == false

flaechenduengung(d) if {
	d.naturschutz
	d.borstgrasrasen
}

flaechenduengung(d) if {
	d.naturschutz
	d.standort in {"Sonstiger", "Borstgrasrasen"}
}

duenger_zulaessig(d) if {
	d.bio_2018_848
	duenger_stoff(d)
	flaechenduengung(d)
}

natur_eingriff(e) if {
	e.art == "Drainageertuechtigung"
	e.einvernehmen_land
}

natur_eingriff(e) if {
	e.art == "Traenkestelle"
	e.feuchtflaeche == false
	e.quellflur == false
}

naturschutz_voraussetzungen(a, y) if {
	a.naturschutz
	a.projekt.landesbestaetigung
	a.projekt.vollstaendige_schlagliste
	count(a.projekt.schlaege) > 0
	every f in a.projekt.schlaege {
		f.bestaetigt
		f.auflagen_eingehalten
		f.code == "NATA"
		tag(f.codiert_am) <= tag(feldfrist(y))
	}
}

kursdatum(k, option, start) if {
	option == "Naturschutz"
	tag(k.datum) >= tag("2022-01-01")
	tag(k.datum) <= tag("2025-12-31")
	start <= 2025
}

kursdatum(k, option, start) if {
	option == "Almweideplan"
	planjahr(start)
	tag(k.datum) >= tag("2024-10-01")
	tag(k.datum) <= tag(termin(start, "07-15"))
}

kursperson(p, option) if {
	option == "Naturschutz"
	p.massgeblich_eingebunden
	p.austritt == null
}

kursperson(p, option) if {
	option == "Naturschutz"
	p.massgeblich_eingebunden
	tag(p.austritt) > tag("2025-12-31")
}

kursperson(p, option) if {
	option == "Almweideplan"
	p.bewirtschaftet_alm
}

kursperson(p, option) if {
	option == "Almweideplan"
	p.massgeblich_eingebunden
	p.betriebliches_erfordernis
}

# Veranstaltungen einer Person und Verpflichtung, je Veranstaltungs-ID einmal.
kursstunden(p, option, start) := sum([h | some h in veranstaltungen]) if {
	kursperson(p, option)
	veranstaltungen := {k.id: k.stunden |
		some k in p.kurse
		k.option == option
		k.anbieter_anerkannt
		k.fachthema_erfuellt
		k.nur_dieser_betrieb
		k.nur_diese_verpflichtung
		k.stunden > 0
		kursdatum(k, option, start)
	}
}

weiterbildung_erfuellt(personen, option, start) if {
	some p in personen
	kursstunden(p, option, start) >= 4
}

planpruefung(p, y, start) if {
	y == start
	is_object(p)
}

planpruefung(p, y, start) if {
	y > start
	p.jaehrlich_geprueft
	p.pruefung_dokumentiert
	aktualisierung_erledigt(p)
}

aktualisierung_erledigt(p) if p.aenderungsbedarf == false

aktualisierung_erledigt(p) if {
	p.aenderungsbedarf
	p.aktualisiert
}

beteiligung(p) if p.gemeinsam_erstellt
beteiligung(p) if p.kommuniziert
bereitgestellt(p) if p.angefordert == false

bereitgestellt(p) if {
	p.angefordert
	p.uebermittelt
}

plan_erfuellt(almen, y, start) if {
	planjahr(start)
	planjahr(y)
	count(almen) > 0
	every a in almen {
		p := a.plan
		p.jahr == y
		tag(p.erstellt_am) <= tag(termin(y, "07-15"))
		p.standort_ertrag
		p.oekologische_wertigkeit
		p.ziele_management
		p.lenkung_je_teilflaeche
		beteiligung(p)
		bereitgestellt(p)
		planpruefung(p, y, start)
	}
}

park_ausschluss(park, auflagen) if {
	park in tab.nationalpark_ohne_almpraemie
	is_boolean(auflagen)
}

park_ausschluss(park, auflagen) if {
	park != ""
	park != null
	auflagen == true
}

rechtsform(person) if person.form in {"natuerliche_Person", "eingetragene_Personengesellschaft"}

rechtsform(person) if {
	person.form in {"juristische_Person", "Personenvereinigung"}
	person.oeffentlich_prozent <= 25
}

antragsberechtigt(person) if {
	rechtsform(person)
	person.oeffentlich_beherrscht == false
	person.aktiver_landwirt
	person.landwirtschaftliche_taetigkeit
	person.eigener_name_und_rechnung
	person.verfuegungsgewalt
	person.almbewirtschafter
}

betriebsgroesse(start, y, geschuetzt, anrechenbar) if {
	y == start
	max([geschuetzt / 0.5, anrechenbar / 1.5]) >= 1
}

betriebsgroesse(start, y, geschuetzt, anrechenbar) if {
	y > start
	geschuetzt >= 0
	anrechenbar >= 0
}

uebernahme_typ(fall) if fall.option in {"Basis", "Naturschutz"}

uebernahme_typ(fall) if {
	fall.option == "Almweideplan"
	fall.struktur in {"Aufloesung", "Teilung", "Zusammenlegung"}
}

uebernahme_moeglich(fall, y) if {
	fall.bisher_teilnehmend == false
	fall.uebernommen_ha > 0
	fall.ausweitung_ha <= fall.uebernommen_ha * 0.5
	tag(fall.online_antrag) > tag(termin(y - 1, "12-31"))
	tag(fall.online_antrag) <= tag(listenfrist(y))
	fall.ama_genehmigt
	uebernahme_typ(fall)
}

abgangstoleranz(vorjahr_ha) := max([0.5, min([5, 0.05 * vorjahr_ha])]) if vorjahr_ha >= 0

kombizelle(von, nach) := {"markierung": wert, "fussnoten": tab.kombifussnoten} if {
	von != nach
	some zeile in tab.kombinationen
	zeile.code == von
	wert := zeile.zellen[nach]
}

wechsel_erlaubt(von, nach, y) if {
	some w in tab.wechsel
	w.von == von
	w.nach == nach
	y <= w.bis
	y >= 2023
}

kulturgruppen(name, y) := {row.gruppe | some row in tab.kulturen; name in row.namen; row.ab <= y}
allgemeiner_gve_schluessel := tab.anhang_a
kuerzungsreihenfolge := tab.kuerzungsreihenfolge

zahlungslimit(gruppe, y) := row if {
	some row in tab.obergrenzen
	row.gruppe == gruppe
	row.von <= y
	y <= row.bis
}

sanktionsfolge(stufe, y, vorher_100) := {"ausschluss": true, "rueckforderung": true, "prozent": 100} if {
	stufe == "100"
	vorher_100 >= 1
}

else := {"ausschluss": false, "rueckforderung": false, "prozent": row.prozent} if {
	some row in tab.sanktionen
	row.von <= y
	y <= row.bis
	row.stufe == stufe
}

duerre_ansuchen(y, unmoeglich) if {
	y == 2026
	unmoeglich == true
}
