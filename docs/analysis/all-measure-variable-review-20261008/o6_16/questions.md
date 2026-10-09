# o6_16: offene Fachentscheidungen

Alle Antworten und App-Zuordnungen bleiben offen. Die Zitate sind Modellnotizen bzw. Prüfbeobachtungen, keine bestätigte Fachauslegung.

### o6_16-INPUT_CONTRACT

Welche der im Diff einzeln gelisteten Eingaben werden fachlich benötigt und aufgenommen? Für jede: verbindlicher Name, Betrieb/Schlag/Tier/Gruppe/Projekt, Einheit, Zeitbezug, Herkunft/Nachweis und Abgrenzung zu bestehenden App-Feldern. Luna- und Opus-Strukturen sind alternative Vorschläge; keine automatische Umbenennung.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_16-luna-high-20261005/workspace/rules/profile_changes.json:6–9`

```text
    {"action":"add","path":"farm.bentazon_reauthorized","value_after":false,"rationale":"Die ab 2025 maßgebliche Ausnahme knüpft das Bentazon-Verbot an eine Wiederzulassung.","rule_ids":["O616-033"],"source_reference_ids":["M-P9-PSM"]},
    {"action":"add","path":"farm.region.is_eastern_lower_austria_or_tullnerfeld","value_after":false,"rationale":"Für die Stickstoffreduktion muss die Lage in östlichem Niederösterreich einschließlich Tullnerfeld separat erfasst werden.","rule_ids":["O616-016","O616-017"],"source_reference_ids":["M-P4-NREDUCTION"]},
    {"action":"add","path":"measure.requested","value_after":true,"rationale":"Der Maßnahmeantrag ist im Canonical Profile nicht vorhanden.","rule_ids":["O616-004","O616-005","O616-051"],"source_reference_ids":["M-P2-COMBINATION","M-P2-MINIMUM","M-P13-APPLICATION"]},
    {"action":"add","path":"measure.first_participation_year","value_after":2026,"rationale":"Das erste Teilnahmejahr steuert die 2-ha-Mindestteilnahme.","rule_ids":["O616-005","O616-006"],"source_reference_ids":["M-P2-MINIMUM"]},
```

Ursprung: `runs/v2-o6_16-opus-5.5-high-20261002/workspace/rules/profile_changes.json:8–11`

```text
      "path": "farm.applicant",
      "value_before": null,
      "value_after": {
        "legal_form": "enum(natuerliche_person|personengesellschaft_firmenbuch|juristische_person|personenvereinigung)",
```

### o6_16-ZONE_VERSION

Welche GIS/KG-Kulisse gilt je Jahr, insbesondere bis 2024 vs. ab 2025? Wie werden die 80-%-Reduktionszonen schlaggenau bestätigt; Bezug zu App #133?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_16-opus-5.5-high-20261002/workspace/notes/assumptions.md:19–29`

```text
- Die Kulisse wird über die KG-Nummer (`land.parcels[].cadastral_community_number`) gegen die vollständige
  KG-Liste aus Anhang G (1566 Zeilen, Seiten 40–59) bestimmt. Die Karten (Abbildungen bis 2024 / ab 2025) sind nicht
  maschinenlesbar; die KG-Liste wird als aktuelle Kulisse ab 2025 behandelt (die 1b-Markierungen auf S. 51–54
  deuten auf die Erweiterung 2025 hin). Für Jahre bis 2024 kann die Kulisse daher zu weit sein.
- In der Quelle steht KG 51106 (Bergham, Bad Wimsbach-Neydharting) doppelt; die Zeile wurde unverändert übernommen,
  die Rego-Abfrage dedupliziert.
- Politische Gemeinde und Katastralgemeinde sind im Textextrakt nicht eindeutig trennbar und stehen daher gemeinsam
  im Feld `gemeinde_und_katastralgemeinde`.
- Die Teilgebiete für den Reduktionsfaktor 80 % (nördliches/mittleres Burgenland, östliches Niederösterreich inkl.
  Tullnerfeld, Wien) sind in Anhang G nicht nach KG ausgewiesen. Wien wird aus Anhang G abgeleitet; für die übrigen
  Schläge muss `n_reduction_zone` angegeben werden, sonst meldet die Policy `missing_data`.
```

### o6_16-N_CHAIN

Welche Folgekultur-/Zwischenfrucht-Kette und NAPV-Daten sind notwendig, damit Überträge nicht nur aus einer Vorkultur angenähert werden?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_16-opus-5.5-high-20261002/workspace/notes/assumptions.md:33–42`

```text
- Die Schwellen 10/20 kg/ha werden als „strikt größer“ gelesen (Beispiel Eferding 2025: 20 kg/ha → kein Übertrag).
- Maßgeblich ist das Antragsjahr der Folgekultur (`farm.year`); „ab 2025 bestehende oder angebaute Kulturen“ wird
  damit gleichgesetzt.
- Der Auslöser „Überschuss > 30 kg/ha“ für die Herbst-Anlagepflicht wird auf den Saldo vor Reduktionsfaktor bezogen.
- Der Übertrag wird auf zwei Nachkommastellen gerundet (Beispiel 12 × 0,6 = 7,2 kg/ha).
- Die Kettenbetrachtung über mehrere Kulturen (nicht-stickstoffzehrende Folgekulturen, mehrere Kulturen im Jahr,
  mehrjährige Kulturen, genutzte Zwischenfrüchte) ist als Regel erfasst, aber nicht als Ketten-Simulation
  implementiert: Die Policy prüft je Schlag den Übertrag aus der angegebenen Vorkultur.
- Für die Herbst-Anlagepflicht gilt die Teilnahme an o6_6/o6_7 plus `cover_crop.is_used` als Zwischenfrucht gemäß
  Begrünungsmaßnahme. Die Varianten-Detailauflagen von o6_6/o6_7 werden nicht geprüft.
```

### o6_16-REGISTER_TOPUP

Welcher aktuelle Bentazon-Zulassungsstatus, Sudangras-Scope und OÖ-Top-up-Nachweis sind verbindlich? Nicht vorhandene Bestätigungen bleiben offen.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_16-opus-5.5-high-20261002/workspace/notes/assumptions.md:46–63`

```text
- Bentazon ist nur bei Wiederzulassung verboten. Der Status ist unbekannt; Standard `false`
  (`bentazon_reauthorized_default`), per Profilfeld überschreibbar.
- Die Codierpflicht PSMBIO/PSMCS (bis 2025) wird nur für Ackerflächen in der Kulisse geprüft (Kapitel 4.6 bezieht
  sich auf die Kulisse).
- Sudangras steht im Infoblatt 2026 (Verbot und Zuschlag), nicht aber in der SRL; umgesetzt nach dem Infoblatt.
- Zuckermais wird beim Zuschlag „Mais (ohne Saatmaisvermehrung)“ mitgezählt.
- „Schutz- und Schongebiete“ (kein PSM-Zuschlag) sind schlagbezogen über
  `oepul.in_protection_or_conservation_zone` erfasst; `farm.region.water_protection_zone` ist nur betriebsbezogen
  und wird dafür nicht verwendet.

## Oberösterreich

- Die Sperrzeiträume reichen über den Jahreswechsel und werden über den Monat/Tag geprüft (inklusive
  Grenztage). Ackerfutter ist vom allgemeinen Sperrzeitraum 15.10.–15.02. ausgenommen; für Mais gilt
  15.10.–21.03.
- Ob eine Gabe „leichtlöslich“ ist und wie viel N nach Stall- und Lagerverlusten verbleibt, wird als Eingabe
  übernommen (NAPV-Definitionen nicht verfügbar).
- Der Landes-Top-up wird gewährt, sofern `upper_austria_top_up_funds_available` nicht ausdrücklich `false` ist.
```

### o6_16-SOIL_SOURCE

Welche MFA-2026-Basis, Proben-/Projektvorgaben und genaue Fälligkeit gelten? Muss die fehlende AMA-Meldung vom 25.08.2026 nachgetragen werden?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_16-opus-5.5-high-20261002/workspace/notes/assumptions.md:76–81`

```text
- Fristen bis 31.12.2026 werden erst ab Profiljahr 2027 als Verstoß gewertet; im Jahr 2026 erscheinen sie als
  `obligations` mit Status `open` oder `fulfilled`.
- Die Basisfläche für die Probenanzahl ist die Kulissen-Ackerfläche des Profils; für ein Profiljahr ungleich 2026
  ist `soil_sample_base_area_ha` (MFA 2026) anzugeben.
- Für die Wiener Doppelproben werden Proben mit `area == "wien_gebiet"` gezählt; räumliche/zeitliche
  Projektvorgaben sind nicht modelliert.
```
