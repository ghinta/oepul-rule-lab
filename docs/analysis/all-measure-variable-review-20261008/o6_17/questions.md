# o6_17: offene Fachentscheidungen

Alle Antworten und App-Zuordnungen bleiben offen. Die Zitate sind Modellnotizen bzw. Prüfbeobachtungen, keine bestätigte Fachauslegung.

### o6_17-INPUT_CONTRACT

Welche der im Diff einzeln gelisteten Eingaben werden fachlich benötigt und aufgenommen? Für jede: verbindlicher Name, Betrieb/Schlag/Tier/Gruppe/Projekt, Einheit, Zeitbezug, Herkunft/Nachweis und Abgrenzung zu bestehenden App-Feldern. Luna- und Opus-Strukturen sind alternative Vorschläge; keine automatische Umbenennung.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_17-luna-high-20261005/workspace/rules/profile_changes.json:6–9`

```text
    {"action":"add","path":"oepul.o6_17.participating","value_after":"boolean","rationale":"Teilnahme an o6_17 muss erfasst werden.","rule_ids":["o617.combination.ubb_or_bio"],"source_reference_ids":["o617_combination"]},
    {"action":"add","path":"oepul.o6_17.is_first_participation_year","value_after":"boolean","rationale":"Erstes Teilnahmejahr steuert die Zugangsschwellen.","rule_ids":["o617.minimum.first_year_area","o617.minimum.first_year_share","o617.animal.tierholding_threshold"],"source_reference_ids":["o617_minimum","o617_tierholding"]},
    {"action":"add","path":"oepul.o6_17.combination","value_after":"enum(ubb|bio|bio_part_farm)","rationale":"Zulässige Kombinationsmaßnahme muss erfasst werden.","rule_ids":["o617.combination.ubb_or_bio","o617.combination.table_measure17"],"source_reference_ids":["o617_combination","annex_L_combination"]},
    {"action":"add","path":"oepul.o6_17.contract_start_year","value_after":"int","rationale":"Vertragsbeginn bestimmt Laufzeit und Antrag.","rule_ids":["o617.contract.minimum_four_years","o617.application.deadline_and_last_entry"],"source_reference_ids":["o617_contract","o617_application"]},
```

Ursprung: `runs/v2-o6_17-opus-5.5-high-20261002/workspace/rules/profile_changes.json:8–11`

```text
      "path": "farm.applicant",
      "value_before": null,
      "value_after": {
        "legal_form": "enum(natural_person|registered_partnership|legal_person|association|public_body)",
```

### o6_17-AGL_BOUNDARIES

Wie gelten Grenze 20 bei Grünlandzahl, AGL-Mindestgarantie 2 ha, Flächenzuordnung und Zugangsbeschränkung für den einjährigen AGL-Zuschlag?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_17-opus-5.5-high-20261002/workspace/notes/assumptions.md:7–21`

```text
1. **Hangneigung ab 18 % ab 2025 (Merkblatt Kap. 1).** Im Merkblatt steht pauschal, dass ab 2025
   „auch eine Hangneigung ab 18 % gefördert“ wird. Laut SRL 2.17 („Art der Unterstützung“) und der
   Prämientabelle gilt das nur für artenreiche Grünlandflächen (AGL 162 €/ha). Die Grundprämie bleibt
   daher auf < 18 % beschränkt (`O617-SCOPE-BASE-SLOPE`).
2. **Grenze Grünlandzahl 20.** Das Merkblatt schreibt „bis 20“ und „ab 20 bis unter 30“, die Zahl 20
   fällt also in beide Stufen. Verwendet werden die SRL-Intervalle `< 20`, `>= 20 und < 30`, `>= 30 und < 40`
   und `>= 40`. Bei Widerspruch geht die SRL vor (`GEN-LEGAL-HIERARCHY`).
3. **AGL-Obergrenze „jedenfalls aber 2,00 ha“.** Umgesetzt als `max(Anteil × gemähtes Grünland; 2,00 ha)`.
   Gemähtes Grünland umfasst alle gemähten Grünland-Schlagnutzungsarten ohne Bergmähder.
   Übersteigt die AGL-fähige Fläche die Obergrenze, wird proportional über alle Schläge gekürzt.
   Welche Schläge die AMA tatsächlich vorrangig berücksichtigt, ist nicht geregelt.
4. **Flächenzugang ab 2026.** Obergrenze = Fläche 2025 + max(50 % × Fläche 2025; 5 ha). Die Kürzung
   wird proportional auf die Grundprämie angewendet. Ob auch der AGL-Zuschlag betroffen ist, bleibt offen:
   AGL ist ein einjähriger Zuschlag und unterliegt nach Allg. Bedingungen 7.2 vermutlich nicht der
   Beschränkung. Er wird hier nicht gekürzt.
```

### o6_17-AREA_SLOPE

Welche Gesamt-/Futter-/Almfläche bildet den 40-%-Grünlandanteil? Was bedeutet Hangneigung am Schlag und wie wird vollflächige Mahd mit Abtransport belegt?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_17-opus-5.5-high-20261002/workspace/notes/assumptions.md:27–33`

```text
6. **Grünlandanteil 40 %.** Als „landwirtschaftliche Nutzfläche ohne Almweideflächen“ wird
   `land.total_area_ha − land.alpine_pasture_area_ha` verwendet. Ob `total_area_ha` im Profil Almflächen
   enthält, ist nicht festgelegt.
7. **Futterfläche.** Alle Grünlandschläge außer „Sonstige Grünlandflächen“ und Grünlandbrachen sowie
   die Ackerfutter-Schlagnutzungsarten. Almweideflächen (`land_use = alpine_pasture`) zählen nicht dazu.
8. **Schlagnutzungsart „weide“.** Das ist ein Sammelcode für nicht gemähte Weideflächen und wird in den
   Quellen nicht namentlich geführt (Annahme).
```

### o6_17-TRAINING_SOIL

Ab welchem Stichtag sind Bildung/Bodenproben fällig, welche Themen sind Pflicht und welche MFA-2025-Fläche/Nachweise zählen?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_17-opus-5.5-high-20261002/workspace/notes/assumptions.md:34–41`

```text
9. **Weiterbildung und Bodenproben – Prüfzeitpunkt.** Eine Verletzung wird ab dem Antragsjahr 2025
   gemeldet, weil die Frist am 31.12.2025 endet. Eine Person, die *vor* dem 31.12.2025 ausscheidet,
   macht ihre Kurse unanrechenbar.
   Die SRL verlangt, dass die drei Themen „jedenfalls Inhalt“ der Kurse sind; das Merkblatt nennt sie nur
   „mögliche Themen“. Die Themenprüfung ist daher nur im Katalog erfasst (`O617-OBL-TRAINING-TOPICS`) und
   nicht als harte Rego-Bedingung umgesetzt.
10. **Bodenproben-Basis.** Bevorzugt wird der Profilwert `soil_sample_base_mfa2025_grassland_lt18_ha`
    (MFA 2025) verwendet. Fehlt er, wird die Basis nur im Antragsjahr 2025 aus den Schlägen berechnet.
```

### o6_17-SPECIES_DOCUMENTATION

Wie werden Kennarten, Abschnitte, Beobachtungsdatum und Namensvarianten bestätigt? Beide Modelllisten und Zuordnungen bleiben prüfpflichtig.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_17-opus-5.5-high-20261002/workspace/notes/assumptions.md:51–58`

```text
15. **Kennartenliste.** Merkblatt und Anhang H weichen bei der Familienzuordnung ab: Ehrenpreis ist im
    Merkblatt ein Wegerich-, im Anhang ein Löwenmaulgewächs. Taubenkropf-Leimkraut steht im Anhang H
    layoutbedingt im Block der Schmetterlingsblütler. Beide Zuordnungen sind in den Daten erfasst; für die
    Zählung ist das ohne Bedeutung.
    Schreibweise „Karthäuser-Nelke“ (Merkblatt) vs. „Kartäuser-Nelke“ (Anhang H).
16. **Mindestbewirtschaftung.** Als „Mahd erfolgt“ gilt mindestens ein Eintrag in
    `operations.cutting_dates`. Ob die Mahd vollflächig war und das Mähgut verbracht wurde, ist nicht im
    Profil abbildbar.
```
