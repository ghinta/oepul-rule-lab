# Verifikation für #97

Basis: `main` bei `84482b59264c04e3f645460ebe15f6b64b3b85ef`.
Branch: `codex/issue-97-heuwirtschaft`. Lokale Auswertung: 07.10.2026.

- Repository-Suite: 80 Tests bestanden, keine übersprungenen Quellenfälle.
- Validator-Suite: 11 Tests bestanden.
- OPA 1.18.2: fmt, strict check und test bestanden (3 direkte Guard-Tests).
- Die 41 neuen Python-Tests prüfen Vertrag, Provenienz und tatsächliche
  OPA-Ausgaben; die vollständige Kategorienprüfung umfasst alle 20 RGVE-Zeilen.
- Quellenbelege auf den angegebenen PDF-Seiten maschinell geprüft.
- Historische Policy-/Daten-/Testdateien und gebundene Metadaten unverändert;
  sämtliche in `lineage.json` aufgeführten Hashes geprüft.
- Schema entspricht den Pydantic-Modellen; Workflow-YAML ist syntaktisch gültig.

Der erste Remote-Lauf bestand die 75 Repository-Tests bereits mit der
offiziellen gepinnten Binary. Er deckte eine Umgebungsabhängigkeit im
bestehenden Auto-Auswahl-Test des Validators auf. Dieser Test entfernt
jetzt ausschließlich die expliziten `OPA_BIN`-/`OPA_RUNTIME`-Overrides,
damit er die beabsichtigte automatische Workspace-Auswahl prüft. Der
separate Override-Test bleibt bestehen.

Die lokale Binary hat SHA-256
`16118120a6a662c25c678b02b411d8cb22e32460f5d47d2ff9466ff2ed5104cc`.
Sie erfüllt den vorhandenen lokalen Versionscheck (1.18.2). CI lädt separat
die offizielle, im Repository mit SHA-256 gepinnte Plattform-Binary; ein
lokaler Pass wird nicht als bereits gelaufener Remote-CI-Pass ausgegeben.

## Ursprüngliche Quellenfälle und Reparaturwirkung

| Fall aus Review #98 | Adaptierter Befund |
| --- | --- |
| Merkblatt-Beispiel | 5 RGVE / 13 ha; 11 ha prämienfähig, 1.603,80 EUR Indikation. |
| Folgejahr ohne Tiere | Historischer Zugang bleibt erfüllt, aktueller Satz 0. |
| 4 adulte Neuweltkamele auf 2 ha im Erstjahr | 0,60 RGVE, Schwelle erfüllt. |
| 1 kleiner adulter Equide auf 2 ha im Erstjahr | 0,50 RGVE, Schwelle verfehlt. |
| Jahr 2030 bei Vertrag bis 2028 | Außerhalb des Vertrags, keine positive Prämienindikation. |
| Unbekannte Silagelagerung | `missing_data`, Prämienindikation null. |
| Ungemähtes Ackerfutter im Dürregebiet | Keine automatische Befreiung; Jahrespflicht vor Fälligkeit offen, nach Fälligkeit bei bestätigter Nichterfüllung verletzt. |

Zusätzlich geprüft: Durchschnitt vor Stichtagsbestand, explizite Null,
fehlende/unvollständige/leere Exporte, unbekannte Kategorien, Tierarten-
Kategorie-Konflikte, Auslandsbezug, 1,99/2-ha-Grenze, datierter Zugang,
aktuelles Jahr und Snapshot, Mahd unbekannt/leer, Zweitkultur, Option,
Grünfütterungsfälligkeit und pflicht-/jahr-/zeitgebundene Anerkennungen.
Eine passende Anerkennung führt zur Rechtsfolgenprüfung; andere bekannte
Verletzungen bleiben erhalten.

## Review-Korrekturen aus PR #99

Der ursprüngliche Stand ließ `kleegrass` im Erstjahr aus dem Nenner fallen:
0,7 RGVE / 2 ha erfüllten scheinbar die Schwelle, obwohl mit der tatsächlichen
1-ha-Kleegrasfläche 0,7 / 3 ha darunter liegen. Der Regressionstest prüft
diese Grenze und verlangt bei unbekannten Codes `missing_data` sowie null
für Flächensummen, Satz und Prämienindikation. Bestätigtes `non_fodder` und
bekannte Ackerweide werden getrennt geprüft.

Weitere neue Tests verwerfen `1e999`, `-1e999`, NaN und ±Infinity für alle
sechs numerischen Flächen-/Tierbestandsfelder vor Aufruf von OPA. Die fünf
beanstandeten Verpflichtungs-IDs werden über tatsächliche Verletzungen
ihren genauen Quellenbelegen zugeordnet; alle sieben Verpflichtungs-IDs
besitzen eine gültige Referenz. Die PDF-Seitenprüfung umfasst die neuen
Belege. Diese Regressionen reproduzierten die Fehler vor der Korrektur.

Der Workspace-Kommentar betrifft den Generator-Auftrag. #97 ist die vom
Nutzer separat beauftragte manuelle Adaptation mit eigenem Branch, Tests
und CI. Der Geltungsbereich ist jetzt in `AGENTS.md` ausdrücklich abgegrenzt;
historische Runs, Quelldokumente und Canonical Farm Profile bleiben gebunden.

## Reproduzieren

```bash
OPA_BIN=/absolute/path/to/opa PYTHONPATH=src python3 -m unittest discover -s tests -v
PYTHONPATH=src python3 -m unittest discover -s runner/validation/tests -v
python3 runner/validation/opa_validate.py validate \
  --workspace adaptations/o6_3 --runtime local --opa-bin /absolute/path/to/opa \
  --target policy --target data --target tests --pretty
```

CI führt diese Gates auf PRs und `main` aus und stellt den technischen
Prüfbericht als Artefakt bereit. Die Fälle bleiben sichtbare Entwicklungs-
regressionen; sie sind kein kontrollierter Modellbenchmark.
