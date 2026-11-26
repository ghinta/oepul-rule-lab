package oepul.o6_1a

import data.ubb_tabellen as t
import rego.v1

tag(datum) := time.parse_rfc3339_ns(concat("", [datum, "T00:00:00Z"])) / 86400000000000
stichtag(jahr, monat_tag) := tag(sprintf("%d-%s", [jahr, monat_tag]))

# Nur die Ausnahme für den geprüften Tatbestand, nicht die gesamte Zahlung.
duerregebiet(land, bezirk) if {
	some z in t.duerregebiete
	z.land == land
	z.bezirk in {"*", bezirk}
}

automatische_ernteausnahme(p, jahr) if {
	jahr == 2026
	p.land_use == "arable"
	duerregebiet(p.mfa.bundesland, p.mfa.bezirk)
	p.ernte.spaetsommer_herbst
	p.ernte.besonders_hitzeempfindlich
	p.ernte.duerrebedingt_kein_erntbarer_bestand
}

op_verzicht(p) if "OPUBB" in p.mfa.codes
praemiensperre(p) if op_verzicht(p)
praemiensperre(p) if "OP" in p.mfa.codes
praemiensperre(p) if "VF" in p.mfa.codes

duerre_div(p, jahr) if {
	jahr == 2026
	op_verzicht(p)
	p.mfa.weitere_nutzungsvorgaben == false
	is_array(p.mfa.codes)
	every code in p.mfa.codes { not code in {"NAT", "EBW", "N2"} }
}

dritte_nutzung(p, jahr) if {
	p.land_use == "arable"
	"DIV" in p.mfa.codes
	duerre_div(p, jahr)
}

fruehe_acker_nutzung(p, _, art, frueh_ha_einschliesslich_schlag, gesamt_div) if {
	p.land_use == "arable"
	"DIV" in p.mfa.codes
	p.mfa.weitere_nutzungsvorgaben == false
	art in {"Mahd", "Häckseln"}
	gesamt_div > 0
	frueh_ha_einschliesslich_schlag <= gesamt_div * 0.25
}

fruehe_acker_nutzung(p, jahr, art, _, _) if {
	p.land_use == "arable"
	"DIV" in p.mfa.codes
	art in {"Mahd", "Häckseln", "Weide"}
	duerre_div(p, jahr)
}

problemmahd_ok(befallene_ha, div_ha, art, nachweis) if {
	div_ha > 0
	befallene_ha > div_ha * 0.25
	art in t.problemarten
	nachweis
}

nfz_ruhetage(p, jahr) := 49 if {
	p.land_use == "grassland"
	"DIVNFZ" in p.mfa.codes
	duerre_div(p, jahr)
}

else := 63 if {
	p.land_use == "grassland"
	"DIVNFZ" in p.mfa.codes
}

nfz_folge_ok(p, jahr, abschluss, folgetag) if {
	tag(folgetag) - tag(abschluss) > nfz_ruhetage(p, jahr)
}

# Vergleichsmahd ist ein Datum oder null, wenn kein Vergleichsschlag existiert.
sz_regulaer(jahr, vorverlegung, einmaehdig, _, datum) if {
	vorverlegung >= 0
	vorverlegung <= 10
	tag(datum) >= stichtag(jahr, "06-15") - vorverlegung
	einmaehdig
}

sz_regulaer(jahr, vorverlegung, _, vergleich, datum) if {
	vorverlegung >= 0
	vorverlegung <= 10
	tag(datum) >= stichtag(jahr, "06-15") - vorverlegung
	tag(datum) >= tag(vergleich)
}

sz_regulaer(jahr, vorverlegung, _, _, datum) if {
	vorverlegung >= 0
	vorverlegung <= 10
	tag(datum) >= stichtag(jahr, "07-15") - vorverlegung
}

sz_duerre(p, jahr, vorverlegung, vergleich, datum) if {
	p.land_use == "grassland"
	"DIVSZ" in p.mfa.codes
	duerre_div(p, jahr)
	vorverlegung >= 4
	vorverlegung <= 7
	tag(datum) >= (stichtag(jahr, "06-15") - vorverlegung) - 14
	tag(datum) >= tag(vergleich)
}

variantenwechsel(von, nach, datum) if {
	datum > "2026-04-15"
	some z in t.fristenwechsel
	z.von == von
	z.nach == nach
	datum <= z.bis
}

umbruch_ab(anlagejahr, winter_oder_zwischenfrucht) := stichtag(anlagejahr + 1, "08-01") if winter_oder_zwischenfrucht

else := stichtag(anlagejahr + 1, "09-15") if winter_oder_zwischenfrucht == false

standardmischung_ok(insektenarten, familien, nicht_insekten_prozent) if {
	insektenarten >= 7
	familien >= 3
	nicht_insekten_prozent >= 0
	nicht_insekten_prozent <= 10
}

artenliste("arable") := t.arten_acker
artenliste("grassland") := t.arten_gruenland
artenname(z, n) if n in {z.deutsch, z.wissenschaftlich}
artenname(z, n) if n in z.suchnamen

listenart(nutzung, n) := z if {
	some z in artenliste(nutzung)
	artenname(z, n)
}

partner_ok(nutzung, s) if {
	s.regional_belegt
	s.gewichtsprozent > 0
	s.gewichtsprozent <= 5
	listenart(nutzung, s.art)
}

partner_ok(_, s) if {
	s.oekotyp_zertifiziert
	s.regional_belegt
	s.gewichtsprozent > 0
}

# Grundpartner zählen pro Art einmal, unabhängig von Synonymen oder Lieferanten.
regionalmischung_ok(nutzung, mix) if {
	mix.kg_ha >= 20
	mix.etiketten
	mix.bezugsrechnungen
	every s in mix.partner { is_boolean(s.oekotyp_zertifiziert); partner_ok(nutzung, s)}
	sum([s.gewichtsprozent | some s in mix.partner]) == 100
	grundarten := {z.wissenschaftlich | some s in mix.partner; s.gewichtsprozent <= 5; z := listenart(nutzung, s.art)}
	count(grundarten) >= 30
	count({z.familie | some z in artenliste(nutzung); z.wissenschaftlich in grundarten}) >= 7
	every name in grundarten {
		sum([s.gewichtsprozent | some s in mix.partner; s.oekotyp_zertifiziert == false; listenart(nutzung, s.art).wissenschaftlich == name]) <= 5
	}
}

rs_standort_ok(gruenlandzahl, hang) if {
	gruenlandzahl >= 30
	hang >= 0
	hang < 18
}

slk_stufe(kultur, sorte, jahr) := z.stufe if {
	some z in t.slk_sorten
	z.kultur == kultur
	z.sorte == sorte
	jahr >= z.ab
	jahr <= 2028
}

div_projekt_gruen_ok(p) if {
	p.land_use == "grassland"
	"DIVSZ" in p.mfa.codes
	"NAT" in p.mfa.codes
	some c in p.mfa.projektauflagen
	c in t.nat_codes
}

div_projekt_gruen_ok(p) if {
	p.land_use == "grassland"
	"DIVSZ" in p.mfa.codes
	"N2" in p.mfa.codes
	some c in p.mfa.projektauflagen
	c in t.natura_codes
}

div_projekt_gruen_ok(p) if {
	p.land_use == "grassland"
	"DIVSZ" in p.mfa.codes
	"EBW" in p.mfa.codes
	p.mfa.ebw_lebensraum_nutzung_bestaetigt
	p.mfa.nutzungsart in {"Einmähdige Wiese", "Mähwiese/-weide zwei Nutzungen"}
}

div_projekt_acker_ok(p) if {
	p.land_use == "arable"
	p.mfa.nutzungsart == "Grünbrache"
	"DIV" in p.mfa.codes
	"NAT" in p.mfa.codes
	"SA01" in p.mfa.projektauflagen
}

div_projekt_acker_ok(p) if {
	p.land_use == "arable"
	p.mfa.nutzungsart == "Grünbrache"
	"DIV" in p.mfa.codes
	"EBW" in p.mfa.codes
}

div_projekt_acker_ok(p) if {
	p.land_use == "arable"
	some c in p.mfa.codes
	c in {"BAW", "AG"}
	"DIV" in p.mfa.codes
	p.mfa.nutzungsart in {"Grünbrache", "Sonstiges Feldfutter"}
	p.mfa.div_pflege_eingehalten
}

acker_div_codierung_ok(nutzung, code, _) if {
	code == "DIV"
	nutzung in {"Grünbrache", "Sonstiges Feldfutter"}
}

acker_div_codierung_ok(nutzung, code, jahr) if {
	jahr >= 2025
	code == "DIV"
	nutzung == "Ackerweide"
}

acker_div_codierung_ok(nutzung, code, _) if {
	code == "DIVRS"
	nutzung == "Sonstiges Feldfutter"
}

acker_div_codierung_ok(nutzung, code, jahr) if {
	jahr >= 2025
	code == "DIVRS"
	nutzung == "Grünbrache"
}

steilflaeche(p) if {
	p.land_use == "grassland"
	p.mfa.nutzungsart in t.maehnutzungen
	p.slope_percent >= 50
	count(p.operations.cutting_dates) >= 1
}

erosionsfall(p) if {
	p.land_use == "arable"
	p.area_ha > 0.5
	p.mfa.ueberwiegende_hangneigung_prozent >= 10
	p.crop.crop_name in t.erosionskulturen
}

erosionsverfahren_ok(p) if {
	p.erosion.massnahme_8
	p.erosion.anerkanntes_verfahren
	p.erosion.art in {"Mulchsaat", "Direktsaat", "Strip-Till"}
	p.erosion.begruenungsmassnahme in {"6", "7"}
}

erosionsverfahren_ok(p) if {
	p.erosion.massnahme_8
	p.erosion.anerkanntes_verfahren
	is_string(p.erosion.art)
	not p.erosion.art in {"Mulchsaat", "Direktsaat", "Strip-Till"}
}

abstand_ok(abstand) if abstand == null

abstand_ok(abstand) if {
	is_number(abstand)
	abstand >= 5
}

lse_punkt_ok(e) if {
	e.art in {"Baum", "Busch", "Baum-/Buschgruppe"}
	e.verfuegungsgewalt
	e.beantragt
	e.ganzjaehrig_erhalten
	e.gloez == false
	e.alm_oder_hutweide == false
	e.abstand_lf_m <= 5
	e.kronendurchmesser_m >= 2
	e.flaeche_m2 <= 100
	abstand_ok(e.abstand_naechstes_element_m)
}

streuobst_ok(e, jahr) if {
	lse_punkt_ok(e)
	some z in t.streuobst
	z.art == e.obstart
	jahr >= z.ab
	e.starkwuechsig
	e.grosskronig
	e.stamm in {"Hochstamm", "Halbstamm"}
	e.baumuebergreifendes_stuetzgeruest == false
	wildform_ok(e)
}

wildform_ok(e) if e.wildform == false
wildform_ok(e) if e.obstart in {"Apfel", "Birne", "Kirsche"}

hecke_anlage_ok(h, jahr) if {
	tag(h.anlagedatum) >= stichtag(2023, "01-01")
	tag(h.anlagedatum) <= stichtag(jahr, "05-15")
	h.eigener_acker_angrenzend
	h.laengsseite_wald_lse == false
	h.landeskonzept
	h.gis_bestaetigt
	h.ueberwiegend_strauch_obst
	h.breite_m >= 5
	h.breite_m <= 20
	h.kraut_prozent >= 20
}

fallen_anlagetermin_ok(f) if {
	f.folgekultur == false
	tag(f.anlage) >= tag(f.bezugsdatum)
	tag(f.anlage) - tag(f.bezugsdatum) <= 14
}

fallen_anlagetermin_ok(f) if {
	f.folgekultur
	tag(f.anlage) <= tag(f.vergleichstermin)
}

fallen_zeitplan_ok(p) if {
	f := p.pheromonfallen
	f.anzahl >= 15 * p.area_ha
	fallen_anlagetermin_ok(f)
	tag(f.entfernung) - tag(f.anlage) >= 35
	tag(f.entfernung) < tag(f.ernte)
	count({d | some d in f.leerungen; tag(d) >= tag(f.anlage); tag(d) <= tag(f.anlage) + 35}) >= 2
}

schlagbefunde[p.parcel_id] contains "Ernteausnahme 2026 ohne Einzelmeldung" if {
	some p in input.land.parcels
	automatische_ernteausnahme(p, input.farm.year)
}

schlagbefunde[p.parcel_id] contains "Keine UBB-Prämie auf diesem Schlag" if {
	some p in input.land.parcels
	praemiensperre(p)
}

schlagbefunde[p.parcel_id] contains "Dritte Acker-DIV-Nutzung ohne UBB-Prämie zulässig" if {
	some p in input.land.parcels
	dritte_nutzung(p, input.farm.year)
}

schlagbefunde[p.parcel_id] contains "Anrechenbare Projektfläche Grünland" if {
	some p in input.land.parcels
	div_projekt_gruen_ok(p)
}

schlagbefunde[p.parcel_id] contains "Anrechenbare Projektfläche Acker" if {
	some p in input.land.parcels
	div_projekt_acker_ok(p)
}

schlagbefunde[p.parcel_id] contains "Standort und Mahd für Steilflächenzuschlag erfüllt" if {
	some p in input.land.parcels
	steilflaeche(p)
}
