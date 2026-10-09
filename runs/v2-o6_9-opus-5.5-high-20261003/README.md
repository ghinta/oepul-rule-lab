# Draft: `o6_9` mit `claude-opus-5-5` (Rerun mit aktualisiertem Quellenpack)

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_9` (Bodennahe Ausbringung flüssiger
Wirtschaftsdünger und Gülleseparation) erneut, diesmal mit den zusätzlichen
Rechtsquellen GSP-AV und NAPV. Er liefert einen quellengebundenen, ausführbaren
Regelkandidaten. Die technische Validierung belegt weder fachliche
Vollständigkeit noch Rechtsverbindlichkeit oder eine passende Empfehlung für
einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_9-opus-5.5-high-20261003`
- Modus: `discover`, Quality Gate `v1` (vergleichbar mit allen bisherigen Runs)
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 28 min API-Zeit; laut Claude Code 201.427 Output-Tokens (davon
  54.034 Thinking), Listenpreis-Äquivalent 15,24 USD
- Versuche: 2 (Fortsetzung derselben Sitzung mit dem Fehlerbericht von
  `finalize`, siehe `resumed_attempts` in `run.json`); Tokens und Kosten sind
  aufsummiert
- Limit-Guard: Versuch 1 startete bei 69 % und endete regulär bei 8 %
  Restlimit; Versuch 2 startete nach dem Reset bei 91 % und endete bei 72 %
- Maßnahmenspezifische Quelle: `o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen, **GSP-AV (Fassung
  28.01.2026)**, **NAPV (Fassung 28.10.2024)** und vier amtliche Hinweise aus
  2026 (Quellenpack-Provenance `20261003T110742003580Z`)
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 89 |
| Quellenbelege | 165 |
| Coverage-Einträge / offene Einträge | 145 / 2 |
| Vorgeschlagene Profil-Blattpfade | 96 in 25 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 4 / 0 |
| Datendateien / Datentabellen | 10 / 29 |
| Rego-Dateien / Zeilen | 8 / 1235 |
| Generierte OPA-Tests | 82 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |

Die Kennzahl „verwendete Eingabepfade“ erfasst nur direkte `input.`-Zugriffe.

## Änderung gegenüber `v2-o6_9-opus-5.5-high-20260925`

| Signal | 25.09. | 03.10. |
|---|---:|---:|
| Quellen im Workspace | 8 | 10 |
| Strukturierte Regeln | 96 | 89 |
| Quellenbelege | 222 | 165 |
| davon GSP-AV / NAPV | – | 19 / 8 |
| Offene Coverage-Einträge | 0 | 2 |
| Profil-Blattpfade | 63 | 96 |
| Generierte OPA-Tests | 60 | 82 |
| Kosten (Listenpreis-Äquivalent, laut `run.json`) | 11,05 USD | 15,24 USD |

- Die neuen Rechtsquellen werden genutzt: GSP-AV für Abwicklung und Verfahren
  (Mengenbeantragung bis 30. November, Fristen, höhere Gewalt, Änderungs- und
  Übergabemeldungen, Kürzungen und Sanktionen, Auszahlung), NAPV für
  Stickstoffbedarf düngungswürdiger Flächen sowie Sperrfristen und
  Ausbringungsverbote.
- Weniger Regeln und Belege bedeuten nicht weniger Abdeckung: Die
  Coverage-Einträge sind gleich zahlreich; SRL-Belege wurden teils durch die
  spezifischeren GSP-AV-/NAPV-Belege ersetzt. Ein Einzelregelvergleich steht in
  `artifacts/compare-previous.json`.
- Neu offen (`unresolved`): zwei NAPV-Stellen (Anlage 3 Tabelle 1 Fußnote 1,
  60 kg N bei nicht beimpftem Saatgut; Anlage 3 Abschnitt VI, Ackerfutter
  kleebetont 40 kg N/ha), die dem Informationsblatt widersprechen, das
  Leguminosen-Reinbestände als nicht düngungswürdig nennt. Umgesetzt ist die
  Linie von Informationsblatt und SRL.
- Versuch 1 scheiterte an `finalize` (überlappende Profilvorschläge
  `oepul_measures.o6_9` neben Unterpfaden, ein nicht auf der zitierten Seite
  gefundener Beleg, zwei ungenutzte Referenzen, ein GSP-AV-Coverage-Eintrag
  außerhalb der geprüften Seiten); Versuch 2 behob alle Punkte.

Kosten und Tokens meldet Claude Code bei Fortsetzungen derselben Sitzung kumulativ; maßgeblich ist daher der Wert des letzten Versuchs in `run.json` (`generator_result`). Das README des Vorgänger-Runs addiert diese kumulativen Werte je Versuch und nennt deshalb zu hohe Kosten und Tokens.

## Offene fachliche Punkte

Siehe `workspace/notes/assumptions.md`, u. a.: Einstufung nicht gedeckter
Jungsauen (SRL ab 50 kg vs. Informationsblatt ab 32 kg), proportionale Kürzung
über alle Verfahren bei Überschreitung von 50 m³/ha, Vorrang der
Rinderdatenbank-GVE vor Anhang-A-Faktoren und die oben genannten
NAPV-Widersprüche zu Leguminosen.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.
