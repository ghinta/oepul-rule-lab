# Draft: `o6_12` mit `claude-opus-5-5`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_12` (Insektizidverzicht Wein, Obst und Hopfen). Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung
belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine
passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_12-opus-5.5-high-20260926`
- Modus: `discover`
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 25 min, 78 Turns; laut Claude Code
  355.231 Output-Tokens (davon 95.618 Thinking),
  Listenpreis-Äquivalent 19,93 USD
- Versuche: 2 (Fortsetzung derselben Sitzung mit dem Fehlerbericht von `finalize`, siehe `resumed_attempts` in `run.json`); Laufzeit und Tokens sind aufsummiert
- Limit-Guard: Start bei 75 %, letzte Messung
  60 % Restlimit; kein Abbruch
- Maßnahmenspezifische Quelle: `o6_12_insektizidverzicht_wein_obst_hopfen_2026_04.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 91 |
| Quellenbelege | 190 |
| Coverage-Einträge / offene Einträge | 178 / 1 |
| Vorgeschlagene Profil-Blattpfade | 83 in 17 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 2 / 0 |
| Datendateien / Datentabellen | 3 / 25 |
| Rego-Dateien / Zeilen | 9 / 1655 |
| Generierte OPA-Tests | 68 |
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
  nicht. Seine Fortsetzung wurde zunächst vom Nutzungsguard blockiert
  (20 % Restlimit) und nach dem Limit-Reset nachgeholt.
- Ein Coverage-Eintrag bleibt `unresolved`: Flächenabweichungen nach
  §§ 42–47 GSP-AV, die nicht im Quellpaket liegen.
- Die präzisere Logik der Rebzikaden-Meldung 2026 zu chemisch-synthetischen
  Mitteln bei behördlicher Anordnung wird für alle Jahre angewendet; ob das
  vor 2026 so gilt, ist offen.
- Der Rebzikaden-Ausstieg 2026 wird schon bei mindestens einem Weinschlag
  geprüft; die AMA-Genehmigung ist eine Eingabe.
- Weitere Auslegungen (Sonstige Weinflächen, Abgangstoleranz, Reihenfolge der
  Kürzungen, Anhang-L-Rekonstruktion aus dem PDF-Layout) stehen in
  `workspace/notes/assumptions.md`.
- Die 68 selbst erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht alle Regeln und Ausnahmen ab.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.

