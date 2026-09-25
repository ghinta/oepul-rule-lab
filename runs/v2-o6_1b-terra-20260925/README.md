# Draft: `o6_1b` mit `gpt-5.6-terra`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich
oder rechtlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_1b` (Biologische Wirtschaftsweise).
Er liefert einen quellengebundenen, ausführbaren Regelkandidaten. Technische
Validierung ersetzt weder eine fachliche Vollständigkeitsprüfung noch eine
rechtsverbindliche Förderentscheidung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_1b-terra-20260925`
- Modus: `discover`
- Modell: `gpt-5.6-terra`, Reasoning `high`
- Maßnahmenspezifische Quelle: AMA-Informationsblatt Biologische
  Wirtschaftsweise, Stand April 2026
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen sowie vier amtliche Hinweise
  aus 2026
- Source-Pack-Prüfung: alle 27 Kern-PDFs, 2 Rechtsgrundlagen und 4 Hinweise
  verifiziert; AMA-Indizes entsprechen dem Stand der lokalen Sammlung
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt
- Der erste Generatorversuch wurde trotz 63 % Restkontingent durch einen
  nicht-fachlichen Ausfall des Quoten-Pollings abgebrochen. Der zweite,
  ergänzende Pass startete mit 61 % und endete regulär bei 44 %.

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 36 |
| Quellenbelege | 40 |
| Coverage-Einträge / nicht-regelnde Einträge / offene Einträge | 38 / 5 / 0 |
| Vorgeschlagene Profiländerungen / neue Profilpfade | 11 / 30 |
| Von Rego verwendete Eingabepfade / unbekannt | 15 / 0 |
| Datendateien / Datentabellen | 1 / 4 |
| Rego-Dateien / Zeilen | 2 / 211 |
| Generierte OPA-Tests | 4 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |
| Canonical Farm Profile direkt verändert | nein |

## Offene fachliche Punkte

- Die Rego-Entscheidung prüft nur beobachtbare, numerische Kernpflichten.
  Fehlende `input.oepul`-Daten ergeben keine Zustimmung, sondern
  `missing_oepul_observations`; die nötigen Werte bleiben Discover-Vorschläge.
- Geschlossene Tabellen zu RGVE, seltenen Sorten und regionalem Saatgut sind
  als Datenbestand übernommen. Für die Prüfung einer konkreten Saatmischung
  wären zusätzlich die tatsächlich verwendeten Arten erforderlich.
- Die Trockenheitsausnahmen 2026 sind fachlich als Ausnahme dokumentiert,
  aber nicht als positive Rego-Eligibility modelliert: vorzeitige bzw. dritte
  Nutzung setzt OPBIO voraus und lässt die BIO-Prämie der betroffenen Fläche
  entfallen.
- Die vier erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht jede Regel und Ausnahme ab.

Die veröffentlichten Dateien enthalten prüfbare Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
Identitäten und Prüfsummen stehen in `run.json` und den Artefakten.
