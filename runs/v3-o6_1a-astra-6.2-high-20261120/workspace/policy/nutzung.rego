package oepul.o6_1a

import rego.v1

# Entscheidungsfunktionen prüfen jeweils den benannten Teil der Förderverpflichtung.
acker_regelereignis(e, _, jahr) if {
	e.art in {"Mahd", "Häckseln"}
	tag(e.datum) >= stichtag(jahr, "08-01")
}

acker_regelereignis(e, _, jahr) if {
	e.art == "Weide"
	jahr >= 2025
	tag(e.datum) >= stichtag(jahr, "08-01")
}

acker_regelereignis(e, p, jahr) if {
	tag(e.datum) < stichtag(jahr, "08-01")
	fruehe_acker_nutzung(p, jahr, e.art, input.land.div_anrechenbar.vor_august_gepflegt_ha, input.land.div_anrechenbar.acker_ha)
}

acker_regelereignis(e, p, jahr) if reinigung_ohne_abfuhr(e, p, jahr)
acker_regelereignis(e, _, jahr) if weidenachpflege(e, jahr)

acker_regelpflege_ok(p, jahr) if {
	p.land_use == "arable"
	"DIV" in p.mfa.codes
	p.mfa.weitere_nutzungsvorgaben == false
	every c in p.mfa.codes { not c in {"NAT", "EBW", "BAW", "AG"} }
	is_array(p.operations.nutzungen)
	every e in p.operations.nutzungen { acker_regelereignis(e, p, jahr) }
	n := acker_pflegeanzahl(p, jahr)
	n <= max_nutzungen(p, jahr)
	n + p.div.zaehlbare_pflege_vorjahr >= 1
}

jaehrliche_mahd(p) if {
	some e in p.operations.nutzungen
	e.art == "Mahd"
	e.abtransport
}

agf_jahresnutzung_ok(p, jahr) if {
	p.land_use == "grassland"
	"DIVAGF" in p.mfa.codes
	p.div.altgras_ueber_winter
	jaehrliche_mahd(p)
	every e in p.operations.nutzungen {
		e.art in {"Mahd", "Weide"}
		tag(e.datum) <= stichtag(jahr, "08-15")
	}
}

rs_gruen_ereignis_ok(e, _, jahr) if {
	e.art in {"Mahd", "Weide"}
	tag(e.datum) >= stichtag(jahr, "07-15")
}

rs_gruen_ereignis_ok(e, p, _) if {
	e.art == "Reinigungsschnitt"
	p.div.neuansaat_erstes_antragsjahr
}

rs_gruen_zaehlt(e) if e.art in {"Mahd", "Weide"}

rs_gruen_zaehlt(e) if {
	e.art == "Reinigungsschnitt"
	e.abtransport
}

rs_gruen_pflege_ok(p, jahr) if {
	p.land_use == "grassland"
	"DIVRS" in p.mfa.codes
	every e in p.operations.nutzungen { rs_gruen_ereignis_ok(e, p, jahr) }
	count([1 | some e in p.operations.nutzungen; rs_gruen_zaehlt(e)]) <= 2
	jaehrliche_mahd(p)
	every e in p.operations.nutzungen { gruen_mahd_abfuhr(e) }
}

gruen_mahd_abfuhr(e) if e.art != "Mahd"
gruen_mahd_abfuhr(e) if e.abtransport

div_saatfrist_ok(datum, jahr) if tag(datum) <= stichtag(jahr, "05-15")

divrs_fortsetzung_ok(vorjahrescode, _, jahr) if {
	jahr <= 2028
	vorjahrescode == "DIVRS"
}

divrs_fortsetzung_ok(_, neuansaat, jahr) if {
	jahr <= 2028
	neuansaat
}

slk_reinanbau_ok(s) if {
	s.sortenrein
	s.saatgutnachweis
	s.untersaat == false
}

slk_reinanbau_ok(s) if {
	s.sortenrein
	s.saatgutnachweis
	s.untersaat
	s.untersaat_untergeordnet
	s.untersaat_mitgeerntet == false
}

mfa_uebernahmetag(jahr) := stichtag(jahr, "04-17") if jahr in {2023, 2028}

else := stichtag(jahr, "04-15")

uebernahmeantrag_ok(jahr, datum, vorher, ausweitung) if {
	jahr >= 2023
	jahr <= 2028
	tag(datum) > stichtag(jahr - 1, "12-31")
	tag(datum) <= mfa_uebernahmetag(jahr)
	vorher > 0
	ausweitung <= 0.5 * vorher
}

entgelt_bei_op(p, _) := 0 if praemiensperre(p)

entgelt_bei_op(p, bruttobetrag) := bruttobetrag if {
	is_array(p.mfa.codes)
	not praemiensperre(p)
}

nat_terminfreigabe(p, jahr, datum) if {
	jahr == 2026
	"NAT" in p.mfa.codes
	p.mfa.nutzungstermin_festgelegt
	tag(datum) >= stichtag(jahr, "08-12")
	tag(datum) <= stichtag(jahr, "12-31")
}

natura_terminfreigabe(p, jahr, datum) if {
	jahr == 2026
	"N2" in p.mfa.codes
	is_string(p.mfa.geaenderter_landestermin)
	tag(datum) >= tag(p.mfa.geaenderter_landestermin)
	tag(datum) <= stichtag(jahr, "12-31")
}

# Bei diesen sieben Listeneinträgen umfasst die Freigabe alle Herkünfte und Sorten.
slk_gruppenstufe(kultur, artengruppe, jahr) := z.stufe if {
	some z in data.ubb_tabellen.slk_sorten
	z.kultur == kultur
	z.alle_herkuenfte
	z.artengruppe == artengruppe
	jahr >= z.ab
	jahr <= 2028
}

ackerbasis_erosion_gesperrt(p) if {
	erosionsfall(p)
	p.erosion.massnahme_8 == false
}

ackerbasis_erosion_gesperrt(p) if {
	erosionsfall(p)
	p.erosion.anerkanntes_verfahren == false
}

ackerbasis_erosion_gesperrt(p) if {
	erosionsfall(p)
	p.erosion.art in {"Mulchsaat", "Direktsaat", "Strip-Till"}
	is_string(p.erosion.begruenungsmassnahme)
	not p.erosion.begruenungsmassnahme in {"6", "7"}
}

schlagbefunde[p.parcel_id] contains "Erosionsauflage schließt Acker-Basismodulprämie aus" if {
	some p in input.land.parcels
	ackerbasis_erosion_gesperrt(p)
}

# Förderpositionen sind einzeln abfragbar. Mehrkosten und Bescheide können weitere Begrenzungen auslösen.
pruefwerte["Eintrittsfrist UBB eingehalten"] := antragsfrist_ok(input.farm.oepul_vertrag.ubb_beginn, input.farm.oepul_vertrag.massnahmenantrag)
pruefwerte["Weiterbildung nachgewiesen"] := bildung_erfuellt
pruefwerte["Modulationsfaktor Heimfläche"] := modulationsfaktor(input.land.foerderumfang.heimflaeche_ha)
pruefwerte["Zuschlag Acker-DIV über 7 % (ha)"] := mehr_div_ha(input.land.arable_area_ha, input.land.div_anrechenbar.reiner_acker_ha)
pruefwerte["Zuschlag Grünland-DIV über 7 % (ha)"] := mehr_div_ha(input.land.maehgruenland_ohne_bergmaehder_ha, input.land.div_anrechenbar.reines_gruenland_ha)
pruefwerte["Prämienfähiger neuer Flächenzugang (ha)"] := zugang_praemienfaehig(input.farm.year, input.land.foerderumfang.massnahme_2025_ha, input.land.foerderumfang.kumulierter_neuzugang_ha)
pruefwerte["Abgang mit Rückzahlungsverpflichtung (ha)"] := rueckzahlflaeche(input.land.foerderumfang.vorjahr_massnahme_ha, input.land.foerderumfang.abgang_ohne_ausnahme_ha)
