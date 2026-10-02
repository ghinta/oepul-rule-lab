# Annahmen und offene Fragen – o6_16 Vorbeugender Grundwasserschutz – Acker

Run: `v2-o6_16-opus-5.5-high-20261002` (Modus `discover`)

## Quellenlage und Rangfolge

- Das Informationsblatt (Stand April 2026) ist laut eigenem Hinweis rechtlich unverbindlich. Maßgeblich ist die
  Sonderrichtlinie ÖPUL 2023 (Fassung 2024-0.489.174). Wo das Infoblatt aktueller oder genauer ist (Sudangras,
  Wegfall der PSM-Codierung ab 2026), wurde es umgesetzt, weil es die Verwaltungspraxis 2026 abbildet.
- Die in den AMA-News vom 25.08.2026 erwähnte Meldung „Aufzeichnungsverpflichtungen bei der ÖPUL-Maßnahme
  Vorbeugender Grundwasserschutz – Acker“ liegt nicht als Quelle vor. Ihr Inhalt ist daher nicht berücksichtigt
  (Coverage: `unresolved`).
- GSP-AV, MOG 2021 und die Nitrat-Aktionsprogramm-Verordnung (NAPV) liegen nicht vor. Verweise auf sie (§ 8 Abs. 1,
  § 9 Abs. 6, Anlage 2 und 3 NAPV, § 6 GSP-AV) sind als Eingaben modelliert (z. B. `napv_compliant`,
  `n_available_kg_ha`, `readily_soluble_n`) und nicht inhaltlich nachgerechnet.

## Gebietskulisse (Anhang G)

- Die Kulisse wird über die KG-Nummer (`land.parcels[].cadastral_community_number`) gegen die vollständige
  KG-Liste aus Anhang G (1566 Zeilen, Seiten 40–59) bestimmt. Die Karten (Abbildungen bis 2024 / ab 2025) sind nicht
  maschinenlesbar; die KG-Liste wird als aktuelle Kulisse ab 2025 behandelt (die 1b-Markierungen auf S. 51–54
  deuten auf die Erweiterung 2025 hin). Für Jahre bis 2024 kann die Kulisse daher zu weit sein.
- In der Quelle steht KG 51106 (Bergham, Bad Wimsbach-Neydharting) doppelt; die Zeile wurde unverändert übernommen,
  die Rego-Abfrage dedupliziert.
- Politische Gemeinde und Katastralgemeinde sind im Textextrakt nicht eindeutig trennbar und stehen daher gemeinsam
  im Feld `gemeinde_und_katastralgemeinde`.
- Die Teilgebiete für den Reduktionsfaktor 80 % (nördliches/mittleres Burgenland, östliches Niederösterreich inkl.
  Tullnerfeld, Wien) sind in Anhang G nicht nach KG ausgewiesen. Wien wird aus Anhang G abgeleitet; für die übrigen
  Schläge muss `n_reduction_zone` angegeben werden, sonst meldet die Policy `missing_data`.

## Stickstoffbilanzierung

- Die Schwellen 10/20 kg/ha werden als „strikt größer“ gelesen (Beispiel Eferding 2025: 20 kg/ha → kein Übertrag).
- Maßgeblich ist das Antragsjahr der Folgekultur (`farm.year`); „ab 2025 bestehende oder angebaute Kulturen“ wird
  damit gleichgesetzt.
- Der Auslöser „Überschuss > 30 kg/ha“ für die Herbst-Anlagepflicht wird auf den Saldo vor Reduktionsfaktor bezogen.
- Der Übertrag wird auf zwei Nachkommastellen gerundet (Beispiel 12 × 0,6 = 7,2 kg/ha).
- Die Kettenbetrachtung über mehrere Kulturen (nicht-stickstoffzehrende Folgekulturen, mehrere Kulturen im Jahr,
  mehrjährige Kulturen, genutzte Zwischenfrüchte) ist als Regel erfasst, aber nicht als Ketten-Simulation
  implementiert: Die Policy prüft je Schlag den Übertrag aus der angegebenen Vorkultur.
- Für die Herbst-Anlagepflicht gilt die Teilnahme an o6_6/o6_7 plus `cover_crop.is_used` als Zwischenfrucht gemäß
  Begrünungsmaßnahme. Die Varianten-Detailauflagen von o6_6/o6_7 werden nicht geprüft.

## Pflanzenschutz

- Bentazon ist nur bei Wiederzulassung verboten. Der Status ist unbekannt; Standard `false`
  (`bentazon_reauthorized_default`), per Profilfeld überschreibbar.
- Die Codierpflicht PSMBIO/PSMCS (bis 2025) wird nur für Ackerflächen in der Kulisse geprüft (Kapitel 4.6 bezieht
  sich auf die Kulisse).
- Sudangras steht im Infoblatt 2026 (Verbot und Zuschlag), nicht aber in der SRL; umgesetzt nach dem Infoblatt.
- Zuckermais wird beim Zuschlag „Mais (ohne Saatmaisvermehrung)“ mitgezählt.
- „Schutz- und Schongebiete“ (kein PSM-Zuschlag) sind schlagbezogen über
  `oepul.in_protection_or_conservation_zone` erfasst; `farm.region.water_protection_zone` ist nur betriebsbezogen
  und wird dafür nicht verwendet.

## Oberösterreich

- Die Sperrzeiträume reichen über den Jahreswechsel und werden über den Monat/Tag geprüft (inklusive
  Grenztage). Ackerfutter ist vom allgemeinen Sperrzeitraum 15.10.–15.02. ausgenommen; für Mais gilt
  15.10.–21.03.
- Ob eine Gabe „leichtlöslich“ ist und wie viel N nach Stall- und Lagerverlusten verbleibt, wird als Eingabe
  übernommen (NAPV-Definitionen nicht verfügbar).
- Der Landes-Top-up wird gewährt, sofern `upper_austria_top_up_funds_available` nicht ausdrücklich `false` ist.

## Option auswaschungsgefährdete Ackerflächen (AG)

- Einsaatfrist und Begrünungsart werden nur im ersten AG-Jahr geprüft.
- „Mahd/Häckseln mindestens jedes zweite Jahr“ wird ab dem 2. AG-Jahr als „im laufenden oder vorigen Jahr erfolgt“
  geprüft.
- AG-Schläge sind von der Basisprämie und allen anderen o6_16-Zuschlägen ausgeschlossen (Annahme auch für den
  Schweinefütterungs-Zuschlag ab 2025, wegen „mit keiner anderen ÖPUL-Prämie kombinierbar“).
- Die 20-%-Grenze bezieht sich auf die gesamte Ackerfläche des Betriebes (`land.arable_area_ha`).

## Weiterbildung, Konzept, Bodenproben

- Fristen bis 31.12.2026 werden erst ab Profiljahr 2027 als Verstoß gewertet; im Jahr 2026 erscheinen sie als
  `obligations` mit Status `open` oder `fulfilled`.
- Die Basisfläche für die Probenanzahl ist die Kulissen-Ackerfläche des Profils; für ein Profiljahr ungleich 2026
  ist `soil_sample_base_area_ha` (MFA 2026) anzugeben.
- Für die Wiener Doppelproben werden Proben mit `area == "wien_gebiet"` gezählt; räumliche/zeitliche
  Projektvorgaben sind nicht modelliert.

## Schweinefütterung

- `animal_count` gilt als Jahresdurchschnittsbestand. Ist `gve` angegeben, hat es Vorrang vor der Berechnung
  über Anhang A (Profilfeld `category` = Code aus Anhang A).
- Infoblatt und SRL unterscheiden sich bei den Gewichtsgrenzen (Infoblatt „Jung- und Mastschweine sowie
  Jungsauen nicht gedeckt ab 32 bis 60 kg“, SRL „Jungsauen nicht gedeckt ab 50 kg“); die Fütterungskategorie wird
  daher als Eingabe (`feeding.feeding_category`) erwartet.
- Die Phasengrenzen werden über das Phasen-Startgewicht (32/60/90 kg) zugeordnet.

## Prämie und allgemeine Bedingungen

- Die Flächenzugangsbeschränkung (ab 2026 max. +50 % auf Basis 2025, mind. +5 ha) wird auf die Basisfläche
  angewendet, wenn `premium_area_2025_ha` angegeben ist; Flächen, die bereits mit der Maßnahme belegt waren, müssen
  in dieser Basis korrekt berücksichtigt sein.
- Die Modulation wird auf die o6_16-Prämie mit `land.total_area_ha` angewendet; die Obergrenze je ha Schlag
  (1.300 €/ha) ist nur als Funktion verfügbar, da Prämien anderer Maßnahmen nicht im Profil stehen.
- Der maßnahmenbezogene OP-Code für o6_16 wird als `OPGWA` angenommen (im allgemeinen Merkblatt nur als Beispiel
  genannt).
- Die Kombinationstabelle Anhang L ist im Textextrakt nicht spaltengenau; Zeile 16 wurde über die Symmetrie
  der Spalte 16 in den anderen Zeilen rekonstruiert (x: 1A, 3, 6, 7, 8, 9, 24; a: 1B, 2; übrige leer).

## 2026-Hinweise

- Die Dürre-Ausnahme zur Ernteverpflichtung wird über `farm.region.district` (betriebsbezogen) und das Bundesland
  aus Anhang G geprüft; Bezirksnamen müssen der Schreibweise der AMA-Meldung entsprechen.
- Die Erleichterungen für Acker-Biodiversitätsflächen betreffen o6_16 nur bei AG-Flächen mit DIV-Code; die
  25-%-Regel wird über die gesamte Acker-DIV-Fläche des Betriebes geprüft.
- Die Meldung zum vorzeitigen Ausstieg aus dem Insektizidverzicht (Rebzikade) betrifft nur o6_12 und ist
  `not_rule`.
