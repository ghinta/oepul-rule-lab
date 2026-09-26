# Draft: `o6_5` mit `gpt-5.6-terra`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich
oder rechtlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_5` (Erhaltung gefährdeter
Nutztierrassen). Er liefert einen quellengebundenen, ausführbaren
Regelkandidaten. Die technische Validierung ersetzt weder eine fachliche
Vollständigkeitsprüfung noch eine rechtsverbindliche Förderentscheidung.

## Lauf

- Run-ID: `v2-o6_5-terra-20260926`
- Modus: `discover`
- Modell: `gpt-5.6-terra`, Reasoning `high`
- Maßnahmenspezifische Quelle: amtlich aktuelle Fassung Oktober 2025
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen sowie vier amtliche Hinweise
  aus 2026
- Source-Pack-Prüfung: alle 27 Kern-PDFs, 2 Rechtsgrundlagen und 4 Hinweise
  verifiziert; AMA-Indizes entsprechen dem Stand der lokalen Sammlung
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt
- Limit-Guard: Start mit 88 % primärem Restbudget, Modellabschluss mit 66 %;
  kein Guard-Abbruch

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 26 |
| Quellenbelege | 17 |
| Coverage-Einträge / regelnde / nicht-regelnde / offene Einträge | 30 / 21 / 9 / 0 |
| Vorgeschlagene Profiländerungen / neue Profilpfade | 5 / 32 |
| Von Rego verwendete Eingabepfade / unbekannt | 2 / 0 |
| Datendateien / Datentabellen | 1 / 2 |
| Rego-Dateien / Zeilen | 2 / 102 |
| Generierte OPA-Tests | 3 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / 3 von 3 bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |
| Canonical Farm Profile direkt verändert | nein |

## Offene fachliche Punkte

- Die aktuell amtlich veröffentlichte maßnahmenspezifische Fassung ist Stand
  Oktober 2025; sie wurde mit den verfügbaren 2026-Quellen ergänzt. Eine
  spätere amtliche Fassung muss erneut extrahiert werden.
- Die Rego-Implementierung prüft derzeit nur die determinierten Mindest-
  Eingaben für Rasse, Reinrassigkeit, Zuchtbuch und Haltedauer. Weitere
  strukturierte Regeln – etwa Antrags-, Abgangs-, Ersatz- und
  Weitergabefristen – sind quellengebunden katalogisiert und als Discover-
  Profilfelder erfasst, aber nicht als vollständig ausführbare Entscheidung
  modelliert.
- Die Dürre-Mitteilung vom 12. August 2026 verkürzt für 2026 die Haltedauer
  bis 31. August. Die Ausnahmeregel ist als eigener, belegter Rego-Zweig
  getestet; Bewegungs- und Meldepflichten bleiben davon unberührt.
- Die drei erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht jede Regel und Ausnahme ab.

Die veröffentlichten Dateien enthalten prüfbare Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
Identitäten und Prüfsummen stehen in `run.json` und den Artefakten.
