# Draft: `o6_21` mit `gpt-5.6-terra`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_21`. Er liefert einen quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_21-terra-20260929`
- Modus: `discover`
- Modell: `gpt-5.6-terra`, Reasoning `high`
- Maßnahmenspezifische Quelle: versioniertes AMA-Informationsblatt im lokalen Quellensatz
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April 2026, Sonderrichtlinie ÖPUL 2023 samt Anhang A sowie amtliche Hinweise aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 17 |
| Quellenbelege | 18 |
| Coverage-Einträge | 24 |
| Vorgeschlagene Profil-Blattpfade | 33 in 3 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 16 / 0 |
| Datendateien / Datentabellen | 1 / 3 |
| Rego-Dateien / Zeilen | 2 / 188 |
| Generierte OPA-Tests | 4 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |
| Canonical Farm Profile direkt verändert | nein |

## Offene fachliche Punkte

- Die Quelle erfordert tatsächliche Rinderdatenbankhistorien. Der Kandidat nutzt daher vorab berechnete Jahresdurchschnitts-RGVE und Kategorie-Fakten, statt Einzelhistorien zu rekonstruieren.
- Offenstall, Milchlieferung einschließlich saisonaler Almlieferung, Qplus-Nachweis und Kompostmethode/-dokumentation benötigen zusätzliche Nachweisfelder und sind nur Discover-Vorschläge.
- Die vorliegenden Hinweise aus 2026 ändern o6_21 nicht; die Nichtanwendbarkeit ist in der Coverage dokumentiert.
- Die alternative ungewen­dete Kompostmischung bleibt ein beleggestütztes Eingabefeld, keine automatisierte agronomische Bestimmung. Die vier OPA-Tests sind Techniktests und keine vollständige fachliche Testabdeckung.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-, Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht; ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten festgehalten.
