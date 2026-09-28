# Draft: `o6_19` mit `claude-opus-5-5`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_19` (Ergebnisorientierte Bewirtschaftung). Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung
belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine
passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_19-opus-5.5-high-20260927`
- Modus: `discover`
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 32 min, 82 Turns; laut Claude Code
  694.590 Output-Tokens (davon 153.636 Thinking),
  Listenpreis-Äquivalent 39,49 USD
- Versuche: 3 (Fortsetzung derselben Sitzung mit dem Fehlerbericht von `finalize`, siehe `resumed_attempts` in `run.json`); Laufzeit und Tokens sind aufsummiert
- Limit-Guard: Versuch 1 wurde bei 3 % Restlimit kontrolliert unterbrochen
  (`aborted_usage_guard`) und nach dem Limit-Reset in derselben Sitzung
  fortgesetzt; der letzte Versuch startete bei 71 % und endete bei 59 %
- Maßnahmenspezifische Quelle: `o6_19_ergebnisorientierte_bewirtschaftung_2025_10.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 102 |
| Quellenbelege | 199 |
| Coverage-Einträge / offene Einträge | 151 / 0 |
| Vorgeschlagene Profil-Blattpfade | 97 in 94 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 12 / 0 |
| Datendateien / Datentabellen | 9 / 28 |
| Rego-Dateien / Zeilen | 12 / 2010 |
| Generierte OPA-Tests | 76 |
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
- Für 2023 enthalten die Quellen keine EBW-Flächensätze (Anhang K gilt ab
  01.01.2024); Rego meldet dafür `base_rate_not_found`. Die Vogeltabelle hat
  nur Sätze für Erhaltungszustand A.
- Auffällige Tabellenwerte in Anhang K (z. B. „Feuchte bis nasse Fettwiese“
  A/schwer 1.124,0 statt vermutlich 1.112,4; „Mäh-Halbtrockenrasen“ B/schwer
  über A/schwer) wurden wörtlich übernommen, nicht korrigiert. Die Zuordnung
  der Tier-Indikatoren EBAT02–EBAT07 folgt der Zeilenlage der Textextraktion.
- Offen: ob die allgemeinen Mindestbewirtschaftungskriterien gegenüber der
  Regel „jedes zweite Jahr“ abweichen, und welche Prämie bei unzulässiger
  Einzelflächenkombination entfällt.
- Die 76 selbst erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht alle Regeln und Ausnahmen ab.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.

