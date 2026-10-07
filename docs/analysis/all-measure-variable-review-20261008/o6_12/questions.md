# o6_12: offene Fachentscheidungen

Alle Antworten und App-Zuordnungen bleiben offen. Die Zitate sind Modellnotizen bzw. Prüfbeobachtungen, keine bestätigte Fachauslegung.

### o6_12-INPUT_CONTRACT

Welche der im Diff einzeln gelisteten Eingaben werden fachlich benötigt und aufgenommen? Für jede: verbindlicher Name, Betrieb/Schlag/Tier/Gruppe/Projekt, Einheit, Zeitbezug, Herkunft/Nachweis und Abgrenzung zu bestehenden App-Feldern. Luna- und Opus-Strukturen sind alternative Vorschläge; keine automatische Umbenennung.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_12-luna-high-20261003/workspace/rules/profile_changes.json:8–11`

```text
      "path": "farm.region.country",
      "value_after": "Austria",
      "rationale": "Die Förderfähigkeit der maßgeblichen Fläche hängt von ihrer Lage in Österreich ab.",
      "rule_ids": ["o612.general_location"],
```

Ursprung: `runs/v2-o6_12-opus-5.5-high-20260926/workspace/rules/profile_changes.json:8–11`

```text
      "path": "farm.applicant",
      "value_before": null,
      "value_after": {
        "person_type": "enum(natural_person|registered_partnership|legal_person|association|public_body)",
```

### o6_12-ORDER_YEAR

Welche behördliche Wirkstoff-Ausnahme und Uploadpflicht gelten je Jahr? Darf die 2026-Präzisierung rückwirkend für frühere Jahre verwendet werden?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_12-opus-5.5-high-20260926/workspace/notes/assumptions.md:36–46`

```text
3. **Behördlich angeordnete Bekämpfung vor 2026:** Laut SRL 2.12 ist der „behördlich
   zugelassene Wirkstoff“ zulässig. Die 2026-Meldung präzisiert: Chemisch-synthetische
   Mittel sind nur zulässig, wenn sie dezidiert angeordnet sind oder keine
   Bio-Wirkstoffe verfügbar sind. Diese präzisere Logik wird für alle Jahre angewendet
   (`order_covers_chemical_synthetic`). Ein angeordneter Einsatz mit einem Bio-Mittel
   ist immer zulässig.
4. **Upload/Übermittlung der Anordnung:** Das Maßnahmenblatt (Kap. 4.2) verlangt den
   Upload der Anordnung im Rahmen der PSM-Codierung, die bis 2025 gilt. Die Meldung
   vom 12.06.2026 sagt, dass keine Übermittlung an die AMA erforderlich ist. Umgesetzt:
   Upload nur, solange `psm_coding_required` gilt (≤ 2025). Die Dokumentation am Betrieb
   ist in allen Jahren verpflichtend.
```

### o6_12-EXPLICIT_APPROVAL

Welcher Nachweis bestätigt den genehmigten Rebzikaden-Ausstieg, wann endet der Vertrag und welche Schläge/Prämien umfasst er? Ein fehlendes approved darf keine Genehmigung ersetzen.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_12-opus-5.5-high-20260926/workspace/notes/assumptions.md:47–53`

```text
5. **Rebzikaden-Ausstieg 2026:** Die Meldung verlangt „Betriebe mit Weinflächen“. Es
   wird nur geprüft, ob mindestens ein Weinschlag vorhanden ist; das gilt auch für
   Schnittweingärten und Sonstige Weinflächen. Der Ausstieg gilt als genehmigt, wenn
   die formalen Voraussetzungen erfüllt sind und `approved` nicht ausdrücklich `false`
   ist. Die AMA-Genehmigung ist also als Eingabe modelliert. Keine Prämie wird nur für
   das Jahr der Meldung angenommen, in dem der Vertrag endet. Chemisch-synthetische
   Insektizideinsätze ab dem Meldedatum gelten nicht als Verstoß.
```

### o6_12-CROP_EXIT_SCOPE

Welche sonstigen Wein-/Spezialkulturflächen zählen zum Verzicht und zur Mindestteilnahme? Bedeutet vollständiger Flächenverlust Ausstieg?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_12-opus-5.5-high-20260926/workspace/notes/assumptions.md:24–35`

```text
1. **Sonstige Weinflächen und Mindestteilnahmefläche bzw. Verzicht:** Sonstige
   Weinflächen erhalten keine Prämie und sind nicht förderfähig. Angenommen wird: Sie
   zählen **nicht** zur Mindestteilnahmefläche von 0,50 ha, sind als Weinfläche des
   Betriebes aber **vom Insektizidverzicht erfasst**. Das ist die vorsichtige
   Auslegung von „gesamte Wein-, Obst- und Hopfenfläche des Betriebes“. Sonstige
   Spezialkulturflächen gelten nicht als WOH-Fläche.
2. **Flächenabgangs-Toleranz (5 % / 5 ha / 0,5 ha):** Nach SRL 1.7.2.5 sind die Flächen
   der Maßnahme 12 an die jährlich verfügbaren WOH-Flächen gebunden. Die Toleranz nach
   1.7.2.3 wird für Maßnahme 12 daher nicht angewendet. Sie ist als Funktion
   (`area_reduction_tolerance_ha`) umgesetzt, und `area_reduction_repayment_ha` bleibt
   bei jährlich gebundenen Maßnahmen undefiniert. Ob ein vollständiger Verlust aller
   WOH-Flächen als Ausstieg gilt, bleibt offen.
```
