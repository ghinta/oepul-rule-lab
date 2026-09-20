# Auftrag: vollständige ÖPUL-Regelgewinnung für `o6_16`

Modus: `discover`
Run-ID: `v2-o6_16-terra-20260919`

Arbeite ausschließlich im aktuellen Run-Workspace. Lies `AGENTS.md`, danach das
Canonical Farm Profile und anschließend die folgenden Quellen. Lies das
Maßnahmenblatt, die allgemeinen Teilnahmebedingungen und die 2026-Hinweise
vollständig. Durchsuche die Rechtsgrundlagen und Anhänge systematisch nach der
Maßnahme und lies alle gefundenen Abschnitte samt Definitionen, Tabellen,
Fußnoten und Querverweisen vollständig:

- sources/20241011_srl_oepul_2023.pdf (seitenmarkierter Text: sources/20241011_srl_oepul_2023.txt)
- sources/20241011_srl_oepul_2023_anhaenge.pdf (seitenmarkierter Text: sources/20241011_srl_oepul_2023_anhaenge.txt)
- sources/2026-05-22__trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen.html
- sources/2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html
- sources/2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html
- sources/2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html
- sources/o6_16_vorbeugender_grundwasserschutz_acker_2026_04.pdf (seitenmarkierter Text: sources/o6_16_vorbeugender_grundwasserschutz_acker_2026_04.txt)
- sources/o6_allgemeine_teilnahmebedingungen_2026_04.pdf (seitenmarkierter Text: sources/o6_allgemeine_teilnahmebedingungen_2026_04.txt)

## Ergebnis

1. Extrahiere möglichst jede normative, berechnungsrelevante oder
   entscheidungsrelevante Aussage einschließlich Voraussetzungen, Schwellen,
   Ausnahmen, Fristen, Optionen, Kombinationsbedingungen und Folgen.
2. Schreibe den vollständigen strukturierten Regelkatalog nach
   `rules/rules.json`. Lies davor
   `contracts/rules-catalog-v2.schema.json` vollständig und halte dieses Schema
   exakt ein: `contract_version` = `rules-catalog-v2.0.0`, `measure` =
   `o6_16` und das Array `rules`.
   Jede Regel benötigt mindestens eine stabile ID,
   Regelart, normalisierte Aussage, Bedingungen, Ergebnis und Quellenbeleg mit
   Dokument, Seite und Abschnitt.
3. Schreibe Quellenbelege zusätzlich nach `rules/citations.json`. Lies davor
   `contracts/source-references-v2.schema.json` vollständig und halte dieses
   Schema exakt ein. Verwende als `run_id` exakt `v2-o6_16-terra-20260919`;
   `source_path` und `artifact_path` beginnen mit
   `workspace/`, damit sie vom Run-Verzeichnis aus auflösbar sind. Ermittle die
   tatsächlichen SHA-256-Werte der kopierten Quellen. `evidence_text` ist ein
   kurzer wörtlicher Ausschnitt, der auf der angegebenen PDF-Seite bzw. in der
   HTML-Quelle tatsächlich vorkommt; eine Paraphrase ist hier unzulässig.
4. Implementiere ausführbare Rego-v1-Regeln unter `policy/` und aussagekräftige
   Tests unter `tests/`. Überführe umfangreiche Tabellen und geschlossene Listen
   vollständig nach `data/` und verwende sie aus Rego; fasse sie nicht nur
   beschreibend zusammen.
5. Ändere `canonical_farm_profile.json` niemals direkt. Lies
   `contracts/profile-changes-v1.schema.json` und schreibe benötigte Ergänzungen,
   Änderungen oder Löschungen nach `rules/profile_changes.json`. Jeder Vorschlag
   benötigt verknüpfte Regel- und Quellenbeleg-IDs. Verwende für `value_after`
   exakt die Struktur-Notation des Canonical Farm Profile: insbesondere ein
   JSON-Array mit repräsentativem Objekt statt des Strings `array<object>`. Im
   Modus `conform` muss das Array `changes` leer bleiben.
6. Führe OPA-Formatierung, Strict-Compile-Check und Tests wiederholt aus und
   repariere technische Fehler. Dokumentiere verbleibende fachliche
   Mehrdeutigkeiten in `notes/assumptions.md`.
7. Lies `contracts/coverage-ledger-v1.schema.json` und dokumentiere jeden
   geprüften Abschnitt, Absatz, jede Tabelle und Fußnote in
   `rules/coverage.json`: entweder mit Regel-IDs oder als `not_rule` bzw.
   `unresolved` samt Begründung. Maßnahmenblatt, allgemeine Bedingungen und
   2026-Hinweise werden vollständig geprüft; bei Rechtsgrundlagen darfst du
   gezielte Abschnitte mit begründetem `targeted_sections`-Scope verwenden.
8. Lies `contracts/data-inventory-v1.schema.json` und inventarisiere jede Datei
   unter `data/` in `rules/data_inventory.json`. Erfasse Tabellen über
   JSON-Pointer, Zeilenzahl und Quellenbeleg-IDs. Gibt es keine Datendateien,
   bleibt `artifacts` leer.
9. Validiere vor Abschluss alle fünf JSON-Ausgaben nochmals Feld für Feld gegen
   die mitgelieferten Schemas; ähnliche oder ältere Formate gelten als Fehler.

Lasse Regeln nicht allein wegen eines unvollständigen Ausgangsprofils weg. Ziel
ist zunächst maximale, quellengebundene und technisch lauffähige Extraktion;
eine unabhängige fachliche Bewertung findet später statt.

## Verbindlicher Reparaturauftrag nach unabhängiger Grounding-Prüfung

Der erste vollständige Entwurf wurde außerhalb deines Sandboxes mit dem
Pydantic-/Grounding-Validator geprüft. Bewahre die fachliche Breite und die
vollständige Anhang-G-Tabelle, repariere aber sämtliche folgenden Befunde:

1. `rules/profile_changes.json`: Drei `add`-Vorschläge verwenden JSON `null`
   als `value_after`; das ist kein gültiger Profiltyp. Verwende dieselbe
   Blueprint-Notation wie `canonical_farm_profile.json` (`"date|null"`,
   `"number|null"`, `"boolean"`, Arrays mit repräsentativem Objekt). Da
   überlappende Änderungen verboten sind, ersetze die bisherigen Vorschläge
   vorzugsweise durch genau einen vollständigen `add` für `oepul.o6_16`, der
   wirklich jeden in Regeln oder Rego verwendeten Pfad enthält. Insbesondere
   fehlen derzeit zahlreiche Betriebs-, Options- und Parcel-Felder wie
   `application_date`, `entry_year`, Flächenhistorie, Fristen,
   `soil_sample_parameters`, Wiener/Cultan/Schweine-Optionen sowie alle von
   Rego verwendeten Parcel-Attribute. Keine fachlich benötigte Variable
   weglassen.
2. `rules/citations.json`: Die Evidence-Texte der folgenden IDs sind auf der
   angegebenen Seite nicht exakt auffindbar und müssen anhand der
   seitenmarkierten TXT-Dateien wortgetreu berichtigt werden; korrigiere bei
   Bedarf auch die Seitenzahl: `src.general.p7`, `src.general.p13`,
   `src.general.p15`, `src.general.p16`, `src.general.p17`, `src.law.p74`,
   `src.law.p75`, `src.law.p76`, `src.measure.p2`, `src.measure.p3`,
   `src.measure.p4`, `src.measure.p5`, `src.measure.p7`, `src.measure.p8`,
   `src.measure.p9`, `src.measure.p15`. Prüfe danach auch alle übrigen
   Evidence-Texte erneut. Nicht paraphrasieren.
3. `rules/data_inventory.json`: Der Validator zählt skalare Blätter in
   verschachtelten Lookup-Objekten. Setze daher die tatsächlichen Counts:
   `/drought_2026_harvest_exemption_districts` = 41,
   `/premiums_eur_per_ha` = 19 und
   `/protein_limits_g_per_kg_88_tm` = 10. Die 1.566 Einträge der
   Katastralgemeinden bleiben unverändert.
4. Prüfe abschließend alle Regel-/Citation-/Coverage-/Data-Crosslinks und
   erhalte die direkten Profil- und Quelldateien unverändert. Fehlender
   Docker-Socket im Modell-Sandbox ist kein fachlicher Fehler; die Host-Abnahme
   erfolgt danach separat.

## Verbindlicher OPA-Reparaturauftrag

Die externe Grounding-Prüfung besteht nun ohne Fehler. Verändere die
strukturierten Regeln, Belege, Coverage, Daten, Profilvorschläge und Quellen
nicht mehr. Die Host-Prüfung mit OPA 1.18.2 meldet jedoch in
`policy/o6_16.rego` mindestens an Zeile 47 folgenden Parserfehler:

```text
rego_parse_error: unexpected if keyword
factor := 0.8 if high_reduction_area else 0.6
```

Diese Python-artige bedingte Zuweisung ist kein gültiges Rego v1 und kommt in
beiden `nitrogen_transfer_kg_per_ha`-Zweigen vor. Ersetze sie durch gültige,
deterministische Rego-v1-Regeln bzw. eine Hilfsfunktion für den Faktor. Prüfe
den gesamten Policy- und Testcode zusätzlich auf denselben Syntaxfehler und
formatiere beide Rego-Dateien so weit im Sandbox möglich. Ändere ausschließlich
`policy/o6_16.rego` und bei tatsächlich notwendiger Testkorrektur
`tests/o6_16_test.rego`.

## Zweiter verbindlicher OPA-Reparaturauftrag

Der Parserfehler ist behoben; OPA 1.18.2 Strict-Compile besteht. Die Tests
melden derzeit 6/9, fehlgeschlagen sind Gebietskulisse, Bio-Basisprämie und
Wirkstoffverbot. Eine direkte OPA-Auswertung zeigt die Ursache eindeutig:
Die JSON-Datei wird mit ihren Objektfeldern direkt am `data`-Root geladen.
Vorhanden sind daher `data.eligible_katastralgemeinden`,
`data.premiums_eur_per_ha`, `data.restricted_crops` und
`data.banned_active_ingredients`; `data.o6_16_reference_data.*` ist undefiniert.

Korrigiere in `policy/o6_16.rego` alle Zugriffe auf die generierten Tabellen
auf die tatsächlich geladenen Root-Pfade. Ändere keine fachlichen Regeln,
strukturierten Verträge, Belege, Coverage, Profildaten oder Quelldaten. Prüfe,
dass kein `data.o6_16_reference_data` mehr vorkommt. Die Host-Abnahme führt
anschließend erneut Formatierung, Strict-Compile und alle neun Tests aus.
