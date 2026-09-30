# Draft: `o6_2` mit `claude-opus-5-5`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_2` (Einschränkung ertragssteigernder Betriebsmittel). Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung
belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine
passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_2-opus-5.5-high-20260930`
- Modus: `discover`
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 13 min, 25 Turns; laut Claude Code
  469.365 Output-Tokens (davon 113.115 Thinking),
  Listenpreis-Äquivalent 26,87 USD
- Versuche: 3 in derselben Sitzung. Versuch 1 (ca. 18 min) wurde durch das
  Zeitlimit des steuernden Hintergrundjobs abgebrochen und hat kein
  Result-Event geschrieben; Laufzeit, Turns und Tokens oben umfassen daher nur
  die Versuche 2 und 3 (Fortsetzungen mit dem Fehlerbericht von `finalize`,
  siehe `resumed_attempts` in `run.json`)
- Limit-Guard: kein Guard-Abbruch; eine Fortsetzung wurde zunächst bei 46 %
  Restlimit blockiert und nach dem Limit-Reset nachgeholt. Der letzte Versuch
  startete bei 62 % und endete bei 61 %
- Maßnahmenspezifische Quelle: `o6_2_einschraenkung_ertragssteig_betriebsmittel_2026_04.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 82 |
| Quellenbelege | 207 |
| Coverage-Einträge / offene Einträge | 157 / 0 |
| Vorgeschlagene Profil-Blattpfade | 72 in 26 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 2 / 0 |
| Datendateien / Datentabellen | 6 / 28 |
| Rego-Dateien / Zeilen | 14 / 1661 |
| Generierte OPA-Tests | 87 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |
| Canonical Farm Profile direkt verändert | nein |

Die Kennzahl „verwendete Eingabepfade“ erfasst nur direkte `input.`-Zugriffe.
Zugriffe über Funktionsparameter oder lokale Variablen zählen nicht; die
tatsächlich benötigten Pfade sind in `rules/profile_changes.json` und den
Regelbedingungen belegt. Mit den Terra-Runs ist die Kennzahl daher nur
eingeschränkt vergleichbar.

## Offene fachliche Punkte

- Versuch 1 wurde nicht vom Modell, sondern durch das Zeitlimit des
  steuernden Hintergrundjobs beendet; Versuch 2 setzte die Sitzung fort und
  bestand die Grounding-Gates noch nicht, Versuch 3 behob die gemeldeten
  Fehler.
- Offen laut `workspace/notes/assumptions.md`: ob ein Bio-Teilbetrieb mit
  Kulturbereich teilnehmen darf (SRL allgemein vs. engere Fassung des
  Informationsblatts; umgesetzt ist die engere) und ob bei GLÖZ-8-NPF bis 2024
  statt 0 €/ha die Ackerflächenprämie zustünde.
- Welche Parzellen bei überschrittenem Flächenzugang ab 2026 nicht prämiert
  werden, regeln die Quellen nicht; ein o6_2-spezifischer OP-Code wird nicht
  genannt.
- Die 87 selbst erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht alle Regeln und Ausnahmen ab.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.

