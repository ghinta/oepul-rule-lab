# Fachliche Mehrdeutigkeiten und Modellannahmen

- Das Canonical Farm Profile enthält keine maßnahmenspezifischen Tierkategorien,
  Einzeltiermeldungen, Weidetagebücher, optionale 150-Tage-Auswahl oder
  gekoppelten Almstützungsbezug. Diese Eingaben werden im Discover-Modus als
  Erweiterungsvorschläge dokumentiert; der Rego-Code behandelt fehlende Werte
  nicht als erfüllte Verpflichtung.
- `weide_days` und `average_rgve` sind im vorgeschlagenen o6_20-Block bereits
  ermittelte, prüffähige Eingabewerte. Die Quelle beschreibt die Berechnung über
  den Zeitraum 1. April bis 31. Oktober mit 214 Tagen und die anteilige
  Berücksichtigung von Zugängen/Abgängen; eine Ereigniszeitleiste ist im
  Canonical Profile nicht vorhanden.
- Die Quelle unterscheidet bei Rindern zwischen automatisch aus der
  Rinderdatenbank ermittelten Tieren und bei anderen Kategorien beantragten
  Tieren. Die Rego-Schnittstelle bildet das Ergebnis dieser jeweiligen
  Ermittlung als `animals`/`animal_count` und die zugehörigen Meldeflags ab.
- Die 2026-Dürre-Meldung schafft für `o6_20` keine pauschale Aufhebung der
  Weideverpflichtung. Sie verlangt lediglich, dass die besondere Situation bei
  Vor-Ort-Kontrollen, insbesondere beim Grundfutterbedarf auf der Weide,
  berücksichtigt wird. Das wird als Kontrollkontext und nicht als automatische
  Förderfähigkeit modelliert.
- Die HTML-Meldungen zum Insektizidverzicht, zur Ernteverpflichtung auf
  Ackerflächen und zu anderen Maßnahmen enthalten keine Änderung der
  o6_20-Weidefristen oder Prämienberechnung und werden im Coverage-Ledger als
  geprüft, aber nicht maßnahmenrelevant ausgewiesen.
