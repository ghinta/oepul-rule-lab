# Draft: `o6_16` mit `claude-opus-5-5` (Rerun mit aktualisiertem Quellenpack)

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_16` (Vorbeugender Grundwasserschutz –
Acker) erneut, diesmal mit GSP-AV, NAPV und der AMA-Meldung vom 25.08.2026 zu
den Aufzeichnungsverpflichtungen. Er liefert einen quellengebundenen,
ausführbaren Regelkandidaten. Die technische Validierung belegt weder fachliche
Vollständigkeit noch Rechtsverbindlichkeit oder eine passende Empfehlung für
einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_16-opus-5.5-high-20261003`
- Modus: `discover`, Quality Gate `v1` (vergleichbar mit allen bisherigen Runs)
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 37 min API-Zeit; laut Claude Code 260.296 Output-Tokens (davon
  57.963 Thinking), Listenpreis-Äquivalent 18,47 USD
- Versuche: 3 (Fortsetzung derselben Sitzung, siehe `resumed_attempts` in
  `run.json`); Tokens und Kosten sind aufsummiert
- Limit-Guard: Versuch 1 wurde bei 4 % Restlimit kontrolliert beendet und nach
  dem Reset fortgesetzt (Start 90 %). Versuch 2 bestand `finalize` wegen
  überlappender Profilvorschläge (`farm.oepul` neben `farm.oepul.o6_16`) nicht;
  Versuch 3 behob das (Start 59 %, Ende 58 %)
- Maßnahmenspezifische Quelle: `o6_16_vorbeugender_grundwasserschutz_acker_2026_04.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen, **GSP-AV (Fassung
  28.01.2026)**, **NAPV (Fassung 28.10.2024)**, vier allgemeine amtliche
  Hinweise aus 2026 und **die Meldung vom 25.08.2026 zu den
  Aufzeichnungsverpflichtungen** (Quellenpack-Provenance
  `20261003T110742003580Z`)
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 98 |
| Quellenbelege | 359 |
| Coverage-Einträge / offene Einträge | 144 / 3 |
| Vorgeschlagene Profil-Blattpfade | 142 in 34 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 2 / 0 |
| Datendateien / Datentabellen | 33 / 33 |
| Rego-Dateien / Zeilen | 11 / 1702 |
| Generierte OPA-Tests | 140 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |

Die Kennzahl „verwendete Eingabepfade“ erfasst nur direkte `input.`-Zugriffe.

## Änderung gegenüber `v2-o6_16-opus-5.5-high-20261002`

| Signal | 02.10. | 03.10. |
|---|---:|---:|
| Quellen im Workspace | 8 | 11 |
| Strukturierte Regeln | 131 | 98 |
| Quellenbelege | 338 | 359 |
| davon NAPV / GSP-AV / Meldung 25.08. | – | 27 / 22 / 9 |
| Coverage-Einträge / offen | 138 / 2 | 144 / 3 |
| Profil-Blattpfade | 110 | 142 |
| Generierte OPA-Tests | 140 | 140 |
| Kosten (Listenpreis-Äquivalent) | 44,20 USD | 18,47 USD |

- Geschlossen: Die Meldung vom 25.08.2026 zu den Aufzeichnungspflichten war im
  alten Run ein offener Punkt („liegt nicht als Quelle vor“); sie ist jetzt mit
  9 Belegen eingearbeitet. Die NAPV (Düngung, Aufzeichnungen) und die GSP-AV
  (Abwicklung) sind nicht mehr nur als Eingaben modelliert, sondern belegt.
- Weiterhin bzw. neu offen (`unresolved`):
  - Anhang G: Die Karten der Gebietskulisse haben keine maschinenlesbare
    Abgrenzung; maßgeblich ist die KG-Liste (S. 40–59).
  - NAPV § 9 (verstärkte Aktionen in Anlage-5-Gebieten): Diese Gebiete sind im
    Profil nicht abgebildet.
  - NAPV Anlage 3 Abschnitt VI (Grünland/Ackerfutter) ist nicht als Daten
    transkribiert; der N-Bedarf wird als Eingabe erwartet.
- Die SRL/Infoblatt-Abweichungen des alten Runs (Sudangras, Gewichtsgrenzen,
  Ackerfutter) sind nicht mehr als offen geführt.
- Weniger Regeln bei mehr Belegen: Der neue Run fasst Regeln stärker zusammen;
  ein Einzelvergleich steht in `artifacts/compare-previous.json`.

## Offene fachliche Punkte

Siehe `workspace/notes/assumptions.md` sowie die drei offenen Coverage-Einträge
oben.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.
