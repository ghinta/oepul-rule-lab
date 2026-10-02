# Auftrag: vollständige ÖPUL-Regelgewinnung für `o6_1c`

Modus: `discover`
Run-ID: `v2-o6_1c-luna-high-20260930`

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
- sources/o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf (seitenmarkierter Text: sources/o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.txt)
- sources/o6_allgemeine_teilnahmebedingungen_2026_04.pdf (seitenmarkierter Text: sources/o6_allgemeine_teilnahmebedingungen_2026_04.txt)

## Ergebnis

1. Extrahiere möglichst jede normative, berechnungsrelevante oder
   entscheidungsrelevante Aussage einschließlich Voraussetzungen, Schwellen,
   Ausnahmen, Fristen, Optionen, Kombinationsbedingungen und Folgen.
2. Schreibe den vollständigen strukturierten Regelkatalog nach
   `rules/rules.json`. Lies davor
   `contracts/rules-catalog-v2.schema.json` vollständig und halte dieses Schema
   exakt ein: `contract_version` = `rules-catalog-v2.0.0`, `measure` =
   `o6_1c` und das Array `rules`.
   Jede Regel benötigt mindestens eine stabile ID,
   Regelart, normalisierte Aussage, Bedingungen, Ergebnis und Quellenbeleg mit
   Dokument, Seite und Abschnitt.
3. Schreibe Quellenbelege zusätzlich nach `rules/citations.json`. Lies davor
   `contracts/source-references-v2.schema.json` vollständig und halte dieses
   Schema exakt ein. Verwende als `run_id` exakt `v2-o6_1c-luna-high-20260930`;
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

## Reparaturauftrag nach unabhängiger Grounding-Prüfung (Attempt 2)

Der erste Entwurf ist erzeugt, aber nicht finalisierbar. Arbeite ausschließlich
im Run-Workspace weiter. Lies die Verträge und das Canonical Farm Profile,
prüfe die vorhandenen Artefakte und repariere sie vollständig. Führe am Ende
die technische OPA-Prüfung und die Grounding-Validierung erneut aus.

1. Die Quellenbelege `src_notice_biodiv_2026`,
`src_notice_drought_0805_2026`, `src_notice_drought_0812_2026` und
`src_notice_rebzikade_2026` sind nicht mit Regeln verknüpft. Verknüpfe sie
mit den tatsächlich daraus abgeleiteten Regeln oder entferne nur diese
genuin unbenutzten Referenzen. Behalte die fachliche Extraktionsbreite.
2. Ergänze `rules/profile_changes.json` mit belegten Änderungen für alle von
Regeln oder Rego genutzten, bisher fehlenden Blattpfade. Insbesondere müssen
folgende Pfade strukturgleich zum Canonical Farm Profile vorhanden sein:
`land.parcels[].is_special_crop`,
`land.parcels[].agroforestry.natural_ingress_species[]`,
`land.parcels[].npa.psm_active_ingredients`,
`measure.npa_area_with_care_before_august_ha`,
`land.parcels[].npa.care_purpose`,
`land.parcels[].npa.first_application_year`,
`land.parcels[].npa.was_broken_up`, `measure.bio_part_operation`,
`measure.bio_participation`, `measure.npa_participation`,
`measure.ubb_participation`, `measure.combination_matrix`,
`land.parcels[].counted_for_other_obligation`,
`land.parcels[].other_measure_premium`, `measure.premium_band_selected`,
`land.parcels[].successor_continues_until_year_end`,
`land.parcels[].transfer_date` und `measure.compliance_breach`.
Für Arraypfade schlage immer ein repräsentatives Objekt in JSON-Arraynotation
vor; ändere das Canonical Farm Profile selbst niemals.
3. Stelle außerdem sicher, dass der von Rego verwendete Pfad
`input.measure.npa_area_with_care_before_august_ha` im vorgeschlagenen Profil
auflösbar ist. Prüfe danach sämtliche Regel- und Rego-Pfade gegen das
vorgeschlagene Profil, nicht nur die hier genannten.
4. Lösche keine fachlichen Regeln oder Daten nur, um Validierung grün zu
machen. Beende erst bei leerem Fehlerbericht der Grounding-Validierung und
erfolgreicher technischer Prüfung.

## Zweite Reparaturpräzisierung (Attempt 3)

Die zweite Fassung scheitert ausschließlich an der Anwendungssemantik der
Profiländerungen. Repariere sie im Run-Workspace und validiere erneut.

1. `profile_changes` darf nicht gleichzeitig einen Elternobjektpfad und dessen
Kindpfade ändern. Konsolidiere daher die überlappenden Vorschläge: Entferne
die redundanten Elternänderungen für `measure`, `land.parcels[].npa` und
`land.parcels[].agroforestry`, oder ersetze jeweils die Kindänderungen durch
einen einzigen zulässigen, nicht überlappenden Blattvorschlag, der alle von
Regeln und Rego benötigten Felder in seiner repräsentativen Objektstruktur
liefert. Die resultierenden Rego- und Regelpfade müssen im vorgeschlagenen
Profil weiterhin existieren.
2. Der Pfad `land.parcels[].agroforestry.natural_ingress_species[]` ist ein
Arraycontainer und darf nicht selbst Ziel einer Profiländerung sein. Wähle den
zulässigen Blattpfad bzw. den nicht überlappenden repräsentativen
Objektvorschlag gemäß Schema und Canonical-Profile-Notation; erfasse dessen
Wert als echtes JSON-Array. Passe bei Bedarf die Regel/Rego-Pfadnotation an,
ohne die fachliche Aussage zu verlieren.
3. Prüfe explizit, dass kein Eltern/Kind-Paar in `profile_changes` überlappt
und dass `o6_1c_010` nach Anwendung der Änderungen seinen Eingabepfad im
vorgeschlagenen Profil findet. Beende erst bei leerem Grounding-Fehlerbericht.
