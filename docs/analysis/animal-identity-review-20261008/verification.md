# Verification · 08.10.2026

- **125 Originalzitate / 19 lokale Dateien:** SHA256 und wörtlicher Treffer auf
  der angegebenen physischen PDF-Seite beziehungsweise im sichtbaren lokalen
  HTML-Text geprüft. Keine unscharfe Bedeutungs-/Wortkorrektur verwendet.
- **49 App-Pfade / 75 Zeilenbelege / 25 Dateien:** Inhalt und Zeilenanker gegen
  App-Commit `5296108f5756ef1463c25a49d93d4a346e9b5e9c` geprüft. Dieser Commit
  war beim aktuellen GitHub-main-Abruf der Head. Der Prüfcheckout liefert für
  alle referenzierten Dateien dieselben Bytes.
- **15 Rechenscopes / 14 Maßnahmen / 65 vorhandene Frage-IDs:** Original- und
  Frageverweise vollständig aufgelöst. Alle 289 präzisierten Dossierfragen
  bytegleich gegenüber vorherigem Draft-Head `c10934e8…`, offen und unbeantwortet.
  Der vollständige Satz der acht vorhandenen o6_3-Blocker ist ebenfalls
  unverändert und `open_before_full_recommendation`.
- **Vier Original-Rechenbeispiele:** Weide-RGVE, zwei gemischte Rinderboxen und
  Schweine-Rotationsfläche mit Decimal nachgerechnet. 01.04.–31.10.2026
  einschließlich =214 Tage. Keine allgemeine Rundungsregel oder Golden-
  Erwartung aus diesen Beispielen abgeleitet.
- **Drei aktuelle AMA-Hinweise:** Datum, gezielt relevante Inhalte und kurze
  Zitate gegen offizielle Online-Seiten geprüft. Keine lokal erfassten
  Originalbytes oder SHA256 dieser drei Seiten behauptet. Aktuelle komplette
  SRL-/Anhang-Tierprüfung bleibt ausstehend.
- **Inventarvalidator:** 26 Maßnahmen / 52 Runs / 129 ursprüngliche offene
  Fragegruppen erhalten; bestehende App-Baseline-Pins geprüft.
- **Unabhängige Zweitprüfung:** Quellen-/Frage-/App-Verweise und Produktgrenzen
  geprüft. Auto-Wertänderungen sind bestätigt; nur neue Einzelidentitäten
  bleiben als zusätzliche Produktentscheidung offen.

Zählungen, Datei-Hashes und Decimal-Ergebnisse stehen in
[verification.json](verification.json). Lokale Markdownziele und
`git diff --check` wurden vor Veröffentlichung geprüft.

Die Belege können mit dem vorhandenen Originalquellenprüfer erneut geprüft
werden (Repository-Umgebung mit pypdf/pydantic):

```bash
PYTHONPATH=src:. python - <<'PY'
import hashlib, json
from pathlib import Path
from tools.review_o6_1c_variable_review import OriginalSources
folder = Path('docs/analysis/animal-identity-review-20261008')
checker = OriginalSources()
for item in json.loads((folder / 'evidence.json').read_text())['local_quotes']:
    assert hashlib.sha256(Path(item['source_path']).read_bytes()).hexdigest() == item['source_sha256']
    checker.check_quote(item, 'quote')
print('125 lokale Originalfundstellen geprüft')
PY
python tools/review_all_measure_variables.py
```

Die reguläre PR-CI prüft zusätzlich die vorhandenen Repository-/Validator-/
Originalquellen-/OPA-Checks am neuen Commit. Ihr Ergebnis wird am konkreten
Commit im PR und im Sammelissue verlinkt. Diese Dokumentationsprüfung liefert
keine neuen Modell-Runs, unabhängig bewerteten Golden-Fälle oder produktiven
App-E2E-Tests. Quellen, historische Runs, Policies, Canonical Farm Profile,
App und Thesis bleiben unverändert.
