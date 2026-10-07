# o6_19: offene Fachentscheidungen

Alle Antworten und App-Zuordnungen bleiben offen. Die Zitate sind Modellnotizen bzw. Prüfbeobachtungen, keine bestätigte Fachauslegung.

### o6_19-INPUT_CONTRACT

Welche der im Diff einzeln gelisteten Eingaben werden fachlich benötigt und aufgenommen? Für jede: verbindlicher Name, Betrieb/Schlag/Tier/Gruppe/Projekt, Einheit, Zeitbezug, Herkunft/Nachweis und Abgrenzung zu bestehenden App-Feldern. Luna- und Opus-Strukturen sind alternative Vorschläge; keine automatische Umbenennung.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_19-luna-high-20261005/workspace/rules/profile_changes.json:8–11`

```text
      "path": "measure.id",
      "value_before": null,
      "value_after": "o6_19",
      "rationale": "The canonical farm profile has no leaf input for measure.id; this discover-mode proposal exposes the source-required value without modifying the canonical profile.",
```

Ursprung: `runs/v2-o6_19-opus-5.5-high-20260927/workspace/rules/profile_changes.json:8–11`

```text
      "path": "land.parcels[].oepul.codes",
      "value_before": null,
      "value_after": [
        "string"
```

### o6_19-PROJECT_INDICATORS

Welche Indikatoren/$-Parameter, Habitatnamen und Vogelgruppenzuordnungen aus Anhang K gelten in der konkreten bestätigten Projektversion?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_19-luna-high-20261005/workspace/notes/assumptions.md:4–5`

```text
- Die Projektbestätigung ist die maßgebliche Quelle für die tatsächlich ausgewählten Indikatoren je Schlag. Anhang K ist deshalb als vollständiger Katalog und nicht als Behauptung modelliert, dass jeder Indikator auf jedem Schlag zugleich gilt.
- Die Platzhalter `$1`, `$2` und `$NEO` im extrahierten Anhang-K-Text sind projekt- bzw. lebensraumspezifische Parameter. Sie wurden nicht geraten oder durch Profilwerte ersetzt. Die Policy prüft daher die vom Projekt bestätigten Ergebnisfelder und nutzt die Tabelle als geschlossene Code-/Textliste.
```

Ursprung: `runs/v2-o6_19-opus-5.5-high-20260927/workspace/notes/assumptions.md:86–96`

```text
18. **0,15-ha-Feldstücksregel**: Das Merkblatt verlangt sie für den
    Gesamtbetriebs-Fall ohne Hinweis auf die UBB-Schwelle (ab 10 ha Acker bzw.
    gemähtem Grünland). Das Modell wendet sie wie im Merkblatt ohne diese
    Schwelle an. Die 7-%-Quote von UBB/BIO wird in o6_19 nicht berechnet.
19. **Kapitel 7 „Erhaltungszustände“**: Die Überschrift nennt Erhaltungszustände,
    die Liste enthält aber nur Lebensraumnamen. Die Anrechnung prüft daher nur
    Lebensraum und Schlagnutzungsart. Namen müssen exakt übereinstimmen (keine
    Zuordnung zu den Anhang-K-Prämienbezeichnungen).
20. **Anhang K Tier-Indikatoren**: Die Zuordnung von EBAT02–EBAT07 zu Vogelgruppen
    folgt der Zeilenlage der Textextraktion (Tabellenlayout mehrdeutig).
    EBGH07 ist in der Quelle abgeschnitten und verbatim übernommen.
```

### o6_19-SURCHARGE_CODES

Ist je Fläche nur EBBA01 oder EBBA02 erlaubt? Welche Koordinationsstellen-Bestätigung belegt EBBA-Gründe und die EBHG01/02-Zuordnung?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_19-opus-5.5-high-20260927/workspace/notes/assumptions.md:29–41`

```text
4. **EBBA01/EBBA02**: „kann nur einmal pro Fläche vergeben werden“ wird so gelesen,
   dass je Schlag höchstens ein EBBA-Code zulässig ist (EBBA02 als höhere Stufe
   statt zusätzlich zu EBBA01). EBBA02 nur bei Erhaltungszustand A („sehr gut“).
5. **EBBA-Gründe**: Einschränkungen der Entscheidungsliste wurden, soweit
   maschinell prüfbar, codiert (Erschwernis, Flächengröße, ausgeschlossene
   Lebensräume, Indikatorpräfixe, Erhaltungszustand, Schnittzahl, Vorjahres-Acker).
   Nicht prüfbar bleiben u. a. „regionaltypische Schnittzahl“, „Gunstlage“,
   NALA-Erfassung und die Entfernungsangaben (Eingabe über `ebba_reason_id` wird
   als Beurteilung der Koordinationsstelle übernommen).
6. **EBHG**: Die LRT-/Artenliste aus Anhang I Abschnitt H ist als Referenzumfang
   in `data/` erfasst; Rego prüft die Eignung über die Meldung der
   Landesdienststelle (`habitat_area_reported_in_gis`) und den Layer-Anteil ≥ 50 %.
   EBHG01 wird Grünland-, EBHG02 Ackerschlägen zugeordnet (analog HG01/HG02).
```

### o6_19-TWO_YEAR_CARE

Ersetzt die Zweijahrespflege für alle EBW-Flächen die jährliche Mindestbewirtschaftung oder nur für bestimmte Grünbrachen?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_19-opus-5.5-high-20260927/workspace/notes/assumptions.md:66–78`

```text
12. **Mindestbewirtschaftungskriterien vs. „jedes zweite Jahr“**: Die allgemeinen
    Kriterien (Grünland jährlich mähen/beweiden) gelten laut SRL 1.6.3, „sofern in
    der Maßnahmenbeschreibung keine abweichenden Bestimmungen festgelegt sind“.
    Die EBW verlangt Nutzung/Pflege „zumindest jedes zweite Jahr“ und nimmt
    Grünbrachen ausdrücklich aus. Ob die Zwei-Jahres-Regel für alle EBW-Flächen
    eine abweichende Bestimmung ist, bleibt offen (R-O619-GEN-MIN-MGMT-CRITERIA,
    nicht automatisiert). Nur die Ausnahme für EBW-Grünbrachen ist codiert.
13. **Mindestteilnahme ab Jahr 2** („zumindest ein Schlag“) wird als
    Zugangsvoraussetzung behandelt (Allgemeine Bedingungen 8.2 nennen
    „Mindestteilnahmeflächen“); die Folge ist „keine Prämie im betroffenen Jahr“.
14. **Weiterbildung**: Ein Verstoß wird erst nach dem 31.12.2026 festgestellt
    (Förderjahre > 2026). Merkblatt nennt „förderwerbende Person“, SRL
    „Betriebsführerin/Betriebsführer“; beides wird als `farm_manager` abgebildet.
```

### o6_19-DROUGHT_PROJECT

Welche Grünland-DIV-Ausnahme gilt für EBW, ohne NAT-Regeln analog zu übernehmen? Welche Projektbestätigung und tatsächliche Schlaglage sind nachzuweisen?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_19-opus-5.5-high-20260927/workspace/notes/assumptions.md:100–110`

```text
21. Die Ausnahme für Acker-Biodiversitätsflächen schließt EBW ausdrücklich aus
    (12.08.2026). Für Grünland-Biodiversitätsflächen nennt die Meldung vom
    22.05.2026 nur „Naturschutz“ als Beispiel für „andere Vorgaben“. Die
    Anwendung auf EBW ist eine Analogie (Projektbestätigung als andere Vorgabe).
22. Die Freigabe der Nutzungstermine ab 12.08.2026 nennt nur „Naturschutz“ und
    „Natura 2000“; für EBW wird **keine** Freigabe angenommen.
23. Die Dürre-Ausnahme zur Ernteverpflichtung gilt allgemein für ÖPUL-Ackerflächen.
    Für EBW-Ackerflächen setzt das Modell voraus, dass dort eine Ernteverpflichtung
    besteht (bewirtschaftete Äcker). Die Gebietskulisse wird über
    `farm.region.federal_state/district` geprüft (Betriebs-, nicht Schlagsitz;
    Bezirksnamen müssen exakt übereinstimmen).
```
