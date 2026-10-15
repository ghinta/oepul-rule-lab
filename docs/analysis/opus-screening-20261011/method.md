# Methode und Grenzen der Opus-Sichtung

Diese Diagnose erfüllt [Lab #107](https://github.com/ghinta/oepul-rule-lab/issues/107)
nach der eingefrorenen [Luna-Sichtung](../luna-screening-20261011/README.md).
Sie bereitet den kleinen Thesis-Ausschnitt aus
[App #56](https://github.com/ghinta/oepul-recommender/issues/56) und
[Draft #149](https://github.com/ghinta/oepul-recommender/pull/149) vor.
Sie erzeugt keine neuen Modell-Runs oder unabhängigen fachlichen Sollurteile.

## Unveränderliche Bestände

Der Luna-Bestand liegt auf Main-Commit
`d2b63972c99056fde4e032029e1432639e281fda`; sein ursprüngliches Manifest und
seine Fixtures bleiben unverändert. Die Opus-Kandidaten stammen ausschließlich
aus PR #79, Commit `e009eed4a83ff076b26eba33ac433ac2b0642621`.
Von 36 finalisierten Opus-Veröffentlichungen wird je Maßnahme der zeitlich
letzte nach `max(finalized_at, run_id)` gebunden: genau 26 Maßnahmen,
o6_1a/b/c und o6_2–24. Die zehn ersetzten Kandidaten bleiben erhalten.
Die Auswahl filtert weder nach Regelzahl noch nach Prüferfolg oder Ausgabe.

Die Herkunft vom genannten Commit wird separat durch die dort veröffentlichten
Gitblob-Identitäten und den auf diesen SHA geprüften CI-Checkout belegt. Die
Manifest-API allein weist keinen Git-HEAD nach; ihre Hashprüfung schützt den
bereits gebundenen Dateibestand vor Änderungen. Diese beiden Nachweise haben
unterschiedliche Aufgaben.

`manifest.json` bindet die Metadaten aller 36 Veröffentlichungen und für die
ausgewählten 26 zusätzlich Originalquellen, Canonical Farm Profile, Modell-
und Promptdateien, Profile-Vorschläge, Policy, Daten, Modelltests, Regelkatalog,
Coverage-Ledger, Annahmen, historische Prüfartefakte und neue Fixtures mit
SHA-256 und Bytezahl. `load_paths` beschränkt die Ausführung auf native
Policy-/Datendateien. Raw-Logs und historische Binaries werden nicht geladen.
Die Modellkennung lautet `claude-opus-5-5`; eine unveränderliche Anbieterrevision
ist in diesen historischen Metadaten nicht ausgewiesen und wird nicht ergänzt.

Neun aktuelle Opus-Quellenpakete unterscheiden sich gegenüber Luna:
o6_1c, o6_4, o6_9, o6_12, o6_16, o6_17, o6_21, o6_22, o6_24.
Bei 17 Maßnahmen sind die historischen Quellenhash-Sets identisch.
Dateigleichheit belegt keine vollständige Interpretation oder aktuelle Rechtslage.
Die Quellen werden nicht nachträglich durch neuere Originale ersetzt.

## Dieselben fachlichen Fakten, native Verträge

`luna_translation` verlinkt pro Maßnahme das eingefrorene Luna-Fixture und
erfasst alle drei ursprünglichen Rollen: Basis, Variation, fehlender Fakt.
Zuordnungen nennen Pfade und Bedeutung; nicht belegbar übertragbare Fakten
und der unterschiedliche Prüfbereich werden ausdrücklich ausgewiesen.
Auch bei `cases=[]` bleiben alle drei ursprünglichen Fälle dokumentiert.

Erlaubt sind belegte Umbenennungen, eindeutige Enum-Zuordnungen und reine
Einheitenumrechnungen. Unbekannte Tierklassen, Einzeldaten, Genehmigungen,
Registerzulassungen, Compliance oder datierte Ereignisse werden nicht aus
Modelltests ergänzt. Fehlend, `null`, `false`, `0` und leere Listen
werden nicht ineinander umgedeutet. Jahre und Mengen werden nicht aktualisiert,
um erwünschte Ausgaben zu erhalten. Insbesondere bleibt o6_12 im Jahr 2024.

Eine teilweise übersetzte Eingabe ist ausdrücklich eine Teilprobe. Kann eine
Luna-Variation nicht dargestellt werden, können native Inputs identisch bleiben;
dies bedeutet eine nicht ausgeführte fachliche Variation und keine bestätigte
Nichtverwendung des ursprünglichen Fakts. Die JSON-Pointer-Differenzen zeigen
die tatsächlichen Eingabeänderungen. Ohne sinnvolle belegte native Teilprobe
enthält das Fixture keine ausführbaren Fälle und eine konkrete `fixture_gap`.
Die isolierte Kompilierung wird dennoch für alle 26 Kandidaten durchgeführt.

## Technische Ausführung und Reproduzieren

OPA (Open Policy Agent) 1.18.2 führt Rego aus. Version und Plattform-Prüfsumme
werden gegen die Repository-Pins geprüft. Pro Kandidat werden ausschließlich
hashgebundene Policy-/Datendateien in ein temporäres Bundle kopiert und als
Verzeichnisse geladen, damit native Datennamespaces erhalten bleiben. Modelltests
sind Herkunftsbelege, keine zusätzlich ausgeführten unabhängigen Referenztests.

`opa check --strict` und native, begrenzte `data.*`-Queries verwenden reduzierte
Capabilities ohne Netzwerk, aktuelle Zeit, Zufall und Runtime-Umgebungsdaten.
Eval-Limit: zehn Sekunden; Prozesslimit: 20 Sekunden. `defined`, `undefined`,
`runtime_error`, `compile_error` und `fixture_gap` sind technische Befunde.
Ein definiertes `eligible=false` bei unvollständigen Eingangsdaten ist kein
unabhängiges fachliches Negativurteil. Native Aggregate und Prämien haben je
Kandidat unterschiedliche Bedeutung; Projektionen können bei undefinierten
Teilwerten insgesamt undefiniert werden.

Zwei getrennte Checkouts, ohne Zusammenführen von Branches:

```bash
git clone https://github.com/ghinta/oepul-rule-lab.git /absolute/path/candidate-e009eed
git -C /absolute/path/candidate-e009eed checkout e009eed4a83ff076b26eba33ac433ac2b0642621
# Im Checkout dieses Diagnose-PRs:
PYTHONPATH=src OPA_BIN=/absolute/path/opa python -m rulelab.opus_screening verify \
  --candidate-root /absolute/path/candidate-e009eed
```

CI nutzt denselben festen Kandidatencommit und dieselben OPA-Pins in einem
zweiten Checkout. `verify` prüft vor und nach der Ausführung alle Bindungen
und vergleicht JSON, CSV, Markdown und HTML bytegenau. Es schreibt keine
Reports. `freeze` überschreibt kein Manifest; Änderungen brauchen eine neue
Diagnose. Report-Writes bleiben unter `docs/analysis`, außerhalb der Kandidaten.
Ein Merge von PR #79 ist keine Voraussetzung für diese Diagnose.

## Historische Bedingungen und begrenzter Thesis-Anschluss

`comparison.json` enthält pro Maßnahme Quellen, Profil, Modell/Adapter,
Reasoning, Timeout, Promptprüfsummen, Attempts/Fortsetzungen, historische
OPA-Metadaten, vorhandene Nutzungs-/Kostenangaben sowie Zuordnungslücken.
Die tatsächlichen `generator_result`-Werte werden pro Run einmal verwendet;
kumulative Sitzungswerte werden nicht über Fortsetzungen hinweg erneut addiert.
`generation_attempt` und `resumed_attempts` zählen Runner-Starts beziehungsweise
Fortsetzungen, nicht sämtliche internen Reparaturen oder Werkzeuginteraktionen.
Eine vollständige Interventionshistorie aus unveröffentlichten Raw-Logs wird
nicht behauptet.
Fehlende Luna-Nutzungsangaben bleiben fehlend. Unterschiedliche Werkzeuge,
Reparaturverläufe, Budgets und Quellen verhindern einen kontrollierten Modelleffekt.

Historische `run.json` nennen keine `quality_gate_version`; die Übergabe
berichtet v1. Eine spätere erfolgreiche Metadatenprüfung unter einem v2-Vertrag
belegt keine Erzeugung unter diesem Gate und keine fachliche Vollständigkeit.
Die Ledger melden insgesamt elf offene Coverage-Punkte; acht davon liegen in
den neun erneuerten Kandidaten, drei zusätzlich in o6_1a, o6_10 und o6_23.
Diese Angaben sind Modellbehauptungen, keine unabhängige Volltextprüfung.

Die vier vorgeschlagenen Thesis-Einzelklauseln bleiben eine kleine, gezielte
Auswahl. Die Entwicklungsproben prüfen bei o6_13 Bestäubung statt Antragsfrist,
bei o6_14 Alpungstage statt Tiergruppen und bei o6_17 eingereichte statt
erforderliche Bodenproben. Sie bestätigen daher diese drei Klauseln noch nicht.
Bei o6_17 darf die historische 10,4-ha-Basis nicht aus aktuellen zehn Hektar
neu gebildet oder mit einem erfundenen 0,4-ha-Schlag aufgefüllt werden.

Die Diagnose liefert Vertrags- und Referenzbedarf für #56, keine Methodfreigabe.
Die neue neutrale Versuchsmatrix, gemeinsame Budgets und Modellrevisionen sind
separat zu binden. Danach folgen unabhängige Referenzfälle (#51) und Collector
(#52). Sichtbare Entwicklungsfälle dürfen nicht nachträglich zu Held-out-Fällen
umetikettiert werden. #140 blockiert nur fachliche Sollurteile, deren konkrete
Auslegung noch offen ist; diese technische Diagnose braucht diese Urteile nicht.
