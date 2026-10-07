# o6_14: unveränderte Modellnotizen

Sämtliche Modellannahmen sind unbestätigt. Auch nicht einzeln priorisierte Auslegungen müssen vor Übernahme geprüft werden.

## luna: `v2-o6_14-luna-high-20261004`

# Fachliche Annahmen und offene Punkte

- Das Canonical Farm Profile enthält keine Almobjekte, Almauftriebsbewegungen,
  RGVE-Alterskategorien, Erschließungsstufen, Projektbestätigungen oder
  Auftriebsmeldungen. Die fehlenden Variablen sind deshalb ausschließlich in
  `rules/profile_changes.json` vorgeschlagen; das Canonical Profile bleibt
  unverändert.
- Die Rego-Eingabe verwendet `gve` als bereits anhand des 1.-Juli-
  Altersstichtags berechneten RGVE-Wert. Die vollständige Faktor-Tabelle aus
  Anhang A ist trotzdem als Datenbestand hinterlegt, damit die vorgelagerte
  RGVE-Berechnung reproduzierbar ergänzt werden kann.
- Bei Tieren, die zwischen mehreren Almen wechseln, erwartet die ausführbare
  Regel bereits die je Alm aufgeteilten `alpung_days` und `alm_id`. Die Quelle
  verlangt eine anteilige Berechnung; die konkrete Datenmodellierung der
  Meldungen ist eine offene Integrationsfrage.
- Für Anhang E wird der aus der Projektbestätigung übergebene Code als
  prämienrelevanter Satz modelliert. Ob mehrere Codes auf derselben Fläche
  additiv oder nach der konkreten Projektbestätigung ausschließend anzuwenden
  sind, wird von den vorliegenden Quellen nicht abschließend beschrieben und
  muss bei der Abwicklung geklärt werden.
- Der allgemeine Hinweis vom 22.05.2026 nennt fehlende Wasserversorgung auf
  Almen als Beispiel für ein Ansuchen auf höhere Gewalt. Er begründet keine
  automatische Anerkennung; die Rego-Regel bildet daher nur den belegten
  Antragstatbestand ab.
- Die drei 2026-Hinweise vom 05.08. und 12.08. betreffen Acker-Begrünung,
  Acker-Ernte, Untersaaten, Acker-Biodiversität, Naturschutz und gefährdete
  Nutztierrassen. Sie verändern keine unmittelbar auf o6_14 anwendbare
  Almauflage; sie sind in `rules/coverage.json` als geprüft und nicht
  maßnahmenrelevant dokumentiert.


## opus: `v2-o6_14-opus-5.5-high-20260926`

# Annahmen und offene Fragen – o6_14 Almbewirtschaftung

Run: `v2-o6_14-opus-5.5-high-20260926` (Modus `discover`)

## Annahmen

- **A-01 RGVE für die Mindestteilnahme (3,00 RGVE).** Gezählt wird die Summe der
  RGVE aller prämienfähigen Tiere (≥ 60 angerechnete Alpungstage, Auftrieb bis
  15.07., Anwesenheitsregel erfüllt), ohne anteilige Aufteilung auf Almen, weil
  die Mindestteilnahme betriebsbezogen gilt (`total_participating_rgve`). Die
  Quellen legen nicht fest, ob auch nicht prämienfähige Tiere zählen.
- **A-02 Tatsächliche und angerechnete Tage.** Für Viehbesatz,
  Mindestbestoßungsdauer je Alm und anteilige Aufteilung beim Viehbesatz werden
  die tatsächlichen Auf-/Abtriebsdaten verwendet. Für die Mindestweidedauer je
  Tier und die Prämien-RGVE werden die nach Meldedatum angerechneten Tage
  verwendet (max. 7 bzw. 14 Tage vor der Meldung). Fehlt ein Meldedatum, werden
  0 Tage angerechnet.
- **A-03 Folge einer Alm mit < 60 Bestoßungstagen.** Die Alm erhält keine
  Prämie (prämienfähige Fläche 0) und wird zusätzlich als Verstoß ausgewiesen.
  Der Katalog nennt die genaue Sanktion nicht.
- **A-04 Überbesatz.** Überbesatz wird als Verstoß gegen eine inhaltliche
  Verpflichtung ausgewiesen (Sanktion nach Schema, § 48 GSP-AV). Die berechnete
  Prämie wird dabei nicht automatisch gekürzt; `premium_total` ist ein Betrag
  vor inhaltlichen Kürzungen.
- **A-05 Nach dem 1. Juli geborene Tiere.** Sie sind laut Quelle nur beim
  Maximalviehbesatz ausgeschlossen. Für die Prämie werden sie mit der
  jüngsten Alterskategorie berücksichtigt, wenn sie sonst prämienfähig sind.
- **A-06 Mittelung des Erschließungszustands.** Das Mittel wird nach Alptagen
  (RGVE × Tage) gewichtet und auf eine ganze Stufe gerundet. Das Beispiel im
  Merkblatt (3.750/4.800 → Stufe 2) bestätigt das. Ob die Auftriebszeiten
  „vergleichbar“ sind, wird als Eingabe (`access_times_comparable`) erwartet.
- **A-07 Modulationsbasis.** Basis ist die Summe der prämienfähigen Hektar aller
  Almen, also je Alm min(Almweidefläche, RGVE). Das AMA-Beispiel „230 ha,
  250 RGVE → 98,66 %“ lässt sich damit rechnerisch nicht nachvollziehen:
  (200 + 30 × 0,9) / 230 = 98,70 %. Die Tests verwenden den gerechneten Wert,
  das Beispiel mit 220 ha (99,09 %) stimmt überein.
- **A-08 NATA-Auflagencodes (Anhang E).** Der Satz des jeweiligen Codes wird auf
  die gesamte prämienfähige Almweidefläche angewendet, weil die Aufwandsstufe als
  Anteil der Almweidefläche definiert ist. Für 2023 enthalten die Quellen keine
  Sätze der Codes (Sätze „gelten ab 01.01.2024“), daher gibt es 2023 keinen
  Code-Zuschlag.
- **A-09 Mindestbewirtschaftungskriterien.** Die allgemeinen Kriterien für
  Grünland (Mahd/Beweidung) werden für Almweideflächen durch die
  maßnahmenspezifische Bestoßungspflicht ersetzt und daher nicht gesondert
  geprüft.
- **A-10 Almweideplan-Zuschlag.** Er ist ebenfalls auf die prämienfähige Fläche
  (1 ha/RGVE) begrenzt und je Alm auf 20 ha gedeckelt. Jeder Verstoß gegen die
  Almweideplan-Pflichten (Kurs, Plan, Überprüfung, Begründung) entzieht den
  Zuschlag vollständig. Die Quelle nennt die Folge nicht.
- **A-11 NATA-Kurspflicht.** Ab dem Antragsjahr 2025 wird ein fehlender Kurs als
  Verstoß ausgewiesen (Frist 31.12.2025). Für 2023/2024 wird kein Verstoß
  ausgewiesen.
- **A-12 Anhang L.** Die Zeile „14 Almbewirtschaftung“ ist leer. Das wurde anhand
  der layouterhaltenden PDF-Extraktion der Seite 103 geprüft und als „auf der
  Einzelfläche mit keiner gelisteten Flächenmaßnahme kombinierbar“ gewertet. Die
  tierbezogenen Maßnahmen 15, 20, 21 sind in Anhang L nicht enthalten.
- **A-13 Auftrieb bis 15. Juli.** Die Frist gilt ohne die Ausnahme 17. Juli für
  2023/2028, weil das Merkblatt sie für diesen Punkt nicht nennt. Für die
  Auftriebsliste gilt der 17. Juli in 2023/2028.
- **A-14 Pflicht zur Auftriebsliste.** Eine reine Rinderalm liegt vor, wenn alle
  erfassten Aufenthalte auf der Alm Rinder betreffen.
- **A-15 Allgemeine Flächenabgangstoleranz** (5 % / 5 ha / 0,5 ha). Sie ist als
  Funktion umgesetzt, wird aber wegen der jährlichen Bindung der
  Almbewirtschaftung an verfügbare Flächen und Tiere (Punkt 1.7.2.5 SRL) nicht
  angewendet.
- **A-16 Tierwohl – Stallhaltung Rinder.** Der reduzierte Satz (162,0 €/RGVE)
  gilt, sobald ein Rind einen Almaufenthalt in der Eingabe hat. Die genaue
  Voraussetzung ist die tierbezogene Prämienbeantragung in Maßnahme 14.
- **A-17 2026-Hinweise.** Nur der Hinweis vom 22.05.2026 enthält Aussagen mit
  Almbezug (höhere Gewalt bei fehlender Wasserversorgung auf Almen;
  Berücksichtigung bei Vor-Ort-Kontrollen). Die übrigen drei Hinweise betreffen
  andere Maßnahmen und sind in der Coverage als `not_rule` geführt.

## Offene fachliche Fragen

- Die Mindestbestoßungsdauer ist als „Kalendertage“ (SRL) bzw. „Tage“
  (Merkblatt) formuliert. Es wird dieselbe Zählweise angenommen: Auftriebstag
  zählt, Abtriebstag nicht.
- Unklar ist, wie Unterbrechungszeiten dokumentiert werden (Heimstall,
  Krankheit). Das Modell erwartet getrennte Aufenthalte (`stays`).
- Die Sanktionshöhe konkreter Verstöße (Stufe im Kürzungsschema) ist in den
  Quellen nicht tabelliert. Umgesetzt sind nur die Stufen und der Ausschluss nach
  zweimaliger 100-%-Kürzung.
- Es ist offen, ob die Dürre-Regelungen 2026 zur höheren Gewalt eine Prämie auch
  bei Unterschreiten der 60 Tage ermöglichen. Das Modell weist nur die
  Möglichkeit eines Ansuchens aus.
