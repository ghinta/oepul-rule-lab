# Draft: `o6_20` mit `claude-opus-5-5`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_20` (Tierwohl – Weide). Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung
belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine
passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_20-opus-5.5-high-20260928`
- Modus: `discover`
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 34 min, 91 Turns; laut Claude Code
  743.492 Output-Tokens (davon 186.226 Thinking),
  Listenpreis-Äquivalent 42,32 USD
- Versuche: 3 (Fortsetzung derselben Sitzung mit dem Fehlerbericht von `finalize`, siehe `resumed_attempts` in `run.json`); Laufzeit und Tokens sind aufsummiert
- Limit-Guard: Versuch 1 wurde bei 4 % Restlimit kontrolliert unterbrochen
  (`aborted_usage_guard`) und nach dem Limit-Reset in derselben Sitzung
  fortgesetzt; der letzte Versuch startete bei 72 % und endete bei 59 %
- Maßnahmenspezifische Quelle: `o6_20_tierwohl_weide_2025_10.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 97 |
| Quellenbelege | 196 |
| Coverage-Einträge / offene Einträge | 216 / 0 |
| Vorgeschlagene Profil-Blattpfade | 92 in 6 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 1 / 0 |
| Datendateien / Datentabellen | 5 / 23 |
| Rego-Dateien / Zeilen | 12 / 1835 |
| Generierte OPA-Tests | 61 |
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
- Offen: ob bei gekoppelter Stützung neben der Basisprämie auch der
  150-Tage-Zuschlag halbiert wird (Informationsblatt vs. SRL); umgesetzt ist
  nur die Halbierung der Basisprämie.
- Nicht quantifiziert sind „unmittelbar“ (Abmeldung von Rindern) und der
  „wesentliche Teil des Tages“ beim Grundfutterbedarf; beide sind Eingaben.
- Fehlt ein Boolean zu einer Verpflichtung, wird Einhaltung angenommen – keine
  Verstöße ohne Datengrundlage. Esel fehlen in der Prämientabelle des
  Informationsblatts, stehen aber in der SRL.
- Der tatsächliche Prämiensatz hängt vom EGFL-Budget ab; die Policy liefert
  das Prämienband. Weitere Auslegungen in `workspace/notes/assumptions.md`.
- Die 61 selbst erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht alle Regeln und Ausnahmen ab.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.

