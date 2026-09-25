# ÖPUL Rule Lab - Arbeitsauftrag für Generator-Agents

Dieses Repository dient der möglichst vollständigen Extraktion ausführbarer
Regeln aus den bereitgestellten ÖPUL-Quellen.

## Nutzungsgrenze (Codex und Claude)

Ein neuer Codex- oder Claude-Run darf nur mit mindestens 50 % Restbudget in
jedem Quotenfenster starten. Bei 5 % Restbudget oder weniger ist er
kontrolliert zu beenden und in einen sicheren, fortsetzbaren Zustand zu
bringen; ein harter Limitfehler darf nicht als normaler Abschluss behandelt
werden. Ein unterbrochener Run wird später fortgesetzt oder mit dem
vorhandenen Stand finalisiert.

## Prioritäten

1. Lies die bereitgestellten Quelldokumente vollständig, einschließlich
   Tabellen, Fußnoten, Definitionen, Ausnahmen, Optionen und Übergangsregeln.
2. Identifiziere jede normative oder entscheidungsrelevante Aussage und bilde
   sie als strukturierten Regel-Datensatz und, wo sinnvoll, als Rego ab.
3. Fehlt eine benötigte Eingabevariable, erfasse sie im `discover`-Modus als
   belegten Vorschlag in `rules/profile_changes.json`. Ändere das Canonical Farm
   Profile nie direkt. Überspringe eine Regel nicht allein deshalb, weil das
   Ausgangsprofil unvollständig ist. `value_after` muss dieselbe JSON-Notation
   wie das Canonical Farm Profile verwenden; Arrays werden als JSON-Array mit
   einem repräsentativen Objekt beschrieben, nicht als String `array<object>`.
4. Lange Tabellen und geschlossene Listen werden vollständig als Daten unter
   `data/` erfasst und von Rego referenziert. Größe allein ist kein Grund, eine
   Tabellenzeile, Art, Sorte, Prämienstufe oder Kombinationszelle wegzulassen.
5. Jede Regel muss auf Dokument, Seite, Abschnitt und einen kurzen wörtlichen
   Beleg zurückführen, der auf der angegebenen Seite maschinell auffindbar ist.
6. Erzeuge Rego v1, formatiere es und repariere Compile- bzw. Testfehler
   iterativ. Keine Platzhalterregeln, die eine fachliche Entscheidung vortäuschen.
7. Erhalte Mehrdeutigkeit als explizite Annahme oder offene Frage; sie darf die
   Extraktion der übrigen Regeln nicht blockieren.

## Erlaubte Änderungen im Run-Workspace

- `policy/**/*.rego`
- `data/**/*.json`
- `tests/**/*.rego`
- `rules/rules.json`
- `rules/citations.json`
- `rules/profile_changes.json`
- `rules/coverage.json`
- `rules/data_inventory.json`
- `notes/assumptions.md`

Ändere weder `canonical_farm_profile.json` noch Quelldokumente. Arbeite
ausschließlich im vorbereiteten Run-Workspace. Thesis-Konformität und spätere
Gold-/Hidden-Tests sind nicht Teil des Generierungsauftrags.

Der vorbereitete Workspace enthält den technischen Validator. Verwende ihn
während der Arbeit wiederholt:

```bash
python3 tools/opa_validate.py validate --workspace . --target policy --target data --target tests --write --result-json technical-validation.json --pretty
```

Eine zur Repository-Pin passende lokale OPA-Binary liegt unter `tools/opa`.
Der Validator verwendet sie automatisch. Führe die Prüfung selbst aus und
repariere Fehler iterativ; Docker-Zugriff ist dafür weder nötig noch erlaubt.

Der Generator startet mit einer expliziten lokalen OPA-Umgebung: `OPA_RUNTIME`
steht auf `local`, `OPA_BIN` zeigt auf `tools/opa`, und `tools/` ist im `PATH`.
Damit funktionieren sowohl `opa fmt/check/test ...` als auch der Validator
innerhalb des Modell-Sandboxes. Verwende keine Docker-Kommandos und verlasse
dich nicht auf eine hostweit installierte OPA-Version.
