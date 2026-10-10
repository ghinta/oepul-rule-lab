# Draft: `o6_12` mit `claude-opus-5-5` (Rerun mit aktualisiertem Quellenpack)

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_12` (Insektizidverzicht Wein, Obst und
Hopfen) erneut, diesmal mit der GSP-AV als zusätzlicher Rechtsquelle. Er
liefert einen quellengebundenen, ausführbaren Regelkandidaten. Die technische
Validierung belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit
oder eine passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_12-opus-5.5-high-20261009`
- Modus: `discover`, Quality Gate `v1` (vergleichbar mit allen bisherigen Runs)
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 28 min API-Zeit; laut Claude Code 219.118 Output-Tokens (davon
  55.163 Thinking), Listenpreis-Äquivalent 15,07 USD
- Versuche: 2 (Fortsetzung derselben Sitzung mit dem Fehlerbericht von
  `finalize`, siehe `resumed_attempts` in `run.json`); Tokens und Kosten sind
  aufsummiert
- Limit-Guard: Versuch 1 startete bei 67 % und endete regulär bei 8 %
  Restlimit; Versuch 2 startete nach dem Reset bei 95 % und endete bei 76 %
- Versuch 1 bestand `finalize` nicht (neun überlappende Profilvorschläge
  `oepul.o6_12` neben Unterpfaden, ein Coverage-Eintrag außerhalb der
  geprüften Seiten, ein Daten-Pointer auf einen Einzelwert statt auf eine
  Tabelle, sieben falsche Zeilenzahlen im Daten-Inventar); Versuch 2 behob
  alle Punkte
- Maßnahmenspezifische Quelle: `o6_12_insektizidverzicht_wein_obst_hopfen_2026_04.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen, **GSP-AV (Fassung
  28.01.2026)** und vier allgemeine amtliche Hinweise aus 2026, darunter die
  Meldung zum vorzeitigen Ausstieg wegen der Amerikanischen Rebzikade
  (Quellenpack-Provenance `20261003T110742003580Z`)
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 94 |
| Quellenbelege | 193 |
| Coverage-Einträge / offene Einträge | 141 / 0 |
| Vorgeschlagene Profil-Blattpfade | 96 in 24 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 3 / 0 |
| Datendateien / Datentabellen | 11 / 32 |
| Rego-Dateien / Zeilen | 12 / 1683 |
| Generierte OPA-Tests | 66 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |

Die Kennzahl „verwendete Eingabepfade“ erfasst nur direkte `input.`-Zugriffe.

## Änderung gegenüber `v2-o6_12-opus-5.5-high-20260926`

| Signal | 26.09. | 09.10. |
|---|---:|---:|
| Quellen im Workspace | 8 | 9 |
| Strukturierte Regeln | 91 | 94 |
| Quellenbelege | 190 | 193 |
| davon GSP-AV | – | 35 |
| Coverage-Einträge / offen | 178 / 1 | 141 / 0 |
| Profil-Blattpfade | 83 | 96 |
| Generierte OPA-Tests | 68 | 66 |
| Kosten (Listenpreis-Äquivalent, laut `run.json`) | 11,57 USD | 15,07 USD |

- Geschlossen: Der einzige offene Punkt des alten Runs, die
  Flächenabweichungen nach §§ 42–47 GSP-AV, ist jetzt belegt (Über- und
  Untererklärung, `CIT-GSP-21` bis `-24`), dazu die Sanktionsstufen nach § 48.
- Neu belegt aus der GSP-AV: höhere Gewalt einschließlich behördlicher
  Anordnungen gegen Pflanzenkrankheiten (§ 6 Abs. 1 Z 5), Weinflächen nur im
  Weinbaukataster (§§ 25, 31), die Angabepflicht zu Pflanzenschutzmitteln
  für 70-09/70-10 (§ 34 Abs. 2 Z 12 lit. f; `o6_12` ist 70-10), Mitteilungs-,
  Aufbewahrungs- und Rückzahlungspflichten sowie Zahlungsregeln (§ 52).
- Neu offen: keine.
- Weniger Coverage-Einträge bei etwa gleicher Beleg- und Regelzahl: Der neue
  Run ersetzt SRL- und Teilnahmebedingungs-Belege teils durch die
  spezifischeren GSP-AV-Belege. Ein Einzelvergleich steht in
  `artifacts/compare-previous.json`.

Kosten und Tokens meldet Claude Code bei Fortsetzungen derselben Sitzung kumulativ; maßgeblich ist daher der Wert des letzten Versuchs in `run.json` (`generator_result`). Das README des Vorgänger-Runs addiert diese kumulativen Werte je Versuch und nennt deshalb zu hohe Kosten und Tokens.

## Offene fachliche Punkte

Siehe `workspace/notes/assumptions.md`, u. a.: Die Bio-Zulässigkeit eines
Mittels ist eine Eingabe und wird nicht gegen ein Register geprüft; höhere
Gewalt nach Art. 3 VO (EU) 2021/2116 ist nur als Sammelfall erfasst; die
Sammelmeldung für ein ganzes Katastrophengebiet (§ 6 Abs. 3 GSP-AV) ist nicht
abgebildet.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.
