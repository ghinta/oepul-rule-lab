# Annahmen und offene Punkte

- Die Rego-Entscheidung ist bewusst nur für die beobachtbaren, numerisch prüfbaren Kernpflichten vollständig deterministisch. Fehlende `input.oepul`-Beobachtungen ergeben keine Zustimmung, sondern `missing_oepul_observations`.
- Die in `data/o6_1b_reference_data.json` enthaltenen geschlossenen Listen wurden aus den Tabellen des Maßnahmenblatts übernommen. Die Policy prüft derzeit die messbaren Mischungsschwellen; eine Artenmitgliedschaft einer konkreten Saatgutmischung benötigt zusätzlich eine Liste der tatsächlich verwendeten Arten.
- Die 2026-Trockenheitsausnahmen ändern nicht die reguläre Förderfähigkeit: vorzeitige Nutzung bzw. die dritte Nutzung erfordert OPBIO und führt auf der betroffenen Fläche zu keiner BIO-Prämie. Die Regeln sind deshalb als fachliche Ausnahme im Katalog und nicht als positive Rego-Eligibility modelliert.
- Die Mitteilung vom 12. Juni 2026 betrifft die eigenständige Maßnahme Insektizidverzicht Wein, Obst und Hopfen. Sie begründet keine abweichende BIO-Verpflichtung und ist im Coverage-Ledger als nicht maßnahmenrelevant dokumentiert.
