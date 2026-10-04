# Draft: `o6_21` mit `claude-opus-5-5` (Rerun mit aktualisiertem Quellenpack)

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_21` (Tierwohl – Stallhaltung Rinder)
erneut, diesmal mit GSP-AV, NAPV und der AMA-Meldung vom 02.09.2026 zu den
Meldeverpflichtungen bei tierbezogenen Maßnahmen. Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung
belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine
passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_21-opus-5.5-high-20261004`
- Modus: `discover`, Quality Gate `v1` (vergleichbar mit allen bisherigen Runs)
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 35 min API-Zeit; laut Claude Code 260.716 Output-Tokens (davon
  64.269 Thinking), Listenpreis-Äquivalent 17,43 USD
- Versuche: 3 (Fortsetzung derselben Sitzung, siehe `resumed_attempts` in
  `run.json`); Tokens und Kosten sind aufsummiert
- Limit-Guard: Versuch 1 wurde bei 2 % Restlimit kontrolliert beendet und nach
  dem Reset fortgesetzt (Start 89 %). Versuch 2 bestand `finalize` nicht (ein
  Daten-Pointer auf einen Einzelwert statt auf eine Tabelle, ein Beleg nicht
  auf der zitierten Seite); Versuch 3 behob beides (Start 57 %, Ende 54 %)
- Maßnahmenspezifische Quelle: `o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen, **GSP-AV (Fassung
  28.01.2026)**, **NAPV (Fassung 28.10.2024)**, vier allgemeine amtliche
  Hinweise aus 2026 und **die Meldung vom 02.09.2026 zu
  Meldeverpflichtungen** (Quellenpack-Provenance `20261003T110742003580Z`)
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 95 |
| Quellenbelege | 269 |
| Coverage-Einträge / offene Einträge | 174 / 2 |
| Vorgeschlagene Profil-Blattpfade | 128 in 9 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 1 / 0 |
| Datendateien / Datentabellen | 5 / 36 |
| Rego-Dateien / Zeilen | 9 / 1481 |
| Generierte OPA-Tests | 110 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |

Die Kennzahl „verwendete Eingabepfade“ erfasst nur direkte `input.`-Zugriffe.

## Änderung gegenüber `v2-o6_21-opus-5.5-high-20260928`

| Signal | 28.09. | 04.10. |
|---|---:|---:|
| Quellen im Workspace | 8 | 11 |
| Strukturierte Regeln | 124 | 95 |
| Quellenbelege | 241 | 269 |
| davon GSP-AV / Meldung 02.09. / NAPV | – | 38 / 7 / 5 |
| Coverage-Einträge / offen | 137 / 4 | 174 / 2 |
| Profil-Blattpfade | 115 | 128 |
| Generierte OPA-Tests | 75 | 110 |
| Kosten (Listenpreis-Äquivalent) | 22,24 USD | 17,43 USD |

- Geschlossen: Alle vier offenen Punkte des alten Runs betrafen die Meldung
  „Meldeverpflichtungen zu tierbezogenen ÖPUL-Maßnahmen“ (02.09.2026), die nur
  als Teaser vorlag. Sie ist jetzt Quelle und mit 7 Belegen eingearbeitet.
- Neu offen (`unresolved`):
  - SRL 1.7.4.2–1.7.4.5 (flächen- bzw. bewirtschaftungsverändernde Umstände,
    BML-Festlegungen, Versuchsflächen): Die Anwendbarkeit auf tierbezogene,
    einjährige Verpflichtungen ist nicht eindeutig.
  - NAPV § 9 Abs. 7 (Aufzeichnung von Feldmieten in Anlage-5-Gebieten): Ob
    Kompostmieten darunter fallen, ist nicht eindeutig.
- Weniger Regeln bei mehr Belegen und mehr Coverage-Einträgen: Der neue Run
  fasst Regeln stärker zusammen; ein Einzelvergleich steht in
  `artifacts/compare-previous.json`.

## Offene fachliche Punkte

Siehe `workspace/notes/assumptions.md` sowie die zwei offenen Coverage-Einträge
oben.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.
