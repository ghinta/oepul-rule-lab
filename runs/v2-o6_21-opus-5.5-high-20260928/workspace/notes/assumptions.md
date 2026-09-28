# o6_21 „Tierwohl – Stallhaltung Rinder“ – Annahmen und offene Fragen

Run: `v2-o6_21-opus-5.5-high-20260928` · Modus: `discover`

## Quellenlage

- Maßnahmeninformationsblatt (Stand Oktober 2025), Allgemeine Teilnahmebedingungen (Stand April 2026) und
  die vier 2026-Hinweise wurden vollständig gelesen. SRL: Allgemeiner Teil (S. 2–27), Kapitel 2.21 (S. 86–87),
  2.20 (S. 84–85, nur Querverweis), Anhangsübersicht (S. 94). Anhänge: Anhang A (S. 3), Anhang L (S. 103).
- Keiner der 2026-Hinweise ändert die Verpflichtungen von o6_21. Relevant sind nur der allgemeine Weg zur
  Meldung höherer Gewalt (O6_21-GEN-009) und die Klarstellung, dass die Haltedauer-Erleichterung
  (31. August) nur für „Erhaltung gefährdeter Nutztierrassen“ gilt (O6_21-GEN-024).
- **Offen:** Alle vier HTML-Seiten verlinken die Meldung „Meldeverpflichtungen zu tierbezogenen
  ÖPUL-Maßnahmen“ vom 02.09.2026. Sie ist nicht im Quellpaket enthalten und konnte daher nicht geprüft
  werden (Coverage: `unresolved`).

## Fachliche Auslegungen

1. **SRL-Tippfehler „Tierwohl – Weide“ (21):** In der Prämientabelle der SRL ist „Tierwohl – Weide“ mit
   „(21)“ bezeichnet. Das wird als Maßnahme 20 gelesen, in Übereinstimmung mit dem Informationsblatt.
2. **Reduzierter Satz:** Er wird auf die gesamten RGVE des betroffenen Tieres im Förderjahr angewendet,
   nicht nur auf den Alm- oder Weidezeitraum. Die Quellen sagen dazu nichts Näheres. Auslöser sind die
   Tier-Flags `alm_driven`, `tierwohl_weide_participation` und `coupled_support_alm`.
3. **TGD-Schwelle („über 10,00 RGVE an förderbaren Rindern“):** Berechnet wird der Jahresdurchschnitt der
   RGVE aller Tiere in beantragten, nicht ausgeschlossenen Kategorien, vor Abzug abgemeldeter Tiere.
4. **Mindestteilnahme 2,00 RGVE:** Grundlage sind die prämienfähigen RGVE nach Abzug abgemeldeter oder
   ausgeschlossener Tiere. Möglich ist auch die Lesart, dass abgemeldete Tiere mitzählen.
5. **TGD und Qplus:** Laut SRL sind beide Förderverpflichtungen und keine Zugangsvoraussetzungen. Ein
   Verstoß wird als Verstoß ausgegeben, die Prämie wird aber nicht automatisch auf null gesetzt. Die
   Sanktionsstufe legt die AMA fest; sie wird nicht berechnet. `sanction_reduction_percent` ist nur eine
   Nachschlagefunktion für die Stufe.
6. **Stichtage:** `on_farm_until` wird als exklusiv behandelt, der Abgangstag zählt also nicht mehr.
   Lebensalter-Grenzen werden über Geburtsdatum + 6 bzw. 24 Monate berechnet. Die taggenaue Konvention
   der Rinderdatenbank ist nicht dokumentiert.
7. **Wann ein Verstoß zählt:** Maßgeblich ist `housing.conditions_breached_from`, und der Verstoß zählt
   nur, wenn er in das Verpflichtungsfenster einer beantragten Kategorie fällt (Beispiel „Kälber mit
   7 Monaten“). Fehlt das Datum, gilt der Verstoß ab Jahresbeginn.
8. **Stallabteile:** Der Platzbedarf wird je Abteil aus `occupants` berechnet (maximale Belegung inklusive
   geweideter Tiere und Kühe). Ein Verstoß im Abteil wird allen dort verknüpften Tieren zugerechnet. Im
   Informationsblatt-Beispiel (> 500 kg) sind nur die „betroffenen Tiere“ abzumelden – die Abteile sollten
   daher je Gewichts-/Tiergruppe erfasst werden.
9. **Gewichtsklassen:** „bis X kg“ gilt einschließlich X; „ab 500 kg“ bedeutet über 500 kg, weil „bis 500 kg“
   die 500 kg einschließt. Das Belegungsplan-Beispiel mit 25,50 m² wird damit exakt reproduziert.
10. **Kälberschlupf (40 %):** Wird nur im Rahmen der Mutterkuh-/Liegeboxenausnahme geprüft.
11. **Kompostierung:**
    - Die SRL schreibt „und/oder Strauchschnitt“, das Informationsblatt „oder“. Umgesetzt ist: mindestens
      ein Pflanzenmaterial genügt.
    - Die wendefreie Variante mit Beimengung (Informationsblatt, Ergänzung Oktober 2025) steht nicht in der
      SRL. Sie ist ohne Jahresgrenze umgesetzt.
    - „Nennenswertes Ausmaß (z. B. 50:50)“ ist keine harte Schwelle und wird daher als Boolean erfasst.
    - Beim Umsetzen genügt ein Paar von Umsetzvorgängen im Abstand von mindestens 14 Tagen.
12. **Modulation:** „Alle Maßnahmen“ schließt die Tierprämie o6_21 ein. Grundlage ist
    `land.total_area_ha`.
13. **Bagatellgrenze 50 €:** Die Quelle sagt „kann abgesehen werden“. Das wird nur als Flag ausgegeben, die
    Auszahlung wird nicht gestrichen.
14. **Übernahmeliste:** Die Allgemeinen Teilnahmebedingungen (6.3) nennen mehr Zuschläge als SRL 1.7.3.1.
    Die Daten folgen der SRL; o6_21 ist in beiden Listen enthalten.
15. **Ausstieg:** Ein Ausstieg innerhalb des Förderjahres macht das jeweilige Element (Maßnahme, Kategorie
    oder Zuschlag) für dieses Jahr ungültig. Ein Ausstieg mit Datum im Folgejahr lässt das laufende Jahr
    unberührt.
16. **Nicht ausführbar bewertet:** Folgende Regeln sind nur im Katalog erfasst, weil keine prüfbaren
    Eingaben oder AMA-Ermessensentscheidungen vorliegen: SRL 1.7.4.2/1.7.4.3 (bewirtschaftungsverändernde
    Umstände), höhere Gewalt, Doppelförderung, Konditionalität, Revisionsklausel, Reihenfolge der
    Mehrfachkürzungen und die Messvorgaben der Stallskizze.

## Profilvorschläge (`rules/profile_changes.json`)

Das bestehende `livestock.species_groups[]` aggregiert nur Gruppen. Für die Maßnahme werden aber
tierbezogene Daten aus der Rinderdatenbank, abteilbezogene Stalldaten und Maßnahmenangaben gebraucht.
Deshalb werden neue Strukturen vorgeschlagen, statt die bestehenden Felder umzudeuten:

- `livestock.cattle_animals`
- `livestock.stall_pens`
- `livestock.stall_buildings`
- `oepul.o6_21`
- `oepul.controls`
- `farm.applicant`, `farm.dairy`, `farm.programs`

## Technischer Hinweis

- Die Hilfsdateien `rules/_cites_draft.json` und `rules/_src.json` stammen aus der Generierung. Sie gehören
  nicht zu den erlaubten Artefakten. Das Löschen per Tool wurde in dieser Sitzung verweigert; sie sollten
  manuell entfernt werden.
