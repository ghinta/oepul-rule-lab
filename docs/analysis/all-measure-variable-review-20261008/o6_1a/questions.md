# o6_1a: offene Fachentscheidungen

Alle Antworten und App-Zuordnungen bleiben offen. Die Zitate sind Modellnotizen bzw. Prüfbeobachtungen, keine bestätigte Fachauslegung.

### o6_1a-PHEROMONE_PERIOD

Wie wird das Ende der Vegetationsperiode bestimmt und nachgewiesen? Reicht die Aufbewahrung bis 30. September trotz abweichender SRL-Formulierung?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_1a-opus-5.5-high-20260929/workspace/notes/assumptions.md:22–23`

```text
3. **Aufbewahrung der Pheromonfallen:** SRL „bis zum Ende der Vegetationsperiode“, Informationsblatt „zumindest bis
   30. September“. Rego prüft das Eingabefeld `traps_kept_until_sept_30`; Coverage-Eintrag `unresolved`.
```

### o6_1a-FIELD_PIECE_IDENTITY

Ist AMA feldstueckskennung je Betrieb und Antragsjahr der verbindliche Feldstück-Gruppierungsschlüssel? Wie wird feldstuecksnummer abgegrenzt? Luna fieldpiece_id und Opus field_piece_id bleiben ungeklärte Kandidaten.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_1a-luna-high-20260930/workspace/rules/profile_changes.json:15–18`

```text
    {"action":"add","path":"land.parcels[].fieldpiece_id","value_before":null,"value_after":"string","rationale":"Die feldstücksbezogenen Schwellen erfordern eine Feldstück-ID.","rule_ids":["o6_1a.arable_fieldpiece","o6_1a.grassland_fieldpiece"],"source_reference_ids":["ref_ubb_p6_fieldpiece"]},
    {"action":"add","path":"land.parcels[].biodiversity_management.variant","value_before":null,"value_after":"DIVSZ","rationale":"Die gewählte Grünland-DIV-Variante fehlt im Profil.","rule_ids":["o6_1a.grassland_variants","o6_1a.grassland_divsz","o6_1a.grassland_altgrass"],"source_reference_ids":["ref_ubb_p16_gl_variants","ref_ubb_p18_altgrass"]},
    {"action":"add","path":"land.parcels[].biodiversity_management.insect_flowering_partners","value_before":null,"value_after":0,"rationale":"Für die Acker-DIV-Ansaat ist die Zahl der insektenblütigen Mischungspartner erforderlich.","rule_ids":["o6_1a.arable_sowing"],"source_reference_ids":["ref_ubb_p8_sowing"]},
    {"action":"add","path":"land.parcels[].biodiversity_management.plant_families","value_before":null,"value_after":0,"rationale":"Für die Acker-DIV-Ansaat ist die Zahl der Pflanzenfamilien erforderlich.","rule_ids":["o6_1a.arable_sowing"],"source_reference_ids":["ref_ubb_p8_sowing"]},
```

Ursprung: `runs/v2-o6_1a-opus-5.5-high-20260929/workspace/rules/profile_changes.json:376–379`

```text
          "field_piece_id": "string",
          "streuobst": "boolean",
          "fruit_species": "string|null",
          "tree_form": "enum(hochstamm|halbstamm|other)|null",
```

### o6_1a-DIV_CREDIT

Welche DIV-/NAT-/EBW-/BAW-/AG-/N2-/Heckenflächen zählen zu welcher Quote und zu welchen Prämien? Darf der heutige DIV-Flächentotal dafür verwendet werden oder werden getrennte Anrechenbarkeitswerte benötigt?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_1a-opus-5.5-high-20260929/workspace/notes/assumptions.md:31–45`

```text
7. **75 %/25 %-Regel mit Projektbestätigung:** Laut Beispiel (1,5 ha NAT ab 1.7.) verbrauchen früh genutzte
   Projektflächen das 25 %-Kontingent vorrangig; darüber hinausgehende Nutzung durch Projektflächen ist zulässig,
   UBB-eigene Flächen dürfen dann nicht mehr früh genutzt werden.
8. **2026 OPUBB/OPBIO:** Mit OPUBB/OPBIO codierte Acker-DIV zählen nicht zum 25 %-Kontingent, dürfen vor dem
   1. August beweidet und (ab Hinweis 12.08.) dreimal genutzt werden; sie erhalten keine UBB-Prämie (`common.no_premium`).
   Für Grünland: zusätzliche 14 Tage Vorverlegung (DIVSZ nur mit zweiter Mahd vergleichbarer Schläge) bzw. 49 Tage
   Ruhezeit (DIVNFZ). Die 14 Tage werden auf beide Termine (15.6./15.7.) angewandt.
9. **Variantenwechsel nach 15.04.:** Der Hinweis formuliert die Wechselfristen unabhängig von 2026 („unter bestimmten
   Voraussetzungen“); sie werden daher jahresunabhängig angewandt.
10. **Basismodulprämie Acker „bei Grünbrache bis max. 20 %“:** Interpretiert als: Grünbrache-DIV erhalten die
    Basisprämie bis 20 % der Ackerfläche; Grünbrachen ohne DIV sind nicht förderfähig (Allg. Bedingungen 5.5.1).
11. **Aus anderen Maßnahmen angerechnete DIV** (NAT, EBW, BAW, AG, N2) erhalten keine UBB-Prämie (auch keine
    Basisprämie). N2-Flächen ohne DIV-Code erhalten die UBB-Basisprämie (Anhang L: kombinierbar).
12. **Mehrnutzenhecken als DIV** zählen zur 7 %-Grenze, erhalten aber keine flächenbezogenen DIV-Zuschläge
    (nur den Mehrnutzenhecken-Zuschlag); Quelle regelt dies nicht ausdrücklich.
```

### o6_1a-BOUNDARIES

Welche Ersatzregel gilt bei genau 10 ha Acker und wie werden Feldstücks-, LSE- und Kulturkappungen zugeordnet, wenn mehrere Flächen konkurrieren?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_1a-opus-5.5-high-20260929/workspace/notes/assumptions.md:17–21`

```text
1. **Grenze 10 ha Acker bei der Grünland-Ersatzerfüllung (6.1.1):** Informationsblatt „unter 10,00 ha“, SRL
   „Betriebe bis 10 ha“. Umgesetzt nach SRL (`<= 10`). Differenz nur bei genau 10,00 ha.
2. **Ersatzerfüllung über Grünland:** Umgesetzt nach dem Beispiel 9 ha / 5 ha: gesamt ≥ 7 % von (Acker + gemähtes
   Grünland) *und* Grünland-DIV ≥ Grünland-Mindestanlage (nur, wenn diese greift). Der Querverweis „Kapitel 0“ im
   Informationsblatt ist defekt; angenommen ist Kapitel 6.2.
```

### o6_1a-IN_YEAR

Wie werden unterjährig noch offene Mindestpflegepflichten geprüft, ohne fehlende künftige Ereignisse als Verletzung zu werten?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_1a-opus-5.5-high-20260929/workspace/notes/assumptions.md:28–30`

```text
6. **Zweijährigkeit/Mindestpflege „jedes zweite Jahr“:** Umgesetzt über das Eingabefeld `used_previous_year`; die
   Eingabe beschreibt stets ein abgeschlossenes Kalenderjahr. Unterjährige Auswertungen können Mindestpflichten
   (Mahd, zweite Nutzung) fälschlich als verletzt melden.
```
