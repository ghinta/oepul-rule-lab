# Auftrag: vollständige ÖPUL-Regelgewinnung für `o6_1a`

Modus: `discover`
Run-ID: `v2-o6_1a-luna-high-20260930`

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
- sources/o6_1a_ubb_2026_04.pdf (seitenmarkierter Text: sources/o6_1a_ubb_2026_04.txt)
- sources/o6_allgemeine_teilnahmebedingungen_2026_04.pdf (seitenmarkierter Text: sources/o6_allgemeine_teilnahmebedingungen_2026_04.txt)

## Ergebnis

1. Extrahiere möglichst jede normative, berechnungsrelevante oder
   entscheidungsrelevante Aussage einschließlich Voraussetzungen, Schwellen,
   Ausnahmen, Fristen, Optionen, Kombinationsbedingungen und Folgen.
2. Schreibe den vollständigen strukturierten Regelkatalog nach
   `rules/rules.json`. Lies davor
   `contracts/rules-catalog-v2.schema.json` vollständig und halte dieses Schema
   exakt ein: `contract_version` = `rules-catalog-v2.0.0`, `measure` =
   `o6_1a` und das Array `rules`.
   Jede Regel benötigt mindestens eine stabile ID,
   Regelart, normalisierte Aussage, Bedingungen, Ergebnis und Quellenbeleg mit
   Dokument, Seite und Abschnitt.
3. Schreibe Quellenbelege zusätzlich nach `rules/citations.json`. Lies davor
   `contracts/source-references-v2.schema.json` vollständig und halte dieses
   Schema exakt ein. Verwende als `run_id` exakt `v2-o6_1a-luna-high-20260930`;
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

## Reparaturauftrag für Versuch 2

Die deterministische Finalisierung hat den bisherigen Stand abgelehnt. Prüfe
und repariere die bestehenden Ausgaben vollständig, statt sie nur zu
beschreiben. Die OPA-Prüfung allein genügt nicht. Insbesondere:

- In Belegen und im Coverage-Ledger müssen PDF-Quellen die vorbereiteten
  `workspace/sources/*.pdf`-Pfade verwenden; die zugehörigen `*.txt`-Dateien
  sind ausschließlich seitenmarkierte Lesehilfen. PDF-Belege haben eine
  Seitenzahl; nur echte HTML-Quellen verwenden `page: null`.
- Der Coverage-Ledger muss dieselben PDF-Quellpfade verwenden und für
  nichtrechtliche Kernquellen `full_document` dokumentieren. Er darf keine
  `.txt`-Hilfsdateien als Quellen aufführen.
- Verwende in Regelbedingungen und Rego ausschließlich Pfade aus dem
  Canonical Farm Profile beziehungsweise aus konkreten Discover-Vorschlägen.
  Behalte die bestehende Verschachtelung bei (etwa `farm.year` und
  `farm.region.*`), statt flache Top-Level-Pfade wie `year` oder
  `input.year` zu erfinden. Jeder von Rego verwendete Input-Pfad muss im
  vorgeschlagenen Profil nachweisbar sein.
- Profile-Changes dürfen keine Array-Container als Ziel angeben. Für neue
  Arrays muss `value_after` ein JSON-Array mit einem repräsentativen Objekt
  in der Notation des Canonical Farm Profile sein; alle Zielpfade müssen
  fachliche Blattpfade sein.
- Korrigiere die Zeilenzahlen im Dateninventar anhand der tatsächlich vom
  JSON-Pointer referenzierten Datenstruktur und prüfe alle Tabellen erneut.

Führe nach den Korrekturen erneut OPA fmt, strict check und Tests aus. Ändere
weder die Quellen noch das Canonical Farm Profile.

## Reparaturauftrag für Versuch 3

Die unabhängige Deterministik-Prüfung hat nach Versuch 2 noch genau folgende
Fehler gefunden. Behebe sie sämtlich in den bestehenden Workspace-Ausgaben:

- Die `add`-Vorschläge `land.parcels[].rare_variety.first_use_year` und
  `documentation.drought_2026.relief_code` haben jeweils ein unzulässiges
  `value_after: null`. Verwende passende konkrete Repräsentativwerte (z. B.
  ein ganzzahliges Jahr beziehungsweise `"OPUBB"`). Dadurch muss der gesamte
  Profile-Change-Satz wieder anwendbar sein; danach müssen alle von Rego
  verwendeten `input.documentation.*`-Pfade im vorgeschlagenen Profil liegen.
- Der Beleg `ref_ubb_p16_gl_variants` muss einen unverändert auffindbaren
  wörtlichen Ausschnitt von PDF-Seite 16 verwenden. Ein sicherer Ausschnitt
  ist: `Bei jeder der 4 angebotenen Varianten hat eine Mahd mit Verbringung des Mähgutes`.
- Korrigiere die Dateninventur: Die rekursive Zeilenzahl für
  `/eligible_arable_crops` beträgt 74, und für
  `/premium_rates_eur_per_ha` beträgt sie 60. Aktualisiere die Werte, ohne
  Daten wegzulassen.

Nach der Änderung führe den vollständigen lokalen OPA-Validator aus und
kontrolliere die fünf JSON-Verträge erneut.
