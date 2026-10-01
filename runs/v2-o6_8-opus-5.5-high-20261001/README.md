# Draft: `o6_8` mit `claude-opus-5-5`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_8` (Erosionsschutz Acker). Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung
belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine
passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_8-opus-5.5-high-20261001`
- Modus: `discover`
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 35 min, 73 Turns; laut Claude Code
  531.347 Output-Tokens (davon 138.081 Thinking),
  Listenpreis-Äquivalent 27,25 USD
- Versuche: 2 (Fortsetzung derselben Sitzung mit dem Fehlerbericht von `finalize`, siehe `resumed_attempts` in `run.json`); Laufzeit und Tokens sind aufsummiert
- Limit-Guard: Versuch 1 lief ohne Abbruch; die Fortsetzung wurde zunächst
  bei 33 % Restlimit blockiert und nach dem Limit-Reset nachgeholt. Der
  letzte Versuch startete bei 86 % und endete bei 61 %
- Maßnahmenspezifische Quelle: `o6_8_erosionsschutz_acker_2026_04.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 114 |
| Quellenbelege | 241 |
| Coverage-Einträge / offene Einträge | 195 / 0 |
| Vorgeschlagene Profil-Blattpfade | 93 in 23 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 1 / 0 |
| Datendateien / Datentabellen | 8 / 30 |
| Rego-Dateien / Zeilen | 11 / 2109 |
| Generierte OPA-Tests | 92 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |
| Canonical Farm Profile direkt verändert | nein |

Die Kennzahl „verwendete Eingabepfade“ erfasst nur direkte `input.`-Zugriffe.
Zugriffe über Funktionsparameter oder lokale Variablen zählen nicht; die
tatsächlich benötigten Pfade sind in `rules/profile_changes.json` und den
Regelbedingungen belegt. Mit den Terra-Runs ist die Kennzahl daher nur
eingeschränkt vergleichbar.

## Offene fachliche Punkte

- Der erste Generatorversuch bestand die Grounding-Gates von `finalize`
  nicht; die Fortsetzung derselben Sitzung mit dem Fehlerbericht behob das.
- Auslegungsbedürftig laut `workspace/notes/assumptions.md` u. a.: der
  Anteil eines Schlags am Erosions-Eintragspfad bei Begrünungsstreifen (BAW),
  ob Sudangras unter „Mais und Sorghum“ für Untersaaten fällt, welche
  Codekombinationen außer MS+US und DS+US zulässig sind, und dass die
  Katastralgemeindeliste in Anhang F nur notwendige, nicht hinreichende
  Bedingung ist.
- Die Dürre-Ausnahmen 2026 (Ernteverpflichtung, Untersaat, DIV-Sonderregeln
  auf BAW-Flächen) sind eng nach Wortlaut umgesetzt; Prämiensätze 2023 nennt
  nur die ältere Fassung.
- Die 92 selbst erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht alle Regeln und Ausnahmen ab.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.

