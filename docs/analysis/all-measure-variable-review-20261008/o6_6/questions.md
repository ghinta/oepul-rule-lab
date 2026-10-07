# o6_6: offene Fachentscheidungen

Alle Antworten und App-Zuordnungen bleiben offen. Die Zitate sind Modellnotizen bzw. Prüfbeobachtungen, keine bestätigte Fachauslegung.

### o6_6-INPUT_CONTRACT

Welche der im Diff einzeln gelisteten Eingaben werden fachlich benötigt und aufgenommen? Für jede: verbindlicher Name, Betrieb/Schlag/Tier/Gruppe/Projekt, Einheit, Zeitbezug, Herkunft/Nachweis und Abgrenzung zu bestehenden App-Feldern. Luna- und Opus-Strukturen sind alternative Vorschläge; keine automatische Umbenennung.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_6-luna-high-20261002/workspace/rules/profile_changes.json:8–11`

```text
      "path": "o6_6",
      "value_after": {
        "application_year": "int",
        "measure_application_date": "date|null",
```

Ursprung: `runs/v2-o6_6-opus-5.5-high-20260925/workspace/rules/profile_changes.json:8–11`

```text
      "path": "farm.applicant",
      "value_before": null,
      "value_after": {
        "legal_form": "enum(natural_person|registered_partnership|legal_person|association|public_body)",
```

### o6_6-SOURCE_CONFLICT

Welche Vorgabe gilt beim vertauschten V1/V2-Anlagetermin, beim Walzen und bei mechanischer Beseitigung zwischen SRL und Merkblatt?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_6-opus-5.5-high-20260925/workspace/notes/assumptions.md:41–50`

```text
5. **Widerspruch in der AMA-Meldung vom 05.08.2026:** Dort steht, Variante „1 oder 2“ sei „bis 5. August bzw.
   10. August“ anzulegen. Das kehrt die Reihenfolge des Maßnahmenblatts um (V1: 10.08., V2: 05.08.). Maßgeblich
   bleiben Maßnahmenblatt und SRL; das Beispiel derselben Meldung (Variante 2 bis 5. August) bestätigt das.
6. **Walzen, SRL gegen Maßnahmenblatt:** Die SRL verbietet bei den Varianten 2–6 Walzen von der Anlage bis
   einschließlich 31.10. ohne Ausnahme. Das Maßnahmenblatt erlaubt das Anwalzen unmittelbar nach der Anlage und
   Walzen bei Frost, wenn die flächendeckende Begrünung erhalten bleibt. Übernommen wurden die Ausnahmen des
   Maßnahmenblatts. Rechtlich verbindlich ist die SRL; das bleibt offen.
7. **Mechanische Beseitigung und SRL:** Die SRL nennt als Methoden nur „Häckseln oder Einarbeiten“. Das Maßnahmenblatt
   erweitert die Liste (Direkt-/Mulchsaat, Abfrosten und Niederbrechen, Niederwalzen bei rein abfrostenden Mischungen
   der Varianten 1–5). Verwendet wurde die Liste des Maßnahmenblatts (`data/o6_6/management.json`).
```

### o6_6-VARIANTS_DATES

Wie zählen Anlage-/Umbruchtag, V1-Dauer und Folgejahr? Welche Pflege-, PSM- und Winterhärtepflichten gelten bei Variante 7 und Untersaaten?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_6-opus-5.5-high-20260925/workspace/notes/assumptions.md:29–40`

```text
1. **Ende des Begrünungszeitraums:** Die Spalte heißt „Ende des Begrünungszeitraums (frühester Umbruch am)“. Ein
   Umbruch am angegebenen Tag gilt daher als zulässig. Die Verbote (mineralischer N, PSM, Bodenbearbeitung) gelten
   im halboffenen Intervall [Anlagedatum, Ende).
2. **Variante 1 ab 2025:** Frühester Umbruch ist max(Anlagedatum + 70 Tage, 15.09.). Der Anlagetag zählt als
   Begrünungstag, der Umbruchtag nicht. Beide Beispiele im Maßnahmenblatt werden damit reproduziert
   (10.08. → 19.10.; 07.07. → 15.09.).
3. **Variante 6, Mischungspartner:** Die Tabelle nennt keine Mindestzahl („Kulturen oder deren Mischungen“). Die
   Reinsaat einer zulässigen Kultur wird daher akzeptiert (Minimum 1 Partner, 1 Familie).
4. **Variante 7, Pflege- und Walztermine:** Das Maßnahmenblatt nennt Termine nur für Variante 1 und die Varianten
   2–6, die SRL verbietet Pflege nur bei den Varianten 2–6. Für Variante 7 wird daher kein Pflegetermin geprüft. Das
   allgemeine PSM-Verbot und die Pflicht zur mechanischen Beseitigung gelten für Variante 7 nicht; das Verbot
   mineralischer N-Düngung gilt.
```

### o6_6-SEED_LIST

Welche aktuelle Sorten-/Saatgutquelle und Namensnormalisierung gelten für Grünschnittroggen, insektenblütige Partner und Winterraps? Luna/Opus behandeln spätere Sortenzulassungen unterschiedlich.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_6-opus-5.5-high-20260925/workspace/notes/assumptions.md:60–70`

```text
11. **Insektenblütige Pflanzen:** Die Liste im Maßnahmenblatt ist nur beispielhaft. Wenn
    `insect_pollinated_partner_count` angegeben ist, hat diese Zahl Vorrang. Sonst werden die angegebenen Arten mit
    der Beispielliste abgeglichen (exakte Namen). Arten außerhalb der Liste können trotzdem insektenblütig sein.
12. **Getreide/Mais:** Getreide wird nach der ÖPUL-Getreideliste erkannt, Mais über den Namensbestandteil „mais“.
    Einen reinen Getreide-/Maisbestand erkennt die Regel nur, wenn alle angegebenen Arten Getreide oder Mais sind. Der
    Anteil in Prozent ist eine eigene Eingabe.
13. **Grünschnittroggensorten:** Die Sortenlisten geben den Stand bei Erstellung des Maßnahmenblatts wieder (nicht
    abschließend: „laut Saatgutgesetz“). Später zugelassene Sorten lösen daher einen Verstoß aus, der manuell zu
    prüfen ist.
14. **Variante 7, Winterraps:** Geprüft wird über `crop.crop_name == "Winterraps"`. Abweichende Bezeichnungen im MFA
    werden nicht erkannt.
```

### o6_6-DROUGHT_EVIDENCE

Welche Nachweise bestätigen ordnungsgemäße Anlage und dürrebedingtes Ausfallgetreide 2026? Welche OP-Codes bewahren konkret die Prämienfähigkeit?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_6-opus-5.5-high-20260925/workspace/notes/assumptions.md:88–97`

```text
21. **Ernteverpflichtung und Dürre-Gebietskulisse 2026:** Für o6_6 wirkt beides nur als Hinweis (`advice`). Nach den
    Allgemeinen Teilnahmebedingungen 5.5.2 bleibt die o6_6-Prämie auf nicht abgeernteten Schlägen erhalten, wenn
    maßnahmenbezogene OP-Codes vergeben werden (nicht OP/OPZWF). Die Gebietskulisse ist vollständig in
    `data/o6_6/notices_2026.json` erfasst; der Bezirk kommt aus `farm.region.district`.
22. **Dürre 2026, Flächendeckung:** Die Ausnahme greift nur, wenn `properly_established == true`. Beim Ausfallgetreide
    über 50 % wird zusätzlich `cereal_share_from_volunteer == true` verlangt.
23. **Laufzeit der Varianten:** Die Tabellenzeilen gelten bis 2028, dem Ende der SRL-Laufzeit. Letzter Einstieg ist
    2027; die Weiterführung vorbeantragter einjähriger Maßnahmen im Jahr 2028 wird angenommen.
24. **Betriebsmindestgröße im 1. Jahr:** Näherung über `land.total_area_ha` für die landwirtschaftliche Fläche
    inklusive GA/K20/LSE.
```
