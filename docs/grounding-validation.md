# Grounding- und Halluzinationskontrollen

Status: implementiert auf dem Feature-Branch `codex/grounding-validation`.

## Ziel

Die Generierung soll neue Regeln und benötigte Eingaben weiterhin entdecken
können, aber weder freie JSON-Strukturen noch unbelegte Aussagen oder direkte
Änderungen am Canonical Farm Profile unbemerkt akzeptieren.

Pydantic verhindert keine fachlich falsche Aussage, wenn sie formal korrekt
ist. Deshalb kombiniert der Finalizer fünf unterschiedliche Gates.

## Validierungskette

1. **Strikte Pydantic-Verträge**
   
   Alle Generator-Artefakte werden mit Pydantic v2 und `extra="forbid"`
   eingelesen. Falsche Typen, unbekannte Felder, doppelte IDs und ungültige
   Aktionskombinationen werden abgelehnt. Die JSON-Schemas werden direkt aus
   denselben Modellen erzeugt.

2. **Belegprüfung**
   
   Jeder Quellenbeleg enthält `source_sha256`, Seite, Claim und einen kurzen
   wörtlichen `evidence_text`. Der Finalizer prüft den Hash und sucht den
   normalisierten Beleg auf genau der angegebenen PDF-Seite beziehungsweise in
   der HTML-Quelle. Eine bloße Paraphrase besteht dieses Gate nicht.

3. **Cross-Links**
   
   Jede Regel referenziert existierende Quellenbeleg-IDs. Jeder Beleg muss von
   mindestens einer Regel genutzt werden. Profilvorschläge und Datentabellen
   referenzieren ebenfalls existierende Regeln bzw. Belege. Artefaktpfade und
   Zeilengrenzen werden geprüft.

4. **Profilvorschläge statt Direktänderung**
   
   `workspace/canonical_farm_profile.json` muss byteinhaltlich dieselbe Struktur
   wie der Baseline-Snapshot behalten. Discover-Läufe schreiben ausschließlich
   `rules/profile_changes.json`. Der Finalizer kontrolliert, ob `add`, `change`
   oder `remove` zum Ausgangsprofil passt, erzeugt
   `artifacts/proposed-profile.json` und berechnet daraus den Profil-Diff.
   Direkte Änderungen lassen den Lauf fehlschlagen.

   Zusätzlich müssen alle in strukturierten Bedingungen und Rego verwendeten
   `input`-Pfade im validierten vorgeschlagenen Profil existieren. Damit kann
   ein Modell eine fehlende Variable nicht nur im Code erfinden; es muss sie
   explizit, belegt und reviewbar vorschlagen.

5. **Coverage und Datentabellen**
   
   `rules/coverage.json` weist geprüfte Abschnitte, Absätze, Tabellen, Fußnoten
   und Hinweise Regeln zu oder dokumentiert `not_rule`/`unresolved` mit Grund.
   Nicht-rechtliche Kernquellen müssen als vollständig geprüft markiert sein;
   bei PDFs muss die Seitenmenge vollständig sein. Rechtsgrundlagen dürfen mit
   begründetem Abschnittsscope geprüft werden.

   `rules/data_inventory.json` bindet jede JSON-Datei unter `data/` per Hash ein
   und prüft Tabellen über JSON-Pointer, Zeilenzahl und Quellenbelege. Als
   ausführbare Tabellen gelten sowohl Arrays als auch Lookup-Objekte. Bei
   Arrays zählen die Elemente; bei verschachtelten Lookup-Objekten werden die
   skalaren Einträge gezählt.

## Artefakte

Generatorpflichten:

- `rules/rules.json`
- `rules/citations.json`
- `rules/profile_changes.json`
- `rules/coverage.json`
- `rules/data_inventory.json`
- Rego, Tests, Daten und Annahmen

Finalizer-Ergebnisse:

- `artifacts/grounding-validation.json`
- `artifacts/direct-profile-diff.json`
- `artifacts/proposed-profile.json`
- `artifacts/profile-diff.json`
- technische OPA-Prüfung, Metriken und Inventar

Mit `python3 -m rulelab verify-grounding runs/<run-id>` lassen sich die
deterministischen Gates unabhängig vom mutierenden Finalizer erneut ausführen.
Der Befehl schreibt keine Run-Dateien.

## Bewusste Grenze

Ein belegter Satz kann falsch interpretiert oder unvollständig operationalisiert
werden. Deshalb bleiben Cross-Model-Vergleich, unabhängige Verifier-Läufe,
Hidden Tests und Domainexpert:innen-Review erforderlich. Die neuen Gates
verwandeln Halluzinationen jedoch von still akzeptierten Ergebnissen in
sichtbare Vertrags-, Beleg-, Abdeckungs- oder Verknüpfungsfehler.
