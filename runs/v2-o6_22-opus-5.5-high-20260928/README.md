# Draft: `o6_22` mit `claude-opus-5-5`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_22` (Tierwohl – Schweinehaltung). Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung
belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine
passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_22-opus-5.5-high-20260928`
- Modus: `discover`
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 32 min, 75 Turns; laut Claude Code
  639.319 Output-Tokens (davon 225.698 Thinking),
  Listenpreis-Äquivalent 35,57 USD
- Versuche: 3 (Fortsetzung derselben Sitzung mit dem Fehlerbericht von `finalize`, siehe `resumed_attempts` in `run.json`); Laufzeit und Tokens sind aufsummiert
- Limit-Guard: Versuch 1 wurde bei 4 % Restlimit kontrolliert unterbrochen
  (`aborted_usage_guard`) und nach dem Limit-Reset in derselben Sitzung
  fortgesetzt; der letzte Versuch startete bei 54 % und endete bei 38 %
- Maßnahmenspezifische Quelle: `o6_22_tierwohl-schweinehaltung_2025_10.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 126 |
| Quellenbelege | 272 |
| Coverage-Einträge / offene Einträge | 167 / 3 |
| Vorgeschlagene Profil-Blattpfade | 90 in 40 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 1 / 0 |
| Datendateien / Datentabellen | 6 / 38 |
| Rego-Dateien / Zeilen | 11 / 2038 |
| Generierte OPA-Tests | 84 |
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
- Drei Coverage-Einträge bleiben `unresolved`: Tierabweichungen nach
  §§ 42–47 GSP-AV (nicht im Quellpaket), die nur als Teaser verlinkte
  AMA-Meldung „Meldeverpflichtungen zu tierbezogenen ÖPUL-Maßnahmen“
  (02.09.2026) sowie das Modulationsbeispiel der ATB mit 98,66 % statt
  rechnerisch 98,70 %.
- Auslegungsbedürftig sind u. a. die Gewichtsklassengrenzen der
  Mindestflächentabelle, die abweichenden Klassen von Tierliste und
  Platztabelle, der GVE-Faktor nicht gedeckter Jungsauen und das
  „nennenswerte Ausmaß“ der Festmistkompostierung (siehe
  `workspace/notes/assumptions.md`).
- Die 84 selbst erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht alle Regeln und Ausnahmen ab.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.

