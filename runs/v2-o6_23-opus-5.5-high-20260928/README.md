# Draft: `o6_23` mit `claude-opus-5-5`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_23` (Natura 2000 und andere Schutzgebiete – Landwirtschaft). Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung
belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine
passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_23-opus-5.5-high-20260928`
- Modus: `discover`
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 24 min, 70 Turns; laut Claude Code
  466.596 Output-Tokens (davon 138.076 Thinking),
  Listenpreis-Äquivalent 29,27 USD
- Versuche: 3 (Fortsetzung derselben Sitzung mit dem Fehlerbericht von `finalize`, siehe `resumed_attempts` in `run.json`); Laufzeit und Tokens sind aufsummiert
- Limit-Guard: Versuch 1 wurde bei 1 % Restlimit kontrolliert unterbrochen
  (`aborted_usage_guard`) und nach dem Limit-Reset in derselben Sitzung
  fortgesetzt; der letzte Versuch startete und endete bei 62 %
- Maßnahmenspezifische Quelle: `o6_23_natura2000-landwirtschaft_2025_10.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 88 |
| Quellenbelege | 182 |
| Coverage-Einträge / offene Einträge | 140 / 1 |
| Vorgeschlagene Profil-Blattpfade | 46 in 9 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 1 / 0 |
| Datendateien / Datentabellen | 3 / 20 |
| Rego-Dateien / Zeilen | 6 / 1337 |
| Generierte OPA-Tests | 60 |
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
- Ein Coverage-Eintrag bleibt `unresolved`: Die Revisionsklausel (SRL 1.7.5)
  bezieht sich auf Art. 70; o6_23 ist eine Art.-72-Intervention.
- Offen bleiben, ob die in den Auflagentiteln genannte Nutzungshäufigkeit bei
  GI05/GI06/GI07 eine sanktionsrelevante Verpflichtung ist (umgesetzt nur als
  Hinweis) und welche Prämie bei unzulässiger Kombination auf demselben Schlag
  entfällt.
- Ein maßnahmenbezogener OP-Code ist in den Quellen nicht genannt. Anhang L
  wurde aus dem PDF-Layout rekonstruiert (siehe
  `workspace/notes/assumptions.md`).
- Die 60 selbst erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht alle Regeln und Ausnahmen ab.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.

