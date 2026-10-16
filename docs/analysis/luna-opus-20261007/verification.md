# Verifikation

Grundlage: PR #95 und PR #96 sind gemergt; `main` enthält den finalisierten
Luna-o6_3-Run und das unveränderte Original-Log. Dessen vollständiger
SHA-256 bleibt `c3c943a1a2b7164f6b1f3ae899b2c5db8a36543f9e14c1cfd990b589907a8f1d`.

26 gepaarte Maßnahmen; Ausgangsprofil und Coverage-Quellenhashes identisch.
Regel-/Testzahlen gegen die gebundenen Kandidaten geprüft.

Aus dem Repository mit lokalem OPA 1.18.2:

```bash
python3 docs/analysis/luna-opus-20261007/review_o6_3.py \
  --repo . --opa /absolute/path/to/opa \
  --output /tmp/o6_3-probes.json
```

Alle sieben Fälle wurden erfolgreich von OPA ausgeführt. Die beobachteten
fachlichen Abweichungen stehen in `assessment.md`; erfolgreicher
Prozessabschluss bedeutet nicht, dass ein Kandidat alle Sollbedingungen
erfüllt. Policy-/Datenhashes und beide Eingabeformen stehen im Ergebnis.

Die Auswertung verwendet ausschließlich synthetische Eingaben. Sie führt
keine Modellgenerierung aus und verändert keine Run-Artefakte.
