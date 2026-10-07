# o6_22: unveränderte Modellnotizen

Sämtliche Modellannahmen sind unbestätigt. Auch nicht einzeln priorisierte Auslegungen müssen vor Übernahme geprüft werden.

## luna: `v2-o6_22-luna-high-20261005`

# Annahmen und offene Punkte

- Der Run arbeitet im Modus `discover`. Das Canonical Farm Profile wurde nicht
  verändert; fehlende o6_22-Eingaben sind ausschließlich als Vorschläge in
  `rules/profile_changes.json` erfasst.
- Die Maßnahmenquelle liegt als Stand Oktober 2025 vor. Die Sonderrichtlinie
  und ihre Anhänge liegen als Fassung vom 11. Oktober 2024 vor. Wo beide
  Quellen dieselbe Verpflichtung beschreiben, wird die verbindliche
  Sonderrichtlinie für die Rechtsgrundlage und das Merkblatt für die
  ausführungserklärenden Details verwendet.
- Die in den Maßnahmeninformationen genannte gesetzliche Ausnahme für die
  Gruppenhaltung von Sauen wird nicht selbst aus der 1. THVO rekonstruiert,
  weil diese Rechtsquelle nicht im bereitgestellten Quellenumfang enthalten
  ist. Die Ausnahme ist als explizite Bedingung abgebildet und auf das
  Merkblatt zurückgeführt.
- Die vier 2026-Hinweise behandeln Biodiversitätsflächen, Insektizidverzicht
  Wein/Obst/Hopfen, Dürre-Ernte- und Begrünungsregeln sowie andere Maßnahmen.
  Sie enthalten keine Änderung für Tierwohl – Schweinehaltung. Deshalb sind
  die geprüften einschlägigen Abschnitte als `not_rule` in der Coverage-Ledger
  dokumentiert und nicht als o6_22-Regeln erfunden.
- Die Freiland-Regelung wird im Rego mit dem vorhandenen Behördenhöchstwert
  oder, wenn dieser fehlt, mit 4 GVE/ha geprüft. Die alternative Koppelung
  über die gesamte im Haltungszeitraum verfügbare Fläche bleibt fachlich
  offen und muss als Eingabemodell ergänzt werden, falls sie maschinell
  separat bewertet werden soll.
- Prämienwerte werden in `data/o6_22_tables.json` vollständig für die im
  Merkblatt genannten Kategorien und Zuschläge geführt. Eine spätere
  Betriebsgrößenmodulation ist eine allgemeine Berechnung über der
  maßnahmenbezogenen Prämie und wird deshalb als eigene Katalogregel geführt.
- Zwischen der geschlossenen Tierlisten-Aufzählung auf Seite 2 (dort werden
  „Ältere Sauen nicht gedeckt“ unter der Kategorie der Zuchtsauen genannt) und
  der Einordnung auf Seite 7 (ungedeckte Jungsauen sowie ausgemerzte
  Zuchttiere bis zur Deckung bzw. Ausmerzung unter „Jung- und Mastschweine“)
  besteht eine auslegungsbedürftige Spannung. Die Regel
  `o622.sows.category_transition` bildet die ausdrückliche Übergangsregel auf
  Seite 7 ab; die Datenliste bewahrt zugleich die auf Seite 2 vollständig
  abgedruckte Tierlistenliste. Eine behördliche Klärung der Bezeichnung
  „Ältere Sauen nicht gedeckt“ bleibt offen.


## opus: `v2-o6_22-opus-5.5-high-20260928`

# o6_22 Tierwohl – Schweinehaltung – Annahmen und offene Fragen

Run: `v2-o6_22-opus-5.5-high-20260928` (Modus `discover`)

## Eingabemodell

- Eine `livestock.species_groups[]`-Gruppe mit `species == "pigs"` entspricht einer homogenen
  Tiergruppe in **einem** Stallabteil bzw. Gehege. Die Platzprüfung erfolgt je Gruppe
  (O622-FAT-SPACE-03). `animal_count` ist der aktuelle Abteilbesatz (Platzbedarf,
  Besatzdichte); für GVE/Prämie wird bei `livestock.average_animal_list_submitted == true`
  der `average_animal_count` verwendet, sonst `animal_count` (Stichtag 1. April).
- Neue Felder sind als belegte Vorschläge in `rules/profile_changes.json` erfasst; das
  Canonical Farm Profile wurde nicht verändert. Fehlende Pflichtwerte (z. B. Stallfläche)
  werden als `missing_inputs` ausgegeben statt als erfüllt gewertet. Boolesche
  Verpflichtungsfelder lösen nur bei explizitem `false` einen Befund aus.

## Fachliche Auslegungen

1. **Gewichtsklassengrenzen der Mindestflächentabelle** („bis 20 kg … ab 85 kg“): „bis X“
   wird inklusiv gelesen (≤ 20, ≤ 32, ≤ 50), die Klasse „bis 85 kg“ exklusiv, da „ab 85 kg“
   85 kg einschließt; genau 85 kg fällt damit in die strengere Klasse (1,10 m²).
   Fehlt das Durchschnittsgewicht, wird konservativ die Obergrenze der Tierlistenkategorie
   verwendet (bei offenen Kategorien „ab 50/110 kg“ die Klasse ab 85 kg).
2. **Tierliste vs. Platztabelle**: Die Tierlistenklassen (50–80, 80–110 kg) decken sich nicht
   mit den Platzklassen (bis 85 / ab 85 kg); maßgeblich für die Fläche ist das tatsächliche
   Gruppengewicht.
3. **Liegefläche Ferkel/Mast**: Die SRL nennt nur Gesamtflächen plus 40-%-Regel, das
   Maßnahmenblatt zusätzlich Liegeflächen je Tier. Beide sind identisch (Liegefläche =
   0,4 × Gesamtfläche); ein Test prüft diese Konsistenz der Datentabelle.
4. **GVE-Faktor nicht gedeckte Jungsauen**: Anhang A nennt „Zucht- und Jungsauen ab 50 kg
   0,5“; Maßnahmenblatt Kap. 10 und SRL 2.22 (Jung- und Mastschweine inkl. ungedeckte
   Jungsauen) ergeben 0,30. Verwendet wird 0,30 (Maßnahmenblatt), da ungedeckte Jungsauen
   der Kategorie Jung- und Mastschweine zugeordnet sind.
5. **Mindestteilnahme 2,00 GVE** wird auf die prämienfähigen GVE aller aktiven Kategorien
   *nach* Abzug der Abmeldungen bezogen („mit mindestens 2,00 GVE teilnehmen“).
6. **TGD-Schwelle „über 10,00 GVE förderbare Schweine“**: gerechnet über alle am Betrieb
   gehaltenen Schweine prämienfähiger Tierlistenkategorien (ohne Zuchteber, ohne
   Wildschweine), unabhängig von Beantragung/Abmeldung; strikt größer als 10.
7. **Abmeldepflicht**: Gruppen mit Haltungsmängeln gelten als nicht konform; der Abgleich
   erfolgt über die Summe der Jahresdurchschnittsstückzahlen je Kategorie gegen die
   gemeldeten Abmeldungen (Beilage „Tierwohl – Weide/Stallhaltung“ ist kategoriebezogen).
   Die Prämie basiert gemäß Kap. 9 auf „Tierliste minus Abmeldungen“; nicht gemeldete
   Mängel werden als Verstoß ausgewiesen, aber nicht automatisch sanktioniert, da das
   Sanktionsausmaß (Schwere, Ausmaß, Dauer, Häufigkeit) behördlich festgelegt wird.
8. **Verstöße gegen Förderverpflichtungen** führen nicht automatisch zu Prämie 0; nur
   Zugangsvoraussetzungen (Mindest-GVE, Förderwerber, Mindestgröße im ersten Jahr,
   Kontrollverweigerung) setzen die Prämie auf 0. `sanction_reduction_percent` bildet die
   Kürzungsstufen nur als Funktion ab.
9. **Ausstieg**: Eine während eines Kalenderjahres gemeldete Abmeldung macht die
   Maßnahme/Kategorie/den Zuschlag für dieses Jahr und alle Folgejahre ungültig; ein
   Wiedereinstieg erfordert einen neuen Antrag mit späterem Einstiegsjahr.
10. **Erlöschen einer Kategorie** (kein prämienfähiges Tier) wird für das aktuelle Jahr
    ausgewiesen; die Historie früherer Jahre wird nicht modelliert.
11. **Sauen-Gruppenhaltung**: `pig_welfare.group_housing` beschreibt die Gruppenhaltung
    im gesetzlich verpflichtenden Zeitfenster. Das Zeitfenster selbst ist über
    `sow_group_housing_required` ausführbar; ob die Übergangsregel (bis 2033) greift,
    hängt von einer baulichen Einschätzung ab, die als Funktionsargument übergeben wird.
12. **Festmistkompostierung „nennenswertes Ausmaß (z. B. 50:50)“**: 50:50 ist nur ein
    Beispiel; als Verstoß gilt ein fehlender Pflanzenanteil, unter 50 % wird nur ein
    Hinweis (`advisories`) ausgegeben. „Zweimal im Abstand von mindestens 14 Tagen“ wird
    als mindestens zwei Umsetztermine mit mindestens einem Paar ≥ 14 Tage Abstand gelesen.
13. **Zuschlag Festmistkompostierung** gilt laut SRL „je GVE in der Maßnahme“; er wird je
    aktiver Kategorie auf deren prämienfähige GVE berechnet. Ob bei gleichzeitiger
    Teilnahme an o6_21 (ebenfalls Festmistzuschlag, gesamter Festmist) eine Doppelzahlung
    ausgeschlossen ist, regeln die Quellen nicht – offen.
14. **Modulation**: Bezugsbasis ist `land.total_area_ha` (gesamte Betriebsfläche laut
    Mehrfachantrag). Das Alm-Beispiel in den Allgemeinen Teilnahmebedingungen (S. 20) nennt
    98,66 %, rechnerisch ergibt (200 + 30 × 0,9) / 230 = 98,70 %; das 220-ha-Beispiel
    (99,09 %) ist konsistent und wird getestet.
15. **Bagatellgrenze 50 €** („kann abgesehen werden“) bezieht sich laut SRL auf den
    Auszahlungsbetrag insgesamt; hier nur als Kennzeichen auf Maßnahmenebene ausgegeben.
16. **Kombinationen**: SRL 1.9.4 und Anhang L enthalten Maßnahme 22 nicht; daraus wird
    abgeleitet, dass o6_22 mit allen anderen Maßnahmen kombinierbar ist (O622-GEN-COMB-01).
17. **Flächenobergrenzen** (AT 9.2, SRL 1.9.2.1) gelten nur für flächenbezogene Zahlungen
    und werden auf die GVE-Prämie nicht angewendet (O622-GEN-CAP-01).

## Offene Punkte (unresolved)

- **Tierabweichungen (SRL 1.12.1.2)**: verweist auf §§ 42–47 GSP-AV, die nicht im
  Quellenpaket liegen; Toleranzen/Kürzungsformeln für Abweichungen bei Tierzahlen sind
  daher nicht ausführbar abgebildet.
- **Meldeverpflichtungen tierbezogener Maßnahmen (Teaser vom 02.09.2026)**: Die
  2026-Hinweise enthalten in der Seitenleiste nur den Teaser „Der Abgang von beantragten
  Tieren aufgrund von Verkauf, Verendung oder Schlachtung muss fristgerecht der AMA
  gemeldet werden“. Die vollständige Meldung fehlt im Quellenpaket; Fristen und die
  Anwendbarkeit auf o6_22 (Durchschnittstierliste) sind offen. Keine Regel extrahiert.
- **2026-Dürre-/Trockenheitsregeln** betreffen UBB/BIO-Biodiversitätsflächen,
  Ernteverpflichtung auf Acker, Begrünungsmaßnahmen, Naturschutz/Natura 2000, o6_5 und
  o6_12 – keine Sonderregel für o6_22. Übernommen wurde nur der allgemeine Weg zur
  Meldung höherer Gewalt (O622-GEN-FM-2026).
- **Betriebe mit < 10 Sauen / THVO-Übergangsregel**: Die Beurteilung, ob die Anforderung
  „ohne bauliche Maßnahmen“ erfüllbar ist, bleibt eine Einzelfallfeststellung.
- Rein verfahrensbezogene Regeln (z. B. O622-APP-06 Kategorietausch, O622-APP-09
  Nachbeantragung mit schriftlichem Ersuchen, O622-VIS-02 VIS-Abgleich, O622-TGD-03
  Nachweis auf Aufforderung, Selbstanzeige, Revisionsklausel) sind im Katalog erfasst,
  aber mangels entscheidbarer Eingaben nicht als Rego-Prüfung implementiert.
