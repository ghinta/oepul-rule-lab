---
description: AMA-Quellen aktualisieren, validieren und Opus-5.5-Reruns für betroffene Maßnahmen durchführen und veröffentlichen
argument-hint: "[Maßnahmen, Standard: o6_9 o6_16 o6_24 o6_21 o6_22]"
---

# Quellen-Update und Opus-5.5-Reruns

Maßnahmen für die Reruns: `$ARGUMENTS`. Wenn leer, in dieser Reihenfolge:
`o6_9 o6_16 o6_24 o6_21 o6_22`.

Arbeite im Repo `oepul-rule-lab` auf dem Branch `claude/serene-cray-pxlyc3`
(PR ghinta/oepul-rule-lab#79). Antworten auf Deutsch, kurz. Erfinde nichts:
Quellen, Stände und Kennzahlen kommen nur aus Dateien und Befehlsausgaben.

## Harte Regeln

- Quelldateien unter `sources/oepul/` nie von Hand ändern, umbenennen oder
  löschen. Nur `manage_sources.py` schreibt dort.
- Bricht `update` wegen einer Byte-Kollision ab oder schlägt `validate` fehl:
  **stoppen**, Fehlermeldung und Ursache berichten, nichts umgehen.
- Runs strikt nacheinander, nie parallel. Diese Sitzung und der Generator
  teilen sich das Claude-Limit.
- `rulelab run` dauert bis zu 2 h: immer im Hintergrund starten
  (`run_in_background`) und auf das Ende warten, nicht mit `sleep` pollen.
- Endet ein Run mit `aborted_usage_guard`: nicht neu starten, sondern den
  Fortsetzungsbefehl aus `run.json` (`usage_guard.resume`) berichten und
  aufhören.
- Ein Run, der nach einem `--resume` noch immer nicht finalisiert ist, wird
  nicht veröffentlicht.
- Nichts mit `--skip-validation` finalisieren.

## 1. Vorbereitung

```bash
git status --short            # muss sauber sein, sonst stoppen und berichten
git fetch origin claude/serene-cray-pxlyc3
git checkout claude/serene-cray-pxlyc3
git pull origin claude/serene-cray-pxlyc3
python3 -m pip install -e . pypdf   # falls rulelab/pypdf fehlen
make test
```

## 2. Quellen aktualisieren und prüfen

```bash
python3 sources/oepul/manage_sources.py update
python3 sources/oepul/manage_sources.py validate --check-index
make source-validate
```

Danach den Delta prüfen und kurz zusammenfassen:

- `git status --short sources/oepul/` und `git diff --stat sources/oepul/manifest.json`
- Neue Dateien unter `originals/`, `legal/`, `notices/2026/` auflisten, jeweils
  mit gedrucktem Stand aus dem Manifest.
- Für jede neue Rechts- und Meldungsquelle `applies_to_measures` aus dem
  Manifest nennen.
- Prüfen, dass GSP-AV, NAPV und das Grundwasserschutzprogramm Graz bis
  Bad Radkersburg im Manifest stehen. Fehlt eine, stoppen und berichten.

Commit (nur `sources/oepul/`):

```bash
git add sources/oepul
git commit -m "data: refresh AMA source pack (legal sources and 2026 notices)"
```

## 3. Reruns, je Maßnahme `<m>`

Run-ID: `v2-<m>-opus-5.5-high-$(date +%Y%m%d)`. Existiert das Verzeichnis
schon, `-b` anhängen.

```bash
python3 -m rulelab prepare --measure <m> --model config/models/claude-opus-5.5.json --run-id <run-id>
```

Vor dem Start prüfen: `runs/<run-id>/run.json` → `sources` muss das
maßnahmenspezifische Merkblatt, die Teilnahmebedingungen und die neuen, für
`<m>` gescopten Rechtsquellen/Meldungen enthalten. Fremd gescopte Quellen
dürfen nicht drin sein. Abweichung: stoppen und berichten.

```bash
python3 -m rulelab run runs/<run-id>                # im Hintergrund
python3 -m rulelab verify-grounding runs/<run-id>
python3 -m rulelab finalize runs/<run-id>
```

Schlägt `finalize` fehl: genau einmal
`python3 -m rulelab run runs/<run-id> --resume` und erneut `finalize`.

Vergleich mit dem bisherigen Opus-Run derselben Maßnahme (neuester
`runs/v2-<m>-opus-5.5-high-*` vor diesem):

```bash
python3 -m rulelab compare runs/<alter-run> runs/<run-id> --output runs/<run-id>/artifacts/compare-previous.json
```

`runs/<run-id>/README.md` nach dem Muster von
`runs/v2-o6_16-opus-5.5-high-20261002/README.md` schreiben (Status DRAFT, Lauf,
Ergebnis-Tabelle aus `artifacts/metrics.json` und `run.json`). Zusätzlich ein
Abschnitt „Änderung gegenüber `<alter-run>`“: neue Quellen, Regeln/Belege
vorher → nachher, welche offenen Coverage-Einträge (`unresolved`) jetzt
geschlossen oder neu sind.

Veröffentlichen (Workspace-Quellen, Tools und Schemas bleiben lokal):

```bash
R=runs/<run-id>
git add -f $R/README.md $R/run.json $R/model.json $R/prompt.md $R/baseline_profile.json \
  $R/artifacts $R/workspace/data $R/workspace/notes $R/workspace/policy \
  $R/workspace/rules $R/workspace/tests
git commit -m "data: publish finalized <m> Opus 5.5 high rerun with refreshed sources"
```

Dann mit der nächsten Maßnahme weiter.

## 4. Seite, Bericht, Push

```bash
python3 -m rulelab site
make site-check
make test
```

In `reports/opus-5.5-vs-terra-high-comparison.md` einen kurzen Abschnitt
„Reruns mit aktualisierten Quellen“ ergänzen: Tabelle je Maßnahme mit alter und
neuer Run-ID, Regeln, Belege, offene Coverage-Einträge vorher → nachher.

```bash
git add docs/assets/data.js reports/opus-5.5-vs-terra-high-comparison.md
git commit -m "docs: add source-refresh reruns to run explorer and comparison"
git push -u origin claude/serene-cray-pxlyc3
```

## 5. Abschlussbericht

Kurz, als Tabelle: Maßnahme, Run-ID, Status (veröffentlicht / Limit-Abbruch /
finalize fehlgeschlagen), Regeln und offene Coverage-Einträge vorher → nachher,
Kosten laut `run.json`. Danach offene Punkte und nicht abgeschlossene Runs mit
ihrem Fortsetzungsbefehl.
