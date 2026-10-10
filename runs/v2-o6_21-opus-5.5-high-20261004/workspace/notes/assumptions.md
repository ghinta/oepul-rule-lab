# Annahmen und offene Fragen – o6_21 Tierwohl – Stallhaltung Rinder

Run: `v2-o6_21-opus-5.5-high-20261004` (Modus `discover`)

## Datenmodell

- Rego liest das Canonical Farm Profile (`farm.year`, `land.total_area_ha`) und die in
  `rules/profile_changes.json` vorgeschlagenen Erweiterungen (`farm.applicant`,
  `farm.programmes`, `farm.dairy`, `farm.oepul_first_participation_year`,
  `land.protected_cultivation_area_ha`, `livestock.cattle_animals[]`,
  `livestock.stall_compartments[]`, `livestock.solid_manure_composting`,
  `oepul_measures.o6_21`). `livestock.species_groups[]` reicht nicht aus, weil die Maßnahme
  einzeltier- (RDB, Ohrmarke) und stallabteilbezogen geprüft wird.
- Datumsangaben im Format `YYYY-MM-DD`. `on_farm_until` ist der letzte Tag am Betrieb
  (inklusiv); `null` heißt, das Tier ist noch am Betrieb.

## Fachliche Annahmen

1. **RGVE-Berechnung**: Taggenau je Altersstufe (< ½ Jahr, ½–2 Jahre, ≥ 2 Jahre). Die
   Grenzen ergeben sich aus Geburtsdatum + 6 Monate bzw. + 2 Jahre (Kalenderarithmetik).
   Der Jahresdurchschnitt ist die Summe aus Tagen × Faktor ÷ Tage des Jahres. Die
   Kategorie „Männliche Rinder ab ½ Jahr“ umfasst auch Tiere ab 2 Jahren (Faktor 1,0),
   da keine Altersobergrenze genannt ist.
2. **TGD-Schwelle (> 10,00 RGVE „förderbare Rinder“)**: berechnet aus allen Tieren der
   beantragten Kategorien vor Abmeldungen bzw. Haltungsverstößen (`gross_category_rgve`).
   Die Mindestteilnahme (2,00 RGVE) wird dagegen mit den prämienfähigen RGVE nach
   Abmeldungen geprüft.
3. **Gewichtsklassen**: „bis 500 kg“ schließt 500 kg ein, „ab 500 kg“ gilt für > 500 kg
   (Überschneidung bei genau 500 kg im Quelltext).
4. **Reduzierter Satz (162 €)**: Er gilt für das ganze Jahres-RGVE eines Tieres, sobald
   für dieses Tier Almbewirtschaftung, Tierwohl – Weide oder die gekoppelte Stützung für
   Almrinder beantragt wird. Eine zeitanteilige Aufteilung ist in den Quellen nicht
   beschrieben.
5. **Stallabteilprüfung**: Momentaufnahme zum `assessment_date` (Standard: 31.12. des
   Antragsjahres). Gezählt werden alle am Betrieb befindlichen Tiere des Abteils, auch
   nicht förderfähige Tiere, Kühe und Tiere auf der Weide. Die Ganzjahresvorgabe kann so
   nur näherungsweise abgebildet werden; für mehrere Zeitpunkte sind mehrere Auswertungen
   nötig.
6. **Haltungsverstöße je Tier** (Anbindung, Vollspalten, Einzelhaltung) zählen nur, wenn sie
   in den Teilnahmezeitraum des Tieres in einer gültigen Kategorie fallen (Beispiel
   „Kälber nach 7 Monaten auf Vollspalten“).
7. **Abmeldung „umgehend“**: Rechtzeitigkeit lässt sich nicht als Frist in Tagen abbilden.
   Geprüft wird nur, ob ein verpflichtend abzumeldendes Tier überhaupt abgemeldet wurde.
   Abgemeldete und nicht konforme Tiere sind im ganzen Förderjahr nicht prämienfähig.
8. **Wendefreie Kompostierung**: Das „nennenswerte Ausmaß (z. B. 50:50)“ ist kein fester
   Schwellenwert und wird als Boolean `added_material_significant` übernommen. Die Variante
   steht seit der Fassung Oktober 2025 im Informationsblatt, aber nicht in der SRL. Sie wird
   ohne Jahresbeschränkung angewendet.
9. **NAPV**: Für Kompostmieten auf unbefestigten Flächen werden nur Abdeckung und § 6
   Abs. 7 Z 2, 4, 5, 6 geprüft (Verweis in § 6 Abs. 1 Z 3). Ob § 9 Abs. 7 (Aufzeichnung von
   Feldmieten in Anlage-5-Gebieten) für Kompostmieten gilt, bleibt offen (Coverage
   `unresolved`).
10. **Sanktionen**: Die Sanktionsstufe (inkl. Erhöhung bei Wiederholung oder VOK) legt die
    AMA fest. Rego übernimmt die Stufen als Eingabe und rechnet nur Kumulation,
    100 %-Obergrenze, den 1-%-Einbehalt ab 2027 und den Ausschluss bei zweimaliger
    100-%-Kürzung.
11. **Übererklärung (§ 46 GSP-AV)**: Bei Rindern aus der RDB wird nur § 43 abgebildet
    (nicht ermittelte Tiere ohne Prämie). Eine Sanktion nach § 46 Abs. 4 für tierbezogene
    Prämien ist nicht implementiert, weil die Schwellen (3 %/2 ha) flächenbezogen formuliert
    sind.
12. **Ausstieg**: Eine Abmeldung mit Datum im Antragsjahr macht den abgemeldeten Umfang für
    dieses Jahr und alle Folgejahre ungültig. Spätere Neubeantragungen (Antragsdatum nach dem
    Ausstieg) sind wieder gültig. Ein Ausstieg nach Ankündigung einer Vor-Ort-Kontrolle ist
    unwirksam.
13. **Erlöschen einer Kategorie**: Rego meldet für das laufende Jahr, welche Kategorien
    erlöschen (`categories_lapsing`). Für Folgejahre muss das Erlöschen über
    `lapsed_after_year` eingegeben werden.
14. **Verspätete Wiederaufnahme**: Sie gilt nur bei Korrektur, schriftlichem Ersuchen und
    Anerkennung durch die AMA (Ermessen der AMA, daher Eingabe `late_reentry_accepted`).
15. **Modulation** wird auf die Maßnahmenprämie nach inhaltlichen Kürzungen angewendet
    (Reihenfolge SRL 1.12.2). Basis ist `land.total_area_ha`.
16. **Allgemeine Pflichten** ohne automatisierbare Prüfung (Konditionalität, Doppelförderung,
    Umgehungsverbot, Revisionsklausel usw.) erscheinen in `main.general_obligations`. Sie
    werden nur ausgewiesen und nicht als erfüllt oder verletzt bewertet.

## Offene Fragen

- SRL 1.7.4.2–1.7.4.5 (dauerhafte/vorübergehende bewirtschaftungsverändernde Umstände):
  Anwendbarkeit auf einjährige tierbezogene Verpflichtungen ist unklar (`unresolved`).
- Geltung der 2023-Sonderregel (Teilnahme ab 15.4.) für den TGD: Laut Informationsblatt ab
  Fassung April 2023 ergänzt; umgesetzt für TGD und Qplus.
- Abweichung SRL/Informationsblatt bei Qplus: Die SRL spricht von „vergleichbarer Programme
  für weibliche Mastrinder“. Laut Informationsblatt gibt es derzeit kein vergleichbares
  Programm, daher ist nur „Qplus Rind“ in den Daten hinterlegt.
- Die 2026-Hinweise vom 22.05., 12.06., 05.08. und 12.08.2026 enthalten keine
  Erleichterungen für o6_21. Der Hinweis vom 02.09.2026 bestätigt die Meldepflichten des
  Informationsblatts.
