# Draft: `o6_24` mit `claude-opus-5-5` (Rerun mit aktualisiertem Quellenpack)

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_24` (Wasserrahmenrichtlinie –
Landwirtschaft) erneut, diesmal mit der GSP-AV und dem Grundwasserschutzprogramm
Graz bis Bad Radkersburg samt Anlage 3. Er liefert einen quellengebundenen,
ausführbaren Regelkandidaten. Die technische Validierung belegt weder fachliche
Vollständigkeit noch Rechtsverbindlichkeit oder eine passende Empfehlung für
einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_24-opus-5.5-high-20261003`
- Modus: `discover`, Quality Gate `v1` (vergleichbar mit allen bisherigen Runs)
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 29 min API-Zeit; laut Claude Code 228.737 Output-Tokens (davon
  57.796 Thinking), Listenpreis-Äquivalent 15,70 USD
- Versuche: 3 (Fortsetzung derselben Sitzung, siehe `resumed_attempts` in
  `run.json`); Tokens und Kosten sind aufsummiert
- Limit-Guard: Versuch 1 wurde bei 3 % Restlimit kontrolliert beendet und nach
  dem Reset fortgesetzt (Start 89 %). Versuch 2 bestand `finalize` nicht: ein
  Coverage-Eintrag trug `rule_ids`, ohne als Regel-Eintrag markiert zu sein,
  wodurch der ganze Ledger verworfen wurde. Versuch 3 behob das (Start 62 %)
- Maßnahmenspezifische Quelle: `o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen, **GSP-AV (Fassung
  28.01.2026)**, **Grundwasserschutzprogramm Graz bis Bad Radkersburg 2018
  (Fassung 01.07.2026) samt Anlage 3 (Ausgabe 2026)** und vier allgemeine
  amtliche Hinweise aus 2026 (Quellenpack-Provenance `20261003T110742003580Z`)
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 95 |
| Quellenbelege | 225 |
| Coverage-Einträge / offene Einträge | 189 / 1 |
| Vorgeschlagene Profil-Blattpfade | 119 in 11 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 2 / 0 |
| Datendateien / Datentabellen | 13 / 32 |
| Rego-Dateien / Zeilen | 10 / 1250 |
| Generierte OPA-Tests | 67 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |

Die Kennzahl „verwendete Eingabepfade“ erfasst nur direkte `input.`-Zugriffe.

## Änderung gegenüber `v2-o6_24-opus-5.5-high-20260928`

| Signal | 28.09. | 03.10. |
|---|---:|---:|
| Quellen im Workspace | 8 | 11 |
| Strukturierte Regeln | 62 | 95 |
| Quellenbelege | 140 | 225 |
| davon Grundwasserschutzprogramm / GSP-AV | – | 59 / 36 |
| Coverage-Einträge / offen | 179 / 3 | 189 / 1 |
| Profil-Blattpfade | 46 | 119 |
| Generierte OPA-Tests | 62 | 67 |
| Kosten (Listenpreis-Äquivalent) | 23,03 USD | 15,70 USD |

- Geschlossen: Zwei der drei offenen Punkte des alten Runs hingen an der
  fehlenden GSP-AV; Aufbewahrungsfrist (§ 16 Z 1) und Flächenabweichungen
  (Über- und Unterdeklaration) sind jetzt aus der GSP-AV belegt. Die
  Revisionsklausel wird nicht mehr als offen geführt, ist aber weiterhin nur
  aus der SRL belegt (Regel `o6_24.gen.revision_clause`); ihre Anwendbarkeit
  auf die einjährige Maßnahme bleibt eine fachliche Prüffrage.
- Neu abgedeckt: Das Grundwasserschutzprogramm Graz bis Bad Radkersburg liefert
  die Düngeklassen, N-Obergrenzen, Nmin-, Bewässerungs- und
  Aufzeichnungspflichten (Regeln `o6_24.gwsp.*` und `o6_24.fert.*`).
- Neu offen (`unresolved`): Das Kartenwerk der Düngeklassen (Anlagen 2A und
  2B-1 bis 2B-58) liegt nur als Plan vor; die Klassenzuordnung eines Schlags
  muss als Eingabe aus INVEKOS-GIS bzw. GIS Steiermark kommen.
- Ein Einzelvergleich der Regeln steht in `artifacts/compare-previous.json`.

## Offene fachliche Punkte

Siehe `workspace/notes/assumptions.md` sowie den offenen Coverage-Eintrag oben.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.
