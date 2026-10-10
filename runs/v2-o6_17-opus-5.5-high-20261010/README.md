# Draft: `o6_17` mit `claude-opus-5-5` (Rerun mit aktualisiertem Quellenpack)

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_17` (Humuserhalt und Bodenschutz auf
umbruchsfähigem Grünland) erneut, diesmal mit der GSP-AV als zusätzlicher
Rechtsquelle. Er liefert einen quellengebundenen, ausführbaren
Regelkandidaten. Die technische Validierung belegt weder fachliche
Vollständigkeit noch Rechtsverbindlichkeit oder eine passende Empfehlung für
einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_17-opus-5.5-high-20261010`
- Modus: `discover`, Quality Gate `v1` (vergleichbar mit allen bisherigen Runs)
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 35 min API-Zeit; laut Claude Code 257.985 Output-Tokens (davon
  69.203 Thinking), Listenpreis-Äquivalent 17,84 USD
- Versuche: 3 (Fortsetzung derselben Sitzung, siehe `resumed_attempts` in
  `run.json`); Tokens und Kosten sind aufsummiert
- Limit-Guard: Versuch 1 (Start 73 %) wurde bei 4 % Restlimit kontrolliert
  beendet und nach dem Reset fortgesetzt (Start 95 %, Ende 76 %). Versuch 2
  bestand `finalize` nicht (sechs ungenutzte Referenzen, Seitenangaben bei
  vier HTML-Quellen, zwei falsche Zeilenzahlen im Daten-Inventar). Versuch 3
  behob alle Punkte (Start 73 %, Ende 72 %)
- Maßnahmenspezifische Quelle: `o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen, **GSP-AV (Fassung
  28.01.2026)** und vier allgemeine amtliche Hinweise aus 2026
  (Quellenpack-Provenance `20261003T110742003580Z`)
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 106 |
| Quellenbelege | 337 |
| Coverage-Einträge / offene Einträge | 152 / 0 |
| Vorgeschlagene Profil-Blattpfade | 86 in 38 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 1 / 0 |
| Datendateien / Datentabellen | 8 / 25 |
| Rego-Dateien / Zeilen | 14 / 1864 |
| Generierte OPA-Tests | 75 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |

Die Kennzahl „verwendete Eingabepfade“ erfasst nur direkte `input.`-Zugriffe.

## Änderung gegenüber `v2-o6_17-opus-5.5-high-20261002`

| Signal | 02.10. | 10.10. |
|---|---:|---:|
| Quellen im Workspace | 8 | 9 |
| Strukturierte Regeln | 118 | 106 |
| Quellenbelege | 303 | 337 |
| davon GSP-AV | – | 38 |
| Coverage-Einträge / offen | 133 / 1 | 152 / 0 |
| Profil-Blattpfade | 68 | 86 |
| Generierte OPA-Tests | 112 | 75 |
| Kosten (Listenpreis-Äquivalent, laut `run.json`) | 15,45 USD | 17,84 USD |

- **Nicht geschlossen, nur nicht mehr als offen geführt:** Der einzige offene
  Punkt des alten Runs, die Flächen- und Tierabweichungen nach §§ 42–47
  GSP-AV, ist im neuen Run nicht belegt. Der Run hat die GSP-AV gezielt
  gelesen (Seiten 9–24, 30–31 und 88–93; §§ 42–43 stehen auf den Seiten 28
  und 29, §§ 44–47 auf Seite 30) und zitiert §§ 42–47 nicht. SRL 1.12 ist nur noch als ein
  Coverage-Eintrag geführt, der auf Sanktionsstufen und Kürzungsreihenfolge
  verweist. Die Flächenabweichungssanktion fehlt damit weiterhin; die übrigen
  Reruns (`o6_1c`, `o6_4`, `o6_12`) belegen sie aus §§ 42, 46 und 47.
- Neu belegt aus der GSP-AV: Grünland-Schlagnutzungsarten (§ 25 Abs. 3),
  Grünlandwerdung (§ 26), RGVE-Umrechnung (§ 21 Abs. 4), Hangneigung und
  Grünlandzahl der Referenzparzelle (§ 23), höhere Gewalt (§ 6),
  Sanktionsstufen (§ 48) und GLÖZ 2, 4 und 9 (Anlage 2).
- Weniger Regeln und Tests bei mehr Belegen: Der neue Run fasst Regeln
  stärker zusammen. Ein Einzelvergleich steht in
  `artifacts/compare-previous.json`.

Kosten und Tokens meldet Claude Code bei Fortsetzungen derselben Sitzung kumulativ; maßgeblich ist daher der Wert des letzten Versuchs in `run.json` (`generator_result`). Das README des Vorgänger-Runs addiert diese kumulativen Werte je Versuch und nennt deshalb zu hohe Kosten und Tokens.

## Offene fachliche Punkte

- §§ 42–47 GSP-AV (Flächen- und Tierabweichungen), siehe oben.
- Siehe `workspace/notes/assumptions.md`, u. a.: Grundprämie nur unter 18 %
  Hangneigung (Informationsblatt und Prämientabelle widersprechen sich),
  Grenze der Grünlandzahl 20, Kürzung bei Überschreitung der AGL-Obergrenze,
  fehlender maßnahmenspezifischer OP-Code und Behandlung der
  Prämienobergrenze von 1.300 €/ha.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.
