# o6_19: unveränderte Modellnotizen

Sämtliche Modellannahmen sind unbestätigt. Auch nicht einzeln priorisierte Auslegungen müssen vor Übernahme geprüft werden.

## luna: `v2-o6_19-luna-high-20261005`

# Fachliche Annahmen und offene Punkte

- Das Canonical Farm Profile enthält keine Maßnahmengruppe. Die Discover-Vorschläge in `rules/profile_changes.json` ergänzen ausschließlich fehlende Eingabevariablen; `canonical_farm_profile.json` wurde nicht verändert.
- Die Projektbestätigung ist die maßgebliche Quelle für die tatsächlich ausgewählten Indikatoren je Schlag. Anhang K ist deshalb als vollständiger Katalog und nicht als Behauptung modelliert, dass jeder Indikator auf jedem Schlag zugleich gilt.
- Die Platzhalter `$1`, `$2` und `$NEO` im extrahierten Anhang-K-Text sind projekt- bzw. lebensraumspezifische Parameter. Sie wurden nicht geraten oder durch Profilwerte ersetzt. Die Policy prüft daher die vom Projekt bestätigten Ergebnisfelder und nutzt die Tabelle als geschlossene Code-/Textliste.
- Für die EBW-Flächenstilllegung wurde die Formulierung „maximal 25 %, jedenfalls 2,00 ha“ als `max(25 % der Ackerfläche, 2 ha)` operationalisiert. Die Rechtsquelle nennt die Mindestgarantie, aber keine alternative Berechnungsformel.
- Die Prämientabelle enthält in der Quelle für einzelne Kombinationen `/`; diese Kombinationen werden als `null` im Datenkatalog geführt und nicht als förderfähig angenommen.
- Die allgemeinen Biodiversitäts-Dürreausnahmen vom 22.05.2026 und 12.08.2026 werden für EBW nicht als Freigabe interpretiert: Der 12.08.2026-Hinweis sagt ausdrücklich, dass zusätzlich in EBW eingebrachte Acker-Biodiversitätsflächen weiterhin nach der Projektbestätigung zu bewirtschaften sind.
- Der 12.06.2026-Hinweis zum vorzeitigen Ausstieg aus dem Insektizidverzicht Wein/Obst/Hopfen und die nicht maßnahmenspezifischen Abschnitte der 05.08.2026- bzw. 12.08.2026-Hinweise sind in `rules/coverage.json` als `not_rule` dokumentiert.
- Die HTML-Quellen haben keine PDF-Seiten. Ihre Quellenbelege verwenden deshalb `page: null` und den HTML-Abschnitt als Locator.


## opus: `v2-o6_19-opus-5.5-high-20260927`

# Annahmen und offene fachliche Fragen – o6_19 „Ergebnisorientierte Bewirtschaftung“ (EBW)

Run: `v2-o6_19-opus-5.5-high-20260927`, Modus `discover`.

## Eingabemodell

- Alle EBW-spezifischen Eingaben fehlen im Canonical Farm Profile und werden in
  `rules/profile_changes.json` als 94 einzelne, nicht überlappende Blattfelder
  vorgeschlagen (unter `land.parcels[].oepul.*`, `land.parcels[].oepul.ebw.*`,
  `oepul.*`, `oepul.o6_19.*`). Übergeordnete Objekte entstehen implizit.
  Arrayfelder (`codes`, `indicators`, `other_measure_premium_claims`,
  `surcharge_codes`) werden als Array mit repräsentativem Element beschrieben.
- Jeder Pfad in den `input_paths` der Regeln ist entweder im Canonical Farm
  Profile vorhanden oder als Feld vorgeschlagen; die Rego-Regeln lesen genau
  diese Pfade.
- Datumsangaben werden als `YYYY-MM-DD`-Strings erwartet (lexikographischer Vergleich).

## Prämienberechnung

1. **Prämiensätze 2023**: Anhang K gibt Sätze „ab 01.01.2024“ an. Für 2023 enthalten
   die Quellen keine EBW-Flächensätze; Rego liefert für 2023 keinen Satz
   (`rate_issues: base_rate_not_found`). Die Braunkehlchen-Zeile „bis inkl. 2024“
   wird daher nur für 2024 angewendet.
2. **Tabellenwerte verbatim**: Auffällige Werte (z. B. „Feuchte bis nasse Fettwiese“
   A/schwer 1.124,0 statt 1.112,4; „Mäh-Halbtrockenrasen“ B/schwer 1.285,2 > A/schwer
   1.210,0) wurden unverändert übernommen, nicht korrigiert.
3. **Vogeltabelle**: nur Spalte „Sehr guter Erhaltungszustand (A)“ vorhanden; bei B/C
   wird kein Satz ermittelt.
4. **EBBA01/EBBA02**: „kann nur einmal pro Fläche vergeben werden“ wird so gelesen,
   dass je Schlag höchstens ein EBBA-Code zulässig ist (EBBA02 als höhere Stufe
   statt zusätzlich zu EBBA01). EBBA02 nur bei Erhaltungszustand A („sehr gut“).
5. **EBBA-Gründe**: Einschränkungen der Entscheidungsliste wurden, soweit
   maschinell prüfbar, codiert (Erschwernis, Flächengröße, ausgeschlossene
   Lebensräume, Indikatorpräfixe, Erhaltungszustand, Schnittzahl, Vorjahres-Acker).
   Nicht prüfbar bleiben u. a. „regionaltypische Schnittzahl“, „Gunstlage“,
   NALA-Erfassung und die Entfernungsangaben (Eingabe über `ebba_reason_id` wird
   als Beurteilung der Koordinationsstelle übernommen).
6. **EBHG**: Die LRT-/Artenliste aus Anhang I Abschnitt H ist als Referenzumfang
   in `data/` erfasst; Rego prüft die Eignung über die Meldung der
   Landesdienststelle (`habitat_area_reported_in_gis`) und den Layer-Anteil ≥ 50 %.
   EBHG01 wird Grünland-, EBHG02 Ackerschlägen zugeordnet (analog HG01/HG02).
7. **Obergrenze 1.500 EUR/ha**: Die Obergrenze gilt für die Summe aller
   flächenbezogenen Zahlungen je Schlag. Welche Zahlung gekürzt wird, regeln die
   Quellen nicht; das Modell kürzt den EBW-Satz (Obergrenze minus
   `other_area_payments_eur_per_ha`).
8. **Kürzungsreihenfolge** (SRL 1.12.2): inhaltliche Kürzung → Stilllegungs-Obergrenze
   → Modulation → Flächenzahlungs-Obergrenze → Zugangskürzung. Übererklärungen,
   Fristversäumnis und Konditionalität sind nicht modelliert.
9. **Stilllegungs-Obergrenze (25 % / 2 ha)** und **Flächenzugang ab 2026
   (+50 % / +5 ha auf Basis 2025)**: Die Quellen nennen nicht, welche Schläge
   gekürzt werden; das Modell kürzt anteilig über alle betroffenen Flächen. Die
   Zugangsbeschränkung wird auf die gesamte prämienfähige EBW-Fläche angewendet;
   die Unterscheidung „bereits vorher mit der gleichen Maßnahme belegt“ ist nicht
   schlagweise modelliert und muss bei der Eingabe `ebw_area_2025_ha`
   (Bezugsfläche 2025) vorab berücksichtigt werden.
10. **Modulation** wird auf die gesamte Maßnahmenprämie inkl. Zuschlag Regionaler
    Naturschutzplan angewendet („Prämienausmaß aller Maßnahmen“).
11. **Sanktionen**: Die Kürzungsstufe wird als Ergebnis der AMA-Bewertung
    (`oepul.o6_19.sanctions.stage`) eingegeben; die Einstufung nach Schwere,
    Ausmaß, Dauer und Häufigkeit ist nicht automatisiert. Indikator-, Erfassungs-
    und Änderungsverstöße werden als `obligation_violations` gemeldet, streichen
    die Fläche aber nicht automatisch.

## Förderfähigkeit und Auflagen

12. **Mindestbewirtschaftungskriterien vs. „jedes zweite Jahr“**: Die allgemeinen
    Kriterien (Grünland jährlich mähen/beweiden) gelten laut SRL 1.6.3, „sofern in
    der Maßnahmenbeschreibung keine abweichenden Bestimmungen festgelegt sind“.
    Die EBW verlangt Nutzung/Pflege „zumindest jedes zweite Jahr“ und nimmt
    Grünbrachen ausdrücklich aus. Ob die Zwei-Jahres-Regel für alle EBW-Flächen
    eine abweichende Bestimmung ist, bleibt offen (R-O619-GEN-MIN-MGMT-CRITERIA,
    nicht automatisiert). Nur die Ausnahme für EBW-Grünbrachen ist codiert.
13. **Mindestteilnahme ab Jahr 2** („zumindest ein Schlag“) wird als
    Zugangsvoraussetzung behandelt (Allgemeine Bedingungen 8.2 nennen
    „Mindestteilnahmeflächen“); die Folge ist „keine Prämie im betroffenen Jahr“.
14. **Weiterbildung**: Ein Verstoß wird erst nach dem 31.12.2026 festgestellt
    (Förderjahre > 2026). Merkblatt nennt „förderwerbende Person“, SRL
    „Betriebsführerin/Betriebsführer“; beides wird als `farm_manager` abgebildet.
15. **Kombination auf der Einzelfläche**: Unzulässige Kombinationen (Anhang L,
    Zeile 19) werden als `combination_conflicts` gemeldet, ohne automatisch eine
    der beiden Prämien zu streichen, weil die Quellen offenlassen, welche entfällt.
16. **OP-Code**: Ein maßnahmenbezogener OP-Code für EBW wird nicht genannt;
    codiert sind nur `OP` und `VF`.
17. **Nationalparks**: Ohne Angabe von `national_park_relevant_requirements` wird
    konservativ „relevante Auflagen vorhanden“ (keine Prämie) angenommen.
18. **0,15-ha-Feldstücksregel**: Das Merkblatt verlangt sie für den
    Gesamtbetriebs-Fall ohne Hinweis auf die UBB-Schwelle (ab 10 ha Acker bzw.
    gemähtem Grünland). Das Modell wendet sie wie im Merkblatt ohne diese
    Schwelle an. Die 7-%-Quote von UBB/BIO wird in o6_19 nicht berechnet.
19. **Kapitel 7 „Erhaltungszustände“**: Die Überschrift nennt Erhaltungszustände,
    die Liste enthält aber nur Lebensraumnamen. Die Anrechnung prüft daher nur
    Lebensraum und Schlagnutzungsart. Namen müssen exakt übereinstimmen (keine
    Zuordnung zu den Anhang-K-Prämienbezeichnungen).
20. **Anhang K Tier-Indikatoren**: Die Zuordnung von EBAT02–EBAT07 zu Vogelgruppen
    folgt der Zeilenlage der Textextraktion (Tabellenlayout mehrdeutig).
    EBGH07 ist in der Quelle abgeschnitten und verbatim übernommen.

## Hinweise 2026

21. Die Ausnahme für Acker-Biodiversitätsflächen schließt EBW ausdrücklich aus
    (12.08.2026). Für Grünland-Biodiversitätsflächen nennt die Meldung vom
    22.05.2026 nur „Naturschutz“ als Beispiel für „andere Vorgaben“. Die
    Anwendung auf EBW ist eine Analogie (Projektbestätigung als andere Vorgabe).
22. Die Freigabe der Nutzungstermine ab 12.08.2026 nennt nur „Naturschutz“ und
    „Natura 2000“; für EBW wird **keine** Freigabe angenommen.
23. Die Dürre-Ausnahme zur Ernteverpflichtung gilt allgemein für ÖPUL-Ackerflächen.
    Für EBW-Ackerflächen setzt das Modell voraus, dass dort eine Ernteverpflichtung
    besteht (bewirtschaftete Äcker). Die Gebietskulisse wird über
    `farm.region.federal_state/district` geprüft (Betriebs-, nicht Schlagsitz;
    Bezirksnamen müssen exakt übereinstimmen).
24. Die Meldung zum Insektizidverzicht (Rebzikade) und die Dürre-Regeln zu
    Begrünung, Immergrün, Untersaaten und Nutztierrassen betreffen andere Maßnahmen
    (`not_rule` in der Coverage).

## Nicht automatisierte Katalogregeln

Folgende Regeln sind nur im Katalog erfasst (keine Rego-Symbole), weil
Eingaben oder Ermessensentscheidungen fehlen: R-O619-GEN-CONDITIONALITY,
R-O619-GEN-MIN-MGMT-CRITERIA, R-O619-GEN-OP-CASES, R-O619-GEN-SELF-REPORT,
R-O619-GEN-FARM-TRANSFER, R-O619-GEN-EXIT-TIMING, R-O619-GEN-REENTRY,
R-O619-GEN-COMBINATION-CORRECTION, R-O619-GEN-REVISION-CLAUSE,
R-O619-GEN-COORD-BODY, R-O619-N2026-CONTROL-CONSIDERATION. Ihre Belege
verweisen mit `used_by` auf `rules/rules.json`.
