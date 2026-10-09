# Draft: `o6_22` mit `claude-opus-5-5` (Rerun mit aktualisiertem Quellenpack)

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_22` (Tierwohl – Schweinehaltung)
erneut, diesmal mit GSP-AV, NAPV und der AMA-Meldung vom 02.09.2026 zu den
Meldeverpflichtungen bei tierbezogenen Maßnahmen. Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung
belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine
passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_22-opus-5.5-high-20261004`
- Modus: `discover`, Quality Gate `v1` (vergleichbar mit allen bisherigen Runs)
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 37 min API-Zeit; laut Claude Code 300.592 Output-Tokens (davon
  72.698 Thinking), Listenpreis-Äquivalent 22,61 USD
- Versuche: 4 (Fortsetzung derselben Sitzung, siehe `resumed_attempts` in
  `run.json`); Tokens und Kosten sind aufsummiert
- Limit-Guard: Versuch 1 (Start 51 %) und Versuch 2 wurden am Limit
  kontrolliert beendet und jeweils nach dem Reset fortgesetzt. Versuch 3
  (Start 87 %) lief durch, bestand `finalize` aber nicht (Zeilenzahl im
  Daten-Inventar für `space_requirements.json`: 4 angegeben, 9 vorhanden).
  Versuch 4 behob das (Start 56 %, Ende 51 %)
- Maßnahmenspezifische Quelle: `o6_22_tierwohl-schweinehaltung_2025_10.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen, **GSP-AV (Fassung
  28.01.2026)**, **NAPV (Fassung 28.10.2024)**, vier allgemeine amtliche
  Hinweise aus 2026 und **die Meldung vom 02.09.2026 zu
  Meldeverpflichtungen** (Quellenpack-Provenance `20261003T110742003580Z`)
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 125 |
| Quellenbelege | 293 |
| Coverage-Einträge / offene Einträge | 139 / 0 |
| Vorgeschlagene Profil-Blattpfade | 118 in 17 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 1 / 0 |
| Datendateien / Datentabellen | 6 / 35 |
| Rego-Dateien / Zeilen | 7 / 1438 |
| Generierte OPA-Tests | 73 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |

Die Kennzahl „verwendete Eingabepfade“ erfasst nur direkte `input.`-Zugriffe.

## Änderung gegenüber `v2-o6_22-opus-5.5-high-20260928`

| Signal | 28.09. | 04.10. |
|---|---:|---:|
| Quellen im Workspace | 8 | 11 |
| Strukturierte Regeln | 126 | 125 |
| Quellenbelege | 272 | 293 |
| davon GSP-AV / Meldung 02.09. / NAPV | – | 28 / 7 / 5 |
| Coverage-Einträge / offen | 167 / 3 | 139 / 0 |
| Profil-Blattpfade | 90 | 118 |
| Generierte OPA-Tests | 84 | 73 |
| Kosten (Listenpreis-Äquivalent) | 35,57 USD | 22,61 USD |

- Geschlossen:
  - Tierabweichungen (§§ 42–47 GSP-AV) fehlten im alten Run, weil die GSP-AV
    nicht vorlag; sie sind jetzt aus der GSP-AV belegt.
  - Die Meldung „Meldeverpflichtungen zu tierbezogenen ÖPUL-Maßnahmen“
    (02.09.2026) lag nur als Teaser vor; sie ist jetzt Quelle und mit 7
    Belegen eingearbeitet.
  - Der Rechenhinweis zum Alm-/Behirtungsbeispiel der Teilnahmebedingungen
    (98,66 % gegenüber rechnerisch 98,70 %) wird nicht mehr als offen
    geführt; er betrifft nicht `o6_22`.
- Neu offen: keine.
- Weniger Coverage-Einträge und Tests bei mehr Belegen: Der neue Run gliedert
  die Quellen gröber; ein Einzelvergleich steht in
  `artifacts/compare-previous.json`.

## Offene fachliche Punkte

Siehe `workspace/notes/assumptions.md`.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.
