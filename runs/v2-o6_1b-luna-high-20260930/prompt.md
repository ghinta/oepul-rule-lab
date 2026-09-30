# Auftrag: vollständige ÖPUL-Regelgewinnung für `o6_1b`

Modus: `discover`
Run-ID: `v2-o6_1b-luna-high-20260930`

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
- sources/o6_1b_biologische_wirtschaftsweise_2026_04.pdf (seitenmarkierter Text: sources/o6_1b_biologische_wirtschaftsweise_2026_04.txt)
- sources/o6_allgemeine_teilnahmebedingungen_2026_04.pdf (seitenmarkierter Text: sources/o6_allgemeine_teilnahmebedingungen_2026_04.txt)

## Ergebnis

1. Extrahiere möglichst jede normative, berechnungsrelevante oder
   entscheidungsrelevante Aussage einschließlich Voraussetzungen, Schwellen,
   Ausnahmen, Fristen, Optionen, Kombinationsbedingungen und Folgen.
2. Schreibe den vollständigen strukturierten Regelkatalog nach
   `rules/rules.json`. Lies davor
   `contracts/rules-catalog-v2.schema.json` vollständig und halte dieses Schema
   exakt ein: `contract_version` = `rules-catalog-v2.0.0`, `measure` =
   `o6_1b` und das Array `rules`.
   Jede Regel benötigt mindestens eine stabile ID,
   Regelart, normalisierte Aussage, Bedingungen, Ergebnis und Quellenbeleg mit
   Dokument, Seite und Abschnitt.
3. Schreibe Quellenbelege zusätzlich nach `rules/citations.json`. Lies davor
   `contracts/source-references-v2.schema.json` vollständig und halte dieses
   Schema exakt ein. Verwende als `run_id` exakt `v2-o6_1b-luna-high-20260930`;
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

Der erste Entwurf ist erzeugt, aber nicht finalisierbar. Arbeite weiterhin nur
im Run-Workspace und repariere die bestehenden Artefakte vollständig. Lies die
Verträge, das Canonical Farm Profile, die Quellen und die vorhandenen Dateien
erneut, bevor du änderst. Führe danach die technische Validierung und
`PYTHONPATH=src python3 -m rulelab verify-grounding ..` aus (vom Workspace
aus ggf. mit passendem relativen Run-Pfad); beende die Reparatur erst, wenn
beides fehlerfrei ist.

1. Revidiere alle Quellenbelege so, dass jede `evidence_text` exakt und
maschinenfindbar in der gewählten Quelle vorkommt. Die folgenden Belege sind
derzeit nicht auffindbar und müssen durch kurze exakte Ausschnitte ersetzt
werden: `o6_1b_p05_livestock`, `o6_1b_p07_grassland`,
`o6_1b_p08_09_training`, `o6_1b_p22_23_landscape`,
`o6_1b_srl_p37_certification`, `o6_1b_srl_p37_grassland`,
`o6_1b_srl_p38_arable_div`, `o6_1b_srl_p38_sowing`,
`o6_1b_srl_p40_monitoring`, `o6_1b_srl_p44_combination`.
2. Die Quellenbelege `o6_1b_p10_field_div`, `o6_1b_p11_sowing` und
`o6_1b_p18_grassland_codes` verweisen fälschlich auf nicht vorbereitete
HTML-Dateien. Ersetze sie durch belegte Quellen aus der vorbereiteten Auswahl
oder korrigiere sie auf die tatsächlich vorhandene Quelle. Für HTML gilt
`page: null`; für PDF ist eine reale Seitennummer erforderlich. Entferne
unbenutzte Quellenbelege oder verknüpfe sie korrekt mit Regeln.
3. Vervollständige `rules/profile_changes.json`: Jede von Regeln oder Rego
verwendete Eingabepfad-Variable, die im vorgeschlagenen Profil fehlt, braucht
einen belegten Change auf ein Blatt (niemals auf einen Array-Container wie
`application.measures[]`). Folge der Struktur des Canonical Farm Profile und
verwende für Arrays repräsentative Objekt-Arrays. Insbesondere müssen die
fehlenden Bereiche `year`, `biodiversity`, `certifications`, `crop`, `land`,
`livestock`, `monitoring`, `pheromone_traps`, `partial_farm`,
`landscape_elements`, `hedge` und `exception` sowie ihre von Rego verwendeten
Unterpfade konsistent mit den Regeln ergänzt oder die betroffenen Regeln/Rego
auf bestehende, korrekt vorgeschlagene Pfade zurückgeführt werden. Stelle
sicher, dass die Änderung für `application.measures` ein Blatt unter einem
repräsentativen Objekt adressiert, nicht den Array-Container.
4. Behebe den Dateninventarfehler: Die fünf vorhandenen Dateien unter
`workspace/data/` müssen im Inventory mit genau auflösbaren
`workspace/data/...`-Pfaden stehen (nicht `data/...`), mit korrekten
JSON-Pointern, Zeilenzahlen und Quellenbelegen.
5. Erhalte die fachliche Breite der Extraktion. Keine defekten Regeln,
Quellenbelege oder Datendateien nur löschen, um die Prüfung grün zu bekommen;
entferne ausschließlich wirklich redundante, unreferenzierte Einträge.
