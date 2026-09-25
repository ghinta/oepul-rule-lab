# Draft: `o6_4` mit `claude-opus-5-5`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_4` (Bewirtschaftung von Bergmähdern). Er
liefert einen quellengebundenen, ausführbaren Regelkandidaten. Die technische
Validierung belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit
oder eine passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_4-opus-5.5-high-20260925`
- Modus: `discover`
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
  (Claude Code `2.1.282`, headless)
- Laufzeit: 26 min, 66 Turns; laut Claude Code 198.364 Output-Tokens
  (davon 53.548 Thinking), rund 12,0 Mio. Cache-Read-Tokens, Listenpreis-Äquivalent
  9,38 USD
- Limit-Guard: Start bei 91 %, letzte Messung 91 % Restlimit; kein Abbruch
- Maßnahmenspezifische Quelle: AMA-Informationsblatt Stand Oktober 2025
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 74 |
| Quellenbelege | 162 |
| Coverage-Einträge / offene Einträge | 134 / 2 |
| Vorgeschlagene Profil-Blattpfade | 46 in 21 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 6 / 0 |
| Datendateien / Datentabellen | 6 / 18 |
| Rego-Dateien / Zeilen | 8 / 1135 |
| Generierte OPA-Tests | 57 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |
| Canonical Farm Profile direkt verändert | nein |

Die Kennzahl „verwendete Eingabepfade“ erfasst nur direkte `input.`-Zugriffe.
Dieser Kandidat liest Schlagmerkmale überwiegend über Funktionsparameter
(z. B. `p.mountain_meadow.share_above_1200m_percent`); diese Pfade sind in
`rules/profile_changes.json` und den Regelbedingungen belegt, zählen aber nicht
in die Kennzahl. Mit den Terra-Runs ist sie daher nur eingeschränkt vergleichbar.

## Offene fachliche Punkte

- Zwei Coverage-Einträge bleiben `unresolved`: Flächenabweichungen nach
  §§ 42–47 GSP-AV sowie die PSM-Angabe nach § 34 GSP-AV. Die GSP-AV liegt nicht
  im Quellpaket.
- „Mehr als die Hälfte über 1.200 m“ ist streng als `> 50 %` umgesetzt; der
  Anteil muss aus dem INVEKOS-GIS-Layer als Eingabe kommen.
- Die Almbetriebs-Ausnahme zur Seehöhe der Betriebsstätte, die Behandlung
  gemischter Mähverfahren und die Folge eines Kombinationskonflikts sind
  auslegungsbedürftig und in `workspace/notes/assumptions.md` dokumentiert.
- Prämienobergrenze, Flächenzugang/-abgang und Sanktionsstufen werden nur
  gemeldet bzw. berechnet, nicht auf einzelne Schläge verteilt.
- Die 57 selbst erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht alle Regeln und Ausnahmen ab.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.
