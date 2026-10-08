# Verification · 08.10.2026

- **355 unterschiedliche Originalzitate / 30 lokale Quellen:** wörtlicher
  Treffer an der angegebenen physischen PDF-Seite beziehungsweise im sichtbaren
  HTML-Text; SHA256 und unveränderte Bytes gegen Quellenpin `7a296d28…`
  geprüft. Acht exakt gleiche Belege der Teilprüfungen zusammengeführt.
- **32 App-Istbeobachtungen / 61 Zeilenverweise / 22 Dateien:** Inhalt,
  Zeilenanker und SHA256 bytegenau gegen den aktuell abgefragten App-main-Pin
  `5296108f5756ef1463c25a49d93d4a346e9b5e9c` geprüft. Istpfad, Editor,
  Adapter und fachlicher Regelzugriff getrennt untersucht.
- **24 Maßnahmen / 13 gemeinsame Themen / 70 Teilscopes:** alle Quellen-/
  Frageverweise aufgelöst. 124 bestehende lokale offene Frage-IDs gebunden;
  drei echte offene UBB-IDs separat im unveränderten Sammelissue-Body verifiziert.
  Keine neue UBB-SEED-Frage-ID oder Aliasfreigabe erfunden.
- **Fragenintegrität:** sämtliche 289 Dossierfragen bytegleich zu vorherigem
  Draft-Head `53f3783…`, `open_before_app_admission` und `answer:null`.
  Vollständiger exakter Satz der acht o6_3-Blocker ebenfalls unverändert offen.
  Die gemeinsame Struktur schließt und dedupliziert keine dieser Fragen.
- **Aktuelle Hinweise:** AMA 25.08./12.06.2026 und BAES-Registerbeschreibung
  gezielt online geprüft. Kurze neue Zitate wörtlich bestätigt; keine
  vollständigen aktuellen Register-/Rechts-/Katalogbytes oder SHA behauptet.
  Das explizite AMA-N-Beispiel 40×0,60=24 und 60−24=36 mit Decimal nachgerechnet;
  eigener N der ungenutzten Zwischenfrucht wird unvermindert weitergegeben.
  Kein allgemeines Golden-Soll aus dem Beispiel abgeleitet.
- **Inventarvalidator:** bestehende Pins für 26 Maßnahmen / 52 Runs /
  129 ursprüngliche offene Fragegruppen sowie App-Baseline erhalten.
- **Unabhängige Zweitprüfung:** Originalquellen, Appblobs/-anker, exakte
  Frage-/Blocker-Sätze, Produktentscheidungen und verbliebene Quellen-/
  Kataloggrenzen geprüft; keine verbleibenden materiellen Reviewbefunde.

Zählungen, Quellhashes und Beispielrechnung stehen in
[verification.json](verification.json). Lokale Markdownziele und Frage-IDs
sowie `git diff --cached --check` werden vor Veröffentlichung geprüft.

Reproduzierbare Fundstellenprüfung mit vorhandener Repository-Umgebung:

```bash
PYTHONPATH=src:. python - <<'PY'
import hashlib, json
from pathlib import Path
from tools.review_o6_1c_variable_review import OriginalSources
folder = Path('docs/analysis/material-operations-review-20261008')
checker = OriginalSources()
for item in json.loads((folder / 'evidence.json').read_text())['local_quotes']:
    assert hashlib.sha256(Path(item['source_path']).read_bytes()).hexdigest() == item['source_sha256']
    checker.check_quote(item, 'quote')
print('355 unterschiedliche lokale Originalfundstellen geprüft')
PY
python tools/review_all_measure_variables.py
```

Die reguläre PR-CI prüft die vorhandenen Repository-/Validator-/Originalquellen-/
OPA-Checks am neuen Commit; das konkrete Ergebnis wird dort und im Sammelissue
verlinkt. Kein neuer Modell-Run, unabhängig bewerteter Golden-Fall oder
produktiver App-E2E-Test. Originalquellen, historische Runs/Policies,
Canonical Farm Profile, App und Thesis bleiben unverändert.
