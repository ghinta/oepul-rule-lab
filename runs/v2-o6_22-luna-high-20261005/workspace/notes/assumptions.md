# Annahmen und offene Punkte

- Der Run arbeitet im Modus `discover`. Das Canonical Farm Profile wurde nicht
  verändert; fehlende o6_22-Eingaben sind ausschließlich als Vorschläge in
  `rules/profile_changes.json` erfasst.
- Die Maßnahmenquelle liegt als Stand Oktober 2025 vor. Die Sonderrichtlinie
  und ihre Anhänge liegen als Fassung vom 11. Oktober 2024 vor. Wo beide
  Quellen dieselbe Verpflichtung beschreiben, wird die verbindliche
  Sonderrichtlinie für die Rechtsgrundlage und das Merkblatt für die
  ausführungserklärenden Details verwendet.
- Die in den Maßnahmeninformationen genannte gesetzliche Ausnahme für die
  Gruppenhaltung von Sauen wird nicht selbst aus der 1. THVO rekonstruiert,
  weil diese Rechtsquelle nicht im bereitgestellten Quellenumfang enthalten
  ist. Die Ausnahme ist als explizite Bedingung abgebildet und auf das
  Merkblatt zurückgeführt.
- Die vier 2026-Hinweise behandeln Biodiversitätsflächen, Insektizidverzicht
  Wein/Obst/Hopfen, Dürre-Ernte- und Begrünungsregeln sowie andere Maßnahmen.
  Sie enthalten keine Änderung für Tierwohl – Schweinehaltung. Deshalb sind
  die geprüften einschlägigen Abschnitte als `not_rule` in der Coverage-Ledger
  dokumentiert und nicht als o6_22-Regeln erfunden.
- Die Freiland-Regelung wird im Rego mit dem vorhandenen Behördenhöchstwert
  oder, wenn dieser fehlt, mit 4 GVE/ha geprüft. Die alternative Koppelung
  über die gesamte im Haltungszeitraum verfügbare Fläche bleibt fachlich
  offen und muss als Eingabemodell ergänzt werden, falls sie maschinell
  separat bewertet werden soll.
- Prämienwerte werden in `data/o6_22_tables.json` vollständig für die im
  Merkblatt genannten Kategorien und Zuschläge geführt. Eine spätere
  Betriebsgrößenmodulation ist eine allgemeine Berechnung über der
  maßnahmenbezogenen Prämie und wird deshalb als eigene Katalogregel geführt.
- Zwischen der geschlossenen Tierlisten-Aufzählung auf Seite 2 (dort werden
  „Ältere Sauen nicht gedeckt“ unter der Kategorie der Zuchtsauen genannt) und
  der Einordnung auf Seite 7 (ungedeckte Jungsauen sowie ausgemerzte
  Zuchttiere bis zur Deckung bzw. Ausmerzung unter „Jung- und Mastschweine“)
  besteht eine auslegungsbedürftige Spannung. Die Regel
  `o622.sows.category_transition` bildet die ausdrückliche Übergangsregel auf
  Seite 7 ab; die Datenliste bewahrt zugleich die auf Seite 2 vollständig
  abgedruckte Tierlistenliste. Eine behördliche Klärung der Bezeichnung
  „Ältere Sauen nicht gedeckt“ bleibt offen.
