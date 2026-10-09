# o6_20: offene Fachentscheidungen

Alle Antworten und App-Zuordnungen bleiben offen. Die Zitate sind Modellnotizen bzw. Prüfbeobachtungen, keine bestätigte Fachauslegung.

### o6_20-INPUT_CONTRACT

Welche der im Diff einzeln gelisteten Eingaben werden fachlich benötigt und aufgenommen? Für jede: verbindlicher Name, Betrieb/Schlag/Tier/Gruppe/Projekt, Einheit, Zeitbezug, Herkunft/Nachweis und Abgrenzung zu bestehenden App-Feldern. Luna- und Opus-Strukturen sind alternative Vorschläge; keine automatische Umbenennung.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_20-luna-high-20261005/workspace/rules/profile_changes.json:8–11`

```text
      "path": "farm.livestock.o6_20",
      "value_after": [
        {
          "category": "string",
```

Ursprung: `runs/v2-o6_20-opus-5.5-high-20260928/workspace/rules/profile_changes.json:8–11`

```text
      "path": "farm.applicant",
      "value_before": null,
      "value_after": {
        "legal_form": "enum(natural_person|registered_partnership|legal_person|association_of_persons)",
```

### o6_20-HALVED_SURCHARGE

Wird bei gekoppelter Almstützung nur die Basisprämie oder auch der 150-Tage-Zuschlag halbiert?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_20-opus-5.5-high-20260928/workspace/notes/assumptions.md:26–28`

```text
4. **Halbierung bei gekoppelter Stützung**: Das Informationsblatt halbiert die „Basisprämie“, die SRL „die Prämie für die
   betroffenen Tiere“. Umgesetzt: nur die Basisprämie der betroffenen RGVE wird halbiert, der 150-Tage-Zuschlag nicht.
   Offene Frage, ob der Zuschlag ebenfalls halbiert wird.
```

### o6_20-GRAZING_TIMELINE

Wie werden Weidetage, Teilaufenthalte, Hinderungstage und geburtsbedingte Stalltage nachgewiesen? Welcher Zeitraum trägt den Durchschnittsbestand?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_20-opus-5.5-high-20260928/workspace/notes/assumptions.md:19–38`

```text
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
```

### o6_20-DROUGHT_EVIDENCE

Wie wird wesentlicher Tagesanteil/Grundfutterbedarf fachlich belegt und welche konkrete höhere-Gewalt-Anerkennung verändert welche Pflicht?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_20-opus-5.5-high-20260928/workspace/notes/assumptions.md:50–56`

```text
- **„Unmittelbar“** (Abmeldung von Rindern): nicht quantifiziert. Eine fehlende Meldung ist ein Verstoß; eine Meldung nach dem
  Tag des Bekanntwerdens erzeugt nur einen Prüfhinweis (`review_items`).
- **Grundfutterbedarf / wesentlicher Teil des Tages**: nicht quantifiziert (keine Mindeststundenzahl). Eingabe als Boolean.
- **Trockenheit 2026**: Der Hinweis sagt nur, dass die Situation bei Vor-Ort-Kontrollen „berücksichtigt“ wird. Für 2026 wird ein
  Grundfutter-Verstoß daher zu einem Prüfhinweis statt zu einem automatischen Verstoß; es gibt keinen pauschalen Verzicht.
- **Höhere Gewalt**: Eine anerkannte höhere Gewalt (`force_majeure_recognized`) unterdrückt nur Verstöße bei Weidetagen und beim
  150-Tage-Zuschlag, nicht bei Dokumentations- oder Meldepflichten. Die Voraussetzungen nach § 6 GSP-AV liegen außerhalb der Quellen.
```
