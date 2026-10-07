# o6_1c: offene Fachentscheidungen

Alle Antworten und App-Zuordnungen bleiben offen. Die Zitate sind Modellnotizen bzw. Prüfbeobachtungen, keine bestätigte Fachauslegung.

### o6_1c-INPUT_CONTRACT

Welche der im Diff einzeln gelisteten Eingaben werden fachlich benötigt und aufgenommen? Für jede: verbindlicher Name, Betrieb/Schlag/Tier/Gruppe/Projekt, Einheit, Zeitbezug, Herkunft/Nachweis und Abgrenzung zu bestehenden App-Feldern. Luna- und Opus-Strukturen sind alternative Vorschläge; keine automatische Umbenennung.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_1c-luna-high-20260930/workspace/rules/profile_changes.json:6–9`

```text
    {"action":"add","path":"measure.id","value_after":"o6_1c","rationale":"Die beantragte Maßnahme fehlt im Canonical Farm Profile und wird von den o6_1c-Teilnahmeentscheidungen benötigt.","rule_ids":["o6_1c_001","o6_1c_004","o6_1c_043","o6_1c_044","o6_1c_045","o6_1c_046"],"source_reference_ids":["src_measure_overview_p1","src_general_auto_p13","src_notice_biodiv_2026","src_notice_rebzikade_2026","src_notice_drought_0805_2026","src_notice_drought_0812_2026"]},
    {"action":"add","path":"measure.application_date","value_after":"date|null","rationale":"Das Datum der Maßnahmenbeantragung fehlt und ist für die Antragsfrist erforderlich.","rule_ids":["o6_1c_003"],"source_reference_ids":["src_measure_application_p4","src_general_application_p12"]},
    {"action":"add","path":"measure.deregistered","value_after":"boolean","rationale":"Die Abmeldung einer einjährigen Maßnahme fehlt und ist für die automatische Verlängerung erforderlich.","rule_ids":["o6_1c_004"],"source_reference_ids":["src_general_auto_p13"]},
    {"action":"add","path":"measure.contract_start","value_after":"date|null","rationale":"Der Vertragsbeginn fehlt und ist für den einjährigen Verpflichtungszeitraum erforderlich.","rule_ids":["o6_1c_002"],"source_reference_ids":["src_general_contract_p12","src_legal_general_p12"]},
```

Ursprung: `runs/v2-o6_1c-opus-5.5-high-20260925/workspace/rules/profile_changes.json:8–11`

```text
      "path": "farm.applicant",
      "value_before": null,
      "value_after": {
        "legal_form": "enum(natural_person|registered_partnership|legal_person|association|public_body)",
```

### o6_1c-NPA_AREA

Welche Flächen bilden die 4-%-Basis, den GLÖZ-Abzug und die betriebliche 50-%-Frühschnittquote? Wie werden Teilflächenschnitte erfasst?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_1c-opus-5.5-high-20260925/workspace/notes/assumptions.md:27–34`

```text
1. **4 %-Obergrenze:** Bezugsbasis ist `land.arable_area_ha` des Betriebes einschließlich der NPA selbst
   (Grünbrache zählt zum Ackerland). Die Obergrenze wirkt auf die Prämienfläche; über 4 % hinausgehende
   NPA-Fläche wird nicht prämiert, aber nicht als Verstoß gewertet (die Quellen nennen keinen Verstoß).
2. **GLÖZ 4:** Der als GLÖZ-4-Pufferstreifen ausgewiesene Flächenteil wird von der NPA-Fläche abgezogen,
   bevor die 4 %-Grenze angewandt wird.
3. **50 %-Regel (Schnitt vor dem 1. August):** betriebsbezogen über alle NPA-Schläge; ein Schlag gilt als
   „früh gemäht", sobald ein zählender Schnitt vor dem 1. August liegt (Teilflächenschnitte werden nicht
   abgebildet). Zulässige Reinigungsschnitte zählen nicht.
```

### o6_1c-NPA_CARE

Zählt ein Reinigungsschnitt zur Zweijahrespflege, wann ist diese prüfbar, und welche Dünge-/PSM-Ereignisse einschließlich P/K/Kalk müssen erfasst werden?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_1c-opus-5.5-high-20260925/workspace/notes/assumptions.md:35–45`

```text
4. **Reinigungsschnitt:** Nur im ersten Antragsjahr (`first_npa_declaration_year == farm.year`) und nur bei
   `establishment_type == "new_sowing"` oder nach Umbruch und Neueinsaat einer bestehenden Grünbrache.
   Selbstbegrünung wird **nicht** als Neuansaat gewertet (Informationsblatt: „bezieht sich auf Flächen mit
   Neuansaat"). Ein unzulässiger Reinigungsschnitt wird als Verstoß gemeldet und zählt zusätzlich als
   regulärer Schnitt.
5. **Mindestpflege „jedes zweite Jahr":** Verstoß, wenn im laufenden Jahr kein Schnitt (inkl.
   Reinigungsschnitt) erfolgte und `maintenance_in_previous_year == false`; im ersten NPA-Jahr nicht prüfbar.
   Ob ein Reinigungsschnitt die Mindestpflege erfüllt, regeln die Quellen nicht ausdrücklich (hier: ja).
   Die Prüfung setzt einen Jahresabschluss-Datenstand voraus.
6. **Düngung:** „Jegliche Düngung" – neben N-Mengen aus `operations.fertilizer` wird das neue Flag
   `npa.any_fertilization` (auch P/K/Kalk, Wirtschaftsdünger) ausgewertet.
```

### o6_1c-AGROFORESTRY

Sind Agroforststreifen eigenständige Landschaftselemente oder Schlag-Unterobjekte? Wie werden etablierte Bäume, entbehrliche Pflanzpfähle und Nachpflanzung nachgewiesen?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_1c-opus-5.5-high-20260925/workspace/notes/assumptions.md:48–58`

```text
8. **Agroforststreifen-Definition:** Dichte = Bäume × 100 / Länge (Laufmeter); Sträucher zählen nicht als
   Bäume. Negativliste wird auf Art- und – für „Ölweiden (Elaeagnus)" – auf Gattungsebene geprüft.
   Die Pflegepflichten (Pflanzpfahl, Verbissschutz, Pflegeschnitte) werden als Booleans erwartet; bei
   älteren, etablierten Bäumen kann ein Pflanzpfahl fachlich entbehrlich sein – das ist nicht abgebildet.
9. **Gehölzentnahme:** Die Streifen-Kennzahlen beschreiben den Zustand nach allfälliger Nachpflanzung.
   Verstoß, wenn nachgepflanzt wurde, aber nach dem 15. Mai, oder wenn ohne Nachpflanzung die
   Mindestkriterien nicht mehr erfüllt sind.
10. **Kombinierbarkeit Agroforststreifen:** Das Informationsblatt nennt das Kombinationsverbot nur für NPA;
    Anhang L weist für die gesamte Maßnahme 1C (Zeile und Spalte) keine kombinierbare Maßnahme aus.
    Umgesetzt: auch Agroforststreifen-Flächen erhalten keine weitere Maßnahmenprämie. Die
    Anrechnung von Agroforststreifen auf die 15 a der UBB/BIO-Feldstücksregel ist davon unberührt.
```

### o6_1c-COMBINATIONS_CODES

Welche Kombinationen und OP-Codes gelten tatsächlich für NPA und Agroforststreifen? Darf irgendein OP-Präfix stellvertretend verwendet werden?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_1c-opus-5.5-high-20260925/workspace/notes/assumptions.md:55–67`

```text
10. **Kombinierbarkeit Agroforststreifen:** Das Informationsblatt nennt das Kombinationsverbot nur für NPA;
    Anhang L weist für die gesamte Maßnahme 1C (Zeile und Spalte) keine kombinierbare Maßnahme aus.
    Umgesetzt: auch Agroforststreifen-Flächen erhalten keine weitere Maßnahmenprämie. Die
    Anrechnung von Agroforststreifen auf die 15 a der UBB/BIO-Feldstücksregel ist davon unberührt.
11. **Förderwerbende:** SRL 1.4 hebt den Ausschluss von Gebietskörperschaften und Einrichtungen mit
    bestimmendem Einfluss (> 25 %) für 1C ab 2025 auf; daher wird die 25 %-Grenze für 1C nicht geprüft.
12. **Betriebsmindestgröße:** `land.total_area_ha` wird als landwirtschaftliche Fläche ohne
    Landschaftselemente/Agroforststreifen interpretiert; Agroforststreifen und (neu)
    `land.landscape_elements_area_ha` werden addiert. Liegt `farm.oepul.first_participation_year` nicht vor,
    wird das Antragsjahr als erstes Teilnahmejahr angenommen (konservativ).
13. **Maßnahmenbezogener OP-Code für 1C:** Die Quellen nennen keinen konkreten Code (analog „OPUBB",
    „OPBIO"). Jeder Code mit Präfix „OP" erfüllt die OP-Kennzeichnungspflicht; prämienausschließend sind
    „OP" und „VF" sowie die Statusflags.
```
