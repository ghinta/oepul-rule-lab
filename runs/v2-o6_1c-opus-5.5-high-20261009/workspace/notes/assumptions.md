# Annahmen und offene Fragen – o6_1c „Nichtproduktive Ackerflächen und Agroforststreifen“

Run: `v2-o6_1c-opus-5.5-high-20261009` (Modus `discover`)

## Quellenhierarchie

- Rechtlich verbindlich sind SRL ÖPUL 2023 (inkl. Anhänge), MOG 2021 und GSP-AV; das
  Merkblatt (Stand Oktober 2025) und die Allgemeinen Teilnahmebedingungen (Stand April 2026)
  sind laut eigenem Impressum „rechtlich unverbindlich“. Bei Abweichungen im Wortlaut wurde
  die inhaltlich übereinstimmende Aussage beider Ebenen zitiert (z. B. Umbruch „ab dem
  1. August“ im Merkblatt = „nach dem 31.07.“ in der SRL).
- Die SRL-Fassung stammt vom 11.10.2024 (GZ 2024-0.489.174). Spätere SRL-Änderungen sind
  nicht im Quellpaket; Merkblatt und Teilnahmebedingungen könnten bereits jüngere Stände
  widerspiegeln.

## Fachliche Mehrdeutigkeiten

1. **4-%-Grenze (O6_1C-NPA-014):** Bezugsbasis ist `land.arable_area_ha` (Ackerfläche inkl.
   Grünbrachen/NPA gemäß § 25 Abs. 2 GSP-AV). Ob die Ackerfläche vor oder nach Abzug von
   GLÖZ-4-Flächen bzw. nicht förderfähigen Flächen gemeint ist, ist nicht geregelt. Die
   Kappung erfolgt nach Abzug des GLÖZ-4-Anteils und ausgeschlossener Schläge.
2. **Kombinationsverbot NPA (O6_1C-NPA-015):** Merkblatt/SRL regeln, dass NPA „prämienmäßig“
   mit keiner anderen Maßnahme kombinierbar ist; Anhang L enthält für die gesamte Zeile/Spalte
   1C (auch Agroforststreifen) keine Kombination. Nicht geregelt ist, welche Maßnahme bei
   Doppelbeantragung die Prämie verliert. Das Rego meldet einen Verstoß, kürzt die NPA-Fläche
   aber nicht automatisch. Für Agroforststreifen wird kein Kombinationsverstoß ausgegeben, da
   Agroforststreifen als LSE ohnehin keine Hauptkultur tragen; die Matrix ist aber vollständig
   in den Daten verfügbar.
3. **50-%-Regel (O6_1C-NPA-010):** Wird auf einem Schlag vor dem 1. August regulär gemäht,
   zählt die gesamte Schlagfläche zum „frühen“ Anteil (keine Teilflächenbetrachtung).
   Die Grenze ist „nicht mehr als 50 %“ (genau 50 % zulässig).
4. **Pflege jedes zweite Jahr (O6_1C-NPA-007):** Ausgewertet wird erst nach Abschluss des
   Verpflichtungsjahres (`commitment_year_completed`) und nur, wenn auch im Vorjahr kein
   Schnitt erfolgte (`cut_in_previous_year == false`). Für Erstjahresflächen ohne Vorjahr ist
   `cut_in_previous_year` sinngemäß `true` zu setzen.
5. **Reinigungsschnitt (O6_1C-NPA-011/-012):** Selbstbegrünung wird wie eine Neuansaat
   behandelt (SRL: „Neuansaat (wobei eine Selbstbegrünung zulässig ist)“). Ein unzulässiger
   Reinigungsschnitt wird als Verstoß gemeldet **und** als regulärer Schnitt gezählt.
6. **PSM-/Düngeverbot (O6_1C-NPA-005):** Das Verbot läuft ab 1.1. des ersten Antragsjahres bis
   zum Umbruch. Die Eingaben (`operations.psm_used`, Düngermengen) werden als Angaben für den
   Verbotszeitraum des Antragsjahres interpretiert; eine Düngung nach dem Umbruch (z. B. zur
   Folgekultur) muss vom Eingabesystem ausgenommen werden.
7. **Pflegemaßnahmen Agroforststreifen (O6_1C-AFS-003):** Pflanzpfahl und Verbissschutz sind
   „nach der Pflanzung“ gefordert; für ältere, bereits etablierte Bäume ist unklar, ob diese
   weiterhin vorhanden sein müssen. Das Rego prüft die Angaben nur, wenn sie explizit `false`
   sind.
8. **Gehölzentnahme (O6_1C-AFS-002):** „Mindestkriterien“ werden als die Definitionsmerkmale
   (Breite, Dichte, Abstand, Negativliste usw.) verstanden.
9. **Negativliste:** Abgleich über wissenschaftliche Namen (case-insensitive); „Ölweiden
   (Elaeagnus)“ wird als ganze Gattung behandelt (Präfixvergleich).
10. **Gebietskörperschaften (O6_1C-ELIG-002):** Die Ausnahme gilt für die gesamte Maßnahme 1C
    ab 2025 (beide Kategorien).
11. **BIO-Teilbetrieb:** Die Ausnahme vom NPA-Ausschluss setzt voraus, dass der Betrieb
    ausschließlich als BIO-Teilbetrieb mit Kulturbereich Wein, Obst und Hopfen teilnimmt
    (`bio_participation_type == "partial_wine_fruit_hops"`).
12. **Prämienband (O6_1C-PREM-003):** Der tatsächliche Hektarsatz innerhalb des Bandes hängt
    von Budget und beantragter Gesamtfläche (österreichweit) ab und ist nicht berechenbar. Das
    Rego liefert Mindest-, Höchst- und garantierten (Mindest-)Betrag nach Modulation.
13. **Prämienobergrenze (O6_1C-PREM-005):** Die SRL 1.9.2.1 bezieht die Obergrenze auf
    Zahlungen gemäß Art. 70 und 72; o6_1c ist eine Öko-Regelung gemäß Art. 31. Die
    Teilnahmebedingungen nennen o6_1c ab 2025 ausdrücklich als nicht eingerechnet.
14. **Revisionsklausel (SRL 1.7.5):** Bezieht sich auf Art. 70 Abs. 7; für die Art.-31-Maßnahme
    o6_1c nicht als Regel modelliert.
15. **Maßnahmenspezifischer OP-Code:** Die Quellen nennen keinen eigenen OP-Code für o6_1c.
    Das Rego wertet den Code `OP` sowie das Flag `third_party_fault_noncompliance` aus.
16. **Nationalparks:** Für Nationalparks außer Neusiedlersee/Donau-Auen wird nur dann
    ausgeschlossen, wenn `relevant_management_restrictions == true` gemeldet wird.
17. **Übererklärung (O6_1C-SANC-004):** Die Funktion bildet § 46 Abs. 1 GSP-AV auf der
    Flächenebene ab; die Umrechnung auf Prämienebene (§ 46 Abs. 2) wird nicht modelliert.
18. **Sanktionsstufen:** Welche Stufe einem konkreten Verstoß zugeordnet wird, legt die AMA
    nach einem nicht veröffentlichten Schema fest; das Rego erwartet die Stufe als Eingabe.
19. **GLÖZ 8 Z 1:** Die GSP-AV-Fassung vom 28.01.2026 enthält weiterhin die 4-%-Stilllegung
    nach GLÖZ 8 Z 1, während die SRL die neue Öko-Regelung 1C mit den „geänderten
    Rechtsgrundlagen hinsichtlich GLÖZ 8“ begründet. Ob GLÖZ 8 Z 1 ab 2025 noch anzuwenden
    ist, wird hier nicht entschieden (nur als Konditionalitätshinweis O6_1C-GEN-010).

## 2026-Hinweise

- Die trockenheitsbedingten Ausnahmen 2026 (vorzeitige Nutzung, dritte Nutzung,
  Codierung OPUBB/OPBIO) betreffen ausdrücklich Acker-/Grünland-Biodiversitätsflächen der
  Maßnahmen UBB und BIO. Für NPA/Agroforststreifen wurde keine Erleichterung veröffentlicht;
  Schnittzeitpunkt (50 % ab 1. August) und Höchstzahl (2 Schnitte) bleiben daher unverändert.
  Dies ist eine Auslegung aus dem Schweigen der Hinweise.
- Die Dürre-Erleichterungen zur Ernteverpflichtung (Gebietskulissen) sind für o6_1c nicht
  relevant, weil NPA und Agroforststreifen von den Mindestbewirtschaftungskriterien
  ausgenommen sind (O6_1C-NPA-018). Erfasst wurde nur die allgemeine Möglichkeit, höhere
  Gewalt einzelbetrieblich geltend zu machen (O6_1C-FM-002).
- Der Rebzikaden-Hinweis betrifft ausschließlich o6_12.

## Profilerweiterungen

Die vorgeschlagenen Profilpfade (`rules/profile_changes.json`) sind notwendig, weil das
Canonical Farm Profile keine Maßnahmenteilnahme, keine Feldstücksliste-Codes und keine
NPA-/Agroforststreifen-Merkmale abbildet. Bestehende Felder (`land.parcels[].operations.psm_used`,
`...fertilizer.*`, `land.arable_area_ha`, `land.total_area_ha`, `farm.year`) werden
weiterverwendet. Datumsangaben werden als ISO-Strings `JJJJ-MM-TT` erwartet.

## Ergänzungen nach der Finalisierungsprüfung

- **Anhang L Fußnoten (O6_1C-COMB-001):** Fußnoten 1) und 3) sind zellbezogen und werden über
  `combination_assessment` ausgewertet. Fußnoten 2) (Spalte/Zeile 13) und 4) (Kopfzeilen 8 und
  16) stehen in der Tabelle an den Maßnahmenbezeichnungen und sind in den Daten als
  `header_footnote` der jeweiligen Maßnahme erfasst; ihre Detailregeln betreffen nicht o6_1c.
- **Anhänge A–K:** Nur per Volltextsuche (ohne Treffer zu o6_1c) durchsucht, nicht inhaltlich
  geprüft; daher kein Coverage-Eintrag außerhalb von S. 103.
- **Zeilenzahl von Parameterobjekten:** Für Objekte unter `/parameters/*` zählt jeder Wert eine
  Zeile; Listenwerte zählen elementweise.
- **Belegtexte:** Auszüge wurden so gewählt, dass sie sowohl im seitenmarkierten Text als auch in
  der PDF-Textextraktion (Leerraum normalisiert) vorkommen und nicht an einer Silbentrennung enden.
