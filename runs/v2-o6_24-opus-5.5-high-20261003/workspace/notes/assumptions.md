# Annahmen und offene Punkte – o6_24 „Wasserrahmenrichtlinie – Landwirtschaft“

Run: `v2-o6_24-opus-5.5-high-20261003` (Modus `discover`)

## Fachliche Annahmen

1. **Mindestteilnahme 2,00 ha**: Gezählt wird jede bewirtschaftete Ackerfläche
   (Nutzungsart A) in der Gebietskulisse, auch Flächen mit Bewilligung zu
   erhöhten N-Gaben (OPWRRL) und Brachen. Maßnahmenblatt und SRL sprechen von
   „bewirtschafteter Ackerfläche“, nicht von prämienfähiger Fläche.
2. **Gebietskulisse und Düngeklassen** werden als Eingabe erwartet
   (`land.parcels[].wrrl.in_area`, `fertilization_classes`). Die Anlagen 1 und 2B
   (Gemeindeliste, Detailpläne) liegen nur als Kartenverweis vor
   (Coverage `gw.anl2` = unresolved).
3. **Gewichtetes Mittel**: Es wird auf 2 Dezimalstellen gerundet (133,2 kg).
   Das Maßnahmenblatt nennt 133 kg; ob abgerundet werden muss, bleibt offen.
4. **Anzurechnende N-Menge** = Summe jahreswirksamer N-Gaben
   + N-Nachlieferung aus Vorfrucht/Ernterückständen + Gießwasser-N. Dass diese
   Summe mit der Tabellenobergrenze verglichen wird, ist eine Auslegung von
   Anlage 3 Punkt 1 („zu berücksichtigen“).
5. **10 %-Erhöhung**: nur für Kulturen der Tab. 2 (Ackerbau), nicht für Feldgemüse
   (Punkt 2 „im Ackerbau“). Die Erhöhung gilt für die gewichtete Obergrenze.
6. **Tab. 4-Zuordnung**: Die Zuordnung von Tab.-2/3-Kulturen zu Tab.-4-Zeilen
   (`crops_tab2_tab3`) ist eine Hilfstabelle dieses Runs. Bei „Weizen“ ist
   Winter- oder Sommerung nicht erkennbar. Ohne `gwsp_period_crop` wird daher die
   Zeile „andere Kulturen außer Begrünungen“ angenommen und als Hinweis ausgegeben.
7. **Punkt 4 (> 100 kg N/ha in < 3 Wochen)**: Umgesetzt als gleitendes
   21-Tage-Fenster ab jeder Gabe. Damit gilt auch eine Einzelgabe über 100 kg N/ha
   als nicht geringfügig. Ob nur mehrere Gaben gemeint sind, ist offen.
8. **Zeitraum Düngung–Anbau (10 Tage)**: Geprüft werden Gaben am oder vor dem
   Anbaudatum. Wintergerste ist über die Sonderregelung mit 6 Tagen erfasst.
9. **Anlage 3 Punkt 4 und 5, Hinweis 2 (WRG 175/210 kg), § 6 GWSP** sind keine
   ausdrücklich in SRL 2.24 genannten Förderverpflichtungen. Sie werden als
   wasserrechtliche Basisbefunde (`baseline_findings`) und nicht als
   sanktionsrelevante ÖPUL-Verstöße ausgegeben. Das gilt auch für den Hinweis zur
   Sojabohne: Nach dem Wortlaut stammt er aus der NAPV.
10. **Fassung des GWSP**: Die SRL nennt LGBl. Nr. 70/2020, das Maßnahmenblatt
    „i.d.g.F.“. Die Daten bilden Anlage 3 in der Fassung LGBl. Nr. 47/2026 ab
    (in Kraft ab 08.06.2026). Für Düngungen vor diesem Datum könnten abweichende
    Vorgängerwerte gelten, die nicht in den Quellen enthalten sind.
11. **Brachflächen**: Nur die SRL (nicht das Maßnahmenblatt) schließt Brachflächen
    aus. Die Regel folgt der rechtsverbindlichen SRL.
12. **Kombination (Anhang L)**: Ein Kombinationskonflikt auf einem Schlag macht
    diesen Schlag für o6_24 im Modell nicht prämienfähig, bis die Kombination
    korrigiert wird. Welche Maßnahme die Prämie verliert, regeln die Quellen nicht.
13. **Obergrenze 1.300 €/ha und Modulation**: Die Modulation wird vor der
    Obergrenzenprüfung angewendet (Reihenfolge SRL 1.12.2). Andere
    Flächenzahlungen je Schlag sind als Eingabe zu liefern.
14. **Sanktionsstufen**: Die Grundstufe je Verstoß legt die AMA fest (Schema nicht
    in den Quellen). Die Eingabe `base_level` (0 = Verwarnung … 6 = 100 %) ist
    daher erforderlich. Modelliert sind Eskalation, Kumulierung, 1 %-Einbehalt
    ab 2027 und Ausschluss bei zweiter 100 %-Kürzung.
15. **Dürre-Ausnahme 2026**: Sie wird auf Bezirksebene
    (`farm.region.federal_state`, `farm.region.district`) geprüft. Die Kulisse
    deckt sich mit den GWSP-Bezirken Graz, Graz-Umgebung, Leibnitz und
    Südoststeiermark.
16. **Nationalpark**: In den Quellen ist kein Nationalpark in der WRRL-Kulisse
    genannt. Die Ausnahme ist dennoch als Regel abgebildet.

## Offene, nicht auflösbare Referenzen

- Die NAPV (Düngeobergrenzen für nicht tabellierte Kulturen; Ausbringungszeiten
  für Kompost und Festmist von Huf- und Klauentieren) ist nicht Teil der Quellen
  dieses Runs. Die Rego-Regeln geben nur einen Hinweis aus (`napv_limit_required`).
- Die Kartenwerke Anlage 2A/2B des GWSP sind nur als Verweis vorhanden.

## Technische Hinweise

- Fünf Tabellenzeilen-Belege (Anhang L Zeile 24; Anlage 3 Tab. 2 „Weizen“ und
  Tab. 4 „Körnermais, Silomais“, „Winterweizen, Triticale“, „andere Kulturen“)
  stimmen wörtlich mit dem bereitgestellten seitenmarkierten Text überein, der
  der pypdf-Extraktion entspricht. In einer Extraktion mit `pdftotext` (ohne
  Layout) werden die Tabellenspalten anders umbrochen.
- Die Profiländerungen sind ausschließlich Ergänzungen (`add`). Die vorhandenen
  Felder `operations.fertilizer.*` (Jahressummen) reichen für die datumsbezogenen
  Prüfungen nicht aus und bleiben unverändert.
