# Draft: `o6_7` mit `claude-opus-5-5`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_7` (Begrünung von Ackerflächen – System Immergrün). Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung
belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine
passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_7-opus-5.5-high-20260925`
- Modus: `discover`
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 38 min, 89 Turns; laut Claude Code
  580.304 Output-Tokens (davon 152.615 Thinking),
  Listenpreis-Äquivalent 25,37 USD
- Versuche: 2 (Fortsetzung derselben Sitzung mit dem Fehlerbericht von `finalize`, siehe `resumed_attempts` in `run.json`); Laufzeit und Tokens sind aufsummiert
- Limit-Guard: Start bei 91 %, letzte Messung
  91 % Restlimit; kein Abbruch
- Maßnahmenspezifische Quelle: `o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 107 |
| Quellenbelege | 265 |
| Coverage-Einträge / offene Einträge | 161 / 0 |
| Vorgeschlagene Profil-Blattpfade | 88 in 25 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 7 / 0 |
| Datendateien / Datentabellen | 5 / 58 |
| Rego-Dateien / Zeilen | 13 / 2231 |
| Generierte OPA-Tests | 106 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |
| Canonical Farm Profile direkt verändert | nein |

Die Kennzahl „verwendete Eingabepfade“ erfasst nur direkte `input.`-Zugriffe.
Zugriffe über Funktionsparameter oder lokale Variablen zählen nicht; die
tatsächlich benötigten Pfade sind in `rules/profile_changes.json` und den
Regelbedingungen belegt. Mit den Terra-Runs ist die Kennzahl daher nur
eingeschränkt vergleichbar.

## Offene fachliche Punkte

- Der erste Generatorversuch bestand die Grounding-Gates von `finalize`
  nicht; die Fortsetzung derselben Sitzung mit dem Fehlerbericht behob das.
- Offen laut `workspace/notes/assumptions.md`: eine Mindestzahl an
  Mischungspartnern bei Zwischenfrüchten nach dem 20. September (SRL vs.
  Merkblatt), das genaue Ende des NAPV-Verbotszeitraums je Kultur und Region
  (nicht im Quellpaket) sowie die Prämienwirkung auf NAT/EBW-Einzelflächen und
  Grünbrachen (Anhang L).
- Der tatsächliche Prämiensatz im Band 70–90 €/ha wird jährlich von der AMA
  festgelegt und ist nicht berechenbar.
- Ein maßnahmenbezogener OP-Code für System Immergrün ist in den Quellen nicht
  genannt; die Eingabe erwartet den Maßnahmencode „7“.
- Die 106 selbst erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht alle Regeln und Ausnahmen ab.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.

