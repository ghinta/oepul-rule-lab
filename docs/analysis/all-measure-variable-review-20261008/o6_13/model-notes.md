# o6_13: unveränderte Modellnotizen

Sämtliche Modellannahmen sind unbestätigt. Auch nicht einzeln priorisierte Auslegungen müssen vor Übernahme geprüft werden.

## luna: `v2-o6_13-luna-high-20261004`

# Fachliche Annahmen und offene Fragen

- Die Quellen nennen keine abschließende Artenliste der zulässigen Organismen. Deshalb prüft Rego einen belegten Eintrag im AGES-Pflanzenschutzmittelregister und die dortige Aufwandsmenge als Eingabe, statt eine nicht belegte Artenliste zu erfinden.
- `organism_application` wird als schlagbezogenes repräsentatives Objekt modelliert. Für jeden beantragten Schlag muss mindestens ein vollständiger Eintrag vorliegen; die Quellen sagen nicht ausdrücklich, ob mehrere Anwendungen getrennt oder gesammelt aufgezeichnet werden müssen. Der Canonical-Profile-Vertrag erlaubt an dieser Stelle keinen Array-Container.
- Die allgemeine 85-%-Erntepflicht wird auf beantragte Flächen im geschützten Anbau angewendet. Die Dürre-Ausnahme 2026 wird nur bei den ausdrücklich genannten kumulativen Bedingungen zugelassen: Förderjahr 2026, kein erntbarer Bestand, üblicherweise Spätsommer-/Herbsternte und veröffentlichte Gebietskulisse.
- Die 2026-Mitteilungen nennen die Gebietskulisse für Ackerflächen. Ob eine geschützte Fläche mit Nutzungsart A trotz Gewächshaus-/Tunnelproduktion in jedem Einzelfall als Ackerfläche im Sinn der Mitteilung gilt, ist offen; die Regel wird deshalb als konditionale Ausnahme mit Eingabe `crop_is_late_summer_or_autumn` geführt.
- Für die alternative Betriebsmindestgröße von 1,50 ha wird die Summe der vorhandenen Acker-, Grünland-, Spezialkultur- und Almflächen verwendet; die Sonderrichtlinie verweist zusätzlich auf weitere anrechenbare Flächen. Die Rego-Berechnung ist daher als discover-fähige Näherung markiert, bis diese Flächenfelder im Profil vollständig modelliert sind.
- Der Prämiensatz von 2.160 Euro/ha wird als Maßnahmensatz und zugleich als maßnahmenspezifische Obergrenze ab 2024 geführt. Eine separate Berechnung weiterer kombinierter Flächenzahlungen ist wegen des ausdrücklichen Kombinationsverbots auf der Einzelfläche nicht vorgesehen.
- Die Quellen enthalten rechtlich unverbindliche Informationsblätter; die Sonderrichtlinie und ihre Anhänge wurden für die rechtlich und tabellarisch relevanten Querverweise parallel zitiert.


## opus: `v2-o6_13-opus-5.5-high-20260926`

# o6_13 – Einsatz von Nützlingen im geschützten Anbau: Annahmen und offene Fragen

Run: `v2-o6_13-opus-5.5-high-20260926` (Modus `discover`)

## Fachliche Mehrdeutigkeiten

1. **Flächendeckender Einsatz je Schlag vs. „zumindest ein Gewächshaus“.**
   Das Merkblatt (Kap. 1) gewährt die Prämie für Flächen, „auf denen flächendeckend
   Organismen eingesetzt werden“; SRL 2.13 und Merkblatt 4.1 verlangen den Einsatz
   „in zumindest einem Gewächshaus oder Folientunnel“. Umsetzung: Die Maßnahmenebene
   (Mindestteilnahme O6_13-ACC-02, Verpflichtung O6_13-OBL-01) prüft ≥ 1 Struktur; die
   Prämie je NUE-Schlag (O6_13-SCOPE-01) verlangt einen anrechenbaren, flächendeckenden
   Einsatz auf genau diesem Schlag. Ob ein NUE-Schlag ohne eigenen Einsatz prämienfähig
   ist, wenn ein anderes Gewächshaus des Betriebs die Bedingung erfüllt, bleibt offen.
2. **Flächendeckung** wird als boolesche Eingabe (`covers_entire_area`) modelliert; die
   Quellen definieren kein Mess-/Toleranzkriterium.
3. **Anrechenbarkeit** (Registereintrag, Aufwandsmenge, Ersatz eines PSM-Einsatzes) wird
   als Eingabe erwartet; ein Abgleich mit dem AGES-Pflanzenschutzmittelregister ist nicht
   Teil der Quellen und nicht implementiert.
4. **Maßnahmenbezogener OP-Code**: Die Quellen nennen nur Beispiele (OPBIO, OPUBB …),
   keinen Code für NUE. Modelliert über `op_measure_codes` mit Maßnahmenkennung `o6_13`.
5. **Dürre 2026 (Ernteverpflichtung)**: Die Hinweise vom 05.08./12.08.2026 beziehen sich
   auf Ackerflächen und Ackerkulturen mit Ernte im Spätsommer/Herbst. Flächen im
   geschützten Anbau (A) sind Ackerland; ob die Ausnahme auf Gewächshauskulturen
   praktisch anwendbar ist, ist fraglich. Die Regel O6_13-DRT-01 greift nur, wenn die
   Eingaben `no_harvestable_crop_due_to_drought` und
   `crop_usually_harvested_late_summer_or_autumn` gesetzt sind. Die Gebietskulisse wird
   auf Betriebsebene (`farm.region`) geprüft, nicht je Schlag.
6. **Betriebsmindestgröße 1,50 ha**: `land.total_area_ha` wird als Fläche nach § 25 GSP-AV
   interpretiert; GA-, K20-, Landschaftselement-, Hecken- und Agroforstflächen werden über
   `land.minimum_size_additional_area_ha` addiert (Profilvorschlag). Die 0,50-ha-Schwelle
   für geschützten Anbau nutzt `land.protected_cultivation_area_ha`, ersatzweise die Summe
   der Schläge in Gewächshaus/Folientunnel.
7. **Nationalparks**: Nur Neusiedler See, Donau-Auen und Kalkalpen sind namentlich
   geregelt. Für andere Nationalparks wird eine Prämie nur bei `national_park_relevant_restrictions
   == true` versagt (Kombination aus SRL 1.6.2.2 und Merkblatt 5.5.1).
8. **Kürzungsreihenfolge / Obergrenze**: Da Prämiensatz und Obergrenze für o6_13 identisch
   sind (2.000 bzw. 2.160 €/ha) und keine Kombination zulässig ist, wird die Obergrenze je
   Schlag über `capped_rate` vor der Modulation angewandt; das Ergebnis ist unabhängig von
   der exakten Position in der Reihenfolge.
9. **Kürzungsstufe** wird als Eingabe (`compliance.sanction_stage`) übernommen; die
   Zuordnung von Schwere/Ausmaß/Dauer/Häufigkeit zu einer Stufe ist in den Quellen nicht
   tabelliert. Flächenabweichungen (§§ 42–47 GSP-AV) werden nicht berechnet (O6_13-SANC-06).
10. **Vertragsverlängerung**: Die automatische Verlängerung setzt voraus, dass im Vorjahr
    NUE beantragt, keine Abmeldung/kein Ausschluss erfolgte und der MFA abgegeben wurde.
    Eine Abmeldung im laufenden Jahr macht die Maßnahme für dieses Jahr ungültig, sofern
    sie vor Ankündigung einer VOK bzw. Mitteilung einer Verwaltungskontrolle erfolgt.
11. **Übernahme (6.3)** ist bei einer einjährigen Maßnahme nur für das laufende Jahr
    relevant; o6_13 steht nicht auf der Liste „nur in Einzelfällen“.
12. **Kulturdefinitionen** (Getreide, Feldgemüse, Obst) wurden geprüft, aber nicht
    umgesetzt, da o6_13 keine Kulturart voraussetzt.

## Technische Hinweise

- Rego-Paket `oepul.o6_13`, Entscheidung unter `data.oepul.o6_13.decision`.
- Daten unter `data/o6_13/` (`data.o6_13.measure`, `.general`, `.anhang_l`, `.notices_2026`).
- Anhang L wurde per Layout-Extraktion (pypdf) spaltengenau erfasst (134 nicht leere
  Zellen); Zeile und Spalte 13 sind leer.
- Ein Versuch, ein Hilfsskript nach `/tmp` zu schreiben, wurde (Pfad außerhalb des
  Workspace) abgelehnt; Generierung erfolgte über Inline-Python.
