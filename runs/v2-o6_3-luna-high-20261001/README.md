# ÖPUL Rule Lab: o6_3 / gpt-5.6-luna (high)

Dieser Discover-Run extrahiert Regeln zur Maßnahme **Heuwirtschaft** (`o6_3`)
aus den im Run festgehaltenen Quellen. Er ist ein technisch validierter Entwurf
und keine fachliche Freigabe.

## Ergebnis

- 29 strukturierte Regeln und 35 Quellenbelege
- 42 Einträge im Coverage Ledger
- 5 generierte OPA-Tests; technischer Validator erfolgreich
- 23 belegte Vorschläge für Profilergänzungen; das Canonical Farm Profile
  wurde nicht verändert
- 1 Datendatei mit 7 inventarisierten Tabellen
- unabhängige Grounding-Validierung ohne Fehler

## Usage Guard

Der finale, begrenzte Korrekturlauf startete bei 98 % Restbudget. Die
Stoppschwelle von 5 % wurde nicht erreicht; es wurden keine Reset-Credits
verwendet.

## Nachträgliche Finalisierung

Am 7. Oktober 2026 wurde der reguläre Finalizer nach Wiederherstellung des
unveränderten Generatorlogs aus PR #95 erneut ausgeführt. Status und Metriken
in `run.json` sowie Inventar und technischer Prüfbericht entsprechen diesem
erfolgreichen Abschluss. Es wurde kein neuer Modelllauf gestartet; Regeln,
Belege, Daten und Tests wurden nicht geändert. Der Explorer-Eintrag stimmt
bereits mit den finalisierten Metriken überein.

Die veröffentlichten Dateien enthalten die nachvollziehbaren Run-Artefakte
und das ursprüngliche Generatorlog unter `raw/events.jsonl`. Quelldokumente
und Arbeitswerkzeuge sind nicht Teil dieses Exports.
