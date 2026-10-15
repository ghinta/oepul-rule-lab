# o6_22 Tierwohl – Schweinehaltung: Annahmen und offene Fragen

Run: `v2-o6_22-opus-5.5-high-20261004`, Modus `discover`.

Diese Datei hält fest, wo die Quellen mehrdeutig sind und wie die Rego-Regeln
(`policy/o6_22/*.rego`) und Daten (`data/o6_22/*.json`) sie auslegen. Die
Regel-IDs verweisen auf `rules/rules.json`.

## Eingabemodell

- Das Canonical Farm Profile enthält keine schweinespezifischen Felder. Alle
  benötigten Eingaben sind als Vorschläge in `rules/profile_changes.json`
  erfasst (17 Ergänzungen). Die Rego-Regeln lesen bereits diese vorgeschlagenen
  Pfade.
- Freilandhaltung wird über `housing.housing_type = "pasture"` abgebildet, die
  Kombination aus Stall und Freiland über `"mixed"` (O622-FREE-007).
- Die Tierlistenposition steht im neuen Feld `pig_tierliste_category`. Das
  freie Feld `category` bleibt unverändert.
- Ein- und Austritte werden je Antragscode in
  `farm.oepul_measures.o6_22.applications[]` geführt, mit `applied_on`,
  `first_year` und `withdrawn_on`.

## Fachliche Auslegungen

1. **Grenzen der Gewichtsklassen (O622-SPACE-002/003)**: Die Tabelle nennt
   „bis 20 / bis 32 / bis 50 / bis 85 / ab 85 kg“. Die Obergrenze gilt als
   inklusive: 85 kg fällt in „bis 85“, über 85 kg in „ab 85“. Das
   Belegungsplan-Beispiel („ab 50 kg bis 85 kg“ bzw. „ab 85 kg“) lässt die
   Zuordnung genau an der Grenze offen.
2. **Liegefläche Ferkel/Mast**: Die SRL nennt nur die Gesamtfläche und den
   Anteil von 40 %. Die Liegeflächen je Tier im Informationsblatt entsprechen
   genau 40 % der Gesamtfläche. Geprüft wird deshalb einmal gegen 40 % der
   geforderten Gesamtfläche (O622-SPACE-001/003).
3. **Sauenbuchten**: Die Tiere werden je Typ gezählt (`sow_counts`:
   Zuchtsau bzw. gedeckte Jungsau). Geprüft wird die Summe der Mindestflächen
   je Bucht.
4. **Schwelle für den Tiergesundheitsdienst (O622-TGD-001)**: „über 10,00 GVE an
   förderbaren Schweinen“ wird so ausgelegt: alle Schweine prämienfähiger
   Tierlistenkategorien am Betrieb, unabhängig davon, ob die Kategorie
   beantragt ist, und vor Abmeldungen. Genau 10,00 GVE lösen die Pflicht nicht
   aus.
5. **Basis für die Stückzahl (O622-ELIG-002)**: Liegt eine
   Durchschnittstierliste vor, gilt der Jahresdurchschnitt, sonst der Stichtag
   1. April. Fehlt der Durchschnittswert einer Gruppe, wird auf den Stichtag
   zurückgegriffen.
6. **Abmeldung im Förderjahr (O622-EXIT-002)**: Jede Abmeldung mit
   `withdrawn_on` bis einschließlich 31.12. des Förderjahres macht den
   Antragscode für dieses Jahr ungültig. Eine Abmeldung ab 1.1. des
   Folgejahres lässt das laufende Jahr gültig.
7. **Kategorie ohne Tiere (O622-CONTRACT-005)**: Eine aktive Kategorie mit 0
   prämienfähigen GVE gilt als erloschen und erhält keine Prämie. Die
   Prüfung, ob mindestens ein Tier vorhanden ist, erfolgt auf GVE-Basis.
8. **Zuschlag unkupiert (O622-UNK-001/004)**: Maßgeblich sind nur die
   teilnehmenden, nicht abgemeldeten Tiere im Tierwohlstall. Das wird über das
   Gruppenflag `participating_animals_all_undocked_full_year` abgebildet.
   Kupierte Tiere in einem konventionellen Stall sind laut Beispiel
   unschädlich.
9. **Eiweißfuttermittel (O622-GVO-003)**: „In der Regel > 20 %
   Rohprotein“ bei Einzelkomponenten wird über einen typischen Rohproteingehalt
   (`typical_crude_protein_percent_dm`) abgebildet. Raufutter ist immer
   ausgenommen. Die Herkunft wird als `origin_continent = europe` erfasst; das
   schließt europäische Länder außerhalb der EU ein.
10. **Festmistkompostierung (O622-FMK-003/006/007)**:
    - Geprüft wird der Abstand zwischen aufeinanderfolgenden Umsetzungen
      (mindestens 14 Tage). Ein Mindestabstand zwischen dem Aufsetzen der Miete
      und der ersten Umsetzung ist nicht geregelt und wird nicht geprüft.
    - Mischmieten nach Absatz 1 des Informationsblatts (S. 11) und die
      „wendefreie Kompostierung“ (S. 11, Absatz 2) werden zusammengefasst.
      Ohne Umsetzen ist eine Miete zulässig, wenn Pflanzenmaterial in
      nennenswertem Ausmaß beigemengt ist (Boolean, kein fester
      Prozentsatz, „z. B. 50:50“ ist nur ein Beispiel), ein
      Kompostierungsverfahren angewendet wird und es sich nicht um
      strohreichen Mist allein handelt.
    - Für einen Kompostwender wird vollständiges Umsetzen nicht gesondert
      verlangt. Für Miststreuer und gleichwertige Geräte ist es gefordert.
11. **NAPV (O622-FMK-009)**: Bei Kompostmieten auf unbefestigtem Grund werden
    nur § 6 Abs. 1 Z 3 iVm Abs. 7 Z 2, 4, 5 und 6 sowie die Abdeckung
    geprüft. Die übrigen Ziffern von Abs. 7 betreffen nur
    Zwischenlagerungen als Feldmiete.
12. **Beschäftigungsmaterial (O622-ENR-001)**: Nur Getreide- oder Maisstroh
    und Heu gelten als „mit Stroh oder Heu eingestreut“. Strohpellets,
    Heupellets und andere Einstreu verlangen zusätzlich ständig verfügbares
    Gras, Stroh oder Heu.
13. **Gruppenhaltung der Sauen (O622-GRP-006/007/009)**: Die THVO-Zeiträume
    werden über Tage nach dem Decken (10 bzw. 28) und Tage vor dem Abferkeln
    (5 bzw. 7) abgebildet. Die Übergangsregelung gilt nur, wenn der Stall vor
    2013 gebaut und nicht umgebaut wurde, der Gruppenplatz ohne Umbau nicht
    reicht und das Jahr höchstens 2033 ist. Für Betriebe mit weniger als 10
    Sauen gelten dieselben Zeiträume; eine eigene Prüfung gibt es nicht.
14. **Besatz in der Freilandhaltung (O622-FREE-001)**: Die GVE ergeben sich
    aus der erklärten Stückzahl der Gruppe. Teilen sich mehrere Gruppen ein
    Gehege, ist `enclosure_gve` anzugeben. Bei Koppelhaltung zählt die
    Gesamtfläche aller Koppeln.
15. **Modulation (O622-GEN-011)**: Sie wird auf die tierbezogene Prämie
    angewendet, und zwar nach der Gesamtfläche des Betriebs
    (`land.total_area_ha`), weil die Quellen „Prämienausmaß aller Maßnahmen“
    nennen. Der Faktor wird auf 4 Nachkommastellen gerundet, Beträge auf
    Cent.
16. **Übererklärung (O622-GEN-017)**: § 46 Abs. 4 GSP-AV wird auf
    Prämienbeträge angewendet: Liegt die beantragte Prämie um mehr als 3 %
    über der ermittelten Prämie, wird um das 1,5-fache der Differenz gekürzt,
    höchstens auf 0. Das Kriterium „mehr als 2 ha“ ist auf Tiere nicht
    übertragbar.
17. **Sanktionen (O622-GEN-008/009/010)**: Stufe 1 (Verwarnung) entspricht
    0 %, ab 2027 einem Einbehalt von 1 %. Eskalationen sind mit Stufe 7
    (100 %) gedeckelt. Die Einstufung eines Verstoßes nimmt die AMA vor; die
    Rego-Funktionen rechnen nur mit einer vorgegebenen Stufe.
18. **Mindestbetrag (O622-GEN-013)**: Die Grenze „50 € nicht überschreiten“
    wird als `<= 50` umgesetzt (nach Modulation). Ob die AMA tatsächlich
    absieht, steht in ihrem Ermessen; deshalb gibt es nur ein Flag.
19. **Korrekturfrist der Tierliste (O622-APP-004)**: „Vierwöchige
    Einspruchsfrist“ wird als 28 Kalendertage ab Erhalt der
    Auszahlungsmitteilung umgesetzt. Ohne Datum der Mitteilung wird die Frist
    nicht geprüft.
20. **Hinweis vom 2. September 2026 (O622-REP-006)**: Dass Nachweise Datum,
    Anzahl und Verkaufsgewicht enthalten „sollten“, wird als Warnung umgesetzt
    (`warnings`), nicht als Verstoß. Fehlen Nachweise ganz, ist das ein
    Verstoß.
21. **Dürre- und Sonderregelungen 2026**: Die Hinweise vom 22. Mai, 12. Juni,
    5. August und 12. August 2026 enthalten keine Erleichterung für o6_22. Die
    verkürzte Haltedauer bis 31. August gilt nur für o6_5. Übernommen wurde nur
    der allgemeine Weg über den Antrag auf höhere Gewalt (O622-GEN-014).
22. **Kombination mit anderen Maßnahmen (O622-GEN-007)**: Die Quellen nennen
    für o6_22 keinen Kombinationsausschluss. Anhang L regelt nur
    Kombinationen auf derselben Einzelfläche und enthält die Maßnahme 22 nicht.
23. **Förderwerbende Person (O622-GEN-002)**: Gebietskörperschaften
    (`territorial_authority`) sind bei o6_22 nicht förderwerbend. Für
    juristische Personen und Personenvereinigungen gilt eine öffentliche
    Beteiligung von höchstens 25 % (inklusive).
24. **Konditionalität (O622-GEN-005)** und Kontrollduldung (O622-GEN-019)
    sind im Katalog erfasst, aber nicht als Rego-Prüfung umgesetzt. Dafür
    fehlen eigene Prüfdaten.

## Regeln ohne Rego-Umsetzung

Die folgenden Regeln haben keine `rego_symbols`, weil sie Verfahren beschreiben
oder ohne Prüfdaten nicht entscheidbar sind:

- O622-TGD-003: Nachweis über die TGD-Teilnahme nach Aufforderung
- O622-DOC-004: Messmethode der Buchtenfläche
- O622-REP-005: VIS-Abgleich durch die AMA
- O622-REP-007: Beanstandung bei verspäteten Meldungen
- O622-EXIT-003, O622-EXIT-004: Ausstiegszeitpunkt und Wiedereinstieg
- O622-GEN-005, O622-GEN-007, O622-GEN-019 bis O622-GEN-023

## Quellenbelege

- `evidence_text` wurde für jede PDF-Referenz automatisch geprüft. Der Text
  ist auf der angegebenen Seite sowohl im seitenmarkierten `.txt` als auch in
  der `pdftotext`-Ausgabe des PDF enthalten (Leerraum normalisiert).
- Bei HTML-Hinweisen ist der Belegtext wörtlich im Roh-HTML enthalten. Die
  Seitenangabe ist `null`.
- Wo Tabellen im PDF spaltenweise extrahiert werden (SRL S. 89/90,
  Informationsblatt S. 15), verweist der Beleg auf Tabellenkopf bzw.
  Zeilenbeschriftung, nicht auf eine Werte-Zeile. Die Werte selbst stehen
  vollständig in `data/o6_22/*.json`.
- Zwei Paragraphen der GSP-AV (§ 46 Abs. 1 und 4) stehen auf PDF-Seite 30
  (Referenzen `REF-GSP-P30-*`).

## Offene Fragen für die fachliche Prüfung

- Wie werden innerhalb eines Förderjahres Stichtags- und Durchschnittsbestand
  kombiniert, wenn nur einzelne Kategorien schwanken? Umgesetzt ist ein
  betriebsweites Flag.
- Zählt der Zeitraum zwischen dem Aufsetzen der Miete und der ersten Umsetzung
  zum 14-Tage-Abstand?
- Wie wird die Schwelle von 10 GVE für den Tiergesundheitsdienst bei
  unterjährig schwankenden Beständen ermittelt (Stichtag oder Durchschnitt)?
  Umgesetzt ist die gleiche Basis wie für die Prämie.
