# o6_23: offene Fachentscheidungen

Alle Antworten und App-Zuordnungen bleiben offen. Die Zitate sind Modellnotizen bzw. Prüfbeobachtungen, keine bestätigte Fachauslegung.

### o6_23-INPUT_CONTRACT

Welche der im Diff einzeln gelisteten Eingaben werden fachlich benötigt und aufgenommen? Für jede: verbindlicher Name, Betrieb/Schlag/Tier/Gruppe/Projekt, Einheit, Zeitbezug, Herkunft/Nachweis und Abgrenzung zu bestehenden App-Feldern. Luna- und Opus-Strukturen sind alternative Vorschläge; keine automatische Umbenennung.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_23-luna-high-20261005/workspace/rules/profile_changes.json:6–9`

```text
    {"action":"add","path":"land.parcels[].country","value_after":"string","rationale":"Die Maßnahme verlangt, dass geförderte Flächen in Österreich liegen.","rule_ids":["O623-TERRITORY"],"source_reference_ids":["GENERAL-LAND-AT"]},
    {"action":"add","path":"land.parcels[].is_natura2000_or_high_nature_value","value_after":"boolean","rationale":"Für die Gebietskulisse muss je Fläche abgebildet werden, ob sie in Natura 2000 oder einem sonstigen Gebiet mit hohem Naturwert liegt.","rule_ids":["O623-SCOPE"],"source_reference_ids":["SHEET-SCOPE","SRL-SCOPE"]},
    {"action":"add","path":"land.parcels[].project_confirmation","value_after":"boolean","rationale":"Die Projektbestätigung ist Zugangsvoraussetzung und wird flächenbezogen erteilt.","rule_ids":["O623-PROJECT-CONFIRMATION"],"source_reference_ids":["SHEET-PROJECT","SRL-PROJECT-DETAIL"]},
    {"action":"add","path":"land.parcels[].application_code","value_after":"string","rationale":"Die Feldstücksliste muss den Code N2 enthalten.","rule_ids":["O623-N2-CODING"],"source_reference_ids":["SHEET-APPLICATION"]},
```

Ursprung: `runs/v2-o6_23-opus-5.5-high-20260928/workspace/rules/profile_changes.json:8–11`

```text
      "path": "farm.applicant",
      "value_before": null,
      "value_after": {
        "legal_form": "enum(natural_person|registered_partnership|legal_person|association|public_body)",
```

### o6_23-ORDINANCE_DATES

Welche Landesverordnung/Projektversion bestätigt den 2026-Schnitttermin? Gelten allgemeine 12.08.-Freigabe oder DIV-Ausnahmen für N2 und für welche Auflagen?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_23-opus-5.5-high-20260928/workspace/notes/assumptions.md:28–35`

```text
6. **Schnittzeitpunktauflagen.** Geprüft wird jeder Schnitttermin gegen den in der
   Projektbestätigung festgelegten frühesten Mahdtermin (`$1`). Die Beweidung vor diesem
   Termin wird nicht geprüft, weil die GL-Auflagen nur die Mahd regeln.
7. **Dürre 2026.** Wird der Schnittzeitpunkt per Landesverordnung geändert, gilt im Jahr 2026
   `earliest_cut_date_state_ordinance_2026`; die Prämie bleibt unverändert. Die generelle
   Freigabe ab 12. August gilt laut Hinweis nur für die Maßnahme „Naturschutz“ und wird für
   N2-Auflagen nicht automatisch angewendet. Die DIV-Ausnahmen (OPUBB/OPBIO) gelten nicht für
   N2-Flächen, weil dort „auch andere Vorgaben“ gelten (analog zum Beispiel Naturschutz).
```

### o6_23-USE_FREQUENCY

Ist GI05/06/07-Nutzungsanzahl eine sanktionsrelevante Pflicht oder ein Titel? Welche Kombinationen innerhalb Kapitel G sind zulässig?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_23-opus-5.5-high-20260928/workspace/notes/assumptions.md:23–27`

```text
5. **Nutzungshäufigkeit bei GI05/GI06/GI07.** Die Auflagentitel nennen „dreimalige
   (bzw. häufigere) / zweimalige / einmalige Nutzung“. Verbindliche Bewirtschaftungsauflage
   laut Anhang I ist das Düngeverbot. Ob die Nutzungsanzahl eine eigenständige,
   sanktionsrelevante Verpflichtung ist, bleibt offen. Abweichungen werden daher nur als Hinweis
   `use_frequency_mismatch` ausgegeben (Nutzungen = Schnitttermine + `grazing_uses`).
```

Ursprung: `runs/v2-o6_23-opus-5.5-high-20260928/workspace/notes/assumptions.md:41–43`

```text
9. **Anhang J innerhalb Kapitel G.** Die Kapitelmatrix regelt nur die Kombination zwischen
   Kapiteln. Unvereinbarkeiten innerhalb von Kapitel G (z. B. GI05 mit GA-Auflagen) sind in den
   vorliegenden Quellen nicht tabelliert. Sie werden deshalb nicht geprüft.
```

### o6_23-COMBINATION_PAYMENT

Welche Prämie entfällt bei Konflikten und welche Reihenfolge gilt für Obergrenze, Sanktion und Modulation? Opus dokumentiert eine abweichende Reihenfolge.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_23-opus-5.5-high-20260928/workspace/notes/assumptions.md:36–59`

```text
8. **Kombinationskonflikte.** Liegt auf demselben Schlag eine nicht kombinierbare Maßnahme
   (Anhang L) oder eine Naturschutz-Auflage eines unvereinbaren Kapitels (Anhang J) vor, wird
   für o6_23 keine Prämie auf diesem Schlag berechnet. Welche der beiden Maßnahmen tatsächlich
   entfällt, regeln die Quellen nicht. Dieser Punkt ist offen.
   `1B_TB` (BIO-Teilbetrieb) wird für Anhang L wie 1B behandelt.
9. **Anhang J innerhalb Kapitel G.** Die Kapitelmatrix regelt nur die Kombination zwischen
   Kapiteln. Unvereinbarkeiten innerhalb von Kapitel G (z. B. GI05 mit GA-Auflagen) sind in den
   vorliegenden Quellen nicht tabelliert. Sie werden deshalb nicht geprüft.
10. **Anhang L.** Die Tabelle wurde aus dem PDF-Layout (pypdf, Spaltenpositionen) vollständig
    in `data/o6_23/combinations.json` übernommen. Zeile und Spalte 23 stimmen mit Maßnahmenblatt
    und SRL 2.23 überein (1A, 1B, 2, 18, 19). Bei den übrigen Zeilen ist ein
    Spaltenzuordnungsfehler durch die Textextraktion nicht völlig ausgeschlossen.

## Berechnung

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
