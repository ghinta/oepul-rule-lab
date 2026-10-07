# o6_15: offene Fachentscheidungen

Alle Antworten und App-Zuordnungen bleiben offen. Die Zitate sind Modellnotizen bzw. Prüfbeobachtungen, keine bestätigte Fachauslegung.

### o6_15-INPUT_CONTRACT

Welche der im Diff einzeln gelisteten Eingaben werden fachlich benötigt und aufgenommen? Für jede: verbindlicher Name, Betrieb/Schlag/Tier/Gruppe/Projekt, Einheit, Zeitbezug, Herkunft/Nachweis und Abgrenzung zu bestehenden App-Feldern. Luna- und Opus-Strukturen sind alternative Vorschläge; keine automatische Umbenennung.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_15-luna-high-20261004/workspace/rules/profile_changes.json:8–11`

```text
      "path": "farm.participates_almbewirtschaftung",
      "value_after": true,
      "rationale": "Die gleichzeitige Teilnahme an Almbewirtschaftung ist eine Zugangsvoraussetzung.",
      "rule_ids": ["O615-003"],
```

Ursprung: `runs/v2-o6_15-opus-5.5-high-20260926/workspace/rules/profile_changes.json:8–11`

```text
      "path": "farm.applicant",
      "value_before": null,
      "value_after": {
        "legal_form": "enum(natural_person|registered_partnership|legal_person|association|public_body)",
```

### o6_15-HERDER_IDENTITY

Wie wird eine Person eindeutig einer Alm/Jahres-Auftriebsliste zugeordnet? Welche fachliche Auswahl gilt bei Mehrfachnennung statt alphabetischer erster alm_id?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_15-opus-5.5-high-20260926/workspace/notes/assumptions.md:59–67`

```text
11. **Mehrfach genannte Hirtinnen/Hirten.** Eine Person, die auf mehreren
    Almen angegeben ist, wird nur der ersten Alm (nach `alm_id`) zugerechnet.
    Die Quellen sagen nur, dass die Prämie „nur einmal beantragt“ werden kann.
12. **Mindestteilnahme 3,00 RGVE** wird gegen die Summe der anrechenbaren,
    behirteten RGVE aller Almen geprüft – ohne Deckelung auf 50 RGVE je
    Hirtin/Hirte.
13. **Mindestbestoßung durch hintereinander aufgetriebene Tiere** kann aus den
    Einzeldaten nicht zuverlässig abgeleitet werden (Lücken, Überschneidungen).
    Deshalb wird dafür das Eingabefeld `stocking_days` verwendet.
```

### o6_15-DAIRY_BLOCKS

Wie werden Milchvieh-RGVE auf 50-RGVE/Hirtenblöcke und mehrere Almen verteilt? Welche Formel gilt beim widersprüchlichen Beispiel 2?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_15-opus-5.5-high-20260926/workspace/notes/assumptions.md:7–17`

```text
1. **Beispiel 2 (Informationsblatt, Kap. 9, S. 8) – Rechenfehler bei Alm B.**
   Das Blatt nennt für „Hirte Alm B: 20 RGVE × 81,0 € + 30 RGVE × 27,0 €“ den
   Betrag 2.295,0 €. Rechnerisch sind es 2.430,0 € (2.295 € entspricht 25 RGVE ×
   27 € aus Beispiel 1). Die Policy rechnet korrekt; die Gesamtprämie beträgt
   daher 12.669,6 € statt der ausgewiesenen 12.534,6 €
   (Test `test_example2_total_uses_correct_arithmetic`). Beim Hundezuschlag steht
   außerdem der Tippfehler „1,200,0 €“ (gemeint 1.200,0 €).
2. **Modulationsbeispiel (Allgemeine Teilnahmebedingungen, S. 20).** Für 230 RGVE
   wird der Faktor 98,66 % genannt. Nach dem angegebenen Schema (200 × 100 % +
   30 × 90 %) / 230 ergibt sich 98,70 %. Die Policy verwendet die Formel
   (Test `test_modulation_factor`).
```

Ursprung: `runs/v2-o6_15-opus-5.5-high-20260926/workspace/notes/assumptions.md:25–35`

```text
4. **Zuordnung der Milchvieh-RGVE zu den Hirtenblöcken.** Die Quellen regeln
   nur, dass die erhöhte Prämie für die ersten 20 RGVE „pro 50 RGVE und Hirtin
   oder Hirte“ gilt. Beispiel 1 (2 Hirten, 40 Milchkuh-RGVE) weist trotzdem nur
   20 Milchvieh-RGVE zum höheren Zuschlag aus. Daraus wird abgeleitet: Die
   Milchvieh-RGVE werden vorrangig in die Blöcke eingerechnet, und der höhere
   Zuschlag gilt nur für die ersten 20 RGVE je 50er-Block
   (`higher_rate_rgve(min(dairy, capped))`). Beide Beispiele werden so exakt
   reproduziert.
5. **Blockbefüllung je Hirtin/Hirte.** Die RGVE werden der Reihe nach auf die
   Hirtinnen und Hirten verteilt, je Person mit höchstens 50 RGVE
   (Beispiel 1: 50 + 45).
```

### o6_15-MULTI_ALM

Wie werden anteilige Alpungstage, Erstauftrieb und Modulation mehrerer Almen ermittelt? Ein fehlender Gesamtzeitraum darf nicht automatisch Anteil 1 bestätigen.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_15-opus-5.5-high-20260926/workspace/notes/assumptions.md:25–53`

```text
4. **Zuordnung der Milchvieh-RGVE zu den Hirtenblöcken.** Die Quellen regeln
   nur, dass die erhöhte Prämie für die ersten 20 RGVE „pro 50 RGVE und Hirtin
   oder Hirte“ gilt. Beispiel 1 (2 Hirten, 40 Milchkuh-RGVE) weist trotzdem nur
   20 Milchvieh-RGVE zum höheren Zuschlag aus. Daraus wird abgeleitet: Die
   Milchvieh-RGVE werden vorrangig in die Blöcke eingerechnet, und der höhere
   Zuschlag gilt nur für die ersten 20 RGVE je 50er-Block
   (`higher_rate_rgve(min(dairy, capped))`). Beide Beispiele werden so exakt
   reproduziert.
5. **Blockbefüllung je Hirtin/Hirte.** Die RGVE werden der Reihe nach auf die
   Hirtinnen und Hirten verteilt, je Person mit höchstens 50 RGVE
   (Beispiel 1: 50 + 45).
6. **Modulationsbasis.** Nach dem Beispiel wird „230 RGVE“ wie „230 ha“
   behandelt. Basis ist je Alm min(aufgetriebene RGVE mit ≥ 60 Tagen,
   Almweidefläche in ha), summiert über alle Almen des Almbetriebs. Offen ist,
   ob bei mehreren Almen je Alm oder für den gesamten Almbetrieb moduliert wird;
   umgesetzt ist die Summe über den Almbetrieb. Optional kann `stocked_rgve`
   direkt eingegeben werden.
7. **Anteilige Anrechnung.** Anteil = anerkannte Tage auf dieser Alm /
   `total_alpine_days_all_herded_alms`. Fehlt dieser Wert, gilt die Alm als
   einzige Alm (Anteil 1).
8. **Stichtag 15. Juli bei Weitertrieb.** Für die Anerkennung „bis 15. Juli
   aufgetrieben“ zählt der Erstauftrieb (`first_drive_up_date`), nicht das
   Umtriebsdatum auf die zweite Alm. Sonst würden die Tiere in Beispiel 2
   (Wechsel nach 66 Tagen, also im August) auf Alm B nicht zählen, obwohl das
   Blatt sie anrechnet.
9. **Verspätete Meldung.** Die anerkannten Alpungstage beginnen frühestens
   14 Tage (Rinder) bzw. 7 Tage (übrige Arten) vor dem Meldedatum. Ob eine
   verspätete Meldung zusätzlich sanktioniert wird, ist nicht geregelt; sie wird
   nur als Verstoß markiert.
```

### o6_15-TOPUP_COMBINATION

Welche aktuelle Landes-Top-up-Bestätigung ist erforderlich? Erfüllt bloße Teilnahme ohne Almprämie in Kalkalpen die Kombination?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_15-opus-5.5-high-20260926/workspace/notes/assumptions.md:77–84`

```text
16. **Nationalpark Kalkalpen.** Dort ist Almbewirtschaftung nicht
    prämienfähig. Offen ist, ob die Kombinationsverpflichtung der Behirtung
    trotzdem durch *Teilnahme* ohne Prämie erfüllt ist. Die Policy gibt dazu nur
    einen Hinweis aus.
17. **Landes-Top-up.** Ob ein Bundesland das Top-up gewährt, ist eine externe
    Eingabe (`federal_state_top_up_granted`,
    `federal_state_top_up_notified_by_may_15`). Die Quellen legen nicht fest,
    welche Länder es gewähren.
```
