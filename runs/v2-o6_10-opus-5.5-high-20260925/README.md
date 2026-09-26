# Draft: `o6_10` mit `claude-opus-5-5`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_10` (Erosionsschutz Wein, Obst und Hopfen). Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung
belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine
passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_10-opus-5.5-high-20260925`
- Modus: `discover`
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 29 min, 79 Turns; laut Claude Code
  808.870 Output-Tokens (davon 212.451 Thinking),
  Listenpreis-Äquivalent 50,03 USD
- Versuche: 4 (Fortsetzung derselben Sitzung mit dem Fehlerbericht von `finalize`, siehe `resumed_attempts` in `run.json`); Laufzeit und Tokens sind aufsummiert
- Limit-Guard: Versuch 1 startete bei 72 % Restlimit und wurde bei 4 %
  kontrolliert unterbrochen (`aborted_usage_guard`); die Sitzung wurde nach dem
  Limit-Reset fortgesetzt. Ein weiterer Start wurde bei 49 % blockiert. Der
  letzte Versuch startete bei 64 % und endete bei 61 %
- Maßnahmenspezifische Quelle: `o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 91 |
| Quellenbelege | 191 |
| Coverage-Einträge / offene Einträge | 126 / 1 |
| Vorgeschlagene Profil-Blattpfade | 62 in 20 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 1 / 0 |
| Datendateien / Datentabellen | 5 / 38 |
| Rego-Dateien / Zeilen | 9 / 1768 |
| Generierte OPA-Tests | 56 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |
| Canonical Farm Profile direkt verändert | nein |

Die Kennzahl „verwendete Eingabepfade“ erfasst nur direkte `input.`-Zugriffe.
Zugriffe über Funktionsparameter oder lokale Variablen zählen nicht; die
tatsächlich benötigten Pfade sind in `rules/profile_changes.json` und den
Regelbedingungen belegt. Mit den Terra-Runs ist die Kennzahl daher nur
eingeschränkt vergleichbar.

## Offene fachliche Punkte

- Vier Generatorversuche in derselben Sitzung: Versuch 1 wurde vom
  Nutzungsguard unterbrochen, die Versuche 2–4 setzten mit dem
  Fehlerbericht von `finalize` fort; zuletzt blieb nur eine falsche
  Zeilenzahl der Dürre-2026-Tabelle im Dateninventar.
- Ein Coverage-Eintrag bleibt `unresolved`: Ob ein behördlich angeordneter
  Insektizideinsatz (Rebzikade, Maßnahme 12) die EOP-Anrechenbarkeit in o6_10
  berührt, ist nicht geregelt.
- Fehlt die Hangneigung, wird konservativ 0 % angenommen (niedrigste
  Prämienstufe); die Quelle übernimmt sie aus INVEKOS-GIS.
- Auslegungsbedürftig laut `workspace/notes/assumptions.md` u. a.:
  Selbstbegrünung vs. bestehende Begrünung (A-02), Terrassen unter 25 %
  Hangneigung (A-03), betriebliche oder schlagbezogene Kürzung des
  EOP-Zuschlags (A-04), Fristen nach Rodung/Neuauspflanzung (A-06/A-07) und
  der maßnahmenbezogene OP-Code (A-18).
- Die 56 selbst erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht alle Regeln und Ausnahmen ab.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.

