# Auftrag: vollständige ÖPUL-Regelgewinnung für `o6_12`

Modus: `discover`
Run-ID: `v3-o6_12-astra-6.2-high-20261120`

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
- sources/o6_12_insektizidverzicht_wein_obst_hopfen_2026_04.pdf (seitenmarkierter Text: sources/o6_12_insektizidverzicht_wein_obst_hopfen_2026_04.txt)
- sources/o6_allgemeine_teilnahmebedingungen_2026_04.pdf (seitenmarkierter Text: sources/o6_allgemeine_teilnahmebedingungen_2026_04.txt)

## Ergebnis

1. Extrahiere möglichst jede normative, berechnungsrelevante oder
   entscheidungsrelevante Aussage einschließlich Voraussetzungen, Schwellen,
   Ausnahmen, Fristen, Optionen, Kombinationsbedingungen und Folgen.
2. Schreibe den vollständigen strukturierten Regelkatalog nach
   `rules/rules.json`. Lies davor
   `contracts/rules-catalog-v2.schema.json` vollständig und halte dieses Schema
   exakt ein: `contract_version` = `rules-catalog-v2.0.0`, `measure` =
   `o6_12` und das Array `rules`.
   Jede Regel benötigt mindestens eine stabile ID,
   Regelart, normalisierte Aussage, Bedingungen, Ergebnis und Quellenbeleg mit
   Dokument, Seite und Abschnitt.
3. Schreibe Quellenbelege zusätzlich nach `rules/citations.json`. Lies davor
   `contracts/source-references-v2.schema.json` vollständig und halte dieses
   Schema exakt ein. Verwende als `run_id` exakt `v3-o6_12-astra-6.2-high-20261120`;
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

- [coverage] sources.6.items.22: Value error, only rules disposition may contain rule_ids
- [cross_references] rules absent from coverage ledger: ['o6_12.abbruch', 'o6_12.abmeldung', 'o6_12.acker_duerre', 'o6_12.aktive_flaeche', 'o6_12.almausmass', 'o6_12.andere_kultur', 'o6_12.anordnung', 'o6_12.antrag', 'o6_12.antragsteller', 'o6_12.auskunft', 'o6_12.ausschluss', 'o6_12.ausstieg_folge', 'o6_12.ausstieg_meldung', 'o6_12.ausstieg_option', 'o6_12.auszahlung', 'o6_12.begruenung_duerre', 'o6_12.bescheid', 'o6_12.bestand', 'o6_12.betrieb', 'o6_12.betriebsgroesse', 'o6_12.bew_acker', 'o6_12.bew_brache', 'o6_12.bew_dauer', 'o6_12.bew_gruen', 'o6_12.bio_kombi', 'o6_12.bio_mittel', 'o6_12.bio_option_antrag', 'o6_12.biodiv_mindest', 'o6_12.codepflicht', 'o6_12.dauerhaft', 'o6_12.div_acker', 'o6_12.div_dritte', 'o6_12.div_frueh', 'o6_12.div_gruen_frueh', 'o6_12.div_kontrolle', 'o6_12.div_phaeno', 'o6_12.div_ruhetage', 'o6_12.div_varianten', 'o6_12.div_wechsel', 'o6_12.einjaehrig', 'o6_12.einstieg', 'o6_12.erosion_breite', 'o6_12.erosion_erneuerung', 'o6_12.erosion_kombi', 'o6_12.erosion_pflege', 'o6_12.erosion_praemie', 'o6_12.erosion_saat', 'o6_12.flaechendef', 'o6_12.folgejahr', 'o6_12.fremd', 'o6_12.ga_k20', 'o6_12.ganzjahr', 'o6_12.gve_schluessel', 'o6_12.hoehere_gewalt', 'o6_12.identifikation', 'o6_12.immergruen', 'o6_12.inland', 'o6_12.jahresflaeche', 'o6_12.kleinbetrag', 'o6_12.konditionalitaet', 'o6_12.kontrollen', 'o6_12.kontrollgrenze', 'o6_12.korrektur', 'o6_12.kulturgruppen', 'o6_12.lager', 'o6_12.laufzeit', 'o6_12.matrix', 'o6_12.matrix_wien', 'o6_12.minimum', 'o6_12.mischcode', 'o6_12.modulation', 'o6_12.nachfolge', 'o6_12.nationalpark', 'o6_12.nutzung_nat', 'o6_12.nutzung_natura', 'o6_12.obergrenze', 'o6_12.obst', 'o6_12.op', 'o6_12.op_beispiele', 'o6_12.op_doppelt', 'o6_12.op_ernte', 'o6_12.op_vertrag', 'o6_12.optionen', 'o6_12.organismen', 'o6_12.organismen_zugang', 'o6_12.pflanzgut', 'o6_12.prueffrist', 'o6_12.pruefhilfe', 'o6_12.pruefrecht', 'o6_12.rassen', 'o6_12.reben', 'o6_12.rebzikade_bio', 'o6_12.rebzikade_gebiet', 'o6_12.rebzikade_nachweis', 'o6_12.rebzikade_synthetisch', 'o6_12.recht', 'o6_12.reihenfolge', 'o6_12.revision', 'o6_12.sanktion', 'o6_12.satz', 'o6_12.selbstanzeige', 'o6_12.sonstige', 'o6_12.spezial', 'o6_12.stufen', 'o6_12.teilbetrieb', 'o6_12.teilzahlung', 'o6_12.toleranz', 'o6_12.topfkultur', 'o6_12.uebernahme', 'o6_12.uebernahme_sonder', 'o6_12.umstieg', 'o6_12.umwandlung', 'o6_12.untersaat', 'o6_12.upload', 'o6_12.verlaengerung', 'o6_12.verlust', 'o6_12.versaeumt', 'o6_12.versuch', 'o6_12.vertragspartner', 'o6_12.verweigerung', 'o6_12.verzicht', 'o6_12.vieh', 'o6_12.vorcode', 'o6_12.voruebergehend', 'o6_12.wegfall', 'o6_12.zugangsflaeche', 'o6_12.zweck', 'o6_12.zwischenfrucht']
- [data] row_count mismatch for workspace/data/oepul.json/oepul_tables/culture_groups: expected 4, got 82
- [profile_application] Rego uses paths absent from proposed profile: ['input.farm.o6_12.takeover.fraction', 'input.farm.o6_12.takeover.lower', 'input.farm.o6_12.takeover.upper', 'input.farm.payment_assessment.full_year', 'input.farm.payment_assessment.public_overlap', 'input.farm.payment_assessment.term_possible', 'input.farm.payment_assessment.trial_noncompliance']
