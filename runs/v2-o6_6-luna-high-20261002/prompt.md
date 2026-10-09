# Auftrag: vollständige ÖPUL-Regelgewinnung für `o6_6`

Modus: `discover`
Run-ID: `v2-o6_6-luna-high-20261002`

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
- sources/o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf (seitenmarkierter Text: sources/o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.txt)
- sources/o6_allgemeine_teilnahmebedingungen_2026_04.pdf (seitenmarkierter Text: sources/o6_allgemeine_teilnahmebedingungen_2026_04.txt)

## Ergebnis

1. Extrahiere möglichst jede normative, berechnungsrelevante oder
   entscheidungsrelevante Aussage einschließlich Voraussetzungen, Schwellen,
   Ausnahmen, Fristen, Optionen, Kombinationsbedingungen und Folgen.
2. Schreibe den vollständigen strukturierten Regelkatalog nach
   `rules/rules.json`. Lies davor
   `contracts/rules-catalog-v2.schema.json` vollständig und halte dieses Schema
   exakt ein: `contract_version` = `rules-catalog-v2.0.0`, `measure` =
   `o6_6` und das Array `rules`.
   Jede Regel benötigt mindestens eine stabile ID,
   Regelart, normalisierte Aussage, Bedingungen, Ergebnis und Quellenbeleg mit
   Dokument, Seite und Abschnitt.
3. Schreibe Quellenbelege zusätzlich nach `rules/citations.json`. Lies davor
   `contracts/source-references-v2.schema.json` vollständig und halte dieses
   Schema exakt ein. Verwende als `run_id` exakt `v2-o6_6-luna-high-20261002`;
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

## Reparaturauftrag nach technischer Prüfung (verbindlich)

Der erste Durchlauf hat umfangreiche Regeln erzeugt, scheitert aber noch an
Grounding und Profilauflösung. Arbeite im vorhandenen Workspace weiter,
erhalte die inhaltliche Abdeckung und repariere **alle** folgenden Punkte.
Führe danach erneut den lokalen Validator aus, bis er vollständig erfolgreich
ist.

1. Korrigiere die `used_by`-Zeilenbereiche der Quellenbelege
   `src_drought_0805` und `src_drought_0812`: die Bereiche müssen auf echte
   Zeilen der aktuellen `workspace/rules/rules.json` zeigen oder beide
   Zeilenwerte müssen `null` sein. Keine out-of-range-Werte.
2. Ersetze das `evidence_text` der Belege `src_data_variants`,
   `src_general_p10_12`, `src_general_p12_13`, `src_general_p15_16`,
   `src_general_p4_5`, `src_general_p5_6`, `src_o66_p12_13`,
   `src_o66_p2_3` und `src_srl_common_p9_11` jeweils durch einen kurzen,
   exakten, maschinell auf der bezeichneten Seite auffindbaren Wortlaut. Keine
   Paraphrasen und keine zusammengezogenen Textstücke über Seiten hinweg.
3. Vervollständige `rules/profile_changes.json` so, dass jeder Pfad aus
   Regelbedingungen und Rego gegen das Canonical Farm Profile oder gegen einen
   beantragten Profilzusatz auflösbar ist. Lege insbesondere einen konsistenten
   Wurzelzusatz `o6_6` als JSON-Objekt mit sämtlichen dort verwendeten Feldern
   an (nicht je Feld kollidierende Änderungen). Ergänze auch die benötigten
   allgemeinen Felder unter `applicant`, `documentation`, `farm` und `land`.
   Verwende bei Flächen/Parzellen die vorhandene Array-Objekt-Notation. Passe
   Regeln nötigenfalls an real existierende Pfade an: `farm.year`, nicht
   `canonical_farm_profile.farm.year`; für Österreich verwende z. B.
   `farm.country` oder einen tatsächlich beantragten Parzellenpfad. Alle
   `input.o6_6.*`-Zugriffe in Rego müssen durch diesen einen Profilzusatz
   gedeckt sein.
4. Korrigiere die Dateninventur für
   `workspace/data/o6_6_variants.json/premium_bands_eur_per_ha`: die
   angegebene Zeilenzahl muss der tatsächlichen Anzahl (14) entsprechen.

Arbeite nicht an Canonical Profile oder Quellen. Erfinde keine Belege. Behalte
Regeln und Quellen-IDs soweit möglich stabil, führe den lokalen technischen
Validator strikt aus und beende erst bei sauberem Ergebnis.
