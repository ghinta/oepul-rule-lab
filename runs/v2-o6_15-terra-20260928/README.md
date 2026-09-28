# Draft: `o6_15` mit `gpt-5.6-terra`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_15` (Tierwohl – Behirtung). Er liefert
einen quellengebundenen, ausführbaren Regelkandidaten. Die technische
Validierung belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit
oder eine passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_15-terra-20260928`
- Modus: `discover`
- Modell: `gpt-5.6-terra`, Reasoning `high`
- Limit-Guard: Start bei 96 %, Abschluss bei 80 % Restlimit; kein Abbruch
- Maßnahmenspezifische Quelle: AMA-Informationsblatt Tierwohl – Behirtung,
  Ausgabe April 2026
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhang A sowie vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 25 |
| Quellenbelege | 24 |
| Coverage-Einträge / nicht-regelrelevante Einträge | 23 / 8 |
| Vorgeschlagene Profil-Blattpfade | 50 in 2 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 7 / 0 |
| Datendateien / Datentabellen | 1 / 1 |
| Rego-Dateien / Zeilen | 2 / 144 |
| Generierte OPA-Tests | 5 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |
| Canonical Farm Profile direkt verändert | nein |

## Offene fachliche Punkte

- Das bestehende Profil enthält keine tier-, alm-, Hirt:innen-, Melde- oder
  Herdenschutzhunddaten. Die zwei ergänzten Strukturen sind ausschließlich
  Discover-Vorschläge und müssen vor produktiver Nutzung fachlich abgestimmt
  werden.
- Die fünf erzeugten OPA-Tests prüfen RGVE-Schlüssel, Prämienstufen,
  Mindestteilnahme, Mindestdauer und Herdenschutzhund-Voraussetzungen. Sie
  sind keine Golden-, Hidden- oder Domainexpert:innen-Tests und decken nicht
  alle Regeln, Fristen und Ausnahmen ab.
- Die Prämien- und Meldedaten bilden den Quellenstand des Runs ab; betriebliche
  Nachweise und die konkrete Förderentscheidung bleiben separat zu prüfen.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.
