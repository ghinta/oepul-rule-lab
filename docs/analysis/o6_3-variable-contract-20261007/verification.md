# Verifikation

Lab-Basis `0760684b5029d65feeca984bf627a3c6269a9955`, App-Referenz
`14e5422b9977f78eb2f7edfb99313e4aac39f9a7`.
Branch `codex/issue-136-o6-3-contract`.

Lokal bestanden: 89 Repository-Tests (9 neue), 11 Validator-Tests,
Dossier-Check samt echtem App-Checkout-Abgleich, OPA 1.18.2 fmt/strict check
und 3/3 direkte OPA-Tests. Die zehn Dossier-Inputs werden zusätzlich zu den
bisherigen Quellenfällen durch echtes OPA ausgewertet. Python-Compilecheck
und `git diff --check` bestehen.

```bash
PYTHONPATH=src python3 tools/validate_o6_3_contract.py
PYTHONPATH=src python3 tools/validate_o6_3_contract.py --app-root /path/to/pinned/app
PYTHONPATH=src OPA_BIN=/path/to/pinned/opa python3 -m unittest discover -s tests -v
PYTHONPATH=src python3 -m unittest discover -s runner/validation/tests -v
python3 runner/validation/opa_validate.py validate --workspace adaptations/o6_3 \
  --runtime local --opa-bin /path/to/pinned/opa --target policy --target data \
  --target tests --result-json /tmp/issue136-validation.json --pretty
```

Der offline ausführbare Dossier-Check prüft die gebundenen Lab-/Quellenhashes,
alle 46 nativen Schema-Eingabepfade, 17 Regelgruppen, 46 genaue PDF-Belege,
20 RGVE-Koeffizienten sowie die Zuordnung zu den versionierten App-CSV-Dateien.
Der optionale App-Checkout-Abgleich prüft zusätzlich den exakten Commit und
Dateiinhalt der Registries, Dependencies und beteiligten Adapter/Services.

Neun neue Tests prüfen die Integrität sowie konkrete Fehlerfälle: fehlender
Inputpfad, unzutreffend behaupteter App-Verbrauch, Durchschnitt als GVE-Alias,
fehlender Quellenbeleg und falscher kleiner-Equiden-Faktor. Entfernte oder
stillschweigend geschlossene Promotionsblocker werden ebenfalls abgelehnt. Der OPA-Test
reproduziert alle zehn synthetischen Entwicklungsinputs und ihre dokumentierten
Beobachtungen. Alle bisherigen Lab-/Validator-/OPA-Gates bleiben erforderlich.

CI enthält einen expliziten Dossier-Check und führt die neuen Tests über die
bestehende Testsuche aus. Ergebnisse und exakter geprüfter PR-Head werden in
der PR-Beschreibung dokumentiert. Kein App-Testlauf wird für unveränderten
App-Code behauptet; die Prüfung betrifft dessen gebundenes Referenzinventar.

Gegenprüfung der für 08.10.2026 angekündigten Opus-Revisionen und die
fachlichen/integrativen Promotionsblocker sind ausdrücklich ausstehend.
