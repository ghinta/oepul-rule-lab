# Draft: `o6_7` mit `gpt-5.6-terra`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich
oder rechtlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_7` (Begrünung von Ackerflächen –
System Immergrün). Er liefert einen quellengebundenen, ausführbaren
Regelkandidaten. Die technische Validierung ersetzt weder eine fachliche
Vollständigkeitsprüfung noch eine rechtsverbindliche Förderentscheidung.

## Lauf

- Run-ID: `v2-o6_7-terra-20260926`
- Modus: `discover`
- Modell: `gpt-5.6-terra`, Reasoning `high`
- Maßnahmenspezifische Quelle: amtlich aktuelle Fassung Oktober 2025
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen sowie vier amtliche Hinweise
  aus 2026
- Source-Pack-Prüfung: alle 27 Kern-PDFs, 2 Rechtsgrundlagen und 4 Hinweise
  verifiziert; AMA-Indizes entsprechen dem Stand der lokalen Sammlung
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt
- Limit-Guard: Start mit 62 % primärem Restbudget, Modellabschluss mit 40 %;
  kein Guard-Abbruch

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 34 |
| Quellenbelege | 20 |
| Coverage-Einträge / regelnde / nicht-regelnde / offene Einträge | 31 / 22 / 9 / 0 |
| Vorgeschlagene Profiländerungen / neue Profilpfade | 10 / 50 |
| Von Rego verwendete Eingabepfade / unbekannt | 8 / 0 |
| Datendateien / Datentabellen | 1 / 5 |
| Rego-Dateien / Zeilen | 2 / 202 |
| Generierte OPA-Tests | 4 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / 4 von 4 bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |
| Canonical Farm Profile direkt verändert | nein |

## Offene fachliche Punkte

- Die aktuell amtlich veröffentlichte maßnahmenspezifische Fassung ist Stand
  Oktober 2025; sie wurde mit den verfügbaren 2026-Quellen ergänzt. Eine
  spätere amtliche Fassung muss erneut extrahiert werden.
- Der Endzeitpunkt des Verbots für mineralischen Stickstoff verweist auf die
  Nitrat-Aktionsprogramm-Verordnung. Der Lauf schlägt deshalb ein explizites
  Eingabefeld vor, statt den jahresspezifischen Zeitpunkt zu erfinden.
- Die Dürre-Ausnahme 2026 setzt glaubhafte vorsorgliche Bewirtschaftung und
  eine Anlage zum frühestmöglichen Zeitpunkt voraus. Sie ist daher als
  evidenzabhängige Ausnahme modelliert und lockert keine anderen Fristen.
- Die punktuelle 85%-Berechnung verlangt eine zeitbezogene Historie über alle
  Ackerflächen. Das Canonical Farm Profile enthält keine solche Zeitreihe; die
  Rego-Entscheidung braucht daher die vorgeschlagenen Ereignisdaten.
- Die vier erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht jede Ausnahme oder Vor-Ort-
  Feststellung ab.

Die veröffentlichten Dateien enthalten prüfbare Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
Identitäten und Prüfsummen stehen in `run.json` und den Artefakten.
