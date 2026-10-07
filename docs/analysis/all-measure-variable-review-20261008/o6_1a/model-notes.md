# o6_1a: unveränderte Modellnotizen

Sämtliche Modellannahmen sind unbestätigt. Auch nicht einzeln priorisierte Auslegungen müssen vor Übernahme geprüft werden.

## luna: `v2-o6_1a-luna-high-20260930`

# Fachliche Annahmen und offene Punkte

- Das Canonical Farm Profile enthält keine maßnahmenspezifischen Codes, Feldstück-IDs, DIV-Flächen, Prämienoptionen, Saatgutnachweise, Monitoringdaten oder 2026-Ausnahmecodes. Diese Werte werden im Modus `discover` ausschließlich in `rules/profile_changes.json` vorgeschlagen; das Canonical Farm Profile bleibt unverändert.
- Die Rego-Prüfungen erwarten für diese fehlenden Werte ein angereichertes Laufzeit-Inputobjekt. Die Regelbedingungen und die Profilpfade im Katalog bleiben quellengebunden; eine fehlende Variable darf nicht als fachliche Nichterfüllung interpretiert werden.
- Die 2026-Dürremeldungen sind zeitlich begrenzte Verwaltungserleichterungen. `o6_1a.drought_early_use` bildet deren Vorliegen als explizite Tatsachenvariable ab, weil die HTML-Meldung die konkrete Vorabnutzungsfreigabe nicht für jeden Schlag algorithmisch parametrisiert.
- Die dritte Acker-DIV-Nutzung 2026 ist als Sonderfall mit OPUBB/OPBIO und Prämie 0 modelliert. Für zusätzlich in NAT/EBW eingebrachte Flächen bleibt die Projektbestätigung vorrangig.
- Für seltene Sorten und regionale Saatgutarten wurde die vollständige in den bereitgestellten Anhängen enthaltene Liste in `data/o6_1a_tables.json` übernommen. Schreibvarianten wissenschaftlicher Namen werden als Datenwert beibehalten; die fachliche Listenmitgliedschaft ist maßgeblich.
- Die Rechtsgrundlage ist gezielt auf UBB, die allgemeinen Teilnahme-/Flächenregeln, die UBB-relevanten Anhänge A–C und die Kombinationsmatrix geprüft. Nicht UBB-spezifische Maßnahmenteile wurden als `not_rule` im Coverage-Ledger vermerkt.


## opus: `v2-o6_1a-opus-5.5-high-20260929`

# o6_1a (UBB) – Annahmen und offene fachliche Fragen

Run: `v2-o6_1a-opus-5.5-high-20260929`, Modus `discover`.

## Quellenhierarchie

- Rechtlich verbindlich ist die Sonderrichtlinie ÖPUL 2023 samt Anhängen. Das Informationsblatt (Stand April 2026)
  ist ausdrücklich unverbindlich, aber konkreter. Wo beide übereinstimmen, wird das Informationsblatt zitiert; bei
  Widersprüchen ist die Entscheidung unten dokumentiert.
- Die AMA-Hinweise 2026 werden als Festlegungen des BML gemäß SRL 1.7.4.4 behandelt und nur für das Antragsjahr 2026
  angewandt (`notices_2026.rego`, Jahr aus `data.o6_1a.o6_1a_drought_2026_parameters.year`).
- Der Hinweis vom 12.06.2026 (Rebzikade) betrifft nur „Insektizidverzicht Wein, Obst und Hopfen“ (Maßnahme 12) und
  wurde in der Coverage als `not_rule` erfasst.

## Widersprüche und Mehrdeutigkeiten

1. **Grenze 10 ha Acker bei der Grünland-Ersatzerfüllung (6.1.1):** Informationsblatt „unter 10,00 ha“, SRL
   „Betriebe bis 10 ha“. Umgesetzt nach SRL (`<= 10`). Differenz nur bei genau 10,00 ha.
2. **Ersatzerfüllung über Grünland:** Umgesetzt nach dem Beispiel 9 ha / 5 ha: gesamt ≥ 7 % von (Acker + gemähtes
   Grünland) *und* Grünland-DIV ≥ Grünland-Mindestanlage (nur, wenn diese greift). Der Querverweis „Kapitel 0“ im
   Informationsblatt ist defekt; angenommen ist Kapitel 6.2.
3. **Aufbewahrung der Pheromonfallen:** SRL „bis zum Ende der Vegetationsperiode“, Informationsblatt „zumindest bis
   30. September“. Rego prüft das Eingabefeld `traps_kept_until_sept_30`; Coverage-Eintrag `unresolved`.
4. **Grünlandumwandlung:** SRL nennt Acker, Dauer-/Spezialkulturen und geschützten Anbau; das Informationsblatt nennt
   zusätzlich Weinflächen. Die Eingabe `current_grassland_ha` bildet die Nettoumwandlung unabhängig von der Zielnutzung ab.
5. **AZR-Ausnahme 2023:** Die Bedingung „nicht zumindest 0,15 ha andere Kulturen“ ist über die Kennzeichnung aller
   Schläge des Feldstücks mit AZR abgebildet (wie in Kapitel 10 gefordert).
6. **Zweijährigkeit/Mindestpflege „jedes zweite Jahr“:** Umgesetzt über das Eingabefeld `used_previous_year`; die
   Eingabe beschreibt stets ein abgeschlossenes Kalenderjahr. Unterjährige Auswertungen können Mindestpflichten
   (Mahd, zweite Nutzung) fälschlich als verletzt melden.
7. **75 %/25 %-Regel mit Projektbestätigung:** Laut Beispiel (1,5 ha NAT ab 1.7.) verbrauchen früh genutzte
   Projektflächen das 25 %-Kontingent vorrangig; darüber hinausgehende Nutzung durch Projektflächen ist zulässig,
   UBB-eigene Flächen dürfen dann nicht mehr früh genutzt werden.
8. **2026 OPUBB/OPBIO:** Mit OPUBB/OPBIO codierte Acker-DIV zählen nicht zum 25 %-Kontingent, dürfen vor dem
   1. August beweidet und (ab Hinweis 12.08.) dreimal genutzt werden; sie erhalten keine UBB-Prämie (`common.no_premium`).
   Für Grünland: zusätzliche 14 Tage Vorverlegung (DIVSZ nur mit zweiter Mahd vergleichbarer Schläge) bzw. 49 Tage
   Ruhezeit (DIVNFZ). Die 14 Tage werden auf beide Termine (15.6./15.7.) angewandt.
9. **Variantenwechsel nach 15.04.:** Der Hinweis formuliert die Wechselfristen unabhängig von 2026 („unter bestimmten
   Voraussetzungen“); sie werden daher jahresunabhängig angewandt.
10. **Basismodulprämie Acker „bei Grünbrache bis max. 20 %“:** Interpretiert als: Grünbrache-DIV erhalten die
    Basisprämie bis 20 % der Ackerfläche; Grünbrachen ohne DIV sind nicht förderfähig (Allg. Bedingungen 5.5.1).
11. **Aus anderen Maßnahmen angerechnete DIV** (NAT, EBW, BAW, AG, N2) erhalten keine UBB-Prämie (auch keine
    Basisprämie). N2-Flächen ohne DIV-Code erhalten die UBB-Basisprämie (Anhang L: kombinierbar).
12. **Mehrnutzenhecken als DIV** zählen zur 7 %-Grenze, erhalten aber keine flächenbezogenen DIV-Zuschläge
    (nur den Mehrnutzenhecken-Zuschlag); Quelle regelt dies nicht ausdrücklich.
13. **LSE-Deckel 80 je ha Feldstück:** Bei Überschreitung werden Streuobstbäume (höherer Satz) vorrangig gezählt; die
    Reihenfolge ist in den Quellen nicht geregelt.
14. **Erosionsgefährdete Kulturen:** Namensabgleich mit der Quellliste (Plural), zusätzlich `crop_category == maize`
    und das Übersteuerungsfeld `crop.erosion_prone_crop`. „Rüben“ umfasst laut Annahme Zucker- und Futterrüben.
15. **Förderwürdige Kulturen und DIV:** Für die 15 %-Schwelle zählen alle anrechenbaren Acker-DIV über 7 % (laut
    Beispiel inkl. NAT-DIV); ausbezahlt wird nur für die Kulturen, nicht für DIV. Reihung nach Satzhöhe bis 40 %.
16. **Zuschlag „1 DIV je 3 ha“:** Gezählt werden alle anrechenbaren DIV-Schläge > 0,05 ha (auch aus anderen
    Maßnahmen); prämiert wird nur UBB-eigene DIV-Fläche bis 20 %.
17. **Modulation:** Bezug „gesamte Fläche des Betriebes“ = Summe aller Schläge in Österreich ohne Almen.
18. **Obergrenze je ha:** Da andere Maßnahmenprämien nicht im Profil vorliegen, wird die Summe aller
    flächenbezogenen Zahlungen als Eingabe `total_area_payments_eur_per_ha` erwartet.
19. **Sanktionen:** Die Stufenzuordnung (Schwere, Ausmaß, Dauer, Häufigkeit) ist nicht quantifiziert; Rego stellt
    nur die Tabelle der Kürzungssätze und die Ausschlussregel bereit.
20. **Nationalparks:** Neusiedlersee und Donau-Auen generell ohne Prämie; andere Nationalparks nur ohne Prämie, wenn
    relevante Bewirtschaftungsauflagen bestehen (Eingabe `national_park_relevant_restrictions`).
21. **Datums- und Flächenvergleiche:** Flächen mit Toleranz 1e-6 ha (Gleitkomma); DIVNFZ-Ruhezeit: nächste Tätigkeit
    frühestens am 64. Kalendertag nach `first_use_completed_date` (Beispiel 24.6. → 27.8.).

## Nicht als Rego abgebildete Aussagen

Reine Verfahrens-, Informations- oder Kontrollbestimmungen (z. B. Konditionalität, Kontrollverweigerung, Korrektur
unmöglicher Kombinationen, Betriebsstrukturwechsel, Freigabe Naturschutz-Nutzungstermine 2026) sind im Katalog mit
leerem `rego_symbols` enthalten, weil ihre Rechtsfolge nicht aus Profildaten entscheidbar ist.

## Profil

Das Canonical Farm Profile enthält keine ÖPUL-spezifischen Daten (Maßnahmencodes, MFA-Codes, Feldstücke,
Nutzungsereignisse, Biodiversitätsflächen, LSE, Monitoring). Alle benötigten Felder sind in
`rules/profile_changes.json` als Ergänzungen vorgeschlagen; `constraints.biodiversity_area.type` wird zur Umstellung
auf die UBB-Codes vorgeschlagen.
