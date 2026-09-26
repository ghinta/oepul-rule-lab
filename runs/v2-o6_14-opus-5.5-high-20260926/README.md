# Draft: `o6_14` mit `claude-opus-5-5`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_14` (Almbewirtschaftung). Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung
belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine
passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_14-opus-5.5-high-20260926`
- Modus: `discover`
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 38 min, 91 Turns; laut Claude Code
  876.172 Output-Tokens (davon 178.238 Thinking),
  Listenpreis-Äquivalent 45,68 USD
- Versuche: 3 (Fortsetzung derselben Sitzung mit dem Fehlerbericht von `finalize`, siehe `resumed_attempts` in `run.json`); Laufzeit und Tokens sind aufsummiert
- Limit-Guard: Versuch 1 wurde bei 4 % Restlimit kontrolliert unterbrochen
  (`aborted_usage_guard`) und nach dem Limit-Reset in derselben Sitzung
  fortgesetzt; der letzte Versuch startete bei 59 % und endete bei 47 %
- Maßnahmenspezifische Quelle: `o6_14_almbewirtschaftung_2026_04.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 126 |
| Quellenbelege | 311 |
| Coverage-Einträge / offene Einträge | 121 / 0 |
| Vorgeschlagene Profil-Blattpfade | 136 in 4 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 15 / 0 |
| Datendateien / Datentabellen | 4 / 27 |
| Rego-Dateien / Zeilen | 13 / 2247 |
| Generierte OPA-Tests | 122 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |
| Canonical Farm Profile direkt verändert | nein |

## Offene fachliche Punkte

- Drei Generatorversuche in derselben Sitzung: Versuch 1 wurde vom
  Nutzungsguard unterbrochen, Versuch 2 setzte fort und bestand die
  Grounding-Gates noch nicht, Versuch 3 behob die gemeldeten Fehler.
- Offen laut `workspace/notes/assumptions.md`: die Zählweise der
  Mindestbestoßungsdauer (Kalendertage vs. Tage; Auftriebstag zählt,
  Abtriebstag nicht), die Dokumentation von Unterbrechungszeiten, die
  Sanktionsstufe konkreter Verstöße und ob die Dürre-Regelungen 2026 eine
  Prämie auch unter 60 Bestoßungstagen ermöglichen.
- Die Folge einer Alm mit weniger als 60 Bestoßungstagen, Überbesatz,
  NATA-Auflagencodes und der Almweideplan-Zuschlag beruhen auf den Annahmen
  A-03 bis A-10.
- Die 122 selbst erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht alle Regeln und Ausnahmen ab.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.

