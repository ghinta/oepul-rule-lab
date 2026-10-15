# Annahmen und offene fachliche Fragen – o6_9

Run: `v2-o6_9-opus-5.5-high-20261003` · Modus `discover`

Maßnahme: ÖPUL 2023 „Bodennahe Ausbringung flüssiger Wirtschaftsdünger und
Gülleseparation“ (SRL 2.9, GSP-AV Intervention 70-08).

## Eingabemodell

- Die Rego-Regeln lesen das Canonical Farm Profile plus die in
  `rules/profile_changes.json` vorgeschlagenen Felder, vor allem den Block
  `oepul_measures.o6_9`. Die vorhandenen Felder
  `livestock.species_groups[].manure.*` reichen nicht aus: Es fehlen Mengen je
  Verfahren, schlagbezogene Aufzeichnungen, Nachweise und die Separation.
- Datumswerte werden als `YYYY-MM-DD` erwartet.
- Fehlt `farm.applicant_type`, gilt `natural_person`.
- Fehlt `quantity_claim_date`, gilt die Mengenbeantragung als fristgerecht
  (Status unbekannt). Ist ein Datum angegeben und liegt es nach dem 30. November,
  ist die Menge nicht prämienfähig.
- Persönliche Voraussetzungen werden nur bei ausdrücklichem `false` als Verstoß
  gewertet. Das betrifft eigener Name, aktiver Landwirt, Lage in Österreich und
  ganzjährige Erfüllung.

## Fachliche Mehrdeutigkeiten

1. **Nicht gedeckte Jungsauen (O69-SRL-001):** Die SRL ordnet sie „ab 50 kg“
   der Mastgruppe zu (Durchschnitt max. 157 g). Das Informationsblatt
   (Juni 2026) nennt sie dagegen schon ab 32 kg in der Zeile 32–60 kg. Die
   Datentabelle ordnet sie über die Mastgruppen-Kategorien zu. Die Einstufung
   eines konkreten Tieres liegt beim Eingabeprofil.
2. **Durchschnittswert der Mastgruppe (O69-MB-027):** Laut SRL gilt der Wert
   von 157 g „ab 32 kg bis Mastende“. Er wird deshalb als Durchschnitt über die
   ganze Mast modelliert, obwohl die Tabelle des Informationsblatts ihn nur in
   der Zeile 32–60 kg zeigt. Für Ferkel (Ø max. 166 g) wird der angegebene
   Rationswert direkt als Durchschnittswert geprüft.
3. **Kürzung bei Überschreitung der 50 m³/ha-Grenze (O69-MB-042, Annahme A-03):**
   Die Quellen legen nicht fest, auf welches Verfahren die Kürzung entfällt. Die
   Rego-Regel kürzt daher proportional über alle Verfahren.
4. **Klee und Leguminosen (O69-MB-044):** Das Informationsblatt nennt Klee
   ausdrücklich als nicht düngungswürdigen Leguminosenreinbestand. Die NAPV
   (Anlage 3 Abschnitt VI) setzt für kleebetontes Ackerfutter aber eine
   Obergrenze von 40 kg N/ha. Für Soja, Erbse und Bohne sieht Fußnote 1 bei
   nicht beimpftem Saatgut 60 kg N/ha vor. Umgesetzt ist die Linie von
   Informationsblatt und SRL („Leguminosen-Reinbestände sind keine
   düngungswürdigen Flächen“). Der Punkt bleibt im Coverage-Ledger `unresolved`.
5. **`crop_category`:** `legume` wird als Leguminosenreinbestand behandelt,
   außer `crop.is_legume_pure_stand` ist ausdrücklich `false` (z. B. Kleegras).
   `fallow` wird als Stilllegung/Grünbrache mit 0 kg N-Bedarf behandelt. Als
   düngungswürdig gelten nur `land_use` `arable` und `grassland`.
6. **Rinder-GVE (O69-MB-043):** Vorrangig zählt der Wert aus der
   Rinderdatenbank (`cattle_gve_annual_average`). Fehlt er, wird mit den
   Rinderfaktoren aus Anhang A gerechnet. Diese stehen dort in der Spalte RGVE,
   die GVE-Spalte ist für Rinder leer.
7. **GVE Schweine (O69-MB-005/006):** Vorrang hat `pig_gve_annual_average`.
   Danach folgt der `gve`-Wert der Tiergruppe, dann `annual_average_count` bzw.
   `animal_count` × Faktor aus Anhang A. Bezugsgröße ist `land.arable_area_ha`,
   die gesamte Ackerfläche ohne Abzüge.
8. **Fläche für die 54 €/ha-Prämie (O69-MB-045):** Gezählt werden förderfähige
   Ackerschläge, also ohne OP/VF-Code, ohne Verstoß gegen die 85 %-Ernte (sofern
   nicht ausgenommen) und ohne nicht förderfähige oder Nationalparkflächen. Ohne
   Schlagliste wird `land.arable_area_ha` verwendet.
9. **Übererklärung (O69-GEN-030):** § 46 Abs. 2 und 4 GSP-AV wird auf
   Prämienbeträge angewendet. Das 2-ha-Kriterium aus Abs. 1 lässt sich nicht auf
   m³ übertragen, daher gilt nur das 3 %-Kriterium.
10. **Mindestbetrag 50 € (O69-GEN-024):** Das ist eine Kann-Bestimmung. Sie wird
    daher als Warnung ausgegeben und führt nicht automatisch zu einer
    Nullprämie.
11. **Kombinationstabelle Anhang L (O69-GEN-017):** Maßnahme 9 ist überwiegend
    mengenbezogen (€/m³). Die Einzelflächenprüfung greift daher nur für Schläge,
    die in `oepul_measures` den Code „9“ tragen. Praktisch betrifft das die
    €/ha-Komponente der Schweinefütterung. Die Fußnoten 1, 3 und 4 betreffen
    andere Maßnahmenpaare.
12. **NAPV-Abgleich (O69-NAPV-002/003):** Das ist nur ein Hinweis (`warnings`),
    keine Förderbedingung der Maßnahme 9, denn die NAPV ist ordnungsrechtliche
    Baseline bzw. Konditionalität.
    - Der Verbotsbeginn auf Acker ist pauschal ab 16. Oktober angesetzt, weil
      das Erntedatum der letzten Hauptfrucht nicht im Profil steht.
    - Die Ausnahmen bis 31. Oktober bzw. ab 1. Februar greifen nur über Flags.
    - § 3 NAPV (Einarbeitung binnen 4/12 Stunden, Hanglagen) ist nicht
      modelliert.
13. **Ausgangsprodukte Biogasgülle (O69-MB-009):** Die SRL-Liste (Stand 2024)
    enthält kein Maisquellwasser und keine Bedingung „keine Speiseölreste“. Das
    Informationsblatt vom Juni 2026 enthält beides und wurde verwendet. Die
    Quelle steht je Zeile in `manure_definitions.json`.
14. **Prämiensätze 2023 (O69-MB-041):** Sie stehen nur im Informationsblatt. Die
    SRL-Fassung 2024 weist nur die Sätze ab 2024 aus.
15. **Dürre 2026 (O69-NOT-001):** Die Ausnahme betrifft die
    Mindestbewirtschaftung (Ernte auf 85 %). Für Maßnahme 9 zählt das nur bei
    der €/ha-Prämie der Schweinefütterung. Der Bezirk wird aus
    `land.parcels[].federal_state/district` gelesen, sonst aus `farm.region`.
    Die Bezirksnamen müssen exakt der Schreibweise der AMA-Meldungen
    entsprechen.
16. **Abmeldung (O69-MB-040/038):** Jede Abmeldung mit Datum im laufenden
    Förderjahr macht die Maßnahme für dieses Jahr ungültig. Eine Abmeldung ab
    1. Jänner des Folgejahres ist ohne Verlust.
17. **Abgleich von Menge und Aufzeichnungen (O69-GEN-021):** Ist die beantragte
    Menge je Verfahren größer als die aufgezeichnete, wird das als Abweichung
    gewertet. Das ist eine Interpretation von 8.2 der Allgemeinen
    Teilnahmebedingungen („bodennah ausgebrachte Güllemenge“).
18. **Chronologie der Aufzeichnungen (O69-MB-016):** Geprüft wird die
    Reihenfolge der Einträge in der Liste.
19. **Maßnahmenübernahme (O69-GEN-018):** Ob Maßnahme 9 als „tierbezogene
    Maßnahme“ gilt, ist offen. Die Bedingung „Tiere und Flächen vom selben
    Vorbetrieb“ wird vorsichtshalber immer verlangt.
20. **Sanktionen (O69-GEN-020/GSP-008):** Die Einstufung eines konkreten
    Verstoßes in eine Stufe nimmt die AMA nach Schwere, Ausmaß, Dauer und
    Häufigkeit vor. Rego stellt nur die Stufentabelle und die
    Kumulationsfunktion bereit, keine automatische Zuordnung.
21. **Mehrjährige Bestimmungen:** Vertragszeitraum 2028, Flächenzu- und
    -abgänge und Maßnahmenwechsel gelten nicht für die einjährige Maßnahme 9.
    Sie stehen im Coverage-Ledger als `not_rule`.

## Nicht anwendbare 2026-Meldungen

- Die Meldungen vom 22.05.2026 (Biodiversitätsflächen UBB/BIO) und vom
  12.06.2026 (Insektizidverzicht, Rebzikade) betreffen andere Maßnahmen. Die
  Meldungen vom 05.08. und 12.08.2026 betreffen ebenfalls überwiegend andere
  Maßnahmen.
- Übernommen wurden nur die maßnahmenübergreifenden Aussagen:
  - Ernteverpflichtung und Dürre-Gebietskulisse (O69-NOT-001, O69-NOT-002)
  - Hinweis auf den Antrag auf höhere Gewalt (O69-GEN-026)
