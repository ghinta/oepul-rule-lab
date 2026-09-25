# Draft: `o6_1b` mit `claude-opus-5-5`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_1b` (Biologische Wirtschaftsweise). Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung
belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine
passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_1b-opus-5.5-high-20260925`
- Modus: `discover`
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 54 min, 122 Turns; laut Claude Code
  809.969 Output-Tokens (davon 155.520 Thinking),
  Listenpreis-Äquivalent 42,86 USD
- Versuche: 2 (Fortsetzung derselben Sitzung mit dem Fehlerbericht von `finalize`, siehe `resumed_attempts` in `run.json`); Laufzeit und Tokens sind aufsummiert
- Limit-Guard: Start bei 91 %, letzte Messung
  91 % Restlimit; kein Abbruch
- Maßnahmenspezifische Quelle: `o6_1b_biologische_wirtschaftsweise_2026_04.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 200 |
| Quellenbelege | 588 |
| Coverage-Einträge / offene Einträge | 239 / 0 |
| Vorgeschlagene Profil-Blattpfade | 192 in 89 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 1 / 0 |
| Datendateien / Datentabellen | 8 / 92 |
| Rego-Dateien / Zeilen | 18 / 3585 |
| Generierte OPA-Tests | 111 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |
| Canonical Farm Profile direkt verändert | nein |

Die Kennzahl „verwendete Eingabepfade“ erfasst nur direkte `input.`-Zugriffe.
Zugriffe über Funktionsparameter oder lokale Variablen zählen nicht; die
tatsächlich benötigten Pfade sind in `rules/profile_changes.json` und den
Regelbedingungen belegt. Mit den Terra-Runs ist die Kennzahl daher nur
eingeschränkt vergleichbar.

## Offene fachliche Punkte

- Der erste Generatorversuch bestand `finalize` nicht: Daten-Pointer zeigten
  auf Skalare, sieben Belege standen nicht wörtlich auf der zitierten Seite, und
  Profilvorschläge fehlten für Elternpfade. Die Fortsetzung mit dem
  Fehlerbericht behob das, ohne den Regelumfang zu verringern.
- Kürzungsstufen legt die AMA nach einem unveröffentlichten Schema fest; sie
  werden als Eingabe (`oepul.o6_1b.sanction_level`) übernommen und nur in
  Prozentsätze umgerechnet.
- Auslegungsbedürftig und in `workspace/notes/assumptions.md` (A-01 bis A-26)
  dokumentiert sind u. a. die Zuordnung der Kombinationspflicht zu Phänoflex
  bzw. „Schnittzeit nach Phänologie“, der Zuschlag „je angefangene 3 ha“, die
  75/25-%-Regel mit Projektbestätigung, die Reihenfolge der Kappung von
  Landschaftselementen sowie die Dürre-Ausnahmen 2026 ohne geschlossene
  Kulturliste.
- 19 Katalogregeln sind reine Dokumentations-, Verfahrens- oder
  Behördenaussagen ohne eigene Rego-Entscheidung.
- Die 111 selbst erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht alle Regeln und Ausnahmen ab.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.

