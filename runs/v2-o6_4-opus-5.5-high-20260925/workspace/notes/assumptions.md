# Annahmen und offene Fragen – o6_4 „Bewirtschaftung von Bergmähdern“

Run: `v2-o6_4-opus-5.5-high-20260925`, Modus `discover`.

## Quellenlage

- Das Maßnahmenblatt (Stand Oktober 2025) und SRL 2.4 stimmen inhaltlich überein. Das Maßnahmenblatt ist
  laut Impressum rechtlich unverbindlich (GEN-LEGAL-001). Bei Formulierungsunterschieden wurde die jeweils
  engere Lesart implementiert und beide Quellen zitiert.
- **Nachweide:** Das Maßnahmenblatt sagt „ab dem 16. August“, die SRL „nach dem 15.08.“. Beides ist gleichwertig
  und wird als Beweidung erst ab dem 16.08. umgesetzt (`before_month_day(d, 8, 16)`).
- **Prämiensätze 2023:** Die Sätze 350/550/900 €/ha stehen nur im Maßnahmenblatt. Die SRL (Fassung 2024)
  nennt nur die Sätze ab 01.01.2024 (+8 % laut Präambel 1a). Beide Zeilen stehen in `data/o6_4/premium_rates.json`.
- Keine der vier 2026-Meldungen ändert o6_4-Auflagen. Übernommen wurden nur die allgemeinen Aussagen zu höherer
  Gewalt und zur Berücksichtigung der Trockenheit bei Vor-Ort-Kontrollen (N2026-FM-001, N2026-VOK-001).
  Die Freigabe der Nutzungstermine ab 12.08.2026 gilt nur für die Maßnahmen Naturschutz und Natura 2000.
  Für Bergmähder bleibt die Nachweidegrenze 16.08. bestehen.

## Fachliche Auslegungen in Rego

1. **„Mehr als die Hälfte“ / „überwiegender Teil“ über 1.200 m** wird streng als `> 50 %` umgesetzt; genau 50 %
   ist nicht teilnahmefähig. Der Anteil muss aus dem INVEKOS-GIS-Layer als Eingabe geliefert werden.
2. **Almbetriebe (O6_4-ELIG-004):** Die Ausnahme „kann auch unter der Almbetriebsstätte liegen“ wird so gelesen,
   dass bei Almbetrieben der Seehöhenvergleich mit der Betriebsstätte ganz entfällt. Das 1.200-m-Kriterium
   bleibt davon unberührt. Ob „Almbetrieb“ einen eigenständigen Almbetrieb oder einen Heimbetrieb mit Alm meint,
   ist offen; modelliert ist ein Boolean `farm.oepul_participation.is_alpine_farm_operation`.
3. **„In der Regel nicht angrenzend“ (O6_4-ELIG-005)** ist eine Regelvermutung. Sie erzeugt nur einen
   Prüfhinweis (`advisory`), keine Ablehnung.
4. **„Schwierig zu bewirtschaften“ (Hangneigung, Lage, Erreichbarkeit)** beschreibt den Förderzweck und ist
   keine eigene Prüfschwelle. Die Eingabe `difficult_to_manage` wird nur dokumentiert.
5. **Mahd jedes zweite Jahr (O6_4-MOW-001):** Die Mahd im Vorjahr wird aus `cutting_dates` des Vorjahres oder aus
   `operations.mowing.mowed_previous_year` abgeleitet. Ob die Vorjahresmahd vollflächig war und das Mähgut
   verbracht wurde, lässt sich mit dem Profil nicht prüfen und gilt als erfüllt. Ein Verstoß wird erst erkannt,
   wenn in zwei aufeinanderfolgenden Jahren keine Mahd stattfand.
6. **Mähverfahren bei gemischtem Einsatz (O6_4-CODE-003):** Nach den Beispielen bestimmt das Hauptmähverfahren
   den Code; das Ausmähen mit der Sense ändert ihn nicht. Für echte Mischflächen (z. B. halb Motormäher, halb Sense)
   enthalten die Quellen keine Aufteilungsregel. Es wird genau ein Code je Schlag erwartet (O6_4-CODE-002).
7. **Prämie je Schlag:** `area_ha × Satz`, auf Cent gerundet. Die Flächenermittlung und Abweichungssanktionen
   (§§ 42–47 GSP-AV) sind nicht modelliert, weil die GSP-AV nicht im Quellpaket liegt (Coverage `unresolved`).
8. **Kombinationsausschluss (O6_4-PREM-003):** Eine unzulässige Kombination wird als `combination_conflict`
   gemeldet. Die o6_4-Prämie wird dabei **nicht** automatisch auf 0 gesetzt, weil die Quellen nicht festlegen,
   welche der kollidierenden Prämien entfällt. GEN-COMB-001 sieht eine Korrektur bis zur Auszahlungsmitteilung vor.
   Die Zuordnung `o6_1a` → Anhang-L-Spalte `1A` usw. erfolgt über `annex_l_id`.
   „Punktförmige Landschaftselemente“ (Maßnahmenblatt) und „Landschaftselemente“ (SRL/Anhang L Fn. 1) werden
   gleich behandelt über `premium_component == "landscape_element"`.
9. **Prämienobergrenze (GEN-CAP-001):** Rego meldet nur die Überschreitung (`cap_exceeded`). Welche Zahlung
   gekürzt wird, ist nicht geregelt. Nach SRL 1.12.2 erfolgt die Kappung nach der Modulation.
10. **Flächenzugang und -abgang:** Die Funktionen `premium_eligible_area_limit_ha`, `area_addition_excess_ha`,
    `area_reduction_tolerance_ha` und `area_reduction_repayment_ha` rechnen auf Maßnahmenebene. Die Verteilung
    einer Zugangskürzung auf einzelne Schläge regeln die Quellen nicht; `parcel_premium` wird daher nicht gekürzt.
    In `reduction_exempt_ha` gehören Flächen mit Verlust der Verfügungsgewalt und zulässig umgewandelte Flächen.
11. **Modulation:** Als „gesamte Fläche des Betriebes“ dient `land.total_area_ha`. Die Almfläche wird getrennt
    betrachtet, betrifft o6_4 aber nicht. `modulation_factor(0) = 1`.
12. **Betriebsmindestgröße:** Die 1,50 ha werden gegen `land.total_area_ha` geprüft. Das ist eine Näherung, denn
    die Quelle zählt GA-, K20-, GLÖZ-LSE-, Mehrnutzenhecken- und Agroforstflächen hinzu.
13. **OP-Code:** Ein maßnahmenbezogener OP-Code für Bergmähder (analog OPBIO/OPUBB) wird in keiner Quelle genannt.
    Rego wertet nur `OP` und `VF` als prämienausschließend (`data.o6_4.general_parameters.op_code_mandatory_cases.no_premium_codes`).
14. **Nationalpark:** Ausgewertet wird schlagbezogen (`constraints.in_national_park`). Die Ausnahme „keine
    relevanten Bewirtschaftungsauflagen“ muss als Eingabe kommen. Die Auflagen werden weiter geprüft.
15. **Düngemittel:** Die geschlossene Liste in `data/o6_4/input_substances.json` stuft alle Düngemittel außer
    Festmist (ursprüngliche Form) und eigenen häuslichen Abwässern als unzulässig ein, darunter Kompost,
    Gärrückstand und Jauche. Grundlage ist der Satz „da sämtliche Düngemittel (außer Festmist) verboten sind“.
    Eine angegebene `mineral_n_kg_per_ha > 0` gilt ebenfalls als Verstoß. Die „Bedarfsgerechtheit“ der
    Festmistgabe ist nicht quantifiziert und wird nicht geprüft.
16. **Pflanzenschutz:** Ob nur bio-zulässige Wirkstoffe verwendet wurden, ist eine Eingabe
    (`psm_only_bio_approved_substances`); die Betriebsmittelliste (betriebsmittelbewertung.at) liegt nicht vor.
17. **Antragsfrist (O6_4-APP-001):** Der Maßnahmenantrag muss in einem Kalenderjahr vor dem Vertragsbeginn
    (01.01.) liegen, also spätestens am 31.12. des Vorjahres.
18. **Ausstieg/Rückforderung:** Befreiungsgründe sind als geschlossene Menge modelliert: Maßnahmenwechsel,
    Verlust der Verfügungsgewalt, höhere Gewalt bzw. dauerhafte Umstände, Revisionsklausel.
    Ob die AMA einen dauerhaften Umstand anerkennt, liegt in ihrem Ermessen und ist hier eine Eingabe.
19. **Sanktionsstufen:** Welcher Verstoß zu welcher Stufe führt, legt ein AMA-internes Bewertungsschema fest, das
    nicht vorliegt. Rego bildet nur Stufe → Prozentsatz ab, den 1-%-Einbehalt statt Verwarnung ab 2027 und den
    Ausschluss nach zwei 100-%-Kürzungen.
20. **Kleinbetrag (GEN-PAY-002):** „kann abgesehen werden“ ist eine Kann-Bestimmung. Rego liefert nur
    `payment_may_be_waived(amount)` (≤ 50 €).

## Offene Punkte (Coverage `unresolved`)

- SRL 1.12.1.2: Flächenabweichungen nach §§ 42–47 GSP-AV; der Text der GSP-AV ist nicht im Quellpaket.
- SRL 1.12.1.3, Satz zur PSM-Angabe gemäß § 34 Abs. 2 Z 12 lit. f GSP-AV („in den genannten Maßnahmen“):
  Ob o6_4 erfasst ist, lässt sich ohne GSP-AV nicht klären.

## Profilvorschläge

Alle neuen Eingaben stehen in `rules/profile_changes.json` und nutzen die Notation des Canonical Farm Profile
(Arrays mit einem repräsentativen Objekt). Neu sind die schlagbezogenen Bergmahdmerkmale, BM-/OP-Codes,
Maßnahmenzuordnung mit Landschaftselement-Komponente, Mahd- und Weidedetails, Düngemittelarten, der
Bio-PSM-Status und die Nationalparklage. Betriebsbezogen kommen Förderwerberstatus, Heimbetriebsseehöhe,
Almbetrieb und maßnahmenbezogene Vertrags- und Flächenhistorie hinzu.
