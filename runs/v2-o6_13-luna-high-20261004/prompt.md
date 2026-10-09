# Auftrag: vollständige ÖPUL-Regelgewinnung für `o6_13`

Modus: `discover`
Run-ID: `v2-o6_13-luna-high-20261004`

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
- sources/o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf (seitenmarkierter Text: sources/o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.txt)
- sources/o6_allgemeine_teilnahmebedingungen_2026_04.pdf (seitenmarkierter Text: sources/o6_allgemeine_teilnahmebedingungen_2026_04.txt)

## Ergebnis

1. Extrahiere möglichst jede normative, berechnungsrelevante oder
   entscheidungsrelevante Aussage einschließlich Voraussetzungen, Schwellen,
   Ausnahmen, Fristen, Optionen, Kombinationsbedingungen und Folgen.
2. Schreibe den vollständigen strukturierten Regelkatalog nach
   `rules/rules.json`. Lies davor
   `contracts/rules-catalog-v2.schema.json` vollständig und halte dieses Schema
   exakt ein: `contract_version` = `rules-catalog-v2.0.0`, `measure` =
   `o6_13` und das Array `rules`.
   Jede Regel benötigt mindestens eine stabile ID,
   Regelart, normalisierte Aussage, Bedingungen, Ergebnis und Quellenbeleg mit
   Dokument, Seite und Abschnitt.
3. Schreibe Quellenbelege zusätzlich nach `rules/citations.json`. Lies davor
   `contracts/source-references-v2.schema.json` vollständig und halte dieses
   Schema exakt ein. Verwende als `run_id` exakt `v2-o6_13-luna-high-20261004`;
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

Der erste Lauf enthält fachliche Regeln, scheitert aber noch an systematischen
Quellenpfaden und einem Array-Profilpfad. Arbeite im bestehenden Workspace
weiter, erhalte die Abdeckung und behebe **alle** folgenden Punkte. Führe danach
lokalen Validator und `verify-grounding` selbst erneut aus, bis beide ohne
Fehler bestehen.

1. Alle PDF-Belege in `rules/citations.json` referenzieren irrtümlich
   `workspace/sources/*.txt`. Ersetze bei sämtlichen `SRC-ANNEX-*`,
   `SRC-GEN-*`, `SRC-LEGAL-*` und `SRC-O613-*`-Einträgen die `.txt`-Pfade
   durch die tatsächlichen vorbereiteten PDFs und ihre exakten Hashes:
   `20241011_srl_oepul_2023.pdf`, `20241011_srl_oepul_2023_anhaenge.pdf`,
   `o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf` und
   `o6_allgemeine_teilnahmebedingungen_2026_04.pdf`. Seitenzahlen und
   Evidenztexte müssen zu diesen PDFs passen. `SRC-DATA-O613` darf nicht auf
   eine erzeugte Datendatei oder sonst nicht vorbereitete Quelle zeigen:
   binde ihn an die passende vorbereitete Originalquelle oder entferne/ersetze
   ihn mit sauber verknüpften Regeln.
2. Korrigiere `rules/coverage.json` auf genau diese vorbereiteten PDF-Pfade;
   entferne sämtliche `.txt`-Ledger-Pfade. PDFs erhalten korrekte Seitenlisten
   und zulässigen Scope. Nur echte Notice-HTMLs, falls belegt verwendet, haben
   leere `pages_reviewed` und `full_document`-Scope.
3. `land.parcels[].organism_applications[]` ist kein zulässiger Zielpfad für
   einen Profil-Add. Modellier die Anwendung als zulässiges Blatt bzw.
   repräsentatives Objekt unter der Parzelle ohne Arraycontainer (z. B.
   `land.parcels[].organism_application`) und passe die Regeln O613-008,
   O613-009, O613-010 sowie alle Rego-Zugriffe daran an. Der Vorschlag muss
   alle fachlich benötigten Felder erfassen, die Canonical-Profile-Notation
   einhalten und passende Regel- und Quellen-IDs tragen.
4. Korrigiere in `rules/data_inventory.json` die Zeilenzahl für
   `/o6_13_reference_data/drought_2026_automatic_higher_force_districts` auf
   **41**; Pfad, SHA-256 und Quellenbelege bleiben passend zur vorhandenen
   Datendatei.

Ändere weder Quelldokumente noch das Canonical Farm Profile und erfinde keine
Evidenz. Beende erst nach vollständig erfolgreicher technischer und
Grounding-Validierung.
