# Draft: `o6_4` mit `claude-opus-5-5` (Rerun mit aktualisiertem Quellenpack)

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_4` (Bewirtschaftung von Bergmähdern)
erneut, diesmal mit der GSP-AV als zusätzlicher Rechtsquelle. Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung
belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine
passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_4-opus-5.5-high-20261009`
- Modus: `discover`, Quality Gate `v1` (vergleichbar mit allen bisherigen Runs)
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 25 min API-Zeit; laut Claude Code 193.194 Output-Tokens (davon
  55.615 Thinking), Listenpreis-Äquivalent 14,38 USD
- Versuche: 3 (Fortsetzung derselben Sitzung, siehe `resumed_attempts` in
  `run.json`); Tokens und Kosten sind aufsummiert
- Limit-Guard: Versuch 1 (Start 66 %) wurde am Limit kontrolliert beendet und
  nach dem Reset fortgesetzt (Start 96 %, Ende 71 %). Versuch 2 bestand
  `finalize` nicht (Zeilenzahlen im Daten-Inventar für `area_change` und
  `takeover`: 8 bzw. 4 angegeben, 9 bzw. 5 vorhanden). Versuch 3 behob das
  (Start 70 %, Ende 68 %)
- Maßnahmenspezifische Quelle: `o6_4_bewirtschaftung_von_bergmaehdern_2025_10.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen, **GSP-AV (Fassung
  28.01.2026)** und vier allgemeine amtliche Hinweise aus 2026
  (Quellenpack-Provenance `20261003T110742003580Z`)
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 90 |
| Quellenbelege | 224 |
| Coverage-Einträge / offene Einträge | 158 / 0 |
| Vorgeschlagene Profil-Blattpfade | 69 in 13 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 1 / 0 |
| Datendateien / Datentabellen | 1 / 31 |
| Rego-Dateien / Zeilen | 7 / 1370 |
| Generierte OPA-Tests | 67 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |

Die Kennzahl „verwendete Eingabepfade“ erfasst nur direkte `input.`-Zugriffe.

## Änderung gegenüber `v2-o6_4-opus-5.5-high-20260925`

| Signal | 25.09. | 09.10. |
|---|---:|---:|
| Quellen im Workspace | 8 | 9 |
| Strukturierte Regeln | 74 | 90 |
| Quellenbelege | 162 | 224 |
| davon GSP-AV | – | 40 |
| Coverage-Einträge / offen | 134 / 2 | 158 / 0 |
| Profil-Blattpfade | 46 | 69 |
| Generierte OPA-Tests | 57 | 67 |
| Kosten (Listenpreis-Äquivalent, laut `run.json`) | 9,38 USD | 14,38 USD |

- Geschlossen:
  - Flächenabweichungen (§§ 42–47 GSP-AV): Über- und Untererklärung sowie
    die Sanktionsfreiheit nach Korrektur sind jetzt belegt (`CIT-GSP-029` bis
    `-032`), dazu die Sanktionsstufen nach § 48.
  - PSM-Angaben nach § 34 Abs. 2 Z 12 lit. f GSP-AV: Der neue Run führt den
    Punkt nicht mehr als offen, sondern fasst SRL 1.12 in einem
    Coverage-Eintrag zusammen und zitiert die Stelle nicht ausdrücklich.
    Aus der Quelle ist die Frage beantwortbar: Lit. f nennt die
    Fördermaßnahmen 70-02, 70-03, 70-09, 70-10, 70-12 und 70-14, `o6_4` ist
    laut Anlage 1 die Fördermaßnahme 70-05 (`CIT-GSP-038`) und damit nicht
    erfasst.
- Neu belegt aus der GSP-AV: die Bergmähder-Definition (§ 25 Abs. 3 Z 3:
  über der Dauersiedlungsgrenze, überwiegend über 1.200 m, Mahd alle zwei
  Jahre, Weide nach dem 15. August zählt nicht als Nutzung), höhere Gewalt
  (§ 6), Mitteilungs-, Aufbewahrungs- und Rückzahlungspflichten (§§ 12, 14,
  16), Stichtag und Mindestgröße (§§ 27, 28) und GLÖZ 2 (Anlage 3).
- Neu offen: keine.
- Ein Einzelvergleich der Regeln steht in `artifacts/compare-previous.json`.

Kosten und Tokens meldet Claude Code bei Fortsetzungen derselben Sitzung kumulativ; maßgeblich ist daher der Wert des letzten Versuchs in `run.json` (`generator_result`). Der Vorgänger-Run hatte nur einen Versuch; seine Angaben sind korrekt.

## Offene fachliche Punkte

Siehe `workspace/notes/assumptions.md`, u. a.: ob die Mahdpflicht „jedes
zweite Jahr“ im ersten Vertragsjahr an die Mahd des Vorjahres anknüpft, ob
das Ausmähen um Hindernisse zur vollflächigen Mahd gehört, der
maßnahmenbezogene OP-Code und ob nach einem Umstieg in Naturschutz oder EBW
das Beweidungsverbot weiter gilt.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.
