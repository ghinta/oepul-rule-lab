# Draft: `o6_20` mit `gpt-5.6-terra`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_20` (Weide). Er liefert einen quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_20-terra-20260929`
- Modus: `discover`
- Modell: `gpt-5.6-terra`, Reasoning `high`
- Maßnahmenspezifische Quelle: AMA-Informationsblatt Weide, Ausgabe Oktober 2025; im versionierten Quellenbestand liegt keine Ausgabe 2026 vor
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April 2026, Sonderrichtlinie ÖPUL 2023 samt Anhang A sowie amtliche Hinweise aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 32 |
| Quellenbelege | 23 |
| Coverage-Einträge | 20 |
| Vorgeschlagene Profil-Blattpfade | 52 in 1 Discover-Vorschlag |
| Von Rego verwendete Eingabepfade / unbekannt | 1 / 0 |
| Datendateien / Datentabellen | 1 / 1 |
| Rego-Dateien / Zeilen | 2 / 100 |
| Generierte OPA-Tests | 4 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |
| Canonical Farm Profile direkt verändert | nein |

## Offene fachliche Punkte

- Die Quelle nennt keine feste Weidestundenzahl; der Kandidat modelliert nur belegbares `substantial_day_grazing`, ohne eine Schwelle zu erfinden.
- Die 2-RGVE-Logik ist als Durchschnitt für 1. April bis 31. Oktober modelliert; eine spezielle Datenbankberechnung liegt außerhalb des Workspaces.
- Für Dürre 2026 ist bei Weide nur ein Antrag auf höhere Gewalt unmittelbar relevant. Zeitgebundene Hinweise sind keine dauerhafte Anspruchsgrundlage.
- Maßnahme-, Einzeltier- und Weidetagebuchdaten bleiben Discover-Vorschläge; die vier OPA-Tests sind generierte Techniktests, keine vollständige fachliche Testabdeckung.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-, Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht; ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten festgehalten.
