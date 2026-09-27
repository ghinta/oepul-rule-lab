# Draft: `o6_10` mit `gpt-5.6-terra`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich
oder rechtlich freigegeben**

Dieser Lauf betrifft die Maßnahme `o6_10` (Erosionsschutz Wein, Obst und
Hopfen). Er ist ein quellengebundener, technisch geprüfter Vorschlag und keine
aktive Runtime-Policy oder Förderzusage.

## Run

- ID: `v2-o6_10-terra-20260927`
- Modus: `discover`
- Modell: `gpt-5.6-terra`, Reasoning `high`
- Maßnahmenblatt: amtlich aktuell verlinkte Ausgabe Oktober 2025
- Ergänzende Quellen: allgemeine Teilnahmebedingungen April 2026, die
  Sonderrichtlinie samt Anhängen sowie vier amtliche Hinweise 2026
- Quellenpack: 27/27 Kern-PDFs, 2/2 Rechtsgrundlagen und 4/4 Hinweise
  verifiziert; die AMA-Indexseiten stimmen mit dem Manifest überein
- OPA: lokal gepinnt auf Version `1.18.2`

Der Generator erhielt die geprüfte Binary als `tools/opa` im isolierten
Workspace. Der Modell-Run führte OPA-Formatierung, Strict-Compile und Tests
selbst aus und reparierte technische Fehler iterativ. Der Lauf startete mit
92 % Restbudget und blieb ohne Limit-Abbruch; beim Modellabschluss waren noch
68 % verfügbar.

## Ergebnis

| Kennzahl | Ergebnis |
| --- | ---: |
| Strukturierte Regeln | 31 |
| Quellenbelege | 27 |
| Coverage-Einträge (`rules` / `not_rule` / `unresolved`) | 25 / 13 / 0 |
| Profiländerungsvorschläge / ergänzte Profilpfade | 2 / 40 |
| Rego-Eingabepfade / unbekannte Pfade | 5 / 0 |
| Datendateien / Datentabellen | 1 / 2 |
| Rego-Dateien / Rego-Zeilen | 2 / 148 |
| Generierte OPA-Tests | 5 |

`opa fmt`, `opa check --strict` und `opa test` bestanden mit `PASS: 5/5`.
Die unabhängige Grounding-Prüfung für Verträge, Quellenbelege, Coverage,
Dateninventar und Profilvorschläge besteht ohne Fehler. Das Canonical Farm
Profile wurde im Run nicht direkt verändert.

## Offene fachliche Punkte

- Das spezifische Maßnahmenblatt ist die aktuell verlinkte Ausgabe Oktober
  2025; es wird zusammen mit den amtlichen Bedingungen und Hinweisen 2026
  ausgewertet. Bei einer neu veröffentlichten Fassung ist die Extraktion zu
  wiederholen.
- Nachweise aus Mehrfachantrag, Kontrolle und AGES-Daten werden nur als
  Discover-Profileingaben vorgeschlagen. Die Regeln behaupten keinen externen
  Verwaltungs- oder Kontrollnachweis.
- Die Dürreerleichterungen 2026 bleiben an modellierte Tatsachen gebunden;
  sie bilden keine pauschale Lockerung der Begrünungs- oder sonstigen Pflichten.
- Terrassen und die maßgebliche Hangneigung benötigen belastbare fachliche bzw.
  GIS-Fakten. Sanktionsbeträge und Vollzugsfolgen sind nicht als rechtsverbindliche
  Entscheidung modelliert.
- Die fünf Modelltests sind keine Golden-, Hidden- oder Expertentests. Sie
  belegen technische Ausführbarkeit, nicht die fachliche Endfreigabe.

Rohprotokolle und kopierte Quellbinärdateien werden nicht versioniert. Die
prüfbaren Ergebnisse, Verträge, Hashes und Validierungsartefakte dieses Runs
sind im Run-Verzeichnis enthalten.
