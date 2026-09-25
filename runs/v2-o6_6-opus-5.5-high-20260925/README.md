# Draft: `o6_6` mit `claude-opus-5-5`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_6` (Begrünung von Ackerflächen – Zwischenfruchtanbau). Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung
belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine
passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_6-opus-5.5-high-20260925`
- Modus: `discover`
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 35 min, 78 Turns; laut Claude Code
  548.790 Output-Tokens (davon 126.338 Thinking),
  Listenpreis-Äquivalent 23,89 USD
- Versuche: 2 (Fortsetzung derselben Sitzung mit dem Fehlerbericht von `finalize`, siehe `resumed_attempts` in `run.json`); Laufzeit und Tokens sind aufsummiert
- Limit-Guard: Start bei 91 %, letzte Messung
  91 % Restlimit; kein Abbruch
- Maßnahmenspezifische Quelle: `o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 111 |
| Quellenbelege | 290 |
| Coverage-Einträge / offene Einträge | 154 / 0 |
| Vorgeschlagene Profil-Blattpfade | 72 in 47 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 10 / 0 |
| Datendateien / Datentabellen | 6 / 32 |
| Rego-Dateien / Zeilen | 8 / 1609 |
| Generierte OPA-Tests | 101 |
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
- SRL und Maßnahmenblatt weichen beim Walzen der Varianten 2–6 ab (SRL ohne
  Ausnahme, Maßnahmenblatt mit Anwalzen und Frostwalzen). Umgesetzt sind die
  Ausnahmen des Maßnahmenblatts; rechtlich verbindlich ist die SRL – offen.
- Die AMA-Meldung vom 05.08.2026 vertauscht die Anlagetermine der Varianten 1
  und 2; maßgeblich bleiben Maßnahmenblatt und SRL, gestützt durch das Beispiel
  derselben Meldung.
- Die Prämiensätze sind Prämienbänder, die nach verfügbaren EGFL-Mitteln aliquot
  verteilt werden; der tatsächliche Satz ist nicht berechenbar.
- Weitere 24 Auslegungen (u. a. Ende des Begrünungszeitraums, Mischungspartner
  Variante 6, Pflegetermine Variante 7, Dürre-Ausnahmen 2026) stehen in
  `workspace/notes/assumptions.md`.
- Die 101 selbst erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht alle Regeln und Ausnahmen ab.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.

