# Draft: `o6_15` mit `claude-opus-5-5`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_15` (Tierwohl – Behirtung). Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung
belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine
passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_15-opus-5.5-high-20260926`
- Modus: `discover`
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 31 min, 84 Turns; laut Claude Code
  678.873 Output-Tokens (davon 170.471 Thinking),
  Listenpreis-Äquivalent 36,89 USD
- Versuche: 3 (Fortsetzung derselben Sitzung mit dem Fehlerbericht von `finalize`, siehe `resumed_attempts` in `run.json`); Laufzeit und Tokens sind aufsummiert
- Limit-Guard: Versuch 1 wurde bei 2 % Restlimit kontrolliert unterbrochen
  (`aborted_usage_guard`) und nach dem Limit-Reset in derselben Sitzung
  fortgesetzt; der letzte Versuch startete bei 68 % und endete bei 63 %
- Maßnahmenspezifische Quelle: `o6_15_tierwohl-behirtung_2026_04.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 95 |
| Quellenbelege | 201 |
| Coverage-Einträge / offene Einträge | 132 / 0 |
| Vorgeschlagene Profil-Blattpfade | 93 in 7 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 14 / 0 |
| Datendateien / Datentabellen | 5 / 20 |
| Rego-Dateien / Zeilen | 7 / 1805 |
| Generierte OPA-Tests | 64 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |
| Canonical Farm Profile direkt verändert | nein |

Die Kennzahl „verwendete Eingabepfade“ erfasst nur direkte `input.`-Zugriffe.
Zugriffe über Funktionsparameter oder lokale Variablen zählen nicht; die
tatsächlich benötigten Pfade sind in `rules/profile_changes.json` und den
Regelbedingungen belegt. Mit den Terra-Runs ist die Kennzahl daher nur
eingeschränkt vergleichbar.

## Offene fachliche Punkte

- Drei Generatorversuche in derselben Sitzung: Versuch 1 wurde vom
  Nutzungsguard unterbrochen, Versuch 2 setzte fort und bestand die
  Grounding-Gates noch nicht, Versuch 3 behob die gemeldeten Fehler.
- Die Quellen enthalten Rechenfehler, die der Kandidat dokumentiert und korrekt
  nachrechnet: Beispiel 2 im Informationsblatt (Alm B 2.295,0 € statt
  2.430,0 €, Gesamtprämie daher 12.669,6 € statt 12.534,6 €) und das
  Modulationsbeispiel der Allgemeinen Teilnahmebedingungen (98,66 % statt
  98,70 %). Eigene Tests halten beide Abweichungen fest.
- Auslegungsbedürftig sind u. a. die Zuordnung der Milchvieh-RGVE zu den
  Hirtenblöcken, die Modulationsbasis, der Stichtag 15. Juli bei Weitertrieb und
  die Folge einer Milchkuh ohne Milchvieh-Voraussetzungen.
- Nicht quantifizierbar bzw. extern bleiben der Nationalpark Kalkalpen, ein
  Landes-Top-up und die Konditionalität (siehe `workspace/notes/assumptions.md`).
- Die 64 selbst erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht alle Regeln und Ausnahmen ab.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.

