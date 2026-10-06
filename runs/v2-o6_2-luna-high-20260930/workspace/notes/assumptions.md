# Annahmen und offene fachliche Punkte

- Das Canonical Farm Profile ist ein Typ-/Strukturprofil und enthält keine
  konkreten Betriebswerte. Deshalb werden fehlende Mess-, Antrags- und
  Dokumentationsfelder im Discover-Modus als Vorschläge in
  `rules/profile_changes.json` geführt.
- Die ausführbare Rego-Schnittstelle verwendet die im Discover-Vorschlag
  ergänzten direkten Profilpfade wie `farm.compliance`, `farm.training`,
  `farm.forage_area_ha`, `land.parcels`, `livestock.species_groups`,
  `region` und `program`. Diese Felder werden nicht in das Canonical Farm
  Profile eingetragen, sondern ausschließlich in
  `rules/profile_changes.json` vorgeschlagen.
- Für die RGVE-Berechnung wird `livestock.species_groups[].category` als
  stabiler Schlüssel in die vollständige Anhang-A-Datentabelle interpretiert.
  Die Kategorie muss Alter, Größenklasse und gegebenenfalls Pferderasse
  bereits eindeutig abbilden.
- Die allgemeine Richtlinie nennt den Vertragszeitraum bis 31.12.2028 und die
  Maßnahme 2 als mehrjährig. Die Maßnahmenseite nennt für 2023--2025 die
  konkreten Restlaufzeiten. Ein späterer Einstieg nach 2025 wird deshalb als
  unzulässig modelliert.
- Die 2026-Dürrehinweise betreffen teilweise andere Maßnahmen. Nur die
  Ernteausnahme für Ackerflächen sowie die ausdrücklich verknüpften
  Biodiversitätsausnahmen werden dem o6_2-Katalog zugeordnet; die übrigen
  Abschnitte sind im Coverage-Ledger als `not_rule` dokumentiert.
- Die HTML-Hinweise haben keine PDF-Seiten. Ihre Quellenbelege verwenden daher
  `page: null` und die jeweilige Artikelüberschrift als Abschnitt.
- Die 170-kg-N-Grenze wird als bereits berechneter Wert nach Stall- und
  Lagerverlusten modelliert. Die konkrete fachliche Berechnung der
  Wirtschaftsdüngermenge liegt außerhalb des gelieferten Canonical Profiles.
- Die Regel O62-R39 übernimmt die im Hinweis ausdrücklich genannte zusätzliche
  Bedingung für DIVSZ (zweite Mahd auf vergleichbaren Schlägen). Weitere
  phänologische Vorverlegungen werden nicht auf o6_2 übertragen.
- Die Profilergänzungen verwenden für die bereits im Canonical Profile
  vorhandenen Objektlisten ausschließlich Blattpfade mit repräsentativen
  Objektwerten; Array-Container werden nicht als `...[]`-Ziel geändert. Für die
  Rego-Schnittstelle wird außerdem ein root-level `region`-Objekt ergänzt,
  weil das Canonical Profile die Regionsdaten unter `farm.region` verschachtelt,
  die ausführbaren Regeln aber `input.region` auswerten.
- O62-18 ist als `O62-18-TXT` auf die vorbereitete PDF-Quelle mit dem
  wörtlichen Beleg auf Seite 4 verknüpft. Der Suffix `-TXT` bleibt als stabile
  Referenz-ID erhalten; Quelle, SHA-256 und Seitenangabe sind nun konsistent.
