# o6_9: unveränderte Modellnotizen

Sämtliche Modellannahmen sind unbestätigt. Auch nicht einzeln priorisierte Auslegungen müssen vor Übernahme geprüft werden.

## luna: `v2-o6_9-luna-high-20261002`

# Annahmen und offene fachliche Punkte

- Der Run arbeitet im Modus `discover`. Fehlende Eingaben für Ereignisse, Fütterung, düngungswürdige Fläche, Antrag und Ausstieg werden ausschließlich in `rules/profile_changes.json` vorgeschlagen; das Canonical Farm Profile bleibt unverändert.
- Die Rego-Policy verwendet eine explizite Entscheidungs-Eingabe unter `input` (Teilnahme, Ausbringung, Separation, Schweinefütterung und Berechnungsbasen). Die vorhandenen Profilfelder allein enthalten diese Ereignisse und Nachweise nicht.
- Die Informationsblätter sind laut Impressum rechtlich unverbindlich; die Sonderrichtlinie und ihre Anhänge sind deshalb zusätzlich als Quellenbelege erfasst. Die aktuelle Juni-2026-Fassung des Maßnahmenblatts wird für die ausführbare Auswertung verwendet.
- Die Futtertabelle enthält für gedeckte Jungsauen ab 50 kg im Maßnahmenblatt keine eigene Rohproteingrenze in der sichtbaren Tabellenzeile; sie ist im Katalog als offene fachliche Abgrenzung erhalten und nicht durch einen erfundenen Grenzwert ergänzt.
- Die Rego-Berechnung liefert die o6_9-Bruttoprämie vor allgemeiner Betriebsgrößenmodulation. Die Modulation ist als eigener Katalogsatz dokumentiert, weil dafür die Gesamtbetriebsfläche und ggf. weitere Abwicklungsdaten benötigt werden.
- Die 2026-Dürre- und Rebzikaden-Hinweise wurden vollständig gelesen. Ihre Ausnahmen betreffen andere Maßnahmen (Biodiversität, Begrünung, Ernteverpflichtung, Insektizidverzicht, Naturschutz bzw. Nutztierrassen) und werden daher in `rules/coverage.json` als `not_rule` geführt.
- Die Kombinationstabelle in Anhang L bestätigt die allgemeine Kombinierbarkeit von Maßnahme 9 mit mehreren Maßnahmen, enthält aber die gesonderte Unvereinbarkeit des gleichlautenden Schweinefütterungszuschlags aus Maßnahme 16 nicht als maschinenlesbare Detailbeschreibung; die präzise Sperre wird aus dem SRL-Haupttext und dem Maßnahmenblatt übernommen.


## opus: `v2-o6_9-opus-5.5-high-20260925`

# o6_9 – Annahmen und offene fachliche Fragen

Run: `v2-o6_9-opus-5.5-high-20260925` · Modus: `discover`

Die Quellen wurden wie folgt geprüft: Informationsblatt o6_9 (Stand Juni 2026) vollständig,
Allgemeine Teilnahmebedingungen (April 2026) vollständig, die vier 2026-Hinweise vollständig,
die SRL gezielt (Allgemeiner Teil S. 1–27, Kapitel 2.9 S. 61–63, Querverweise in 2.16 S. 74–77, S. 94)
und die Anhänge gezielt (Anhang A S. 3, Anhang L S. 103). Umfang und Begründungen stehen in `rules/coverage.json`.

## Annahmen in der Implementierung

- **A-01 Rohproteintabelle: Informationsblatt vs. SRL.** Die SRL (2.9 lit. a) ordnet den Durchschnittswert
  157 g der Gruppe „Jung- und Mastschweine ab 32 kg bis Mastende sowie Jungsauen nicht gedeckt ab 50 kg“ zu.
  Das Informationsblatt druckt 157 g in der Zeile „32 bis 60 kg“ und nennt nicht gedeckte Jungsauen „ab 32 kg“.
  Umgesetzt ist die SRL-Lesart: 157 g gelten als Durchschnitt über die ganze Mast (`fattening_average`),
  170/155/150 g als Phasengrenzen je Gewichtsklasse. Gedeckte Jungsauen ab 50 kg sind wie im Informationsblatt
  den tragenden Zuchtsauen (125 g) zugeordnet. In der SRL steht bei ihnen kein eigener Wert.
- **A-02 Liste der Biogas-Ausgangsstoffe.** Das Informationsblatt (Juni 2026) enthält zusätzlich
  „Maisquellwasser“ und die Einschränkung „wenn keine Speiseölreste“. Beides fehlt in der SRL (Stand 2024).
  Umgesetzt ist die aktuellere, weitere Liste des Informationsblatts. `in_srl` in
  `data/o6_9/manure_definitions.json` markiert die Abweichung.
- **A-03 Obergrenze 50 m³/ha bei mehreren Verfahren.** Die Quellen sagen nicht, welchem Verfahren die Kürzung
  zugeordnet wird. Umgesetzt ist eine anteilige Kürzung aller drei Verfahren (`slurry_scale`).
- **A-04 Grundlage der Prämie.** Laut SRL wird die Prämie nach der im MFA beantragten Menge gewährt.
  Übersteigt die beantragte Menge die förderfähig aufgezeichnete Menge, meldet die Policy einen Verstoß.
  Die konkrete Kürzung nach §§ 42–47 GSP-AV ist nicht modelliert, weil diese Normen nicht in den Quellen enthalten sind.
- **A-05 Düngungswürdige Fläche.** Ob ein Stickstoffdüngebedarf nach NAPV besteht, ist als Eingabe
  `has_n_fertilization_need` vorgesehen. Fehlt der Wert, wird ein Bedarf angenommen, weil die NAPV-Tabellen
  keine Quelle dieses Runs sind. Fehlt `is_pure_legume_stand`, gilt `crop_category == "legume"`
  vorsichtshalber als Reinbestand.
- **A-06 Ackerfläche für die Fütterung.** Die Schwelle von 1,00 GVE/ha bezieht sich auf die gesamte Ackerfläche
  ohne Abzüge (`land.arable_area_ha`). Die Prämie von 54 €/ha wird dagegen nur für prämienfähige Ackerschläge
  berechnet: keine Nationalpark-Flächen, kein Code OP, Ernteverpflichtung erfüllt.
  Ackerfutterflächen zählen als Ackerflächen.
- **A-07 Mindestbewirtschaftung.** Die Ernteverpflichtung (85 %) gilt für „in die Maßnahmen eingebrachte Flächen“.
  Bei o6_9 betrifft das nur die flächenbezogene Fütterungsprämie. Die Kategorien Ausbringung und Separierung
  werden nach Menge gefördert und nicht nach Fläche.
- **A-08 Dürre 2026.** Für den Abgleich mit der Bezirksliste wird `land.parcels[].district` verwendet, sonst
  `farm.region.district`; das Bundesland kommt aus `farm.region.federal_state`. „Alle Bezirke“ ist als `*` codiert.
- **A-09 Erlöschen des Vertrags.** Das Erlöschen wird über `oepul_applications[].lapsed_in_year` abgebildet.
  Ab dem Folgejahr ist ein neuer Antrag mit späterem Vertragsbeginn nötig.
- **A-10 Abmeldung.** Ein `withdrawn_on` am oder vor dem 31.12. des betrachteten Jahres macht die Maßnahme für
  dieses Jahr ungültig. Eine Abmeldung ab dem 01.01. des Folgejahres lässt das laufende Jahr gültig.
- **A-11 Modulation.** Der Faktor wird gewichtet aus `land.total_area_ha` berechnet (Beispiel 220 ha → 99,09 %).
  Die Quellen verlangen die Modulation für „alle Maßnahmen“.
- **A-12 Obergrenze für Flächenzahlungen.** Nur als Daten und Lookup-Funktion umgesetzt. Die Summe der übrigen
  Flächenzahlungen je Schlag aus anderen Maßnahmen kennt das Profil nicht.
- **A-13 Sanktionsstufen.** Welche Stufe ein konkreter Verstoß bekommt, regelt das automatisierte Schema nach
  § 48 GSP-AV. Dieses ist nicht Teil der Quellen. Deshalb gibt es nur die Lookup-Funktion
  `sanction_reduction_share(stage, year)`.
- **A-14 Anhang L.** Die PDF-Seite ließ sich nicht rendern, daher wurde Zeile 9 aus dem Textextrakt
  rekonstruiert. Die Spalte 9 der symmetrischen Zeilen stützt das Ergebnis: Die Zeilen 2, 3, 6, 7, 8, 16, 17
  und 24 haben dort ein „x“.
- **A-15 Ausgeschlossene Verfahren.** Ausdrücklich ausgeschlossen sind nur Schwenkverteiler und Prallteller am
  Düsenbalken. `broadcast`, `incorporation` und `unknown` sind aus dem Grundsatz „Geräte, die den Dünger
  unmittelbar auf oder in den Boden ablegen“ abgeleitet.
- **A-16 OP-Code.** Geprüft wird nur der allgemeine Code `OP`. Einen maßnahmenbezogenen OP-Code für o6_9
  nennen die Quellen nicht.
- **A-17 Bagatellgrenze 50 €.** Sie wird auf die o6_9-Prämie nach Modulation angewendet. In der Praxis bezieht
  sie sich auf den gesamten Auszahlungsbetrag.
- **A-18 Letzter Einstieg in die Fütterung (2028).** Umgesetzt als: fristgerechter Antrag mit Vertragsbeginn
  2025–2028 und gültiger o6_9-Vertrag im betrachteten Jahr.
- **A-19 Prämiensätze 2023.** Sie stammen aus dem Informationsblatt. Die SRL-Fassung 2024 nennt nur die Sätze
  ab 2024.
- **A-20 GVE.** Vorrang hat der Jahresdurchschnitt (`gve_annual_average`). Sonst wird Faktor (Anhang A) ×
  durchschnittliche Stückzahl gerechnet, auf sechs Nachkommastellen gerundet, danach das Profilfeld `gve`.
  Bei Rindern stehen die Faktoren in der RGVE-Spalte von Anhang A; sie werden als Rinder-GVE verwendet.

## Offene fachliche Fragen

1. **Wasseranteile.** Wie viel sind ein „geringer Anteil“ Regenwasser bzw. ein „unvermeidlicher Anteil“
   Stallwaschwasser? Die Quellen nennen keine Schwelle. Die Regel ist nur als Daten und Katalogeintrag erfasst.
2. **Betriebsfremde Gülle.** Darf zugekaufte Gülle oder Biogasgülle aus fremden Anlagen bodennah ausgebracht
   werden? Die Quellen schränken die Herkunft nur für die Separierung ein, daher prüft die Policy die Herkunft
   bei der Ausbringung nicht.
3. **Wann „Nachweise“ fehlen.** Rechnungen, Biogas-Zertifikate und Rezepturen fließen nur als Verstöße ein;
   die Prämie wird dadurch nicht automatisch gestrichen.
4. **Takeover.** Übernahmen sind nur bei Betriebsauflösung, -teilung oder -zusammenlegung möglich. Die
   Genehmigung durch die AMA ist nicht modelliert.
5. **Nicht anwendbare 2026-Hinweise.** Die Hinweise zu Biodiversitätsflächen und zum Insektizidverzicht sowie
   weitere Dürre-Erleichterungen betreffen andere Maßnahmen und sind in `coverage.json` als `not_rule` erfasst.
