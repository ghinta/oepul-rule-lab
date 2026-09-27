# Draft: `o6_11` mit `gpt-5.6-terra`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich
oder rechtlich freigegeben**

Dieser Lauf betrifft `o6_11` (Herbizidverzicht Wein, Obst und Hopfen). Er
liefert einen quellengebundenen Rego-Kandidaten, keine aktive Runtime-Policy
und keine Förderzusage.

## Run

- ID: `v2-o6_11-terra-20260927`
- Modus: `discover`
- Modell: `gpt-5.6-terra`, Reasoning `high`
- Maßnahmenblatt: amtliche Ausgabe April 2026
- Ergänzende Quellen: allgemeine Teilnahmebedingungen April 2026,
  Sonderrichtlinie samt Anhängen und vier amtliche Hinweise 2026
- Quellenpack: 27/27 Kern-PDFs, 2/2 Rechtsgrundlagen und 4/4 Hinweise
  verifiziert; die AMA-Indexseiten stimmen mit dem Manifest überein
- OPA: lokal gepinnt auf Version `1.18.2`

Der Generator erhielt die geprüfte lokale Binary als `tools/opa`. Er führte
OPA-Formatierung, Strict-Compile und Tests selbst aus. Die unabhängige
Finalisierung wiederholte diese Prüfungen.

## Ergebnis

| Kennzahl | Ergebnis |
| --- | ---: |
| Strukturierte Regeln | 23 |
| Quellenbelege | 19 |
| Coverage-Einträge (`rules` / `not_rule` / `unresolved`) | 31 / 8 / 0 |
| Profiländerungsvorschläge / ergänzte Profilpfade | 5 / 36 |
| Rego-Eingabepfade / unbekannte Pfade | 10 / 0 |
| Datendateien / Datentabellen | 1 / 4 |
| Rego-Dateien / Rego-Zeilen | 2 / 138 |
| Generierte OPA-Tests | 2 |

`opa fmt`, `opa check --strict` und `opa test` bestanden mit `PASS: 2/2`.
Die unabhängige Grounding-Prüfung für Verträge, Quellenbelege, Coverage,
Dateninventar und Profilvorschläge besteht ohne Fehler. Das Canonical Farm
Profile wurde im Run nicht direkt verändert.

## Offene fachliche Punkte

- Der AGES-Registerstatus ist keine lokale, versionierte Liste. Die Rego-Regel
  erwartet deshalb für jede Anwendung einen fachlich ermittelten `effect_type`
  und ersetzt keine Registerabfrage.
- Schlagnutzungsart, Pflanzgutqualität, Maßnahmenübernahme, Lagerbestand und
  historische PSM-Codes fehlen im Canonical Farm Profile. Sie werden nur als
  quellengebundene Discover-Ergänzungen vorgeschlagen.
- Die 2026-Hinweise ändern nach ihrer vollständigen Prüfung keine
  O6_11-Herbizidverzichtspflicht.
- Die Kombinationstabelle in Anhang L ist eine Matrix. Über die ausdrückliche
  Bio-Kombinationsregel hinaus müssen Einzelflächenkombinationen mit dem
  beantragten Maßnahmenportfolio fachlich abgeglichen werden.
- Zwei Modelltests belegen technische Ausführbarkeit, sind aber keine Golden-,
  Hidden- oder Expertentests.

Rohprotokolle und kopierte Quellbinärdateien werden nicht versioniert. Die
prüfbaren Ergebnisse, Verträge, Hashes und Validierungsartefakte dieses Runs
sind im Run-Verzeichnis enthalten.
