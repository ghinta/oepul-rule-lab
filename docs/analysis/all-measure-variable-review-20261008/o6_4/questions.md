# o6_4: offene Fachentscheidungen

Alle Antworten und App-Zuordnungen bleiben offen. Die Zitate sind Modellnotizen bzw. Prüfbeobachtungen, keine bestätigte Fachauslegung.

### o6_4-INPUT_CONTRACT

Welche der im Diff einzeln gelisteten Eingaben werden fachlich benötigt und aufgenommen? Für jede: verbindlicher Name, Betrieb/Schlag/Tier/Gruppe/Projekt, Einheit, Zeitbezug, Herkunft/Nachweis und Abgrenzung zu bestehenden App-Feldern. Luna- und Opus-Strukturen sind alternative Vorschläge; keine automatische Umbenennung.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_4-luna-high-20261001/workspace/rules/profile_changes.json:8–11`

```text
      "path": "farm.o6_4",
      "value_after": {
        "code": "BM0",
        "year": 2026,
```

Ursprung: `runs/v2-o6_4-opus-5.5-high-20260925/workspace/rules/profile_changes.json:8–11`

```text
      "path": "land.parcels[].mountain_meadow",
      "value_before": null,
      "value_after": {
        "declared_as_mountain_meadow": "boolean",
```

### o6_4-ALPINE_OPERATION

Ist Almbetrieb ein eigenständiger Betrieb oder auch ein Heimbetrieb mit Alm, und welcher Höhenvergleich entfällt tatsächlich?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_4-opus-5.5-high-20260925/workspace/notes/assumptions.md:21–30`

```text
1. **„Mehr als die Hälfte“ / „überwiegender Teil“ über 1.200 m** wird streng als `> 50 %` umgesetzt; genau 50 %
   ist nicht teilnahmefähig. Der Anteil muss aus dem INVEKOS-GIS-Layer als Eingabe geliefert werden.
2. **Almbetriebe (O6_4-ELIG-004):** Die Ausnahme „kann auch unter der Almbetriebsstätte liegen“ wird so gelesen,
   dass bei Almbetrieben der Seehöhenvergleich mit der Betriebsstätte ganz entfällt. Das 1.200-m-Kriterium
   bleibt davon unberührt. Ob „Almbetrieb“ einen eigenständigen Almbetrieb oder einen Heimbetrieb mit Alm meint,
   ist offen; modelliert ist ein Boolean `farm.oepul_participation.is_alpine_farm_operation`.
3. **„In der Regel nicht angrenzend“ (O6_4-ELIG-005)** ist eine Regelvermutung. Sie erzeugt nur einen
   Prüfhinweis (`advisory`), keine Ablehnung.
4. **„Schwierig zu bewirtschaften“ (Hangneigung, Lage, Erreichbarkeit)** beschreibt den Förderzweck und ist
   keine eigene Prüfschwelle. Die Eingabe `difficult_to_manage` wird nur dokumentiert.
```

### o6_4-MOWING_HISTORY

Welche historischen Vollflächen-/Abtransportnachweise braucht die Zweijahresmahd? Wie werden Mischmähverfahren und ihre BM-Codes aufgeteilt?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_4-opus-5.5-high-20260925/workspace/notes/assumptions.md:31–37`

```text
5. **Mahd jedes zweite Jahr (O6_4-MOW-001):** Die Mahd im Vorjahr wird aus `cutting_dates` des Vorjahres oder aus
   `operations.mowing.mowed_previous_year` abgeleitet. Ob die Vorjahresmahd vollflächig war und das Mähgut
   verbracht wurde, lässt sich mit dem Profil nicht prüfen und gilt als erfüllt. Ein Verstoß wird erst erkannt,
   wenn in zwei aufeinanderfolgenden Jahren keine Mahd stattfand.
6. **Mähverfahren bei gemischtem Einsatz (O6_4-CODE-003):** Nach den Beispielen bestimmt das Hauptmähverfahren
   den Code; das Ausmähen mit der Sense ändert ihn nicht. Für echte Mischflächen (z. B. halb Motormäher, halb Sense)
   enthalten die Quellen keine Aufteilungsregel. Es wird genau ein Code je Schlag erwartet (O6_4-CODE-002).
```

### o6_4-SUBSTANCES

Wie wird bedarfsgerechte Festmistgabe belegt und Bio-PSM-Zulässigkeit gegen einen aktuellen Registerstand geprüft?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_4-opus-5.5-high-20260925/workspace/notes/assumptions.md:60–66`

```text
15. **Düngemittel:** Die geschlossene Liste in `data/o6_4/input_substances.json` stuft alle Düngemittel außer
    Festmist (ursprüngliche Form) und eigenen häuslichen Abwässern als unzulässig ein, darunter Kompost,
    Gärrückstand und Jauche. Grundlage ist der Satz „da sämtliche Düngemittel (außer Festmist) verboten sind“.
    Eine angegebene `mineral_n_kg_per_ha > 0` gilt ebenfalls als Verstoß. Die „Bedarfsgerechtheit“ der
    Festmistgabe ist nicht quantifiziert und wird nicht geprüft.
16. **Pflanzenschutz:** Ob nur bio-zulässige Wirkstoffe verwendet wurden, ist eine Eingabe
    (`psm_only_bio_approved_substances`); die Betriebsmittelliste (betriebsmittelbewertung.at) liegt nicht vor.
```

### o6_4-PREMIUM_CONFLICT

Welche Zahlung entfällt bei Kombinationen, wie werden Landschaftselement-Komponenten abgegrenzt und Zugangskürzungen auf Schläge verteilt?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_4-opus-5.5-high-20260925/workspace/notes/assumptions.md:40–57`

```text
8. **Kombinationsausschluss (O6_4-PREM-003):** Eine unzulässige Kombination wird als `combination_conflict`
   gemeldet. Die o6_4-Prämie wird dabei **nicht** automatisch auf 0 gesetzt, weil die Quellen nicht festlegen,
   welche der kollidierenden Prämien entfällt. GEN-COMB-001 sieht eine Korrektur bis zur Auszahlungsmitteilung vor.
   Die Zuordnung `o6_1a` → Anhang-L-Spalte `1A` usw. erfolgt über `annex_l_id`.
   „Punktförmige Landschaftselemente“ (Maßnahmenblatt) und „Landschaftselemente“ (SRL/Anhang L Fn. 1) werden
   gleich behandelt über `premium_component == "landscape_element"`.
9. **Prämienobergrenze (GEN-CAP-001):** Rego meldet nur die Überschreitung (`cap_exceeded`). Welche Zahlung
   gekürzt wird, ist nicht geregelt. Nach SRL 1.12.2 erfolgt die Kappung nach der Modulation.
10. **Flächenzugang und -abgang:** Die Funktionen `premium_eligible_area_limit_ha`, `area_addition_excess_ha`,
    `area_reduction_tolerance_ha` und `area_reduction_repayment_ha` rechnen auf Maßnahmenebene. Die Verteilung
    einer Zugangskürzung auf einzelne Schläge regeln die Quellen nicht; `parcel_premium` wird daher nicht gekürzt.
    In `reduction_exempt_ha` gehören Flächen mit Verlust der Verfügungsgewalt und zulässig umgewandelte Flächen.
11. **Modulation:** Als „gesamte Fläche des Betriebes“ dient `land.total_area_ha`. Die Almfläche wird getrennt
    betrachtet, betrifft o6_4 aber nicht. `modulation_factor(0) = 1`.
12. **Betriebsmindestgröße:** Die 1,50 ha werden gegen `land.total_area_ha` geprüft. Das ist eine Näherung, denn
    die Quelle zählt GA-, K20-, GLÖZ-LSE-, Mehrnutzenhecken- und Agroforstflächen hinzu.
13. **OP-Code:** Ein maßnahmenbezogener OP-Code für Bergmähder (analog OPBIO/OPUBB) wird in keiner Quelle genannt.
    Rego wertet nur `OP` und `VF` als prämienausschließend (`data.o6_4.general_parameters.op_code_mandatory_cases.no_premium_codes`).
```
