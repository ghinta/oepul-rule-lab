# Verification · 08.10.2026

- **275 unterschiedliche Originalzitate / 18 lokale Quellen:** literal auf
  physischer PDF-Seite beziehungsweise im sichtbaren HTML-Text geprüft;
  vollständige Quellenbytes und SHA256 gegen historischen Pin `7a296d28…`
  unverändert. Vier identische Quelle-/Seite-/Zitatbelege zusammengeführt.
- **295 zusätzliche Katalogkontexte:**151 NAT-Parameterzeilen /165 Codes
  einschließlich Aliassen,144 EBW-Kontextzeilen /100 Indikatorcodes. Alle
  vollständigen Ausschnitte literal; keine semantische Parametertyp- oder
  Aliasfreigabe. Vier vorhandene historische Katalogaudits plus WRRL-Lückendossier
  gepinnt; eine vollständige aktuelle Einzelflächenpflichtliste fehlt weiterhin.
- **17 App-Istbeobachtungen / 59 Zeilenverweise / 22 Dateien:** tatsächliche
  Blobs, SHA256, Anfangs-/Endanker bytegenau gegen frisch abgefragten App-main-Pin
  `5296108f5756ef1463c25a49d93d4a346e9b5e9c`. Rohdaten, Blueprint, Registry,
  Adapter, Editor, aktueller HTTP-Dispatch und tatsächliche Policy getrennt.
- **73 Teilscopes / 16 direkt vertiefte Maßnahmen / 12 Themen:** alle Quellen-,
  Online- und Frageverweise aufgelöst.107 bestehende offene IDs mit25 Dossiers
  verbunden. Reine Kurs-/Kombinations-/Zahlungsanteile als Block6/7-Querverweise;
  keine neue Kurs- oder Zahlungsberechnung und kein globales UND-Aufnahmegate.
- **Fragenintegrität:** alle289 Fragen bytegleich zum vorherigen Draft-Head
  `43b295b…`, Status `open_before_app_admission`, `answer:null`.
  Vollständiger exakter Satz alleracht o6_3-Blocker bytegleich und
  `open_before_full_recommendation`; keine Frage entfernt oder beantwortet.
- **Sechs technische App-Policy-Beobachtungen:** unveränderte aktuelle Policy
  isoliert mit synthetischem aktuellem2026-Kontext reproduziert.14/17/19 liefern
  `eligible` als `phase1_baseline_check_passed`;18/23/24 bleiben `missing_data`.
  EBW-Fall: exakt1,0ha Acker ohne Projektbeleg. NATA ist optionaler Alm-Scope;
  Maßnahme17 besitzt keine allgemeine Projektpflicht. Kein Golden-Soll und
  kein HTTP-/Datenbank-/Browser-E2E-Test.
- **OPA-Provenienz:** Erstbeobachtung mit vorhandener lokaler1.18.2-Binary
  und eigenem Hash (`-dirty`-Build, kein Release-Checksum-Nachweis). Alle sechs
  Ergebnisse anschließend mit offizieller1.18.2-Linux-Binary von GitHub Releases
  unabhängig reproduziert; SHA256 `9903e512…ab20de8` entspricht exakt dem
  vorhandenen Repository-Checksum-Katalog. Version passt zum App-Compose-Pin.
- **Gezielte aktuelle Quellen:** AMA19.05./12.08.2026, offizielle SRL-/Anhanglinks
  vom01.10.2026 und datierte WRRL-Konsolidierung/Anlage3 online gelesen.
  RIS§9a bestätigt08.06.2026 als Novellen-Inkrafttreten; historische Anlage3-
  Metadaten zeigen das Ende am07.06.2026. Vollständiger historischer Tabellenstand
  davor fehlt; ausdrückliche RIS-Gesamtfassung am08.10.2026 war perTool nicht
  zugänglich. Keine lückenlose Aktualität nach dem datierten PDF behauptet.
  Keine neuen Online-PDFbytes oder SHA erfunden.

[verification.json](verification.json) enthält Zählungen, geprüfte Quellhashes,
Binary-Provenienz und reproduzierte Statuswerte. Die unabhängige Zweitprüfung
prüft besonders Experten-/Betreibervorrang, eigenen dokumentierten Auto-Snapshot,
automatische Ausnahmerouten, begrenzte Rechtsfolgen und nicht bindende Indikatoren.

Reproduzierbare lokale Fundstellenprüfung mit vorhandenen Repository-Abhängigkeiten:

```bash
PYTHONPATH=src:. python - <<'PY'
import hashlib, json
from pathlib import Path
from tools.review_o6_1c_variable_review import OriginalSources
folder = Path('docs/analysis/authority-project-review-20261008')
checker = OriginalSources()
for item in json.loads((folder / 'evidence.json').read_text())['local_quotes']:
    assert hashlib.sha256(Path(item['source_path']).read_bytes()).hexdigest() == item['source_sha256']
    checker.check_quote(item, 'quote')
print('275 unterschiedliche lokale Originalfundstellen geprüft')
PY
python tools/review_all_measure_variables.py
```

Die reguläre PR-CI prüft bestehende Repository-/Validator-/Originalquellen-/OPA-
Checks am Ergänzungscommit; Ergebnis und konkreter Lauf werden im PR und
Sammelissue verlinkt. Lokale Markdownziele und Diff-Whitespace werden geprüft.
Keine neue Fachregel, App-Funktion, aktuelle private Betriebs-/Behörden-/Experten-
Snapshots, Modellläufe, Golden-Bewertung oder produktive E2E-Prüfung.
Quellen, historische Runs, Canonical Farm Profile und Thesis unverändert.
