# Draft: `o6_3` mit `claude-opus-5-5`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_3` (Heuwirtschaft). Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung
belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine
passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_3-opus-5.5-high-20260930`
- Modus: `discover`
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 26 min, 71 Turns; laut Claude Code
  398.624 Output-Tokens (davon 89.897 Thinking),
  Listenpreis-Äquivalent 22,75 USD
- Versuche: 2 (Fortsetzung derselben Sitzung mit dem Fehlerbericht von `finalize`, siehe `resumed_attempts` in `run.json`); Laufzeit und Tokens sind aufsummiert
- Limit-Guard: Versuch 1 lief ohne Abbruch; die Fortsetzung wurde zunächst
  bei 4 % Restlimit blockiert und nach dem Limit-Reset nachgeholt. Der letzte
  Versuch startete bei 87 % und endete bei 70 %
- Maßnahmenspezifische Quelle: `o6_3_heuwirtschaft_2025_10.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 74 |
| Quellenbelege | 169 |
| Coverage-Einträge / offene Einträge | 125 / 0 |
| Vorgeschlagene Profil-Blattpfade | 65 in 34 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 1 / 0 |
| Datendateien / Datentabellen | 13 / 35 |
| Rego-Dateien / Zeilen | 8 / 1089 |
| Generierte OPA-Tests | 45 |
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
- „Überwiegender Teil der Vegetationsperiode“ bei der Grünfütterung wird als
  mehr als 50 % der Tage vom 1.4. bis 30.9. umgesetzt (mindestens 92 Tage).
- Offen laut `workspace/notes/assumptions.md`: ob ein stillgelegter, vor
  Vertragsbeginn angeschaffter Mähaufbereiter als „am Betrieb vorhanden“ gilt,
  ob reine Einstreu-Streuwiesen zur Futterfläche zählen und ob bei Wegfall der
  Kombinationsverpflichtung ab dem 2. Jahr zusätzlich eine Rückforderung folgt.
- Die 45 selbst erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht alle Regeln und Ausnahmen ab.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.

