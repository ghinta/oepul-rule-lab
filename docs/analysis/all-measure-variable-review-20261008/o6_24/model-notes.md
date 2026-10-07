# o6_24: unveränderte Modellnotizen

Sämtliche Modellannahmen sind unbestätigt. Auch nicht einzeln priorisierte Auslegungen müssen vor Übernahme geprüft werden.

## luna: `v2-o6_24-luna-high-20261005`

# Annahmen und offene Punkte

- Die konkrete steirische Gebietskulisse, Düngeklasseneinstufung (Anlage 2B),
  Stickstoffobergrenzen und Ausbringungszeiträume (Anlage 3) werden von den
  Quellen als externe Verordnung bzw. GIS-Layer referenziert, sind aber nicht
  als eigener Text im Quellenpaket enthalten. Die Rego-Schnittstelle erwartet
  diese schlagbezogenen Werte als Profilergänzungen und trifft ohne sie keine
  erfundene fachliche Entscheidung.
- Die Kombinationstabelle in Anhang L ist als vollständiger Rohdatenbestand
  mit den 21 Spalten und 21 Zeilen abgelegt. Die für Maßnahme 24 ausgewertete
  erlaubte Liste folgt der Zeile „24 Wasserrahmenrichtlinie – Landwirtschaft“;
  Fußnoten bleiben als Daten erhalten.
- Die 2026-Dürreausnahmen gelten nur für das Antragsjahr 2026. Für WRRL sind
  sie nur insoweit entscheidungsrelevant, als die allgemeine 85-%-Erntepflicht
  auf Ackerflächen betroffen ist. Die zusätzlichen Biodiversitäts-, Immergrün-,
  Untersaat-, Naturschutz- und Tierrassenregelungen wurden geprüft, aber nicht
  als WRRL-Regeln modelliert.
- Der Canonical Farm Profile enthält keine Antrag-, Rücktritts-, WRRL-GIS-,
  Düngeklassen- oder Betriebsbuchfelder. Im Discover-Modus werden dafür nur
  belegte Profilvorschläge ausgegeben; das Profil selbst bleibt unverändert.


## opus: `v2-o6_24-opus-5.5-high-20260928`

# o6_24 Wasserrahmenrichtlinie – Landwirtschaft: Annahmen und offene Punkte

Run: `v2-o6_24-opus-5.5-high-20260928` (Modus `discover`)

## Quellenlage

- **Grundwasserschutzprogramm Graz bis Bad Radkersburg 2018 (LGBl. Nr. 24/2018 idF LGBl. Nr. 70/2020) fehlt im Quellpaket.**
  Die eigentlichen Förderverpflichtungen verweisen auf § 4, § 5, Anlage 2B (Düngeklasseneinstufung) und
  Anlage 3 Punkt 1–3 (N-Obergrenzen je Kultur/Klasse, Ausbringungszeiträume). Folgen:
  - Die Düngeobergrenzen werden je Schlag-Teilfläche als Eingabe erwartet
    (`land.parcels[].wrrl_o6_24.duengeklassen[].n_limit_kg_per_ha`). Vollständig belegt sind nur die
    zwei Beispielwerte des Informationsblattes (Winterweichweizen D = 144 kg, B = 108 kg) in
    `data/o6_24/duengeklassen.json`; sie dienen als Fallback, wenn keine Obergrenze geliefert wird.
  - Fehlt eine Obergrenze, gibt es keine Aussage zur Einhaltung, sondern einen Eintrag in `missing_inputs`.
  - Die Einhaltung der Ausbringungszeiträume (Anlage 3 Punkt 3) wird als boolesche Eingabe
    `n_application_periods_compliant` erwartet; die Sperrfristen selbst sind nicht abbildbar.
  - Inhalt und Form des Betriebsbuchs nach § 5 sind nicht abbildbar; geprüft wird nur, ob für jeden
    Schlag Aufzeichnungen vorliegen und das Betriebsbuch am Betrieb aufbewahrt wird.
- § 6 GSP-AV (höhere Gewalt), §§ 42–47 GSP-AV (Flächenabweichungen), § 16 GSP-AV (Aufbewahrung) und
  § 48 GSP-AV (Sanktionsbemessung) sind ebenfalls nicht im Paket. Abweichungssanktionen sind im Coverage-Ledger
  als `unresolved` markiert. Die Stufe der inhaltlichen Kürzung wird als Eingabe `participation.o6_24.sanction_step`
  erwartet, weil Schwere, Ausmaß, Dauer und Häufigkeit nicht aus den Quellen berechenbar sind.

## Fachliche Auslegungen

1. **Jahreswirksame N-Menge**: Liegt `annual_effective_n_kg_per_ha` vor, wird dieser Wert verwendet; sonst
   die Summe aus `mineral_n_kg_per_ha` und `organic_n_kg_per_ha`. Das ist eine Näherung, weil die
   Anrechnung der Jahreswirksamkeit organischer Dünger in der (fehlenden) Verordnung geregelt ist.
2. **Gewichtetes Mittel**: Es wird ungerundet gerechnet (Beispiel 144 × 0,70 + 108 × 0,30 = 133,2 kg).
   Das Informationsblatt nennt „133 kg“. Ob auf ganze kg abgerundet wird, ist offen; die Regel meldet
   133,2 kg (auf 2 Dezimalstellen gerundet).
3. **Mindestteilnahme 2,00 ha**: Gezählt wird jede Ackerfläche (`land_use = arable`) in der Gebietskulisse,
   auch Brachen und Flächen mit Bewilligung zu erhöhten N-Gaben, weil die Quelle von „bewirtschafteter
   Ackerfläche in der Gebietskulisse“ spricht und nicht von prämienfähiger Fläche. Eine strengere Auslegung
   (nur prämienfähige Fläche) ist möglich.
4. **Brachflächen**: Nur die Sonderrichtlinie (2.24.5) schließt Brachflächen aus und verlangt eine Codierung.
   Das Informationsblatt erwähnt Brachen nicht. Die Rego-Regeln folgen der Sonderrichtlinie
   (nicht förderfähig, OPWRRL-Codierung verlangt).
5. **Anwendungsbereich der Förderverpflichtungen**: Die N-Obergrenzen und Ausbringungszeiträume werden auf
   die für 24 beantragten Ackerflächen im Gebiet ohne Bewilligung und ohne Brache angewendet
   (`obligation_parcels`). Betriebsbuch-Aufzeichnungen werden für alle beantragten Ackerschläge im Gebiet verlangt.
6. **Verstöße gegen Förderverpflichtungen** führen nicht automatisch zum Prämienverlust; sie werden als
   `violations` ausgegeben. Die Kürzung ergibt sich erst über `sanction_step`. Ausnahmen sind Mindestbewirtschaftung,
   Codierpflichten, Leistungsüberschneidung und Kombinationskonflikte: Sie machen den Schlag nach
   SRL 1.6.2.1, AT 5.5.2 bzw. Anhang L nicht prämienfähig.
7. **Kombinationskonflikt auf der Einzelfläche**: Bei einer nicht kombinierbaren Maßnahme wird der Schlag in 24
   als nicht prämienfähig behandelt, bis korrigiert wird. Welche der beiden Maßnahmen tatsächlich entfällt,
   ist in den Quellen nicht festgelegt.
8. **Obergrenze für Flächenzahlungen**: Welche Zahlung bei Überschreitung gekürzt wird, regeln die Quellen nicht.
   Die Überschreitung wird anteilig im Verhältnis Prämiensatz 24 / Gesamtzahlung auf die WRRL-Prämie umgelegt.
   Die übrigen Art. 70/72-Flächenzahlungen des Schlages werden als Eingabe `other_area_payments_eur_per_ha`
   erwartet, und zwar ohne 6, 7, 10 (bis 2024) und 1C (ab 2025). Für 2024 nennen die Teilnahmebedingungen
   1.300 €/ha und die SRL (Fassung 1a) ebenfalls 1.300 €/ha; für 2023 gelten 1.200 €/ha laut AT.
9. **Berechnungsreihenfolge**: Brutto → inhaltliche Kürzung → Modulation → Obergrenze (Auszug aus SRL 1.12.2).
   Übererklärungen, Fristversäumnis und Untererklärungen (GSP-AV) sind nicht modelliert.
10. **Modulation**: Maßgeblich ist `land.total_area_ha` als gesamte Betriebsfläche (Heimfläche) laut Mehrfachantrag.
11. **Betriebsmindestgröße**: `land.total_area_ha` wird als Summe der landwirtschaftlichen Flächen inkl. der
    zusätzlich anrechenbaren Flächen (GA, K20, LE, Mehrnutzenhecken, Agroforststreifen) verstanden.
12. **Dürre 2026**: Die Ausnahme greift nur, wenn Bundesland/Bezirk (schlagbezogen, sonst Betriebssitz) gelistet sind,
    kein erntbarer Bestand wegen Dürre vorliegt und die Kultur üblicherweise im Spätsommer/Herbst geerntet wird.
    Die steirischen Bezirke Graz, Graz-Umgebung und Leibnitz decken große Teile der WRRL-Gebietskulisse ab.
    Die Kulturzuordnung (Spätsommer/Herbst) ist nicht listenmäßig definiert und wird als Eingabe erwartet.
13. **Besondere Umstände (SRL 1.7.4.2/1.7.4.3)**: Vereinfachend blockiert ein Umstand ohne höhere Gewalt mit
    Eintritt bis einschließlich 15.04. die Prämie des Jahres. Die abweichende Weitergewährung bei vorübergehenden
    Umständen, wenn alle Bedingungen auf geänderten Flächen eingehalten werden, ist nicht modelliert.
14. **Revisionsklausel (SRL 1.7.5)**: Sie bezieht sich auf Art. 70; Maßnahme 24 ist eine Art. 72-Zahlung.
    Die Anwendbarkeit bleibt offen (`unresolved`) und hat für einjährige Verträge keine praktische Folge.
15. **Abmeldung**: Eine Abmeldung mit Datum im Förderjahr macht das Jahr ungültig. Eine Abmeldung in einem
    früheren Jahr beendet den Vertrag, bis ein neuer Maßnahmenantrag gestellt wird (neues `contract_start_year`).
16. **Kontrollverweigerung**: Wirkt nur für das angegebene Jahr als Prämienausschluss; die Rückabwicklung früherer
    Jahre ist nicht modelliert.
17. **Maßnahmenübernahme**: Die 50 %-Grenze wird auf die übernommene Fläche bezogen (SRL: „mehr als 50 % der
    übernommenen Fläche“). Die AT-Formulierung „bisherige Maßnahmenfläche“ ist gleichsinnig ausgelegt.
18. **Fremdverschulden/Selbstanzeige, Ausstieg bis zur Kontrollankündigung, Finanzierung,
    Rechtsbestimmungen (1.15/1.17/1.19)** sind als Katalogregeln ohne Rego erfasst, weil sie
    Verfahrens- oder Vertragsbestimmungen ohne berechenbare Entscheidung sind.

## Profilvorschläge

Alle neuen Eingabefelder sind in `rules/profile_changes.json` beschrieben. Das vorhandene Feld
`farm.region.water_protection_zone` reicht nicht aus: Es ist betriebsbezogen und bildet weder die
konkrete WRRL-Gebietskulisse noch Düngeklassen ab. Es bleibt daher unverändert.

