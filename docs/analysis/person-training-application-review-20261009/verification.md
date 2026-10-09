# Block 6: Prüfung und Grenzen

Reviewdatum 09.10.2026, Europe/Vienna; Basis-Draft
`59a8a98e43b53b934ba1c66a429533ba1ae7f967`, historische Quellen
`7a296d28cb5b92e2758c5a3889c929ea1db60fe5`, App-main
`5296108f5756ef1463c25a49d93d4a346e9b5e9c`.

Die gezielte Prüfung verbindet vorhandene Einzelprüfungen; keine neue
Vollgenerierung oder behauptete vollständige heutige Normabdeckung.
Maschinenlesbares Ergebnis: [verification.json](verification.json).
Das [unabhängige Review](independent-review.json) hat keine offenen Befunde.

- 271 unterschiedliche lokale Originalfundstellen aus 29 Dateien: wörtlicher
  Match über `OriginalSources` und `normalize_evidence`, tatsächliche physische
  PDF-Seite sowie SHA-256 und Bytegleichheit zum historischen Quellenpin.
- 88 belegte Teilscopes verbinden alle 26 Maßnahmen. Allgemeine Vertrags-
  scopes sind als solche markiert und erhalten maßnahmenspezifische Ausnahmen.
  Die Jahreslabel-Frage ist auf die konkret verglichenen Tiermaßnahmen begrenzt.
- 114 vorhandene fachliche Frageverweise: 69 direkte Fragen und 45 begrenzte
  Querverweise. Das sind nicht 114 eigenständige Kurs-/Antragsfragen. Alle
  ursprünglichen 289 Fragen sind bytegleich zum Basiscommit, weiter offen und
  unbeantwortet. Sämtliche acht o6_3-Blocker werden nach exakter ID-Menge,
  Anzahl und offenem Status geprüft. Die fünf echten externen UBB-IDs sind
  anhand des unveränderten Issue140-Textes geprüft; keine davon ist eine
  vorhandene spezifische UBB-Trainings-ID.
- Acht App-Vertragsbeobachtungen, 58 exakte Zeilenanker und 26 Dateihashes:
  referenzierte lokale Blobs entsprechen dem frischen App-main-Pin.
- Acht aktuelle synthetische Policyfälle mit tatsächlicher unveränderter
  Produktionsprojektion und Query `data.oepul.measure_decision`:
  UBB/BIO/14/17/19 ergeben `eligible`; 2/16/15 ergeben bei gefüllten bisherigen
  Inputs `missing_data`. Personen-/Kurs-/tatsächliche Antragsnachweise fehlen
  in diesen begrenzten Fällen. Kein vollständiges fachliches Golden-Soll.
- Acht MANA-Parameterpaare reproduzieren identische effektive Inputs trotz
  leerer gegenüber gefüllter bestehender MANA-Liste. Produktionsfunktionskörper
  und alle in diesen Fällen erreichten Helper werden unverändert per AST
  isoliert ausgeführt; keine nachgebaute fachliche Entscheidung.
- OPA 1.18.2, offizieller Release und Repositorychecksum:
  `9903e5125ac281104f2c4b7371d10cc3b74a98933743fcbfc174f9bf0ab20de8`.
  Kontextdatum 09.10.2026 ausdrücklich simuliert. Native o6_3-Route nicht in
  diesen acht generischen Runtimefällen enthalten; ihre Grenzen sind separat
  anhand Code und erhaltenen Fachblockern dokumentiert.
- Ein zusätzlicher technischer UBB-Grenzfall mit 3,0 ha Acker und 0,21 ha DIV
  ist in [technical-followup.json](technical-followup.json) getrennt reproduziert.
  Aktuelle Basis-Policy liefert `not_eligible`; der Zahlenvertrag wird als
  eigene Folgearbeit geprüft. Keine Fachantwort oder Appkorrektur daraus abgeleitet.
- Lokale Markdownlinks und Inventarintegrität geprüft. Der bestehende
  CI-Workflow prüft Repository-/Validator-/Originalquellen-/OPA-Guards am
  Ergänzungscommit; er ersetzt keine individuelle aktuelle Normprüfung.

Die lokale Fundstellenprüfung lässt sich mit dem bestehenden Checker wiederholen:

```python
import hashlib, json
from pathlib import Path
from tools.review_o6_1c_variable_review import OriginalSources

report = Path("docs/analysis/person-training-application-review-20261009")
checker = OriginalSources()
for quote in json.loads((report / "evidence.json").read_text())["local_quotes"]:
    assert hashlib.sha256(Path(quote["source_path"]).read_bytes()).hexdigest() == quote["source_sha256"]
    checker.check_quote(quote, "quote")
```

Mit einem App-Checkout am genannten Pin und per Repositorychecksum verifizierter
OPA-Binary lassen sich die gespeicherten effektiven Inputs erneut ausführen:

```python
import json, subprocess
from pathlib import Path

report = Path("docs/analysis/person-training-application-review-20261009")
# app_policy: backend/policy/oepul_measures.rego im App-Checkout am genannten Pin.
# opa_binary: offizielles OPA 1.18.2 mit oben angegebenem Releasehash.
for case in json.loads((report / "policy-observations.json").read_text()):
    raw = subprocess.check_output(
        [str(opa_binary), "eval", "--format=json", "-d", str(app_policy),
         "--stdin-input", "data.oepul.measure_decision"],
        input=json.dumps(case["input"]).encode(),
    )
    assert json.loads(raw)["result"][0]["expressions"][0]["value"] == case["result"]
```

Acht aktuelle Onlinebeobachtungen sind datierte Ergänzungen, keine im Repository
gespeicherten Quelldateien mit behaupteten Hashes. Vollständiger AMA-Meldeartikel
02.09.2026 und GWA-Hinweis09.07.2026 sind gelesen; ausgewählte aktuelle SRL-Passagen
bestätigen den HUM-Wortlautkonflikt und die eigenständige UBB-Option2027.
Die sicher extrahierte vollständige Anbieter-Maßnahmen-Matrix sowie individuelle
aktuelle Betriebs-/Kurs-/Antrags-/Übernahmenachweise fehlen weiterhin. Der
2024-Abfragestand wird nicht als aktueller Datenstand ausgegeben.

Keine HTTP-/Datenbank-/Browser-E2E-Prüfung, keine Modellqualitätsmessung,
keine Fachfreigabe, keine App-/Canonical-/Thesisänderung und kein Merge.
