# o6_1b: unveränderte Modellnotizen

Sämtliche Modellannahmen sind unbestätigt. Auch nicht einzeln priorisierte Auslegungen müssen vor Übernahme geprüft werden.

## luna: `v2-o6_1b-luna-high-20260930`

# Annahmen und offene Punkte

- Der Auftrag verwendet `o6_1b` als technische Maßnahme-ID. Die Sonderrichtlinie bezeichnet dieselbe Maßnahme als „Biologische Wirtschaftsweise (1B)“; abweichende Schreibweisen in den Quellen wurden als dieselbe Maßnahme normalisiert.
- Die Informationsblätter sind rechtlich unverbindliche Aufbereitungen. Für die ausführbare Regel wird die Sonderrichtlinie als vorrangiger Beleg verwendet, wenn sie eine Aussage parallel enthält.
- Die vier 2026-HTML-Hinweise sind zeitbezogene Ergänzungen. Ihre `page`-Referenz bleibt deshalb `null`; Abschnitt und wörtlicher HTML-Beleg identifizieren die Fundstelle.
- Die Dürre-Hinweise vom 05.08. und 12.08.2026 betreffen überwiegend andere ÖPUL-Maßnahmen. Übernommen wurden nur Aussagen mit unmittelbarer Wirkung auf BIO-DIV oder das allgemeine Verfahren höherer Gewalt; die Mitteilung vom 12.06.2026 zum Insektizidverzicht wurde als `not_rule` dokumentiert.
- Das Canonical Farm Profile ist ein Typ-/Strukturprofil und enthält keine konkreten Antrags-, Code-, Fristen-, Varianten- oder Aggregatfelder. Diese wurden im Modus `discover` als Vorschläge dokumentiert, ohne das Canonical Profile zu ändern.
- Die Rego-Schnittstelle erwartet für aggregierte Prüfungen die im Katalog beschriebenen Eingabepfade, insbesondere `land.arable_biodiversity_area_ha`, `land.grassland_biodiversity_area_ha`, `biodiversity`, `training`, `monitoring` und `pheromone_traps`.
- Die 2026-Ausnahme für vorzeitige DIV-Nutzung ist prämienbezogen: OPBIO/OPUBB bedeutet, dass die betroffene Fläche für die Maßnahme keine Prämie erhält; die übrigen einschlägigen Bewirtschaftungsauflagen bleiben grundsätzlich bestehen.
- Die aus Anhang C übernommenen Artenlisten werden als geschlossene Datenlisten geführt. Die Ausnahme für zertifiziertes Ökotypensaatgut wird als fachliche Ausnahme der Mischungsprüfung dokumentiert und nicht als Erweiterung der statischen Artenliste interpretiert.


## opus: `v2-o6_1b-opus-5.5-high-20260925`

# Annahmen und offene Punkte – o6_1b „Biologische Wirtschaftsweise“

Run: `v2-o6_1b-opus-5.5-high-20260925` · Modus: `discover`

## 1. Quellen und Umfang

- Vollständig gelesen und im Coverage-Ledger erfasst: Informationsblatt o6_1b (Stand April 2026, 51 S.),
  Allgemeine Teilnahmebedingungen (Stand April 2026, 21 S.) und die vier AMA-Hinweise 2026
  (22.05., 12.06., 05.08., 12.08.).
- Sonderrichtlinie ÖPUL 2023: gezielt geprüft. Präambel, Allgemeiner Teil 1.1–1.20 (S. 3–27) und
  Maßnahme 2.1 B (S. 36–45) wurden vollständig gelesen. Die übrigen Maßnahmen wurden per Volltextsuche
  nach „Biologische Wirtschaftsweise“ bzw. „(1B)“ auf Querverweise geprüft (S. 60, 65, 77, 78, 83, 92, 94).
- Anhänge: A (GVE-Schlüssel), B (Sortenliste), C (autochthone Arten) und L (Kombinationstabelle)
  inklusive Fußnoten. Die Anhänge D–K betreffen andere Maßnahmen.
- Die SHA-256-Werte aller Quellen stimmen mit `sources/manifest.json` überein.
- Laut Impressum sind die Informationsblätter rechtlich unverbindlich. Bei Abweichungen wird dies unten
  vermerkt. Rechtlich maßgeblich ist die Sonderrichtlinie; die Umsetzung folgt dem aktuelleren
  Informationsblatt, sofern es die Sonderrichtlinie nur präzisiert.

## 2. Eingabemodell (Rego) und Profilvorschläge

- Die Rego-Regeln lesen die Pfade des Canonical Farm Profile, soweit vorhanden
  (`farm.year`, `farm.region.*`, `land.parcels[]`, `livestock.species_groups[]`, `land.total_area_ha`).
- Alle zusätzlich benötigten Felder stehen als Vorschläge in `rules/profile_changes.json` (33 Einträge):
  Schlagnutzungsart, MFA-Codes, Feldstücke, Biodiversitätsangaben, datierte Nutzungsereignisse,
  Landschaftselemente, Mehrnutzenhecken, RGVE-Schlüssel sowie der Abschnitt `oepul`.
- `livestock.species_groups[].animal_count` wird als Jahresdurchschnittsbestand interpretiert
  (Rinderdatenbank bzw. Durchschnittstierliste, ATB 5.7).
- Datumsangaben sind ISO-Strings (`YYYY-MM-DD`). Fristvergleiche erfolgen tagesgenau.
- Ob ein Verstoß vorliegt, wird deterministisch aus den Eingaben geprüft. Die daraus folgende
  Kürzungsstufe legt die AMA nach einem nicht veröffentlichten Schema fest. Sie wird deshalb als Eingabe
  (`oepul.o6_1b.sanction_level`) übernommen und nur in einen Prozentsatz umgerechnet.
- Pfade in `coverage.json` und `data_inventory.json` beginnen wie in `citations.json` mit `workspace/`
  und sind damit vom Run-Verzeichnis aus auflösbar.

- Einzelne Skalarparameter sind in `data/` zu Objekten gruppiert (`general.deadlines`,
  `general.tolerances`, `lists.parameters`, `notices_2026.deadlines`, `rgve_key.thresholds`), damit jede
  inventarisierte Tabelle ein JSON-Objekt oder -Array ist. Bei Objekten zählt `row_count` die
  enthaltenen Blattwerte. Die Fußnoten 1)–4) von Anhang L stehen vollständig in `combination.footnotes`.
- Erweiterungen bestehender Profilobjekte (`land.parcels[].crop`, `.operations`,
  `.constraints.biodiversity_area`) sind als einzelne `add`-Vorschläge je neuem Unterfeld formuliert.
  Die vorhandenen Felder des Canonical Farm Profile bleiben unverändert.
- Wörtliche Belege enden nie mit einem am Zeilenende getrennten Wort. Sie werden sowohl gegen den
  Seitentext als auch gegen die enttrennte Fassung geprüft.

## 3. Technische Anmerkung zur OPA-Binary

- Die mitgelieferte OPA-Binary (1.18.2, Build „-dirty“) vergleicht Ganzzahlen falsch mit
  Gleitkomma-Literalen, deren Wert ganzzahlig ist. Beispiele: `1 >= 10.0` ergibt `true`, ebenso
  `3 >= 30.0`.
- Deshalb wurden alle ganzzahligen Werte in `data/` als Ganzzahlen gespeichert (z. B. `235` statt
  `235.0`), und die Policies enthalten keine Literale der Form `x.0`. Nicht ganzzahlige Werte wie
  `0.07` oder `221.4` sind nicht betroffen.

## 4. Fachliche Mehrdeutigkeiten und getroffene Auslegungen

- **A-01 Monitoring Phänoflex / Schnittzeit nach Phänologie (Kap. 7.5).** Im Informationsblatt fehlt
  vor „Schnittzeit nach Phänologie“ der Aufzählungspunkt, sodass die Kombinationsverpflichtung
  (GL06/GL15/GL25) auch Phänoflex zuzuordnen sein könnte. Die Sonderrichtlinie (lit. d) ordnet sie nur
  „Schnittzeit nach Phänologie“ zu; so ist es umgesetzt. Phänoflex hat keine Kombinationspflicht.
- **A-02 Zuschlag „je angefangene 3 ha“ (8.3/9.3).** Gezählt werden alle DIV-codierten Schläge über
  0,05 ha, einschließlich der aus anderen Maßnahmen angerechneten. Die Quellen schließen diese nicht
  ausdrücklich aus. Der Zuschlag wird nur auf Biodiversitätsflächen gewährt, die über die Bio-Maßnahme
  prämienfähig sind, und ist auf 20 % der Fläche begrenzt.
- **A-03 75/25-%-Regel mit Projektbestätigung (6.1.4.2).** Laut Beispiel belastet eine vor dem
  1. August genutzte NAT/EBW-Fläche den 25-%-Anteil, ist wegen des Vorrangs der Projektbestätigung aber
  selbst kein Verstoß. Ein Verstoß (DA-018) liegt nur vor, wenn zusätzlich reguläre DIV-Flächen früh
  genutzt werden und der gesamte Frühnutzungsanteil 25 % übersteigt. Flächen mit OPBIO-Codierung
  (Dürre 2026) und mit der Ausnahme für invasive Arten zählen nicht mit.
- **A-04 Grünbrache in der Basismodulprämie (11.2).** Die Grenze von 20 % der Ackerfläche gilt für
  DIV-codierte Grünbrachen. Grünbrachen ohne DIV sind nicht förderfähig (ATB 5.5.1) und erhalten keine
  Prämie.
- **A-05 Altgras-Zuschlag DIVAGF.** Er steht in der Tabelle im Block „Zuschläge für
  Biodiversitätsflächen (jeweils bis max. 20 %)“ und ist daher ebenfalls auf 20 % der gemähten
  Grünlandfläche begrenzt.
- **A-06 Förderwürdige Kulturen, 15-%-Schwelle.** Die „über 7 % hinausgehenden Biodiversitätsflächen“
  werden aus der gesamten Acker-DIV-Fläche einschließlich der NAT-angerechneten Flächen berechnet
  (Beispiel 8.6: 10 % + 3 % → 6 %). Die 40-%-Kappung gilt nur für die förderwürdigen Kulturflächen.
  Zweitkulturen erhalten den höheren Satz; die Fläche zählt nur einmal.
- **A-07 Kappung der Landschaftselemente (80 je ha Feldstück).** Die Quellen legen keine Reihenfolge
  fest. Streuobstbäume (höherer Satz) werden vorrangig berücksichtigt, danach andere Elemente. Die
  Kappung verwendet `floor(80 × Feldstücksfläche)`.
- **A-08 Kreislaufwirtschaft.** Für Acker wird „nicht-tierhaltend oder tierhaltend < 1,4 RGVE/ha“ als
  Viehbesatz < 1,40 RGVE/ha Futterfläche umgesetzt. Beim Grünland zählen im Zähler alle anrechenbaren
  Grünland-DIV (auch NAT/EBW/N2), artenreiches Grünland aus o6_17 und – bei Teilnahme an o6_17 –
  einmähdige Wiesen und Streuwiesen. Der Nenner ist das gemähte Grünland ohne Bergmähder.
- **A-09 DIVSZ-Termine.** Die phänologische Vorverlegung (max. 10 Tage) und die Vorverlegung 2026 um
  14 Tage (mit OPBIO) werden auf den frühesten Termin (15.6.) und auf den „jedenfalls“-Termin (15.7.)
  angewendet. Der Termin der zweiten Mahd vergleichbarer Schläge bleibt die untere Grenze
  (Beispiel Tirol/Vorarlberg).
- **A-10 DIVNFZ-Ruhezeitraum.** Der Zeitraum beginnt am Tag nach `first_use_completed_date`
  (Ballenabtransport bzw. Weidepflege). Fehlt dieses Datum, wird das Datum der ersten Nutzung
  verwendet. Nutzung, Befahren und Düngung sind am 64. Tag wieder zulässig (Beispiel 24.6. → 27.8.).
- **A-11 Pheromonfallen – Aufbewahrungsfrist.** Das Informationsblatt nennt den 30. September, die
  Sonderrichtlinie das „Ende der Vegetationsperiode“. In `data/` ist der Wert des Informationsblatts
  (30.9.) hinterlegt; geprüft wird nur das Vorhandensein der Aufzeichnungen.
- **A-12 Unter bzw. bis 10 ha Ackerfläche (Ersatz über Grünland).** Das Informationsblatt schreibt
  „unter 10,00 ha“, die Sonderrichtlinie „bis 10 ha“. Umgesetzt ist die Formulierung des aktuelleren
  Informationsblatts (`< 10`).
- **A-13 Querverweis „Punkt 2.1.9-5“ in der Sonderrichtlinie (Ersatz über Grünland).** Er wird als
  Verweis auf die Bewirtschaftungsvarianten für Grünland-Biodiversitätsflächen (Kap. 6.2.4 des
  Informationsblatts) gelesen.
- **A-14 Teilbetrieb – getrennte Lagerung.** Die Sonderrichtlinie nennt Pflanzenschutz-, Düngemittel
  und Saatgut, das Informationsblatt zusätzlich Futtermittel. Die Eingabe ist ein einzelnes Boolean,
  das alle Betriebsmittel abdeckt.
- **A-15 Normalisierungstabellen.** `crop_species_map` (botanische Art) und
  `erosion_prone_crop_aliases` (Singular-/Nutzungsformen der erosionsgefährdeten Kulturen) sind eigene
  Zuordnungen, keine Quellentabellen. Nicht zugeordnete Kulturnamen werden unverändert als Art
  behandelt; mit `crop.species` lässt sich die Art explizit angeben.
- **A-16 Artenlisten.** Die Daten übernehmen Kapitel 14 des Informationsblatts. Gegenüber Anhang C gibt
  es nur typografische Abweichungen (z. B. „Plantago lanceolate“ im Informationsblatt statt
  „lanceolata“, Silbentrennungen). Geprüft wird in Rego die Anzahl der Arten, Familien und listenfremden
  Arten; Einzelnamen werden nicht abgeglichen.
- **A-17 Weiterbildung.** Ein Verstoß wird erst ab dem Antragsjahr 2026 festgestellt (Frist 31.12.2025).
  Im Jahr 2025 gilt die Verpflichtung noch als offen.
- **A-18 Mindestauszahlung.** „Kann abgesehen werden“ (≤ 50 €) wird nur als Kennzeichen ausgegeben
  (`payout_may_be_withheld`), nicht als automatische Nullstellung.
- **A-19 Prämienobergrenze je Schlag.** Die Summe aller ÖPUL-Flächenzahlungen je Schlag enthält Prämien
  anderer Maßnahmen. Sie wird als Eingabe `oepul_area_payment_eur_per_ha` erwartet; Rego meldet
  überschrittene Schläge (`capped_parcels`), rechnet aber keine anderen Maßnahmen.
- **A-20 Dürre-Gebietskulisse 2026.** Die Meldungen nennen keine geschlossene Kulturliste („Ackerkulturen,
  die üblicherweise erst im Spätsommer oder Herbst geerntet werden“). Das wird über das Eingabe-Flag
  `crop.late_harvest_crop` abgebildet. Die Bezirkszuordnung erfolgt schlagbezogen, ersatzweise über
  `farm.region`.
- **A-21 Rebzikade (12.06.2026).** Die Meldung betrifft o6_12. Für o6_1b ist sie nur bei Teilbetrieben
  relevant, deren konventioneller Wein-Kulturbereich an o6_12 teilnimmt. Sie ist daher nur im Katalog
  erfasst (N26-011/-012) und nicht in Rego ausgewertet.
- **A-22 Zweijährigkeit und Mindestpflege.** Die Prüfungen „mindestens 1 Nutzung in zwei Jahren“ und
  „Mahd mit Verbringung im Jahr“ werden nur ausgewertet, wenn `year_complete = true` ist. So entstehen
  keine Fehlalarme während eines laufenden Jahres.
- **A-23 SLK „auf einer Fläche pro Förderjahr nur einmal“.** Jeder Schlag trägt genau eine Sorte; eine
  Mehrfachgewährung ist damit strukturell ausgeschlossen. Die Kappung von 10 ha je Sorte ist umgesetzt.
- **A-24 Grünland-Basismodulprämie.** Bergmähder zählen zur Grünland-Basisprämie; sie sind nur von der
  Bezugsbasis der Biodiversitätsflächen ausgenommen. Almweideflächen (`alpine_pasture`) sind nicht
  Maßnahmenfläche.
- **A-25 Zugangsvoraussetzungen.** Die Regeln ZT-001, ATB-001/-002/-003, VZ-003, AN-001/-002 und
  TB-001/-005 werden als Zugangsvoraussetzungen behandelt (SRL 1.12.1.1). Folge: kein Vertrag im
  1. Jahr, danach keine Prämie im betroffenen Jahr.
- **A-26 Erosionsabschlag.** Die „überwiegende Hangneigung“ wird über `slope_percent` des Schlags
  abgebildet. Die volle Basisprämie setzt die Teilnahme an o6_8 und ein erosionsminderndes Verfahren
  auf dem Schlag voraus; bei Mulch-/Direktsaat/Strip-Till zusätzlich o6_6 oder o6_7.

## 5. Nicht in Rego ausgewertete Katalogregeln

Diese Regeln sind reine Dokumentations-, Verfahrens- oder Informationsaussagen oder hängen von
Behördenentscheidungen ab. Sie sind im Katalog mit Beleg erfasst, haben aber keine eigenständige
Rego-Entscheidung: TB-003, BV-001, BV-005, BV-006, PSM-002, GL-003, WB-004, WB-007, DA-015, DA-016,
DG-014, MO-004, ATB-019, ATB-023, ATB-024, ATB-029, N26-011, N26-012, N26-013. ATB-026
(Kombinationstabelle Anhang L) ist vollständig als Daten erfasst (`data/o6_1b/combination.json`); die
Maßnahmenausschlüsse auf Betriebsebene werden über AN-001/AN-002 in Rego geprüft.

