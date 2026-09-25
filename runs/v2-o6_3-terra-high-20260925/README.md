# Draft: `o6_3` mit `gpt-5.6-terra`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_3` (Heuwirtschaft). Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung
belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine
passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_3-terra-high-20260925`
- Modus: `discover`
- Modell: `gpt-5.6-terra`, Reasoning `high`
- Limit-Guard: Start bei 82 %, Abschluss bei 73 % Restlimit; kein Abbruch
- Maßnahmenspezifische Quelle: AMA-Informationsblatt Stand Oktober 2025
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 31 |
| Quellenbelege | 41 |
| Coverage-Einträge / offene Einträge | 46 / 0 |
| Vorgeschlagene Profil-Blattpfade | 28 in sechs Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 13 / 0 |
| Datendateien / Datentabellen | 1 / 3 |
| Rego-Dateien / Zeilen | 2 / 149 |
| Generierte OPA-Tests | 5 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |
| Canonical Farm Profile direkt verändert | nein |

## Offene fachliche Punkte

- Antrag, Silage, Heu-Abgabe, Mähaufbereiter, Tieralters- und
  Größenklassen sowie Flächenhistorie fehlen im Canonical Farm Profile. Sie
  werden nur als Discover-Vorschläge ergänzt.
- Die Grünfütterung ist für den „überwiegenden Teil“ der Vegetationsperiode
  vorgeschrieben, ohne belastbare Tageszahl. Die Rego-Regel erwartet deshalb
  eine belegte Feststellung statt einer erfundenen Schwelle.
- Das Informationsblatt führt die Biologische Wirtschaftsweise – Teilbetrieb
  als Kombination, die Sonderrichtlinie nur 1A oder 1B. Diese Ambiguität bleibt
  dokumentiert.
- Die fünf selbst erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht alle Regeln und Ausnahmen ab.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.
