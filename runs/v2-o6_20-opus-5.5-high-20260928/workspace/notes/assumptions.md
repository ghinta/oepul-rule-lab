# Annahmen und offene Fragen – o6_20 „Tierwohl – Weide“

Run: `v2-o6_20-opus-5.5-high-20260928` (Modus `discover`)

## Quellenlage

- Maßgeblich ist das Maßnahmeninformationsblatt Stand Oktober 2025 (aktuelle AMA-Ausgabe, keine Ausgabe 2026),
  die Allgemeinen Teilnahmebedingungen Stand April 2026 und die Sonderrichtlinie ÖPUL 2023 idF 2024-0.489.174.
  Laut Informationsblatt und SRL 1.1 hat bei Widersprüchen die Rechtsgrundlage Vorrang (`o6_20.meta.legal_precedence`).
- Von den vier Hinweisen 2026 betrifft nur der Hinweis vom 22.05.2026 die Maßnahme (Grundfutterbedarf auf der Weide
  bei Vor-Ort-Kontrollen, Antrag auf höhere Gewalt). Die übrigen Hinweise (Insektizidverzicht, Ernteverpflichtung,
  Begrünung, Biodiversitätsflächen, Naturschutz, gefährdete Nutztierrassen) sind im Coverage-Ledger als `not_rule` geführt.
- Anhang L (Kombinationstabelle) enthält die tierbezogene Maßnahme 20 nicht; es wurde kein Kombinationsausschluss
  für Tierwohl – Weide gefunden. Einzige Querwirkung: SRL 2.21 reduziert den Satz von „Tierwohl – Stallhaltung Rinder“
  bei gleichzeitiger Teilnahme an „Tierwohl – Weide“; die SRL schreibt dort „(21)“ – als Schreibfehler für Maßnahme 20 gedeutet.

## Berechnungsannahmen

1. **Tageszählung**: Zugangstag zählt, Abgangstag nicht (Ende exklusiv). Abgeleitet aus den Beispielen des
   Informationsblatts (Zukauf 10. April → 205 Tage; 3. Mai → 182; Zählbeginn 16. Juni → 138; Verendung 14. Juli → 104).
   Die Rego-Tests prüfen alle vier Beispiele.
2. **Verspätete Zugangsmeldung Schafe/Ziegen**: Zählbeginn = Meldedatum − 7 Tage, wenn zwischen Zugang und Meldung mehr als
   7 Tage liegen (Beispiele 22.6. → 15.6.; 23.6. → 16.6.).
3. **Prämienband**: Der tatsächliche Satz hängt von Budget und beantragten RGVE ab (Öko-Regelung, EGFL). Die Policy
   liefert daher garantiertes Minimum (40 €/16 €) und Maximum (60 €/24 €), keinen Punktwert.
4. **Halbierung bei gekoppelter Stützung**: Das Informationsblatt halbiert die „Basisprämie“, die SRL „die Prämie für die
   betroffenen Tiere“. Umgesetzt: nur die Basisprämie der betroffenen RGVE wird halbiert, der 150-Tage-Zuschlag nicht.
   Offene Frage, ob der Zuschlag ebenfalls halbiert wird.
5. **Equiden und Neuweltkamele**: Beantragung über die Stückzahl. Prämien-RGVE = min(beantragte, tatsächlich die Mindestweidetage
   erfüllende Anzahl) × Faktor, ohne anteilige Tageszählung (die anteilige Berücksichtigung ist nur für Rinder und Schafe/Ziegen
   beschrieben). Ersatztiere (Hineinwachsen in die Altersschwelle) zählen zur tatsächlichen Anzahl.
6. **Mindestteilnahme je Kategorie**: Das Blatt sagt „120 oder 150 Tage“; umgesetzt: 150 Tage, wenn für die Kategorie der
   Zuschlag beantragt ist, sonst 120 Tage.
7. **Eingabe Weidetage**: `grazing_days_all_animals` ist eine vorab aggregierte Zahl der Tage, an denen alle teilnehmenden Tiere
   der Kategorie geweidet wurden – inklusive Alm-/Gemeinschaftsweidetagen, ohne Hinderungstage. Die Aggregation aus dem
   Weidetagebuch ist nicht Teil der Policy.
8. **Geburts-Stalltage**: Nur bei Schafen/Ziegen und nur, wenn keine Einzeltierdokumentation erfolgt, werden die Stalltage
   zu 120/150 addiert.
9. **Modulation**: Faktor aus der Gesamtfläche des Betriebes (`land.total_area_ha`), flächengewichtet über die Stufen;
   Beispiel 220 ha → 99,09 % ist getestet. Kürzung und Modulation werden multiplikativ angewendet (Reihenfolge damit
   ergebnisneutral).
10. **50-Euro-Schwelle**: SRL „kann abgesehen werden“ – nur als Kennzeichen `below_min_payout_threshold` ausgegeben.
11. **Sanktionsstufen**: Die Stufe legt die AMA fest (Eingabe `sanction_stage`); ab 2027 wird „Verwarnung“ zu 1 % Einbehalt.
    Eine automatische Ableitung der Stufe aus Schwere/Ausmaß/Dauer/Häufigkeit ist mangels Schema in den Quellen nicht möglich.
12. **Betriebsmindestgröße**: `land.total_area_ha` dient als Näherung für „landwirtschaftliche Fläche in Summe“ (inkl. GA,
    K20, LSE, Mehrnutzenhecken, Agroforststreifen).

## Auslegungsfragen

- **„Unmittelbar“** (Abmeldung von Rindern): nicht quantifiziert. Eine fehlende Meldung ist ein Verstoß; eine Meldung nach dem
  Tag des Bekanntwerdens erzeugt nur einen Prüfhinweis (`review_items`).
- **Grundfutterbedarf / wesentlicher Teil des Tages**: nicht quantifiziert (keine Mindeststundenzahl). Eingabe als Boolean.
- **Trockenheit 2026**: Der Hinweis sagt nur, dass die Situation bei Vor-Ort-Kontrollen „berücksichtigt“ wird. Für 2026 wird ein
  Grundfutter-Verstoß daher zu einem Prüfhinweis statt zu einem automatischen Verstoß; es gibt keinen pauschalen Verzicht.
- **Höhere Gewalt**: Eine anerkannte höhere Gewalt (`force_majeure_recognized`) unterdrückt nur Verstöße bei Weidetagen und beim
  150-Tage-Zuschlag, nicht bei Dokumentations- oder Meldepflichten. Die Voraussetzungen nach § 6 GSP-AV liegen außerhalb der Quellen.
- **Esel** fehlen in der Prämientabelle des Informationsblatts („Pferde, Ponys und Kreuzungen“), sind aber in SRL 2.20.6 und
  Kapitel 1/3.3/4 enthalten → Esel sind prämienfähig.
- **Stichtag Schafe/Ziegen**: Tiere ohne Zugangsdatum oder mit Zugang bis 1. April gelten als zum Stichtag vorhanden und müssen bis
  15. April (2023/2028: 17. April) beantragt sein.
- **Fehlende Eingaben**: Fehlt ein Boolean zu einer Verpflichtung, wird Einhaltung angenommen (keine Verstöße ohne Datengrundlage).
  Nur zentrale Felder (Rechtsform, erstes ÖPUL-Jahr, Weidetagebuch) erscheinen in `missing_inputs`. Fehlende Weidetage werden
  als 0 gewertet und führen zu einem Verstoß.
- **Tierhaltender Betrieb** (0,30 RGVE/ha) ist für diese Maßnahme nicht prämienrelevant und wurde nicht umgesetzt.
- **Letzter Einstieg**: Die Grenze Förderjahr 2027 gilt sowohl für den Einstieg in die Maßnahme als auch für neu hinzukommende
  Kategorien; der 150-Tage-Zuschlag bleibt bis einschließlich 2028 beantragbar.

## Profilvorschläge

Das Canonical Farm Profile enthält keine maßnahmenbezogenen Tier-, Melde- und Antragsdaten. Vorgeschlagen werden daher
`farm.applicant`, `farm.oepul_participation`, `land.protected_cultivation_area_ha`, der Teilbaum `oepul_measures.tierwohl_weide`
(inkl. `categories[]` und `animals[]`), `oepul_measures.tierwohl_stallhaltung_rinder` sowie eine Erweiterung des Enums
`livestock.species_groups[].species` um `new_world_camelids`.
