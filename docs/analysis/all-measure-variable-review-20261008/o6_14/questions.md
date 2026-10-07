# o6_14: offene Fachentscheidungen

Alle Antworten und App-Zuordnungen bleiben offen. Die Zitate sind Modellnotizen bzw. Prüfbeobachtungen, keine bestätigte Fachauslegung.

### o6_14-INPUT_CONTRACT

Welche der im Diff einzeln gelisteten Eingaben werden fachlich benötigt und aufgenommen? Für jede: verbindlicher Name, Betrieb/Schlag/Tier/Gruppe/Projekt, Einheit, Zeitbezug, Herkunft/Nachweis und Abgrenzung zu bestehenden App-Feldern. Luna- und Opus-Strukturen sind alternative Vorschläge; keine automatische Umbenennung.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_14-luna-high-20261004/workspace/rules/profile_changes.json:8–11`

```text
      "path": "land.alpine_pastures[].alm_id",
      "value_after": "string",
      "rationale": "Die Alm-ID fehlt im Canonical Profile und verbindet Almfläche, Bewegungen und Nachweise.",
      "rule_ids": [
```

Ursprung: `runs/v2-o6_14-opus-5.5-high-20260926/workspace/rules/profile_changes.json:8–11`

```text
      "path": "alpine_farming",
      "value_before": null,
      "value_after": {
        "is_alm_manager": "boolean",
```

### o6_14-RGVE_DAYS

Welche Tiere zählen zur 3-RGVE-Mindestteilnahme? Wie werden tatsächliche/anerkannte Tage, Meldedatum und Wechsel bzw. Unterbrechungen je Alm gespeichert?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_14-opus-5.5-high-20260926/workspace/notes/assumptions.md:7–20`

```text
- **A-01 RGVE für die Mindestteilnahme (3,00 RGVE).** Gezählt wird die Summe der
  RGVE aller prämienfähigen Tiere (≥ 60 angerechnete Alpungstage, Auftrieb bis
  15.07., Anwesenheitsregel erfüllt), ohne anteilige Aufteilung auf Almen, weil
  die Mindestteilnahme betriebsbezogen gilt (`total_participating_rgve`). Die
  Quellen legen nicht fest, ob auch nicht prämienfähige Tiere zählen.
- **A-02 Tatsächliche und angerechnete Tage.** Für Viehbesatz,
  Mindestbestoßungsdauer je Alm und anteilige Aufteilung beim Viehbesatz werden
  die tatsächlichen Auf-/Abtriebsdaten verwendet. Für die Mindestweidedauer je
  Tier und die Prämien-RGVE werden die nach Meldedatum angerechneten Tage
  verwendet (max. 7 bzw. 14 Tage vor der Meldung). Fehlt ein Meldedatum, werden
  0 Tage angerechnet.
- **A-03 Folge einer Alm mit < 60 Bestoßungstagen.** Die Alm erhält keine
  Prämie (prämienfähige Fläche 0) und wird zusätzlich als Verstoß ausgewiesen.
  Der Katalog nennt die genaue Sanktion nicht.
```

### o6_14-NATA_CODES

Welche NATA-Auflagencodes sind je Projektfläche additiv oder ausschließend? Welche Fläche und welche Jahresversion bilden die Zuschlagsbasis?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_14-opus-5.5-high-20260926/workspace/notes/assumptions.md:37–41`

```text
- **A-08 NATA-Auflagencodes (Anhang E).** Der Satz des jeweiligen Codes wird auf
  die gesamte prämienfähige Almweidefläche angewendet, weil die Aufwandsstufe als
  Anteil der Almweidefläche definiert ist. Für 2023 enthalten die Quellen keine
  Sätze der Codes (Sätze „gelten ab 01.01.2024“), daher gibt es 2023 keinen
  Code-Zuschlag.
```

### o6_14-ACCESS_MODULATION

Wie werden vergleichbare Auftriebszeiten, Erschließungsstufen und Modulation über mehrere Almen gewichtet? Wie wird der Widerspruch im 230-ha-Beispiel aufgelöst?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_14-opus-5.5-high-20260926/workspace/notes/assumptions.md:28–36`

```text
- **A-06 Mittelung des Erschließungszustands.** Das Mittel wird nach Alptagen
  (RGVE × Tage) gewichtet und auf eine ganze Stufe gerundet. Das Beispiel im
  Merkblatt (3.750/4.800 → Stufe 2) bestätigt das. Ob die Auftriebszeiten
  „vergleichbar“ sind, wird als Eingabe (`access_times_comparable`) erwartet.
- **A-07 Modulationsbasis.** Basis ist die Summe der prämienfähigen Hektar aller
  Almen, also je Alm min(Almweidefläche, RGVE). Das AMA-Beispiel „230 ha,
  250 RGVE → 98,66 %“ lässt sich damit rechnerisch nicht nachvollziehen:
  (200 + 30 × 0,9) / 230 = 98,70 %. Die Tests verwenden den gerechneten Wert,
  das Beispiel mit 220 ha (99,09 %) stimmt überein.
```

### o6_14-DROUGHT_MINIMUM

Kann anerkannte höhere Gewalt 2026 die 60-Tage-Bedingung ändern? Welcher ausdrücklich anerkannte Fall ist nachzuweisen?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_14-opus-5.5-high-20260926/workspace/notes/assumptions.md:76–86`

```text
- Die Mindestbestoßungsdauer ist als „Kalendertage“ (SRL) bzw. „Tage“
  (Merkblatt) formuliert. Es wird dieselbe Zählweise angenommen: Auftriebstag
  zählt, Abtriebstag nicht.
- Unklar ist, wie Unterbrechungszeiten dokumentiert werden (Heimstall,
  Krankheit). Das Modell erwartet getrennte Aufenthalte (`stays`).
- Die Sanktionshöhe konkreter Verstöße (Stufe im Kürzungsschema) ist in den
  Quellen nicht tabelliert. Umgesetzt sind nur die Stufen und der Ausschluss nach
  zweimaliger 100-%-Kürzung.
- Es ist offen, ob die Dürre-Regelungen 2026 zur höheren Gewalt eine Prämie auch
  bei Unterschreiten der 60 Tage ermöglichen. Das Modell weist nur die
  Möglichkeit eines Ansuchens aus.
```
