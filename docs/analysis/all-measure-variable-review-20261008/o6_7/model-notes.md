# o6_7: unveränderte Modellnotizen

Sämtliche Modellannahmen sind unbestätigt. Auch nicht einzeln priorisierte Auslegungen müssen vor Übernahme geprüft werden.

## luna: `v2-o6_7-luna-high-20261002`

# Annahmen und offene Punkte

- Das Canonical Farm Profile enthält keine ÖPUL-Maßnahmenstruktur. Die fehlenden Eingaben werden ausschließlich in `rules/profile_changes.json` vorgeschlagen; das Canonical Profile bleibt unverändert.
- Die Rego-Prüfung verwendet für die Ausführung ein ergänzendes `input.measure.o6_7`-Objekt. Die vorgeschlagenen Profile-Ergänzungen bilden die dafür benötigten Felder ab.
- Datumswerte werden in Rego für die technischen Tests als Tag des Jahres modelliert. Die fachliche Regel verwendet die im Quellenbeleg genannten Kalendertage; eine produktive Integration muss die Kalender-/Schaltjahrkonvertierung zentral vornehmen.
- Die 2026-Ausnahmen sind als zeitlich begrenzte Sachverhaltsregeln modelliert. Eine Glaubhaftmachung bzw. Vor-Ort-Prüfung ist fachlich erforderlich, kann aber nicht allein aus dem Canonical Profile automatisiert bewiesen werden.
- Die Quellen unterscheiden bei später Zwischenfruchtanlage zwischen „ausschließlich winterhart“ in älteren Formulierungen und „überwiegend winterhart“ ab Antragsjahr 2025. Für `o6_7` wird ab 2025 die ausdrücklich aktualisierte überwiegende Winterhärte mit einer strikten Mehr-als-50-%-Prüfung operationalisiert; Grenzfälle mit genau 50 % bleiben als Verstoß offen.
- Anhang L enthält die vollständige Kombinationstabelle. Für die Maßnahme o6_7 werden die maßgeblichen Zeilen in `data/annex_l_combination_table.json` strukturiert referenziert; die übrigen Tabellenzeilen und Fußnoten bleiben zur Nachvollziehbarkeit vollständig erhalten.
- Die HTML-Quelle vom 22.05.2026 betrifft Biodiversitätsflächen, die Quelle vom 12.06.2026 den Insektizidverzicht. Beide wurden vollständig gelesen und als `not_rule` für o6_7 dokumentiert.
- Die 2026-Mitteilung vom 12.08.2026 lockert nur die 30-/50-Tage-Abstände unter Glaubhaftmachung; die ausdrücklich genannten absoluten Anlagegrenzen (20. September bei abfrostenden Mischungen, 15. Oktober bei überwiegend winterharten Begrünungen) und die 42-Tage-Mindestdauer bleiben verbindlich.
- Die allgemeine 85-%-Ernteverpflichtung wird als eigenständige Zugang-/Bewirtschaftungsbedingung modelliert. Die Dürreausnahme 2026 hebt sie nur bei fehlendem erntbarem Bestand in der veröffentlichten Bezirkskulisse auf; sie ersetzt nicht die o6_7-Begrünungsquote.
- Die Quellen nennen die bestehende o6_7-Datenstruktur nicht im Canonical Profile. Für neue zeit- oder ereignisbezogene Sachverhalte (GLÖZ-8-Klassifikation 2024, Futternutzung/Nachwuchs, Pflegezeitpunkt) werden deshalb repräsentative Profile-Ergänzungen im `discover`-Modus vorgeschlagen.


## opus: `v2-o6_7-opus-5.5-high-20260925`

# Annahmen und offene Fragen – o6_7 „Begrünung von Ackerflächen – System Immergrün“

Run: `v2-o6_7-opus-5.5-high-20260925` · Modus `discover`

## Eingabemodell

- Das Canonical Farm Profile enthält nur einen Zeitpunkt `operations.cover_crop.sowing_date`.
  Für die tagesgenaue 85 %-Prüfung wird je Ackerschlag eine chronologische Liste von
  Begrünungsabschnitten (`land.parcels[].greening.segments[]`) vorausgesetzt (Vorschlag in
  `rules/profile_changes.json`). Abschnitte des Vorjahres (z. B. Winterweizen ab Herbst) müssen
  mitgeliefert werden, sonst gelten die Tage ab 1. Jänner bis zur ersten Kultur als unbegrünt.
- Maßnahmencodes folgen der Nummerierung der Sonderrichtlinie („1A“, „6“, „7“, „16“ …),
  Flächencodes (`OP`, `VF`, `NAT`, `EBW`, `K20`, `DIV`, `GI`) den AMA-Bezeichnungen.

## Fachliche Auslegung

1. **Tageszählung der Lücken:** Lückenlänge = Anlagedatum − Ernte-/Umbruchdatum in Tagen.
   Der Ernte-/Umbruchstag ist unbegrünt, der Anlagetag begrünt; eine Lücke ist zulässig,
   wenn sie höchstens 30/30/50 Tage beträgt. Wird die Frist überschritten, gilt die
   gesamte Lücke als unbegrünt (Beispiel Merkblatt S. 4: 40 Tage unbegrünt).
2. **Ungültige Zwischenfrüchte** (z. B. unter 42 Tage, zu wenige Mischungspartner) werden
   wie „nicht vorhanden“ behandelt; die Lücke zwischen den umgebenden Hauptfrüchten wird
   dann nach der 50-Tage-Regel bewertet. Das deckt das Beispiel S. 5 (41 Tage) ab; für den
   Fall, dass der gesamte Zeitraum ≤ 50 Tage ist, gilt die Fläche damit als begrünt.
3. **Zwischenfrucht nach Zwischenfrucht („Zug um Zug“):** zulässige Lücke 0 Tage
   (Umbruch und Neuanlage am selben Tag). „Unmittelbar“ ist in den Quellen nicht in Tagen
   beziffert.
4. **Umbruch von Grünbrache/Ackerfutter → Hauptfrucht** wird wie „Ernte Hauptfrucht –
   Anbau Hauptfrucht“ (50 Tage) behandelt; Grünbrache und Naturschutz-Selbstbegrünung zählen
   als Hauptfrucht-Gruppe.
5. **Offene Lücke am Jahresende** (Ernte ohne erfasste Folgekultur): Tage innerhalb der
   höchstzulässigen Frist (50 Tage nach Hauptfrucht, 30 Tage nach Zwischenfrucht) gelten
   vorläufig als begrünt, danach als unbegrünt.
6. **Winterhärte nach dem 20. September:** vor 2025 `frost_killed_share == 0`; ab dem
   Antragsjahr (= Jahr der Anlage) 2025 `frost_killed_share < 0.5`. Nach dem 20. September
   gilt keine Mindestzahl an Mischungspartnern (Reinsaat zulässig). Die SRL formuliert die
   3-Partner-Regel ohne Datumsbezug; das Merkblatt knüpft sie an die Anlage bis 20.09. –
   umgesetzt wurde die Merkblatt-Lesart.
7. **Ersteinstieg:** Für Zwischenfrüchte, die vor dem 1. Jänner des ersten Vertragsjahres
   angelegt wurden, werden die Termine 20.09./15.10. nicht geprüft; die Mischung muss
   entweder die 3-Partner/2-Familien-Regel oder die Winterhärte-Regel erfüllen. Die
   15.02.-Umbruchsperre und 42 Tage werden weiterhin geprüft.
8. **Ende des Mineral-N-Verbots:** Das Ende des Verbotszeitraums nach
   Nitrat-Aktionsprogramm-Verordnung ist in den Quellen nicht datiert; es wird als
   Eingabe `nitrate_ban_end_date` erwartet. Fehlt es, wird das Umbruchsdatum verwendet
   (Untergrenze) bzw. bei offenem Abschnitt jede Düngung ab Anlage als Verstoß gewertet.
9. **Walzen:** Rückverfestigungswalzen gilt bis 1 Tag nach Anlage als „unmittelbar“
   (Parameter `reconsolidation_rolling_max_days_after_sowing`). Späteres Walzen ist bei
   überwinternden Zwischenfrüchten erst nach dem 31.10. und nur bei Erhalt der
   flächendeckenden Begrünung zulässig (Merkblatt 2025-10 S. 6/7 und SRL 2.7 lit. e
   zusammen gelesen; der Merkblatt-Satz „Für den restlichen Begrünungszeitraum ist Walzen
   nicht erlaubt“ steht im Spannungsverhältnis zu „Walzen – z. B. bei Frost – ist möglich“).
10. **„Überwinternd“** = Abschnitt ohne Enddatum oder mit Enddatum in einem späteren Jahr als
    die Anlage.
11. **ES-Acker-Sperre nach Abmeldung:** umgesetzt als Verstoß, wenn die Abmeldung im
    Bewertungsjahr erfolgt und der Betrieb im selben Jahr die ES-Acker-Option
    Mulch/Direkt/Strip-Till beantragt und nicht an Maßnahme 6 teilnimmt. Das Merkblatt
    spricht vom „Folgejahr“ ohne klaren Bezugspunkt (Jahr der Begrünung vs. Jahr der
    Abmeldung).
12. **Flächenhinzunahmen nach dem 15. Oktober:** Ausgeschlossen werden unbegrünt übernommene
    Schläge mit Übernahmedatum nach dem 15.10. des Bewertungsjahres; ob die Hinzunahme
    ursächlich für die Überschreitung ist, wird nicht zusätzlich geprüft.
13. **Prämienfähigkeit auf Einzelflächen (Anhang L):** Schläge, die zusätzlich in nicht
    kombinierbaren Maßnahmen liegen (z. B. 18 Naturschutz, 19 EBW, 1C, 17, 23) oder K20
    tragen, erhalten keine Immergrün-Prämie, zählen aber zur 85 %-Ausgangsfläche.
    Grünbrachen (nicht aktiv bewirtschaftet) erhalten keine Prämie, außer als
    Biodiversitätsfläche (`DIV`) von UBB/BIO. Diese Auslegung ist durch die Quellen nicht
    explizit für System Immergrün bestätigt.
14. **Prämiensatz:** Der tatsächliche Satz im Band 70–90 €/ha wird von der AMA jährlich
    festgelegt; ohne Eingabe wird der garantierte Mindestbetrag 70 €/ha verwendet. Die
    Modulation wird auf die gesamte Betriebsfläche (`land.total_area_ha`) angewendet.
15. **Maßnahmengültigkeit:** Verstöße gegen inhaltliche Förderverpflichtungen (z. B. 85 %)
    führen nicht automatisch zu Prämie 0; Sanktionsstufen werden von der AMA nach Schwere,
    Ausmaß, Dauer und Häufigkeit festgelegt und sind daher nur als Tabelle abgebildet.
16. **Dürre 2026:** Die Fristüberschreitung (30/50 Tage) wird nur bei gesetztem Flag
    `drought_2026_late_sowing_justified` am Folgeabschnitt und Nachholung im Jahr 2026
    anerkannt. Die Erleichterung zur Flächendeckung/Ausfallgetreide gilt für 2026 angelegte
    Zwischenfrüchte mit `proper_sowing == true`. Die Ernte-Ausnahme gilt für Schläge im
    gelisteten Bezirk (Schlag- oder Betriebsbezirk) mit `no_harvestable_crop_due_to_drought`.
    Bezirksnamen müssen exakt der Schreibweise der AMA-Meldung entsprechen.
17. **Ernteverpflichtung:** Nur Schläge mit `usage_category == "main_crop"` werden auf 85 %
    Ernte geprüft (Ackerfutter und Grünbrache haben eigene Mindestbewirtschaftung, nicht
    implementiert).

## Offene Fragen

- Ist bei Zwischenfrüchten nach dem 20. September in Mischsaat (nicht Reinsaat) eine
  Mindestzahl an Mischungspartnern erforderlich? (SRL vs. Merkblatt)
- Genaues Ende des NAPV-Verbotszeitraums je Kultur/Region (nicht in den Quellen).
- Genaue Prämienwirkung auf Einzelflächen in NAT/EBW bzw. auf Grünbrachen für System
  Immergrün (Anhang L zeigt keine Kombinierbarkeit mit 18/19).
- Das Merkblatt führt keinen maßnahmenbezogenen OP-Code für System Immergrün an; die
  Eingabe `op_measure_codes` enthält daher den Maßnahmencode „7“.
