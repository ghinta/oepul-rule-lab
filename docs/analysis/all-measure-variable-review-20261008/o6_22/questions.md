# o6_22: offene Fachentscheidungen

Alle Antworten und App-Zuordnungen bleiben offen. Die Zitate sind Modellnotizen bzw. Prüfbeobachtungen, keine bestätigte Fachauslegung.

### o6_22-INPUT_CONTRACT

Welche der im Diff einzeln gelisteten Eingaben werden fachlich benötigt und aufgenommen? Für jede: verbindlicher Name, Betrieb/Schlag/Tier/Gruppe/Projekt, Einheit, Zeitbezug, Herkunft/Nachweis und Abgrenzung zu bestehenden App-Feldern. Luna- und Opus-Strukturen sind alternative Vorschläge; keine automatische Umbenennung.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_22-luna-high-20261005/workspace/rules/profile_changes.json:8–11`

```text
      "path": "livestock.o6_22",
      "value_before": null,
      "value_after": {
        "measure": "o6_22",
```

Ursprung: `runs/v2-o6_22-opus-5.5-high-20260928/workspace/rules/profile_changes.json:8–11`

```text
      "path": "farm.applicant",
      "value_before": null,
      "value_after": {
        "legal_form": "enum(natural_person|registered_partnership|legal_person|association)",
```

### o6_22-SOW_CATEGORY

Welche Kategorie und welcher GVE-Faktor gelten für ungedeckte Jungsauen/ältere ungedeckte Sauen? Wie wird tatsächliches Gruppengewicht bei exakt 85 kg eingeordnet?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_22-opus-5.5-high-20260928/workspace/notes/assumptions.md:19–33`

```text
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
```

### o6_22-CURRENT_VS_AVERAGE

Wie werden Stallabteil-ID, aktueller Besatz und Jahresdurchschnitt/Stichtagsbestand getrennt gespeichert? Ein animal_count darf nicht je Maßnahme stillschweigend umgedeutet werden.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_22-opus-5.5-high-20260928/workspace/notes/assumptions.md:7–15`

```text
- Eine `livestock.species_groups[]`-Gruppe mit `species == "pigs"` entspricht einer homogenen
  Tiergruppe in **einem** Stallabteil bzw. Gehege. Die Platzprüfung erfolgt je Gruppe
  (O622-FAT-SPACE-03). `animal_count` ist der aktuelle Abteilbesatz (Platzbedarf,
  Besatzdichte); für GVE/Prämie wird bei `livestock.average_animal_list_submitted == true`
  der `average_animal_count` verwendet, sonst `animal_count` (Stichtag 1. April).
- Neue Felder sind als belegte Vorschläge in `rules/profile_changes.json` erfasst; das
  Canonical Farm Profile wurde nicht verändert. Fehlende Pflichtwerte (z. B. Stallfläche)
  werden als `missing_inputs` ausgegeben statt als erfüllt gewertet. Boolesche
  Verpflichtungsfelder lösen nur bei explizitem `false` einen Befund aus.
```

### o6_22-OUTDOOR_LEGAL

Welche Fläche zählt bei Koppelrotation/Freiland, welche Behördenhöchstgrenze gilt und welche THVO-Gruppenhaltungs-/bauliche Ausnahme ist bestätigt?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_22-opus-5.5-high-20260928/workspace/notes/assumptions.md:54–57`

```text
11. **Sauen-Gruppenhaltung**: `pig_welfare.group_housing` beschreibt die Gruppenhaltung
    im gesetzlich verpflichtenden Zeitfenster. Das Zeitfenster selbst ist über
    `sow_group_housing_required` ausführbar; ob die Übergangsregel (bis 2033) greift,
    hängt von einer baulichen Einschätzung ab, die als Funktionsargument übergeben wird.
```

### o6_22-DOUBLE_COMPOST

Wie wird nennenswerter Pflanzenanteil belegt und ist der gesamte Festmistzuschlag bei paralleler Rinder-/Schweinehaltung doppelt förderbar?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_22-opus-5.5-high-20260928/workspace/notes/assumptions.md:58–65`

```text
12. **Festmistkompostierung „nennenswertes Ausmaß (z. B. 50:50)“**: 50:50 ist nur ein
    Beispiel; als Verstoß gilt ein fehlender Pflanzenanteil, unter 50 % wird nur ein
    Hinweis (`advisories`) ausgegeben. „Zweimal im Abstand von mindestens 14 Tagen“ wird
    als mindestens zwei Umsetztermine mit mindestens einem Paar ≥ 14 Tage Abstand gelesen.
13. **Zuschlag Festmistkompostierung** gilt laut SRL „je GVE in der Maßnahme“; er wird je
    aktiver Kategorie auf deren prämienfähige GVE berechnet. Ob bei gleichzeitiger
    Teilnahme an o6_21 (ebenfalls Festmistzuschlag, gesamter Festmist) eine Doppelzahlung
    ausgeschlossen ist, regeln die Quellen nicht – offen.
```
