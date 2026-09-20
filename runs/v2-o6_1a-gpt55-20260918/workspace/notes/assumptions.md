# Annahmen und offene Punkte für o6_1a

- Fehlende Eingabevariablen wurden im discover-Modus in `rules/profile_changes.json` vorgeschlagen; `canonical_farm_profile.json` blieb unverändert.
- Feldstückspflichten werden in Rego über aggregierte `land.field_blocks[]` geprüft. Eine spätere Implementierung kann diese Werte aus Schlag-/GIS-Daten berechnen.
- Die 2026-Dürregebietskulisse kombiniert die Hinweise vom 05.08.2026 und 12.08.2026.
- Phänologische Vorverlegung wird als Eingabeparameter modelliert, weil die verlinkte Vorverlegungskarte nicht Teil der Quellenkopie ist.
- Die genaue fachliche Kürzungshöhe bei Verstößen bleibt ein Bewertungsakt nach Schwere, Ausmaß, Dauer und Häufigkeit und ist hier als Sanktionsrahmen katalogisiert.
- Die technische Validierung wurde mit dem bereitgestellten Validator und OPA 1.18.2 im Docker-Modus abgeschlossen; Formatierung, Strict-Compile und alle 7 generierten Tests bestehen.
