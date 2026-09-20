# DRAFT: `o6_11` mit `gpt-5.6-luna`

Dieser Snapshot dokumentiert einen Discover-Lauf für die Maßnahme
`o6_11` – Herbizidverzicht Wein, Obst und Hopfen – mit dem Modell
`gpt-5.6-luna` und hoher Reasoning-Einstellung.

Die maßnahmenspezifische Quelle ist das AMA-Merkblatt mit Stand April 2026.
Der Run enthält außerdem die beim Lauf bereitgestellten allgemeinen
Teilnahmebedingungen, Rechtsgrundlagen und amtlichen Hinweise des Jahres 2026.

## Ergebnis

- 26 strukturierte Regeln
- 36 Quellenbelege
- 9 Profiländerungsvorschläge mit 32 ergänzten Profilpfaden
- 1 Datenartefakt mit 8 Tabellen bzw. geschlossenen Listen
- Rego v1 mit 7 bestandenen OPA-Tests
- Grounding-Validierung ohne Fehler

Während der unabhängigen OPA-Prüfung wurden ein falscher Datenimport, eine
unsichere Variablenbindung und undefinierte False-Zustände technisch repariert.
Außerdem wurde eine zunächst nur zitierte allgemeine Betriebsmindestgröße als
eigene belegte Regel samt Profilvorschlägen und Tests ergänzt.

## Status

**DRAFT – technisch validiert, nicht fachlich freigegeben.** Compile-Erfolg,
Grounding und selbst erzeugte Tests belegen keine vollständige fachliche
Richtigkeit. Kopierte Quellen und rohe Modellprotokolle sind nicht Teil dieses
Git-Snapshots; ihre Hashes und Herkunft bleiben in den Run-Metadaten erhalten.
