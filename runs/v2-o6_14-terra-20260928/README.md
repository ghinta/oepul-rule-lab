# Draft: `o6_14` mit `gpt-5.6-terra`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_14` (Almbewirtschaftung). Er liefert
einen quellengebundenen, ausführbaren Regelkandidaten. Die technische
Validierung belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit
oder eine passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_14-terra-20260928`
- Modus: `discover`
- Modell: `gpt-5.6-terra`, Reasoning `high`
- Limit-Guard: Start bei 88 %, Abschluss bei 78 % Restlimit; kein Abbruch
- Maßnahmenspezifische Quelle: AMA-Informationsblatt Almbewirtschaftung,
  Ausgabe April 2026
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhang E und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 30 |
| Quellenbelege | 22 |
| Coverage-Einträge / nicht-regelrelevante Einträge | 28 / 5 |
| Vorgeschlagene Profil-Blattpfade | 52 in 3 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 1 / 0 |
| Datendateien / Datentabellen | 1 / 4 |
| Rego-Dateien / Zeilen | 2 / 90 |
| Generierte OPA-Tests | 3 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |
| Canonical Farm Profile direkt verändert | nein |

## Offene fachliche Punkte

- Das bestehende Profil enthält nur eine aggregierte Almweidefläche. Die
  zusätzliche Antragsteller- und Einzelalmstruktur ist ausschließlich ein
  Discover-Vorschlag und muss vor jeder produktiven Nutzung fachlich
  abgestimmt werden.
- Die drei erzeugten OPA-Tests prüfen zentrale RGVE-, Prämien- und
  Kombinationsfälle, sind aber keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht alle Regeln, Fristen und Ausnahmen
  ab.
- Die Prämien-, Auflagen- und Meldedaten bilden den Quellenstand des Runs ab;
  betriebliche Nachweise und die konkrete Förderentscheidung bleiben separat
  zu prüfen.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.
