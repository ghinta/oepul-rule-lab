# Annahmen und offene Fragen – o6_11 Herbizidverzicht Wein, Obst und Hopfen

Run: `v2-o6_11-opus-5.5-high-20261001` (Modus `discover`)

## Quellenrangfolge
- Laut Allgemeinen Teilnahmebedingungen (Kap. 1) ist allein die Rechtsgrundlage (SRL ÖPUL 2023, GSP-AV, MOG 2021) verbindlich. Bei Abweichungen zwischen Merkblatt und SRL wird die SRL-Formulierung als maßgeblich betrachtet, das Merkblatt liefert Konkretisierungen (z. B. Zaunbereich, Stammbehandlungsmittel, Ameisensäure, PSM-Codes).

## Fachliche Annahmen
1. **Nutzungsart-Ableitung.** Fehlt `crop.usage_type`, wird aus `crop_category` abgeleitet: `vineyard → wine`, `orchard → fruit`, `hop → hop`. Ist `crop_name` bei Obst `null`, wird der Schlag als Obstfläche behandelt; ist eine Art angegeben, muss sie in der Obstliste stehen.
2. **Schnittweingärten** erhalten den Weinprämiensatz („zählen zur Weinfläche“). Ausdrücklich ist nur die Anrechnung zur Weinfläche und der Herbizidverzicht geregelt.
3. **Sonstige Weinflächen** unterliegen konservativ dem Herbizidverzicht (gesamte Weinfläche des Betriebes), zählen aber nicht zur Mindestteilnahmefläche (nicht förderfähig). **Rebschulen** unterliegen nicht dem Verzicht (keine Weinfläche). **Walnüsse/Edelkastanien** bleiben Obstflächen mit Verzichtspflicht, erhalten aber keine Prämie. Offen: Ob nicht prämienfähige Flächen tatsächlich unter den Verzicht fallen.
4. **Unveredelte Obstanlagen** (Code OP) bleiben ebenfalls Obstflächen mit Verzichtspflicht.
5. **Wirkungstyp.** Herbizid = `effect_type == "herbicide"` gemäß AGES-Register. Die Registerabfrage selbst ist nicht abgebildet; die Einstufung muss im Input vorliegen. Auch biologisch zugelassene Mittel mit Wirkungstyp Herbizid gelten als Verstoß.
6. **Ameisensäure** wird unabhängig von der Kultur als Verstoß gewertet („generell in der Feldproduktion nicht zulässig“), auch bei Kauf/Lagerung.
7. **Kauf/Lagerung.** Ausnahme nur, wenn die Zielkultur (`intended_crop_category`) auf einem Schlag ohne Herbizidverzicht angebaut wird **und** Aufzeichnungen vorliegen **und** die Menge als plausibel markiert ist. Die Plausibilitätsbeurteilung selbst (Menge vs. Fläche) wird nicht berechnet.
8. **PSM-Codierung (bis 2025).** Geprüft werden nur flächige Anwendungen (`is_area_wide`) im Antragsjahr auf Schlägen der Maßnahme. Ein gesetztes PSMCS erfüllt auch die PSMBIO-Pflicht. Die zeitliche Pflicht zur Streichung/Nachtragung (O611-PSM-CODE-ADVANCE) ist nur katalogisiert.
9. **Flächenbindung.** Maßnahme 11 ist an die jährlich verfügbaren Flächen gebunden (SRL 1.7.2.5, AT 5.9). Daraus wird abgeleitet, dass Flächenverringerungen keine Rückforderung nach der 5 %/5 ha/0,5 ha-Toleranz auslösen; die Toleranzformel ist dennoch implementiert und greift für nicht flexible Maßnahmen.
10. **Prämienobergrenze.** Bei Überschreitung wird die Maßnahme-11-Prämie anteilig (proportional) gekürzt; die Quellen regeln nicht, welcher Maßnahme die Kürzung zugeordnet wird. Andere Zahlungen werden als bereits gekürzter €/ha-Wert (`other_area_payments_eur_per_ha`) erwartet; die Ausnahmen bei der Einrechnung (6, 7, 10 bis 2024 bzw. 6, 7, 1C ab 2025) muss der Input berücksichtigen.
11. **Kürzungsreihenfolge.** Gemäß SRL 1.12.2: inhaltliche Kürzung → Modulation → Obergrenze. Flächenabweichungen, Fristversäumnisse und Konditionalitätskürzungen werden nicht berechnet (nur Hinweis).
12. **Sanktionsstufe** ist eine Eingangsgröße (AMA-Bewertung nach Schwere, Ausmaß, Dauer, Häufigkeit); Rego berechnet nur die Folge.
13. **Umstieg 11 → 1B.** Antrag spätestens 31.12.2025; 1B gilt ab dem Folgejahr des Antrags. Ab diesem Jahr wird für 11 keine Prämie berechnet und keine Rückforderung ausgelöst.
14. **Bio-Teilbetrieb.** Zulässig nur, wenn der Bio-Teil ausschließlich den Kulturbereich Acker/Grünland umfasst (`organic_partial_culture_areas == ["arable_grassland"]`).
15. **Maßnahmenübernahme.** Merkblatt: Ausweitung „der bisherigen Maßnahmenfläche auf andere Flächen um mehr als 50 %“; SRL: „um mehr als 50 % der übernommenen Fläche“. Implementiert: `expansion_area_ha / taken_over_area_ha ≤ 50 %` (SRL-Formulierung).
16. **Schläge ohne `oepul.measures`** gelten als für Maßnahme 11 beantragt (Default), damit Profile ohne MFA-Schlagdaten auswertbar bleiben.
17. **Nationalparks.** Namen werden gegen eine Liste (`Neusiedler See`, `Neusiedlersee`, `Neusiedler See - Seewinkel`, `Donau-Auen`) abgeglichen; in anderen Nationalparks wird die Prämie gewährt (AT 5.5.1). Die SRL-Formulierung „keine relevanten Bewirtschaftungsauflagen“ wird nicht separat bewertet.
18. **Dauerhafte Umstände.** Prämie im Eintrittsjahr bleibt erhalten bei Eintritt nach dem 15.04. oder bei höherer Gewalt; die Alternativen „nach dem Almauftrieb / nach Anlage der Begrünungskultur“ sind für 11 nicht einschlägig.
19. **Minimalauszahlung ≤ 50 €** ist eine Kann-Bestimmung und wird nur als Hinweis ausgegeben.

## 2026-Hinweise
- Keiner der vier Hinweise enthält eine Ausnahme für Maßnahme 11. Der rückzahlungsfreie Rebzikade-Ausstieg betrifft nur Maßnahme 12; die Dürre-Erleichterungen betreffen Ackerkulturen, Begrünungen (6, 7, 10), Untersaaten (8), Biodiversitätsflächen (1A/1B), Naturschutz/Natura 2000 (18/23) und Nutztierrassen (5). Für 11 bleibt nur der allgemeine Weg über ein Ansuchen auf höhere Gewalt.

## Technische Hinweise
- Anhang L wurde aus den Textkoordinaten der PDF-Seite 103 rekonstruiert (Spalten-x-Positionen, Fußnoten als hochgestellte Marker); die Matrix ist für Zeile/Spalte 11 symmetrisch (1A Fn 1, 2, 10, 12). Fehler bei anderen Zellen sind möglich und für Maßnahme 11 ohne Auswirkung.
- In SRL 1.9.4 wird UBB redaktionell mit „(1B)“ bezeichnet; in `farm_combination_exclusions.json` als 1A interpretiert.
- `evidence_text` wurde gegen den seitenmarkierten Text und die pypdf-Extraktion derselben Seite (Whitespace normalisiert) bzw. gegen den HTML-Rohtext geprüft. Einige SRL-Zitate enthalten die Original-Leerzeichenartefakte der PDF-Extraktion (z. B. „Fläch en“).
