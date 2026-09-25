# Draft: `o6_1c` mit `claude-opus-5-5`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_1c` (Nichtproduktive Ackerflächen und Agroforststreifen). Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung
belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine
passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_1c-opus-5.5-high-20260925`
- Modus: `discover`
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 33 min, 68 Turns; laut Claude Code
  500.077 Output-Tokens (davon 142.983 Thinking),
  Listenpreis-Äquivalent 22,18 USD
- Versuche: 2 (Fortsetzung derselben Sitzung mit dem Fehlerbericht von `finalize`, siehe `resumed_attempts` in `run.json`); Laufzeit und Tokens sind aufsummiert
- Limit-Guard: Start bei 91 %, letzte Messung
  91 % Restlimit; kein Abbruch
- Maßnahmenspezifische Quelle: `o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 97 |
| Quellenbelege | 258 |
| Coverage-Einträge / offene Einträge | 179 / 4 |
| Vorgeschlagene Profil-Blattpfade | 88 in 11 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 5 / 0 |
| Datendateien / Datentabellen | 16 / 46 |
| Rego-Dateien / Zeilen | 8 / 1864 |
| Generierte OPA-Tests | 74 |
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
- Vier Coverage-Einträge bleiben `unresolved`, weil die GSP-AV nicht im
  Quellpaket liegt: § 31 (nicht hauptsächlich landwirtschaftlich genutzte
  Flächen), § 6 (höhere Gewalt), §§ 42–47 (Flächenabweichungen) und die
  Spezialkulturliste nach § 25 Abs. 4 (nur als Eingabe-Flag geprüft).
- Die tatsächliche Prämie hängt von Budget und Gesamtantragsfläche ab
  (SRL 1.9.3.2); Rego liefert daher nur das Prämienband je Kategorie.
- SRL 1.9.4 enthält einen Redaktionsfehler (1B statt 1A); umgesetzt ist 1A,
  gestützt durch das Informationsblatt.
- Die Dürre-Erleichterungen 2026 für Biodiversitätsflächen werden nicht auf NPA
  übertragen; ob die AMA das in der Praxis zulässt, ist offen.
- Weitere Auslegungen (4-%-Obergrenze, 50-%-Schnittregel, Reinigungsschnitt,
  Kombinationsverbot auch für Agroforststreifen) stehen in
  `workspace/notes/assumptions.md`.
- Die 74 selbst erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht alle Regeln und Ausnahmen ab.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.

