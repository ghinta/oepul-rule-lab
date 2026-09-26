# Draft: `o6_6` mit `gpt-5.6-terra`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich
oder rechtlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_6` (Begrünung von Ackerflächen –
Zwischenfruchtanbau). Er liefert einen quellengebundenen, ausführbaren
Regelkandidaten. Die technische Validierung ersetzt weder eine fachliche
Vollständigkeitsprüfung noch eine rechtsverbindliche Förderentscheidung.

## Lauf

- Run-ID: `v2-o6_6-terra-20260926`
- Modus: `discover`
- Modell: `gpt-5.6-terra`, Reasoning `high`
- Maßnahmenspezifische Quelle: amtlich aktuelle Fassung Oktober 2025
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen sowie vier amtliche Hinweise
  aus 2026
- Source-Pack-Prüfung: alle 27 Kern-PDFs, 2 Rechtsgrundlagen und 4 Hinweise
  verifiziert; AMA-Indizes entsprechen dem Stand der lokalen Sammlung
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt
- Limit-Guard: Start mit 95 % primärem Restbudget, Modellabschluss mit 81 %;
  kein Guard-Abbruch

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 32 |
| Quellenbelege | 25 |
| Coverage-Einträge / regelnde / nicht-regelnde / offene Einträge | 32 / 27 / 5 / 0 |
| Vorgeschlagene Profiländerungen / neue Profilpfade | 1 / 40 |
| Von Rego verwendete Eingabepfade / unbekannt | 2 / 0 |
| Datendateien / Datentabellen | 1 / 3 |
| Rego-Dateien / Zeilen | 2 / 113 |
| Generierte OPA-Tests | 3 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / 3 von 3 bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |
| Canonical Farm Profile direkt verändert | nein |

## Offene fachliche Punkte

- Die aktuell amtlich veröffentlichte maßnahmenspezifische Fassung ist Stand
  Oktober 2025; sie wurde mit den verfügbaren 2026-Quellen ergänzt. Eine
  spätere amtliche Fassung muss erneut extrahiert werden.
- Die Quellen enthalten kalenderjahrübergreifende Zeiträume. Der vorgeschlagene
  `o6_6`-Profilzusatz trägt deshalb einen ausdrücklichen Antrags-/Begrünungs-
  kontext; dessen Zuordnung zu einzelnen Betriebsvorgängen ist fachlich zu
  prüfen.
- Die Dürre-Mitteilung vom 12. August 2026 betrifft eine Gebietskulisse, die
  in den bereitgestellten Quellen nicht als sauber abgrenzbare maschinenlesbare
  Tabelle vorliegt. Sie ist daher als profilabhängige Regel dokumentiert und
  nicht räumlich hart codiert.
- Die drei erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht jede Variantenfrist, Ausnahme und
  Vor-Ort-Feststellung ab.

Die veröffentlichten Dateien enthalten prüfbare Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
Identitäten und Prüfsummen stehen in `run.json` und den Artefakten.
