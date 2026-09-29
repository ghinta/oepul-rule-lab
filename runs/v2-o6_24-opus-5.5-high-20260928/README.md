# Draft: `o6_24` mit `claude-opus-5-5`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_24` (Wasserrahmenrichtlinie – Landwirtschaft). Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung
belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine
passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_24-opus-5.5-high-20260928`
- Modus: `discover`
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 28 min, 68 Turns; laut Claude Code
  429.209 Output-Tokens (davon 89.392 Thinking),
  Listenpreis-Äquivalent 23,03 USD
- Versuche: 2 (Fortsetzung derselben Sitzung mit dem Fehlerbericht von `finalize`, siehe `resumed_attempts` in `run.json`); Laufzeit und Tokens sind aufsummiert
- Limit-Guard: Versuch 1 lief ohne Abbruch (Ende bei 6 % Restlimit); die
  Fortsetzung wurde zunächst blockiert und nach dem Limit-Reset nachgeholt.
  Der letzte Versuch startete bei 90 % und endete bei 74 %
- Maßnahmenspezifische Quelle: `o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 62 |
| Quellenbelege | 140 |
| Coverage-Einträge / offene Einträge | 179 / 3 |
| Vorgeschlagene Profil-Blattpfade | 46 in 22 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 4 / 0 |
| Datendateien / Datentabellen | 5 / 30 |
| Rego-Dateien / Zeilen | 7 / 1310 |
| Generierte OPA-Tests | 62 |
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
- **Quellenlücke:** Das Grundwasserschutzprogramm Graz bis Bad Radkersburg 2018
  (LGBl. Nr. 24/2018 idF LGBl. Nr. 70/2020) fehlt im Quellpaket. Die eigentlichen
  Förderverpflichtungen (Düngeklassen, N-Obergrenzen je Kultur und Klasse,
  Ausbringungszeiträume) verweisen darauf. Die Obergrenzen werden daher als
  Eingabe je Schlag-Teilfläche erwartet; belegt sind nur die zwei
  Beispielwerte des Informationsblatts.
- Drei Coverage-Einträge bleiben `unresolved`: Revisionsklausel (Art. 70 vs.
  Art.-72-Zahlung), Aufbewahrungsfrist nach § 16 GSP-AV und
  Flächenabweichungen nach §§ 42–47 GSP-AV (GSP-AV nicht im Quellpaket).
- Offen ist, ob das gewichtete Mittel der N-Obergrenzen gerundet wird
  (Informationsblatt 133 kg, rechnerisch 133,2 kg).
- Die 62 selbst erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht alle Regeln und Ausnahmen ab.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.

