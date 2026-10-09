# o6_12: unveränderte Modellnotizen

Sämtliche Modellannahmen sind unbestätigt. Auch nicht einzeln priorisierte Auslegungen müssen vor Übernahme geprüft werden.

## luna: `v2-o6_12-luna-high-20261003`

# Annahmen und offene Punkte

- Das Canonical Farm Profile ist ein Schema-Template und enthält keine konkreten Betriebswerte. Im Modus `discover` werden deshalb die maßnahmenspezifischen Eingaben in `rules/profile_changes.json` vorgeschlagen; das Canonical Profile selbst bleibt unverändert.
- Für Rego werden die vorgeschlagenen Felder unter `input.farm.measures.o6_12` und den flächenbezogenen `operations`-Feldern verwendet. Die bestehende Profilstruktur enthält weder Teilnahme-/Fristfelder noch die nötigen Insektizid-Ausnahme- und Dokumentationsmerkmale.
- Die 2026-Dürre-Hinweise vom 22.05., 05.08. und 12.08. nennen keine Änderung der o6_12-Verpflichtung. Ihre sachlich nicht einschlägigen Ausnahmen wurden daher im Coverage-Ledger als `not_rule` dokumentiert.
- Die 12.06.2026-Mitteilung unterscheidet zwischen einem genehmigten rückzahlungsfreien Ausstieg und dem Verbleib in der Maßnahme bei behördlich angeordnetem Einsatz. Die beiden Pfade sind im Regelkatalog getrennt modelliert.
- `other_explicitly_marked_combinations` in der Datenstruktur bewahrt die in der Anhang-L-Zeile sichtbaren Maßnahmencodes; die Fußnote zum Organismen-Zuschlag wird als Prämienabschlag bei der Kombination mit o6_12 interpretiert. Die Anhang-L-Fußnoten 1, 2 und 4 betreffen andere Maßnahmen bzw. Kulturtypen und wurden nicht als zusätzliche o6_12-Entscheidung modelliert.


## opus: `v2-o6_12-opus-5.5-high-20260926`

# Annahmen und offene fachliche Fragen – o6_12 Insektizidverzicht Wein, Obst und Hopfen

Run: `v2-o6_12-opus-5.5-high-20260926` (Modus `discover`)

## Eingabemodell

- Alle neuen Eingabefelder sind in `rules/profile_changes.json` als Vorschläge erfasst.
  Die Rego-Regeln lesen sie mit `object.get` und Standardwerten. **Fehlende Angaben
  werden als unbedenklich behandelt**, z. B. `location.in_austria` = true oder
  `minimum_management.*` = true. Ein Befund entsteht also nur, wenn eine Angabe
  ausdrücklich negativ ist. Eine Vollständigkeitsprüfung der Eingaben ist nicht Teil
  der Regeln.
- Fehlt `crop.special_crop_type`, wird auf `crop.crop_category` zurückgegriffen:
  vineyard → Wein, orchard → Obst, hop → Hopfen. Diese Flächen gelten dann als voll
  prämienfähig. Schnittweingärten, Reb-/Baumschulen und „Sonstige“ Flächen lassen
  sich nur über `special_crop_type` unterscheiden.
- Bei Obstflächen wird `crop.crop_name` per Präfix gegen die Obstliste geprüft (z. B.
  „Apfel“, „Walnuss“). Nicht gelistete Namen führen zu `fruit_crop_not_in_oepul_fruit_list`.
  Die Sammelbegriffe „andere Schalenfrüchte“ und „verwandte Züchtungen/Kreuzungen“ lassen
  sich über den Namen nicht vollständig abgleichen.

## Fachliche Mehrdeutigkeiten

1. **Sonstige Weinflächen und Mindestteilnahmefläche bzw. Verzicht:** Sonstige
   Weinflächen erhalten keine Prämie und sind nicht förderfähig. Angenommen wird: Sie
   zählen **nicht** zur Mindestteilnahmefläche von 0,50 ha, sind als Weinfläche des
   Betriebes aber **vom Insektizidverzicht erfasst**. Das ist die vorsichtige
   Auslegung von „gesamte Wein-, Obst- und Hopfenfläche des Betriebes“. Sonstige
   Spezialkulturflächen gelten nicht als WOH-Fläche.
2. **Flächenabgangs-Toleranz (5 % / 5 ha / 0,5 ha):** Nach SRL 1.7.2.5 sind die Flächen
   der Maßnahme 12 an die jährlich verfügbaren WOH-Flächen gebunden. Die Toleranz nach
   1.7.2.3 wird für Maßnahme 12 daher nicht angewendet. Sie ist als Funktion
   (`area_reduction_tolerance_ha`) umgesetzt, und `area_reduction_repayment_ha` bleibt
   bei jährlich gebundenen Maßnahmen undefiniert. Ob ein vollständiger Verlust aller
   WOH-Flächen als Ausstieg gilt, bleibt offen.
3. **Behördlich angeordnete Bekämpfung vor 2026:** Laut SRL 2.12 ist der „behördlich
   zugelassene Wirkstoff“ zulässig. Die 2026-Meldung präzisiert: Chemisch-synthetische
   Mittel sind nur zulässig, wenn sie dezidiert angeordnet sind oder keine
   Bio-Wirkstoffe verfügbar sind. Diese präzisere Logik wird für alle Jahre angewendet
   (`order_covers_chemical_synthetic`). Ein angeordneter Einsatz mit einem Bio-Mittel
   ist immer zulässig.
4. **Upload/Übermittlung der Anordnung:** Das Maßnahmenblatt (Kap. 4.2) verlangt den
   Upload der Anordnung im Rahmen der PSM-Codierung, die bis 2025 gilt. Die Meldung
   vom 12.06.2026 sagt, dass keine Übermittlung an die AMA erforderlich ist. Umgesetzt:
   Upload nur, solange `psm_coding_required` gilt (≤ 2025). Die Dokumentation am Betrieb
   ist in allen Jahren verpflichtend.
5. **Rebzikaden-Ausstieg 2026:** Die Meldung verlangt „Betriebe mit Weinflächen“. Es
   wird nur geprüft, ob mindestens ein Weinschlag vorhanden ist; das gilt auch für
   Schnittweingärten und Sonstige Weinflächen. Der Ausstieg gilt als genehmigt, wenn
   die formalen Voraussetzungen erfüllt sind und `approved` nicht ausdrücklich `false`
   ist. Die AMA-Genehmigung ist also als Eingabe modelliert. Keine Prämie wird nur für
   das Jahr der Meldung angenommen, in dem der Vertrag endet. Chemisch-synthetische
   Insektizideinsätze ab dem Meldedatum gelten nicht als Verstoß.
6. **Obergrenze für Flächenzahlungen:** Die Quellen sagen nicht, bei welcher Maßnahme
   die Kappung wirkt. Angenommen wird eine Kappung beim Anteil der Maßnahme 12. Die
   übrigen Flächenzahlungen des Schlags kommen als Eingabe
   (`other_area_payments_eur_per_ha`), und zwar ohne die Maßnahmen, die laut
   Förderobergrenzen-Tabelle nicht eingerechnet werden (6, 7, 10 bzw. 1C).
7. **Reihenfolge der Kürzungen:** Umgesetzt ist eine vereinfachte Reihenfolge:
   inhaltliche Kürzung → Modulation → Obergrenze (SRL 1.12.2). Flächenabweichungen
   (§§ 42–47 GSP-AV), Fristversäumnis (§ 33 GSP-AV) und Konditionalitätskürzungen sind
   nicht modelliert, weil die GSP-AV nicht im Quellpaket enthalten ist. In der
   Coverage ist dieser Punkt als `unresolved` vermerkt.
8. **Sanktionsstufe:** Die AMA setzt die Kürzungsstufe fest (Schwere, Ausmaß, Dauer,
   Häufigkeit). Sie ist daher Eingabe (`oepul.o6_12.sanction.stage`) und wird nicht aus
   den Befunden abgeleitet. Die Verwarnung bedeutet bis 2026 0 % und ab 2027 1 %
   Einbehalt.
9. **Mindestauszahlung 50 €:** Das ist eine Kann-Bestimmung. Sie wird nur als Hinweis
   (`payout_may_be_withheld_below_minimum`) ausgegeben und ohne Angabe von
   `oepul.total_payment_eur` auf die Nettoprämie der Maßnahme 12 angewendet.
10. **Anhang L:** Die Matrix wurde aus dem PDF-Layout nach Spaltenpositionen
    extrahiert: 134 Zellen, symmetrisch konsistent. Für Maßnahme 12: 1A (nur
    Landschaftselemente), 2, 10 (Fußnote 3), 11. Die Zelle 12/10 mit Fußnote 3 wird als
    „combinable_with_reduction“ des Organismen-Zuschlags (10) gedeutet. Die
    Prämienreduktion trifft laut SRL S. 65 den Zuschlag der Maßnahme 10 (−50 %), nicht
    die Prämie der Maßnahme 12.
11. **Bio-Teilbetrieb:** Die Kombination mit 1B ist nur zulässig, wenn der biologisch
    bewirtschaftete Teil den Kulturbereich Acker/Grünland umfasst. Dann liegen die
    WOH-Flächen im konventionellen Teil.
12. **Zahlungsantrag:** Im ersten Verpflichtungsjahr wird der fehlende Zahlungsantrag
    nicht gesondert modelliert. Dort gilt die Zugangslogik: kein Vertrag.
13. **Nationalparks:** Nur Neusiedlersee und Donau-Auen schließen die Prämie der
    Maßnahme 12 aus. Kalkalpen schließt nur Maßnahme 14 aus, andere Nationalparks
    nichts. Eine mögliche Prämienfreiheit wegen „relevanter Bewirtschaftungsauflagen“
    in anderen Nationalparks ist nicht modelliert.
14. **Dürre-Meldungen 2026:** Die automatische Anerkennung höherer Gewalt für die
    Ernteverpflichtung betrifft ausschließlich Ackerkulturen. Die Bezirkslisten wurden
    deshalb bewusst nicht nach `data/` übernommen. Für WOH-Flächen bleibt das
    einzelbetriebliche Ansuchen erforderlich.

## Quellenbelege

- `evidence_text` wurde maschinell gegen die seitenmarkierte Textfassung (zeilengenau)
  und gegen die pypdf-Extraktion derselben PDF-Seite geprüft (whitespace-normalisiert).
  Bei HTML wurde gegen den Rohtext und den tag-bereinigten Text geprüft. Alle 190
  Belege sind auffindbar.
- Die Sonderrichtlinie enthält in der Textfassung Extraktionsartefakte, z. B. „au f“
  oder „Fläch en“. Belege wurden daher auf artefaktfreie Zeilenabschnitte beschränkt.
