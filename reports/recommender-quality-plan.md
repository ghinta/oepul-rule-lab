# Plan: Recommender-Qualität mit den Rule-Lab-Ergebnissen verbessern

Stand: 2. Oktober 2026 · Bezug: `ghinta/oepul-recommender` bei `411586e`,
`ghinta/oepul-rule-lab` bei `b6e8917` (26 Opus-5.5- und 26 Terra-Runs)

## Kurzfassung

- Der Recommender trifft heute nur für 3 von 26 Maßnahmen belastbare
  Entscheidungen; 15 Maßnahmen sind geparkt und liefern fast immer
  `missing_data`.
- Die Runs zeigen den Hauptgrund: Die geparkten Maßnahmen fragen nach
  Nachweisen über die Bewirtschaftung (PSM-Einsatz, Schnitttermine, N-Bilanz),
  obwohl für eine Empfehlung der Zugang entscheidet. Der Zugang ist für viele
  dieser Maßnahmen aus AMA-Daten prüfbar. Mindestens fünf Variablen haben gar
  keine normative Grundlage.
- Gewichtet nach Maßnahmen sind 54 % der Zugangs-Datenbedarfe (Klasse A)
  direkt aus dem AMA-Auszug ableitbar, weitere 29 % teilweise.
- Plan in fünf Phasen: Referenzkatalog und Quellen, Profil v2, AMA-Ausbau,
  Regelübernahme mit Hochstufung, Qualitätsmessung. Ziel: höchstens 5 statt
  15 geparkte Maßnahmen, alle Belege auf Quellenstand 2026, messbar halbierte
  `missing_data`-Quote.

## 1. Ausgangslage im Recommender

| Bereich | Stand | Beleg |
| --- | --- | --- |
| Entscheidungslogik | 26 Maßnahmen in Rego; Reifegrad A: 3 (o6_1a, o6_8, o6_17), B: 8, C: 15 | `docs/mapping/20-dictionary/measure-readiness-classification-v1.csv` |
| Geparkte Maßnahmen | 15 Maßnahmen über den gemeinsamen Helfer `c_measure_result`, der immer `missing_data` liefert | `backend/policy/oepul_measures.rego` |
| Quellenbindung | DecisionTrace bindet alle 26 Maßnahmen an die Informationsblätter 2025-10; die Bekanntmachungen 2026 fehlen | `backend/app/review/adapters/oepul/` |
| Kanonisches Profil | 47 gemappte Variablen, davon 20 „unresolved“ | `docs/mapping/20-dictionary/unresolved-variables-v1.md` |
| Daten | AMA-Auszug MFA 2023 (`D619_23`, 13 Tabellen), 250 Bestandsbetriebe | `backend/app/ama_raw/` |
| Fachfeedback | Domainreview 03.08.2026 wünscht u. a. Begrünungsvarianten (P-05), 150-Tage-Indikatoren (P-10), Ausbringungsmengen je Verfahren (P-11), Alpungstage (P-12) | `docs/changes/review-ui-ergonomics/domain-expert-review/` |

## 2. Was die Runs für den Recommender zeigen

### 2.1 Geparkte Maßnahmen fragen nach den falschen Variablen

Für eine Empfehlung zählt, ob ein Betrieb teilnehmen kann (Zugang) und welche
Verpflichtungen er dann übernimmt (Auflagen). Die heutigen
`c_measure_result`-Pflichtfelder sind fast ausschließlich Auflagen-Nachweise.
Die Runs trennen beides und belegen den Zugang mit wörtlichen Zitaten.

| Maßnahme | Recommender fordert heute | Laut Runs maßgeblich für den Zugang | AMA-Quelle | Ziel |
| --- | --- | --- | --- | --- |
| o6_2 | `psm_used`, `nitrogen_input_kg_per_ha`, `nutrient_balance_complete` | gleichzeitige UBB-Teilnahme (Kombinationspflicht), kein Bio außer Teilbetrieb; Verzicht auf N-Mineraldünger und flächige PSM, 170 kg N/ha aus Tierhaltung und Weiterbildung sind Auflagen | `ST_OEPUL_MANA`, `ST_FSL`, `ST_MFA_Angaben` | A + Auflagen |
| o6_3 | `cutting_dates`, `management_events` | gemähte Grünland- und Ackerfutterflächen; Silageverzicht am ganzen Betrieb ist Auflage; Option Verzicht Mähaufbereiter | `ST_FSL`, `ST_MFA_Angaben` | A + Auflagen |
| o6_4 | `cutting_dates`, `oepul_codes` | Bergmähder über der Dauersiedlungsgrenze (BM-Codes); Mahd mindestens jedes zweite Jahr, höchstens einmal jährlich, sind Auflagen | `ST_FSL` (Codes), `ST_MFA_Angaben` (Seehöhe) | A für Bestand, sonst B |
| o6_9 | `incorporation_time_hours`, `ammonia_reduction_percent` | Prämie nach m³ je Technik laut MFA-Angaben, höchstens 50 m³/ha düngungswürdige Fläche bzw. 20 m³ je Rinder-GVE; keine Regel zu Einarbeitung oder NH3 | `ST_MFA_Angaben`, `ST_FSL`, `ST_RINDER` | A |
| o6_11 | `psm_used`, `psm_applications` | Wein-, Obst- und Hopfenflächen nach abschließender Liste mit Ausschlüssen; Herbizidverzicht ist Auflage | `ST_FSL` | A + Auflagen |
| o6_12 | `psm_used`, `psm_applications` | wie o6_11, Insektizidverzicht als Auflage; 2026 rückzahlungsfreier Ausstieg wegen Rebzikade | `ST_FSL`, `ST_OEPUL_MANA` | A + Auflagen |
| o6_13 | `is_protected_cultivation`, `beneficials` | mindestens ein Gewächshaus oder Folientunnel; jährlicher Nützlingseinsatz (Code NUE) | `ST_FSL` (Schlagnutzungsart, Code) | A |
| o6_15 | `behirtung_days`, `alpine_pasture_area_ha` | mindestens 3,00 behirtete RGVE; Kombinationspflicht mit Almbewirtschaftung | `ST_AAL*`, `ST_OEPUL_MANA` | A |
| o6_16 | `nitrogen_input_kg_per_ha`, `nutrient_balance_complete` | mindestens 2,00 ha Acker in der Kulisse nach SRL-Anhang G, abgegrenzt über 1.566 Katastralgemeinden; Bodenproben, Weiterbildung, N-Aufzeichnungen sind Auflagen | `ST_FSL` (KG-Nummer, Ackerfläche) | A + Auflagen |
| o6_18 | `cutting_dates`, `psm_used`, `nitrogen_input_kg_per_ha`, `project_confirmation_codes` | Projektbestätigung der Naturschutzbehörde mit NAT-Codes; Auflagen je Projektbestätigung | `ST_FSL` (NAT-Codes, nur Bestand) | B |
| o6_20 | `weide_hours_per_day`, `water_availability`, `livestock_events` | teilnahmefähige Tierkategorien, 120 Weidetage (Zuschlag 150), Tränke und Unterstand; „wesentlicher Teil des Tages“ ohne Mindeststunden | `ST_TW`, `ST_TIERLISTE` | A + Auflagen |
| o6_21 | `stall_area_m2`, `floor_type`, `bedding_type`, `daylight_percentage` | mindestens 2,00 RGVE; Tiergesundheitsdienst ab 10 RGVE; Qplus Rind für weibliche Rinder; Ausschluss von Milchlieferbetrieben für weibliche Rinder ½–2 Jahre; Gruppenhaltung, planbefestigte eingestreute Liegefläche mindestens 40 % | `ST_TIERLISTE`, `ST_RINDER`, `ST_TW` | B (Zugang teils A) |
| o6_22 | `stall_area_m2`, `floor_type`, `bedding_type` | mindestens 2,00 GVE Schweine; Tiergesundheitsdienst ab 10 GVE; Gruppenhaltung, planbefestigte eingestreute Liegefläche; Zuschläge | `ST_TIERLISTE`, `ST_TW` | B |
| o6_23 | `is_protected_area`, `project_confirmation_codes`, `cutting_dates` | Flächen in Natura 2000 oder gleichgestellten Gebieten mit Projektbestätigung und Codes | `ST_FSL` (Codes); Kulisse über GIS | B |
| o6_24 | `nitrogen_input_kg_per_ha`, `nutrient_balance_complete` | mindestens 2,00 ha Acker in der Kulisse des Grundwasserschutzprogramms Graz bis Bad Radkersburg; Düngeklassen, Betriebsbuch | `ST_FSL`; Kulisse über GIS | C bis GIS vorliegt |

### 2.2 Variablen ohne normative Grundlage

Keine Regel in den 26 Opus-Runs stützt diese Recommender-Variablen. Sie sollten
aus dem Profil und der Unresolved-Liste entfernt und durch belegte Angaben
ersetzt werden.

| Variable | Maßnahme | Befund | Ersatz |
| --- | --- | --- | --- |
| `weide_hours_per_day` | o6_20 | Beweidung über einen „wesentlichen Teil des Tages“, ausdrücklich ohne Mindestdauer (`o6_20.obligation.substantial_part_of_day`) | Weidetage je Kategorie (120/150) |
| `distance_pasture_to_farm` | o6_20 | keine Regel | entfällt |
| `daylight_percentage` | o6_21, o6_22 | keine Regel | Liegefläche, Perforation, Einstreu, Gruppenhaltung |
| `incorporation_time_hours` | o6_9 | keine Regel | m³ je Ausbringungstechnik |
| `ammonia_reduction_percent`, `ammonia_reduction_technology` | o6_9 | keine Regel | m³ je Ausbringungstechnik, Separation |

### 2.3 Allgemeine Zugangsbedingungen fehlen

Opus erfasst die maßnahmenübergreifenden Bedingungen der Teilnahmebedingungen
und der SRL in allen 26 Maßnahmen, etwa aktive:r Landwirt:in, Bewirtschaftung
im eigenen Namen, Lage der Flächen und Tiere in Österreich, Mindestfläche im
ersten ÖPUL-Jahr (0,50 ha geschützter Anbau oder 1,50 ha landwirtschaftliche
Fläche) und den Ausschluss von Gebietskörperschaften und Einrichtungen mit mehr
als 25 % öffentlicher Beteiligung (mit maßnahmenspezifischen Ausnahmen). Im
Recommender gibt es dafür keine gemeinsame Prüfung. 42 % der Opus-Belege
stammen aus diesen allgemeinen Teilen; sie gehören in ein gemeinsames Modul.

### 2.4 Quellenstand 2026 und prüfbare Belege

Zehn Informationsblätter liegen in einer Fassung 2026 vor (o6_1a, o6_1b, o6_2,
o6_8, o6_9, o6_11, o6_12, o6_14, o6_15, o6_16), dazu vier Bekanntmachungen
(Dürre 2026, Rebzikade). Die Runs liefern für jede Regel Dokument, Seite,
Abschnitt und ein maschinell geprüftes wörtliches Zitat (`verify-grounding`).
Diese Belege können die DecisionTrace-Quellenangaben direkt ersetzen.

### 2.5 Datenverfügbarkeit im AMA-Auszug

| Klasse | Konzepte ja / teilweise / nein | Bedarfe (Maßnahmen, Opus) ja / teilweise / nein |
| --- | --- | --- |
| A · Zugang und Empfehlung | 11 / 8 / 3 | 177 / 96 / 57 |
| B · Bewirtschaftung | 0 / 6 / 7 | 0 / 46 / 54 |
| C · Abwicklung | 0 / 4 / 2 | 0 / 82 / 39 |

Für Klasse A fehlen im Auszug nur Rechtsform, öffentliche Beteiligung und
Programmteilnahmen (Tiergesundheitsdienst, Qplus). Diese drei Angaben sind
einfache Betriebsangaben und können einmalig erfasst werden. Die
Expert:innen-Wünsche P-05, P-10, P-11 und P-12 sind genau Variablen, die die
Regeln brauchen und die der Auszug bereits enthält.

## 3. Ziele und Kennzahlen

| Kennzahl | Heute | Ziel |
| --- | --- | --- |
| Maßnahmen mit belastbarer Zugangsentscheidung (Reifegrad A) | 3 | mindestens 15 |
| Geparkte Maßnahmen (Reifegrad C) | 15 | höchstens 5 |
| Variablen ohne normative Grundlage | mindestens 5 | 0 |
| Klasse-A-Bedarfe aus AMA befüllt | nicht gemessen | mindestens 80 % |
| Maßnahmen mit Belegen aus dem Quellenstand 2026 | 0 von 26 | 26 von 26 |
| `missing_data`-Quote über die 250 Bestandsbetriebe | Baseline messen | halbieren |
| Übereinstimmung mit Golden Farms | keine Golden Farms | mindestens 90 % |
| Ungeklärte Abweichungen Recommender gegen Opus-Regeln | nicht gemessen | 0 (jede triagiert) |

## 4. Arbeitspakete

### Phase 0: Referenzkatalog festlegen und Quellenlücken schließen

- Opus-Runs als Referenzkatalog markieren; Terra-Runs als unabhängige
  Gegenprobe behalten.
- Konzeptkatalog (`config/analysis/profile-concepts-v1.json`) mit
  Domänenexpert:innen bestätigen: Klasse A/B/C und AMA-Status je Konzept.
- Quellenpaket ergänzen: GSP-AV (§§ 6, 16, 25, 31, 34, 42–47) sowie die
  AMA-News vom 25.08.2026 (Aufzeichnungspflichten o6_16) und 02.09.2026
  (Meldepflichten tierbezogener Maßnahmen). Danach betroffene Maßnahmen gezielt
  nachziehen: o6_1c, o6_4, o6_12, o6_16, o6_17, o6_21, o6_22, o6_24.

Abnahme: bestätigte Konzeptliste; aktualisiertes Quellenmanifest; neue Runs im
Run Explorer.

### Phase 1: Kanonisches Profil v2

- Ein Schema statt 26 maßnahmeneigener Varianten, begrenzt auf Klasse A und
  ausgewählte B-Angaben: `farm.applicant`, `farm.oepul.participations[]`,
  `land.field_pieces[]`, `land.parcels[].oepul` (Codes, Lage, GLÖZ,
  Zahlungen), `land.landscape_elements[]`, `livestock.animals[]`,
  `alpine_farming`.
- Abbildungstabelle Run-Pfad → Profil-v2-Pfad für alle 3.439 Vorschläge,
  vorbefüllt über die Konzepte, danach fachlich geprüft.
- Platzhalter-Variablen aus Abschnitt 2.2 entfernen.
- Recommender: `backend/policy/farm_profile_schema_blueprint.json`, Registries
  und Dependency-CSVs versioniert auf v2 heben.

Abnahme: Profil v2 in beiden Repos; Mapping-CSV; keine Rego-Regel liest einen
Pfad außerhalb von v2.

### Phase 2: AMA-Daten ausschöpfen (`canonical_builder.py`)

| AMA-Tabelle | Neue Ableitung | Wirkt auf |
| --- | --- | --- |
| `ST_OEPUL_MANA` | Teilnahmen mit Code, Antragsdatum, Verpflichtungsbeginn, Abmeldedatum, Status; erstes Teilnahmejahr | alle 26 Maßnahmen, Kombinationen |
| `ST_FSL` | alle Schlag-Codes, Begrünungsvariante, geschützter Anbau, GLÖZ- und LSE-Elemente, KG-Nummer | o6_1a–c, o6_4, o6_6–o6_8, o6_11–o6_13, o6_16, o6_18 |
| `ST_MFA_Angaben` | aktive:r Landwirt:in, Gülle-m³ je Technik und Separation, Verzicht Mähaufbereiter, Seehöhe, Bienenstöcke, Pferdehaltung | o6_1b, o6_3, o6_4, o6_9, allgemein |
| `ST_TW`, `ST_TW_SCHA_ZI` | Weide- und Stall-Ohrmarken, 150-Weidetage-Merkmale | o6_20, o6_21, o6_22 |
| `ST_GN` | Einzeltiere gefährdeter Rassen | o6_5 |
| `ST_AAL*` | Almen, Alpungstage, Behirtung, Hirt:innen, Herdenschutzhunde | o6_14, o6_15 |
| `ST_TIERLISTE`, `ST_RINDER` | Tierkategorien mit RGVE-Schlüssel | o6_1a, o6_1b, o6_2, o6_3, o6_17, o6_21, o6_22 |

Zusätzlich: KG → Gemeinde, Bezirk, Bundesland (für Dürrekulisse und
Landes-Top-ups); mehrjährigen Auszug (MFA 2024–2026) für Flächenhistorie und
Vorjahresnutzung anfragen; GIS-Verschneidung (Nationalpark, Natura 2000,
WRRL-Kulisse) als späteren eigenen Schritt planen.

Abnahme: Anteil der Klasse-A-Bedarfe, die für die 250 Bestandsbetriebe
automatisch befüllt sind, gemessen und dokumentiert.

### Phase 3: Regeln übernehmen und Maßnahmen hochstufen

- Zugangs-, Kombinations-, Options- und Prämienregeln je Maßnahme aus den
  Opus-Runs auf Profil v2 umschreiben; bei Abweichung zu Terra fachlich
  entscheiden.
- Allgemeine Regeln (Teilnahmebedingungen, SRL-Allgemeinteil) einmal als
  gemeinsames Modul.
- Auflagen (Klasse B) nicht abfragen, sondern als Liste „Was ist zu tun?“ mit
  Beleg ausgeben.
- DecisionTrace auf die Fassungen 2026 und die Belege aus `citations.json`
  umstellen; Bekanntmachungen 2026 als zeitlich begrenzte Ausnahmen führen.
- Kombinationsregeln (Opus: 103 Regeln, Anhang L als Daten) mit
  `data/oepul/kombinationstabelle_2023.csv` abgleichen.

Reihenfolge nach Hebel:

| Welle | Maßnahmen | Begründung |
| --- | --- | --- |
| 1 | o6_9, o6_13, o6_14, o6_15, o6_16, o6_20, o6_5 (Bestand) | Zugang weitgehend aus AMA prüfbar |
| 2 | o6_2, o6_3, o6_4, o6_11, o6_12 | Zugang über Flächen und Teilnahmen; Verzicht als Auflage |
| 3 | o6_21, o6_22, o6_18, o6_19 | Haltungs- und Projektangaben als Expert:innen-Eingabe |
| 4 | o6_23, o6_24 | brauchen GIS-Kulissen |

Abnahme je Maßnahme: Rego mit Tests, DecisionTrace mit 2026-Belegen,
Reifegrad im Readiness-CSV angehoben.

### Phase 4: Qualität messen

- Differenztest: Recommender-, Opus- und Terra-Rego auf denselben, über das
  Mapping übersetzten Profilen auswerten; jede Abweichung ist ein Prüffall.
- Die 2.182 generierten Opus-Tests nach dem Mapping als Regressionstests
  übernehmen.
- Golden Farms mit Expert:innen (`ghinta/oepul-recommender-thesis#1`): je
  Maßnahme 3–5 anonymisierte Fälle mit erwarteter Entscheidung und Begründung.
- Kennzahlen aus Abschnitt 3 vor und nach jeder Welle über die 250
  Bestandsbetriebe messen.
- Für Thesis-Phase C (#12–#14) liefert der Rule-Lab-Vergleich die erste
  Modell- und Variantenmessung (Opus gegen Terra).

## 5. Risiken und offene Entscheidungen

- **Profil v2 ist ein Vertragswechsel.** DecisionTrace, Registries und
  Szenarioeingaben müssen versioniert migriert werden.
- **Datenzugang:** Ein mehrjähriger AMA-Auszug und GIS-Kulissen sind nicht
  im Repository und müssen angefragt werden.
- **Kein Goldstandard:** Die Runs sind quellengebunden, aber fachlich nicht
  abgenommen. Übernahme nur mit Expert:innen-Prüfung.
- **Umfang:** Klasse C (Abwicklung) bewusst außerhalb des Empfehlungsprofils
  halten, sonst wächst der Erfassungsaufwand stark.

## 6. Nächste Schritte

1. Konzeptkatalog mit Expert:innen durchgehen (eine Sitzung).
2. Quellenpaket um GSP-AV und die zwei AMA-News ergänzen, betroffene Runs
   nachziehen.
3. Profil-v2-Entwurf (Klasse A) und Mapping-CSV im Rule Lab erzeugen.
4. Im Recommender `ST_OEPUL_MANA`, alle `ST_FSL`-Codes und `ST_MFA_Angaben`
   in den Canonical Builder aufnehmen.
5. Pilot: o6_9 und o6_16 von C auf A heben, `missing_data`-Quote vorher und
   nachher über die 250 Bestandsbetriebe messen.
