package oepul.o6_14

import data.almtabellen as tab
import rego.v1

# Alle Datumsfelder sind ISO-Kalendertage, ohne Uhrzeit.
tag(d) := n if {
	regex.match(`^\d{4}-\d{2}-\d{2}$`, d)
	n := time.parse_rfc3339_ns(concat("", [d, "T00:00:00Z"])) / 86400000000000
}

termin(y, md) := sprintf("%04d-%s", [y, md])
jahr := input.farm.year
antrag := input.almwirtschaft

vertragsdauer(y) := tab.vertragsjahre[sprintf("%d", [y])]
feldfrist(y) := termin(y, "04-17") if y in {2023, 2028}

else := termin(y, "04-15")

listenfrist(y) := termin(y, "07-17") if y in {2023, 2028}

else := termin(y, "07-15")

planjahr(y) if {
	y >= 2025
	y <= 2028
}

einstiegsfrist(typ, y) := termin(y - 1, "12-31") if {
	typ in {"Basis", "Naturschutz"}
	vertragsdauer(y) > 0
}

else := termin(y - 1, "12-31") if {
	typ == "Almweideplan"
	planjahr(y)
}

tierklasse(t) := "Zwergrind" if {
	t.art == "Rind"
	t.rasse in tab.zwergrinder
}

else := "Rind" if {
	t.art == "Rind"
	is_string(t.rasse)
	t.rasse != ""
	not t.rasse in tab.zwergrinder
}

else := "Equide_gross" if {
	t.art == "Equide"
	is_number(t.rassenhoehe_m)
	t.rassenhoehe_m > 1.48
}

else := "Equide_gross" if {
	t.art == "Equide"
	is_number(t.rassenendgewicht_kg)
	t.rassenendgewicht_kg > 300
}

else := "Equide_klein" if {
	t.art == "Equide"
	is_number(t.rassenhoehe_m)
	is_number(t.rassenendgewicht_kg)
	t.rassenhoehe_m > 0
	t.rassenhoehe_m <= 1.48
	t.rassenendgewicht_kg > 0
	t.rassenendgewicht_kg <= 300
}

else := t.art if t.art in {"Neuweltkamel", "Schaf", "Ziege"}

# Vollendete Kalendermonate zum 1. Juli, keine pauschale Tageslänge pro Monat.
alter_monate(t, y) := n if {
	tag(t.geburt) <= tag(termin(y, "07-01"))
	[by, bm, bd] := time.date(time.parse_rfc3339_ns(concat("", [t.geburt, "T00:00:00Z"])))
	n := ((((y - by) * 12) + 7) - bm) - count({1 | bd > 1})
}

unter_altersgrenze(_, zeile) if zeile.bis_monate_exklusiv == null

unter_altersgrenze(n, zeile) if {
	is_number(zeile.bis_monate_exklusiv)
	n < zeile.bis_monate_exklusiv
}

rgve_pro_stueck(t, y) := row.rgve if {
	k := tierklasse(t)
	n := alter_monate(t, y)
	some row in tab.rgve
	row.klasse == k
	row.von_monaten <= n
	unter_altersgrenze(n, row)
}

meldefrist(art) := 14 if art == "Rind"

else := 7 if art in {"Equide", "Neuweltkamel", "Schaf", "Ziege"}

abtrieb_fristgerecht(art, s) if {
	art in {"Equide", "Neuweltkamel"}
	s.prognose_abtrieb == s.bis
} else if {
	d := tag(s.abtrieb_gemeldet) - tag(s.bis)
	d >= 0
	d <= meldefrist(art)
}

# Halboffene Intervalle vereinigen. Parallel aufgetriebene Tiere und
# unterbrochene Perioden verlängern den Kalender nicht künstlich.
auftriebstage(art, s, y) := {d |
	s.in_oesterreich == true
	von := max([tag(s.von), tag(s.auftrieb_gemeldet) - meldefrist(art), tag(termin(y, "01-01"))])
	bis := min([tag(s.bis), tag(termin(y + 1, "01-01"))])
	von < bis
	some d in numbers.range(von, bis - 1)
}

tage_auf_alm(t, id, y) := {d | some s in t.aufenthalte; s.alm_id == id; some d in auftriebstage(t.art, s, y)}
weidetage(t, y) := {d | some s in t.aufenthalte; some d in auftriebstage(t.art, s, y)}

tierdaten(t, y) if {
	tierklasse(t) != ""
	is_number(t.stueck)
	t.stueck > 0
	round(t.stueck) == t.stueck
	tag(t.geburt) <= tag(termin(y, "12-31"))
	is_array(t.aufenthalte)
	not ueberlappende_almen(t.aufenthalte)
	every s in t.aufenthalte {
		is_string(s.alm_id)
		is_boolean(s.in_oesterreich)
		tag(s.von) >= tag(t.geburt)
		tag(s.bis) >= tag(s.von)
		tag(s.auftrieb_gemeldet) >= tag(s.von)
	}
}

ueberlappende_almen(aufenthalte) if {
	some s in aufenthalte
	some t in aufenthalte
	s.alm_id != t.alm_id
	max([tag(s.von), tag(t.von)]) < min([tag(s.bis), tag(t.bis)])
}

bestossungstage(tiere, id, y) := count({d |
	some t in tiere
	some d in tage_auf_alm(t, id, y)
}) if {
	is_array(tiere)
	every t in tiere { tierdaten(t, y) }
}

# Bei Wechseltieren ist die aliquote Zuordnung ausdrücklich für Rind,
# Schaf und Ziege beschrieben. Für die anderen Arten nur eindeutige Fälle.
anteil(t, id, y) := 0 if count(tage_auf_alm(t, id, y)) == 0

else := 0 if count(weidetage(t, y)) < 60

else := 1 if count(tage_auf_alm(t, id, y)) == count(weidetage(t, y))

else := n if {
	t.art in {"Rind", "Schaf", "Ziege"}
	n := count(tage_auf_alm(t, id, y)) / count(weidetage(t, y))
}

besatz_beitrag(t, id, y) := 0 if tag(t.geburt) > tag(termin(y, "07-01"))

else := (anteil(t, id, y) * t.stueck) * rgve_pro_stueck(t, y)

besatz_rgve(tiere, id, y) := sum(beitraege) if {
	is_array(tiere)
	every t in tiere { tierdaten(t, y) }
	beitraege := [besatz_beitrag(t, id, y) | some t in tiere]
	count(beitraege) == count(tiere)
}

rechtzeitig_aufgetrieben(t, y) if {
	some s in t.aufenthalte
	s.in_oesterreich == true
	tag(s.von) >= tag(termin(y, "01-01"))
	tag(s.von) <= tag(termin(y, "07-15"))
}

zahlbeitrag(t, id, y) := 0 if anteil(t, id, y) == 0

else := 0 if not rechtzeitig_aufgetrieben(t, y)

else := 0 if t.weidezugang == false

else := (anteil(t, id, y) * t.stueck) * rgve_pro_stueck(t, y) if t.weidezugang == true

zahl_rgve(tiere, id, y) := sum(beitraege) if {
	is_array(tiere)
	every t in tiere { tierdaten(t, y) }
	beitraege := [zahlbeitrag(t, id, y) | some t in tiere]
	count(beitraege) == count(tiere)
}

mindestteilnahme(start, y, ha, rgve) if {
	vertragsdauer(start) > 0
	start == y
	ha >= 3
	rgve >= 3
}

mindestteilnahme(start, y, ha, rgve) if {
	vertragsdauer(start) > 0
	start < y
	y <= 2028
	ha >= 0
	rgve >= 0
}

optionen_vereinbar(natur, plan) if {
	is_boolean(natur)
	is_boolean(plan)
	[natur, plan] != [true, true]
}

besatzgrenze(a, y) := 1.5 if {
	a.naturschutz
	a.almweideplan == false
}

else := 2.4 if {
	a.naturschutz == false
	a.almweideplan
	planjahr(y)
	a.intensitaet.beantragt
	a.intensitaet.oekologisch_erforderlich
	a.intensitaet.begruendung_im_plan
	tag(a.intensitaet.listenantrag) <= tag(listenfrist(y))
}

else := 2 if a.naturschutz == false

besatzflaeche(a) := a.inland_ha + a.ausland_angrenzend_ha if {
	a.ausland_angrenzend_ha > 0
	a.ausland_jahresmeldung_mit_nachweis
}

else := a.inland_ha

besatzflaeche_fuer_grenze(a, grenze) := besatzflaeche(a) if grenze == 2

else := a.inland_ha if besatzflaeche(a) == a.inland_ha

else := a.inland_ha if a.ausland_in_zuschlagsgrenze_anerkannt == false

else := besatzflaeche(a) if a.ausland_in_zuschlagsgrenze_anerkannt

listenbefreiung(a, tiere, y) if {
	a.stufe == 1
	a.behirtung == false
	a.intensitaet.beantragt == false
	arten := {t.art | some t in tiere; some s in t.aufenthalte; s.alm_id == a.id; tag(s.von) <= tag(termin(y, "12-31")); tag(s.bis) > tag(termin(y, "01-01"))}
	arten == {"Rind"}
}

grundsatz(stufe, y) := row.satz_2023 if {
	y == 2023
	some row in tab.erschliessung
	row.stufe == stufe
}

else := row.satz_ab_2024 if {
	y >= 2024
	y <= 2028
	some row in tab.erschliessung
	row.stufe == stufe
}

natursatz(y) := row.euro_ha if {
	some row in tab.naturschutz_grundpraemie
	row.von <= y
	y <= row.bis
}

planzuschlag(ha, y) := 20 * min([20, ha]) if {
	planjahr(y)
	ha >= 0
}

praemienflaeche(ha, rgve) := min([ha, rgve]) if {
	ha >= 0
	rgve >= 0
}

biotopflaeche(flaeche_m2, einzelgehoelze) := (flaeche_m2 + (100 * einzelgehoelze)) / 10000 if {
	flaeche_m2 >= 0
	einzelgehoelze >= 0
}

projektstufe(p, row) if {
	is_number(row.bis_prozent)
	p <= row.bis_prozent
}

projektstufe(p, row) if {
	row.bis_prozent == null
	p <= 100
}

projektsatz(code, anteil_prozent, y) := row.euro_ha if {
	some row in tab.projektauflagen
	row.code == code
	y >= row.ab
	y <= 2028
	anteil_prozent > row.ueber_prozent
	projektstufe(anteil_prozent, row)
}

modulationsbasis(almen_rgve, almen_ha) := min([sum(almen_rgve), sum(almen_ha)])
stufenende(row, basis) := basis if row.bis == null

else := min([row.bis, basis])

modulationsfaktor(basis) := 1 if basis == 0

else := sum(anteile) / basis if {
	basis > 0
	anteile := [wert | some row in tab.modulation; wert := max([0, stufenende(row, basis) - row.von]) * row.anteil]
}

# Teilberechnungen pro Alm. Beträge sind vor Auflagenprüfung, Obergrenzen
# und Sanktion. Unbekannte Tierdaten dürfen keine Teil-Summe ergeben.
almwerte[a.id] := werte if {
	some a in antrag.almen
	tiere := antrag.tiere
	rgve := besatz_rgve(tiere, a.id, jahr)
	zahl := zahl_rgve(tiere, a.id, jahr)
	tage := bestossungstage(tiere, a.id, jahr)
	ha := praemienflaeche(a.praemienfaehige_inland_ha, zahl)
	grenze := besatzgrenze(a, jahr)
	flaeche := besatzflaeche_fuer_grenze(a, grenze)
	flaeche > 0
	a.praemienfaehige_inland_ha <= a.inland_ha
	werte := {"bestossungstage": tage, "mindestdauer_erreicht": tage >= 60, "besatz_rgve": rgve, "zahl_rgve": zahl, "besatz_rgve_ha": rgve / flaeche, "grenze_rgve_ha": grenze, "ueberbesatz": rgve > (grenze * flaeche), "praemienflaeche_ha_vor_auflagenpruefung": ha, "grundpraemie_vor_modulation_eur": ha * grundsatz(a.stufe, jahr)}
}

betriebsfaktor := modulationsfaktor(basis) if {
	count(almwerte) == count(antrag.almen)
	basis := modulationsbasis([w.zahl_rgve | some w in almwerte], [a.inland_ha | some a in antrag.almen])
}

einstieg_erfuellt := ok if {
	ha := [a.inland_ha | some a in antrag.almen]
	count(ha) == count(antrag.almen)
	is_number(antrag.startjahr)
	is_number(antrag.aufgetriebene_rgve_betrieb)
	ok := count({1 | mindestteilnahme(antrag.startjahr, jahr, sum(ha), antrag.aufgetriebene_rgve_betrieb)}) == 1
}
