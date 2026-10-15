# Draft: `o6_1c` mit `claude-opus-5-5` (Rerun mit aktualisiertem Quellenpack)

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_1c` (Nichtproduktive Ackerflächen und
Agroforststreifen) erneut, diesmal mit der GSP-AV als zusätzlicher Rechtsquelle.
Er liefert einen quellengebundenen, ausführbaren Regelkandidaten. Die technische
Validierung belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit
oder eine passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_1c-opus-5.5-high-20261009`
- Modus: `discover`, Quality Gate `v1` (vergleichbar mit allen bisherigen Runs)
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 28 min API-Zeit; laut Claude Code 223.020 Output-Tokens (davon
  61.026 Thinking), Listenpreis-Äquivalent 15,13 USD
- Versuche: 2 (Fortsetzung derselben Sitzung mit dem Fehlerbericht von
  `finalize`, siehe `resumed_attempts` in `run.json`); Tokens und Kosten sind
  aufsummiert
- Limit-Guard: Versuch 1 startete bei 97 % und endete regulär bei 23 %
  Restlimit; Versuch 2 startete nach dem Reset bei 99 % und endete bei 68 %
- Versuch 1 bestand `finalize` nicht (vier ungenutzte Referenzen, drei nicht
  auf der zitierten Seite gefundene Belege, überlappende Profilvorschläge
  `farm.oepul` neben `farm.oepul.o6_1c`, ein Coverage-Eintrag außerhalb der
  geprüften Seiten, zwei falsche Zeilenzahlen im Daten-Inventar); Versuch 2
  behob alle Punkte
- Maßnahmenspezifische Quelle: `o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen, **GSP-AV (Fassung
  28.01.2026)** und vier allgemeine amtliche Hinweise aus 2026
  (Quellenpack-Provenance `20261003T110742003580Z`)
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 97 |
| Quellenbelege | 221 |
| Coverage-Einträge / offene Einträge | 149 / 0 |
| Vorgeschlagene Profil-Blattpfade | 88 in 16 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 1 / 0 |
| Datendateien / Datentabellen | 7 / 22 |
| Rego-Dateien / Zeilen | 12 / 1791 |
| Generierte OPA-Tests | 80 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |

Die Kennzahl „verwendete Eingabepfade“ erfasst nur direkte `input.`-Zugriffe.

## Änderung gegenüber `v2-o6_1c-opus-5.5-high-20260925`

| Signal | 25.09. | 09.10. |
|---|---:|---:|
| Quellen im Workspace | 8 | 9 |
| Strukturierte Regeln | 97 | 97 |
| Quellenbelege | 258 | 221 |
| davon GSP-AV | – | 31 |
| Coverage-Einträge / offen | 179 / 4 | 149 / 0 |
| Profil-Blattpfade | 88 | 88 |
| Generierte OPA-Tests | 74 | 80 |
| Kosten (Listenpreis-Äquivalent, laut `run.json`) | 11,53 USD | 15,13 USD |

- Geschlossen: Alle vier offenen Punkte des alten Runs hingen an der fehlenden
  GSP-AV und sind jetzt aus ihr belegt:
  - § 31 (nicht förderfähige Flächen), Beleg `CIT-GSP-14`
  - § 6 (höhere Gewalt, Meldung binnen drei Wochen, Nachholen versäumter
    Handlungen), Belege `CIT-GSP-02` bis `-04` und `CIT-GSP-31`
  - §§ 42–47 (Über- und Untererklärung von Flächen), Belege `CIT-GSP-19` bis
    `-21`; zusätzlich § 48 (Sanktionsstufen)
  - § 25 Abs. 4 (Dauer- und Spezialkulturen), Beleg `CIT-GSP-08`
- Neu belegt aus der GSP-AV: Agroforststreifen als förderfähige
  Landschaftselemente (§§ 23, 29), Mindestgröße (§ 27), Antragsfristen
  (§ 33) und die GLÖZ-Standards 4, 6 und 8 (Anlage 2).
- Neu offen: keine.
- Weniger Belege und Coverage-Einträge bei gleicher Regelzahl: Der neue Run
  stützt sich weniger auf die Teilnahmebedingungen und SRL, wo die GSP-AV die
  spezifischere Quelle ist. Ein Einzelvergleich steht in
  `artifacts/compare-previous.json`.

Kosten und Tokens meldet Claude Code bei Fortsetzungen derselben Sitzung kumulativ; maßgeblich ist daher der Wert des letzten Versuchs in `run.json` (`generator_result`). Das README des Vorgänger-Runs addiert diese kumulativen Werte je Versuch und nennt deshalb zu hohe Kosten und Tokens.

## Offene fachliche Punkte

Siehe `workspace/notes/assumptions.md`, u. a.: Bezugsbasis der 4-%-Grenze,
Rangfolge bei Doppelbeantragung trotz Kombinationsverbot, Umrechnung der
Übererklärung auf Prämienebene (§ 46 Abs. 2 GSP-AV, nicht modelliert) und ob
die 4-%-Stilllegung nach GLÖZ 8 Z 1 ab 2025 noch anzuwenden ist.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.
