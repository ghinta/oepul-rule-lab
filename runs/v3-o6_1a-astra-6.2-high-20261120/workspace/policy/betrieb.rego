package oepul.o6_1a

import data.ubb_tabellen as t
import rego.v1

# Separat abfragbare Entscheidungen; fehlende Eingaben liefern keinen positiven Bescheid.
vertragsjahre(beginn) := 2029 - beginn if beginn in {2023, 2024, 2025}

mindestgroesse_ok(teilnahmejahr, geschuetzt, gesamt) if {
	teilnahmejahr == 1
	max([geschuetzt / 0.5, gesamt / 1.5]) >= 1
}

mindestgroesse_ok(teilnahmejahr, _, _) if teilnahmejahr > 1

anteil_soll(ha) := 0 if {
	ha >= 0
	ha <= 2
}

anteil_soll(ha) := ha * 0.07 if ha > 2

gruenland_soll_ha := anteil_soll(input.land.maehgruenland_ohne_bergmaehder_ha)
acker_soll_ha := anteil_soll(input.land.arable_area_ha)

ersatzflaeche(acker, zusaetzlich, grenze_einschliesslich) := zusaetzlich if {
	acker < 10
	is_boolean(grenze_einschliesslich)
} else := zusaetzlich if {
	acker == 10
	grenze_einschliesslich
}

else := 0

# Hektar als ganze Nanohektar vergleichen, damit Dezimalgrenzen bei Addition exakt bleiben.
flaecheneinheiten(ha) := round(ha * 1000000000)

div_bilanz := {
	"acker_soll_ha": acker_soll_ha, "gruenland_soll_ha": gruenland_soll_ha,
	"gruenland_erfuellt": flaecheneinheiten(gruen) >= flaecheneinheiten(gruenland_soll_ha),
	"acker_erfuellt_merkblatt": mb, "acker_erfuellt_richtlinie": srl, "klaerung_10_ha": mb != srl,
} if {
	acker := input.land.arable_area_ha
	gruen := input.land.div_anrechenbar.gruenland_ha
	div := input.land.div_anrechenbar.acker_ha
	extra := max([0, flaecheneinheiten(gruen) - flaecheneinheiten(gruenland_soll_ha)])
	mb := (flaecheneinheiten(div) + ersatzflaeche(acker, extra, false)) >= flaecheneinheiten(acker_soll_ha)
	srl := (flaecheneinheiten(div) + ersatzflaeche(acker, extra, true)) >= flaecheneinheiten(acker_soll_ha)
}

feld_azr(f, jahr) if {
	jahr == 2023
	f.nutzung == "Acker"
	f.gebeizte_rueben_2022
	f.andere_kulturen_2022_ha < 0.15
	f.alle_folgeschlaege_azr
}

feld_basis(f) := input.land.arable_area_ha if f.nutzung == "Acker"
feld_basis(f) := input.land.maehgruenland_ohne_bergmaehder_ha if f.nutzung == "Grünland"

# Für Grünland ist maßgebliche_ha ausschließlich die gemähte Fläche ohne Bergmähder.
feld_grenze(f, jahr) := 0 if feld_basis(f) < 10

else := 0 if f.massgebliche_ha <= 5

else := 0 if feld_azr(f, jahr)

else := 0.15 if jahr != 2023

else := 0.15 if f.nutzung == "Grünland"

else := 0.15 if f.gebeizte_rueben_2022 == false

else := 0.15 if f.andere_kulturen_2022_ha >= 0.15

else := 0.15 if f.alle_folgeschlaege_azr == false

agroforstbeitrag(f, jahr) := f.zugeordnete_1c_agroforst_ha if {
	f.nutzung == "Acker"
	jahr >= 2025
}

else := 0 if jahr < 2025

else := 0 if f.nutzung == "Grünland"

feldbilanzen[f.id] := {"soll_ha": soll, "anrechenbar_ha": ist, "erfuellt": ist >= soll} if {
	some f in input.land.feldstuecke
	soll := feld_grenze(f, input.farm.year)
	ist := (f.div_ha + f.zugeordnete_gloez_lse_ha) + agroforstbeitrag(f, input.farm.year)
}

gruenlandreferenz_ha := input.land.erhaltung.erstjahr_gruenland_ha + input.land.erhaltung.umbruch_vorjahr_ha
gruenlandtoleranz_ok := (input.land.erhaltung.anrechenbarer_umbruch_vertrag_ha - input.land.erhaltung.anrechenbare_neuanlagen_ha) <= 1

ausgenommene_kultur(n, _) if n in t.ackerfutter

ausgenommene_kultur(n, jahr) if {
	jahr >= 2025
	n in {"Grünbrache", "Spargel"}
}

getreide_oder_mais(k) if k.getreideanteil_prozent >= 50
getreide_oder_mais(k) if k.erstkultur == "Mais"

# MFA-Zeilen führen botanische Art der Erst-/überwiegenden Kultur und ihren Getreideanteil.
diversifizierung := {
	"getreide_mais_ha": getreide, "getreide_mais_ok": getreide <= (basis * 0.75),
	"ueber_55_prozent": verletzt,
} if {
	basis := input.land.arable_area_ha
	basis > 5
	zeilen := input.land.hauptkulturen
	sum([k.ha | some k in zeilen]) == basis
	every k in zeilen { is_string(k.erstkultur); is_string(k.botanische_art); is_number(k.getreideanteil_prozent)}
	getreide := sum([k.ha | some k in zeilen; getreide_oder_mais(k)])
	arten := {k.botanische_art | some k in zeilen; not ausgenommene_kultur(k.erstkultur, input.farm.year)}
	verletzt := {art | some art in arten; sum([k.ha | some k in zeilen; k.botanische_art == art; not ausgenommene_kultur(k.erstkultur, input.farm.year)]) > basis * 0.55}
}

rgve_faktor(kategorie) := r.rgve if {
	some r in t.rgve
	r.kategorie == kategorie
}

rgve_bestand := sum([wert | some z in gruppen; wert := z.jahresrelevante_stueck * rgve_faktor(z.kategorie)]) if {
	gruppen := input.livestock.rgve_bestand_inland
	is_array(gruppen)
	every z in gruppen { is_number(rgve_faktor(z.kategorie)); z.jahresrelevante_stueck >= 0}
}

tierhaltend := rgve_bestand >= (0.30 * futter) if {
	futter := input.land.grassland_area_ha + input.land.ackerfutter_ha
	futter > 0
}

abgangstoleranz(vorjahr_ha) := max([0.50, min([5, vorjahr_ha * 0.05])]) if vorjahr_ha >= 0
rueckzahlflaeche(vorjahr, reduktion) := reduktion if reduktion > abgangstoleranz(vorjahr)

else := 0 if reduktion >= 0

zugang_praemienfaehig(jahr, _, neu) := neu if jahr in {2024, 2025}

zugang_praemienfaehig(jahr, basis2025, neu) := min([neu, max([5, 0.5 * basis2025])]) if {
	jahr >= 2026
	jahr <= 2028
}

praemiensatz(position, jahr) := zeile.eur if {
	some zeile in t.praemiensaetze
	zeile.position == position
	jahr >= zeile.von
	jahr <= zeile.bis
}

mehr_div_ha(basis, rein) := max([0, min([rein, basis * 0.2]) - (basis * 0.07)])

verteilungszuschlag_ok(basis, groessen) if {
	basis > 0
	count([ha | some ha in groessen; ha > 0.05]) >= ceil(basis / 3)
}

flaechenanteil_foerderkulturen_ok(acker, kultur_ha, div_ha) if {
	kultur_ha + max([0, div_ha - (0.07 * acker)]) > 0.15 * acker
}

kultur_gruppe(name) := t.foerderkulturen[name]

# Je förderwürdigem Schlag die vergütbaren Gruppen seiner Haupt- und Zweitkultur angeben.
schlag_satz(s, jahr) := max([praemiensatz(g, jahr) | some g in s.gruppen]) if {
	every g in s.gruppen { g in {"feldfutter", "leguminosen", "kreuzbluetler", "sonnenblume", "bhg"} }
}

kulturzuschlag_eur := sum(teilbetraege) if {
	schlaege := input.land.foerderkulturschlaege
	jahr := input.farm.year
	basis := input.land.arable_area_ha
	div := input.land.div_anrechenbar.acker_ha
	every s in schlaege { s.ha > 0; is_number(schlag_satz(s, jahr))}
	kulturha := sum([s.ha | some s in schlaege])
	flaechenanteil_foerderkulturen_ok(basis, kulturha, div)
	saetze := {schlag_satz(s, jahr) | some s in schlaege}
	teilbetraege := [betrag |
		some satz in saetze
		vorher := sum([s.ha | some s in schlaege; schlag_satz(s, jahr) > satz])
		ha := sum([s.ha | some s in schlaege; schlag_satz(s, jahr) == satz])
		betrag := satz * min([ha, max([0, (basis * 0.4) - vorher])])
	]
}

stufenende(stufe, ha) := ha if stufe.bis_ha == null

else := min([ha, stufe.bis_ha])

modulationsfaktor(ha) := sum([betrag | some s in t.modulation; betrag := max([0, stufenende(s, ha) - s.ab_ha]) * s.faktor]) / ha if ha > 0

obergrenze(kategorie, jahr) := z if {
	some z in t.obergrenzen
	z.kategorie == kategorie
	jahr >= z.von
	jahr <= z.bis
}

kuerzung(stufe, jahr) := z.prozent if {
	some z in t.kuerzungen
	z.stufe == stufe
	jahr >= z.ab
	jahr <= z.bis
}

kombinationszelle(massnahme, partner) := z.zeichen if {
	some z in t.kombinationsmatrix
	z.massnahme == massnahme
	z.partner == partner
}

betriebliche_kombination_ok(bio, nichtproduktiver_acker) if {
	bio in {"keine", "Teilbetrieb Wein, Obst und Hopfen"}
	nichtproduktiver_acker == false
}

monitoring_kombination_ok(programm, _, _) if {
	some m in t.monitoring
	m.programm == programm
	count(m.nat_codes) == 0
}

monitoring_kombination_ok(programm, nat, auflagen) if {
	nat
	some m in t.monitoring
	m.programm == programm
	some c in m.nat_codes
	c in auflagen
}
