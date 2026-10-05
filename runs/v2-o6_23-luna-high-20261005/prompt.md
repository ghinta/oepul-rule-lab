# Auftrag: vollständige ÖPUL-Regelgewinnung für `o6_23`

Modus: `discover`
Run-ID: `v2-o6_23-luna-high-20261005`

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
- sources/o6_23_natura2000-landwirtschaft_2025_10.pdf (seitenmarkierter Text: sources/o6_23_natura2000-landwirtschaft_2025_10.txt)
- sources/o6_allgemeine_teilnahmebedingungen_2026_04.pdf (seitenmarkierter Text: sources/o6_allgemeine_teilnahmebedingungen_2026_04.txt)

## Ergebnis

1. Extrahiere möglichst jede normative, berechnungsrelevante oder
   entscheidungsrelevante Aussage einschließlich Voraussetzungen, Schwellen,
   Ausnahmen, Fristen, Optionen, Kombinationsbedingungen und Folgen.
2. Schreibe den vollständigen strukturierten Regelkatalog nach
   `rules/rules.json`. Lies davor
   `contracts/rules-catalog-v2.schema.json` vollständig und halte dieses Schema
   exakt ein: `contract_version` = `rules-catalog-v2.0.0`, `measure` =
   `o6_23` und das Array `rules`.
   Jede Regel benötigt mindestens eine stabile ID,
   Regelart, normalisierte Aussage, Bedingungen, Ergebnis und Quellenbeleg mit
   Dokument, Seite und Abschnitt.
3. Schreibe Quellenbelege zusätzlich nach `rules/citations.json`. Lies davor
   `contracts/source-references-v2.schema.json` vollständig und halte dieses
   Schema exakt ein. Verwende als `run_id` exakt `v2-o6_23-luna-high-20261005`;
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

## Fortsetzung nach Usage-Guard-Unterbrechung

Der vorherige Lauf wurde ausschließlich wegen eines vorübergehenden Fehlers
beim Abruf der Codex-Auslastung kontrolliert unterbrochen. Prüfe die bestehenden
Workspace-Artefakte, vervollständige sie bei Bedarf und liefere einen vollständig
validierten Discover-Entwurf. Übernimm keine unvollständigen Artefakte als
Abschluss: Führe den lokalen technischen Validator erneut aus, repariere alle
Fehler und ändere weder Quellen noch das Canonical Farm Profile.

## Reparaturlauf: Grounding- und Profilabgleich

Der zweite Generierungsversuch ist technisch erzeugt, besteht aber die strikte
Grounding-Prüfung noch nicht. Repariere im Workspace alle folgenden Punkte und
führe den lokalen Validator erneut aus:

- `SHEET-N2` darf nicht ungenutzt bleiben: Verknüpfe ihn mit einer tatsächlich
  passenden Regel oder entferne den überflüssigen Beleg, ohne die zugehörige
  Aussage zu verlieren.
- Für `GENERAL-MIN-MGMT`, `GENERAL-OP`, `GENERAL-SANCTIONS` und
  `SRL-COMBINATION` muss `evidence_text` ein kurzer, wortgetreuer Ausschnitt
  sein, der auf genau der referenzierten Quelle und Seite auffindbar ist.
- Bringe Rego und `rules/profile_changes.json` zur Deckung: Die Regeln
  O623-2026-CUT-EXCEPTION, O623-2026-DIVSZ-EXCEPTION,
  O623-APPLICATION-DEADLINE, O623-AUFLAGEN-COMBINATION,
  O623-AUTO-EXTENSION, O623-LAST-ENTRY, O623-PREMIUM-RATES und
  O623-WITHDRAWAL-EFFECT verwenden noch nicht vorgeschlagene Pfade (`year`,
  `land.parcels[].project_confirmation_obligations` bzw.
  `measure.o6_23.withdrawal_not_declared`). Ergänze belegte, nicht
  überlappende Profilvorschläge in Canonical-Profile-kompatibler Struktur oder
  passe Rego auf bereits vorgeschlagene korrekte Pfade an. Gleiches gilt für
  die in Rego verwendeten Pfade `input.year` und
  `input.land.parcels[].valid`; keine undefinierten Platzhalterpfade.
- In `rules/data_inventory.json` ist für
  `workspace/data/o6_23.json` am Pointer `/o6_23/combination_chapters` die
  tatsächliche `row_count` 64 statt 8.

Ändere weder die Quellen noch das Canonical Farm Profile. Beende erst, wenn
strict Compile/Tests und die Grounding-Prüfung fehlerfrei sind.

## Zweiter Reparaturlauf: verbleibender Profilpfad

Die Grounding-Prüfung ist bis auf einen Punkt erfolgreich. Rego liest noch
`input.land.parcels[].valid`, das von keinem gültigen, nicht überlappenden
Profilvorschlag abgedeckt wird. Ergänze diesen Feldpfad korrekt in der zum
Canonical Farm Profile passenden Struktur oder verwende einen bereits korrekt
vorgeschlagenen Feldpfad. Prüfe danach erneut mit dem lokalen Validator und
beende erst bei vollständig erfolgreicher Grounding-Prüfung. Quellen und das
Canonical Farm Profile bleiben unverändert.
