# o6_3: offene Fachentscheidungen

Alle Antworten und App-Zuordnungen bleiben offen. Die Zitate sind Modellnotizen bzw. Prüfbeobachtungen, keine bestätigte Fachauslegung.

### o6_3-INPUT_CONTRACT

Welche der im Diff einzeln gelisteten Eingaben werden fachlich benötigt und aufgenommen? Für jede: verbindlicher Name, Betrieb/Schlag/Tier/Gruppe/Projekt, Einheit, Zeitbezug, Herkunft/Nachweis und Abgrenzung zu bestehenden App-Feldern. Luna- und Opus-Strukturen sind alternative Vorschläge; keine automatische Umbenennung.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_3-luna-high-20261001/workspace/rules/profile_changes.json:6–9`

```text
    {"action":"add","path":"farm.heuwirtschaft.measure","value_after":"string","rationale":"Die Rego-Evaluierung benötigt die beantragte Maßnahme unter dem Maßnahmenprofil.","rule_ids":["O63.SCOPE","O63.COMBINATION"],"source_reference_ids":["O63-L01","O63-M02"]},
    {"action":"add","path":"farm.heuwirtschaft.year","value_after":"int","rationale":"Das Förderjahr steuert Prämiensatz, Dürreausnahme und Editionsbezug.","rule_ids":["O63.PREMIUM_TABLE","O63.DROUGHT_2026_ARABLE_EXCEPTION","O63.UPDATE"],"source_reference_ids":["O63-M17","O63-N03","O63-M20"]},
    {"action":"add","path":"farm.heuwirtschaft.contract_start_year","value_after":"int","rationale":"Das Vertragsbeginnjahr wird für Laufzeit und letzten Einstieg benötigt.","rule_ids":["O63.CONTRACT","O63.APPLICATION"],"source_reference_ids":["O63-M01","O63-M15","O63-L05"]},
    {"action":"add","path":"farm.heuwirtschaft.eligible_area_ha","value_after":"number","rationale":"Die Prämie wird je förderfähigem Hektar berechnet; die Fläche wird zusätzlich schlagbezogen geprüft.","rule_ids":["O63.SCOPE","O63.PREMIUM_TABLE","O63.SECOND_CROP"],"source_reference_ids":["O63-L01","O63-M17","O63-M19"]},
```

Ursprung: `runs/v2-o6_3-opus-5.5-high-20260930/workspace/rules/profile_changes.json:8–11`

```text
      "path": "farm.applicant",
      "value_before": null,
      "value_after": {
        "legal_form": "enum(natural_person|registered_partnership|legal_entity|association)",
```

### o6_3-FORAGE

Zählen Alm-/Streuwiesen und nur zur Einstreu genutzte Wiesen zur Futterfläche? Welche Durchschnittsbestände und Kategorien sind erforderlich?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_3-opus-5.5-high-20260930/workspace/notes/assumptions.md:7–11`

```text
## Tierhaltereigenschaft
- Der Viehbesatz wird ungerundet mit 0,30 RGVE/ha verglichen. Das Merkblatt-Beispiel rundet nur für die Anzeige (0,38).
- Zur Futterfläche zählt die gesamte Grünlandfläche (`land_use == grassland`), also auch Streuwiesen, Bergmähder, Dauerweiden und Hutweiden. Dazu kommen Ackerfutterflächen inklusive Ackerweide, ohne Zweitkulturen. Almweideflächen (`alpine_pasture`) zählen nicht dazu. Das Merkblatt nennt nur „Summe der Grünland- und Ackerfutterflächen“, die Nutzungsart Alm ist dort nicht ausdrücklich geregelt.
- Liegt `average_count` vor, wird es vor `animal_count` verwendet. Damit sind die Durchschnittstierliste bzw. der Durchschnittsbestand laut Rinderdatenbank abgebildet. Die taggenaue Berechnung und die Zurechnung beim Betriebsstrukturwechsel werden als vorab berechneter Durchschnittsbestand erwartet.
- Equiden mit genau 1,48 m Widerristhöhe und genau 300 kg gehören laut Merkblatt zur kleinen Kategorie. Für Grenzfälle mit „über 1,48 m **oder** über 300 kg“ (Anhang A: „und/oder“) ist die Wahl der Kategorie Teil der Eingabe (`rgve_category`).
```

### o6_3-GREEN_FEEDING

Wie wird überwiegende Grünfütterung nachgewiesen? Sind 92 Tage, Teil-Tage und die Addition von Heim-/Alm-/Gemeinschaftsweidetagen fachlich ausreichend?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_3-opus-5.5-high-20260930/workspace/notes/assumptions.md:20–22`

```text
## Grünfütterung
- „Überwiegender Teil der Vegetationsperiode“ (1.4.–30.9. = 183 Tage) wird als mehr als 50 % der Tage umgesetzt, also mindestens 92 Tage. Eingrasen/Weide am Heimbetrieb und Tage auf Gemeinschaftsweide/Alm werden addiert. Keine Quelle verlangt eine tägliche Mindestdauer; Tage mit teilweiser Grünfütterung zählen daher voll. Das ist offen.
- Die Prüfung greift nur, wenn raufutterverzehrende Tiere (RGVE > 0) gehalten werden.
```

### o6_3-MACHINERY_COMBINATION

Gilt ein stillgelegter Mähaufbereiter als vorhanden? Wie wird zeitgleiche Kombination während des Jahres geprüft und welche Vertragsfolgen hat ihr Wegfall?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_3-opus-5.5-high-20260930/workspace/notes/assumptions.md:35–38`

```text
## Offene Fragen
1. Gilt eine vor Vertragsbeginn angeschaffte, aber stillgelegte Mähaufbereiter-Einheit als „am Betrieb vorhanden“? Aktuell zählt jedes vorhandene Gerät als Verstoß.
2. Zählt eine Streuwiese in der Futterflächenberechnung, wenn sie nur zur Einstreu genutzt wird? Aktuell ja, weil sie Grünland ist.
3. Die Kombinationsverpflichtung muss laut Merkblatt „zeitgleich“ erfüllt sein. Sie wird jährlich geprüft. Bei Wegfall ab dem 2. Jahr gibt es keine Prämie (SRL 1.12.1.1); ob zusätzlich eine Rückforderung aus dem Vertragszeitraum folgt, ist nicht abschließend geregelt.
```

### o6_3-PREMIUM_SCOPE

Wie unterscheiden sich Mindestteilnahme, tatsächlich gemähte Prämienfläche, Flächenzugang und maßnahmenbezogener OP-Ausschluss? Bestehende acht Blocker aus #97 bleiben offen.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_3-opus-5.5-high-20260930/workspace/notes/assumptions.md:13–18`

```text
## Mindestteilnahme / Prämienfähigkeit
- Für die 2-ha-Mindestfläche zählt jede Grünlandparzelle mit `grassland_type == maehwiese_maehweide`, auch wenn sie in „Naturschutz“ eingebracht ist. Eine tatsächliche Mahd wird dafür nicht geprüft, weil die Quelle „bewirtschaftet“ verlangt.
- Prämienfähig sind nur tatsächlich gemähte Flächen, also Flächen mit mindestens einem Eintrag in `cutting_dates`. Das gilt auch für Mähwiesen und Mähweiden, gestützt auf „gemähte Grünlandflächen“ in Kap. 1.
- Kombinierbarkeit auf der Einzelfläche (Anhang L): Ist eine Parzelle zusätzlich in einer nicht kombinierbaren Maßnahme (z. B. 18 Naturschutz, 4 Bergmähder, 8 Erosionsschutz Acker) beantragt, gibt es auf ihr keine Heuwirtschaftsprämie. Sie zählt aber weiter zur Mindest- und zur Futterfläche. Bei Naturschutz fließt stattdessen der GM01-Zuschlag (108 €/ha) in die Naturschutzprämie. Die Matrix wurde spaltengenau aus den PDF-Koordinaten von Seite 103 rekonstruiert, ihre Symmetrie ist geprüft.
- Ein maßnahmenbezogener OP-Code für die Heuwirtschaft wird generisch über `op_measures` mit dem Eintrag `o6_3` abgebildet. Ein offizieller Codename (z. B. „OPHEU“) ist in den Quellen nicht genannt.
- Flächenzugangsbeschränkung ab 2026: Deckel ist `Basis 2025 + max(50 % × Basis 2025; 5 ha)`, nur für Grünland. Flächen, die vorher schon in derselben Maßnahme waren, gelten laut Quelle nicht als Zugang. Das muss bereits in der Basis-/Istfläche berücksichtigt sein.
```
