# o6_21: offene Fachentscheidungen

Alle Antworten und App-Zuordnungen bleiben offen. Die Zitate sind Modellnotizen bzw. Prüfbeobachtungen, keine bestätigte Fachauslegung.

### o6_21-INPUT_CONTRACT

Welche der im Diff einzeln gelisteten Eingaben werden fachlich benötigt und aufgenommen? Für jede: verbindlicher Name, Betrieb/Schlag/Tier/Gruppe/Projekt, Einheit, Zeitbezug, Herkunft/Nachweis und Abgrenzung zu bestehenden App-Feldern. Luna- und Opus-Strukturen sind alternative Vorschläge; keine automatische Umbenennung.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_21-luna-high-20261005/workspace/rules/profile_changes.json:6–9`

```text
    {"action":"add","path":"participation_year","value_after":"int","rationale":"Discover-Vorschlag für die jahresabhängige Betriebsmindestgröße.","rule_ids":["O621-FARM-SIZE"],"source_reference_ids":["SRC-GENERAL-FARM-SIZE"]},
    {"action":"add","path":"farm.o6_21.year","value_after":"int","rationale":"Discover-Vorschlag für antragsjahrabhängige Maßnahmeregeln.","rule_ids":["O621-PREMIUM","O621-COMPOST-ALTERNATIVES","O621-STALL-PLAN-HISTORY"],"source_reference_ids":["SRC-MEASURE-RATES","SRC-MEASURE-COMPOST-2025","SRC-MEASURE-PLAN-REMOVED"]},
    {"action":"add","path":"farm.o6_21.participating_categories","value_after":["male_from_half_year"],"rationale":"Discover-Vorschlag für die beantragten Rinderkategorien.","rule_ids":["O621-CATEGORIES","O621-MILK-DELIVERY","O621-QPLUS"],"source_reference_ids":["SRC-MEASURE-CATEGORIES","SRC-MEASURE-MILK","SRC-MEASURE-QPLUS"]},
    {"action":"add","path":"farm.o6_21.average_fundable_rgve","value_after":"number","rationale":"Discover-Vorschlag für Mindestteilnahme und Prämienberechnung.","rule_ids":["O621-MIN-RGVE","O621-PREMIUM"],"source_reference_ids":["SRC-MEASURE-MINIMUM","SRC-MEASURE-RATES"]},
```

Ursprung: `runs/v2-o6_21-opus-5.5-high-20260928/workspace/rules/profile_changes.json:8–11`

```text
      "path": "farm.applicant",
      "value_before": null,
      "value_after": {
        "type": "enum(natural_person|registered_partnership|legal_person|association_of_persons|public_body)",
```

### o6_21-WEIGHT_BOUNDARIES

Welche Platzklasse gilt bei exakt 500 kg? Welche Belegung im Abteil, Gewichtsgruppen und datierten Verpflichtungsfenster sind maßgeblich?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_21-opus-5.5-high-20260928/workspace/notes/assumptions.md:32–44`

```text
6. **Stichtage:** `on_farm_until` wird als exklusiv behandelt, der Abgangstag zählt also nicht mehr.
   Lebensalter-Grenzen werden über Geburtsdatum + 6 bzw. 24 Monate berechnet. Die taggenaue Konvention
   der Rinderdatenbank ist nicht dokumentiert.
7. **Wann ein Verstoß zählt:** Maßgeblich ist `housing.conditions_breached_from`, und der Verstoß zählt
   nur, wenn er in das Verpflichtungsfenster einer beantragten Kategorie fällt (Beispiel „Kälber mit
   7 Monaten“). Fehlt das Datum, gilt der Verstoß ab Jahresbeginn.
8. **Stallabteile:** Der Platzbedarf wird je Abteil aus `occupants` berechnet (maximale Belegung inklusive
   geweideter Tiere und Kühe). Ein Verstoß im Abteil wird allen dort verknüpften Tieren zugerechnet. Im
   Informationsblatt-Beispiel (> 500 kg) sind nur die „betroffenen Tiere“ abzumelden – die Abteile sollten
   daher je Gewichts-/Tiergruppe erfasst werden.
9. **Gewichtsklassen:** „bis X kg“ gilt einschließlich X; „ab 500 kg“ bedeutet über 500 kg, weil „bis 500 kg“
   die 500 kg einschließt. Das Belegungsplan-Beispiel mit 25,50 m² wird damit exakt reproduziert.
10. **Kälberschlupf (40 %):** Wird nur im Rahmen der Mutterkuh-/Liegeboxenausnahme geprüft.
```

### o6_21-RGVE_ELIGIBLE

Welche RGVE zählen vor/nach Abmeldungen zur TGD-Schwelle und Mindestteilnahme? Welche Tiere erhalten den reduzierten Alm-/Weidesatz und für welchen Zeitraum?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_21-opus-5.5-high-20260928/workspace/notes/assumptions.md:21–31`

```text
2. **Reduzierter Satz:** Er wird auf die gesamten RGVE des betroffenen Tieres im Förderjahr angewendet,
   nicht nur auf den Alm- oder Weidezeitraum. Die Quellen sagen dazu nichts Näheres. Auslöser sind die
   Tier-Flags `alm_driven`, `tierwohl_weide_participation` und `coupled_support_alm`.
3. **TGD-Schwelle („über 10,00 RGVE an förderbaren Rindern“):** Berechnet wird der Jahresdurchschnitt der
   RGVE aller Tiere in beantragten, nicht ausgeschlossenen Kategorien, vor Abzug abgemeldeter Tiere.
4. **Mindestteilnahme 2,00 RGVE:** Grundlage sind die prämienfähigen RGVE nach Abzug abgemeldeter oder
   ausgeschlossener Tiere. Möglich ist auch die Lesart, dass abgemeldete Tiere mitzählen.
5. **TGD und Qplus:** Laut SRL sind beide Förderverpflichtungen und keine Zugangsvoraussetzungen. Ein
   Verstoß wird als Verstoß ausgegeben, die Prämie wird aber nicht automatisch auf null gesetzt. Die
   Sanktionsstufe legt die AMA fest; sie wird nicht berechnet. `sanction_reduction_percent` ist nur eine
   Nachschlagefunktion für die Stufe.
```

### o6_21-COMPOST_YEAR

Ab welchem Jahr ist die wendefreie Kompostierung zulässig? Wie wird nennenswertes Ausmaß ohne erfundene 50-%-Schwelle nachgewiesen?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_21-opus-5.5-high-20260928/workspace/notes/assumptions.md:45–51`

```text
11. **Kompostierung:**
    - Die SRL schreibt „und/oder Strauchschnitt“, das Informationsblatt „oder“. Umgesetzt ist: mindestens
      ein Pflanzenmaterial genügt.
    - Die wendefreie Variante mit Beimengung (Informationsblatt, Ergänzung Oktober 2025) steht nicht in der
      SRL. Sie ist ohne Jahresgrenze umgesetzt.
    - „Nennenswertes Ausmaß (z. B. 50:50)“ ist keine harte Schwelle und wird daher als Boolean erfasst.
    - Beim Umsetzen genügt ein Paar von Umsetzvorgängen im Abstand von mindestens 14 Tagen.
```
