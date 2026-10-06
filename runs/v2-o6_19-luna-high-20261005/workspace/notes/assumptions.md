# Fachliche Annahmen und offene Punkte

- Das Canonical Farm Profile enthält keine Maßnahmengruppe. Die Discover-Vorschläge in `rules/profile_changes.json` ergänzen ausschließlich fehlende Eingabevariablen; `canonical_farm_profile.json` wurde nicht verändert.
- Die Projektbestätigung ist die maßgebliche Quelle für die tatsächlich ausgewählten Indikatoren je Schlag. Anhang K ist deshalb als vollständiger Katalog und nicht als Behauptung modelliert, dass jeder Indikator auf jedem Schlag zugleich gilt.
- Die Platzhalter `$1`, `$2` und `$NEO` im extrahierten Anhang-K-Text sind projekt- bzw. lebensraumspezifische Parameter. Sie wurden nicht geraten oder durch Profilwerte ersetzt. Die Policy prüft daher die vom Projekt bestätigten Ergebnisfelder und nutzt die Tabelle als geschlossene Code-/Textliste.
- Für die EBW-Flächenstilllegung wurde die Formulierung „maximal 25 %, jedenfalls 2,00 ha“ als `max(25 % der Ackerfläche, 2 ha)` operationalisiert. Die Rechtsquelle nennt die Mindestgarantie, aber keine alternative Berechnungsformel.
- Die Prämientabelle enthält in der Quelle für einzelne Kombinationen `/`; diese Kombinationen werden als `null` im Datenkatalog geführt und nicht als förderfähig angenommen.
- Die allgemeinen Biodiversitäts-Dürreausnahmen vom 22.05.2026 und 12.08.2026 werden für EBW nicht als Freigabe interpretiert: Der 12.08.2026-Hinweis sagt ausdrücklich, dass zusätzlich in EBW eingebrachte Acker-Biodiversitätsflächen weiterhin nach der Projektbestätigung zu bewirtschaften sind.
- Der 12.06.2026-Hinweis zum vorzeitigen Ausstieg aus dem Insektizidverzicht Wein/Obst/Hopfen und die nicht maßnahmenspezifischen Abschnitte der 05.08.2026- bzw. 12.08.2026-Hinweise sind in `rules/coverage.json` als `not_rule` dokumentiert.
- Die HTML-Quellen haben keine PDF-Seiten. Ihre Quellenbelege verwenden deshalb `page: null` und den HTML-Abschnitt als Locator.
