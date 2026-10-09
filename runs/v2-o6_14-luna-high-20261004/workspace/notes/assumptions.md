# Fachliche Annahmen und offene Punkte

- Das Canonical Farm Profile enthält keine Almobjekte, Almauftriebsbewegungen,
  RGVE-Alterskategorien, Erschließungsstufen, Projektbestätigungen oder
  Auftriebsmeldungen. Die fehlenden Variablen sind deshalb ausschließlich in
  `rules/profile_changes.json` vorgeschlagen; das Canonical Profile bleibt
  unverändert.
- Die Rego-Eingabe verwendet `gve` als bereits anhand des 1.-Juli-
  Altersstichtags berechneten RGVE-Wert. Die vollständige Faktor-Tabelle aus
  Anhang A ist trotzdem als Datenbestand hinterlegt, damit die vorgelagerte
  RGVE-Berechnung reproduzierbar ergänzt werden kann.
- Bei Tieren, die zwischen mehreren Almen wechseln, erwartet die ausführbare
  Regel bereits die je Alm aufgeteilten `alpung_days` und `alm_id`. Die Quelle
  verlangt eine anteilige Berechnung; die konkrete Datenmodellierung der
  Meldungen ist eine offene Integrationsfrage.
- Für Anhang E wird der aus der Projektbestätigung übergebene Code als
  prämienrelevanter Satz modelliert. Ob mehrere Codes auf derselben Fläche
  additiv oder nach der konkreten Projektbestätigung ausschließend anzuwenden
  sind, wird von den vorliegenden Quellen nicht abschließend beschrieben und
  muss bei der Abwicklung geklärt werden.
- Der allgemeine Hinweis vom 22.05.2026 nennt fehlende Wasserversorgung auf
  Almen als Beispiel für ein Ansuchen auf höhere Gewalt. Er begründet keine
  automatische Anerkennung; die Rego-Regel bildet daher nur den belegten
  Antragstatbestand ab.
- Die drei 2026-Hinweise vom 05.08. und 12.08. betreffen Acker-Begrünung,
  Acker-Ernte, Untersaaten, Acker-Biodiversität, Naturschutz und gefährdete
  Nutztierrassen. Sie verändern keine unmittelbar auf o6_14 anwendbare
  Almauflage; sie sind in `rules/coverage.json` als geprüft und nicht
  maßnahmenrelevant dokumentiert.
