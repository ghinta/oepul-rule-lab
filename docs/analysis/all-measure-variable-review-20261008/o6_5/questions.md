# o6_5: offene Fachentscheidungen

Alle Antworten und App-Zuordnungen bleiben offen. Die Zitate sind Modellnotizen bzw. Prüfbeobachtungen, keine bestätigte Fachauslegung.

### o6_5-INPUT_CONTRACT

Welche der im Diff einzeln gelisteten Eingaben werden fachlich benötigt und aufgenommen? Für jede: verbindlicher Name, Betrieb/Schlag/Tier/Gruppe/Projekt, Einheit, Zeitbezug, Herkunft/Nachweis und Abgrenzung zu bestehenden App-Feldern. Luna- und Opus-Strukturen sind alternative Vorschläge; keine automatische Umbenennung.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_5-luna-high-20261002/workspace/rules/profile_changes.json:8–11`

```text
      "path": "farm.application_date",
      "value_after": "date",
      "rationale": "Für die fristgerechte Beantragung der Maßnahme ist neben dem im Canonical Farm Profile vorhandenen Förderjahr das Datum der Maßnahmenbeantragung erforderlich.",
      "rule_ids": ["o65-039"],
```

Ursprung: `runs/v2-o6_5-opus-5.5-high-20260925/workspace/rules/profile_changes.json:8–11`

```text
      "path": "livestock.endangered_breed_animals",
      "value_before": null,
      "value_after": [
        {
```

### o6_5-BREEDING

Bedeutet mindestens jeder zweite Wurf reinrassig einen 50-%-Anteil oder eine Reihenfolgeregel? Welche Einzelereignisse und Abfohldaten müssen gespeichert werden?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_5-opus-5.5-high-20260925/workspace/notes/assumptions.md:27–47`

```text
- **A-04 Bezugsdatum für Ersatztiere.** Laut SRL 2.5 müssen Ersatztiere „alle
  Förderverpflichtungen zum Zeitpunkt der Nachbesetzung“ erfüllen. Geprüft wird daher
  zum späteren der beiden Zeitpunkte: Stichtag 01.04. bzw. 31.05. oder Nachbesetzungsdatum
  (`requirement_ref_ns`).
- **A-05 „Mindestens jeder 2. Wurf reinrassig“.** Ausgelegt als: Anteil reinrassiger Würfe
  mindestens 50 % aller Würfe (`litters_purebred >= 0,5 * litters_total`). Eine strengere
  Lesart („keine zwei aufeinanderfolgenden nicht reinrassigen Würfe“) ist möglich, lässt
  sich mit den vorhandenen Eingaben aber nicht abbilden. **Offen.**
- **A-06 Abfohlintervall 3,5 Jahre.** Geprüft wird, ob zum 31.05. des Antragsjahres
  (bzw. zum Nachbesetzungsdatum) höchstens 42 Monate seit der letzten Abfohlung vergangen
  sind. Fehlt `last_foaling_date`, wird `first_offspring_date` verwendet.
- **A-07 Altersgrenzen.** Monatsarithmetik mit `time.add_date`; eine Geburt am selben
  Kalendertag gilt als erreichtes Alter. „Älter als 5 Jahre“ beim Hengst ist strikt
  auszulegen (> 5 Jahre).
- **A-08 Jährlicher Zuchteinsatz.** Die Ausnahme „im Jahr der Zulassung zur Zucht“ wird
  über `breeding_approval_year == farm.year` abgebildet. Für Zuchthengste verlangt die
  Tabelle keinen jährlichen Zuchteinsatz, nur einen regelmäßigen sowie den Nachweis eines
  Nachkommen ab 5 Jahren.
- **A-09 Zuchtbuch/Herdebuch.** Das Informationsblatt spricht von „Zuchtbuch“, die SRL beim
  Hengst von „Herdebuch“. Beide Begriffe werden gleichgesetzt.

```

### o6_5-REPLACEMENT

Welche Nachbesetzungspflicht gilt nach 31.08.2026 und über wie viele Ersatztiere muss die Kette geprüft werden? Gilt die Fünf-Wochen-Frist auch für Rinder?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_5-opus-5.5-high-20260925/workspace/notes/assumptions.md:50–70`

```text
- **A-10 Abgang am letzten Tag.** Ein Abgang am letzten Tag der Haltedauer (31.12. bzw.
  2026: 31.08.) zählt als Abgang innerhalb der Haltedauer, weil die Haltung „bis
  einschließlich“ dieses Tages verlangt ist.
- **A-11 Fünf-Wochen-Frist.** Die Frist beträgt 35 Kalendertage ab dem Abgangstag.
  Das Beispiel im Informationsblatt (20.12.2023 → 24.01.2024) bestätigt diese Rechnung;
  es ist als Test hinterlegt.
- **A-12 Rinder nach dem 30.09.** „Nach dem 30. September“ heißt ab 01.10. Als Weitergabe
  gelten `departure.reason` `sale` oder `transfer`. Eine Nachbesetzung ist dann nicht nötig,
  sofern das Tier vor dem 01.01. des Folgejahres weder exportiert noch geschlachtet wird
  noch verendet.
- **A-13 Nachbesetzungsketten.** Ausgewertet wird bis zur zweiten Ebene
  (beantragtes Tier → Ersatztier → Ersatztier des Ersatztiers). Längere Ketten sind
  wegen des Rekursionsverbots in Rego nicht abgebildet. **Offen/technisch.**
- **A-14 Geringere Prämie bei Nachbesetzung.** Das Informationsblatt nennt zwei Fälle
  (weiblich → männlich, mit MLK → ohne MLK). Umgesetzt ist allgemein das Minimum aus den
  Prämien des beantragten Tieres und der herangezogenen Ersatztiere. Bei gleicher Rasse
  unterscheiden sich die Prämien nur nach Kategorie und MLK. Diese Lösung deckt daher die
  genannten Fälle ab und zahlt in den übrigen Fällen nie mehr als für das beantragte Tier.
  **Auslegung.**
- **A-15 Weitergabe ohne Vorabmeldung.** Die Grenzen 6 Monate (Zuchtstation) bzw. 3 Monate
  (männliche Tiere) werden als Haltebedingung geprüft; Überschreitung heißt, das Tier ist
```

Ursprung: `runs/v2-o6_5-opus-5.5-high-20260925/workspace/notes/assumptions.md:88–92`

```text
- **A-19 Haltedauer 2026.** Die Festlegung „Haltedauer bis einschließlich 31. August“ steht
  in `data/o6_5/general.json#/year_specific_overrides`. Daraus folgt, dass bei Abgang ab
  01.09.2026 weder eine Nachbesetzung noch eine Nachbesetzungsmeldung nötig ist. Abgänge
  sind aber weiterhin bis Jahresende zu melden.
- **A-20 Höhere Gewalt (Trockenheit).** Der allgemeine Hinweis zu Ansuchen auf höhere Gewalt
```

Ursprung: `runs/v2-o6_5-luna-high-20261002/workspace/notes/assumptions.md:3–6`

```text
- Die Maßnahmenblätter sind als ausführliche AMA-Aufbereitung gekennzeichnet; die rechtlich verbindliche Grundlage ist die Sonderrichtlinie. Widersprüche wurden zugunsten der Sonderrichtlinie beziehungsweise des ausdrücklich späteren 2026-Hinweises behandelt.
- Die 2026-Ausnahme wird für `input.year == 2026` als Haltedatum 31.08. modelliert. Tierbewegungsmeldungen für Nicht-Rinder bleiben bis 31.12. relevant; eine Nachbesetzungsmeldung nach 31.08. wird nicht verlangt. Die genaue fachliche Abgrenzung, ob eine Nachbesetzung nach dem verkürzten Haltungszeitraum überhaupt noch verlangt wird, ist im Hinweis sprachlich nicht weiter ausdifferenziert und bleibt als offene Auslegungsfrage dokumentiert.
- Datumsarithmetik wird in der Rego-Schnittstelle als bereits berechnetes Feld `days_until_replacement` beziehungsweise `reported_within_days` erwartet. Das vermeidet eine nicht durch die Quellen belegte Kalenderarithmetik im Regelwerk.
- Der 2026-Hinweis spricht von Tierbewegungsmeldungen bis Jahresende, während das Maßnahmenblatt die 7-Tage-Abgangsmeldung an die vorgeschriebene Haltedauer knüpft. Die ausführbare Regel erhält deshalb für Nicht-Rinder eine Meldung bei dokumentiertem Abgang bis zum Jahresende und führt die 7-Tage-Frist als eigenes Prüffeld.
```

### o6_5-REPORTING

Welche Folgen hat fehlende Vorabmeldung oder verspätete Abgangs-/Nachbesetzungsmeldung? Welche tierbezogene Meldung vom 02.09.2026 muss ergänzt werden?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_5-opus-5.5-high-20260925/workspace/notes/assumptions.md:71–81`

```text
  nicht förderbar. Fehlt nur die Vorabmeldung, wird ein Befund ausgegeben
  (`O6_5-REP-PRIOR-TRANSFER-REPORT`), die Förderbarkeit bleibt aber erhalten. Die SRL
  („Vor der Weitergabe hat eine Meldung … zu erfolgen“) lässt auch die strengere Lesart zu.
  **Offen.**
- **A-16 Kurzaufenthalte bis 10 Tage.** Geprüft wird `end_date - start_date <= 10`
  (Kalendertage laut SRL, „Tage“ laut Informationsblatt). Der Aufenthalt muss belegt sein
  (`documented`). Längere Aufenthalte bei Leistungsprüfungen, Tierzucht- oder
  Sportveranstaltungen sind keine zulässige Weitergabe.
- **A-17 Verspätete Meldungen.** Abgangs- und Nachbesetzungsmeldungen nach mehr als 7 Tagen
  erzeugen Befunde (`findings`). Laut Informationsblatt „kann“ das bei Vor-Ort-Kontrollen zu
  Beanstandungen führen; die Höhe einer allfälligen Sanktion ist in den Quellen nicht
```

Ursprung: `runs/v2-o6_5-opus-5.5-high-20260925/workspace/notes/assumptions.md:96–99`

```text
  ÖPUL-Maßnahmen“ (02.09.2026) erscheint nur als Kurztext in der Seitenleiste; der
  vollständige Hinweis ist nicht im Quellpaket. Der Teaser stützt lediglich
  O6_5-REP-DEPARTURE-7-DAYS.

```

### o6_5-EXPLICIT_CONFIRMATIONS

Darf Bestätigung ohne Datum als fristgerecht gelten? Braucht GEP die jährliche Verbandsbestätigung? Welche AMA-Genehmigung ist bei Wiedereinstieg erforderlich?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_5-opus-5.5-high-20260925/workspace/notes/assumptions.md:128–135`

```text
- **A-30 Wiedereinstieg nach Erlöschen.** Möglich über einen neuen Maßnahmenantrag bis
  31.12. des Vorjahres oder über Korrektur plus schriftliches Ersuchen. Die Genehmigung des
  Ersuchens durch die AMA wird unterstellt, sobald beides vorliegt.
- **A-31 GEP-Zuschlag.** Der Zuschlag wird gewährt, wenn die Rasse in Anhang D als „ja“
  (besonderes GEP) gekennzeichnet ist. Ob der Zuchtverband das Programm im jeweiligen Jahr
  tatsächlich umsetzt, ist nicht als Eingabe modelliert. **Offen.**
- **A-32 Bestätigung der Zuchtorganisation ohne Datum.** Status `confirmed` ohne Datum gilt
  als fristgerecht.
```
