# Gemeinsame Fachentscheidungen

Alle Antworten und App-Zuordnungen bleiben offen. Die Zitate sind Modellnotizen bzw. Prüfbeobachtungen, keine bestätigte Fachauslegung.

### cross_measure-SOURCE_VERSION

Welche aktuelle Rechts-/Merkblatt-/Notice-/Register-/GIS-Version gilt je Förderjahr? Fehlende GSP-AV, NAPV, THVO, WRRL-Verordnung und AMA-Meldungen vom 25.08./02.09.2026 müssen als fehlend sichtbar bleiben. Neue Opus-Überarbeitungen separat versionieren.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_16-opus-5.5-high-20261002/workspace/notes/assumptions.md:7–15`

```text
- Das Informationsblatt (Stand April 2026) ist laut eigenem Hinweis rechtlich unverbindlich. Maßgeblich ist die
  Sonderrichtlinie ÖPUL 2023 (Fassung 2024-0.489.174). Wo das Infoblatt aktueller oder genauer ist (Sudangras,
  Wegfall der PSM-Codierung ab 2026), wurde es umgesetzt, weil es die Verwaltungspraxis 2026 abbildet.
- Die in den AMA-News vom 25.08.2026 erwähnte Meldung „Aufzeichnungsverpflichtungen bei der ÖPUL-Maßnahme
  Vorbeugender Grundwasserschutz – Acker“ liegt nicht als Quelle vor. Ihr Inhalt ist daher nicht berücksichtigt
  (Coverage: `unresolved`).
- GSP-AV, MOG 2021 und die Nitrat-Aktionsprogramm-Verordnung (NAPV) liegen nicht vor. Verweise auf sie (§ 8 Abs. 1,
  § 9 Abs. 6, Anlage 2 und 3 NAPV, § 6 GSP-AV) sind als Eingaben modelliert (z. B. `napv_compliant`,
  `n_available_kg_ha`, `readily_soluble_n`) und nicht inhaltlich nachgerechnet.
```

Ursprung: `runs/v2-o6_22-opus-5.5-high-20260928/workspace/notes/assumptions.md:79–86`

```text
- **Tierabweichungen (SRL 1.12.1.2)**: verweist auf §§ 42–47 GSP-AV, die nicht im
  Quellenpaket liegen; Toleranzen/Kürzungsformeln für Abweichungen bei Tierzahlen sind
  daher nicht ausführbar abgebildet.
- **Meldeverpflichtungen tierbezogener Maßnahmen (Teaser vom 02.09.2026)**: Die
  2026-Hinweise enthalten in der Seitenleiste nur den Teaser „Der Abgang von beantragten
  Tieren aufgrund von Verkauf, Verendung oder Schlachtung muss fristgerecht der AMA
  gemeldet werden“. Die vollständige Meldung fehlt im Quellenpaket; Fristen und die
  Anwendbarkeit auf o6_22 (Durchschnittstierliste) sind offen. Keine Regel extrahiert.
```

### cross_measure-CURRENT_SNAPSHOT

Welcher aktuelle Snapshot einschließlich datierter Betreiber-/Experteneingaben bildet den Tatsachenstand? Für jede Pflicht Fälligkeitsdatum/Jahresabschluss festlegen; zukünftige Möglichkeiten nur als begründete Notiz. Bestandsjahr, Vertragsjahr, Antrag und historische Bezugsjahre trennen.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_1a-opus-5.5-high-20260929/workspace/notes/assumptions.md:28–30`

```text
6. **Zweijährigkeit/Mindestpflege „jedes zweite Jahr“:** Umgesetzt über das Eingabefeld `used_previous_year`; die
   Eingabe beschreibt stets ein abgeschlossenes Kalenderjahr. Unterjährige Auswertungen können Mindestpflichten
   (Mahd, zweite Nutzung) fälschlich als verletzt melden.
```

Ursprung: `runs/v2-o6_16-opus-5.5-high-20261002/workspace/notes/assumptions.md:76–81`

```text
- Fristen bis 31.12.2026 werden erst ab Profiljahr 2027 als Verstoß gewertet; im Jahr 2026 erscheinen sie als
  `obligations` mit Status `open` oder `fulfilled`.
- Die Basisfläche für die Probenanzahl ist die Kulissen-Ackerfläche des Profils; für ein Profiljahr ungleich 2026
  ist `soil_sample_base_area_ha` (MFA 2026) anzugeben.
- Für die Wiener Doppelproben werden Proben mit `area == "wien_gebiet"` gezählt; räumliche/zeitliche
  Projektvorgaben sind nicht modelliert.
```

### cross_measure-UNKNOWN_APPROVAL

Wie werden unbekannt, bestätigt falsch, bestätigt leer und bestätigt erfüllt unterschieden? Keine automatische Genehmigung/Teilnahme/Compliance aus fehlenden Angaben; Behördenentscheidungen brauchen explizite Quelle, Datum und Geltungsbereich.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_12-opus-5.5-high-20260926/workspace/notes/assumptions.md:7–12`

```text
- Alle neuen Eingabefelder sind in `rules/profile_changes.json` als Vorschläge erfasst.
  Die Rego-Regeln lesen sie mit `object.get` und Standardwerten. **Fehlende Angaben
  werden als unbedenklich behandelt**, z. B. `location.in_austria` = true oder
  `minimum_management.*` = true. Ein Befund entsteht also nur, wenn eine Angabe
  ausdrücklich negativ ist. Eine Vollständigkeitsprüfung der Eingaben ist nicht Teil
  der Regeln.
```

Ursprung: `runs/v2-o6_12-opus-5.5-high-20260926/workspace/notes/assumptions.md:47–53`

```text
5. **Rebzikaden-Ausstieg 2026:** Die Meldung verlangt „Betriebe mit Weinflächen“. Es
   wird nur geprüft, ob mindestens ein Weinschlag vorhanden ist; das gilt auch für
   Schnittweingärten und Sonstige Weinflächen. Der Ausstieg gilt als genehmigt, wenn
   die formalen Voraussetzungen erfüllt sind und `approved` nicht ausdrücklich `false`
   ist. Die AMA-Genehmigung ist also als Eingabe modelliert. Keine Prämie wird nur für
   das Jahr der Meldung angenommen, in dem der Vertrag endet. Chemisch-synthetische
   Insektizideinsätze ab dem Meldedatum gelten nicht als Verstoß.
```

Ursprung: `runs/v2-o6_20-opus-5.5-high-20260928/workspace/notes/assumptions.md:59–63`

```text
- **Stichtag Schafe/Ziegen**: Tiere ohne Zugangsdatum oder mit Zugang bis 1. April gelten als zum Stichtag vorhanden und müssen bis
  15. April (2023/2028: 17. April) beantragt sein.
- **Fehlende Eingaben**: Fehlt ein Boolean zu einer Verpflichtung, wird Einhaltung angenommen (keine Verstöße ohne Datengrundlage).
  Nur zentrale Felder (Rechtsform, erstes ÖPUL-Jahr, Weidetagebuch) erscheinen in `missing_inputs`. Fehlende Weidetage werden
  als 0 gewertet und führen zu einem Verstoß.
```

### cross_measure-RGVE_COUNT_SCOPE

Welche Tier-IDs, Anhang-A-Kategorien, Stichtage und Durchschnittszeiträume sind verbindlich für GVE/RGVE? Aktueller Abteilbesatz, Jahresdurchschnitt, Weidefenster und Alpungstage bleiben verschiedene Sachverhalte.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_3-opus-5.5-high-20260930/workspace/notes/assumptions.md:9–11`

```text
- Zur Futterfläche zählt die gesamte Grünlandfläche (`land_use == grassland`), also auch Streuwiesen, Bergmähder, Dauerweiden und Hutweiden. Dazu kommen Ackerfutterflächen inklusive Ackerweide, ohne Zweitkulturen. Almweideflächen (`alpine_pasture`) zählen nicht dazu. Das Merkblatt nennt nur „Summe der Grünland- und Ackerfutterflächen“, die Nutzungsart Alm ist dort nicht ausdrücklich geregelt.
- Liegt `average_count` vor, wird es vor `animal_count` verwendet. Damit sind die Durchschnittstierliste bzw. der Durchschnittsbestand laut Rinderdatenbank abgebildet. Die taggenaue Berechnung und die Zurechnung beim Betriebsstrukturwechsel werden als vorab berechneter Durchschnittsbestand erwartet.
- Equiden mit genau 1,48 m Widerristhöhe und genau 300 kg gehören laut Merkblatt zur kleinen Kategorie. Für Grenzfälle mit „über 1,48 m **oder** über 300 kg“ (Anhang A: „und/oder“) ist die Wahl der Kategorie Teil der Eingabe (`rgve_category`).
```

Ursprung: `runs/v2-o6_22-opus-5.5-high-20260928/workspace/notes/assumptions.md:7–11`

```text
- Eine `livestock.species_groups[]`-Gruppe mit `species == "pigs"` entspricht einer homogenen
  Tiergruppe in **einem** Stallabteil bzw. Gehege. Die Platzprüfung erfolgt je Gruppe
  (O622-FAT-SPACE-03). `animal_count` ist der aktuelle Abteilbesatz (Platzbedarf,
  Besatzdichte); für GVE/Prämie wird bei `livestock.average_animal_list_submitted == true`
  der `average_animal_count` verwendet, sonst `animal_count` (Stichtag 1. April).
```

Ursprung: `runs/v2-o6_14-luna-high-20261004/workspace/notes/assumptions.md:8–15`

```text
- Die Rego-Eingabe verwendet `gve` als bereits anhand des 1.-Juli-
  Altersstichtags berechneten RGVE-Wert. Die vollständige Faktor-Tabelle aus
  Anhang A ist trotzdem als Datenbestand hinterlegt, damit die vorgelagerte
  RGVE-Berechnung reproduzierbar ergänzt werden kann.
- Bei Tieren, die zwischen mehreren Almen wechseln, erwartet die ausführbare
  Regel bereits die je Alm aufgeteilten `alpung_days` und `alm_id`. Die Quelle
  verlangt eine anteilige Berechnung; die konkrete Datenmodellierung der
  Meldungen ist eine offene Integrationsfrage.
```

### cross_measure-CODE_IDENTITY

Welche offiziellen MFA-/Maßnahmen-/OP-Codes, Kultur- und Feldstück-IDs gelten? Maßnahmenspezifische Codes dürfen weder erfunden noch allein aus ähnlichen Namen oder einem OP-Präfix abgeleitet werden.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_23-opus-5.5-high-20260928/workspace/notes/assumptions.md:13–17`

```text
2. **Beantragte Schläge.** Als beantragt gelten nur Schläge mit `n2_code_marked = true`
   (Code N2 in der Feldstücksliste). Schläge mit Projektbestätigung ohne N2 werden nur als
   Befund `project_confirmation_without_n2_code` gemeldet.
3. **Maßnahmenbezogener OP-Code.** Die Quellen nennen keinen konkreten OP-Code für o6_23.
   Analog zu `OPBIO`/`OPUBB` wird `OPN2` angenommen; zusätzlich blockiert der allgemeine Code `OP`.
```

Ursprung: `runs/v2-o6_2-opus-5.5-high-20260930/workspace/notes/assumptions.md:11–16`

```text
- Maßnahmen werden in `farm.oepul.participating_measures` und `land.parcels[].parcel_measures`
  mit den SRL-Nummern (`1A`, `1B`, `2`, `16`, …) angegeben, weil Anhang L diese Codes verwendet.
- Die Parzellenkategorie wird aus `land_use`, `crop.crop_category` und `crop.crop_name`
  abgeleitet. Ackerfutter und Obst werden über den Kulturnamen gegen die geschlossenen Listen
  in `data/o6_2_inputs_and_crops.json` erkannt (Vergleich ohne Groß-/Kleinschreibung). Eine
  Obstanlage mit einem nicht gelisteten Kulturnamen gilt als nicht prämienfähig.
```

Ursprung: `runs/v2-o6_1c-opus-5.5-high-20260925/workspace/notes/assumptions.md:65–67`

```text
13. **Maßnahmenbezogener OP-Code für 1C:** Die Quellen nennen keinen konkreten Code (analog „OPUBB",
    „OPBIO"). Jeder Code mit Präfix „OP" erfüllt die OP-Kennzeichnungspflicht; prämienausschließend sind
    „OP" und „VF" sowie die Statusflags.
```

### cross_measure-AREA_DEFINITION

Welche Flächen bilden gesamtbetriebliche Mindestgröße/Modulation, Futterfläche, Mindestteilnahme, Quotenbasis und prämienfähige Fläche? Insbesondere Alm, Brachen, Landschaftselemente und Projektteilflächen getrennt definieren.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_17-opus-5.5-high-20261002/workspace/notes/assumptions.md:27–31`

```text
6. **Grünlandanteil 40 %.** Als „landwirtschaftliche Nutzfläche ohne Almweideflächen“ wird
   `land.total_area_ha − land.alpine_pasture_area_ha` verwendet. Ob `total_area_ha` im Profil Almflächen
   enthält, ist nicht festgelegt.
7. **Futterfläche.** Alle Grünlandschläge außer „Sonstige Grünlandflächen“ und Grünlandbrachen sowie
   die Ackerfutter-Schlagnutzungsarten. Almweideflächen (`land_use = alpine_pasture`) zählen nicht dazu.
```

Ursprung: `runs/v2-o6_13-opus-5.5-high-20260926/workspace/notes/assumptions.md:29–33`

```text
6. **Betriebsmindestgröße 1,50 ha**: `land.total_area_ha` wird als Fläche nach § 25 GSP-AV
   interpretiert; GA-, K20-, Landschaftselement-, Hecken- und Agroforstflächen werden über
   `land.minimum_size_additional_area_ha` addiert (Profilvorschlag). Die 0,50-ha-Schwelle
   für geschützten Anbau nutzt `land.protected_cultivation_area_ha`, ersatzweise die Summe
   der Schläge in Gewächshaus/Folientunnel.
```

### cross_measure-PREMIUM_PRIORITY

Welche Kürzungsreihenfolge und Zuordnung gelten bei Kombinationen, Obergrenzen und Flächenzugang? Keine erfundene Priorität oder automatische Nullprämie. Tatsächliche jährliche Prämiensätze und AMA-Sanktionsstufe getrennt bestätigen.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_23-opus-5.5-high-20260928/workspace/notes/assumptions.md:51–59`

```text
11. **Obergrenzen.** Die Obergrenze wird je Schlag auf den €/ha-Satz angewendet:
    min(Summe N2-Sätze, Obergrenze − sonstige Flächenzahlungen). Die Obergrenze beträgt
    1.500 €/ha, wenn auf dem Schlag Maßnahme 18 oder 19 beantragt ist, sonst 1.300 €/ha
    (2023: 1.200/1.300 €/ha). Wie die Obergrenze zwischen den Maßnahmen aufgeteilt wird,
    regeln die Quellen nicht. Hier wird angenommen, dass o6_23 zuletzt gekürzt wird.
12. **Reihenfolge der Kürzungen.** Die Reihenfolge laut SRL 1.12.2 ist als Daten erfasst.
    Rego wendet vereinfacht an: Obergrenze je Schlag, danach inhaltliche Kürzung
    (Sanktionsstufe) und danach Modulation. Die SRL sieht die Obergrenze nach der Modulation vor.
    Das kann bei gekappten Schlägen zu Rundungs- und Reihenfolgeabweichungen führen.
```

Ursprung: `runs/v2-o6_19-opus-5.5-high-20260927/workspace/notes/assumptions.md:42–62`

```text
7. **Obergrenze 1.500 EUR/ha**: Die Obergrenze gilt für die Summe aller
   flächenbezogenen Zahlungen je Schlag. Welche Zahlung gekürzt wird, regeln die
   Quellen nicht; das Modell kürzt den EBW-Satz (Obergrenze minus
   `other_area_payments_eur_per_ha`).
8. **Kürzungsreihenfolge** (SRL 1.12.2): inhaltliche Kürzung → Stilllegungs-Obergrenze
   → Modulation → Flächenzahlungs-Obergrenze → Zugangskürzung. Übererklärungen,
   Fristversäumnis und Konditionalität sind nicht modelliert.
9. **Stilllegungs-Obergrenze (25 % / 2 ha)** und **Flächenzugang ab 2026
   (+50 % / +5 ha auf Basis 2025)**: Die Quellen nennen nicht, welche Schläge
   gekürzt werden; das Modell kürzt anteilig über alle betroffenen Flächen. Die
   Zugangsbeschränkung wird auf die gesamte prämienfähige EBW-Fläche angewendet;
   die Unterscheidung „bereits vorher mit der gleichen Maßnahme belegt“ ist nicht
   schlagweise modelliert und muss bei der Eingabe `ebw_area_2025_ha`
   (Bezugsfläche 2025) vorab berücksichtigt werden.
10. **Modulation** wird auf die gesamte Maßnahmenprämie inkl. Zuschlag Regionaler
    Naturschutzplan angewendet („Prämienausmaß aller Maßnahmen“).
11. **Sanktionen**: Die Kürzungsstufe wird als Ergebnis der AMA-Bewertung
    (`oepul.o6_19.sanctions.stage`) eingegeben; die Einstufung nach Schwere,
    Ausmaß, Dauer und Häufigkeit ist nicht automatisiert. Indikator-, Erfassungs-
    und Änderungsverstöße werden als `obligation_violations` gemeldet, streichen
    die Fläche aber nicht automatisch.
```

### cross_measure-PROJECT_IDENTITY

Wie werden Projektbestätigung/Behördenanordnung mit stabiler Schlag-/Tier-/Struktur-ID, Teilfläche, Gültigkeitsintervall und Snapshot-Version verbunden? Jede individuelle Auflage braucht bestätigte Parameter statt allgemeiner Boolean-Näherung.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_18-luna-high-20261005/workspace/notes/assumptions.md:4–8`

```text
- Das Maßnahmenblatt bezeichnet die Aussagen als rechtlich unverbindlich; für die normative Priorität wurden die gleichlautenden Bestimmungen aus der Sonderrichtlinie und ihren Anhängen herangezogen. Wo die Projektbestätigung konkrete Platzhalter (`$`) einsetzen muss, wird keine konkrete Zahl oder ein Datum erfunden.
- Die Naturschutz-Auflagen sind flächenbezogen und können auf einem Betrieb je Schlag unterschiedlich sein. Rego behandelt `land.parcels[0].naturschutz_codes` als die Auflagen des geprüften Schlags; die fachlich vollständige Code-Liste steht in `data/o6_18/naturschutz_auflagen.json`.
- Für die ausführbare Policy wird ausschließlich die reale Struktur `farm`, `land.parcels[]` und `documentation` des Canonical Farm Profile verwendet. Die Policy prüft den ersten Eintrag von `land.parcels[]` als den jeweils geprüften Schlag; die flächenbezogene Mehrschlagauswertung bleibt eine offene Integrationsfrage. `land.parcels[].naturschutz_codes` ist als echter JSON-Arraywert vorgeschlagen, nicht als Array-Containerpfad.
- Der Discover-Katalog enthält zusätzlich die Blattwerte, die nicht im Canonical Farm Profile vorhanden sind. Der Vorschlag `year` bleibt für die Katalog-Eingabespur erhalten; die Policy liest das Förderjahr primär aus `farm.year` und verwendet den Root-Wert nur als rückwärtskompatiblen Fallback.
- Die Sonderregel vom 12. August 2026 lässt Nutzungstermine ab 12. August zu, ohne die Projektbestätigung zu ändern. Die konkrete Anwendbarkeit eines früheren Nutzungstermins und die Identität des von der Projektbestätigung erfassten Schlages müssen in den Antragsdaten belegt werden.
```

Ursprung: `runs/v2-o6_19-luna-high-20261005/workspace/notes/assumptions.md:4–5`

```text
- Die Projektbestätigung ist die maßgebliche Quelle für die tatsächlich ausgewählten Indikatoren je Schlag. Anhang K ist deshalb als vollständiger Katalog und nicht als Behauptung modelliert, dass jeder Indikator auf jedem Schlag zugleich gilt.
- Die Platzhalter `$1`, `$2` und `$NEO` im extrahierten Anhang-K-Text sind projekt- bzw. lebensraumspezifische Parameter. Sie wurden nicht geraten oder durch Profilwerte ersetzt. Die Policy prüft daher die vom Projekt bestätigten Ergebnisfelder und nutzt die Tabelle als geschlossene Code-/Textliste.
```
