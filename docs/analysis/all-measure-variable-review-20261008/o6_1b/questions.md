# o6_1b: offene Fachentscheidungen

Alle Antworten und App-Zuordnungen bleiben offen. Die Zitate sind Modellnotizen bzw. Prüfbeobachtungen, keine bestätigte Fachauslegung.

### o6_1b-INPUT_CONTRACT

Welche der im Diff einzeln gelisteten Eingaben werden fachlich benötigt und aufgenommen? Für jede: verbindlicher Name, Betrieb/Schlag/Tier/Gruppe/Projekt, Einheit, Zeitbezug, Herkunft/Nachweis und Abgrenzung zu bestehenden App-Feldern. Luna- und Opus-Strukturen sind alternative Vorschläge; keine automatische Umbenennung.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_1b-luna-high-20260930/workspace/rules/profile_changes.json:6–9`

```text
    {"action":"add","path":"year","value_after":2026,"rationale":"Das Antragsjahr wird für jahresabhängige o6_1b-Regeln benötigt.","rule_ids":["o6_1b_psm_reporting_2026","o6_1b_transaction_costs","o6_1b_2026_drought_arable"],"source_reference_ids":["o6_1b_p07_psm_2026"]},
    {"action":"add","path":"first_participation_year","value_after":2025,"rationale":"Das erste Teilnahmejahr wird für die Betriebsgrößenregel benötigt.","rule_ids":["o6_1b_contract_until_2028"],"source_reference_ids":["o6_1b_p03_contract"]},
    {"action":"add","path":"contract.start_year","value_after":2025,"rationale":"Das Vertragsbeginnjahr fehlt im Ausgangsprofil.","rule_ids":["o6_1b_contract_until_2028"],"source_reference_ids":["o6_1b_p03_contract"]},
    {"action":"add","path":"contract.end_date","value_after":"2028-12-31","rationale":"Das Vertragsende fehlt im Ausgangsprofil.","rule_ids":["o6_1b_contract_until_2028"],"source_reference_ids":["o6_1b_p03_contract"]},
```

Ursprung: `runs/v2-o6_1b-opus-5.5-high-20260925/workspace/rules/profile_changes.json:8–11`

```text
      "path": "farm.certifications.organic.registered_with_food_authority",
      "value_before": null,
      "value_after": "boolean",
      "rationale": "Registrierung als Bio-Betrieb bei der Lebensmittelbehörde ist Zugangsvoraussetzung (Kap. 3.4).",
```

### o6_1b-BIO_SCOPE

Welche Kulturbereiche, Teilbetriebs- und Bio-Kontrollnachweise müssen getrennt erfasst werden? Darf ein einzelnes Boolean die getrennte Lagerung aller Betriebsmittel bestätigen?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_1b-opus-5.5-high-20260925/workspace/notes/assumptions.md:103–105`

```text
- **A-14 Teilbetrieb – getrennte Lagerung.** Die Sonderrichtlinie nennt Pflanzenschutz-, Düngemittel
  und Saatgut, das Informationsblatt zusätzlich Futtermittel. Die Eingabe ist ein einzelnes Boolean,
  das alle Betriebsmittel abdeckt.
```

### o6_1b-DIV_LIMITS

Welche DIV-Flächen zählen für Quote, Zuschläge, 75/25-Regel und Kreislaufwirtschaft? Wie werden konkurrierende Zuschläge bzw. LSE gereiht?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_1b-opus-5.5-high-20260925/workspace/notes/assumptions.md:61–86`

```text
- **A-02 Zuschlag „je angefangene 3 ha“ (8.3/9.3).** Gezählt werden alle DIV-codierten Schläge über
  0,05 ha, einschließlich der aus anderen Maßnahmen angerechneten. Die Quellen schließen diese nicht
  ausdrücklich aus. Der Zuschlag wird nur auf Biodiversitätsflächen gewährt, die über die Bio-Maßnahme
  prämienfähig sind, und ist auf 20 % der Fläche begrenzt.
- **A-03 75/25-%-Regel mit Projektbestätigung (6.1.4.2).** Laut Beispiel belastet eine vor dem
  1. August genutzte NAT/EBW-Fläche den 25-%-Anteil, ist wegen des Vorrangs der Projektbestätigung aber
  selbst kein Verstoß. Ein Verstoß (DA-018) liegt nur vor, wenn zusätzlich reguläre DIV-Flächen früh
  genutzt werden und der gesamte Frühnutzungsanteil 25 % übersteigt. Flächen mit OPBIO-Codierung
  (Dürre 2026) und mit der Ausnahme für invasive Arten zählen nicht mit.
- **A-04 Grünbrache in der Basismodulprämie (11.2).** Die Grenze von 20 % der Ackerfläche gilt für
  DIV-codierte Grünbrachen. Grünbrachen ohne DIV sind nicht förderfähig (ATB 5.5.1) und erhalten keine
  Prämie.
- **A-05 Altgras-Zuschlag DIVAGF.** Er steht in der Tabelle im Block „Zuschläge für
  Biodiversitätsflächen (jeweils bis max. 20 %)“ und ist daher ebenfalls auf 20 % der gemähten
  Grünlandfläche begrenzt.
- **A-06 Förderwürdige Kulturen, 15-%-Schwelle.** Die „über 7 % hinausgehenden Biodiversitätsflächen“
  werden aus der gesamten Acker-DIV-Fläche einschließlich der NAT-angerechneten Flächen berechnet
  (Beispiel 8.6: 10 % + 3 % → 6 %). Die 40-%-Kappung gilt nur für die förderwürdigen Kulturflächen.
  Zweitkulturen erhalten den höheren Satz; die Fläche zählt nur einmal.
- **A-07 Kappung der Landschaftselemente (80 je ha Feldstück).** Die Quellen legen keine Reihenfolge
  fest. Streuobstbäume (höherer Satz) werden vorrangig berücksichtigt, danach andere Elemente. Die
  Kappung verwendet `floor(80 × Feldstücksfläche)`.
- **A-08 Kreislaufwirtschaft.** Für Acker wird „nicht-tierhaltend oder tierhaltend < 1,4 RGVE/ha“ als
  Viehbesatz < 1,40 RGVE/ha Futterfläche umgesetzt. Beim Grünland zählen im Zähler alle anrechenbaren
  Grünland-DIV (auch NAT/EBW/N2), artenreiches Grünland aus o6_17 und – bei Teilnahme an o6_17 –
  einmähdige Wiesen und Streuwiesen. Der Nenner ist das gemähte Grünland ohne Bergmähder.
```

### o6_1b-DIV_TIMING

Gelten die DIVSZ-Vorverlegungen für beide Termine? Welches Datum startet die DIVNFZ-Ruhezeit; darf fehlender Ballenabtransport durch das erste Nutzungsdatum ersetzt werden?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_1b-opus-5.5-high-20260925/workspace/notes/assumptions.md:87–97`

```text
- **A-09 DIVSZ-Termine.** Die phänologische Vorverlegung (max. 10 Tage) und die Vorverlegung 2026 um
  14 Tage (mit OPBIO) werden auf den frühesten Termin (15.6.) und auf den „jedenfalls“-Termin (15.7.)
  angewendet. Der Termin der zweiten Mahd vergleichbarer Schläge bleibt die untere Grenze
  (Beispiel Tirol/Vorarlberg).
- **A-10 DIVNFZ-Ruhezeitraum.** Der Zeitraum beginnt am Tag nach `first_use_completed_date`
  (Ballenabtransport bzw. Weidepflege). Fehlt dieses Datum, wird das Datum der ersten Nutzung
  verwendet. Nutzung, Befahren und Düngung sind am 64. Tag wieder zulässig (Beispiel 24.6. → 27.8.).
- **A-11 Pheromonfallen – Aufbewahrungsfrist.** Das Informationsblatt nennt den 30. September, die
  Sonderrichtlinie das „Ende der Vegetationsperiode“. In `data/` ist der Wert des Informationsblatts
  (30.9.) hinterlegt; geprüft wird nur das Vorhandensein der Aufzeichnungen.
- **A-12 Unter bzw. bis 10 ha Ackerfläche (Ersatz über Grünland).** Das Informationsblatt schreibt
```

### o6_1b-SOURCE_BOUNDARIES

Welche Lesart gilt bei genau 10 ha Acker sowie bei Pheromonfallen-Aufbewahrung? Gilt die Phänologie-Kombinationspflicht auch für Phänoflex?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_1b-opus-5.5-high-20260925/workspace/notes/assumptions.md:57–60`

```text
- **A-01 Monitoring Phänoflex / Schnittzeit nach Phänologie (Kap. 7.5).** Im Informationsblatt fehlt
  vor „Schnittzeit nach Phänologie“ der Aufzählungspunkt, sodass die Kombinationsverpflichtung
  (GL06/GL15/GL25) auch Phänoflex zuzuordnen sein könnte. Die Sonderrichtlinie (lit. d) ordnet sie nur
  „Schnittzeit nach Phänologie“ zu; so ist es umgesetzt. Phänoflex hat keine Kombinationspflicht.
```

Ursprung: `runs/v2-o6_1b-opus-5.5-high-20260925/workspace/notes/assumptions.md:94–102`

```text
- **A-11 Pheromonfallen – Aufbewahrungsfrist.** Das Informationsblatt nennt den 30. September, die
  Sonderrichtlinie das „Ende der Vegetationsperiode“. In `data/` ist der Wert des Informationsblatts
  (30.9.) hinterlegt; geprüft wird nur das Vorhandensein der Aufzeichnungen.
- **A-12 Unter bzw. bis 10 ha Ackerfläche (Ersatz über Grünland).** Das Informationsblatt schreibt
  „unter 10,00 ha“, die Sonderrichtlinie „bis 10 ha“. Umgesetzt ist die Formulierung des aktuelleren
  Informationsblatts (`< 10`).
- **A-13 Querverweis „Punkt 2.1.9-5“ in der Sonderrichtlinie (Ersatz über Grünland).** Er wird als
  Verweis auf die Bewirtschaftungsvarianten für Grünland-Biodiversitätsflächen (Kap. 6.2.4 des
  Informationsblatts) gelesen.
```
