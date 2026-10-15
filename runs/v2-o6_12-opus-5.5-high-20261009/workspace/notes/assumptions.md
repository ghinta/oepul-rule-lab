# Annahmen und offene Fragen – o6_12 Insektizidverzicht Wein, Obst und Hopfen

Run: `v2-o6_12-opus-5.5-high-20261009` (Modus `discover`)

## Quellenkonflikte

1. **PSM-Angabe ab 2026 (Merkblatt vs. GSP-AV).** Laut Merkblatt (Stand April 2026,
   Kap. 4.2 und 7) entfällt die PSM-Codierung ab dem Antragsjahr 2026. Die GSP-AV in
   der Fassung vom 28.01.2026 enthält in § 34 Abs. 2 Z 12 lit. f weiterhin die
   Angabepflicht für 70-10, und SRL 1.12.1.3 wertet diese Angabe als inhaltliche
   Bewirtschaftungsauflage. Umgesetzt ist die Merkblatt-Regel
   (`psm_coding_required` nur bis 2025). Offen bleibt, ob die Pflicht nach GSP-AV
   formal noch besteht und nur nicht mehr vollzogen wird.
2. **Upload der behördlichen Anordnung.** Das Merkblatt verlangt bei angeordnetem
   chemisch-synthetischem Insektizideinsatz den Upload der Anordnung über eAMA. Laut
   Rebzikade-Hinweis vom 12.06.2026 ist dagegen keine Übermittlung an die AMA nötig;
   eine Dokumentation am Betrieb reicht. Umgesetzt ist der Upload als Pflicht bis
   einschließlich 2025, gekoppelt an das Ende der PSM-Codierung. Ab 2026 gilt nur
   noch die Dokumentationspflicht.

## Auslegungsannahmen

3. **Geltungsbereich des Verbots.** Der Verzicht gilt auf der *gesamten* Wein-, Obst-
   und Hopfenfläche des Betriebes, auch auf Flächen ohne Prämie (z. B. nicht beantragt,
   Code OP, Sonstige Weinflächen). Ausgenommen sind nur Reb- und Baumschulen, weil
   diese laut Merkblatt nicht zur Weinfläche zählen.
4. **Behördliche Anordnung – Bio-Vorrang.** Die Einschränkung aus dem Hinweis 2026
   (chemisch-synthetisch nur bei dezidierter Anordnung oder fehlenden Bio-Wirkstoffen)
   wird für alle Jahre angewendet. Sie wird als Konkretisierung von SRL 2.12
   („behördlich zugelassener Wirkstoff“) gelesen. Zusätzlich muss der eingesetzte
   Wirkstoff von der Anordnung gedeckt sein (Eingabe `substance_approved_by_order`).
5. **Kauf/Lagerung bei behördlicher Anordnung.** Bestände, die einer erfassten
   behördlichen Anordnung zugeordnet sind, gelten nicht als verbotener Kauf bzw. als
   verbotene Lagerung. Die Quellen regeln das nicht ausdrücklich.
6. **Flächenabgang.** Wegen der jährlichen Flächenbindung (SRL 1.7.2.5) löst eine
   Verringerung der Wein-, Obst- und Hopfenfläche bei Maßnahme 12 keine Rückzahlung
   nach der 5-%-Toleranzregel (SRL 1.7.2.3) aus. Die Toleranzfunktion ist trotzdem als
   allgemeine Regel implementiert (`general_area_reduction_within_tolerance`).
7. **Rebzikade-Ausstieg in Folgejahren.** Der Hinweis nennt ausdrücklich „keine
   Prämie im Antragsjahr 2026“. Für einen Ausstieg ab 2027 wird angenommen, dass im
   jeweiligen Ausstiegsjahr ebenfalls keine Prämie gewährt wird; für spätere Jahre
   besteht kein Vertrag mehr. Liegt keine Entscheidung vor (`approved` fehlt), gilt der
   Ausstieg als wirksam beantragt; nur ein ausdrückliches `approved: false`
   verhindert ihn.
8. **Mindestteilnahmefläche.** Angerechnet werden Wein-, Obst- und Hopfenflächen in
   Österreich ohne Reb-/Baumschulen und ohne die als nicht förderfähig gelisteten
   Schlagnutzungsarten (Sonstige Wein-/Spezialkulturflächen). Liegt das erste
   Verpflichtungsjahr zurück und fehlt `first_year_area_ha`, liefert die Prüfung
   `unknown`.
9. **Obstkultur „andere Schalenfrüchte“.** Die Liste nennt „Haselnuss sowie andere
   Schalenfrüchte“. In `fruit_crops.json` ist dafür eine Sammelposition „Andere
   Schalenfrüchte“ angelegt; die konkrete Zuordnung einzelner Nussarten ist offen.
10. **Maßnahmenbezogener OP-Code.** Die Quellen nennen keinen konkreten
    maßnahmenbezogenen OP-Code für Maßnahme 12 (analog OPBIO, OPUBB). Abgebildet wird
    er über `measure_op_exclusions: ["12"]`.
11. **Obergrenze je Schlag.** Die Quellen legen nicht fest, welche Maßnahme bei
    Überschreitung der Obergrenze gekürzt wird. Ausgegeben wird nur die Überschreitung
    je ha (`parcel_cap_excess_eur_per_ha`); die übrigen Zahlungen je Schlag sind eine
    Eingabe (`other_area_payments_eur_per_ha`).
12. **Kürzungsreihenfolge.** Die Zahlungsschätzung (`payment_estimate_eur`) wendet in
    vereinfachter Reihenfolge an: Übererklärung, inhaltliche Kürzung, Modulation. Die
    vollständige Reihenfolge nach SRL 1.12.2 liegt als Daten vor. Fristversäumnis-,
    Obergrenzen- und Konditionalitätskürzungen werden nicht berechnet, weil dafür keine
    Eingaben vorliegen.
13. **Sanktionsstufe.** Die Einstufung eines Verstoßes (Stufe 1–7 nach Ausmaß,
    Schwere, Dauer) nimmt die AMA vor und ist hier eine Eingabe. Berechnet werden nur
    Wiederholungserhöhung, Kumulation, Deckelung und Ausschluss.
14. **Aufbewahrungsfrist.** § 16 Z 1 GSP-AV wird als „vier Jahre ab Ende des
    Vertragszeitraums“ gelesen. Das ergibt bei Vertragsende 31.12.2028 eine
    Aufbewahrung bis 31.12.2032 bzw. ab einem vorzeitigen Vertragsende.
15. **Dürre 2026.** Die automatische Anerkennung der nicht erfüllten Ernteverpflichtung
    gilt laut Hinweisen nur für Ackerkulturen. Für Wein-, Obst- und Hopfenflächen wird
    daher ein einzelbetriebliches Ansuchen auf höhere Gewalt verlangt
    (`individual_force_majeure_claim_needed`). Die Bezirksliste wird abgeglichen über
    `farm.region.district`; ein Bezirk je Parzelle wird nicht unterschieden.
16. **Nationalparks.** Nur Neusiedlersee und Donau-Auen schließen die Prämie der
    Maßnahme 12 aus. Die Ausnahme „keine relevanten Bewirtschaftungsauflagen“
    (SRL 1.6.2.2) wird mangels Eingabe nicht weiter differenziert.

17. **Prüfumfang Anhänge.** Die Anhänge A–K wurden nur per Volltextsuche nach der
    Maßnahme durchsucht, ohne Treffer. Sie wurden nicht seitenweise gelesen; der
    Coverage-Eintrag `ANH-A-K` führt daher keine Seitenangaben. Gelesen wurde nur
    Anhang L (S. 103).

## Offene Fragen

- Das Merkblatt nennt `www.betriebsmittelbewertung.at` als Liste erlaubter Mittel. Die
  Bio-Zulässigkeit eines Mittels ist eine Eingabe (`eu_2018_848_permitted`) und wird
  nicht gegen ein Register geprüft.
- Höhere Gewalt nach Art. 3 VO (EU) 2021/2116 ist nur als Sammelfall erfasst. Die
  dort genannten Einzelfälle liegen nicht im Quellenpaket.
- Die Bewertung von Sammelanträgen (eine Meldung für ein ganzes Katastrophengebiet,
  § 6 Abs. 3 GSP-AV) ist nicht abgebildet.

## Vorschläge zum Canonical Farm Profile

Das Ausgangsprofil enthält mit `operations.psm_used` nur einen Pauschalwert. Es fehlen
unter anderem Wirkungstyp, Bio-Zulässigkeit, Nutzungsart, Schlagnutzungsart,
Weinkataster, Veredelung, Codes, Maßnahmenbeantragung, Vertrags-, Ausstiegs- und
Sanktionsangaben. Alle Ergänzungen stehen in `rules/profile_changes.json` mit Regel- und
Quellenbezug.
