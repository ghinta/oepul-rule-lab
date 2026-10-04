# Annahmen und offene Punkte

- Die RGVE-Tabelle wird vollständig aus Anhang A übernommen. Rotwild, Damwild und
  anderes Zuchtwild sind dort zwar aufgeführt, die Maßnahme nennt als zulässige
  Kategorien aber nur Rinder, Schafe, Ziegen, Equiden und Neuweltkamele. Daher
  bleiben die Wildkategorien Datenbestand, sind aber keine zulässigen o6_15-Kategorien.
- Die Rego-Prämienfunktion bildet die im Maßnahmenblatt ausgewiesenen Sätze ab.
  Eine vollständige Aufteilung auf mehrere Hirtinnen/Hirten und mehrere Almen
  benötigt die jährlichen Alm-/Weidemeldungen einschließlich der zeitanteiligen
  Tierbewegungen. Diese Variablen werden im Discover-Profil vorgeschlagen.
- Der Regeltext lässt offen, wie eine Hirtin oder ein Hirte bei mehreren Tierkategorien
  technisch einer Alm/Gemeinschaftsweide-Auftriebsliste zugeordnet wird. Die
  Ein-Person-eine-Alm-Bedingung wird deshalb als eigener Input modelliert.
- Die AMA-Informationsblätter sind laut Impressum rechtlich unverbindlich; die SRL
  ist für die rechtlich verbindlichen Kernregeln maßgeblich. Die Merkblätter werden
  trotzdem als operative Auslegung und Nachweisquelle erfasst.
- Die 2026-Dürre-Mitteilungen begründen keine allgemeine o6_15-Ausnahme. Sie
  nennen fehlende Wasserversorgung auf Almen lediglich als möglichen Anlass für
  einen einzelbetrieblichen Antrag auf höhere Gewalt.
- Die Discover-Felder liegen unter den vorhandenen Profilobjekten `farm`,
  `land.parcels` und `livestock.species_groups`; die repräsentativen Objektfelder
  stehen für die jeweiligen wiederholbaren Datensätze und sind keine Änderungen
  an `canonical_farm_profile.json`.
- Die Milchviehprämie wird getrennt nach den ersten 20 und den weiteren RGVE
  berechnet. Für eine vollständige Mehr-Alm-/Mehr-Hirten-Abrechnung müssen die
  jährlichen Meldungen die Tierbewegungen und die Herderzuordnung auflösen.
- Die Betriebsgrößenmodulation wird als fachliche Regelkatalogaussage erfasst.
  Die konkrete kombinierte Alm-Basis (Almfläche beziehungsweise aufgetriebene
  RGVE nach den jeweiligen Fördergrenzen) ist in den bereitgestellten
  o6_15-Profilfeldern nicht vollständig bestimmbar.
