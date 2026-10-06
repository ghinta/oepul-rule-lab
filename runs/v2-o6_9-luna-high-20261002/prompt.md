# Auftrag: vollständige ÖPUL-Regelgewinnung für `o6_9`

Modus: `discover`
Run-ID: `v2-o6_9-luna-high-20261002`

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
   Schema exakt ein. Verwende als `run_id` exakt `v2-o6_9-luna-high-20261002`;
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

## Verbindlicher Reparaturauftrag nach Grounding-Prüfung

Der erste Lauf enthält umfangreiche Regeln, scheitert aber noch systematisch an
Quellenpfaden und Profilauflösung. Arbeite im vorhandenen Workspace weiter,
erhalte die Abdeckung und repariere **alle** folgenden Punkte. Führe danach
lokalen Validator und `verify-grounding` selbst erneut aus, bis beide ohne
Fehler bestehen.

1. In `rules/citations.json` zeigen die PDF-Belege irrtümlich auf
   `workspace/sources/*.txt`. Ersetze bei **allen** Belegen für Allgemeine
   Bedingungen, Anhänge und das Maßnahmenblatt (`annex_*`, `general_*`,
   `measure_*`, `srl_*`) die `.txt`-Pfade durch die tatsächlich vorbereiteten
   PDFs und deren exakte Hashes: `20241011_srl_oepul_2023.pdf`,
   `20241011_srl_oepul_2023_anhaenge.pdf`,
   `o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf`
   und `o6_allgemeine_teilnahmebedingungen_2026_04.pdf`. Für diese PDF-Belege
   bleiben die Seitenzahlen erhalten und der Evidenztext muss dort wortgleich
   auffindbar sein. Verwende `page: null` nur bei echten Notice-HTML-Dateien.
2. Korrigiere `rules/coverage.json` auf die vier genannten vorbereiteten PDFs
   (und ggf. die tatsächlich gewählten Notice-HTMLs), niemals auf `.txt`-Dateien.
   Entferne alle `.txt`-Ledger-Pfade. PDFs müssen korrekte Seitenlisten und
   zulässigen Scope haben; echte HTMLs haben leere `pages_reviewed` und
   `full_document`-Scope. Alle vorbereiteten Quellen müssen im Ledger stehen.
3. Repare `rules/profile_changes.json` und die Regeln/Rego gemeinsam. Additions
   dürfen nicht auf Arraycontainer wie
   `land.parcels[].operations.manure_applications[]` oder
   `land.parcels[].operations.separation_events[]` zielen. Lege stattdessen
   unter den vorhandenen Parcel-Operations echte Blattfelder oder ein
   zulässiges repräsentatives Objekt an. Ergänze außerdem konsistente,
   quellengebundene Objektvorschläge für jede tatsächlich verwendete Eingabe
   (oder ändere Regel/Rego auf einen existierenden bzw. vorgeschlagenen Pfad):
   `application`, `participation`, `pig_feeding`, `calculation`, `separation`,
   `region`, `farm.arable_area_ha` und die Jahresangabe. Die Vorschläge müssen
   mindestens sämtliche in der Validierung gemeldeten Kinder abdecken:
   Antrag/Methode/Art/Landnutzung/Records/Nachweise/Menge unter `application`,
   Kategorie/Fristen/Vertrags- und Ausstiegsdaten unter `participation`,
   Schweine-GVE und Fütterungsnachweise unter `pig_feeding`,
   Flächen- und GVE-Berechnungswerte unter `calculation` und alle
   Separation-Nachweise und Mengen unter `separation`. Verwende bei der
   Jahresangabe vorzugsweise den Canonical-Pfad `farm.year` statt eines neuen
   nackten Wurzelpfads. Jeder neue Pfad braucht passende `rule_ids` und
   `source_reference_ids`; keine kollidierenden Changes.

Verändere niemals Quelldokumente oder das Canonical Farm Profile, verwende
keine erfundenen Quellen und veröffentliche nichts vor vollständig erfolgreicher
technischer und Grounding-Validierung.
