# o6_1c: unveränderte Modellnotizen

Sämtliche Modellannahmen sind unbestätigt. Auch nicht einzeln priorisierte Auslegungen müssen vor Übernahme geprüft werden.

## luna: `v2-o6_1c-luna-high-20260930`

# Fachliche Annahmen und offene Punkte

- Das Canonical Farm Profile enthält keine o6_1c-Antrags- und Schlagkategorie-Felder. Die benötigten Ergänzungen sind deshalb im `discover`-Modus ausschließlich in `rules/profile_changes.json` vorgeschlagen; das Canonical Farm Profile wurde nicht verändert.
- Die Kombinationstabelle in Anhang L enthält für die 1C-Zeile keine `x`- oder `a`-Einträge. Die explizite Aussage des Maßnahmenblatts zur Ausnahme „Biologische Wirtschaftsweise – Teilbetrieb“ wird vorrangig als maßnahmenspezifische Ausnahme erhalten.
- Die 4-%-Grenze wird als Summe der beantragten NPA-Flächen geteilt durch die betriebliche Ackerfläche modelliert. Ob die AMA bei Sonderfällen eine abweichende Flächenabgrenzung verwendet, ist aus den bereitgestellten Unterlagen nicht weiter auflösbar.
- Für das Prämienband ist nur der veröffentlichte Mindest- und Höchstwert belegt. Die konkrete jährliche Auswahl innerhalb des Bandes hängt laut Quelle von beantragten Flächen und verfügbaren Mitteln ab und wird nicht künstlich berechnet.
- Die Hinweise vom 22.05.2026 und 12.08.2026 zu vorzeitiger Nutzung bzw. dritter Nutzung beziehen sich ausdrücklich auf Biodiversitätsflächen in UBB/BIO bzw. Naturschutz/EBW, nicht auf die Maßnahme o6_1c. Daraus sind die Scope-Ausschlussregeln `o6_1c_043` und `o6_1c_046` abgeleitet; die Ausnahmen werden nicht auf NPA-Flächen übertragen. Beleg: `src_notice_biodiv_2026`, `src_notice_drought_0812_2026`.
- Der Hinweis vom 05.08.2026 zur 85-%-Erntepflicht betrifft produktive Ackerkulturen und die allgemeine Mindestbewirtschaftung; die Maßnahme o6_1c enthält für NPA ausdrücklich abweichende Verpflichtungen. Daraus ist `o6_1c_045` als Scope-Ausschluss abgeleitet. Beleg: `src_notice_drought_0805_2026`.
- Der Hinweis vom 12.06.2026 betrifft ausschließlich den Insektizidverzicht Wein, Obst und Hopfen und ist für o6_1c nicht regelbildend. Daraus ist `o6_1c_044` als Scope-Ausschluss abgeleitet. Beleg: `src_notice_rebzikade_2026`.
- Die Auswertung der Rechtsgrundlagen ist gezielt auf die allgemeine Fördervoraussetzungen-/Antrags-/Kombinations-/Förderhöhenabschnitte, den vollständigen 1C-Abschnitt und Anhang L beschränkt; nicht maßnahmenbezogene Tier-, Wein-, Alm- und andere Maßnahmenteile wurden vollständig als nicht einschlägig abgegrenzt.
- Die Profiländerungen verwenden für zuvor überlappende Strukturen ausschließlich nicht überlappende Blattpfade. Arrayfelder werden als Blatt mit echtem JSON-Array vorgeschlagen; insbesondere wird `natural_ingress_species` nicht als Arraycontainer-Pfad adressiert. Die Regelprüfung berücksichtigt gepflanzte und natürlich angeflogene Gehölze.


## opus: `v2-o6_1c-opus-5.5-high-20260925`

# Annahmen und offene Fragen – ÖPUL 2023, Maßnahme 1C „Nichtproduktive Ackerflächen und Agroforststreifen"

Run: `v2-o6_1c-opus-5.5-high-20260925` · Modus: `discover`

## Quellenlage und Rangfolge

- Das Informationsblatt 1C (Stand Oktober 2025) und die Allgemeinen Teilnahmebedingungen (Stand April 2026)
  bezeichnen sich selbst als rechtlich unverbindlich; maßgeblich ist die Sonderrichtlinie ÖPUL 2023
  (Fassung 2024-0.489.174) samt Anhängen. Wo Informationsblatt und SRL abweichend formulieren, wurden beide
  Belege an derselben Regel hinterlegt:
  - Umbruch nach Winterung/Zwischenfrucht: Informationsblatt „ab dem 1. August", SRL „nach dem 31.07." –
    inhaltlich gleich; umgesetzt als frühester Umbruchtag 1. August.
  - PSM-/Düngeverbot: Informationsblatt „ab 1. Jänner des ersten Antragsjahres", SRL „ab 01.01. des Jahres
    der ersten Angabe des Schlages als NPA im Mehrfachantrag". Als gleichbedeutend behandelt.
  - Agroforststreifen-Nutzungsverbot: SRL „eine Nutzung ist nicht zulässig", Informationsblatt präzisiert
    „Mahd oder Weide" unzulässig, Pflegemahd ohne Abtransport/Häckseln erlaubt. Umgesetzt nach dem
    Informationsblatt.
- SRL 1.9.4 enthält einen offensichtlichen Redaktionsfehler („Umweltgerechte und biodiversitätsfördernde
  Bewirtschaftung“ (1B)); gemeint ist UBB (1A). Umgesetzt als 1A, bestätigt durch Informationsblatt Kap. 6.
- Die GAP-Strategieplan-Anwendungsverordnung (GSP-AV) liegt nicht als Quelle vor. Offen (Coverage
  `unresolved`) sind daher: Spezialkulturen nach § 25 Abs. 4 (Eingabe-Flag
  `is_special_crop_gspav_25_4`), § 31 (nicht hauptsächlich landwirtschaftlich genutzte Flächen),
  § 6 (höhere Gewalt – Tatbestände/Fristen) und §§ 42–47 (Flächenabweichungssanktionen).

## Fachliche Annahmen in der Umsetzung

1. **4 %-Obergrenze:** Bezugsbasis ist `land.arable_area_ha` des Betriebes einschließlich der NPA selbst
   (Grünbrache zählt zum Ackerland). Die Obergrenze wirkt auf die Prämienfläche; über 4 % hinausgehende
   NPA-Fläche wird nicht prämiert, aber nicht als Verstoß gewertet (die Quellen nennen keinen Verstoß).
2. **GLÖZ 4:** Der als GLÖZ-4-Pufferstreifen ausgewiesene Flächenteil wird von der NPA-Fläche abgezogen,
   bevor die 4 %-Grenze angewandt wird.
3. **50 %-Regel (Schnitt vor dem 1. August):** betriebsbezogen über alle NPA-Schläge; ein Schlag gilt als
   „früh gemäht", sobald ein zählender Schnitt vor dem 1. August liegt (Teilflächenschnitte werden nicht
   abgebildet). Zulässige Reinigungsschnitte zählen nicht.
4. **Reinigungsschnitt:** Nur im ersten Antragsjahr (`first_npa_declaration_year == farm.year`) und nur bei
   `establishment_type == "new_sowing"` oder nach Umbruch und Neueinsaat einer bestehenden Grünbrache.
   Selbstbegrünung wird **nicht** als Neuansaat gewertet (Informationsblatt: „bezieht sich auf Flächen mit
   Neuansaat"). Ein unzulässiger Reinigungsschnitt wird als Verstoß gemeldet und zählt zusätzlich als
   regulärer Schnitt.
5. **Mindestpflege „jedes zweite Jahr":** Verstoß, wenn im laufenden Jahr kein Schnitt (inkl.
   Reinigungsschnitt) erfolgte und `maintenance_in_previous_year == false`; im ersten NPA-Jahr nicht prüfbar.
   Ob ein Reinigungsschnitt die Mindestpflege erfüllt, regeln die Quellen nicht ausdrücklich (hier: ja).
   Die Prüfung setzt einen Jahresabschluss-Datenstand voraus.
6. **Düngung:** „Jegliche Düngung" – neben N-Mengen aus `operations.fertilizer` wird das neue Flag
   `npa.any_fertilization` (auch P/K/Kalk, Wirtschaftsdünger) ausgewertet.
7. **Beseitigung:** Die Geräteliste (Pflug, Grubber, …) ist mit „wie" eingeleitet und daher beispielhaft;
   geprüft wird die Methode (Häckseln/Einarbeiten vs. chemisch/sonstig).
8. **Agroforststreifen-Definition:** Dichte = Bäume × 100 / Länge (Laufmeter); Sträucher zählen nicht als
   Bäume. Negativliste wird auf Art- und – für „Ölweiden (Elaeagnus)" – auf Gattungsebene geprüft.
   Die Pflegepflichten (Pflanzpfahl, Verbissschutz, Pflegeschnitte) werden als Booleans erwartet; bei
   älteren, etablierten Bäumen kann ein Pflanzpfahl fachlich entbehrlich sein – das ist nicht abgebildet.
9. **Gehölzentnahme:** Die Streifen-Kennzahlen beschreiben den Zustand nach allfälliger Nachpflanzung.
   Verstoß, wenn nachgepflanzt wurde, aber nach dem 15. Mai, oder wenn ohne Nachpflanzung die
   Mindestkriterien nicht mehr erfüllt sind.
10. **Kombinierbarkeit Agroforststreifen:** Das Informationsblatt nennt das Kombinationsverbot nur für NPA;
    Anhang L weist für die gesamte Maßnahme 1C (Zeile und Spalte) keine kombinierbare Maßnahme aus.
    Umgesetzt: auch Agroforststreifen-Flächen erhalten keine weitere Maßnahmenprämie. Die
    Anrechnung von Agroforststreifen auf die 15 a der UBB/BIO-Feldstücksregel ist davon unberührt.
11. **Förderwerbende:** SRL 1.4 hebt den Ausschluss von Gebietskörperschaften und Einrichtungen mit
    bestimmendem Einfluss (> 25 %) für 1C ab 2025 auf; daher wird die 25 %-Grenze für 1C nicht geprüft.
12. **Betriebsmindestgröße:** `land.total_area_ha` wird als landwirtschaftliche Fläche ohne
    Landschaftselemente/Agroforststreifen interpretiert; Agroforststreifen und (neu)
    `land.landscape_elements_area_ha` werden addiert. Liegt `farm.oepul.first_participation_year` nicht vor,
    wird das Antragsjahr als erstes Teilnahmejahr angenommen (konservativ).
13. **Maßnahmenbezogener OP-Code für 1C:** Die Quellen nennen keinen konkreten Code (analog „OPUBB",
    „OPBIO"). Jeder Code mit Präfix „OP" erfüllt die OP-Kennzeichnungspflicht; prämienausschließend sind
    „OP" und „VF" sowie die Statusflags.
14. **Nationalparks:** Nur Neusiedlersee und Donau-Auen schließen 1C-Prämien aus; in anderen Nationalparks
    ist eine Prämie möglich (Kalkalpen nur für Almbewirtschaftung ausgeschlossen).
15. **Prämienberechnung:** Ausgegeben wird das Prämienband (garantierter Mindestsatz bis Höchstsatz) je
    Kategorie; der tatsächliche Satz hängt von Budget und Gesamtantragsfläche ab (SRL 1.9.3.2) und ist nicht
    berechenbar. Modulation erfolgt über `land.total_area_ha`. Sanktionen (Kürzungsstufen) werden von der AMA
    festgelegt; die Rego-Policy meldet Verstöße mit Regel-ID, bestimmt aber keine Kürzungsstufe.
16. **Obergrenze 1.300 €/ha:** Laut Allgemeinen Teilnahmebedingungen ab 2025 ohne Einrechnung von 1C;
    die SRL bezieht die Obergrenze auf Zahlungen nach Art. 70/72 – 1C ist Öko-Regelung nach Art. 31.
17. **Flächenabgang/-zugang, Toleranzen, Maßnahmenwechsel:** gelten für mehrjährige Maßnahmen; für 1C
    (einjährig) als „nicht beschränkt/nicht umwandelbar" abgebildet. Die Umwandlung mehrjähriger
    Maßnahmenflächen in LSE Agroforststreifen ist als zulässiger Abgang erfasst.
18. **Deregistrierung:** Eine Abmeldung mit Datum im Antragsjahr macht die Kategorie im Jahr ungültig;
    eine Abmeldung in einem Vorjahr erfordert einen neuen Maßnahmenantrag (Wiedereinstieg).
19. **Datumsvergleiche** erfolgen lexikografisch auf ISO-Datumsstrings (`YYYY-MM-DD`).

## 2026-Hinweise

- Die trockenheitsbedingten Erleichterungen für Acker-Biodiversitätsflächen (vorzeitige und dritte Nutzung
  mit OPUBB/OPBIO) gelten nach Wortlaut nur für UBB/BIO. Es wurde **keine** analoge Lockerung für NPA
  angenommen (Regel O61C-N2026-001). Ob die AMA in der Praxis eine vergleichbare Codierung für NPA
  zulässt, ist offen; im Zweifel ist der Weg über höhere Gewalt (eAMA „Eingaben") zu gehen.
- Die Dürre-Gebietskulisse (Ernteverpflichtung) ist für NPA/Agroforststreifen ohne Wirkung, da diese
  Flächen von den Mindestbewirtschaftungskriterien (inkl. Ernte) ausgenommen sind; die Kulisse wurde
  dennoch vollständig als Daten erfasst.
- Der Hinweis zum Insektizidverzicht (Amerikanische Rebzikade) betrifft ausschließlich Maßnahme 12.

## Regeln ohne Rego-Umsetzung

Rein verfahrens- oder erlaubnisbezogene Aussagen ohne prüfbare Eingaben sind nur im Katalog erfasst:
O61C-DEF-AFS-009 (Sträucher zulässig), O61C-GEN-LEGAL-001, O61C-GEN-APPL-007, O61C-GEN-CTRL-002,
O61C-GEN-DEF-002, O61C-GEN-DUR-002, O61C-GEN-FM-004, O61C-GEN-REV-001.

## Profil-Erweiterungen (discover)

Die vorgeschlagenen Pfade in `rules/profile_changes.json` werden von der Policy bereits gelesen; fehlen sie,
greifen Defaults (`object.get`), sodass die Policy auch mit dem unveränderten Profil auswertbar bleibt.
Agroforststreifen sind als eigenes Array `land.agroforestry_strips` modelliert, da sie Landschaftselemente
und keine Parzellen im Sinne von `land.parcels` sind.
