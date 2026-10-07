# Heuwirtschaft: quellengebundene Adaptation für #97

`policy/` und `data/` enthalten einen manuell reparierten, begrenzten
Kandidaten auf Basis des Luna-Runs und der in `lineage.json` gebundenen
Quellen. Historische Modell-Runs und das Canonical Farm Profile bleiben
unverändert. Die Opus-Überarbeitungen vom angekündigten 08.10.2026 sind noch
nicht enthalten. Der spätere App-Maßnahmen-PR muss sie erneut gegenprüfen.

## Ausführen

```bash
PYTHONPATH=src python3 -m rulelab.heuwirtschaft \
  --input adaptations/o6_3/fixtures/merkblatt-example.json \
  --opa-bin /absolute/path/to/opa
```

Der Einstieg validiert `input.schema.json` über die zugehörigen Pydantic-
Modelle und führt ausschließlich Rego aus. Er berechnet keine zweite
fachliche Entscheidung in Python. `status` gilt für den ausdrücklich
ausgewiesenen Klauselslice, `indicative_premium_eur` für eine Bruttoindikation.
Allgemeine Förderfähigkeit, Einzelflächenkombinationen, Flächenzugang,
Modulation, Kürzungen und Abwicklung sind nicht vollständig implementiert.
Das Ergebnis ist noch keine aktuelle App-Empfehlung.

## Datenvertrag für die spätere App-Verdrahtung

Der Host erstellt eine separate Eingabekopie aus dem aktuellen Snapshot
und gültigen tatsächlichen Ergänzungen. Szenarioannahmen gehören in diesen
aktuellen Pfad nicht hinein. Er setzt `context.current_year`,
`context.snapshot_year` und `context.as_of` aus dem Bewertungsauftrag und
dem tatsächlich verwendeten Datensatz. Diese Felder sind keine vom Betrieb
frei editierbaren Bewertungsparameter. Der Lab-CLI prüft ihre Kohärenz;
die Auswahl der tatsächlich aktuellen Daten bleibt Aufgabe von P1/P2.

| Eingabe | Bedeutung und erforderliche Verbindung |
| --- | --- |
| `farm.year`, `context.*` | Aktuelles Förderjahr, Snapshot und Prüfdatum; kein stiller Vorjahresfallback. |
| `farm.heuwirtschaft.contract_start_year`, `first_year.*` | Gültiger bestehender Vertrag und datierte Erstjahresnachweise. Folgejahre übernehmen keine heutigen RGVE als damaligen Nachweis. |
| `land.parcels_complete`, `livestock.species_groups_complete` | Bestätigte Vollständigkeit des effektiven Datenbestands. Importexistenz allein reicht nicht. |
| `land.parcels[]` | Stabile Schlag-ID, Fläche, Nutzungsart, Österreich-/Antragsbezug; Mahddaten sind Beobachtungen im Prüfjahr bis zum Stichtag. |
| `livestock.species_groups[]` | Stabile Gruppen-ID, Art und geschlossene RGVE-Kategorie aus `data/tables.json`; Alters-/Größenklasse explizit zuordnen. `other` mit bekannter Kategorie kann Wild/Neuweltkamele repräsentieren. |
| `average_count`, `animal_count` | Quellengebundener Durchschnitt bzw. Stichtagsbestand; kein ungeprüfter Wechsel bei Rindern. |
| `farm.heuwirtschaft.*` | Aktuelle tatsächliche Angaben zu Silage, Gärung, Grünfütterung, Abgabe und Option; Null/fehlend bedeutet unbekannt, `false` bedeutet ausdrücklich verneint. |
| `operations.full_mowing_and_removal`, `full_grazing` | Gesonderter jährlicher Bewirtschaftungsnachweis; ein einzelnes Mahddatum beweist keine vollflächige Mahd oder Abfuhr. |
| `exceptions.recognitions[]` | Tatsächlicher AMA-Anerkennungsbezug samt Pflicht, Jahr, Zeitraum und bei Schlagpflichten IDs. Keine Zukunftsabsicht und keine allgemeine Schätzung über Anerkennung. |

Jeder eingabefähige Pfad benötigt im App-PR eine Registry-Zuordnung und eine
Consumption-Dependency zum jeweiligen Rego-Check. Herkunft, Übersteuerung,
Rücknahme und Veraltung müssen im dortigen DecisionTrace erscheinen.
`missing_data` enthält die hier tatsächlich konsumierten fehlenden Pfade;
ein registriertes Feld ohne diese Verbindung wäre noch keine Integration.
Typfehler, doppelte IDs und unmögliche Beobachtungsdaten werden vor OPA als
Eingabefehler abgelehnt. Fehlend und Null bleiben dagegen echte Datenlücken.

Die drei Slice-Statuswerte unterscheiden Erfüllung, bekannte Nichterfüllung
und fehlende Fakten. Jahrespflichten werden vor ihrem Jahres-/Saisonende
als offene Hinweise geführt. Eine passende Anerkennung stellt die betroffene
Verletzung zur fachlichen Rechtsfolgenprüfung, ohne andere Verletzungen zu
unterdrücken oder eine günstige Gesamtentscheidung vorzutäuschen.

## Herkunft und Grenzen

`citations.json` bindet die wichtigsten Reparaturen an PDF-Seite und
wörtlichen Beleg. Tests prüfen diese Belege und sämtliche gebundenen
Quellen-/Upstream-Hashes. Die RGVE-/Prämiensätze wurden wertgleich aus dem
Luna-Quelleninventar übernommen; nur Kategorie-, Arten- und
Durchschnittsmetadaten sind ergänzt. Die Tabellenwerte sind keine
editierbaren Betriebsfakten.

Der Kandidat ersetzt den kompletten Maßnahmen-/Studienpfad nicht. Die
Rechtsfolgen höherer Gewalt und die Ermittlung der fachlichen
Grünfütterungsangabe brauchen Review. Zweijährige Bergmähderbewirtschaftung
und die im Ergebnis genannten gemeinsamen Förderregeln bleiben außerhalb
dieses Slice. #97 bleibt für diese fachlichen und App-Abnahmen offen.
