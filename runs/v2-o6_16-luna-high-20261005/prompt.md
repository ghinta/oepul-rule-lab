# Auftrag: vollständige ÖPUL-Regelgewinnung für `o6_16`

Modus: `discover`
Run-ID: `v2-o6_16-luna-high-20261005`

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
   Schema exakt ein. Verwende als `run_id` exakt `v2-o6_16-luna-high-20261005`;
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

## Verbindlicher Reparaturauftrag nach Grounding-Validierung

Der Generierungsversuch ist noch nicht veröffentlichbar, weil Rego auf nicht
vorgeschlagene Profileingaben zugreift. Arbeite ausschließlich im
vorbereiteten Workspace und repariere alle folgenden Pfade konsistent in
Policy, Regeln und `rules/profile_changes.json`:

- `farm.bentazon_reauthorized`
- `farm.region.is_eastern_lower_austria_or_tullnerfeld`
- `land.total_arable_area_ha`
- `livestock.pig_gve_average`
- `measure.oo_chemical_psm_application`
- `measure.oo_variant_3_cover`
- `records.oo_ipm_inspection_or_warning_documented`
- `records.vienna_extra_education_hours`

Jeder erforderliche Pfad muss als zulässiger konkreter Blattpfad mit einem
nicht-null Repräsentativwert und Rule-/Citation-Verknüpfungen vorgeschlagen
werden, sofern er nicht bereits im Canonical Farm Profile existiert. Keine
Array- oder Objekt-Container als Änderung und keine überlappenden Änderungen.
Alternativ darf ein Pfad nur dann aus Rego entfernt werden, wenn die
zugehörige Regel fachlich und referenziell konsistent umgestellt wird. Führe
anschließend den lokalen OPA-Validator erneut aus und kontrolliere alle fünf
JSON-Artefakte gegen die Verträge, bis `verify-grounding` ohne Fehler besteht.

## Zweiter verbindlicher Reparaturauftrag

Die vorige Reparatur besteht noch nicht. Arbeite ausschließlich im
vorbereiteten Workspace und behebe alle folgenden Fehler:

1. `M-P9-PSM` hat einen Belegtext, der auf der zitierten Seite/Quelle nicht
   auffindbar ist. Korrigiere Quelle, Seite und den kurzen wörtlichen
   `evidence_text` auf eine nachweisbar auffindbare Formulierung; passe die
   verknüpfte Regel bei Bedarf konsistent an.
2. Profile-Änderungen dürfen nicht mit `[]` enden. Ersetze die fünf
   unzulässigen Pfade
   `land.parcels[].psm_active_ingredients[]`,
   `options.cultan.parcel_ids[]`,
   `options.strong_n_reduced_pig_feeding.feed_categories[]`,
   `options.washout_risk.parcel_ids[]` und `records.soil_samples[]` durch die
   jeweiligen Blatt-Eigenschaften **ohne** abschließendes `[]`. Beschreibe
   Arraywerte als echte JSON-Arrays mit repräsentativem String bzw. Objekt im
   `value_after`, nicht als Pfad-Container oder Typstring.
3. Stelle sicher, dass insbesondere die von Rego benutzten Pfade
   `options.strong_n_reduced_pig_feeding.feed_categories`,
   `options.washout_risk.parcel_ids` und `records.soil_samples` danach als
   zulässige Profile-Ergänzungen vorhanden sind. Keine überlappenden
   Änderungen erzeugen.
4. Führe den lokalen OPA-Validator aus und kontrolliere anschließend alle
   Grounding-Verträge erneut. Beende erst, wenn auch die Profile-Application-
   und Evidence-Fehler vollständig verschwunden sind.
