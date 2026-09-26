# Draft: `o6_13` mit `claude-opus-5-5`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_13` (Einsatz von Nützlingen im geschützten Anbau). Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung
belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine
passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_13-opus-5.5-high-20260926`
- Modus: `discover`
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 30 min, 78 Turns; laut Claude Code
  689.954 Output-Tokens (davon 152.627 Thinking),
  Listenpreis-Äquivalent 36,24 USD
- Versuche: 3 (Fortsetzung derselben Sitzung mit dem Fehlerbericht von `finalize`, siehe `resumed_attempts` in `run.json`); Laufzeit und Tokens sind aufsummiert
- Limit-Guard: Versuch 1 wurde bei 4 % Restlimit kontrolliert unterbrochen
  (`aborted_usage_guard`) und nach dem Limit-Reset in derselben Sitzung
  fortgesetzt; der letzte Versuch startete bei 66 % und endete bei 65 %
- Maßnahmenspezifische Quelle: `o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 80 |
| Quellenbelege | 169 |
| Coverage-Einträge / offene Einträge | 137 / 0 |
| Vorgeschlagene Profil-Blattpfade | 76 in 23 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 1 / 0 |
| Datendateien / Datentabellen | 4 / 31 |
| Rego-Dateien / Zeilen | 10 / 1679 |
| Generierte OPA-Tests | 77 |
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
  Nutzungsguard unterbrochen, Versuch 2 setzte ihn fort und bestand die
  Grounding-Gates noch nicht, Versuch 3 behob die gemeldeten Fehler.
- Offen bleibt, ob der flächendeckende Nützlingseinsatz je Schlag erfüllt sein
  muss oder „zumindest ein Gewächshaus“ des Betriebs genügt; Flächendeckung und
  Anrechenbarkeit (Registereintrag, Aufwandsmenge, Ersatz eines PSM-Einsatzes)
  sind Eingaben.
- Ein maßnahmenbezogener OP-Code ist in den Quellen nicht genannt; die
  Kürzungsstufe wird als Eingabe übernommen.
- Weitere Auslegungen (Dürre 2026, Betriebsmindestgröße, Nationalparks,
  Vertragsverlängerung, Übernahme) stehen in `workspace/notes/assumptions.md`.
- Die 77 selbst erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht alle Regeln und Ausnahmen ab.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.

