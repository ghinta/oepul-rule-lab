# ÖPUL Rule Lab

Eine kleine, reproduzierbare Experimentierumgebung für die quellenbasierte
Generierung von ÖPUL-Regeln. Der Generator bekommt bewusst nur:

1. das Canonical Farm Profile,
2. die ausgewählten offiziellen ÖPUL-Quellen und
3. den Generierungsauftrag.

In `discover`-Läufen darf ein Agent neue Profilfelder vorschlagen und Rego samt
Tests iterativ reparieren. Das Arbeitsprofil selbst bleibt unverändert:
Vorschläge werden erst nach Pydantic-, Quellen- und Cross-Link-Prüfung auf eine
separate Profilkopie angewendet. `conform`-Läufe erlauben keine Vorschläge.

## Schnellstart

```bash
python3 -m pip install -e .
python3 -m rulelab prepare --measure o6_1a --model config/models/codex-gpt-5.5.json
python3 -m rulelab run runs/<run-id>
python3 -m rulelab verify-grounding runs/<run-id>
python3 -m rulelab finalize runs/<run-id>
python3 -m rulelab compare runs/<run-a> runs/<run-b>
PYTHONPATH=src python3 -m unittest discover -s tests -v
```

Alternativ enthält `.devcontainer/` Python und die gepinnte OPA-Version. Ein
Modellwechsel benötigt beim gleichen Adapter nur eine zweite JSON-Datei unter
`config/models/` mit einem anderen `model`-Wert. Vorbereitet sind Konfigurationen
für `gpt-5.5`, `gpt-5.6-luna`, `gpt-5.6-terra`, `gpt-5.6-sol` und
`gpt-6-astra` (Adapter `codex-cli`) sowie für `claude-opus-5-5` mit Effort
`high` (Adapter `claude-cli`, `config/models/claude-opus-5.5.json`); ein
externer Command-Adapter ist ebenfalls dokumentiert.

Modell, Anbieter, Adapter und Reasoning-Effort stehen in jedem Run in
`model.json` und `run.json` (`model`) sowie in der tatsächlichen
`invocation`. Run-IDs benennen Maßnahme, Modell und Effort, z. B.
`v2-o6_4-opus-5.5-high-20260925`.

### Claude-Adapter

`claude-cli` startet Claude Code headless (`claude -p`) im Run-Workspace.
Dateiänderungen werden nur innerhalb des Workspace automatisch akzeptiert;
alles, was eine interaktive Freigabe bräuchte, wird verweigert. Web-Zugriff,
`git`, `gh`, `curl`, `wget` und `docker` sind gesperrt, MCP-Server sowie
Benutzer- und Projekteinstellungen werden nicht geladen. `CLAUDE*`-Variablen
einer umgebenden Claude-Code-Sitzung sowie `GH_TOKEN`/`GITHUB_TOKEN` werden
nicht an den Generator vererbt. Wo der Login der lokalen `claude`-Installation
für Kindprozesse nicht sichtbar ist, kann `RULELAB_CLAUDE_OAUTH_TOKEN_FILE` auf
eine Token-Datei zeigen; das Token landet nie in Run-Metadaten.

`raw/events.jsonl` enthält den `stream-json`-Verlauf, `raw/final-message.md`
die Abschlussnachricht und `run.json` unter `generator_result` Turns, Dauer,
Token-Nutzung und Kosten. Die Sitzungs-ID steht in `generator_session_id`.

## Nutzungsgrenzen für Codex- und Claude-Läufe

Rule Lab prüft vor jedem `codex-cli`- und `claude-cli`-Run ausschließlich das
Fünf-Stunden-Fenster des jeweiligen Abos: bei Codex das primäre Fenster des
Codex App Servers, bei Claude das Fenster `five_hour`, gelesen über einen
minimalen werkzeuglosen `claude -p`-Aufruf mit einem kleinen Modell. Das
Wochenfenster ist bei beiden ausdrücklich kein Gate. Ein Run startet nur, wenn
im Fünf-Stunden-Fenster mindestens **50 %** verfügbar sind. Während eines Runs
wird dieser verbleibende Wert alle 30 Sekunden geprüft. Bei **5 % oder
weniger** wird der Generator kontrolliert beendet und der Run als
`aborted_usage_guard` protokolliert, statt bis zu einem harten Limitfehler zu
laufen. Meldet Claude für irgendein Fenster den Status `rejected`, gilt das als
0 % und führt ebenfalls zum kontrollierten Stopp. Sind die Limits nicht lesbar,
startet der Run aus Sicherheitsgründen nicht.

Ein Claude-Run wird dabei mit SIGINT wie eine Benutzerunterbrechung beendet.
Workspace und Sitzungsverlauf bleiben erhalten; `run.json` nennt unter
`usage_guard.resume` den Befehl zum Fortsetzen. Danach wird der Run entweder
später fortgesetzt oder mit dem vorhandenen Stand finalisiert:

```bash
python3 -m rulelab run runs/<run-id> --resume   # gleiche Claude-Sitzung fortsetzen
python3 -m rulelab finalize runs/<run-id>       # oder vorhandenen Stand prüfen
```

`--resume` eignet sich auch nach einem fehlgeschlagenen `finalize`: Die
Fortsetzungsanweisung enthält dann die abgelehnten Grounding-Prüfungen und
fehlenden Ausgaben aus `artifacts/`, weil der Generator-Workspace diese
Prüfungen selbst nicht enthält. Jede Fortsetzung zählt als neuer
`generation_attempt` und steht in `resumed_attempts`.

## Quellen aktualisieren

```bash
python3 sources/oepul/manage_sources.py update
python3 sources/oepul/manage_sources.py validate --check-index
```

Der aktuelle Abruf umfasst 27/27 AMA-Kernmerkblätter. Davon tragen elf einen
echten Stand 2026 (zehnmal April, einmal Juni); bei 16 Dokumenten verlinkt die
AMA weiterhin Stand Oktober 2025. Zusätzlich enthält der Pack die aktuell
verlinkte Sonderrichtlinie samt Anhängen und vier amtliche Hinweise zu
Ausnahmen im Antragsjahr 2026. Die tatsächlichen Dokumentstände bleiben im
Manifest sichtbar und werden niemals nur zur Vereinheitlichung umbenannt.

`prepare` legt einen isolierten Arbeitsbereich an und erzeugt für jedes PDF eine
seitenmarkierte Textfassung, damit der Agent systematisch suchen und trotzdem
auf PDF-Seiten zitieren kann. Fünf aus Pydantic-Modellen erzeugte Schemas für
Regeln, Quellenbelege, Profilvorschläge, Quellenabdeckung und Datentabellen
werden in jeden Workspace kopiert und im Prompt ausdrücklich als verbindlich
benannt. `run` startet den in der
Modellkonfiguration gewählten Adapter. `finalize` schreibt Profil-Diff,
verwendete `input`-Pfade und technische Kennzahlen nach `artifacts/`. Es prüft
außerdem strikt verbotene Zusatzfelder, Cross-Links, Quellen- und Datenhashes,
wörtliche Belege auf der zitierten Seite, Abdeckung, Tabellenzeilenzahlen,
Profiländerungsvoraussetzungen, die Existenz aller Regel- und Rego-Eingabepfade
im vorgeschlagenen Profil sowie OPA-Formatierung, Strict-Compile und Tests.
Erfundene oder nur ähnlich strukturierte Angaben lassen den Lauf sichtbar
fehlschlagen.

Vor dem Modellstart stellt `run` zusätzlich die exakt gepinnte OPA-Binary im
isolierten Workspace unter `tools/opa` bereit. Vorhandene lokale Binaries werden
nur bei passender Version übernommen; andernfalls wird ein plattformspezifisches
Artefakt anhand der eingecheckten SHA-256-Prüfsumme verifiziert und gecacht.
Damit kann der Generator Formatierung, Strict-Compile und Tests selbst iterativ
ausführen, ohne Zugriff auf den Docker-Socket oder ein breiteres Sandbox-Profil.

`verify-grounding` führt die deterministischen Pydantic-, Quellen-, Coverage-,
Daten- und Profilprüfungen read-only aus. So kann ein zweiter Agent oder ein
Review-Schritt dieselben Gates wiederholen, ohne Run-Artefakte zu verändern.

Die Details und Grenzen dieser Härtung stehen in
[`docs/grounding-validation.md`](docs/grounding-validation.md).

## Verzeichnisstruktur

```text
profiles/              Canonical Farm Profile als Ausgangsstand
sources/oepul/          aktualisierbare amtliche Quelldokumente und Manifest
prompts/                modellunabhängiger Generierungsauftrag
config/models/          austauschbare Modell-/Adapterkonfiguration
contracts/              JSON-Schemas der Konfiguration und Run-Artefakte
src/rulelab/            Prepare/Run/Finalize-CLI
runner/validation/      OPA fmt/check/test und technische Ergebnisse
runs/                   ignorierte Laufverzeichnisse
```

Die Dokumente in `sources/oepul/` sind kein eingefrorener Benchmark. Das
Update-Skript darf sie durch neuere amtliche Fassungen ergänzen bzw. ersetzen;
das Manifest hält Herkunft, Dokumentstand und Prüfsumme fest. Ein späterer
Benchmark kann einen konkreten Git-Commit referenzieren, ohne die Quelle im Lab
dauerhaft festzuschreiben.

Der erste technisch abgeschlossene UBB-Pilot ist bewusst als nicht fachlich
freigegebener Entwurf dokumentiert:
[`reports/draft-pilot-o6_1a-gpt55.md`](reports/draft-pilot-o6_1a-gpt55.md).
Der technisch validierte Terra-Discover-Lauf für den zuvor geparkten
Grundwasserschutz ist ebenfalls als Draft dokumentiert:
[`reports/draft-o6_16-gpt-5.6-terra.md`](reports/draft-o6_16-gpt-5.6-terra.md).

## Manuelle Adaptationen

`adaptations/o6_3/` enthält den quellengebundenen Heuwirtschaft-Kandidaten
für [Issue #97](https://github.com/ghinta/oepul-rule-lab/issues/97).
Die getrennte Lineage erhält die historischen Modell-Runs unverändert.
Prüfumfang, aktueller Datenvertrag und Grenzen stehen im
[Adaptations-README](adaptations/o6_3/README.md). Der Kandidat wird über
`python3 -m rulelab.heuwirtschaft` mit einem expliziten lokalen OPA geprüft;
eine App-Promotion erfolgt erst nach den dort genannten Abnahmen.

CI führt die Repository-Tests und die OPA-Gates aus. Lokal mit gepinntem OPA:

```bash
OPA_BIN=/absolute/path/to/opa PYTHONPATH=src python3 -m unittest discover -s tests -v
PYTHONPATH=src python3 -m unittest discover -s runner/validation/tests -v
```

## Grundsatz

Compile-Erfolg und selbst erzeugte Tests sind technische Signale, keine
Behauptung fachlicher Korrektheit. Fachliche Bewertung, Hidden Tests und
Thesis-Konformität sind nachgelagerte Verbraucher der unveränderten
Run-Artefakte.
