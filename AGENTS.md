# ÖPUL Rule Lab - Arbeitsauftrag für Generator-Agents

Dieses Repository dient der möglichst vollständigen Extraktion ausführbarer
Regeln aus den bereitgestellten ÖPUL-Quellen.

## Prioritäten

1. Lies die bereitgestellten Quelldokumente vollständig, einschließlich
   Tabellen, Fußnoten, Definitionen, Ausnahmen, Optionen und Übergangsregeln.
2. Identifiziere jede normative oder entscheidungsrelevante Aussage und bilde
   sie als strukturierten Regel-Datensatz und, wo sinnvoll, als Rego ab.
3. Fehlt eine benötigte Eingabevariable, erweitere im `discover`-Modus das
   Canonical Farm Profile. Überspringe eine Regel nicht allein deshalb, weil das
   Ausgangsprofil unvollständig ist.
4. Lange Tabellen und geschlossene Listen werden vollständig als Daten unter
   `data/` erfasst und von Rego referenziert. Größe allein ist kein Grund, eine
   Tabellenzeile, Art, Sorte, Prämienstufe oder Kombinationszelle wegzulassen.
5. Jede Regel muss auf Dokument, Seite, Abschnitt und möglichst eine kurze
   Quellenstelle zurückführen.
6. Erzeuge Rego v1, formatiere es und repariere Compile- bzw. Testfehler
   iterativ. Keine Platzhalterregeln, die eine fachliche Entscheidung vortäuschen.
7. Erhalte Mehrdeutigkeit als explizite Annahme oder offene Frage; sie darf die
   Extraktion der übrigen Regeln nicht blockieren.

## Erlaubte Änderungen im Run-Workspace

- `canonical_farm_profile.json`
- `policy/**/*.rego`
- `data/**/*.json`
- `tests/**/*.rego`
- `rules/rules.json`
- `rules/citations.json`
- `notes/assumptions.md`

Ändere keine Quelldokumente. Arbeite ausschließlich im vorbereiteten
Run-Workspace. Thesis-Konformität und spätere Gold-/Hidden-Tests sind nicht Teil
des Generierungsauftrags.

Der vorbereitete Workspace enthält den technischen Validator. Verwende ihn
während der Arbeit wiederholt:

```bash
python3 tools/opa_validate.py validate --workspace . --target policy --target tests --write --result-json technical-validation.json --pretty
```
