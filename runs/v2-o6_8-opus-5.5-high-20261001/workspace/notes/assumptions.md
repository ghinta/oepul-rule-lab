# Annahmen und offene Fragen – o6_8 Erosionsschutz Acker

Run: `v2-o6_8-opus-5.5-high-20261001` (Modus `discover`).
Grundsatz (ATB Kap. 1, `gen.source_precedence`): Rechtlich verbindlich ist nur die
Sonderrichtlinie (SRL); das Maßnahmeninformationsblatt (MB, Stand April 2026) wird
als aktuelle Verwaltungsauslegung verwendet, wenn es konkreter ist.

## Fachliche Mehrdeutigkeiten

1. **BAW: Anteil am Erosions-Eintragspfad.** MB 4.3 verlangt, dass der Schlag
   „zumindest zu einem Viertel“ auf einem Eintragspfad liegt; SRL 2.8 sagt
   „zumindest teilweise“ und begrenzt die Prämie auf das Vierfache der Pfadfläche.
   Beides ist mathematisch dieselbe Grenze (Anteil ≥ 25 % ⇔ Schlag ≤ 4 × Pfad).
   Umgesetzt: `o6_8.baw.erosion_path_quarter_share` als blockierender Verstoß (MB),
   zusätzlich `o6_8.baw.max_four_times_erosion_path` als nicht blockierender
   Antragshinweis mit Kappung der Prämienfläche (SRL). Würde nur die SRL gelten,
   wäre der Viertel-Verstoß zu entfernen und nur die Kappung anzuwenden.
2. **US bei Sudangras.** SRL 2.8 nennt ab 2025 „Mais und Sorghum“; MB (Kap. 3.2,
   4.4, 5, 6, 7) nennt zusätzlich Sudangras. Umgesetzt nach MB (Kulturliste
   Kapitel 7 mit „ab 2025“).
3. **MS/DS und AH auf demselben Schlag.** Die Quellen sagen nur, dass die
   Kombination nicht prämienfähig ist, aber nicht, welches Verfahren entfällt.
   Umgesetzt: Verstoß plus keine Prämie für MS, DS und AH auf diesem Schlag.
4. **Weitere Codekombinationen.** Ausdrücklich zulässig sind nur MS+US und DS+US.
   Andere Paare (z. B. MS+DS) werden in `unlisted_code_combinations` gemeldet,
   ohne Prämienwirkung.
5. **Tiefenlockerung ohne Erhalt der Begrünung** wird als unzulässige tief
   mischende Bearbeitung gewertet (`o6_8.ms.deep_loosening_cover_preserved`).
6. **Anhang F.** Die Liste der Katastralgemeinden ist eine notwendige, aber keine
   hinreichende Bedingung; maßgeblich ist der Erosions-Eintragspfad-Layer im
   INVEKOS-GIS. Eingabe: `location.kg_nr` und `baw.erosion_path_area_ha`. Fehlt
   `kg_nr`, wird nicht geprüft.
7. **BAW-Pflege jedes zweite Jahr.** Geprüft am Jahresende: Verstoß, wenn die BAW
   seit mindestens dem Vorjahr besteht und die letzte Mahd/das letzte Häckseln
   zwei oder mehr Jahre zurückliegt (bzw. bei vollständigen Aufzeichnungen ohne
   Mahd).
8. **BAW-Umbruch nach Übernahme.** `baw.establishment_year` ist bei lagegenauer
   Übernahme das Anlagejahr des Vorbewirtschafters (MB 4.3).
9. **Maßnahmenbezogener OP-Code.** Laut ATB 5.5.2 wird `OPEROA` als Beispiel
   genannt; angenommen als OP-Code für Erosionsschutz Acker. `OP` gilt immer.
10. **Nationalparks.** Neusiedlersee und Donau-Auen: keine o6_8-Prämie. Andere
    Nationalparks: keine Prämie nur, wenn `national_park_relevant_obligations`
    wahr ist (SRL 1.6.2.2). Laut ATB ist dort grundsätzlich eine Prämie möglich.
11. **Dürre 2026, Ernteverpflichtung.** Die Ausnahme gilt nur für „üblicherweise
    im Spätsommer oder Herbst geerntete“ Ackerkulturen. Es gibt keine
    geschlossene Liste, daher ist ein Eingabe-Flag
    `harvest.late_summer_or_autumn_harvest_crop` erforderlich. Bezirksnamen
    werden exakt wie im Notice-Text verglichen.
12. **Dürre 2026, Untersaat.** Die Ausnahme vom 12.08.2026 (keine Flächendeckung)
    unterdrückt auch den Verstoß „ausreichender Feldaufgang“, weil die
    Vor-Ort-Kontrollen 2026 den Feldaufgang trockenheitsbedingt berücksichtigen
    (Notice 22.05.2026).
13. **DIV-Sonderregeln 2026 auf BAW-Flächen.** Vorzeitige oder dritte Nutzung von
    Acker-DIV betrifft UBB/BIO. Auf BAW-Flächen mit DIV-Anrechnung bleiben die
    BAW-Auflagen (z. B. Beweidungsverbot) bestehen („sämtliche andere Auflagen
    bleiben aufrecht“).
14. **Flächenabgänge.** o6_8-Flächen sind an die jährlich verfügbaren Flächen
    gebunden (SRL 1.7.2.5, ATB 5.9). Die 5-%-/5-ha-/0,5-ha-Toleranz (SRL 1.7.2.3)
    wird für o6_8 daher nicht als Rückzahlungsgrund angewandt. Die Funktion
    bleibt generisch verfügbar.
15. **Flächenobergrenze je Schlag.** Die Kappung bezieht sich auf die Summe
    aller Maßnahmen. Wie ein Überschuss auf die Maßnahmen aufgeteilt wird, ist
    nicht geregelt, daher wird nur `area_cap_exceeded` gemeldet. 2023: 1.200 €/ha
    laut ATB; die SRL in der Fassung 2024 nennt nur 1.300 €/ha.
16. **Modulation** auf Basis `land.total_area_ha` (gesamte Betriebsfläche laut MFA).
    Die Almflächen-Sonderbehandlung ist für o6_8 nicht relevant.
17. **Betriebsmindestgröße.** `land.total_area_ha` wird als Summe der
    anrechenbaren Flächen (inkl. GA, K20, LSE, Mehrnutzenhecken,
    Agroforststreifen) verwendet.
18. **Mindestteilnahme 0,10 ha.** Gezählt werden nur Schläge mit mindestens einem
    verfahrenskonformen Code ohne Ausschlussgrund (z. B. OP, Nationalpark).
19. **Vorfrucht-Zeitbezug.** `preceding_catch_crop` beschreibt die Begrünung vor
    dem Anbau im Antragsjahr `farm.year`. ÖPUL-2015-Varianten gelten nur 2023,
    GLÖZ-8-NPF-Varianten nur im MFA 2025. Der Wechsel Immergrün → ZWF wird über
    die fehlende Teilnahme an „7“ im Antragsjahr erkannt.
20. **Wien-Option.** „Gebietskulisse Wien“ entspricht `location.federal_state ==
    "Wien"`.
21. **UBB/BIO-Querwirkung.** `slope_percent` des Canonical Farm Profile wird als
    „überwiegende Hangneigung“ interpretiert. Erosionsmindernde Verfahren sind
    alle o6_8-Codes am Schlag.
22. **Prämien 2023.** Die SRL-Fassung 2024 nennt nur die Sätze ab 2024
    (+8 %, Präambel 1a); die Sätze 2023 stammen aus der MB-Tabelle.
23. **Schlagnutzungsart.** Die Kulturlisten verwenden die MFA-Schlagnutzungsarten
    wörtlich (z. B. „Sonnenblume“ in US, „Sonnenblumen“ in MS/DS). Abgeglichen
    wird exakt gegen `oepul_o6_8.crop_usage_type`, sonst gegen `crop.crop_name`.
24. **Sanktionsbemessung** (Schwere, Ausmaß, Dauer, Häufigkeit) ist nicht
    berechenbar. Abgebildet sind nur die Stufen (Daten) und die Verstöße.

## Technische Hinweise

- Rego-Paket `oepul.o6_8` (Dateien unter `policy/o6_8/`), Gesamtergebnis in
  `data.oepul.o6_8.decision`.
- Datentabellen unter `data/o6_8/` (Anhang F vollständig mit 1952 Zeilen,
  Anhang L vollständig mit 134 Zellen).
- Die vorgeschlagenen Eingabefelder stehen in `rules/profile_changes.json`.
  Das Canonical Farm Profile wurde nicht verändert.
