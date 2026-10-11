# Draft: `o6_17` mit `claude-opus-5-5` (zweiter Rerun mit aktualisiertem Quellenpack)

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_17` (Humuserhalt und Bodenschutz auf
umbruchsfähigem Grünland) ein drittes Mal. Der erste Rerun
(`v2-o6_17-opus-5.5-high-20261010`) hatte die GSP-AV nur auszugsweise gelesen
und die Flächenabweichungen nach §§ 42–47 nicht belegt. Dieser Lauf
verwendet denselben Quellenpack und denselben Prompt (bis auf die Run-ID). Er
liefert einen quellengebundenen, ausführbaren Regelkandidaten. Die technische
Validierung belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit
oder eine passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_17-opus-5.5-high-20261011`
- Modus: `discover`, Quality Gate `v1` (vergleichbar mit allen bisherigen Runs)
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 38 min API-Zeit; laut Claude Code 303.021 Output-Tokens (davon
  93.404 Thinking), Listenpreis-Äquivalent 19,15 USD
- Versuche: 2 (Fortsetzung derselben Sitzung mit dem Fehlerbericht von
  `finalize`, siehe `resumed_attempts` in `run.json`); Tokens und Kosten sind
  aufsummiert
- Limit-Guard: Versuch 1 startete bei 93 % und endete regulär bei 15 %
  Restlimit; Versuch 2 startete nach dem Reset bei 93 % und endete bei 71 %
- Versuch 1 bestand `finalize` nicht (acht ungenutzte Referenzen, fünf
  überlappende Profilvorschläge `oepul.o6_17` neben Unterpfaden); Versuch 2
  behob beides
- Maßnahmenspezifische Quelle: `o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen, **GSP-AV (Fassung
  28.01.2026)** und vier allgemeine amtliche Hinweise aus 2026
  (Quellenpack-Provenance `20261003T110742003580Z`)
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 133 |
| Quellenbelege | 418 |
| Coverage-Einträge / offene Einträge | 168 / 0 |
| Vorgeschlagene Profil-Blattpfade | 73 in 38 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 1 / 0 |
| Datendateien / Datentabellen | 7 / 37 |
| Rego-Dateien / Zeilen | 7 / 1332 |
| Generierte OPA-Tests | 70 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |

Die Kennzahl „verwendete Eingabepfade“ erfasst nur direkte `input.`-Zugriffe.

## Änderung gegenüber den Vorgänger-Runs

| Signal | 02.10. (alter Quellenpack) | 10.10. | 11.10. |
|---|---:|---:|---:|
| Quellen im Workspace | 8 | 9 | 9 |
| Strukturierte Regeln | 118 | 106 | 133 |
| Quellenbelege | 303 | 337 | 418 |
| davon GSP-AV | – | 38 | 81 |
| Gelesene GSP-AV-Seiten | – | 9–24, 30–31, 88–93 | 9–33, 87–94 |
| Coverage-Einträge / offen | 133 / 1 | 152 / 0 | 168 / 0 |
| Profil-Blattpfade | 68 | 86 | 73 |
| Generierte OPA-Tests | 112 | 75 | 70 |
| Kosten (Listenpreis-Äquivalent, laut `run.json`) | 15,45 USD | 17,84 USD | 19,15 USD |

- **Geschlossen:** Die Flächenabweichungen nach §§ 42–47 GSP-AV, der einzige
  offene Punkt des Runs vom 02.10., sind jetzt belegt und von Regeln
  verwendet: § 42 Abs. 4 (ermittelte Fläche maßgeblich), § 45 Abs. 2 (keine
  Sanktion nach Korrektur), § 46 Abs. 1 und 3 (Übererklärung, 1,5-fache
  Differenz, höchstens 100 %) und § 47 (Untererklärung). Die Übererklärung
  wird als eigene Bemessungsgrundlage berechnet, aber nicht automatisch in
  die Prämie eingerechnet (siehe `workspace/notes/assumptions.md`).
- §§ 43–44 (Abweichungen bei Tieren) sind nicht eigens erfasst; `o6_17` ist
  eine flächenbezogene Maßnahme.
- Gegenüber dem Run vom 10.10. zusätzlich aus der GSP-AV belegt: §§ 7–8
  (sonstige Umstände, offensichtlicher Fehler), §§ 12–13a (Rückforderung,
  Umgehung), § 15 (Bewirtschafterwechsel), § 17 (Duldung), §§ 20, 22 und 24
  (landwirtschaftliche Tätigkeit, Feldstück, Nutzungsarten), § 31
  (nicht förderfähige Fläche), § 34 (Inhalt des Mehrfachantrags) und
  §§ 52–53 (Zahlungen, Reihenfolge der Kürzungen). Junglandwirt (§ 21 Abs. 1–2)
  und GLÖZ 1, 3, 5–8 und 10 sind als nicht regelrelevant geführt.
- Neu offen: keine.
- Ein Einzelvergleich mit dem Run vom 10.10. steht in
  `artifacts/compare-previous.json`.

Kosten und Tokens meldet Claude Code bei Fortsetzungen derselben Sitzung kumulativ; maßgeblich ist daher der Wert des letzten Versuchs in `run.json` (`generator_result`).

## Offene fachliche Punkte

Siehe `workspace/notes/assumptions.md`, u. a.: Abweichungen zwischen
Merkblatt und SRL (Grenze der Grünlandzahl 20, Weiterbildungsthemen, wer die
Weiterbildung absolviert, Bodenproben, Kennartenliste, Erhebungstermin), ob
„Sonstige Grünlandflächen“ in die Ausgangsbasis der Bodenproben zählen, die
Aufteilung des AGL-Deckels auf die beiden Zuschlagssätze und die nicht
quantifizierten höheren Sanktionen bei Vor-Ort-Kontrollen.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.
