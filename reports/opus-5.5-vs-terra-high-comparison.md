# Claude Opus 5.5 gegen GPT-5.6 Terra: Vergleich der Discover-Runs

Stand: 2. Oktober 2026 · Auswertung von `origin/main` bei `b6e8917` · Zahlen
reproduzierbar mit `python3 -m rulelab site` (siehe
[Run Explorer](https://ghinta.github.io/oepul-rule-lab/))

## Kurzfazit

- **Opus deckt Terra inhaltlich ab und geht deutlich tiefer.** Opus zitiert
  99 % der Quellseiten, die Terra zitiert (530 von 534). Umgekehrt finden sich
  nur 37 % der Opus-Seiten bei Terra. Auf Zitatebene werden 73 % der
  Terra-Belege automatisch bei Opus wiedergefunden; jede manuell geprüfte
  Stichprobe der übrigen fand den Inhalt in einer anderen Opus-Regel mit
  anders zugeschnittenem Zitat.
- **Umfang:** Opus liefert 3,8× so viele Regeln, 9,4× so viele Belege, 18× so
  viele Tests und 11× so viel Rego. Weil Opus atomar (eine Bedingung je Regel)
  und Terra verdichtet formuliert, sind Regelzahlen allein kein Qualitätsmaß.
- **Ausführbarkeit:** 88 % der Opus-Regeln sind mit einem Rego-Symbol
  verknüpft und 89 % nennen Eingabepfade (Terra 48 % bzw. 62 %). Opus erzeugt
  0,79 Tests je Regel, Terra 0,16.
- **Sprache:** Terra formuliert in 15 von 26 Runs überwiegend auf Englisch,
  Opus durchgehend auf Deutsch. Für die deutschsprachigen DecisionTrace-Texte
  des Recommenders ist das ein praktischer Vorteil von Opus.
- **Datenbedarf:** Opus erfasst Antragsteller-, Teilnahme- und
  Abwicklungsbedingungen aus den Teilnahmebedingungen in allen 26 Maßnahmen;
  Terra nur vereinzelt. Beide benennen Profilpfade uneinheitlich.
- **Aufwand:** Opus kostete 377,60 USD Listenpreis-Äquivalent (Median
  13,76 USD je Maßnahme) bei rund 14 Stunden API-Zeit. Für Terra sind keine
  Kosten protokolliert.

**Empfehlung:** Opus-Runs als Referenzkatalog für den Recommender verwenden,
Terra-Runs als unabhängige Gegenprobe behalten. Wo beide Modelle abweichen,
entscheidet die fachliche Prüfung.

## Versuchsaufbau

| Merkmal | GPT-5.6 Terra | Claude Opus 5.5 |
| --- | --- | --- |
| Adapter | `codex-cli` | `claude-cli` (Claude Code headless) |
| Reasoning-Stufe | `high` | `high` |
| Maßnahmen | 26 | 26 |
| Quellen je Run | 8 (o6_22: alle 33) | 8 |
| Ausgangsprofil | identisch (`768688efd4`) | identisch (`768688efd4`) |
| Generierungsauftrag | identisch (Reparaturpass bei Wiederholung) | identisch |
| Zeitlimit je Versuch | 1 h | 2 h |
| Versuche | meist 1, einzelne 2–5 | 1–5; Nutzungs-Guard unterbricht, Fortsetzung in derselben Sitzung |
| Gates | alle gültig | alle gültig |

Die acht Quellen je Run sind die Sonderrichtlinie ÖPUL 2023 samt Anhängen, die
Allgemeinen Teilnahmebedingungen 2026-04, vier Bekanntmachungen 2026 und das
Informationsblatt der Maßnahme in seiner jeweils aktuellen Version (zehn
Blätter 2026, sechzehn 2025-10).

## Umfang der Artefakte

| Kennzahl (Summe 26 Maßnahmen) | Terra | Opus | Faktor |
| --- | ---: | ---: | ---: |
| Strukturierte Regeln | 731 | 2.750 | ×3,8 |
| Quellenreferenzen | 682 | 6.414 | ×9,4 |
| Coverage-Einträge | 933 | 3.957 | ×4,2 |
| Generierte Rego-Tests | 119 | 2.182 | ×18,3 |
| Rego-Dateien | 52 | 272 | ×5,2 |
| Rego-Zeilen | 4.453 | 50.043 | ×11,2 |
| Datentabellen | 81 | 892 | ×11,0 |
| Profiländerungs-Vorschläge | 104 | 721 | ×6,9 |
| Additive Profilpfade | 1.024 | 2.324 | ×2,3 |
| Geänderte bestehende Pfade | 0 | 6 | – |

### Je Maßnahme

`T` = Terra, `O` = Opus. „Terra-Seiten bei Opus“: Anteil der von Terra
zitierten Dokumentseiten, die Opus ebenfalls zitiert. „Terra-Belege bei Opus“:
Anteil der Terra-Zitate, die automatisch einem Opus-Zitat derselben Seite
zugeordnet werden.

| Maßnahme | Blatt | Regeln T / O | Referenzen T / O | Tests T / O | Profilpfade T / O | Terra-Seiten bei Opus | Terra-Belege bei Opus |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `o6_1a` | 2026-04 | 38 / 166 | 44 / 418 | 8 / 143 | 29 / 190 | 100 % | 66 % |
| `o6_1b` | 2026-04 | 36 / 200 | 40 / 588 | 4 / 111 | 30 / 192 | 100 % | 88 % |
| `o6_1c` | 2025-10 | 32 / 97 | 14 / 258 | 4 / 74 | 43 / 88 | 100 % | 79 % |
| `o6_2` | 2026-04 | 29 / 82 | 25 / 207 | 3 / 87 | 39 / 72 | 100 % | 56 % |
| `o6_3` | 2025-10 | 31 / 74 | 41 / 169 | 5 / 45 | 28 / 65 | 88 % | 56 % |
| `o6_4` | 2025-10 | 20 / 74 | 31 / 162 | 3 / 57 | 34 / 46 | 100 % | 74 % |
| `o6_5` | 2025-10 | 26 / 97 | 17 / 189 | 3 / 93 | 32 / 62 | 100 % | 65 % |
| `o6_6` | 2025-10 | 32 / 111 | 25 / 290 | 3 / 101 | 40 / 72 | 100 % | 92 % |
| `o6_7` | 2025-10 | 34 / 107 | 20 / 265 | 4 / 106 | 50 / 88 | 100 % | 55 % |
| `o6_8` | 2026-04 | 26 / 114 | 24 / 241 | 6 / 92 | 35 / 93 | 100 % | 79 % |
| `o6_9` | 2026-06 | 25 / 96 | 19 / 222 | 4 / 60 | 28 / 63 | 100 % | 63 % |
| `o6_10` | 2025-10 | 31 / 91 | 27 / 191 | 5 / 56 | 40 / 62 | 100 % | 63 % |
| `o6_11` | 2026-04 | 23 / 76 | 19 / 151 | 2 / 60 | 36 / 67 | 100 % | 90 % |
| `o6_12` | 2026-04 | 34 / 91 | 40 / 190 | 5 / 68 | 34 / 83 | 100 % | 72 % |
| `o6_13` | 2025-10 | 26 / 80 | 26 / 169 | 4 / 77 | 38 / 76 | 100 % | 65 % |
| `o6_14` | 2026-04 | 30 / 126 | 22 / 311 | 3 / 122 | 52 / 136 | 100 % | 82 % |
| `o6_15` | 2026-04 | 25 / 95 | 24 / 201 | 5 / 64 | 50 / 93 | 100 % | 79 % |
| `o6_16` | 2026-04 | 34 / 131 | 30 / 338 | 9 / 140 | 94 / 110 | 100 % | 67 % |
| `o6_17` | 2025-10 | 28 / 118 | 31 / 303 | 4 / 112 | 53 / 68 | 100 % | 61 % |
| `o6_18` | 2025-10 | 25 / 125 | 19 / 321 | 7 / 96 | 20 / 112 | 100 % | 90 % |
| `o6_19` | 2025-10 | 30 / 102 | 31 / 199 | 5 / 76 | 43 / 97 | 100 % | 61 % |
| `o6_20` | 2025-10 | 32 / 97 | 23 / 196 | 4 / 61 | 52 / 92 | 100 % | 74 % |
| `o6_21` | 2025-10 | 17 / 124 | 18 / 241 | 4 / 75 | 33 / 115 | 100 % | 83 % |
| `o6_22` | 2025-10 | 24 / 126 | 22 / 272 | 4 / 84 | 47 / 90 | 100 % | 96 % |
| `o6_23` | 2025-10 | 22 / 88 | 25 / 182 | 7 / 60 | 20 / 46 | 100 % | 84 % |
| `o6_24` | 2025-10 | 21 / 62 | 25 / 140 | 4 / 62 | 24 / 46 | 95 % | 72 % |

## Abdeckung der Quellen

Die Belege (`evidence_text`) sind wörtliche Quellzitate. Deshalb lassen sie
sich unabhängig von der Sprache der Regeltexte vergleichen. Gemessen wurde auf
zwei Ebenen:

| Ebene | Terra → Opus | Opus → Terra |
| --- | ---: | ---: |
| Zitierte Dokumentseiten | 99 % (530 / 534) | 37 % (530 / 1.452) |
| Wörtliche Belege (automatischer Abgleich) | 73 % | 8 % |

Abgleichsregel für Belege: gleiche Datei und Seite, mindestens drei gemeinsame
Inhaltswörter und mindestens 60 % der Inhaltswörter des kürzeren Zitats. Die
nicht automatisch zugeordneten Terra-Belege sind überwiegend kurze Überschriften
oder Zitate, die Opus anders zuschneidet oder auf mehrere Belege aufteilt.
Stichproben, jeweils mit dem passenden Inhalt bei Opus gefunden:

| Terra-Beleg | Fundstelle bei Opus |
| --- | --- |
| o6_14: mindestens 3,00 ha Almweide mit 3,00 RGVE | `O614-ACCESS-001`, `O614-ACCESS-002` |
| o6_11: keine Prämie für sonstige Weinflächen, Walnüsse, Edelkastanien | `O611-NO-PREMIUM-TYPES` |
| o6_12: Schnittweingärten zählen zur Weinfläche, Rebschulen nicht | `o6_12.def.cutting_vineyard_counts_as_wine`, `o6_12.def.vine_nursery_not_wine` |
| o6_17: tierhaltend ab 0,30 RGVE | `O617-LIV-DEF` |
| o6_22: Dokumentation der Kompostmieten | `O622-SUP-COMP-*` |
| o6_2: Weiterbildung bis 31.12.2025 | `O6_2-OBL-TRAIN-001` |

Die einzigen von Opus nicht zitierten Terra-Seiten betreffen Bekanntmachungen,
die Opus im Coverage-Ledger bewusst als nicht anwendbar begründet hat. Beispiel
o6_3: Terra übernimmt die Dürre-Ausnahme zur Ernteverpflichtung; Opus vermerkt,
dass diese nur für Ackerflächen ohne Ackerfutter gilt und Heuwirtschaftsflächen
der Mahd- und Weideverpflichtung unterliegen. Das ist die präzisere Lesart.

### Herkunft der Belege

| Quelle | Terra | Opus |
| --- | ---: | ---: |
| Informationsblatt der Maßnahme | 47 % | 39 % |
| Allgemeine Teilnahmebedingungen | 28 % | 25 % |
| Sonderrichtlinie ÖPUL 2023 | 14 % | 27 % |
| SRL-Anhänge | 5 % | 4 % |
| Bekanntmachungen 2026 | 6 % | 4 % |

Opus stützt sich fast doppelt so stark auf die Sonderrichtlinie. 42 % der
Opus-Belege stammen aus maßnahmenübergreifenden Teilen (Teilnahmebedingungen
und SRL-Allgemeinteil, Seiten 1–27). Dieselben allgemeinen Regeln stehen daher
in 26 Runs; für den Recommender gehören sie in ein gemeinsames Modul statt
26-fach in jede Maßnahme.

## Ausführbarkeit und Form

| Kennzahl | Terra | Opus |
| --- | ---: | ---: |
| Regeln mit Rego-Symbol | 48 % | 88 % |
| Regeln mit Eingabepfaden | 62 % | 89 % |
| Generierte Tests je Regel | 0,16 | 0,79 |
| Regeltexte überwiegend Englisch | 15 von 26 Runs | 0 von 26 Runs |
| Coverage-Einträge „unresolved“ | 6 | 23 |

Terra verdichtet mehrere Bedingungen in eine Regel. Beispiel o6_21: Terra fasst
Gruppenhaltung, planbefestigte Liegefläche, Perforationsgrenze und Einstreu in
`O621.GROUP.LITTER` zusammen; Opus führt dieselben Bedingungen als
`O6_21-HOUS-006` bis `O6_21-HOUS-008` getrennt, jeweils mit eigenem Beleg und
Rego-Symbol. Für eine erklärbare Entscheidung je Bedingung (DecisionTrace) ist
die atomare Form direkt verwendbar.

## Regeln nach fachlicher Kategorie

Näherung über den frei benannten `rule_type`, zugeordnet mit
`config/analysis/rule-categories-v1.json`. Phase: A = vor dem Antrag prüfbar,
B = Bewirtschaftung, C = Abwicklung.

| Kategorie | Phase | Terra | Anteil | Opus | Anteil | Faktor |
| --- | :---: | ---: | ---: | ---: | ---: | ---: |
| Zugang und Förderfähigkeit | A | 163 | 22 % | 424 | 15 % | ×2,6 |
| Prämie und Berechnung | A | 99 | 14 % | 397 | 14 % | ×4,0 |
| Kombinationen und Doppelförderung | A | 29 | 4 % | 103 | 4 % | ×3,6 |
| Optionen und Zuschläge | A | 41 | 6 % | 49 | 2 % | ×1,2 |
| Bewirtschaftungsauflagen | B | 116 | 16 % | 499 | 18 % | ×4,3 |
| Ausnahmen und Sonderregeln (inkl. 2026) | B | 45 | 6 % | 256 | 9 % | ×5,7 |
| Aufzeichnung, Meldung und Codierung | B | 49 | 7 % | 89 | 3 % | ×1,8 |
| Antrag, Vertrag und Fristen | C | 98 | 13 % | 480 | 17 % | ×4,9 |
| Abwicklung, Kontrolle und Sanktion | C | 69 | 9 % | 205 | 7 % | ×3,0 |
| Definitionen und Hinweise | – | 22 | 3 % | 248 | 9 % | ×11,3 |

Der Mehrumfang von Opus liegt vor allem bei Definitionen, Ausnahmen,
Verfahren und Auflagen. Bei den für eine Empfehlung entscheidenden Kategorien
(Zugang, Prämie, Kombination) liefert Opus das 2,6- bis 4-fache. Nur bei
Optionen und Zuschlägen liegen beide nahe beieinander.

## Vorgeschlagene Profilvariablen

Opus macht 721 Vorschläge mit 2.324 Pfaden, Terra 104 Vorschläge mit 1.024
Pfaden. Terra schlägt eher große maßnahmeneigene Blöcke vor (`o6_6`, `o6_9`,
`oepul.o6_16`), Opus feinere Strukturen. Die Zuordnung zu 41 fachlichen
Konzepten (`config/analysis/profile-concepts-v1.json`) zeigt die Unterschiede:

| Konzept | Klasse | Maßnahmen Opus / Terra | AMA |
| --- | :---: | ---: | --- |
| Rechtsform und Antragstellertyp | A | 26 / 4 | nein |
| Beteiligung der öffentlichen Hand | A | 26 / 3 | nein |
| Erstes ÖPUL-Teilnahmejahr | A | 26 / 9 | teilweise |
| Abmeldung, Ausstieg, Maßnahmenwechsel | C | 26 / 14 | teilweise |
| Übernahme, Bewirtschafterwechsel, Flächenweitergabe | C | 26 / 6 | teilweise |
| Maßnahmenteilnahme, Antrag, Vertragsbeginn | A | 25 / 21 | ja |
| Geschützter Anbau | A | 24 / 4 | ja |
| Aktive:r Landwirt:in | A | 22 / 6 | ja |
| ÖPUL-Codes je Schlag | A | 20 / 14 | ja |
| Lage (Österreich, Bezirk, KG) | A | 20 / 6 | ja |
| Konditionalität, Verstöße, Sanktionen | C | 20 / 5 | nein |
| Kontrollen | C | 19 / 0 | nein |
| Schutz- und Gebietskulissen | A | 18 / 5 | teilweise |
| Einzeltiere (Ohrmarke, Rasse, Zu- und Abgang) | A | 17 / 11 | ja |
| Biodiversitäts-, Naturschutz-, EBW-Flächen | B | 5 / 8 | teilweise |

Die vollständige, filterbare Liste aller 3.439 Pfade steht im
[Run Explorer](https://ghinta.github.io/oepul-rule-lab/#variablen). Gemeinsam
ist beiden Modellen das Namensproblem: Dieselbe Angabe erscheint als
`in_austria`, `is_in_austria` oder `located_in_austria`, verteilt auf bis zu
sechs Namensräume. Opus ändert zusätzlich sechs Auswahllisten des bestehenden
Profils (Tierarten, Tierkategorien, Bodenbearbeitung, Ausbringungstechnik,
Biodiversitätsflächen-Typen).

## Offene Punkte aus den Coverage-Ledgern

| Art | Opus | Terra |
| --- | ---: | ---: |
| Verweis auf die GSP-AV, die nicht im Quellenpaket ist (§§ 6, 16, 25, 31, 34, 42–47) | 11 | – |
| Verlinkte AMA-News fehlen (25.08.2026 Aufzeichnungspflichten o6_16; 02.09.2026 Meldepflichten tierbezogene Maßnahmen) | 6 | – |
| Abweichung zwischen Quellen (SRL gegen Informationsblatt, Rechenbeispiel ATB) | 3 | – |
| Anwendbarkeit unklar (Revisionsklausel Art. 70 bei Art.-72-Maßnahmen, Rebzikade-Ausstieg) | 3 | – |
| Daten außerhalb des Profils (GIS-Kulissen, Nachweise, Übernahmen) | – | 4 |
| Nicht ausführbar abbildbar (Gesamtobergrenze, Kombinationsmatrix als Fließtext) | – | 2 |

Opus dokumentiert deutlich mehr Grenzen des Quellenpakets. Daraus folgen
konkrete Ergänzungen für das Paket: die GSP-AV und die zwei fehlenden
AMA-News.

## Aufwand

Kosten laut Claude Code (`costBasis: list`, also Listenpreis-Äquivalent, nicht
die tatsächliche Abrechnung im Abo), kumuliert über alle Fortsetzungen einer
Sitzung:

| Kennzahl | Opus |
| --- | ---: |
| Kosten gesamt | 377,60 USD |
| Median je Maßnahme | 13,76 USD (Spanne 9,38–27,75) |
| API-Zeit gesamt | 830 Minuten |
| Median API-Zeit je Maßnahme | 31 Minuten |
| Versuche je Maßnahme | 1–5 (Median 3) |

Der Codex-Adapter protokolliert für Terra weder Kosten noch Token. Ein
Kostenvergleich ist daher nicht möglich.

## Einschränkungen

- Zeitlimit und Fortsetzungen unterscheiden sich (Terra 1 h, Opus 2 h je
  Versuch, Opus mit bis zu fünf Fortsetzungen).
- Terra o6_22 lief mit allen 33 Quellen.
- Die Regelkategorien sind eine Näherung über frei benannte Typen.
- Es gibt noch keinen Goldstandard. Vollständigkeit ist relativ zwischen den
  Modellen gemessen; fachliche Korrektheit ist damit nicht belegt.

## Reproduzierbarkeit

```bash
python3 -m rulelab site           # Daten der Seite aus runs/* erzeugen
python3 -m rulelab site --check   # prüfen, ob docs/assets/data.js aktuell ist
python3 -m rulelab compare runs/<terra-run> runs/<opus-run>
```
