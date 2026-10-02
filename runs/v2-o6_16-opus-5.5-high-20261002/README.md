# Draft: `o6_16` mit `claude-opus-5-5`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_16` (Vorbeugender Grundwasserschutz – Acker). Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung
belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine
passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_16-opus-5.5-high-20261002`
- Modus: `discover`
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 38 min, 90 Turns; laut Claude Code
  840.615 Output-Tokens (davon 217.202 Thinking),
  Listenpreis-Äquivalent 44,20 USD
- Versuche: 3 (Fortsetzung derselben Sitzung mit dem Fehlerbericht von `finalize`, siehe `resumed_attempts` in `run.json`); Laufzeit und Tokens sind aufsummiert
- Limit-Guard: Versuch 1 wurde bei 3 % Restlimit kontrolliert beendet und
  nach dem Limit-Reset fortgesetzt. Versuch 2 bestand `finalize` wegen
  überlappender Profil-Änderungsvorschläge nicht; Versuch 3 behob das,
  startete bei 66 % und endete bei 62 % Restlimit
- Maßnahmenspezifische Quelle: `o6_16_vorbeugender_grundwasserschutz_acker_2026_04.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 131 |
| Quellenbelege | 338 |
| Coverage-Einträge / offene Einträge | 138 / 2 |
| Vorgeschlagene Profil-Blattpfade | 110 in 15 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 4 / 0 |
| Datendateien / Datentabellen | 6 / 49 |
| Rego-Dateien / Zeilen | 17 / 2753 |
| Generierte OPA-Tests | 140 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |
| Canonical Farm Profile direkt verändert | nein |

Die Kennzahl „verwendete Eingabepfade“ erfasst nur direkte `input.`-Zugriffe.
Zugriffe über Funktionsparameter oder lokale Variablen zählen nicht; die
tatsächlich benötigten Pfade sind in `rules/profile_changes.json` und den
Regelbedingungen belegt. Mit den Terra-Runs ist die Kennzahl daher nur
eingeschränkt vergleichbar.

## Offene fachliche Punkte

- Der Generator brauchte drei Anläufe: Versuch 1 endete am Limit-Guard,
  Versuch 2 scheiterte an überlappenden Discover-Vorschlägen (z. B.
  `farm.oepul` neben `farm.oepul.o6_16.*`), Versuch 3 bestand alle Gates.
- Zwei Coverage-Einträge bleiben `unresolved`: die Abweichungen zwischen SRL
  und Infoblatt 2026 (Sudangras, Gewichtsgrenzen der Schweinefütterung,
  Ackerfutter; umgesetzt nach dem Infoblatt) und die AMA-Meldung vom
  25.08.2026 zu Aufzeichnungspflichten, die nicht als Quelle vorliegt.
- Gebietskulisse: Die KG-Liste aus Anhang G wird als Kulisse ab 2025
  behandelt; für Jahre bis 2024 kann sie zu weit sein. Die Teilgebiete für
  den Reduktionsfaktor 80 % sind nicht nach KG ausgewiesen und werden außer
  für Wien als Eingabe (`n_reduction_zone`) erwartet.
- Nicht verfügbare Rechtsquellen (GSP-AV, MOG 2021, NAPV) sind als Eingaben
  modelliert und nicht nachgerechnet, z. B. NAPV-Konformität, verfügbarer
  Stickstoff und Leichtlöslichkeit.
- Die Stickstoff-Kettenbetrachtung über mehrere Kulturen ist katalogisiert,
  aber nicht als Simulation umgesetzt; geprüft wird der Übertrag aus der
  angegebenen Vorkultur je Schlag.
- Weitere Auslegungen laut `workspace/notes/assumptions.md`: Bentazon gilt
  standardmäßig als nicht wiederzugelassen, AG-Schläge sind von allen
  anderen o6_16-Zuschlägen ausgeschlossen, der OP-Code wird als `OPGWA`
  angenommen und Zeile 16 der Kombinationstabelle (Anhang L) wurde über
  Symmetrie rekonstruiert.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.
