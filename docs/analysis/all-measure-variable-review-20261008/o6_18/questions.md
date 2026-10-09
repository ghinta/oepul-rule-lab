# o6_18: offene Fachentscheidungen

Alle Antworten und App-Zuordnungen bleiben offen. Die Zitate sind Modellnotizen bzw. Prüfbeobachtungen, keine bestätigte Fachauslegung.

### o6_18-INPUT_CONTRACT

Welche der im Diff einzeln gelisteten Eingaben werden fachlich benötigt und aufgenommen? Für jede: verbindlicher Name, Betrieb/Schlag/Tier/Gruppe/Projekt, Einheit, Zeitbezug, Herkunft/Nachweis und Abgrenzung zu bestehenden App-Feldern. Luna- und Opus-Strukturen sind alternative Vorschläge; keine automatische Umbenennung.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_18-luna-high-20261005/workspace/rules/profile_changes.json:6–9`

```text
    {"action":"add","path":"year","value_after":"int","rationale":"Förderjahr für jahresabhängige o6_18-Regeln.","rule_ids":["O618-PREMIUM-002","O618-DROUGHT-001"],"source_reference_ids":["SRC-GENERAL-CAP","SRC-2026-BIODIV-ARABLE"]},
    {"action":"add","path":"application.access_year","value_after":"int","rationale":"Jahr des Flächenzugangs.","rule_ids":["O618-GENERAL-005"],"source_reference_ids":["SRC-GENERAL-ACCESS"]},
    {"action":"add","path":"application.added_area_ha","value_after":"number","rationale":"Zugegangene Fläche.","rule_ids":["O618-GENERAL-005"],"source_reference_ids":["SRC-GENERAL-ACCESS"]},
    {"action":"add","path":"application.additional_grazing_fertilization","value_after":"boolean","rationale":"Zusätzliche Düngung auf Weideflächen.","rule_ids":["O618-COMMON-004"],"source_reference_ids":["SRC-O618-FERTILIZER"]},
```

Ursprung: `runs/v2-o6_18-opus-5.5-high-20260927/workspace/rules/profile_changes.json:8–11`

```text
      "path": "farm.oepul.measures",
      "value_before": null,
      "value_after": [
        "string"
```

### o6_18-PROJECT_PARAMETERS

Wie werden Projektbestätigung, Version, Codes/Aliase, Teilflächen und konkrete $-Parameter je Schlag gebunden? Luna prüft nur den ersten Schlag; Mehrschlagprüfung muss explizit aufgebaut werden.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_18-luna-high-20261005/workspace/notes/assumptions.md:4–8`

```text
- Das Maßnahmenblatt bezeichnet die Aussagen als rechtlich unverbindlich; für die normative Priorität wurden die gleichlautenden Bestimmungen aus der Sonderrichtlinie und ihren Anhängen herangezogen. Wo die Projektbestätigung konkrete Platzhalter (`$`) einsetzen muss, wird keine konkrete Zahl oder ein Datum erfunden.
- Die Naturschutz-Auflagen sind flächenbezogen und können auf einem Betrieb je Schlag unterschiedlich sein. Rego behandelt `land.parcels[0].naturschutz_codes` als die Auflagen des geprüften Schlags; die fachlich vollständige Code-Liste steht in `data/o6_18/naturschutz_auflagen.json`.
- Für die ausführbare Policy wird ausschließlich die reale Struktur `farm`, `land.parcels[]` und `documentation` des Canonical Farm Profile verwendet. Die Policy prüft den ersten Eintrag von `land.parcels[]` als den jeweils geprüften Schlag; die flächenbezogene Mehrschlagauswertung bleibt eine offene Integrationsfrage. `land.parcels[].naturschutz_codes` ist als echter JSON-Arraywert vorgeschlagen, nicht als Array-Containerpfad.
- Der Discover-Katalog enthält zusätzlich die Blattwerte, die nicht im Canonical Farm Profile vorhanden sind. Der Vorschlag `year` bleibt für die Katalog-Eingabespur erhalten; die Policy liest das Förderjahr primär aus `farm.year` und verwendet den Root-Wert nur als rückwärtskompatiblen Fallback.
- Die Sonderregel vom 12. August 2026 lässt Nutzungstermine ab 12. August zu, ohne die Projektbestätigung zu ändern. Die konkrete Anwendbarkeit eines früheren Nutzungstermins und die Identität des von der Projektbestätigung erfassten Schlages müssen in den Antragsdaten belegt werden.
```

Ursprung: `runs/v2-o6_18-opus-5.5-high-20260927/workspace/notes/assumptions.md:14–29`

```text
- **Umfang:** Die Tabelle enthält alle 332 Auflagencodes. Aliascodes (z. B. `GE01/BC01`, `GJ05/BF05/WD01`) werden als `aliases` der Hauptzeile geführt. Für die Kapitelprüfung nach Anhang J zählt der Anfangsbuchstabe des tatsächlich vergebenen Codes.
- **Text:** Das Feld `text` fasst Auflagentitel und Bewirtschaftungsauflage wortgetreu zusammen. Die Trennung beider Spalten ist aus der Textextraktion nicht zuverlässig möglich.
- **Prämiensätze:**
  - Sie gelten ab 2024.
  - Für 2023 enthalten die Quellen keine Anhang-I-Sätze; die Schlagprämie wird daher nicht berechnet (Regel `O618-PREM-012`). Nur der Zuschlag Regionaler Naturschutzplan (250 €) ist für 2023 belegt.
  - GG03/GG04 haben 2024 und ab 2025 unterschiedliche Sätze.
  - K20-Codes gelten nur bis 2024.
  - KF01 hat keinen Satz.
- **„Ab dem Antragsjahr 2025“:** Das gilt für GA21, GC05, GD03, GR02/WF02, WC03, BI01 und BI02. Die Quelle nennt „BI02 und BI02“; interpretiert als BI01 und BI02.
- **Abgeleitete Merkmale:** Felder wie `required_mowings_per_year`, `fertilization_rule`, `psm_ban` und `requires_grazing` sind Auslegungen des Auflagentextes:
  - GA-Mahdanzahl „3 x Mahd“ wird als *genau* diese Anzahl je Jahr geprüft.
  - Verpflichtende Beweidung wird nur für GA16, GA18, WA01, WA03, BA03 und BA04 angenommen. GA15/GA17 sehen nur „max. 2 x Beweidung“ vor.
  - „Keine zusätzliche Düngung“ wird wie ein Düngeverbot für ausgebrachte Dünger behandelt; Weideausscheidungen sind nicht erfasst.
- **SC02:** Die Pflichtkombination mit SA01 folgt aus dem Merkblatt („SA01 (inkl. SB01 bis SB18 bzw. SC02)“). Im Anhang steht sie ausdrücklich nur für SB.
- **Großtrappe (Monitoring-Pflicht):** Das Merkblatt nennt „TA und TB“, im Anhang steht die Pflicht nur bei TA01. Umgesetzt für TA01 und TB01; ob TC01/TD01 (in der Tabelle „Zusatzauflagen (TB)“) erfasst sind, bleibt offen.
- **N-Auflagen und `$`-Parameter:** Nur Teile sind maschinell geprüft, nämlich Termine, Beweidungs-, Bewässerungs- und Silageverbote sowie PSM. Die übrigen Auflagen sind als Daten verfügbar und über `O618-OBL-016` abgedeckt.
```

### o6_18-CODE_INTERPRETATION

Ist GA-Mahdanzahl exakt oder mindestens? Welche Codes verlangen Beweidung, SC02+SA01 oder Großtrappen-Monitoring einschließlich TC01/TD01?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_18-opus-5.5-high-20260927/workspace/notes/assumptions.md:22–28`

```text
- **„Ab dem Antragsjahr 2025“:** Das gilt für GA21, GC05, GD03, GR02/WF02, WC03, BI01 und BI02. Die Quelle nennt „BI02 und BI02“; interpretiert als BI01 und BI02.
- **Abgeleitete Merkmale:** Felder wie `required_mowings_per_year`, `fertilization_rule`, `psm_ban` und `requires_grazing` sind Auslegungen des Auflagentextes:
  - GA-Mahdanzahl „3 x Mahd“ wird als *genau* diese Anzahl je Jahr geprüft.
  - Verpflichtende Beweidung wird nur für GA16, GA18, WA01, WA03, BA03 und BA04 angenommen. GA15/GA17 sehen nur „max. 2 x Beweidung“ vor.
  - „Keine zusätzliche Düngung“ wird wie ein Düngeverbot für ausgebrachte Dünger behandelt; Weideausscheidungen sind nicht erfasst.
- **SC02:** Die Pflichtkombination mit SA01 folgt aus dem Merkblatt („SA01 (inkl. SB01 bis SB18 bzw. SC02)“). Im Anhang steht sie ausdrücklich nur für SB.
- **Großtrappe (Monitoring-Pflicht):** Das Merkblatt nennt „TA und TB“, im Anhang steht die Pflicht nur bei TA01. Umgesetzt für TA01 und TB01; ob TC01/TD01 (in der Tabelle „Zusatzauflagen (TB)“) erfasst sind, bleibt offen.
```

### o6_18-DIV_AND_DATE

Welche UBB/BIO-Schwellen gelten für NAT-Anrechnung? Welche ersten/zweiten Nutzungstermine sind am 12.08.2026 tatsächlich freigegeben?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_18-opus-5.5-high-20260927/workspace/notes/assumptions.md:34–36`

```text
- **Anhang L:** Aus dem extrahierten Text ist nur Zeile 18 zuverlässig lesbar (1A/1B nur für Landschaftselemente, 23 kombinierbar). Die übrigen Zeilen und Spalten wurden nicht übernommen.
- **Punktförmige Landschaftselemente:** Das Merkblatt spricht von „punktförmigen Landschaftselementen“, die SRL allgemein von Landschaftselementen der 1A/1B. Modelliert über das Flag `ubb_bio_only_landscape_elements`.
- **0,15-ha-Regel bei Feldstücken über 5 ha (`O618-KOMB-009`):** Umgesetzt wie im Merkblatt beschrieben. Die UBB-Schwellen (ab 10 ha Acker bzw. 10 ha gemähtem Grünland) werden nicht zusätzlich geprüft.
```
