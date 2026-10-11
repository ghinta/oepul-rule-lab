# Methode und Grenzen der Luna-Sichtung

Diese Entwicklungssichtung gehört zu [Lab #106](https://github.com/ghinta/oepul-rule-lab/issues/106).
Sie macht die vorhandenen Kandidaten vor der Auswahl des Thesis-Ausschnitts
beobachtbar. Sie ist kein kontrollierter Modellvergleich und enthält keine
unabhängig bestätigten fachlichen Sollurteile.

## Bestand und Bindungen

`manifest.json` bindet genau einen finalisierten `gpt-5.6-luna`-Run für jede
der 26 Maßnahmen: o6_1a/b/c und o6_2–o6_24. Basis ist Commit
`7a296d28cb5b92e2758c5a3889c929ea1db60fe5`. SHA-256 und Dateigröße binden
Originalquellen, Canonical Farm Profile, Run-Metadaten, Modellkonfiguration,
Prompt, vorgeschlagenes Profil, Policy, Daten, Modelltests, Regelkatalog,
Annahmen und historische Prüfartefakte. Die Run-ID, Konfiguration, Datierung
und `generation_attempt` stehen zusätzlich pro Eintrag im Manifest.

Die Query und ihre Eingabe-/Ausgabedeutung stehen im jeweils hashgebundenen
Fixture. Die exakten Policy-/Datendateien stehen in `load_paths`; deren
historische Roots sind `runs/<run-id>/workspace/policy` und `workspace/data`.
Reparaturen sind über die gebundenen `run.json` und `prompt.md` nachvollziehbar.
`generation_attempt` ist die historische Runner-Metadatenzahl, keine vollständige
Zählung aller Modellinterventionen oder selbst ausgeführten Reparaturen.
Raw-Modelltranskripte und damalige lokale OPA-Binaries werden nicht neu veröffentlicht
oder als Policy geladen. Die vorhandenen Modelltests dienen nur als gebundene
Entwicklungsherkunft der Fixtures.

Die Originale werden gegen die im jeweiligen historischen Run gespeicherten
Hashes geprüft. Neuere Quellenpakete werden nicht nachträglich zugeordnet.
Diese Bindung beweist Dateigleichheit; sie beweist weder aktuellen Rechtsstand
noch vollständige oder korrekte Interpretation der Dokumente. Angaben zur
Quellendeckung und Regeltypen in der Matrix stammen aus den historischen
Modellkatalogen und Coverage-Ledgern, nicht aus einer neuen Volltextprüfung.

## Ausführung

OPA (Open Policy Agent) führt die Rego-Regeln aus. Version 1.18.2 und die
plattformabhängige Binary-Prüfsumme werden gegen den Repository-Pin geprüft.
Pro Maßnahme kopiert der Runner ausschließlich die gebundenen Policy- und
Datendateien in ein temporäres Verzeichnis. Er lädt deren **Verzeichnisse**:
dadurch bleiben insbesondere die Datennamespaces unterhalb verschachtelter
JSON-Verzeichnisse erhalten. Andere Maßnahmen und Modelltests werden nicht
mitgeladen. `opa check --strict` prüft den isolierten Kandidaten neu.

Jeder Fall bekommt seine vollständige JSON-Eingabe über stdin. Es gibt keine
Umdeutung in einen gemeinsamen Farm-Vertrag und keine implizit ergänzten Fakten.
Die Query ist ein nativer `data.*`-Pfad oder eine ausdrücklich dokumentierte,
begrenzte Projektion nativer Ausgaben. Bei einer Projektion kann ein undefiniertes
Teilurteil das gesamte Objekt undefiniert machen; der Runner ersetzt es nicht.

Der Lauf verwendet `--strict-builtin-errors`, 10 Sekunden Eval- und 20 Sekunden
Prozesslimit. Fehler sind technische Befunde. Die Capabilities schließen
Netzwerkzugriff, aktuelle Zeit, Zufallswerte und Runtime-Umgebungsdaten aus.
Benötigte solche Builtins würden einen sichtbaren Compile-Fehler ergeben.
Ein vorheriger historischer Prüferfolg überschreibt keinen aktuellen Fehler.

Vor und nach der Ausführung werden die gebundenen Dateien geprüft. Ausgaben
liegen ausschließlich in diesem Analyseverzeichnis. Der Runner führt keine
Modellgenerierung, Formatierungsänderung, Finalisierung oder App-Promotion aus.

## Fälle und Ausgabebedeutung

Je Maßnahme enthält das Fixture eine synthetische Basis, eine einzelne gezielte
Faktänderung und die Entfernung eines Faktwerts. Diese 78 sichtbaren Fälle
stammen teilweise aus historischen Modelltests; Herkunft und Änderungen sind
pro Fixture beschrieben. Sie dürfen später weder als unabhängig bestätigtes
Gold noch als unbekannte Prüfmenge wiederverwendet werden.

`results.json` und `results/<measure>.json` enthalten vollständige Eingaben,
Eingabehashes, JSON-Pointer-Differenzen zur Basis, native Ausgaben und die
vollständigen OPA-JSON-Antworten. Fehlend, `null`, `false`, `0`
und leere Listen bleiben unterscheidbar. `defined`, `undefined`, `runtime_error`
und `compile_error` bezeichnen ausschließlich die technische Ausführung.
`eligible=true` ist kein einheitliches fachliches Gesamturteil. Die konkrete
Bedeutung und der Umfang von Prämienwerten stehen je Maßnahme im Fixture.

Die historischen statischen Eingabepfade sind als solche ausgewiesen; sie sind
kein vollständiger dynamischer Nachweis aller tatsächlich gelesenen Fakten.
Insbesondere können dynamische Referenzen und Berechnungen außerhalb der
gewählten Query fehlen. Jede Variation ändert hier genau einen Fakt. Eine
veränderte Ausgabe belegt ihre beobachtbare Wirkung in diesem Fall; eine
unveränderte Ausgabe beweist keine allgemeine Nichtverwendung. Eine lückenlose
dynamische Eingabeprovenienz bleibt eine konkrete Diagnosegrenze.

## Wiederholung

Vom Repository-Wurzelverzeichnis:

```bash
PYTHONPATH=src OPA_BIN=/absolute/path/opa python -m rulelab.screening verify
```

`verify` prüft alle Bindungen, führt alle Fälle erneut aus und vergleicht JSON,
CSV, Markdown und HTML bytegenau mit den eingecheckten Ergebnissen. Es schreibt
keine Reports. Laufzeiten, temporäre absolute Pfade und Hostdaten werden nicht
als Ergebnis gespeichert. CI nutzt denselben Befehl und dieselben Pins.

`freeze` ist für eine neue Sichtung mit neuem Analyseverzeichnis gedacht und
überschreibt kein bestehendes Manifest. `replay` regeneriert die Anzeige auf
den bereits gebundenen Eingaben. Geänderte Fixtures oder historische Artefakte
werden abgelehnt; eine neue Diagnose braucht ein neues Manifest.

## Begrenzter Anschluss an App und Thesis

Für [App #139](https://github.com/ghinta/oepul-recommender/issues/139) ist eine
begrenzte Vorschau möglich: exakt ausgewähltes Bundle und Query laden,
Eingabevertrag explizit abbilden, Klausel-/Schlag-/Betriebsumfang kennzeichnen,
fehlende Fakten und widersprüchliche Teilurteile getrennt zeigen. Prämienwerte
bleiben unbestätigte Indikationen. Ein pauschales `eligible` oder `missing_data`
reicht dafür nicht. Dieses Issue liefert die Verträge und beobachteten Lücken;
es implementiert diese App-Verbindungen nicht.

[App #136](https://github.com/ghinta/oepul-recommender/issues/136) kann den
separaten manuell adaptierten Heuwirtschaft-Klauselbefund anzeigen. Der hier
untersuchte historische Luna-Run wird dadurch nicht verändert. Seine Ausgabe
darf nicht mit der Ausgabe der Adaptation gleichgesetzt werden.

Die Auswahl des Thesis-Ausschnitts bleibt offen. Vor dem kontrollierten Versuch
in [App #56](https://github.com/ghinta/oepul-recommender/issues/56) sind fachliche
Relevanz, unterschiedliche Regeltypen, unabhängige Referenzfälle, erforderliche
Fakten und konkret offene Auslegungen festzuhalten. Fehlerhafte Kandidaten
werden nicht wegen ungünstiger Ausgaben ausgeschlossen. Die Matrix dokumentiert
die Voraussetzungen; sie schätzt keine unbelegten Expertenstunden und vergibt
keine Genauigkeitsrangfolge. Neue unabhängige Fälle und Expertenlabels sind
je ausgewählter Regel separat zu erstellen.

[App #140](https://github.com/ghinta/oepul-recommender/issues/140) blockiert
fachliche Sollurteile dort, wo eine relevante Auslegung fehlt, und die dort
beschriebene vollständige Heuwirtschaft-Empfehlung. Es blockiert diese technische
Diagnose nicht pauschal. Die konkrete Abhängigkeit steht im jeweiligen Fixture.
[Lab #107](https://github.com/ghinta/oepul-rule-lab/issues/107) folgt für Opus erst
nach Luna und tatsächlicher Verfügbarkeit der vorgesehenen Revisionen.
Vollständiger Quellen-/App-Ausbau bleibt in
[Lab #108](https://github.com/ghinta/oepul-rule-lab/issues/108) und
[App #148](https://github.com/ghinta/oepul-recommender/issues/148) als Future Work.
