# Draft: `o6_5` mit `claude-opus-5-5`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_5` (Erhaltung gefährdeter Nutztierrassen). Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung
belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine
passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_5-opus-5.5-high-20260925`
- Modus: `discover`
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 29 min, 66 Turns; laut Claude Code
  451.077 Output-Tokens (davon 134.502 Thinking),
  Listenpreis-Äquivalent 19,71 USD
- Versuche: 2 (Fortsetzung derselben Sitzung mit dem Fehlerbericht von `finalize`, siehe `resumed_attempts` in `run.json`); Laufzeit und Tokens sind aufsummiert
- Limit-Guard: Start bei 91 %, letzte Messung
  91 % Restlimit; kein Abbruch
- Maßnahmenspezifische Quelle: `o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 97 |
| Quellenbelege | 189 |
| Coverage-Einträge / offene Einträge | 143 / 0 |
| Vorgeschlagene Profil-Blattpfade | 62 in 7 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 2 / 0 |
| Datendateien / Datentabellen | 4 / 13 |
| Rego-Dateien / Zeilen | 8 / 1591 |
| Generierte OPA-Tests | 93 |
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
  nicht; die Fortsetzung derselben Sitzung mit dem Fehlerbericht behob das,
  ohne den Regelumfang zu verringern.
- Das Canonical Farm Profile kennt keine Einzeltiere, Förderwerber- oder
  Vertragsdaten; diese werden als Discover-Vorschläge ergänzt
  (u. a. `livestock.endangered_breed_animals`, `farm.applicant`). Fehlende
  tierbezogene Pflichtangaben gelten konservativ als nicht erfüllt.
- Offen bzw. auslegungsbedürftig sind laut `workspace/notes/assumptions.md`
  u. a. „mindestens jeder 2. Wurf reinrassig“ (umgesetzt als ≥ 50 % der Würfe),
  die Folge einer fehlenden Vorabmeldung bei Weitergabe (nur Befund, keine
  Aberkennung) und die allgemeine Minimum-Regel für die Prämie bei
  Nachbesetzung.
- Nachbesetzungsketten werden wegen des Rekursionsverbots in Rego nur bis zur
  zweiten Ebene ausgewertet.
- Die 93 selbst erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht alle Regeln und Ausnahmen ab.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.

