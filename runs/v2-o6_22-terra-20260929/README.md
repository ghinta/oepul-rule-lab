# Draft: `o6_22` mit `gpt-5.6-terra`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_22` (Tierwohl Schwein). Er liefert einen quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_22-terra-20260929`
- Modus: `discover`
- Modell: `gpt-5.6-terra`, Reasoning `high`
- Maßnahmenspezifische Quelle: versioniertes AMA-Informationsblatt, Ausgabe Oktober 2025
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April 2026, Sonderrichtlinie ÖPUL 2023 samt Anhang A sowie amtliche Hinweise aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 24 |
| Quellenbelege | 22 |
| Coverage-Einträge | 61 |
| Vorgeschlagene Profil-Blattpfade | 47 in 1 Discover-Vorschlag |
| Von Rego verwendete Eingabepfade / unbekannt | 14 / 0 |
| Datendateien / Datentabellen | 1 / 4 |
| Rego-Dateien / Zeilen | 2 / 159 |
| Generierte OPA-Tests | 4 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |
| Canonical Farm Profile direkt verändert | nein |

## Offene fachliche Punkte

- Das Merkblatt Oktober 2025 verfeinert als spätere operative Quelle die Sonderrichtlinie 2024, insbesondere zur ungewen­deten Misch-/Schichtkompost-Alternative und historischen Planpflicht.
- `continuous_use_days <= 366` bildet „höchstens ein Jahr“ ab; die administrative Behandlung von Schaltjahren ist nicht spezifiziert.
- Gruppenhaltungszeiträume, tierärztliche Notwendigkeit, Wasserrechte und die Eignung alternativer Wendeausrüstung bleiben nachweisgestützte Eingaben statt inferierte Tatsachen.
- Die 2026-Dürre- und Insektizid-Hinweise ändern keine o6_22-Anforderung. Die vier OPA-Tests sind Techniktests und keine vollständige fachliche Testabdeckung.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-, Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht; ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten festgehalten.
