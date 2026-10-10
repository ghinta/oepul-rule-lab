# o6_4 Bewirtschaftung von Bergmähdern – Annahmen und offene Fragen

Run: `v2-o6_4-opus-5.5-high-20261009` (Modus `discover`)

## Auslegung der Quellen

1. **„Mehr als die Hälfte“ / „überwiegender Teil“ über 1.200 m** (MB S. 2, SRL S. 51,
   GSP-AV § 25 Abs. 3 Z 3): umgesetzt als streng größer als 50 % (`share > 50`). Genau
   50 % reicht nicht.
2. **Almbetriebe** (MB S. 2): „kann die Bergmahdfläche auch unter der Almbetriebsstätte
   liegen“ wird so ausgelegt, dass bei `farm.is_alm_operation == true` die Bedingung
   „über der Seehöhe des Heimbetriebes“ entfällt. Die 1.200-m-Bedingung bleibt bestehen.
   Wie die Heimbetriebsstätte eines Almbetriebs genau bestimmt wird, regeln die Quellen nicht.
3. **„In der Regel nicht unmittelbar angrenzend“** ist nur ein Indiz. Es erzeugt eine
   Warnung (O64-ELIG-005) und keinen Ausschluss.
4. **Mahd „zumindest jedes zweite Jahr“** (O64-OBL-001): Geprüft wird am Jahresende.
   Ein Verstoß liegt vor, wenn weder im Antragsjahr noch im Vorjahr eine vollflächige Mahd
   mit Verbringung stattfand. Im ersten Vertragsjahr wird nicht geprüft. Auch Jahre vor
   Vertragsbeginn zählen, wenn sie in `full_mowing_years` erfasst sind. Bei einer
   unterjährigen Auswertung kann das Ergebnis vorläufig sein.
5. **Nachweide**: Das Informationsblatt nennt „ab dem 16. August“, die SRL „nach dem 15.08.“.
   Beides wird gleich ausgelegt: Ein Beweidungsbeginn ab dem 16.08. ist zulässig.
   Für die Nachweide werden nur Beginndaten im Antragsjahr ausgewertet.
6. **Gemähtes und liegen gelassenes Mähgut** zählt nicht als Mahd im Sinne von O64-OBL-001.
   Für die Codierung gilt es als „keine Mahd“ (erwarteter Code BM0). Zusätzlich liegt ein
   Verstoß nach O64-OBL-003 vor.
7. **Mähcode bei mehreren Verfahren**: Entscheidend ist das Hauptmähverfahren (Beispiel:
   Motormäher plus Sense ergibt BM2). Pro Mahdereignis wird nur das Hauptverfahren
   erfasst (`method`). Der Rang in `mowing_method_rank` ist nur nötig, wenn mehrere
   Ereignisse vorliegen. Diese wären dann aber ohnehin ein Verstoß nach O64-OBL-002.
8. **Code-Abweichung**: Liegen Mahdereignisse vor, wird die Prämie nach dem tatsächlich
   festgestellten Code berechnet (`effective_code`). Andernfalls wird der beantragte Code
   verwendet. Die Abweichung wird als Verstoß ausgegeben. Die Sanktionshöhe für
   Code-Abweichungen (Flächen- bzw. Prämienabweichung nach § 46 Abs. 2 GSP-AV) wird
   nicht automatisch berechnet.
9. **Unzulässige Kombination** (O64-PRM-003): Beantragt ein Schlag eine andere
   flächenbezogene Maßnahmenprämie, wird für o6_4 keine Prämie berechnet, bis die Kombination
   nach O64-GEN-017 korrigiert ist. Welche Prämie tatsächlich entfällt, legt die AMA fest.
   `premium_measures` meint Flächenprämien. Die Abgeltung punktförmiger Landschaftselemente
   aus 1A/1B ist getrennt in `point_landscape_elements` erfasst.
10. **LSE-Abgeltung**: Wird angewendet, wenn der Betrieb an 1B oder (ohne 1B) an 1A
    teilnimmt. Die Grenze „max. 80 Bäume je ha am Feldstück“ wird nicht automatisch
    gekappt, weil das Feldstück im Profil nicht abgebildet ist. Ein Obergrenzen-Überhang
    (O64-GEN-024) wird vollständig vom o6_4-Betrag abgezogen. Die Aufteilung zwischen den
    Maßnahmen regeln die Quellen nicht.
11. **Kürzungsreihenfolge**: Umgesetzt sind inhaltliche Kürzung → Modulation → Obergrenze →
    Zugangskürzung (SRL 1.12.2). Übererklärung (§ 46), Untererklärung (§ 47) und
    Konditionalität werden als eigene Größen ausgegeben (`over_declaration_sanction_ha`)
    und nicht mit dem Nettobetrag verrechnet.
12. **Sanktionsstufen**: Die Einstufung nach Schwere, Ausmaß, Dauer und Häufigkeit ist eine
    Ermessensentscheidung der AMA. Rego übernimmt eine bewertete Stufe
    (`assessed_findings[].level`, 0 = Verwarnung, 1–6 = 2 % … 100 %), erhöht sie bei
    Wiederholung derselben Verpflichtung und addiert die Kürzungen bis höchstens 100 %.
    Ab 2027 bedeutet Stufe 0 einen Einbehalt von 1 %.
13. **Flächenzugang ab 2026**: Die Grenze ist Fläche 2025 + max(50 % der Fläche 2025; 5 ha)
    + Zugänge, die vorher mit derselben Maßnahme belegt waren. Ist die prämienfähige Fläche
    größer, wird sie anteilig gekürzt (`access_factor`). Wie die Kürzung auf einzelne
    Schläge verteilt wird, regeln die Quellen nicht.
14. **Flächenabgang**: Toleranz = max(0,5 ha; min(5 % der Vorjahresfläche; 5 ha)).
    Abgänge durch Verlust der Verfügungsgewalt und zulässige Umwandlungen werden vorher
    abgezogen.
15. **Maßnahmenbezogener OP-Code**: Die Quellen nennen nur Beispiele (OPBIO, OPUBB, …),
    aber keinen Code für o6_4. Er wird deshalb als boolesches Flag
    `measure_specific_op_code_o6_4` erfasst.
16. **Höhere Gewalt**: Eine Meldung gilt als fristgerecht, wenn sie binnen 21 Kalendertagen
    ab `able_to_report_date` erfolgt und belegt ist (`documented`). Alternativ genügt
    `automatically_recognized` (Gebietsmeldung nach § 6 Abs. 3). Eine anerkannte Meldung
    entschuldigt alle Verstöße auf den genannten Schlägen. Eine Differenzierung nach
    einzelnen Auflagen ist nicht umgesetzt.
17. **Hinweise 2026**: Keiner der vier Hinweise betrifft o6_4 (O64-2026-001). Die
    Dürre-Erleichterungen gelten für Acker-Ernteverpflichtung, Begrünungen, UBB/BIO-
    Biodiversitätsflächen, Naturschutz/Natura 2000 und gefährdete Nutztierrassen. Für
    Bergmähder bleibt nur das einzelbetriebliche Ansuchen auf höhere Gewalt
    (O64-2026-002). Daraus wird keine automatische Anerkennung abgeleitet.
18. **Ausstieg**: Eine Abmeldung im laufenden Jahr sperrt die Prämie dieses Jahres. Eine
    Rückforderung wird angenommen, außer bei gültigem Umstieg (O64-APP-003) oder
    anerkannter Ausnahme (`exit_without_repayment_recognized`, z. B. dauerhafte Umstände,
    Revisionsklausel). Der Umfang der Rückforderung (bereits ausgezahlte Beträge) wird
    nicht berechnet, weil die Zahlungshistorie fehlt.
19. **Mindestbetrag 50 €**: `payment_may_be_waived` kennzeichnet nur das Ermessen der AMA
    („kann“). Die Prämie wird nicht automatisch auf null gesetzt.

## Nicht in Rego umgesetzte Regeln

Für folgende Regeln gibt es keine prüfbaren Eingaben im Profil oder sie sind rein
verfahrensbezogen. Sie sind im Katalog mit Belegen erfasst.

Ohne Rego- und ohne Datensymbol:

- O64-ELIG-009 (GIS-Hilfsmittel), O64-CTL-001, O64-GEN-001, O64-GEN-008, O64-GEN-009,
  O64-GEN-011, O64-GEN-016, O64-GEN-022, O64-GEN-037, O64-GEN-040, O64-GEN-041,
  O64-GEN-043, O64-XM-002 (Zuschläge in den Zielmaßnahmen nach Umstieg)

Nur als Daten unter `data/` abgebildet, ohne eigene Rego-Prüfung:

- O64-ELIG-011 (Stichtag 1. April, 14 Tage nicht-landwirtschaftliche Nutzung),
  O64-PRM-006, O64-GEN-010, O64-GEN-012, O64-GEN-038, O64-GEN-039, O64-GEN-044,
  O64-XM-001

## Offene Fragen

- Wird die Mahdpflicht „jedes zweite Jahr“ im ersten Vertragsjahr nach der Mahd im Jahr
  vor Vertragsbeginn beurteilt? Derzeit: Das erste Vertragsjahr ist ohne Mahd zulässig.
- Schließt „vollflächige Mahd“ kleinere ungemähte Teilflächen (Felsblöcke, Bäume) aus?
  Das Beispiel BM2 legt nahe, dass das Ausmähen um Hindernisse zur vollflächigen Mahd gehört.
- Welcher OP-Code wird maßnahmenbezogen für o6_4 verwendet?
- Gilt nach einem Umstieg in Naturschutz oder EBW auf der umgewandelten Fläche weiterhin
  das o6_4-Beweidungsverbot? Derzeit: Die Fläche erhält keine o6_4-Prämie mehr. Die
  Auflagen der Zielmaßnahme liegen außerhalb dieses Katalogs.
