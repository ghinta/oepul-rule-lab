# o6_3: unveränderte Modellnotizen

Sämtliche Modellannahmen sind unbestätigt. Auch nicht einzeln priorisierte Auslegungen müssen vor Übernahme geprüft werden.

## luna: `v2-o6_3-luna-high-20261001`

# Fachliche Mehrdeutigkeiten und Abgrenzungen

- Das Maßnahmenblatt ist die Ausgabe „Stand Oktober 2025“, während die allgemeinen Teilnahmebedingungen den Stand April 2026 haben. Für die o6_3-Prämiensätze und die Zweitkultur-Präzisierung wird die aktuellere o6_3-Fassung verwendet; allgemeine Vertrags-, Flächenzugangs- und Sanktionsregeln stammen aus der allgemeinen Fassung bzw. der Sonderrichtlinie.
- Die Sonderrichtlinie nennt bei der Zugangskombination ausdrücklich 1A oder 1B; das aktuelle Maßnahmenblatt nennt zusätzlich „Biologische Wirtschaftsweise – Teilbetrieb“. Die Ausführbarkeit behandelt diesen Teilbetrieb als zulässige BIO-Kombinationskennung, die primäre rechtliche Belegstelle bleibt 1A/1B.
- „Überwiegender Teil der Vegetationsperiode“ ist in den Quellen nicht in einer festen Tageszahl quantifiziert. Rego erwartet deshalb ein belegtes boolesches Prüfergebnis `green_feeding_majority_april_to_september` und entscheidet nicht eigenständig, wie viele Tage „überwiegend“ sind.
- Die RGVE-Tabelle ist in `data/o6_3_tables.json` vollständig für die in Anhang A für Raufutterverzehrer relevanten Kategorien erfasst. Schweinewerte aus Anhang A sind nicht einbezogen, weil sie für den RGVE-Schlüssel der Heuwirtschaft nicht als raufutterverzehrende RGVE bezeichnet sind.
- Die Tabellenzeile in Anhang L bestätigt die Kombinierbarkeit von Heuwirtschaft; die konkreten Zugangsbedingungen der Maßnahme bestimmen die ausführbare zulässige Kombination. Unklare Leerzeichen der PDF-Textdarstellung werden daher nicht als zusätzliche Kombinationen interpretiert.
- Die 2026-Meldung vom 5. August enthält eine allgemeine Ausnahme für die Ernteverpflichtung auf Ackerflächen bei dürrebedingt nicht erntbarem Bestand in einer veröffentlichten Gebietskulisse; weil Ackerfutterflächen unter o6_3 fallen können, wird diese zeitlich begrenzte Regel als O63.DROUGHT_2026_ARABLE_EXCEPTION erfasst. Die übrigen Biodiversitäts-, Begrünungs-, Naturschutz-, Natura-2000-, Insektizid- und Nutztierrassen-Ausnahmen ändern keine o6_3-Auflage.
- Für die allgemeine Betriebsgrößenmodulation wird der Faktor als Regelkatalog erfasst. Die Rego-Referenzimplementierung berechnet die maßnahmenspezifische Prämie und meldet o6_3-Verstöße; sie wendet die allgemeine Modulation nicht nochmals in `premium_eur` an, weil dafür das separate Gesamtbetriebsflächenfeld erst als Profile-Change vorgeschlagen wird.


## opus: `v2-o6_3-opus-5.5-high-20260930`

# Annahmen und offene Fragen – o6_3 Heuwirtschaft (Run v2-o6_3-opus-5.5-high-20260930)

## Quellenrang
- Das Merkblatt (Stand Oktober 2025) ist laut Impressum rechtlich unverbindlich. Bei Abweichungen gilt die Sonderrichtlinie (SRL) samt Anhängen. Inhaltliche Widersprüche wurden nicht gefunden. Das Merkblatt ist nur ausführlicher, etwa bei Neben-/Koppelprodukten, beim Kreiseln und bei der Grünfutterabgabe.
- Die SRL (Fassung 2024-0.489.174) nennt nur die Sätze ab 2024 (145,8/167,4 €/ha). Die Sätze für 2023 (135,0/155,0 €/ha) stammen aus dem Merkblatt und entsprechen der Erhöhung um 8 % laut Präambel 1a.

## Tierhaltereigenschaft
- Der Viehbesatz wird ungerundet mit 0,30 RGVE/ha verglichen. Das Merkblatt-Beispiel rundet nur für die Anzeige (0,38).
- Zur Futterfläche zählt die gesamte Grünlandfläche (`land_use == grassland`), also auch Streuwiesen, Bergmähder, Dauerweiden und Hutweiden. Dazu kommen Ackerfutterflächen inklusive Ackerweide, ohne Zweitkulturen. Almweideflächen (`alpine_pasture`) zählen nicht dazu. Das Merkblatt nennt nur „Summe der Grünland- und Ackerfutterflächen“, die Nutzungsart Alm ist dort nicht ausdrücklich geregelt.
- Liegt `average_count` vor, wird es vor `animal_count` verwendet. Damit sind die Durchschnittstierliste bzw. der Durchschnittsbestand laut Rinderdatenbank abgebildet. Die taggenaue Berechnung und die Zurechnung beim Betriebsstrukturwechsel werden als vorab berechneter Durchschnittsbestand erwartet.
- Equiden mit genau 1,48 m Widerristhöhe und genau 300 kg gehören laut Merkblatt zur kleinen Kategorie. Für Grenzfälle mit „über 1,48 m **oder** über 300 kg“ (Anhang A: „und/oder“) ist die Wahl der Kategorie Teil der Eingabe (`rgve_category`).

## Mindestteilnahme / Prämienfähigkeit
- Für die 2-ha-Mindestfläche zählt jede Grünlandparzelle mit `grassland_type == maehwiese_maehweide`, auch wenn sie in „Naturschutz“ eingebracht ist. Eine tatsächliche Mahd wird dafür nicht geprüft, weil die Quelle „bewirtschaftet“ verlangt.
- Prämienfähig sind nur tatsächlich gemähte Flächen, also Flächen mit mindestens einem Eintrag in `cutting_dates`. Das gilt auch für Mähwiesen und Mähweiden, gestützt auf „gemähte Grünlandflächen“ in Kap. 1.
- Kombinierbarkeit auf der Einzelfläche (Anhang L): Ist eine Parzelle zusätzlich in einer nicht kombinierbaren Maßnahme (z. B. 18 Naturschutz, 4 Bergmähder, 8 Erosionsschutz Acker) beantragt, gibt es auf ihr keine Heuwirtschaftsprämie. Sie zählt aber weiter zur Mindest- und zur Futterfläche. Bei Naturschutz fließt stattdessen der GM01-Zuschlag (108 €/ha) in die Naturschutzprämie. Die Matrix wurde spaltengenau aus den PDF-Koordinaten von Seite 103 rekonstruiert, ihre Symmetrie ist geprüft.
- Ein maßnahmenbezogener OP-Code für die Heuwirtschaft wird generisch über `op_measures` mit dem Eintrag `o6_3` abgebildet. Ein offizieller Codename (z. B. „OPHEU“) ist in den Quellen nicht genannt.
- Flächenzugangsbeschränkung ab 2026: Deckel ist `Basis 2025 + max(50 % × Basis 2025; 5 ha)`, nur für Grünland. Flächen, die vorher schon in derselben Maßnahme waren, gelten laut Quelle nicht als Zugang. Das muss bereits in der Basis-/Istfläche berücksichtigt sein.

## Grünfütterung
- „Überwiegender Teil der Vegetationsperiode“ (1.4.–30.9. = 183 Tage) wird als mehr als 50 % der Tage umgesetzt, also mindestens 92 Tage. Eingrasen/Weide am Heimbetrieb und Tage auf Gemeinschaftsweide/Alm werden addiert. Keine Quelle verlangt eine tägliche Mindestdauer; Tage mit teilweiser Grünfütterung zählen daher voll. Das ist offen.
- Die Prüfung greift nur, wenn raufutterverzehrende Tiere (RGVE > 0) gehalten werden.

## Sanktionen und Abwicklung
- Die Zuordnung eines Verstoßes zu einer Kürzungsstufe (Schwere, Ausmaß, Dauer, Häufigkeit) folgt einem AMA-internen Schema, das nicht veröffentlicht ist. Abgebildet sind nur die Stufenanteile (`sanction_share`) und der Ausschluss nach zweimaliger 100-%-Kürzung.
- Die Obergrenzenprüfung (GEN-CAP-01) setzt die übrigen gedeckelten ÖPUL-Zahlungen je Schlag als Eingabe voraus. Wie ausgenommene Maßnahmen (6, 7, 10/1C) behandelt werden, gibt die Tabelle `premium_caps` vor. Die Eingabe muss sie bereits herausrechnen.
- Die Modulation wird auf `land.total_area_ha` angewendet, ohne Alm (getrennte Betrachtung laut 9.3).
- Anerkannte höhere Gewalt (`farm.oepul.force_majeure.recognised`) unterdrückt pauschal alle inhaltlichen Verstöße des Jahres. Die tatsächliche Anerkennung erfolgt einzelfallbezogen durch die AMA.

## 2026-Hinweise
- Die Dürre-Hinweise vom 05.08. und 12.08.2026 (Ernteverpflichtung, Begrünung, Untersaaten, Biodiversitätsflächen, Naturschutztermine, Nutztierrassen) betreffen keine Verpflichtung der Heuwirtschaft. Die Ernteverpflichtung gilt nur für Ackerflächen ohne Ackerfutter. Sie sind in `coverage.json` als `not_rule` begründet.
- Der Hinweis vom 22.05.2026 wird nur mit seinen allgemeinen Aussagen übernommen: Antrag auf höhere Gewalt bei trockenheitsbedingt nicht einhaltbaren Verpflichtungen, Berücksichtigung des Grundfutterbedarfs auf der Weide bei Vor-Ort-Kontrollen. Das kann etwa die Grünfütterungspflicht betreffen. Eine automatische Anerkennung für die Heuwirtschaft sieht keine Quelle vor.
- Der Rebzikade-Hinweis (12.06.2026) betrifft nur die Maßnahme 12.

## Offene Fragen
1. Gilt eine vor Vertragsbeginn angeschaffte, aber stillgelegte Mähaufbereiter-Einheit als „am Betrieb vorhanden“? Aktuell zählt jedes vorhandene Gerät als Verstoß.
2. Zählt eine Streuwiese in der Futterflächenberechnung, wenn sie nur zur Einstreu genutzt wird? Aktuell ja, weil sie Grünland ist.
3. Die Kombinationsverpflichtung muss laut Merkblatt „zeitgleich“ erfüllt sein. Sie wird jährlich geprüft. Bei Wegfall ab dem 2. Jahr gibt es keine Prämie (SRL 1.12.1.1); ob zusätzlich eine Rückforderung aus dem Vertragszeitraum folgt, ist nicht abschließend geregelt.
