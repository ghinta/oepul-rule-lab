# o6_15: unveränderte Modellnotizen

Sämtliche Modellannahmen sind unbestätigt. Auch nicht einzeln priorisierte Auslegungen müssen vor Übernahme geprüft werden.

## luna: `v2-o6_15-luna-high-20261004`

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


## opus: `v2-o6_15-opus-5.5-high-20260926`

# Annahmen und offene Fragen – o6_15 Tierwohl – Behirtung

Run: `v2-o6_15-opus-5.5-high-20260926`, Modus `discover`.

## Quellenkonflikte und Rechenfehler

1. **Beispiel 2 (Informationsblatt, Kap. 9, S. 8) – Rechenfehler bei Alm B.**
   Das Blatt nennt für „Hirte Alm B: 20 RGVE × 81,0 € + 30 RGVE × 27,0 €“ den
   Betrag 2.295,0 €. Rechnerisch sind es 2.430,0 € (2.295 € entspricht 25 RGVE ×
   27 € aus Beispiel 1). Die Policy rechnet korrekt; die Gesamtprämie beträgt
   daher 12.669,6 € statt der ausgewiesenen 12.534,6 €
   (Test `test_example2_total_uses_correct_arithmetic`). Beim Hundezuschlag steht
   außerdem der Tippfehler „1,200,0 €“ (gemeint 1.200,0 €).
2. **Modulationsbeispiel (Allgemeine Teilnahmebedingungen, S. 20).** Für 230 RGVE
   wird der Faktor 98,66 % genannt. Nach dem angegebenen Schema (200 × 100 % +
   30 × 90 %) / 230 ergibt sich 98,70 %. Die Policy verwendet die Formel
   (Test `test_modulation_factor`).
3. **Pferdegrößenklasse.** Das Informationsblatt schreibt „über 1,48 m **oder**
   über 300 kg“, Anhang A „über 1,48 m **und/oder** über 300 kg“. Beide
   Formulierungen sind gleichwertig; die Eingabe erfolgt als Boolean
   `equid_large_breed`.

## Auslegungsannahmen in der Prämienberechnung

4. **Zuordnung der Milchvieh-RGVE zu den Hirtenblöcken.** Die Quellen regeln
   nur, dass die erhöhte Prämie für die ersten 20 RGVE „pro 50 RGVE und Hirtin
   oder Hirte“ gilt. Beispiel 1 (2 Hirten, 40 Milchkuh-RGVE) weist trotzdem nur
   20 Milchvieh-RGVE zum höheren Zuschlag aus. Daraus wird abgeleitet: Die
   Milchvieh-RGVE werden vorrangig in die Blöcke eingerechnet, und der höhere
   Zuschlag gilt nur für die ersten 20 RGVE je 50er-Block
   (`higher_rate_rgve(min(dairy, capped))`). Beide Beispiele werden so exakt
   reproduziert.
5. **Blockbefüllung je Hirtin/Hirte.** Die RGVE werden der Reihe nach auf die
   Hirtinnen und Hirten verteilt, je Person mit höchstens 50 RGVE
   (Beispiel 1: 50 + 45).
6. **Modulationsbasis.** Nach dem Beispiel wird „230 RGVE“ wie „230 ha“
   behandelt. Basis ist je Alm min(aufgetriebene RGVE mit ≥ 60 Tagen,
   Almweidefläche in ha), summiert über alle Almen des Almbetriebs. Offen ist,
   ob bei mehreren Almen je Alm oder für den gesamten Almbetrieb moduliert wird;
   umgesetzt ist die Summe über den Almbetrieb. Optional kann `stocked_rgve`
   direkt eingegeben werden.
7. **Anteilige Anrechnung.** Anteil = anerkannte Tage auf dieser Alm /
   `total_alpine_days_all_herded_alms`. Fehlt dieser Wert, gilt die Alm als
   einzige Alm (Anteil 1).
8. **Stichtag 15. Juli bei Weitertrieb.** Für die Anerkennung „bis 15. Juli
   aufgetrieben“ zählt der Erstauftrieb (`first_drive_up_date`), nicht das
   Umtriebsdatum auf die zweite Alm. Sonst würden die Tiere in Beispiel 2
   (Wechsel nach 66 Tagen, also im August) auf Alm B nicht zählen, obwohl das
   Blatt sie anrechnet.
9. **Verspätete Meldung.** Die anerkannten Alpungstage beginnen frühestens
   14 Tage (Rinder) bzw. 7 Tage (übrige Arten) vor dem Meldedatum. Ob eine
   verspätete Meldung zusätzlich sanktioniert wird, ist nicht geregelt; sie wird
   nur als Verstoß markiert.
10. **Milchkuh ohne Milchvieh-Voraussetzungen.** Eine unter „Milchkühe“
    beantragte Kuh, die die Voraussetzungen nicht erfüllt, bleibt für die
    Behirtungsprämie angerechnet (sie ist behirtet), erhält aber keinen
    Milchvieh-Zuschlag; zusätzlich wird ein Verstoß `o6_15.def.dairy` gemeldet.
    Die tatsächliche Sanktion (Abweichung nach §§ 42–47 GSP-AV) ist offen.
11. **Mehrfach genannte Hirtinnen/Hirten.** Eine Person, die auf mehreren
    Almen angegeben ist, wird nur der ersten Alm (nach `alm_id`) zugerechnet.
    Die Quellen sagen nur, dass die Prämie „nur einmal beantragt“ werden kann.
12. **Mindestteilnahme 3,00 RGVE** wird gegen die Summe der anrechenbaren,
    behirteten RGVE aller Almen geprüft – ohne Deckelung auf 50 RGVE je
    Hirtin/Hirte.
13. **Mindestbestoßung durch hintereinander aufgetriebene Tiere** kann aus den
    Einzeldaten nicht zuverlässig abgeleitet werden (Lücken, Überschneidungen).
    Deshalb wird dafür das Eingabefeld `stocking_days` verwendet.
14. **Rundung.** Beträge und RGVE werden erst im Ergebnis auf 2 Nachkommastellen
    gerundet; die Rundungsregeln der AMA sind nicht angegeben.

## Nicht quantifizierbare bzw. externe Regelungen (unresolved)

15. Die Sanktionshöhe bei Abweichungen von Tieren und Hirtinnen/Hirten
    (§§ 42–47 GSP-AV), die Kürzung bei Fristversäumnis (§ 33 GSP-AV) und
    höhere Gewalt (§ 6 GSP-AV) stehen nicht in den bereitgestellten Quellen.
    Sie sind als Katalogregeln erfasst, aber nicht quantifiziert.
16. **Nationalpark Kalkalpen.** Dort ist Almbewirtschaftung nicht
    prämienfähig. Offen ist, ob die Kombinationsverpflichtung der Behirtung
    trotzdem durch *Teilnahme* ohne Prämie erfüllt ist. Die Policy gibt dazu nur
    einen Hinweis aus.
17. **Landes-Top-up.** Ob ein Bundesland das Top-up gewährt, ist eine externe
    Eingabe (`federal_state_top_up_granted`,
    `federal_state_top_up_notified_by_may_15`). Die Quellen legen nicht fest,
    welche Länder es gewähren.
18. **Konditionalität, Vertragszeitraum über das ganze Jahr, Ausstiegsschranke
    bei angekündigter Vor-Ort-Kontrolle, Revisionsklausel, vorübergehende
    Umstände und verabsäumter Zahlungsantrag** sind nur als Katalogregeln ohne
    Rego erfasst, weil die nötigen Eingaben (Kontrolltermine, Mehrjahresbezug)
    fehlen.
19. **2026-Hinweise.** Nur der Hinweis vom 22.05.2026 enthält einen
    Almbezug (fehlende Wasserversorgung auf Almen als möglicher Fall höherer
    Gewalt). Die Anerkennung ist nicht automatisch; es gibt nur einen Hinweis.
    Die übrigen Hinweise (UBB/BIO-Biodiversitätsflächen, Insektizidverzicht,
    Ernteverpflichtung, Begrünung, Naturschutz, gefährdete Nutztierrassen)
    betreffen andere Maßnahmen. Die verlängerte Haltedauer bei gefährdeten
    Nutztierrassen wird nicht analog auf die Behirtung angewendet.

## Datenmodell

20. Alle almbezogenen Eingaben liegen im neuen Profilbereich
    `alpine_farming` (siehe `rules/profile_changes.json`). Die vorhandenen
    aggregierten `livestock.species_groups` reichen für einzeltierbezogene
    Alpungs- und Meldedaten nicht aus und werden nicht verwendet.
