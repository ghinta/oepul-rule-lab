# o6_8: offene Fachentscheidungen

Alle Antworten und App-Zuordnungen bleiben offen. Die Zitate sind Modellnotizen bzw. Prüfbeobachtungen, keine bestätigte Fachauslegung.

### o6_8-INPUT_CONTRACT

Welche der im Diff einzeln gelisteten Eingaben werden fachlich benötigt und aufgenommen? Für jede: verbindlicher Name, Betrieb/Schlag/Tier/Gruppe/Projekt, Einheit, Zeitbezug, Herkunft/Nachweis und Abgrenzung zu bestehenden App-Feldern. Luna- und Opus-Strukturen sind alternative Vorschläge; keine automatische Umbenennung.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_8-luna-high-20261002/workspace/rules/profile_changes.json:8–11`

```text
      "path": "farm.oepul",
      "value_after": {
        "first_participation_year": "int",
        "contract_start_year": "int",
```

Ursprung: `runs/v2-o6_8-opus-5.5-high-20261001/workspace/rules/profile_changes.json:8–11`

```text
   "path": "farm.oepul.participating_measures",
   "value_before": null,
   "value_after": [
    "enum(1A|1B|1C|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24)"
```

### o6_8-BAW_THRESHOLD

Führt unter 25 % Eintragspfad zur Ablehnung oder nur zur Kappung auf vierfache Pfadfläche? Welche GIS-Version und genaue Teilfläche belegen den Anteil?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_8-opus-5.5-high-20261001/workspace/notes/assumptions.md:10–17`

```text
1. **BAW: Anteil am Erosions-Eintragspfad.** MB 4.3 verlangt, dass der Schlag
   „zumindest zu einem Viertel“ auf einem Eintragspfad liegt; SRL 2.8 sagt
   „zumindest teilweise“ und begrenzt die Prämie auf das Vierfache der Pfadfläche.
   Beides ist mathematisch dieselbe Grenze (Anteil ≥ 25 % ⇔ Schlag ≤ 4 × Pfad).
   Umgesetzt: `o6_8.baw.erosion_path_quarter_share` als blockierender Verstoß (MB),
   zusätzlich `o6_8.baw.max_four_times_erosion_path` als nicht blockierender
   Antragshinweis mit Kappung der Prämienfläche (SRL). Würde nur die SRL gelten,
   wäre der Viertel-Verstoß zu entfernen und nur die Kappung anzuwenden.
```

### o6_8-CROP_CODE_SCOPE

Wie werden Sudangras, MFA-Kulturnamen, nur-MS- und ab-2025-Listenwerte normalisiert? Welche Wirkung haben MS/DS/AH-Kombinationskonflikte?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_8-opus-5.5-high-20261001/workspace/notes/assumptions.md:18–26`

```text
2. **US bei Sudangras.** SRL 2.8 nennt ab 2025 „Mais und Sorghum“; MB (Kap. 3.2,
   4.4, 5, 6, 7) nennt zusätzlich Sudangras. Umgesetzt nach MB (Kulturliste
   Kapitel 7 mit „ab 2025“).
3. **MS/DS und AH auf demselben Schlag.** Die Quellen sagen nur, dass die
   Kombination nicht prämienfähig ist, aber nicht, welches Verfahren entfällt.
   Umgesetzt: Verstoß plus keine Prämie für MS, DS und AH auf diesem Schlag.
4. **Weitere Codekombinationen.** Ausdrücklich zulässig sind nur MS+US und DS+US.
   Andere Paare (z. B. MS+DS) werden in `unlisted_code_combinations` gemeldet,
   ohne Prämienwirkung.
```

### o6_8-DROUGHT_EVIDENCE

Unterdrückt die Dürre-Erleichterung auch ausreichenden Feldaufgang? Wie werden Lage, Anlagejahr bei Übernahme, Pflege und OPEROA-Code belegt?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_8-opus-5.5-high-20261001/workspace/notes/assumptions.md:29–56`

```text
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
```
