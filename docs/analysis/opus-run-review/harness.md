# Wiederholbare technische Prüfung der Einzelberichte

Die Werkzeuge prüfen Bindung, Vollständigkeit des Prüfverzeichnisses und
Reproduzierbarkeit. Sie ersetzen das Lesen der Quellen und die fachliche
Einzelfallprüfung nicht. Fehlgeschlagene Quellenerwartungen sind dokumentierte
Befunde; ein erfolgreicher Replay bestätigt ihre Reproduktion, keine
fachliche Freigabe. Es entstehen keine Modellaufrufe, Scoreboards oder
Änderungen an historischen Regeln, Profilen und Quellen.

Die eingefrorene Auswahl sind die 26 Einträge des bereits veröffentlichten
Screening-Manifests mit SHA-256
`575194a57dd09e52b52adc05de229abc7584414b32b5fadef36a9b83d4368f55`
am Kandidaten-Commit `e009eed4a83ff076b26eba33ac433ac2b0642621`.
Für jeden Run werden sämtliche veröffentlichten Run-Dateien, die exakt in
`run.json` bezeichneten Originalquellen, das Canonical Profile und die
Repository-Pins geprüft. Die Erzeugung einer Bindung behauptet keine
abgeschlossene Quellenlektüre.

```bash
python3 docs/analysis/opus-run-review/audit_runner.py --measure o6_1b --candidate-root /workspace/scratch/opus-candidates-source --bind
python3 docs/analysis/opus-run-review/audit_runner.py --measure o6_1b --candidate-root /workspace/scratch/opus-candidates-source --opa /tmp/issue-51-review-opa --write
python3 docs/analysis/opus-run-review/audit_runner.py --measure o6_1b --candidate-root /workspace/scratch/opus-candidates-source --opa /tmp/issue-51-review-opa --verify
python3 docs/analysis/opus-run-review/audit_runner.py --all --candidate-root /workspace/scratch/opus-candidates-source --opa /tmp/issue-51-review-opa --verify
python3 tools/validate_opus_run_review.py --candidate-root /workspace/scratch/opus-candidates-source --opa /tmp/issue-51-review-opa
```

`--bind` schreibt ausdrücklich `measures/<measure>/binding.json`; `--write`
schreibt ausdrücklich `observations.json`. `--verify` und der Validator
schreiben keine Prüfdateien. Alle Ausgabeorte liegen außerhalb des
unveränderten Kandidaten-Worktrees. Der erste Bericht unter
`../opus-o6-1a-audit-20261015` behält sein ursprüngliches Format und seinen
eigenen Replay. Der gemeinsame Validator prüft ihn ohne Umschreiben.

`--all --verify` liest dieselbe Queue in ihrer festgelegten Reihenfolge,
prüft deren Status und Bindungen und reproduziert ausschließlich bereits
abgeschlossene Dossiers. Ausstehende oder laufende Maßnahmen werden einzeln
mit ihrem Status als übersprungen ausgegeben und getrennt gezählt. Sie
werden weder ausgeführt noch als abgeschlossen markiert. Für den ersten
Run wird ausdrücklich sein ursprünglicher `replay.py --verify` verwendet.
`--all` ist mit `--measure` unvereinbar und erlaubt weder `--bind` noch
`--write`. Eine abgeschlossene Quellenprüfung bedeutet auch bei einem
Bericht ohne Sperrbefund keine Expertenfreigabe oder App-Promotion.

Die neue `development-probes.json` verwendet diese Form:

```json
{
  "measure_id": "o6_1b",
  "run_id": "v2-o6_1b-opus-5.5-high-20260925",
  "query": "data.oepul.o6_1b.result",
  "source_evidence": {},
  "allowed_queries": [],
  "cases": [{
    "case_id": "source-derived-case",
    "input": {},
    "source_ids": [],
    "expectations": [{"operator": "status_equals", "expected": "defined"}]
  }]
}
```

Das Beispiel beschreibt nur das Format und ist kein fachlicher Testfall.
Jeder echte Fall erhält eine ausdrückliche Quellenbegründung. `query` darf
pro Fall überschrieben werden. Ein einfacher Datenpfad im Namespace der
Maßnahme oder die exakt veröffentlichte Screening-Abfrage ist erlaubt.
Zusammengesetzte Abfragen und Funktionsaufrufe müssen zusätzlich wörtlich in
`allowed_queries` stehen. Diese versionierte Datei ist vertrauenswürdiger
Prüfcode, keine Schnittstelle für beliebige externe Nutzereingaben. Ihr
vollständiger Byte-Hash bindet auch Abfragen und Quellenbegründungen.

Erwartungen unterstützen `equals`, `contains_rule`, `excludes_rule` und
`status_equals`. Ausgabepfade sind Arrays mit Objekt-Schlüsseln oder
ganzzahligen Array-Indizes. Numerische Werte werden in Python unabhängig
verglichen: `1` und `1.0` sind gleich, `false` und `0` bleiben verschieden,
auch in verschachtelten Objekten. Fehlende Ausgabefelder haben
`actual_absent: true`; ein vorhandenes `null` wird als `actual: null`
erhalten. `undefined`, `runtime_error` und `process_timeout` haben keine
erfundene Ausgabe. Ein definiertes `null` enthält dagegen ausdrücklich
`output: null`. Ursprüngliche OPA-Fehler bleiben im Ergebnis erhalten.

Die Ausführung verwendet ausschließlich die im Manifest verzeichneten
Originaldateien aus `policy/` und `data/`, keine historischen Selbsttests
oder neu geschriebenen Policy-Ergänzungen. Jede Kopie wird erneut gehasht.
Die Verzeichnisse werden genau wie im ursprünglichen Screening als
`--data bundle/policy --data bundle/data` geladen. Einzelne JSON-Dateien
als getrennte Ladeziele würden den aus Unterverzeichnissen entstehenden
OPA-Namespace verändern und können irreführendes `undefined` erzeugen.
OPA wird gegen den **exakten historischen SHA-256-Pin** geprüft. Seine
ursprünglichen Ergebnisse, einschließlich möglicher Laufzeitfehler,
werden weder korrigiert noch normalisiert. `opa check --strict`,
`--strict-builtin-errors`, 10 Sekunden Evaluierungsgrenze und 20 Sekunden
Prozessgrenze gelten. Die Capabilities sperren Netzwerk, aktuelle Zeit,
Zufall und Runtime-Metadaten (`http.send`, `net.lookup_ip_addr`,
`time.now_ns`, `uuid.rfc4122`, `rand.intn`, `opa.runtime`; `allow_net: []`).
Deterministische Datumsfunktionen bleiben für historische Fristen verfügbar.

Vor jedem Einzel-`--write`/`--verify` und jedem Batch-Replay reproduziert
ein technischer Preflight deshalb die vollständige, bereits veröffentlichte
BIO-Baseline aus dem Screening. Die Referenzdatei ist zusätzlich durch
SHA-256 `0524f1d079bd06744b1a877f23af3c2adf0ff4c124146c6ba588e4fc7b8d4658`
gebunden. Verglichen wird das gesamte native Objekt einschließlich
`compliant: false`, der vier Verstöße und der 400 Euro Transaktionskosten.
Diese frühere Ausgabe ist ausschließlich eine technische
Reproduktionsreferenz, kein fachlicher Sollwert. Der Preflight bleibt
getrennt von den Quellenfällen und erhöht deren Anzahl nicht. Er wurde
zusätzlich mit einer nur im Speicher simulierten Rückkehr zum falschen
Einzeldatei-Lader geprüft und wies diese Regression ab. Die ursprünglichen
rein synthetischen Eingabe-/Ausgabetypkontrollen hatten diese
Verzeichnissemantik nicht abgedeckt.

Ein abgeschlossener neuer Bericht hat `audit.json` mit `measure_id`,
`run_id`, `status` sowie `coverage`. `coverage.rule_ids` muss alle IDs aus
`rules/rules.json` enthalten, `coverage.profile_change_paths` jede einzelne
Profiländerung (mehrere Vorschläge am selben Pfad bleiben mehrfach
enthalten), `coverage.tables` alle Paare `{path,json_pointer}` aus
`rules/data_inventory.json` und `coverage.source_paths` alle gebundenen
Originalquellen. Tabellen werden auch bei verschachtelten JSON-Pointern
vollständig nach dem historischen Katalog gezählt. Inhaltliche Bewertungen,
Quellenstellen, Befunde und offene Fragen gehören zusätzlich in die
Fachberichte; bloßes Auflisten ist keine semantische Prüfung.

Die Queue erlaubt `individual_source_audit_pending`,
`individual_source_audit_in_progress` (auch `in_progress`), `source_audit_completed` und
`source_audit_completed_blocked`. Abgeschlossene Berichte müssen einen
zusammenhängenden Anfang bilden; nur die nächste Maßnahme darf in Arbeit
sein. Der Validator macht aus ausstehenden Einträgen keine abgeschlossenen
Prüfungen. Mit `--measure o6_1b` prüft er neben der gesamten Queue nur dieses
abgeschlossene Dossier; ohne Einschränkung prüft er alle abgeschlossenen
Dossiers. `--opa` schaltet zusätzlich deren unveränderten Replay ein.

Technische Prüfung des Werkzeugs am 15. Oktober 2026: Eine ausschließlich
temporäre synthetische Fixture prüfte definiertes `null`, fehlendes Feld,
`false` gegenüber `0`, verschachtelte typgetreue Gleichheit, `undefined`
und einen ursprünglichen Division-durch-null-Fehler. Zwei Ausführungen mit
dem gepinnten OPA ergaben identische Bytes. Doppelte JSON-Schlüssel,
`NaN` und nicht ausdrücklich zugelassene zusammengesetzte Abfragen wurden
abgewiesen. Der unveränderte erste Bericht wurde mit seinem ursprünglichen
Replay erfolgreich reproduziert (43 Fälle, 55 Erwartungen, davon 27
erfüllt); seine 166 Regel-, 67 Vorschlags- und 53 Tabelleneinträge wurden
gegen die historischen Kataloge geprüft. Die Bindungs- und Katalogleser
wurden außerdem strukturell mit allen 26 Manifest-Einträgen geprüft. Dieser
letzte Schritt ist ausschließlich eine Format-/Identitätsprüfung und zählt
keine weitere Maßnahme als fachlich geprüft.

Der Batch-Replay reproduzierte anschließend den ersten abgeschlossenen
Bericht und gab die übrigen 25 Einträge ausdrücklich als übersprungen aus.
Vier ungültige Batch-Aufrufe (Schreiben, Binden, fehlende OPA-Binary und
gleichzeitige Einzel-/Gesamtauswahl) wurden abgewiesen. Sechs temporäre
Manipulationskontrollen prüften die Ablehnung einer geänderten Abfrage,
falschen Maßnahmen-/Run-Identität, doppelter Fall-IDs, eines Austauschs von
`false` gegen `0` in Belegen und eines Austauschs von `1` gegen `true` in
Zählwerten. Der gemeinsame Validator prüft diese Metadaten auch ohne
erneute OPA-Ausführung; für neue Dossiers müssen `measure_id` und `run_id`
in der Fixture ausdrücklich vorhanden sein.

## Verfasserteile gemeinsam sammeln

```bash
python3 docs/analysis/opus-run-review/collect_review.py --measure o6_1b --candidate-root /workspace/scratch/opus-candidates-source
python3 docs/analysis/opus-run-review/collect_review.py --measure o6_1b --candidate-root /workspace/scratch/opus-candidates-source --complete
```

Der Sammler verarbeitet `core.json`, `general.json`, `measure.json`,
`tables.json` und `inputs.json` im Maßnahmendossier. Er schreibt
`audit.json`, `development-probes.json` und `collection-provenance.json`.
Er führt OPA nicht aus und ändert die gemeinsame Queue nicht. Ohne
`--complete` bleibt der Bericht `in_progress`. Ein ausdrückliches
`--complete` verlangt alle fünf Teile und vollständige, exakt passende
Regel-, Vorschlags- und Tabellenverzeichnisse. Fehlende Einträge werden
aus dem historischen Katalog erkannt, niemals aus ihm ergänzt. Zusätzliche
oder doppelte Katalogeinträge und doppelte Fall-IDs werden abgewiesen.
Mehrere Bewertungen derselben Regel bleiben vollständig erhalten; der
allgemeine/rechtliche Teil dient zuerst zur Navigation, gefolgt von
Maßnahmen-, Kern-, Tabellen- und Eingabeteil. Daraus wird kein gemeinsames
fachliches Urteil berechnet.

Der Abschlussstatus lautet standardmäßig `source_audit_completed_blocked`.
Mit `--completed-status source_audit_completed` kann ausdrücklich ein
anderer Abschlussstatus gesetzt werden. Beide bezeichnen nur den
abgeschlossenen Prüfdurchgang. Ein Reviewer muss den gemeinsamen
Queue-Eintrag anschließend gesondert prüfen und ändern. Bestehende
Beobachtungen werden bei einer veränderten Fixture ungültig und müssen
ausdrücklich neu erzeugt werden; der Sammler überschreibt sie nicht.

Erwartungen, Eingaben, Quellenbelege und Fall-IDs werden aus den
verfassten Proben übernommen. Zusammengesetzte Abfragen werden wörtlich
zugelassen. Frühere Ausführungsfelder (`observed*`, `exit_code`, `status`,
`execution_status`, `output`, `native_result`, `stderr`) werden aus der
Ausführungsfixture entfernt. Die Ursprungsdatei, der JSON-Pointer und ein
Hash der entfernten Felder bleiben im Provenienzbericht gebunden.
Frühere Ausgaben werden nie zu Sollwerten umgewandelt. Auch abweichende
oder überlappende Befunde bleiben einzeln ihren Verfasserteilen zugeordnet.

`audit.json` bindet die fünf Teile, Bindungsdatei, Fixture und Provenienz
mit SHA-256. Der gemeinsame Validator prüft zusätzlich, dass sämtliche
Bewertungen, Befunde, Vorschlags-/Tabellenpfade und Ausführungsfälle
tatsächlich unverändert aus diesen Teilen stammen. Ein bloßes manuelles
Auffüllen der Fall- oder Regelverzeichnisse reicht für einen gültigen
Abschluss nicht. Die vollständige Quellenlektüre bzw. die Wiederverwendung
nach identischem Quellenhash bleibt in den ursprünglichen Leselogs
nachvollziehbar; die Bindung selbst bestätigt nur Identität.

Der Sammler wurde zunächst ausschließlich mit temporären Kopien der
fünf BIO-Teile geprüft: 200 eindeutige Regeln mit 214 Bewertungen, 89
Profilvorschläge, 92 Tabellen, 43 verfasste Befunde und 105 Proben.
Überlappende Bewertungen blieben erhalten; wiederholtes Sammeln erzeugte
identische Bytes. Ein fehlender Eingabeteil verhinderte den Abschluss.
Dies ist Werkzeugvalidierung und kein zusätzlicher fachlicher Prüffall.
Sechs zusätzliche temporäre Negativkontrollen bestätigten die Ablehnung
geänderter Teile, verlorener überlappender Bewertungen, veränderter
Sollwerte trotz nachgezogenem Fixture-Hash, fehlender Vorschlags- oder
Tabellenzeilen sowie doppelter Fall-IDs.
