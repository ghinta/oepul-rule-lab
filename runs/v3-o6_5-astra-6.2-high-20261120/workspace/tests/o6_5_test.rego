package oepul.o6_5_test

import data.oepul.o6_5 as p
import rego.v1

kuh := {
	"tier_id": "R1", "kategorie": "Kuh", "rasse": "Murbodner", "geburtsdatum": "2020-02-29",
	"haltungsland": "AT", "beginn": "2024-03-01", "abgang": null, "aufenthalte": [],
	"beurteilt_bis": "2026-12-31", "rinderdatenbank_zugang": true, "rinderdatenbank_stichtag": true,
	"reinrassig": true, "regelmaessiger_zuchteinsatz": true, "tierzuchtrecht_erfuellt": true,
	"zuchtprogramm_genehmigt_mit_erhaltungsziel": true, "reinrassige_anpaarung": true,
	"geburten": [{"datum": "2026-04-01"}], "gep_umgesetzt": true,
	"bestaetigung": {
		"datum": "2027-02-10", "organisation": "Rinderzucht Steiermark eGen",
		"eama": true, "zuchtbuch": true, "kategorie": true, "programm": true, "milchleistungskontrolle": true,
	},
}

profil(tiere) := {"farm": {"year": 2026}, "livestock": {"foerderpositionen": [{"tiere": tiere}]}}

test_einzelfall_2026 if {
	a := p.pruefung with input as profil([kuh])
	a.einzeltarife_eur == {"R1": 334.8}
	a.halteende_einschliesslich == "2026-08-31"
	a.bestaetigungsfrist == "2027-02-10"
}

test_haltung_grenzen if {
	p.haltungszeit("2026-08-31") with input.farm.year as 2026
	not p.haltungszeit("2026-09-01") with input.farm.year as 2026
	p.haltungszeit("2027-12-31") with input.farm.year as 2027
	not p.haltungszeit("2027-03-31") with input.farm.year as 2027
}

test_fruehabgang_und_meldepflicht if {
	a := object.union(kuh, {"abgang": "2026-09-01"})
	r := p.pruefung with input as profil([a])
	r.einzeltarife_eur.R1 == 334.8
	{"tier_id": "R1", "ereignis": "Abgang", "ereignistag": "2026-09-01", "weg": "Rinderdatenbank"} in r.meldeauftraege
	b := object.union(kuh, {"abgang": "2026-08-31"})
	not p.minimum_erreicht with input as profil([])
	s := p.pruefung with input as profil([b])
	s.einzeltarife_eur == {}
}

schaf := {"tier_id": "S1", "rasse": "Waldschaf", "kategorie": "Mutterschaf", "abgang": "2026-12-20"}

test_2026_meldung_und_letzter_tag if {
	m := p.meldeauftraege with input as profil([object.union(schaf, {"abgang_gemeldet_am": "2026-12-27"})])
	some e in m
	e.frist == "2026-12-27"
	e.status == "fristgerecht"
	p.ersatz_meldeweg(object.union(schaf, {"beginn": "2026-09-01"})) == "keine gesonderte Nachbesetzungsmeldung" with input.farm.year as 2026
	start := object.union(schaf, {"beginn": "2026-08-31"})
	startswith(p.ersatz_meldeweg(start), "eAMA") with input.farm.year as 2026
}

test_fuenf_wochen_ueber_jahresende if {
	a := object.union(kuh, {"abgang": "2025-12-20"})
	b := object.union(kuh, {"tier_id": "R2", "beginn": "2026-01-24", "geburten": [{"datum": "2025-04-01"}], "bestaetigung": object.union(kuh.bestaetigung, {"datum": "2026-02-10"})})
	p.ersatz_ok(a, b) with input.farm.year as 2025
	not p.ersatz_ok(a, object.union(b, {"beginn": "2026-01-25"})) with input.farm.year as 2025
	not p.ersatz_ok(a, object.union(b, {"rasse": "Original Pinzgauer"})) with input.farm.year as 2025
}

test_fristen if {
	p.fristgerecht("2024-02-25", "2024-03-03", 7)
	not p.fristgerecht("2024-02-25", "2024-03-04", 7)
	not p.fristgerecht("2024-02-25", "2024-02-24", 7)
	not p.datum("2025-02-29")
	p.monate("2024-02-29", 12) == "2025-02-28"
}

test_bestaetigung if {
	p.bestaetigt(kuh) with input.farm.year as 2026
	every delta in [{"organisation": "fremd"}, {"datum": "2027-02-11"}, {"zuchtbuch": false}, {"eama": false}, {"programm": false}] {
		not p.bestaetigt(object.union(kuh, {"bestaetigung": object.union(kuh.bestaetigung, delta)})) with input.farm.year as 2026
	}
}

test_artenliste if {
	not p.rasse({"rasse": "Waldschaf", "kategorie": "Kuh"})
	not p.rasse({"rasse": "Fleckvieh", "kategorie": "Kuh"})
	is_array(data.o6_5_tabellen.rassen)
	is_array(data.o6_5_tabellen.kategorien)
	count(data.o6_5_tabellen.rassen) == 27
	count(p.rassen_nach_name) == 27
	count(data.o6_5_tabellen.kategorien) == 10
	count(p.kategorien_nach_name) == 10
	count(data.o6_5_tabellen.tarife) == 20
}

test_jahre_und_ersatztarife if {
	p.tarif(kuh) == 310 with input.farm.year as 2023
	p.tarif(kuh) == 334.8 with input.farm.year as 2024
	b := object.union(kuh, {"kategorie": "Zuchtstier"})
	p.ersatztarif(kuh, b) == 334.8 with input.farm.year as 2025
	c := object.union(kuh, {"bestaetigung": object.union(kuh.bestaetigung, {"milchleistungskontrolle": false})})
	p.ersatztarif(kuh, c) == 248.4 with input.farm.year as 2025
	not p.ersatztarif(c, kuh) with input.farm.year as 2025
}

test_kein_gep if {
	t := {"kategorie": "Mutterziege", "rasse": "Blobe Ziege", "gep_umgesetzt": true}
	p.tarif(t) == 64.8 with input.farm.year as 2026
}

test_jahreseinsatz_alter if {
	every c, geb in {"Zuchtstier": "2025-06-01", "Zuchtwidder": "2025-10-01", "Zuchteber": "2025-10-01", "Zuchtbock": "2025-11-01"} {
		t := {"kategorie": c, "geburtsdatum": geb, "zuchtzulassungsjahr": 2026}
		p.kategorie_ok(t, "2026-04-01") with input.farm.year as 2026
		not p.kategorie_ok(object.union(t, {"geburtsdatum": p.seit(geb, 1)}), "2026-04-01") with input.farm.year as 2026
		not p.kategorie_ok(object.union(t, {"zuchtzulassungsjahr": 2025}), "2026-04-01") with input.farm.year as 2026
	}
}

test_hengst if {
	t := {"kategorie": "Zuchthengst", "geburtsdatum": "2021-05-31"}
	p.kategorie_ok(t, "2026-05-31")
	p.kategorie_ok(object.union(t, {"geburtsdatum": "2024-05-31"}), "2026-05-31")
	not p.kategorie_ok(object.union(t, {"geburtsdatum": "2024-06-01"}), "2026-05-31")
	a := object.union(t, {"geburtsdatum": "2021-05-30"})
	not p.kategorie_ok(a, "2026-05-31")
	n := {"lebend_geboren": true, "registriert_am": "2024-05-31"}
	p.kategorie_ok(object.union(a, {"nachkommen": [n]}), "2026-05-31")
	not p.kategorie_ok(object.union(a, {"nachkommen": [object.union(n, {"registriert_am": "2024-05-30"})]}), "2026-05-31")
}

test_stute if {
	t := object.union(kuh, {"kategorie": "Stute", "geburten": [{"datum": "2022-11-30"}, {"datum": "2026-05-30"}]})
	p.kategorie_ok(t, "2026-05-31")
	not p.kategorie_ok(object.union(t, {"geburten": [{"datum": "2022-11-30"}, {"datum": "2026-05-31"}]}), "2026-05-31")
}

test_weiblicher_stichtag if {
	every k in ["Mutterschaf", "Mutterziege", "Kuh", "Stute"] {
		d := p.tag(2026, p.kategorien_nach_name[k].stichtag)
		t := object.union(kuh, {"kategorie": k, "geburten": [{"datum": d}]})
		p.kategorie_ok(t, d)
		not p.kategorie_ok(object.union(t, {"geburten": [{"datum": p.seit(d, 1)}]}), d)
	}
}

test_zuchtsau if {
	g := [{"datum": "2025-10-01", "reinrassig": true}, {"datum": "2026-04-01", "reinrassig": false}]
	t := object.union(kuh, {"kategorie": "Zuchtsau", "geburten": g})
	p.kategorie_ok(t, "2026-04-01")
	not p.kategorie_ok(object.union(t, {"geburten": array.concat(g, [{"datum": "2026-09-01", "reinrassig": false}])}), "2026-04-01")
}

test_antrag_pferd if {
	t := {"rasse": "Noriker", "kategorie": "Stute", "mfa_beilage_stichtag": true, "ueln": "AT123", "mfa_kennzeichnung": "AT123"}
	p.beantragt(t)
	not p.beantragt(object.union(t, {"mfa_kennzeichnung": "XYZ"}))
	not p.beantragt(object.remove(kuh, ["rinderdatenbank_stichtag"]))
}

test_weide_und_zuchtaufenthalt if {
	p.weide({"art": "Almweide", "voruebergehend": true, "nur_zur_betreuung": true})
	not p.weide({"art": "Zinsweide", "voruebergehend": true, "nur_zur_betreuung": true})
	p.abtrieb("Ziege", "Gemeinschaftsweide", true)
	e := {"art": "Zuchtstation", "voruebergehend": true, "zuchtzweck": true, "von": "2025-04-30", "rueckkehr": "2025-10-30"}
	p.zuchtaufenthalt(kuh, e)
	not p.zuchtaufenthalt(kuh, object.union(e, {"rueckkehr": "2025-10-31"}))
	f := object.union(e, {"art": "Landwirtschaftsbetrieb", "rueckkehr": "2025-07-30"})
	p.zuchtaufenthalt(object.union(kuh, {"kategorie": "Zuchtstier"}), f)
	not p.zuchtaufenthalt(kuh, f)
}

test_kurzaufenthalt if {
	e := {"voruebergehend": true, "belegt": true, "von": "2025-05-15", "rueckkehr": "2025-05-25"}
	p.kurzaufenthalt(e)
	not p.kurzaufenthalt(object.union(e, {"rueckkehr": "2025-05-26"}))
	not p.kurzaufenthalt(object.union(e, {"belegt": false}))
	p.zucht_meldeweg(schaf, e) == "keine gesonderte AMA-Meldung"
}

test_weitergabe_rind if {
	t := object.union(kuh, {"abgang": "2025-10-01", "weitergabe_an_betrieb": true, "im_inland_und_lebend_bis_jahresende": true})
	p.rinderweitergabe(t) with input.farm.year as 2025
	not p.rinderweitergabe(object.union(t, {"abgang": "2025-09-30"})) with input.farm.year as 2025
	not p.rinderweitergabe(object.union(t, {"im_inland_und_lebend_bis_jahresende": false})) with input.farm.year as 2025
}

test_groesse_einstieg_uebernahme if {
	p.groesse_ok with input as {"farm": {"year": 2026, "oepul": {"erstes_oepul_jahr": 2026}}, "land": {"geschuetzter_anbau_at_ha": 0.5}}
	not p.groesse_ok with input as {"farm": {"year": 2026, "oepul": {"erstes_oepul_jahr": 2026}}, "land": {"geschuetzter_anbau_at_ha": 0.49, "anrechenbare_mfa_flaeche_at_ha": 1.49}}
	p.groesse_ok with input as {"farm": {"year": 2026, "oepul": {"erstes_oepul_jahr": 2025}}}
	p.einstieg("2026-12-31") with input.farm.year as 2027
	not p.einstieg("2027-01-01") with input.farm.year as 2027
	not p.einstieg("2027-12-31") with input.farm.year as 2028
	u := {"grund": "Betriebsteilung", "vorbetrieb_tiere": "A", "vorbetrieb_flaechen": "A", "online_im_mfa": true, "ama_genehmigt": true}
	p.uebernahme_ok(u)
	not p.uebernahme_ok(object.union(u, {"vorbetrieb_flaechen": "B"}))
}

test_modulation_sanktionen if {
	p.modulationsfaktor(220) == 218 / 220
	p.modulationsfaktor(1200) == (((200 + 90) + 595) + 150) / 1200
	p.sanktionssatz("Verwarnstufe") == 0 with input.farm.year as 2026
	p.sanktionssatz("Verwarnstufe") == 1 with input.farm.year as 2027
	p.sanktionssatz("Kürzung 50 %") == 50 with input.farm.year as 2026
}

test_doppelte_identitaet if {
	k := {"tiere": [kuh]}
	r := p.pruefung with input as {"farm": {"year": 2026}, "livestock": {"foerderpositionen": [k, k]}}
	r.einzeltarife_eur == {}
}

test_rgve if {
	p.gve_wert("Rinder unter ½ Jahr", 3).wert == 1.2
	p.tierhalter(3, 10)
	not p.tierhalter(2.99, 10)
	p.zwergrind("Dexter")
}

betrieb := {
	"rechtsform": "juristische_person",
	"oeffentliche_einrichtung": false,
	"gleichwertiger_oeffentlicher_einfluss": false,
	"oeffentliches_kapital_prozent": 25,
	"aktiver_landwirt": true,
	"landwirtschaftliche_taetigkeit": true,
	"eigener_name_und_rechnung": true,
	"verfuegungsgewalt": true,
	"erstes_oepul_jahr": 2026,
	"vertrag": {"massnahmenantrag_am": "2025-12-31", "zahlungsantrag_eingereicht": true, "abmeldung_am": null},
}

test_gesamtbetrag_und_vertragszugang if {
	b := profil([kuh])
	d := object.union(b, {"farm": {"year": 2026, "oepul": betrieb}, "land": {"anrechenbare_mfa_flaeche_at_ha": 1.5, "heimflaeche_mfa_ha": 1.5}})
	p.teilnahme_belegt with input as d
	p.modulierte_tarifsumme == 334.8 with input as d
	not p.teilnahme_belegt with input as d with input.farm.oepul.vertrag.abmeldung_am as "2026-12-31"
	not p.teilnahme_belegt with input as d with input.farm.oepul.oeffentliches_kapital_prozent as 25.01
	not p.teilnahme_belegt with input as d with input.farm.oepul.gleichwertiger_oeffentlicher_einfluss as true
	p.teilnahme_belegt with input as d with input.farm.oepul.vertrag.abmeldung_am as "2027-01-01"
}

test_ersatzposition_zaehlt_einmal if {
	a := object.union(kuh, {"abgang": "2026-07-01"})
	b := object.union(kuh, {"tier_id": "R2", "kategorie": "Zuchtstier", "beginn": "2026-08-05", "zuchteinsatz_im_jahr": true})
	d := profil([a, b])
	p.grundbetraege == {"R1": 334.8} with input as d
	count(p.ersatzfristen) == 1 with input as d
	p.grundbetraege == {} with input as profil([a, object.union(b, {"rinderdatenbank_zugang": false})])
	p.grundbetraege == {} with input as profil([a, object.union(b, {"beginn": "2026-08-06"})])
}

test_haltung_nach_august_2026 if {
	e := {"art": "Landwirtschaftsbetrieb", "von": "2026-09-01", "rueckkehr": "2026-12-01", "zuchtzweck": false}
	t := object.union(kuh, {"aufenthalte": [e]})
	p.grundbetraege == {"R1": 334.8} with input as profil([t])
}

test_minimum_fehlende_evidenz if {
	d := profil([object.remove(kuh, ["bestaetigung"])])
	p.grundbetraege == {} with input as d
	p.mindeststatus == "kein förderbares Stichtagstier belegt" with input as d
	p.mindeststatus == "kein Tier beantragt" with input.livestock.foerderpositionen as []
	p.tarifsumme_oder_null == null with input as d
}

test_tabellen if {
	every b in data.o6_5_tabellen.rassen {
		some meta in data.o6_5_tabellen.kategorien
		meta.tierart == b.tierart
		p.rasse({"rasse": b.rasse, "kategorie": meta.kategorie}) == object.remove(b, ["rasse"])
	}
	every r in data.o6_5_tabellen.tarife {
		some b in data.o6_5_tabellen.rassen
		b.tierart == p.kategorien_nach_name[r.kategorie].tierart
		t := {"rasse": b.rasse, "kategorie": r.kategorie, "gep_umgesetzt": false, "bestaetigung": {"milchleistungskontrolle": false}}
		p.tarif(t) == r[b.stufe] with input.farm.year as r.ab
	}
	p.kuerzungsreihenfolge(["Modulation", "Inhaltliche Kürzungen"]) == ["Inhaltliche Kürzungen", "Modulation"]
	p.ackerfutter("Kleegras")
}

test_gep_abstammung if {
	n := {"mehrere_hauptklassen": true, "neue_oberste_klasse": true, "beidseitig_moeglich": true, "vater_abgesichert": true, "mutter_abgesichert": true, "snp_bei_rind": true}
	p.abstammungspruefung(n, kuh)
	not p.abstammungspruefung(object.union(n, {"snp_bei_rind": false}), kuh)
	not p.abstammungspruefung(object.union(n, {"mutter_abgesichert": false}), kuh)
	p.genbanknutzung_ok({"genbanknutzung_technisch_moeglich": false})
	not p.genbanknutzung_ok({"genbanknutzung_technisch_moeglich": true, "einvernehmen_oengene_bedarf": true, "genbank_im_paarungsplan": false})
}

test_anhang_l_geltungsbereich if {
	count(data.o6_5_tabellen.einzelflaechenmatrix) == 21
	every z in data.o6_5_tabellen.einzelflaechenmatrix { count(z.spalten) == 21 }
	p.kombinationszelle("1B", "16").zeichen == "a"
	p.kombinationszelle("1A", "4").fussnote == 1
	p.kombinationszelle("1C", "1A").zeichen == null
	not p.kombinationszelle("5", "1A")
	not p.kombinationszelle("1A", "5")
	p.matrix_fussnote(4)
}

test_beide_belegten_firmenwortlaute if {
	p.zustaendig(kuh, "Rinderzucht Steiermark eG")
	p.zustaendig(kuh, "Rinderzucht Steiermark eGen")
	not p.zustaendig(kuh, "Rinderzucht Tirol eGen")
}

test_betriebsbestand_getrennt_von_einzeltierantrag if {
	b := [{"gve_kategorie": "Rinder ab 2 Jahre", "durchschnittsanzahl": 3}, {"gve_kategorie": "Ferkel ab 8 kg Lebendgewicht", "durchschnittsanzahl": 50}]
	d := {"land": {"grassland_area_ha": 8, "ackerfutterflaeche_ha": 2}, "livestock": {"bestandsberechnung": b, "foerderpositionen": []}}
	p.bestand_rgve == 3 with input as d
	p.tierhalter_nach_futterflaeche with input as d
	not p.minimum_erreicht with input as d
}
