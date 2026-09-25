# Annahmen und offene fachliche Fragen – o6_6 Begrünung von Ackerflächen – Zwischenfruchtanbau

Run: `v2-o6_6-opus-5.5-high-20260925` (Modus `discover`)

## Modellierung

- **Paket und Eingabe:** Die Rego-Regeln liegen im Paket `oepul.o6_6` (`policy/o6_6/*.rego`). Die Tabellen stehen unter
  `data/o6_6/*.json` und werden über `data.o6_6.*` gelesen. Die Eingabe folgt dem Canonical Farm Profile samt den
  vorgeschlagenen Ergänzungen in `rules/profile_changes.json`. Das Antragsjahr ist `farm.year`, das Begrünungsjahr ist
  das Antragsjahr.
- **Schweregrade:** Verstöße tragen die Schwere `ineligible` (Schlag nicht als Begrünung anrechenbar, keine Prämie
  für den Schlag) oder `obligation` (Verstoß gegen eine inhaltliche Förderverpflichtung). Die Kürzung bei `obligation`
  legt die AMA nach dem Stufenschema fest (Schwere, Ausmaß, Dauer, Häufigkeit). Sie wird nicht automatisch
  abgeleitet, sondern als Eingabe `farm.oepul.content_violation_level` übernommen. Die Einteilung in die beiden
  Schweregrade ist eine eigene Modellierungsentscheidung.
- **Prämienband:** Die Sätze sind Prämienbänder, die aliquot nach verfügbaren EGFL-Mitteln verteilt werden. Berechnet
  werden daher Mindest- und Höchstprämie. Garantiert ist nur der Mindestbetrag. Den tatsächlichen Satz kann man aus
  Betriebsdaten nicht bestimmen.
- **Reihenfolge der Kürzungen:** Zuerst die inhaltliche Kürzung (Schritt 5), dann die Modulation (Schritt 7), gemäß
  SRL 1.12.2. Übererklärungen und Fristversäumnisse werden nicht berechnet, weil die Eingabe keine Kontrolldaten
  enthält.
- **Modulation:** Grundlage ist `land.total_area_ha` als „gesamte Fläche des Betriebes“. Abgleich: 220 ha ergeben den
  Faktor 99,09 %.
- **Mindestauszahlung 50 €:** Wird nur als Flag `below_min_payment` ausgegeben. Die Quelle sagt „kann abgesehen
  werden“, es ist also eine Ermessensentscheidung.

## Auslegungsfragen

1. **Ende des Begrünungszeitraums:** Die Spalte heißt „Ende des Begrünungszeitraums (frühester Umbruch am)“. Ein
   Umbruch am angegebenen Tag gilt daher als zulässig. Die Verbote (mineralischer N, PSM, Bodenbearbeitung) gelten
   im halboffenen Intervall [Anlagedatum, Ende).
2. **Variante 1 ab 2025:** Frühester Umbruch ist max(Anlagedatum + 70 Tage, 15.09.). Der Anlagetag zählt als
   Begrünungstag, der Umbruchtag nicht. Beide Beispiele im Maßnahmenblatt werden damit reproduziert
   (10.08. → 19.10.; 07.07. → 15.09.).
3. **Variante 6, Mischungspartner:** Die Tabelle nennt keine Mindestzahl („Kulturen oder deren Mischungen“). Die
   Reinsaat einer zulässigen Kultur wird daher akzeptiert (Minimum 1 Partner, 1 Familie).
4. **Variante 7, Pflege- und Walztermine:** Das Maßnahmenblatt nennt Termine nur für Variante 1 und die Varianten
   2–6, die SRL verbietet Pflege nur bei den Varianten 2–6. Für Variante 7 wird daher kein Pflegetermin geprüft. Das
   allgemeine PSM-Verbot und die Pflicht zur mechanischen Beseitigung gelten für Variante 7 nicht; das Verbot
   mineralischer N-Düngung gilt.
5. **Widerspruch in der AMA-Meldung vom 05.08.2026:** Dort steht, Variante „1 oder 2“ sei „bis 5. August bzw.
   10. August“ anzulegen. Das kehrt die Reihenfolge des Maßnahmenblatts um (V1: 10.08., V2: 05.08.). Maßgeblich
   bleiben Maßnahmenblatt und SRL; das Beispiel derselben Meldung (Variante 2 bis 5. August) bestätigt das.
6. **Walzen, SRL gegen Maßnahmenblatt:** Die SRL verbietet bei den Varianten 2–6 Walzen von der Anlage bis
   einschließlich 31.10. ohne Ausnahme. Das Maßnahmenblatt erlaubt das Anwalzen unmittelbar nach der Anlage und
   Walzen bei Frost, wenn die flächendeckende Begrünung erhalten bleibt. Übernommen wurden die Ausnahmen des
   Maßnahmenblatts. Rechtlich verbindlich ist die SRL; das bleibt offen.
7. **Mechanische Beseitigung und SRL:** Die SRL nennt als Methoden nur „Häckseln oder Einarbeiten“. Das Maßnahmenblatt
   erweitert die Liste (Direkt-/Mulchsaat, Abfrosten und Niederbrechen, Niederwalzen bei rein abfrostenden Mischungen
   der Varianten 1–5). Verwendet wurde die Liste des Maßnahmenblatts (`data/o6_6/management.json`).
8. **PSM ohne mechanische Beseitigung (5.4):** Ausgelegt als: Nach Ende des Begrünungszeitraums ist PSM nur zulässig,
   wenn vorher eine anrechenbare mechanische Beseitigung erfolgt ist oder die Folgekultur schon gesät ist. Geprüft
   wird das nur für die Varianten 1–6.
9. **Variante 1, Folgekultur:** „(winterharte) Hauptkultur im Herbst“ wird geprüft als: Saat nach dem Umbruch und bis
   31.12. des Antragsjahres, dazu Beantragung im nachfolgenden MFA. Die Winterhärte steht in Klammern und wird nicht
   erzwungen.
10. **Untersaaten:** Die Einschränkung auf Varianten, deren Begrünungszeitraum nach der Ernte beginnt, wird so
    umgesetzt: Das Anlagedatum ist das Erntedatum der Vorfrucht und muss vor dem spätesten Anlagetermin der Variante
    liegen. Eine weitergehende Einschränkung (z. B. Ausschluss von Variante 7) wird nicht angenommen.
11. **Insektenblütige Pflanzen:** Die Liste im Maßnahmenblatt ist nur beispielhaft. Wenn
    `insect_pollinated_partner_count` angegeben ist, hat diese Zahl Vorrang. Sonst werden die angegebenen Arten mit
    der Beispielliste abgeglichen (exakte Namen). Arten außerhalb der Liste können trotzdem insektenblütig sein.
12. **Getreide/Mais:** Getreide wird nach der ÖPUL-Getreideliste erkannt, Mais über den Namensbestandteil „mais“.
    Einen reinen Getreide-/Maisbestand erkennt die Regel nur, wenn alle angegebenen Arten Getreide oder Mais sind. Der
    Anteil in Prozent ist eine eigene Eingabe.
13. **Grünschnittroggensorten:** Die Sortenlisten geben den Stand bei Erstellung des Maßnahmenblatts wieder (nicht
    abschließend: „laut Saatgutgesetz“). Später zugelassene Sorten lösen daher einen Verstoß aus, der manuell zu
    prüfen ist.
14. **Variante 7, Winterraps:** Geprüft wird über `crop.crop_name == "Winterraps"`. Abweichende Bezeichnungen im MFA
    werden nicht erkannt.
15. **Einzelflächenkombination (Anhang L):** Nicht kombinierbare Maßnahmen auf demselben Schlag werden als
    `combination_conflicts` gemeldet, blockieren die o6_6-Prämie aber nicht. Welche Maßnahme die Prämie verliert,
    regeln die Quellen nicht.
16. **Nationalparks:** Neusiedlersee und Donau-Auen schließen die Prämie immer aus. In anderen Nationalparks entfällt
    sie nur, wenn relevante Bewirtschaftungsauflagen bestehen; das ist als Eingabeflag modelliert.
17. **Flächenweitergabe:** Hält der Nachfolgebetrieb die Bedingungen nicht ein, entfällt die Prämie für den Schlag
    (Abmeldung bzw. OP-Code). Ausnahme: Verpachtung einer Fläche der Varianten 2, 4, 5 oder 6 nach dem 31.12. an
    einen Betrieb mit System Immergrün.
18. **Ausstieg:**
    - Eine Abmeldung im Antragsjahr macht die Maßnahme für dieses Jahr ungültig.
    - Eine Abmeldung im Folgejahr vor dem Ende des Begrünungszeitraums (Varianten 2, 4, 5, 6, 7) wird als Verstoß
      gemeldet.
    - Eine Abmeldung nach Ankündigung einer Vor-Ort-Kontrolle gilt als nicht wirksam.
19. **Umstieg auf System Immergrün:** Es gilt als gleichzeitige Teilnahme, wenn o6_6 nicht vor dem 01.01. des
    Antragsjahres abgemeldet wurde und o6_7 im selben Jahr beginnt.
20. **Sanktionsstufen:** Ab 2027 wird eine Verwarnung als Einbehalt von 1 % behandelt (Fußnote * in Kapitel 8.2).
    „Ausschluss“ setzt die Prämie auf 0. Die Rückforderung früherer Jahre wird nicht berechnet.
21. **Ernteverpflichtung und Dürre-Gebietskulisse 2026:** Für o6_6 wirkt beides nur als Hinweis (`advice`). Nach den
    Allgemeinen Teilnahmebedingungen 5.5.2 bleibt die o6_6-Prämie auf nicht abgeernteten Schlägen erhalten, wenn
    maßnahmenbezogene OP-Codes vergeben werden (nicht OP/OPZWF). Die Gebietskulisse ist vollständig in
    `data/o6_6/notices_2026.json` erfasst; der Bezirk kommt aus `farm.region.district`.
22. **Dürre 2026, Flächendeckung:** Die Ausnahme greift nur, wenn `properly_established == true`. Beim Ausfallgetreide
    über 50 % wird zusätzlich `cereal_share_from_volunteer == true` verlangt.
23. **Laufzeit der Varianten:** Die Tabellenzeilen gelten bis 2028, dem Ende der SRL-Laufzeit. Letzter Einstieg ist
    2027; die Weiterführung vorbeantragter einjähriger Maßnahmen im Jahr 2028 wird angenommen.
24. **Betriebsmindestgröße im 1. Jahr:** Näherung über `land.total_area_ha` für die landwirtschaftliche Fläche
    inklusive GA/K20/LSE.

## Nicht umgesetzte bzw. nur katalogisierte Regeln

Diese Regeln stehen in `rules/rules.json`, aber ohne ausführbares Rego, weil die Eingabe dafür keine sinnvollen
Daten liefert:

- Konditionalität
- Selbstanzeige
- Maßnahmenübernahme
- Revisionsklausel
- Verweigerung der Kontrolle
- vorübergehende Umstände
- Auszahlungsmodalitäten
- Maßnahmenwechsel (nicht anwendbar)
- Flächenabgangs-Toleranz (nicht anwendbar)
