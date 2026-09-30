# Draft: `o6_1a` mit `claude-opus-5-5`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_1a` (Umweltgerechte und biodiversitätsfördernde Bewirtschaftung). Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung
belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine
passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_1a-opus-5.5-high-20260929`
- Modus: `discover`
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 52 min, 108 Turns; laut Claude Code
  1.057.175 Output-Tokens (davon 245.731 Thinking),
  Listenpreis-Äquivalent 61,30 USD
- Versuche: 3 (Fortsetzung derselben Sitzung mit dem Fehlerbericht von `finalize`, siehe `resumed_attempts` in `run.json`); Laufzeit und Tokens sind aufsummiert
- Limit-Guard: Versuch 1 wurde bei 4 % Restlimit kontrolliert unterbrochen
  (`aborted_usage_guard`) und nach dem Limit-Reset in derselben Sitzung
  fortgesetzt; eine weitere Fortsetzung wurde bei 22 % blockiert und später
  nachgeholt. Der letzte Versuch startete bei 89 % und endete bei 61 %
- Maßnahmenspezifische Quelle: `o6_1a_ubb_2026_04.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 166 |
| Quellenbelege | 418 |
| Coverage-Einträge / offene Einträge | 141 / 1 |
| Vorgeschlagene Profil-Blattpfade | 190 in 67 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 0 / 0 |
| Datendateien / Datentabellen | 8 / 53 |
| Rego-Dateien / Zeilen | 19 / 3618 |
| Generierte OPA-Tests | 143 |
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
- Ein Coverage-Eintrag bleibt `unresolved`: Die Aufbewahrung der
  Pheromonfallen ist in SRL („bis zum Ende der Vegetationsperiode“) und
  Informationsblatt („bis 30.9.“) unterschiedlich geregelt; Rego verwendet
  den konkreteren 30.09.
- Weitere Widersprüche und Auslegungen (u. a. 10-ha-Grenze bei der
  Grünland-Ersatzerfüllung, 75/25-%-Regel mit Projektbestätigung,
  OPUBB/OPBIO 2026, Basismodulprämie bei Grünbrache, LSE-Deckel 80 je ha)
  stehen in `workspace/notes/assumptions.md`.
- Die Kennzahl der Rego-Eingabepfade ist 0, weil die Policy ausschließlich
  über Funktionsparameter und lokale Variablen auf das Profil zugreift; die
  benötigten Pfade sind in `rules/profile_changes.json` und den
  Regelbedingungen belegt.
- Die 143 selbst erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht alle Regeln und Ausnahmen ab.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.

