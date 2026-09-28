# Draft: `o6_12` mit `gpt-5.6-terra`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich
oder rechtlich freigegeben**

Dieser Lauf betrifft `o6_12` (Insektizidverzicht Wein, Obst und Hopfen). Er
liefert einen quellengebundenen Rego-Kandidaten, keine aktive Runtime-Policy
und keine Förderzusage.

## Run

- ID: `v2-o6_12-terra-20260928`
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
| Strukturierte Regeln | 34 |
| Quellenbelege | 40 |
| Coverage-Einträge (`rules` / `not_rule` / `unresolved`) | 25 / 19 / 0 |
| Profiländerungsvorschläge / ergänzte Profilpfade | 10 / 34 |
| Rego-Eingabepfade / unbekannte Pfade | 7 / 0 |
| Datendateien / Datentabellen | 1 / 4 |
| Rego-Dateien / Rego-Zeilen | 2 / 199 |
| Generierte OPA-Tests | 5 |

`opa fmt`, `opa check --strict` und `opa test` bestanden mit `PASS: 5/5`.
Die unabhängige Grounding-Prüfung für Verträge, Quellenbelege, Coverage,
Dateninventar und Profilvorschläge besteht ohne Fehler. Das Canonical Farm
Profile wurde im Run nicht direkt verändert.

## Offene fachliche Punkte

- Teilnahme-, Register-, Kauf-/Lager-, Länder-, Veredelungs-, OP- und
  Behördenanordnungsdaten fehlen im Canonical Farm Profile. Sie werden nur als
  quellengebundene Discover-Ergänzungen vorgeschlagen.
- Die Bio-Ausnahme wird durch das Evidenzfeld `bio_2018_848_permitted`
  repräsentiert; der Run kann keine externe Betriebsmittelbewertung abfragen.
- Die Ausnahme nach behördlicher Anordnung ist über explizite Nachweisfelder
  modelliert. Für den Hinweis vom 12. Juni 2026 wurde keine Bezirksliste
  erfunden.
- Die Matrix in Anhang L wurde nicht über ihre belastbare Darstellung hinaus
  interpretiert. Nur die unabhängig belegte Reduktion des optionalen
  Erosionsschutz-Zuschlags um 50 % ist ausführbar modelliert.
- Die Dürrehinweise 2026 wurden vollständig geprüft, betreffen aber nicht
  o6_12 und sind im Coverage Ledger als nicht einschlägig dokumentiert.
- Die fünf Modelltests belegen technische Ausführbarkeit, sind aber keine
  Golden-, Hidden- oder Expertentests.

Rohprotokolle und kopierte Quellbinärdateien werden nicht versioniert. Die
prüfbaren Ergebnisse, Verträge, Hashes und Validierungsartefakte dieses Runs
sind im Run-Verzeichnis enthalten.
