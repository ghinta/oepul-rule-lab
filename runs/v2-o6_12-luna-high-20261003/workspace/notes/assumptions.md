# Annahmen und offene Punkte

- Das Canonical Farm Profile ist ein Schema-Template und enthält keine konkreten Betriebswerte. Im Modus `discover` werden deshalb die maßnahmenspezifischen Eingaben in `rules/profile_changes.json` vorgeschlagen; das Canonical Profile selbst bleibt unverändert.
- Für Rego werden die vorgeschlagenen Felder unter `input.farm.measures.o6_12` und den flächenbezogenen `operations`-Feldern verwendet. Die bestehende Profilstruktur enthält weder Teilnahme-/Fristfelder noch die nötigen Insektizid-Ausnahme- und Dokumentationsmerkmale.
- Die 2026-Dürre-Hinweise vom 22.05., 05.08. und 12.08. nennen keine Änderung der o6_12-Verpflichtung. Ihre sachlich nicht einschlägigen Ausnahmen wurden daher im Coverage-Ledger als `not_rule` dokumentiert.
- Die 12.06.2026-Mitteilung unterscheidet zwischen einem genehmigten rückzahlungsfreien Ausstieg und dem Verbleib in der Maßnahme bei behördlich angeordnetem Einsatz. Die beiden Pfade sind im Regelkatalog getrennt modelliert.
- `other_explicitly_marked_combinations` in der Datenstruktur bewahrt die in der Anhang-L-Zeile sichtbaren Maßnahmencodes; die Fußnote zum Organismen-Zuschlag wird als Prämienabschlag bei der Kombination mit o6_12 interpretiert. Die Anhang-L-Fußnoten 1, 2 und 4 betreffen andere Maßnahmen bzw. Kulturtypen und wurden nicht als zusätzliche o6_12-Entscheidung modelliert.
