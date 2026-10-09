# Expertenagenda aus Block 1–7

Die 26 Einzelprüfungen und sieben gemeinsamen Blöcke sind jetzt in zehn
Entscheidungsfamilien gebündelt. Die Domainexperten können gemeinsame Grundlagen
einmal beschreiben und Ausnahmen je Maßnahme festhalten. Eine Familie ist eine
Navigationshilfe: Eine Antwort gilt nur für ausdrücklich benannte Teilfragen,
Maßnahmen, Entitäten und Zeiträume. Nicht alle zehn Familien sind für jede Maßnahme
Voraussetzung.

Die 289 präzisierten und 129 ursprünglichen Fragen bleiben als **418 unterschiedliche
Frage-IDs offen**; die fünf UBB-IDs sind bereits in den 129 enthalten. Die acht
o6_3-Blocker bleiben zusätzlich vollständig mit `open_before_full_recommendation`
erhalten. Die Zahlen beschreiben Umfang, keine Qualität oder Vollständigkeit des
Rechts. `OPUS_REVISION` ist eine technische Artefaktprüfung, keine Expertenauslegung.

| Familie | Entscheidung | Originale / präzisierte Fragen |
| --- | --- | --- |
| [D01](decisions.md#d01) | Fachliche Zeiträume, Datenstand und Nachweisvollständigkeit | 5 / 4 |
| [D02](decisions.md#d02) | Flächenidentität, Geometrie und tatsächliche Mengenbasis | 5 / 19 |
| [D03](decisions.md#d03) | Maßnahmenspezifische Flächenanrechnung und Quoten | 17 / 23 |
| [D04](decisions.md#d04) | Tiere, Kategorien, Bestands- und Zeitbasis | 16 / 30 |
| [D05](decisions.md#d05) | Mittel, Futter, Dünger und Nährstoffgrößen | 22 / 33 |
| [D06](decisions.md#d06) | Bewirtschaftungsereignisse, Fristen und tatsächliche Nutzung | 15 / 50 |
| [D07](decisions.md#d07) | Projekt-, Rechts-, Anerkennungs- und Ausnahmewirkung | 25 / 37 |
| [D08](decisions.md#d08) | Personen, Kurse, Anträge und tatsächlicher Vertragszustand | 8 / 46 |
| [D09](decisions.md#d09) | Kombinationen, Zuschläge und tatsächliche Mehrfachanrechnung | 7 / 16 |
| [D10](decisions.md#d10) | Prämien, Kappung, Modulation, Sanktion und Zahlung | 9 / 31 |

Beginnen lässt sich mit D01/D02 und den tatsächlich benötigten Teilfragen der
ersten Maßnahme. Tiere, Materialien, Rechtsbelege und Personenbelege können
fachlich parallel geklärt werden. Flächenanrechnung, Kombination und Geld folgen
ihren jeweiligen bestätigten Mengen und Rechtsgrundlagen; Quellenaufnahme darf
bereits parallel laufen. Teilantworten ermöglichen kleine vollständige App-PRs.

## Bereits bestätigt

Aktuelles Jahr und ausgewählter aktueller Snapshot bilden die Auswertungsbasis,
einschließlich weiterhin gültiger älterer Belege. Dokumentierte Experten- und
Betreiberwerte gehen AMA vor; AMA-Abweichung allein blockiert sie nicht.
Auto-Werte sind zulässig, als `auto` und `dokumentiert` gekennzeichnet und werden
in einem eigenen Auto-Snapshot gespeichert. Die bestehende Arbeitskopie oder ein
EvaluationRun ersetzt dessen Implementierung nicht.

Fehlende Teilflächen und Agroforst-Elemente dürfen mit stabilen IDs und belegter
Feldstück-/Schlagzuordnung ergänzt werden. **„Neu angelegt – Experte / Betreiber /
Auto“** bleibt sichtbar, auch in Erklärung, Vergleich und Export. Die Herkunft
der Neuanlage bleibt getrennt von später überschriebenen Einzelwerten. Keine
amtliche ID wird erfunden. Dokumentierte Aggregate bleiben zulässig; erforderliche
fachliche Anrechnung, Kategorie oder Rechtswirkung muss getrennt belegt sein.
Eingabeherkunft ist keine automatische behördliche Anerkennung oder Auszahlung.
Zukunftsempfehlungen bleiben begründete Notizen. Individuelle Tierneuanlagen sind
eine gesonderte, noch offene Produktfrage.

## Arbeitsunterlagen

- [Entscheidungskarten mit verbleibenden Unterschieden](decisions.md)
- [Kurze Antwortvorlage für die Experten](answer-template.md)
- [Vollständiger Frageindex](question-index.md) und [maschinenlesbare Zuordnung](question-index.json)
- [Gemeinsame Erfassung, Ausnahmen und Umsetzungsschritte](implementation-plan.md)
- [Zusätzliche Restscopes](rest-scopes.md): fachliche Klärung, technische Quellenaufnahme und offene Produktfragen; keine 13 neuen ursprünglichen Frage-IDs
- [Prüfbarkeit](verification.md) und [kurze Begründung](reasons.md)

Das [Sammelissue App #140](https://github.com/ghinta/oepul-recommender/issues/140)
führt die Antworten. UBB bleibt in [Draft Lab #102](https://github.com/ghinta/oepul-rule-lab/pull/102),
die übrigen Einzelprüfungen und diese Agenda in [Draft Lab #103](https://github.com/ghinta/oepul-rule-lab/pull/103).
[App #133](https://github.com/ghinta/oepul-recommender/issues/133) bleibt der bereits
offene Fach-/GIS- und Pilotabhängigkeitsbereich; [App #141](https://github.com/ghinta/oepul-recommender/issues/141)
führt den Quellenrecherche-Subtask. Die Agenda beantwortet oder schließt keines
dieser Issues. Beide Drafts bleiben offen; Merge benötigt gesonderte Freigabe.
App, Thesis, historische Modellläufe und deren Quellen werden hier nicht verändert.
