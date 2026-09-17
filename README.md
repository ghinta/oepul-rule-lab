# ÖPUL Rule Lab

Eine kleine, reproduzierbare Experimentierumgebung für die quellenbasierte
Generierung von ÖPUL-Regeln. Der Generator bekommt bewusst nur:

1. das Canonical Farm Profile,
2. die ausgewählten offiziellen ÖPUL-Quellen und
3. den Generierungsauftrag.

In `discover`-Läufen darf ein Agent das Profil erweitern, Felder ersetzen und
Rego samt Tests iterativ reparieren. Die Änderungen werden gemessen, nicht vorab
verboten. `conform`-Läufe verwenden später ein festes Profil.

## Schnellstart

```bash
python3 -m pip install -e .
python3 -m rulelab prepare --measure o6_1a --model config/models/codex-gpt-5.5.json
python3 -m rulelab run runs/<run-id>
python3 -m rulelab finalize runs/<run-id>
python3 -m rulelab compare runs/<run-a> runs/<run-b>
PYTHONPATH=src python3 -m unittest discover -s tests -v
```

Alternativ enthält `.devcontainer/` Python und die gepinnte OPA-Version. Ein
Modellwechsel benötigt beim gleichen Adapter nur eine zweite JSON-Datei unter
`config/models/` mit einem anderen `model`-Wert. Vorbereitet sind Konfigurationen
für `gpt-5.5`, `gpt-5.6-sol` und `gpt-6-astra`; ein externer Command-Adapter ist
ebenfalls dokumentiert.

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
auf PDF-Seiten zitieren kann. Die beiden Schemas für Regelkatalog und
Quellenbelege werden in jeden Workspace kopiert und im Prompt ausdrücklich als
verbindlich benannt. `run` startet den in der
Modellkonfiguration gewählten Adapter. `finalize` schreibt Profil-Diff,
verwendete `input`-Pfade und technische Kennzahlen nach `artifacts/`. Es prüft
außerdem die Kernstruktur beider JSON-Verträge, Quellenhashes, auflösbare
Artefaktpfade sowie OPA-Formatierung, Strict-Compile und Tests. Ein nur ähnlich
aussehendes älteres JSON-Format lässt den Lauf damit sichtbar fehlschlagen.

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

## Grundsatz

Compile-Erfolg und selbst erzeugte Tests sind technische Signale, keine
Behauptung fachlicher Korrektheit. Fachliche Bewertung, Hidden Tests und
Thesis-Konformität sind nachgelagerte Verbraucher der unveränderten
Run-Artefakte.
