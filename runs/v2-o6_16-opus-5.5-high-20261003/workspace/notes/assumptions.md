# Annahmen und offene Fragen – o6_16 Vorbeugender Grundwasserschutz – Acker

Run: `v2-o6_16-opus-5.5-high-20261003` (Modus `discover`)

## Gebietskulisse (Anhang G)
- Die KG-Liste auf S. 40–59 der Anhänge wird als maßgebliche Gebietskulisse verwendet (1566 Zeilen, 1565 eindeutige
  KG-Nummern; KG 51106 Bergham steht in der Quelle doppelt und wurde unverändert übernommen).
- Die Karten (S. 38/39, bis 2024 bzw. ab 2025) und die „1b“-Randmarkierungen auf S. 51–54 lassen sich nicht
  zeilengenau zuordnen. Die Liste wird daher als Kulisse ab 2025 behandelt. Für Antragsjahre bis 2024 kann die
  Kulisse kleiner gewesen sein (offen).
- Ob ein Schlag in der Kulisse liegt, wird über `land.parcels[].kg_number` bestimmt. Teilweise in der Kulisse liegende
  KG gibt es in der Liste nicht, daher gilt jeder Schlag mit gelisteter KG vollständig als Kulissenfläche.

## Reduktionsfaktor 80 % / 60 %
- Anhang G ordnet die KG nicht den Teilgebieten „nördliches und mittleres Burgenland“ bzw. „östliches
  Niederösterreich inkl. Tullnerfeld“ zu. Deshalb wird ein eigenes Eingabefeld `n_reduction_zone` vorgeschlagen.
  Wien wird automatisch mit 80 % bewertet; fehlt die Zone, gilt 60 %.
- Die 30-kg/ha-Schwelle für die Herbstbegrünung wird auf den Saldo **vor** dem Reduktionsfaktor angewendet
  (Wortlaut „errechneter Stickstoffüberschuss aus der Vorkultur“).
- Der Übertrag wird auf 2 Nachkommastellen gerundet. Die Prüfung vergleicht die tatsächliche Reduktion der
  Folgekulturdüngung (`following_crop_n_reduction_kg_ha`) mit dem Mindestübertrag.
- Ungenutzte Zwischenfrucht, die nicht gemäß Maßnahme 6/7 angelegt wurde: Es wird angenommen, dass dann kein
  Reduktionsfaktor gilt (Übertrag 100 %), weil das Informationsblatt den Faktor nur unter dieser Bedingung zulässt.
- Ackerfutter und Futterleguminosen: Der NAPV-Stickstoffbedarf (Anlage 3 Abschnitt VI) wurde nicht als Daten
  übernommen. Er ist über `n_balance.crop_n_demand_kg_ha` einzugeben. Für Körnerleguminosen gilt der Standardwert
  0 kg N/ha bzw. 60 kg N/ha (Fußnote 1). Der Wert 50 kg N/ha gilt nur in Anlage-5-Gebieten und muss ebenfalls über
  `crop_n_demand_kg_ha` gesetzt werden, weil Anlage-5-Gebiete nicht im Profil abgebildet sind.

## Fristen und einmalige Auflagen
- Weiterbildung (10 h), Gewässerschutzkonzept und Bodenproben (Frist 31.12.2026) werden ab Antragsjahr 2026
  geprüft. Die Eingabe soll dabei den Stand zum Jahresende abbilden. Laut § 48 Abs. 2 GSP-AV wird ein Verstoß im
  Jahr der Feststellung geahndet.
- Doppelte Bodenproben beim Zuschlag Wien („innerhalb des Vertragszeitraums“) werden erst zum Vertragsende 2028
  geprüft.
- Der Maßnahmenantrag (31.12.) verschiebt sich nicht auf den nächsten Arbeitstag (§ 5 Abs. 2 GSP-AV).

## Widersprüche zwischen den Quellen
- **PSM-Angabe:** § 34 Abs. 2 Z 12 lit. f GSP-AV (Fassung 28.01.2026) verlangt für 70-14 weiterhin die Angabe der
  PSM-Verwendung. Das Informationsblatt (Stand 04/2026) streicht die PSM-Codierung ab 2026. Umgesetzt ist die
  Fassung des Informationsblatts (Prüfung nur bis 2025). Das ist rechtlich zu klären.
- **Sudangras** steht beim Wirkstoffverbot und beim PSM-Zuschlag nur im Informationsblatt 04/2026, nicht in der
  SRL-Fassung 2024. Es wurde aufgenommen.
- **Schweine-Rohprotein:** Die SRL nennt den Durchschnittswert 157 g für „32 kg bis Mastende sowie Jungsauen nicht
  gedeckt ab 50 kg“. Das Informationsblatt stellt ihn in der Zeile 32–60 kg dar. Umgesetzt ist: Durchschnitt
  157 g für alle Mastphasen ab 32 kg oder alternativ die Phasengrenzen 170/155/150 g.
- **Bildungszuschlag:** Der Zuschlag „für die ersten 10 ha“ wird auf die prämienfähige Kulissenfläche ohne
  AG-Flächen angewendet.

## GVE und Schweinekategorien
- Anhang A nennt Eber nicht gesondert. Eber ab 50 kg werden mit 0,5 GVE bewertet (wie Zucht- und Jungsauen); als
  Alternative kommt die Kategorie „ausgemerzte Zuchttiere“ mit 0,3 GVE in Frage (offen). Ist
  `species_groups[].gve` gesetzt, wird dieser Wert als Gruppen-Gesamt-GVE verwendet.
- `species_groups[].category` muss für Schweine die Schlüssel aus `data/o6_16/pig_crude_protein_limits.json`
  verwenden.

## Prämie
- AG-Flächen sind von allen anderen Komponenten (Basisprämie, Zuschläge) ausgeschlossen.
- Die 20-%-Grenze für AG bezieht sich auf die gesamte Ackerfläche des Betriebes laut Profil.
- Der Flächenzugang ab 2026 wird vereinfacht über `premium_area_2025_ha` begrenzt: Basis 2025 plus
  max(50 %, 5 ha). Zugänge von Flächen, die schon vorher mit der Maßnahme belegt waren, sind nicht gesondert
  modelliert.
- Die Modulation wird auf die Summe der Maßnahme 16 angewendet. Die schlagbezogene Obergrenze von 1.300 €/ha
  erfordert die Summe aller ÖPUL-Zahlungen je Schlag. Sie ist nur als Funktion (`payment_cap_eur_ha`) umgesetzt,
  nicht in die Prämie eingerechnet.
- Der OÖ-Top-up wird nur gewährt, wenn das Land die Mittel zeitgerecht bereitstellt; dies wird nicht geprüft.

## Hinweise 2026
- Die Dürre-Ausnahme für die Ernteverpflichtung verlangt Bezirk und Bundesland des Schlages; ohne diese Angaben
  werden die Betriebsangaben verwendet.
- Die DIV-Erleichterungen (Hinweise vom 22.05. und 12.08.2026: vorzeitige oder dritte Nutzung, Beweidung ab
  1. August) gelten für UBB/BIO. Für AG-Flächen, die zusätzlich als DIV gemeldet sind, bleiben die strengeren
  AG-Auflagen bestehen (keine Beweidung, kein Drusch). Diese Annahme ist offen.
- Der Hinweis zur Rebzikade (Insektizidverzicht) betrifft die Maßnahme 16 nicht.

## Rechtsgrundlagen – Umfang
- Aus der NAPV sind §§ 2–7, Anlage 1, 4 und 5 sowie Abschnitt VI nicht im Detail modelliert. Sie gehen nur über
  die allgemeine Pflicht „NAPV-Düngevorgaben eingehalten“ (`O616-REC-001`) ein.
- Das Grundwasserschutzprogramm Graz (Maßnahme 24) lag nicht im Run-Workspace und ist für Maßnahme 16 nicht
  einschlägig.
