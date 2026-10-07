# o6_2: offene Fachentscheidungen

Alle Antworten und App-Zuordnungen bleiben offen. Die Zitate sind Modellnotizen bzw. Prüfbeobachtungen, keine bestätigte Fachauslegung.

### o6_2-INPUT_CONTRACT

Welche der im Diff einzeln gelisteten Eingaben werden fachlich benötigt und aufgenommen? Für jede: verbindlicher Name, Betrieb/Schlag/Tier/Gruppe/Projekt, Einheit, Zeitbezug, Herkunft/Nachweis und Abgrenzung zu bestehenden App-Feldern. Luna- und Opus-Strukturen sind alternative Vorschläge; keine automatische Umbenennung.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_2-luna-high-20260930/workspace/rules/profile_changes.json:8–11`

```text
      "path": "year",
      "value_after": "int",
      "rationale": "The evaluator needs the current contract/application year at the profile root.",
      "rule_ids": ["O62-R02", "O62-R15", "O62-R25", "O62-R37"],
```

Ursprung: `runs/v2-o6_2-opus-5.5-high-20260930/workspace/rules/profile_changes.json:8–11`

```text
      "path": "farm.oepul",
      "value_before": null,
      "value_after": {
        "applicant_type": "enum(natural_person|registered_partnership|legal_person|association|public_body)",
```

### o6_2-NITROGEN

Welche Fläche und welche jahresbezogene Menge nach Stall-/Lagerverlusten bilden die 170-kg-N-Grenze? Welche NAPV-/Faktorquelle und Nachweise sind erforderlich?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_2-opus-5.5-high-20260930/workspace/notes/assumptions.md:24–39`

```text
1. **Tierhaltereigenschaft / Besatzstufe:** „RGVE/ha“ in der Prämientabelle wird als RGVE je ha
   Futterfläche (Grünland + Ackerfutter) ausgelegt, wie bei der 0,30-Schwelle. Almweideflächen
   (`land_use = alpine_pasture`) zählen nicht zur Futterfläche.
2. **Stichtag der Tierhaltereigenschaft:** Die Tierzahl (`animal_count`) wird als bereits nach
   der vorgeschriebenen Methode ermittelt übernommen (Rinderdatenbank-Durchschnitt bzw.
   Stichtag 1. April / Durchschnittstierliste). Betriebsstrukturwechsel (O6_2-LIVESTOCK-009) sind
   vorab in der Tierzahl zu berücksichtigen.
3. **Stickstoffgrenze 170 kg N/ha:** Die Bezugsfläche ist die Summe der Parzellen in Österreich
   ohne Almweideflächen (Alm-N wird separat abgezogen). Der N-Anfall nach Stall- und
   Lagerverlusten wird als Eingabe erwartet; die Berechnung aus Tierbestand und
   N-Anfallsfaktoren liegt nicht in den Quellen und ist nicht implementiert.
4. **Organische Rückstände und Klärschlamm** werden unabhängig von der Herkunft als unzulässig
   behandelt, weil das Informationsblatt sie ohne Einschränkung als unzulässig bezeichnet.
   Eigener, nicht nach VO (EU) 2018/848 zulässiger Kompost und eigene Biogasgülle gelten als
   nicht betriebsfremd und damit zulässig. Unbekannte, betriebsfremde, N-haltige Mittel gelten
   als unzulässig.
```

### o6_2-PSM_PART_FARM

Gelten Bio-Wirkstoff-Ausnahmen auch für Beizung und Zweitkultur-Ackerfutter? Welche Bio-Teilbetriebs-Kulturbereiche sind tatsächlich zulässig?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_2-opus-5.5-high-20260930/workspace/notes/assumptions.md:40–49`

```text
5. **Saatgutbeizung:** Sie zählt als flächige Anwendung. Die Ausnahme für ausschließlich
   Bio-zulässige Wirkstoffe wird auch auf die Beizung angewendet (das Blatt sagt „daher nicht
   zulässig“ nur in Bezug auf die Einordnung als flächig).
6. **PSM-Verbot bei Ackerfutter als Zweitkultur:** Das Verbot gilt für die tatsächliche
   Ackerfutterkultur auch dann, wenn diese als Zweitkultur beantragt wurde. Die
   Zweitkultur-Regel betrifft laut Quelle nur Prämie und Futterfläche.
7. **Bio-Kombination:** Die SRL nimmt Bio-Teilbetriebe allgemein aus; das Informationsblatt
   beschränkt die Ausnahme auf den Kulturbereich Wein, Obst und Hopfen. Implementiert ist die
   engere Fassung des Informationsblatts. **Offen**, ob ein Bio-Teilbetrieb mit Kulturbereich
   Acker/Grünland zulässig wäre (praktisch ausgeschlossen, weil UBB nur Acker/Grünland betrifft).
```

### o6_2-PAYMENT_AREA

Gilt bei GLÖZ-8-NPF Nullprämie oder Ackerprämie? Welche Parzellen werden bei Flächenzugang gekürzt und welche OP-Codes betreffen nur UBB/BIO?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_2-opus-5.5-high-20260930/workspace/notes/assumptions.md:50–64`

```text
8. **Nicht kombinierbare Einzelflächen (Anhang L):** Liegt eine Parzelle in einer mit 2
   prämienmäßig nicht kombinierbaren Maßnahme (z. B. 18 Naturschutz, 4 Bergmähder), erhält sie
   keine o6_2-Prämie. Die Verpflichtungen gelten trotzdem gesamtbetrieblich, und die Fläche zählt
   weiter zur Futterfläche. Für die Zelle 2/16 („a“) trifft der Abschlag laut SRL 2.16 die
   Basisprämie von Maßnahme 16, nicht o6_2.
9. **GLÖZ-8-NPF bis 2024:** „keine Ackerfutterflächen-Prämie“ wird als o6_2-Prämie von 0 €/ha
   umgesetzt. **Offen**, ob stattdessen die Ackerflächenprämie zustünde.
10. **Flächenzugang ab 2026:** Welche konkreten Parzellen bei Überschreitung des Zugangs nicht
    prämienfähig sind, regeln die Quellen nicht. Die Kürzung wird als überschießende Fläche mal
    durchschnittlicher Nettoprämiensatz umgesetzt.
11. **Reihenfolge der Kürzungen:** Umgesetzt ist die Reihenfolge inhaltliche Sanktion →
    Modulation → Obergrenze je Schlag → Zugangskürzung (Ausschnitt aus SRL 1.12.2). Die übrigen
    Kürzungsarten (Über-/Untererklärung, Fristversäumnis, Konditionalität) sind nur als
    Datenliste abgebildet, da keine Eingaben existieren. `other_area_payments_eur_per_ha` wird als
    bereits modulierter Betrag angenommen.
```

### o6_2-TRAINING_DUE

Ab welchem tatsächlichen Datenstichtag dürfen die bis 31.12.2025 fälligen Bildungsnachweise als verletzt gelten?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_2-opus-5.5-high-20260930/workspace/notes/assumptions.md:68–70`

```text
13. **Weiterbildung:** Stunden mehrerer anrechenbarer Kurse werden summiert. Der Verstoß wird ab
    Antragsjahr 2025 gemeldet, wenn bis 31.12.2025 weniger als 3 anrechenbare Stunden vorliegen.
    Für 2025 kann das vor Jahresende noch vorläufig sein.
```
