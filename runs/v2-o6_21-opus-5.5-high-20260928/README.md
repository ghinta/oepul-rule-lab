# Draft: `o6_21` mit `claude-opus-5-5`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_21` (Tierwohl – Stallhaltung Rinder). Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung
belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine
passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_21-opus-5.5-high-20260928`
- Modus: `discover`
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 29 min, 54 Turns; laut Claude Code
  450.331 Output-Tokens (davon 118.905 Thinking),
  Listenpreis-Äquivalent 22,24 USD
- Versuche: 2 (Fortsetzung derselben Sitzung mit dem Fehlerbericht von `finalize`, siehe `resumed_attempts` in `run.json`); Laufzeit und Tokens sind aufsummiert
- Limit-Guard: Versuch 1 lief ohne Abbruch (Ende bei 6 % Restlimit); die
  Fortsetzung wurde zunächst bei 4 % blockiert und nach dem Limit-Reset
  nachgeholt. Der letzte Versuch startete bei 91 % und endete bei 69 %
- Maßnahmenspezifische Quelle: `o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 124 |
| Quellenbelege | 241 |
| Coverage-Einträge / offene Einträge | 137 / 4 |
| Vorgeschlagene Profil-Blattpfade | 115 in 11 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 19 / 0 |
| Datendateien / Datentabellen | 9 / 28 |
| Rego-Dateien / Zeilen | 9 / 1773 |
| Generierte OPA-Tests | 75 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |
| Canonical Farm Profile direkt verändert | nein |

## Offene fachliche Punkte

- Der erste Generatorversuch bestand die Grounding-Gates von `finalize`
  nicht; die Fortsetzung derselben Sitzung mit dem Fehlerbericht behob das.
- Vier Coverage-Einträge bleiben `unresolved`: Alle vier 2026-Hinweisseiten
  verlinken die Meldung „Meldeverpflichtungen zu tierbezogenen
  ÖPUL-Maßnahmen“ (02.09.2026), deren Volltext nicht im Quellpaket liegt.
- Die SRL-Prämientabelle bezeichnet „Tierwohl – Weide“ mit der Nummer 21; der
  Kandidat liest das in Übereinstimmung mit dem Informationsblatt als
  Maßnahme 20 und dokumentiert die Abweichung.
- Auslegungen zu reduziertem Satz, TGD-Schwelle über 10 RGVE, Stichtagen,
  Stallabteilen, Gewichtsklassen und Kompostierung stehen in
  `workspace/notes/assumptions.md`.
- Die 75 selbst erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht alle Regeln und Ausnahmen ab.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.

