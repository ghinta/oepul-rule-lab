# Auftrag: vollständige ÖPUL-Regelgewinnung für `o6_9`

Modus: `discover`
Run-ID: `v3-o6_9-astra-6.2-high-20261120`

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
- sources/o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf (seitenmarkierter Text: sources/o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.txt)
- sources/o6_allgemeine_teilnahmebedingungen_2026_04.pdf (seitenmarkierter Text: sources/o6_allgemeine_teilnahmebedingungen_2026_04.txt)

## Ergebnis

1. Extrahiere möglichst jede normative, berechnungsrelevante oder
   entscheidungsrelevante Aussage einschließlich Voraussetzungen, Schwellen,
   Ausnahmen, Fristen, Optionen, Kombinationsbedingungen und Folgen.
2. Schreibe den vollständigen strukturierten Regelkatalog nach
   `rules/rules.json`. Lies davor
   `contracts/rules-catalog-v2.schema.json` vollständig und halte dieses Schema
   exakt ein: `contract_version` = `rules-catalog-v2.0.0`, `measure` =
   `o6_9` und das Array `rules`.
   Jede Regel benötigt mindestens eine stabile ID,
   Regelart, normalisierte Aussage, Bedingungen, Ergebnis und Quellenbeleg mit
   Dokument, Seite und Abschnitt.
3. Schreibe Quellenbelege zusätzlich nach `rules/citations.json`. Lies davor
   `contracts/source-references-v2.schema.json` vollständig und halte dieses
   Schema exakt ein. Verwende als `run_id` exakt `v3-o6_9-astra-6.2-high-20261120`;
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


## Separater Korrekturversuch mit Validatorfeedback
Prüfe die folgenden Befunde im vorhandenen Workspace. Erhalte belegte Inhalte und korrigiere die Rückweisungsgründe anhand der Quellen und Daten.

Die deterministische Rule-Lab-Finalisierung (`finalize`) hat den bisherigen Stand abgelehnt. Behebe alle folgenden Fehler, ohne die Anforderungen aus `AGENTS.md` und den Schemas aufzuweichen:

- [coverage] sources.0.items.125: Value error, only rules disposition may contain rule_ids
- [coverage] sources.0.items.126: Value error, only rules disposition may contain rule_ids
- [coverage] sources.0.items.127: Value error, only rules disposition may contain rule_ids
- [cross_references] rules absent from coverage ledger: ['o6_9.active_land', 'o6_9.actual', 'o6_9.advance', 'o6_9.application', 'o6_9.application_detail', 'o6_9.arable_care', 'o6_9.area_ceiling', 'o6_9.area_growth', 'o6_9.checks', 'o6_9.claim_sep', 'o6_9.claim_spread', 'o6_9.combination', 'o6_9.combo_fix', 'o6_9.conditionality', 'o6_9.contamination', 'o6_9.continuity', 'o6_9.control_access', 'o6_9.control_refusal', 'o6_9.crops', 'o6_9.density', 'o6_9.digestate', 'o6_9.digestate_proof', 'o6_9.distributor', 'o6_9.drought', 'o6_9.drought_request', 'o6_9.dwarf', 'o6_9.entry', 'o6_9.excluded_land', 'o6_9.exclusive', 'o6_9.exit_control', 'o6_9.external', 'o6_9.feed_all', 'o6_9.feed_avg', 'o6_9.feed_boar', 'o6_9.feed_entry', 'o6_9.feed_heavy', 'o6_9.feed_lactating', 'o6_9.feed_light', 'o6_9.feed_middle', 'o6_9.feed_piglet', 'o6_9.feed_pregnant', 'o6_9.feed_source', 'o6_9.fertile', 'o6_9.form', 'o6_9.grading', 'o6_9.grass_care', 'o6_9.group_log', 'o6_9.gve', 'o6_9.hose', 'o6_9.independent', 'o6_9.inject', 'o6_9.inspection_agent', 'o6_9.inspection_result', 'o6_9.k20_combination', 'o6_9.land_types', 'o6_9.lapse', 'o6_9.later_size', 'o6_9.law', 'o6_9.limited_growth', 'o6_9.long_contract', 'o6_9.loss_tolerance', 'o6_9.matrix', 'o6_9.matrix_notes', 'o6_9.meter', 'o6_9.mfa', 'o6_9.min_size', 'o6_9.minimum', 'o6_9.missing_records', 'o6_9.mistaken_div', 'o6_9.modulation', 'o6_9.multiyear_loss', 'o6_9.notification', 'o6_9.november', 'o6_9.one_year_list', 'o6_9.op', 'o6_9.op_duration', 'o6_9.op_fruit', 'o6_9.op_harvest', 'o6_9.op_overlap', 'o6_9.operator', 'o6_9.operator_change', 'o6_9.order', 'o6_9.organic_drift', 'o6_9.parcel_pairs', 'o6_9.parks', 'o6_9.payment', 'o6_9.permanent_care', 'o6_9.permanent_change', 'o6_9.person', 'o6_9.phase_proof', 'o6_9.quantity_basis', 'o6_9.rate_feed', 'o6_9.rate_hose', 'o6_9.rate_injection', 'o6_9.rate_separation', 'o6_9.rate_shoe', 'o6_9.rates_transition', 'o6_9.recipe', 'o6_9.reentry', 'o6_9.renew', 'o6_9.retention', 'o6_9.revision', 'o6_9.rgve', 'o6_9.sanction', 'o6_9.scope', 'o6_9.self_report', 'o6_9.sep_cap', 'o6_9.sep_log', 'o6_9.separation', 'o6_9.shared', 'o6_9.shoe', 'o6_9.slurry', 'o6_9.small_payment', 'o6_9.solid', 'o6_9.spread_cap', 'o6_9.spread_log', 'o6_9.stock', 'o6_9.structure', 'o6_9.takeover', 'o6_9.takeover_area', 'o6_9.temporary_change', 'o6_9.territory', 'o6_9.third_party', 'o6_9.trial', 'o6_9.unused_care', 'o6_9.upgrade', 'o6_9.urine', 'o6_9.warning', 'o6_9.water', 'o6_9.wild', 'o6_9.withdraw', 'o6_9.withdraw_effect', 'o6_9.year']
- [data] row_count mismatch for workspace/data/o6_9.json/o6_9_tables/combinations: expected 21, got 441
- [data] row_count mismatch for workspace/data/o6_9.json/o6_9_tables/contract_groups: expected 5, got 61
- [data] row_count mismatch for workspace/data/o6_9.json/o6_9_tables/gve: expected 23, got 92
- [data] row_count mismatch for workspace/data/o6_9.json/o6_9_tables/substrates: expected 27, got 9
- [evidence] ref.application.M.298: evidence_text not found on cited page/source
- [evidence] ref.op_fruit.G.312: evidence_text not found on cited page/source
- [evidence] ref.recipe.M.208: evidence_text not found on cited page/source


## Budgetfreigabe für v3-o6_9-astra-6.2-high-20261120 (Rule Lab #115, 26.11.2026)
Für diesen Auftrag ersetzt das Wochenfenster (10080 Minuten) das Fünf-Stunden-Fenster in der kopierten AGENTS.md. Der Runner hat vor dem Start 38.0 % Restbudget gemessen. Start ab 5 %, Stopp bei höchstens 5 %. Der Runner überwacht das Budget. Führe den Auftrag ohne erneute Budgetrückfrage aus.
Setze auf dem vorhandenen Workspace auf und prüfe zuerst die bisherigen Ausgaben.
