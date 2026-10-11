# o6_17 – Annahmen und offene fachliche Fragen

Run: `v2-o6_17-opus-5.5-high-20261011` · Modus `discover` · Maßnahme o6_17
„Humuserhalt und Bodenschutz auf umbruchsfähigem Grünland“ (SRL 2.17, Intervention 70-15).

## Quellen und Belege

- Alle 418 `evidence_text`-Ausschnitte sind wörtlich (whitespace-normalisiert) auf der
  angegebenen Seite des seitenmarkierten Textes (`sources/*.txt`) bzw. im HTML der
  2026-Hinweise vorhanden. 402 davon werden zusätzlich von `pdftotext` auf derselben
  PDF-Seite gefunden. Die übrigen 16 Ausschnitte sind Tabellenzeilen
  (z. B. „30,0 €/ha 32,4 €/ha“, „Schläge mit durchschn. Grünlandzahl < 20 32,4“,
  Anhang A/L), die `pdftotext` spaltenweise statt zeilenweise ausgibt; maßgeblich
  ist der bereitgestellte seitenmarkierte Text.
- Anhang L (Kombinationstabelle) wurde mit `pdftotext -layout` über Spaltenpositionen
  gelesen. Zeile 17 ist auf der Einzelfläche kombinierbar mit 1A, 1B, 2, 3 und 9; die
  Gegenrichtung (Spalte 17 in diesen Zeilen) ist konsistent (Test
  `test_combination_table_symmetric_for_17`). Die übrigen Zeilen wurden vollständig
  übernommen, aber nur für Zeile 17 fachlich gegengeprüft.
- Rechtsgrundlagen wurden gezielt geprüft (`targeted_sections`, Begründung in
  `rules/coverage.json`). Andere Maßnahmenabschnitte der SRL und die Anhänge B–G, I–K
  wurden per Volltextsuche nach „Humuserhalt“, „umbruchsfähig“, „artenreich“ und
  „Kennart“ geprüft; außer 2.1.4-4d/2.1.9-5d (Neueinsaat-Ausnahme) und der
  UBB-Weiterbildung gab es keine weiteren Treffer.

## Abweichungen Merkblatt ↔ Sonderrichtlinie

1. **Grenze der Grünlandzahl:** Das Merkblatt sagt „bis 20“ / „ab 20 bis unter 30“, die
   SRL „< 20“ / „>= 20 und < 30“. Umgesetzt nach SRL: Grünlandzahl 20 fällt in die
   zweite Stufe (54,0 €/ha ab 2024).
2. **Weiterbildungsthemen:** Laut Merkblatt „mögliche Themen“, laut SRL „müssen
   jedenfalls Inhalt dieser Kurse sein“. Umgesetzt als Pflicht zum fachspezifischen
   Grünlandkurs (Eingabe `grassland_topic`). Ob jedes der drei Themen behandelt werden
   muss oder eines genügt, bleibt offen.
3. **Wer die Weiterbildung absolviert:** Merkblatt „förderwerbende Person“, SRL
   „Betriebsführerin oder Betriebsführer“; beide erlauben eine maßgeblich tätige
   Person. Modelliert als Rolle `applicant` bzw. `significantly_involved_person`.
4. **Bodenproben:** Laut Merkblatt bis 31.12.2025 „an ein akkreditiertes Labor
   übermitteln“, laut SRL „ziehen und von einem akkreditierten Labor untersuchen“.
   Umgesetzt: Ziehung ab 01.01.2022, Übermittlung bis 31.12.2025, akkreditiertes Labor.
5. **Kennartenliste:** Ehrenpreis steht im Merkblatt unter Wegerichgewächse, in
   Anhang H unter Löwenmaulgewächse. Beide Familien sind gespeichert; für die Zählung
   ist die Familie irrelevant. Schreibvarianten (Karthäuser-/Kartäuser-Nelke,
   Zaunwicke/Zaun-Wicke, Ochsenauge, Rauer Löwenzahn, Herbst-Löwenzahn,
   Blasen-Leimkraut, Aufrechtes Fingerkraut) werden als `alternative_names` erkannt.
6. **Erhebungstermin:** Anhang H nennt „jedenfalls vor dem 30. Juni“ im Satz „Jedenfalls
   ist es sinnvoll …“ (Empfehlung). Nicht als harte Bedingung umgesetzt, nur als Datum
   in `data/o6_17/lists.json#/lists/agl`.

## Modellierungsannahmen

- **Bewertung von Fristen** (Weiterbildung, Bodenproben bis 31.12.2025): Ein Verstoß
  wird nur ausgewiesen, wenn `oepul.evaluation_date` nach der Frist liegt oder, ohne
  Stichtag, das Antragsjahr nach 2025 liegt. Geahndet wird im Jahr der Feststellung
  (§ 48 Abs. 2 GSP-AV).
- **Ausgangsbasis Bodenproben:** Bevorzugt die explizite Eingabe
  `oepul.o6_17.eligible_grassland_lt18_mfa2025_ha`. Fehlt sie, wird sie nur im
  Antragsjahr 2025 aus den Schlägen berechnet: Grünland < 18 % ohne GLÖZ 2/4/9,
  unabhängig von Schlagnutzung und anderen Maßnahmen. Ob auch „Sonstige
  Grünlandflächen“ mitzählen („förderfähige“ vs. „unabhängig von der Schlagnutzung“),
  ist offen; derzeit zählen sie mit.
- **Mindestgrünland und Grünlandanteil (1. Jahr):** Grünland ist die Summe aller
  Schläge mit `land_use = grassland`. Für den 40-%-Anteil wird die LN als
  `land.total_area_ha - land.alpine_pasture_area_ha` angenommen (`total_area_ha`
  enthält die Almweideflächen).
- **Futterfläche (Tierhaltereigenschaft):** Grünland plus Ackerfutterflächen laut
  geschlossener Liste, ohne Almweideflächen. RGVE nur für die im Merkblatt genannten
  Tierarten; Schweine haben nur GVE und zählen nicht. `animal_count` ist als
  Durchschnitts- bzw. Stichtagsbestand gemäß AT 5.7 zu liefern.
- **Gemähtes Grünland (AGL-Deckel):** Einmähdige Wiese, Streuwiese und Mähwiese/-weide
  mit zwei bzw. drei und mehr Nutzungen; ohne Bergmähder, Dauerweide, Hutweide und
  Gemeinschaftsweide.
- **AGL-Deckel:** „max. 15 % bzw. 25 % des gemähten Grünlands, jedenfalls aber 2 ha“
  wird gelesen als `max(Anteil × gemähtes Grünland, 2,0 ha)`. Wird der Deckel
  überschritten, kürzt die Policy die Zuschläge aller AGL-Schläge proportional. Wie
  die AMA den Überhang tatsächlich auf Schläge unterschiedlicher Hangneigungsklassen
  (262 bzw. 162 €/ha) verteilt, ist in den Quellen nicht geregelt.
- **Flächenzugang ab 2026:** Prämienfähige Höchstfläche = Fläche 2025 +
  max(50 % × Fläche 2025; 5 ha) + Zugänge, die schon vorher mit o6_17 belegt waren.
  Angewendet nur auf die Grundprämie, nicht auf den einjährigen Zuschlag AGL.
- **Obergrenze 1.300 €/ha je Schlag** (2023: 1.200): wird nach der Modulation je
  Schlag angewendet, gemäß SRL 1.12.2 (Modulation vor Obergrenze). `other_area_payments_eur`
  muss die übrigen, bereits modulierten ÖPUL-Flächenzahlungen des Schlages
  enthalten (ohne Begrünung Zwischenfrucht/Immergrün, Erosionsschutz WOH bzw. ab 2025
  Nichtproduktive Ackerflächen).
- **Modulation:** Basis ist die Heimfläche (`total_area_ha - alpine_pasture_area_ha`),
  weil Alm und Behirtung getrennt betrachtet werden.
- **Geringfügige Abweichungen bis 300 m²:** Gelten je Eingriff und Einzelfläche für
  jede Art von Eingriff (die Beispielliste ist mit „z. B.“ und „etc.“ offen).
  Aufschüttungen über 300 m² sind nur mit Einsaat und vorab eingeholter Bewilligung
  zulässig.
- **Ausnahme Schädlingsbefall:** Die „Erforderlichkeit“ wird über das Flag
  `documented` abgebildet; eine fachliche Prüfung der Schadhöhe ist nicht möglich.
- **Ausnahme Neueinsaat (DIVRS):** Geprüft werden nur UBB/BIO-Teilnahme und
  Dokumentation. Die inhaltlichen UBB/BIO-Auflagen aus 2.1.4-4d bzw. 2.1.9-5d
  (Grünlandzahl ≥ 30, Hangneigung < 18 %, 30 Arten aus 7 Familien usw.) gehören zu
  o6_1a/o6_1b und werden hier nicht wiederholt.
- **OP-Codes:** Modelliert sind nur der allgemeine Code `OP` und `VF`. Einen
  maßnahmenbezogenen OP-Code für o6_17 nennen die Quellen nicht; bei Bedarf in
  `data/o6_17/lists.json#/lists/non_eligible_parcel_codes` ergänzen.
- **Nationalparks:** Ob auf einer Nationalparkfläche relevante Bewirtschaftungsauflagen
  bestehen, liefert die Eingabe (`national_park_relevant_restrictions`). Neusiedlersee
  und Donau-Auen sind immer ausgeschlossen.
- **Sanktionen:** Die Basisstufe je Verstoß legt die AMA nach einem nicht
  veröffentlichten Schema fest und ist deshalb Eingabe (`findings[].base_stage`).
  Abgebildet sind Kumulation (Summe, max. 100 %), Eskalation um eine Stufe je früherem
  gleichartigem Verstoß, 1 % statt Verwarnung ab 2027 und Ausschluss bei zweiter
  100-%-Kürzung. Höhere Sanktionen bei Vor-Ort-Kontrollen sind nicht quantifiziert.
- **Übererklärung (§ 46):** Wird separat berechnet
  (`overdeclaration_payment_basis_ha`) und nicht automatisch in `premium_total_eur`
  eingerechnet. Ebenso die Untererklärung (§ 47, nur Datentabelle).
- **Höhere Gewalt:** „Binnen drei Wochen“ ist als 21 Kalendertage umgesetzt.
- **Rückzahlungsfreie Ausstiegsgründe:** `loss_of_control`, `force_majeure`,
  `permanent_circumstances` und `revision_clause`. Die Rebzikade-Ausstiegsregel 2026
  gilt nur für Insektizidverzicht (o6_12) und ist nicht auf o6_17 übertragen.
- **Hangneigung, Grünlandzahl, GLÖZ-Einstufung:** Werte aus dem INVEKOS-GIS werden als
  Eingabe übernommen und nicht berechnet.

## 2026-Hinweise

- Keiner der vier Hinweise enthält eine ausdrückliche Sonderregel für o6_17. Erfasst
  sind das allgemeine Verfahren zur höheren Gewalt (eAMA „Eingaben“) und die
  Berücksichtigung der Trockenheit bei Vor-Ort-Kontrollen.
- **Annahme:** Wenn UBB/BIO-Biodiversitätsflächen 2026 mit OPUBB/OPBIO codiert werden,
  entfällt nur die UBB/BIO-Prämie auf diesen Flächen. Die betriebliche
  UBB/BIO-Teilnahme und damit die o6_17-Kombinationsverpflichtung bleiben bestehen.
  Fachlich zu bestätigen.

## Belege nur für Regeln

- Jeder Beleg in `rules/citations.json` wird von mindestens einer Regel genutzt.
  Passagen ohne Regelwirkung (Zielsetzungen, Kostenbegründung, Getreide-/Gemüse-/
  Obstdefinitionen, Änderungsverzeichnisse) sind in `rules/coverage.json` als
  `not_rule` mit Begründung erfasst, aber ohne eigenen Beleg.

## Profiländerungen

- `crop.crop_category` kennt keine Ackerfutter- oder Grünland-Schlagnutzungsarten.
  Statt dieses Enum zu ändern, wird `land.parcels[].field_use_type` (MFA-Schlagnutzung)
  vorgeschlagen.
- Die maßnahmenspezifischen Angaben werden als einzelne, nicht überlappende Pfade
  `oepul.o6_17.<feld>` vorgeschlagen (kein Sammelobjekt `oepul.o6_17`).
- `oepul.o6_17.takeover` ist optional; ohne Übernahme fehlt das Objekt bzw. ist es
  `null`.
