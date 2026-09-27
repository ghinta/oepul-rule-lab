# Draft: `o6_18` mit `claude-opus-5-5`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_18` (Naturschutz). Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung
belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine
passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_18-opus-5.5-high-20260927`
- Modus: `discover`
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 34 min, 90 Turns; laut Claude Code
  722.712 Output-Tokens (davon 201.206 Thinking),
  Listenpreis-Äquivalent 44,53 USD
- Versuche: 3 (Fortsetzung derselben Sitzung mit dem Fehlerbericht von `finalize`, siehe `resumed_attempts` in `run.json`); Laufzeit und Tokens sind aufsummiert
- Limit-Guard: Versuch 1 wurde bei 4 % Restlimit kontrolliert unterbrochen
  (`aborted_usage_guard`) und nach dem Limit-Reset in derselben Sitzung
  fortgesetzt; der letzte Versuch startete bei 64 % und endete bei 60 %
- Maßnahmenspezifische Quelle: `o6_18_naturschutz_2025_10.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 125 |
| Quellenbelege | 321 |
| Coverage-Einträge / offene Einträge | 115 / 0 |
| Vorgeschlagene Profil-Blattpfade | 112 in 30 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 1 / 0 |
| Datendateien / Datentabellen | 8 / 30 |
| Rego-Dateien / Zeilen | 9 / 2359 |
| Generierte OPA-Tests | 96 |
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
- Anhang I ist mit allen 332 Auflagencodes als Daten erfasst. Abgeleitete
  Merkmale (z. B. Mahdanzahl, Düngeregel, PSM-Verbot) sind Auslegungen des
  Auflagentextes; nur Teile der N-Auflagen und `$`-Parameter werden in Rego
  maschinell geprüft.
- **Unvollständig:** Aus Anhang L wurde nur die Zeile 18 übernommen, weil nur sie
  im Textextrakt zuverlässig lesbar war. Die übrigen Kombinationszeilen fehlen.
- Abweichungen zwischen Merkblatt und Anhang (SC02-Pflichtkombination,
  Großtrappen-Monitoring TA/TB, Quellentippfehler „BI02 und BI02“) sind in
  `workspace/notes/assumptions.md` dokumentiert.
- Die Kürzungsstufe konkreter Verstöße ist nicht öffentlich festgelegt; das
  mehrdeutige Profilfeld `is_contract_nature_area` wird durch den Code `NAT`
  in `land.parcels[].oepul.codes` ersetzt (Discover-Vorschlag).
- Die 96 selbst erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht alle Regeln und Ausnahmen ab.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.

