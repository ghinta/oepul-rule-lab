package oepul.o6_1c

import rego.v1

kombinationszelle(m, partner) := z if {
	some z in werte.kombinationen
	z.massnahme == m
	z.partner == partner
}

matrix_name(code) := row.bezeichnung if {
	some row in werte.matrix_achsen
	row.code == code
}

matrix_hinweise(m, partner) := {f.text |
	some f in werte.matrix_fussnoten
	matrix_fussnote_gilt(f, m, partner)
} if {
	kombinationszelle(m, partner)
}

matrix_fussnote_gilt(f, m, partner) if kombinationszelle(m, partner).fussnote_zelle == f.nr
matrix_fussnote_gilt(f, m, _) if m in f.kopf
matrix_fussnote_gilt(f, _, partner) if partner in f.kopf

betriebsbefunde contains "o6_1c.fruehanteil" if {
	jahr >= 2025
	pflegeanteil.ueberschritten
}

betriebsbefunde contains id if some id in npa_konflikt

betriebsbefunde contains "o6_1c.mindestgroesse" if {
	jahr == betrieb.first_oepul_year
	is_number(betrieb.protected_at_ha)
	is_number(betrieb.qualifying_at_ha)
	not mindestgroesse_erreicht
}

betriebsbefunde contains "o6_1c.person" if {
	some field in {"active_farmer", "agricultural_activity", "own_name_and_account", "control_of_land"}
	betrieb[field] == false
}

betriebsbefunde contains "o6_1c.konditionalitaet" if betrieb.conditionality_met == false
betriebsbefunde contains "o6_1c.konditionalitaet" if betrieb.social_conditionality_met == false

uebernahme_frist(y) := stichtag(y, "04-17") if y in {2023, 2028}
uebernahme_frist(y) := stichtag(y, "04-15") if not y in {2023, 2028}

uebernahme_formalkriterien if {
	u := betrieb.transfer
	im_jahr(u.application_date)
	u.application_date <= uebernahme_frist(jahr)
	u.online_mfa
	u.ama_approved
	u.previously_participating == false
	u.transferred_ha > 0
	u.additional_ha >= 0
	u.additional_ha <= u.transferred_ha * 0.5
}

auszahlungsfrist(y) := stichtag(y + 1, "06-30")

max_teilzahlung(erwartet) := erwartet * 0.75 if {
	erwartet >= 0
	betrieb.administrative_checks_complete
}

mehrjaehrige_toleranz(ha) := max([0.5, min([5, ha * 0.05])]) if ha >= 0

mehrjaehriger_zugang(m, y, basis) := max([5, basis * 0.5]) if {
	y > 2025
	m in werte.zugangsbeschraenkt
	basis >= 0
}

wechsel_erlaubt(von, nach, y) if {
	some row in werte.wechsel
	[row.von, row.nach] == [von, nach]
	y >= 2023
	y <= row.bis_antragsjahr
}

vertragsgruppe(name) := {r.regime | some r in werte.vertragsgruppen; r.massnahme == name}

mehrjahresdauer(y) := row if {
	some row in werte.vertragsdauer
	row.beginn == y
}

uebernahme_nur_einzelfall(m) if m in werte.uebernahme_einzelfall
kulturgruppen(name, y) := {r.gruppe | some r in werte.kulturen; r.kultur == name; y >= r.von}

obergrenze(art, y) := row if {
	some row in werte.obergrenzen
	row.art == art
	y >= row.von
	kein_ablauf(row, y)
}

kein_ablauf(row, _) if row.bis == null

kein_ablauf(row, y) if {
	is_number(row.bis)
	y <= row.bis
}

stufenprozent(name, y) := r.bis_2026_prozent if {
	some r in werte.sanktionen
	r.stufe == name
	y <= 2026
}

stufenprozent(name, y) := r.ab_2027_prozent if {
	some r in werte.sanktionen
	r.stufe == name
	y >= 2027
}

sanktionsfolge(name) := row.folge if {
	some row in werte.sanktionen
	row.stufe == name
}

kuerzungsreihenfolge := werte.kuerzungsfolge

gve_stueck(kategorie, anzahl) := {"einheit": row.einheit, "wert": row.faktor * anzahl} if {
	anzahl >= 0
	some row in werte.gve
	row.kategorie == kategorie
}

zwergrind(rasse) if rasse in werte.zwergrinder

tierhaltend(rgve, gruenland, ackerfutter) if {
	gruenland + ackerfutter > 0
	rgve >= 0.30 * (gruenland + ackerfutter)
}

div_variante(code) := row.auflage if {
	some row in werte.div_gruenland
	row.code == code
}

# Nur zur Einordnung erntepflichtiger Produktionsflächen. NPA und AFS sind ausgenommen.
ernteausnahme_2026(p, stand) if {
	jahr == 2026
	im_jahr(stand)
	p.land_use == "arable"
	object.get(object.get(p, "o6_1c", {}), "category", "") == ""
	p.drought.harvest_required
	p.drought.late_summer_or_autumn_crop
	p.drought.no_harvestable_crop_due_to_drought
	some r in werte.duerregebiet
	stand >= r.ab
	r.land == p.drought.federal_state
	bezirk_passt(r, p.drought.district)
}

bezirk_passt(r, _) if r.bezirk == "alle Bezirke"
bezirk_passt(r, d) if r.bezirk == d

# Referenzlisten zur manuellen Einordnung von Einzelfällen.
flaechenausschluesse := werte.ausgeschlossene_flaechen
ausnahmen_mindestbewirtschaftung := werte.ausnahmen_bewirtschaftung
antragstellerformen := werte.antragsteller
ausnahmen_oeffentlicher_einfluss := werte.oeffentliche_ausnahmen

antragsteller_zulaessige_form if {
	jahr >= 2025
	betrieb.applicant_form in {"natürliche Person", "eingetragene Personengesellschaft", "juristische Person", "Personenvereinigung", "Gebietskörperschaft", "Einrichtung einer Gebietskörperschaft"}
}

bestimmender_einfluss if {
	is_number(betrieb.public_capital_percent)
	betrieb.public_capital_percent > 25
}

bestimmender_einfluss if betrieb.equivalent_public_influence

korrektur_zulaessig if {
	betrieb.correction.incompatible_combination
	betrieb.correction.payment_notice_received == false
	betrieb.correction.control_objection == false
}

ausstieg_vor_kontrolle if {
	betrieb.exit_control.inspection_announced == false
	betrieb.exit_control.inspection_conducted == false
	betrieb.exit_control.administrative_result_notified == false
}

schlagbefunde[p.parcel_id] contains "o6_1c.op" if {
	some p in schlaege
	p.o6_1c.measure_specific_op
}

schlagbefunde[p.parcel_id] contains "o6_1c.doppelfoerderung" if {
	some p in schlaege
	p.o6_1c.public_compensation_or_infrastructure
}

schlagbefunde[p.parcel_id] contains "o6_1c.ausschluss" if {
	some p in schlaege
	p.o6_1c.other_excluded_use
}

meldeweg[p.parcel_id] := "maßnahmenbezogener OP-Code, Nachweis am Betrieb" if {
	some p in schlaege
	p.o6_1c.whole_year_obligations_met == false
	p.o6_1c.third_party_fault_only
}

meldeweg[p.parcel_id] := "Code-Korrektur oder Selbstanzeige" if {
	some p in schlaege
	p.o6_1c.whole_year_obligations_met == false
	p.o6_1c.third_party_fault_only == false
}

# Die Eingabe enthält die bereits fachlich festgestellte Stufe; die Einstufung eines Verstoßes liegt bei der AMA.
beurteilungsfolge := {"stufe": b.stage, "einbehalt_prozent": stufenprozent(b.stage, jahr)} if {
	b := betrieb.assessment
	b.stage != "100 %"
}

beurteilungsfolge := {"stufe": "100 %", "einbehalt_prozent": 100} if {
	b := betrieb.assessment
	b.stage == "100 %"
	b.prior_full_reductions_in_contract == 0
}

beurteilungsfolge := {"stufe": "100 %", "einbehalt_prozent": 100, "folge": sanktionsfolge("Zweimal 100 % im Vertragszeitraum")} if {
	b := betrieb.assessment
	b.stage == "100 %"
	b.prior_full_reductions_in_contract >= 1
}
