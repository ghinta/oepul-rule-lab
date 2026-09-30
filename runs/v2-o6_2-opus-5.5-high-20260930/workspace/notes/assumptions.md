# Annahmen und offene Fragen – o6_2 „Einschränkung ertragssteigernder Betriebsmittel“

Run: `v2-o6_2-opus-5.5-high-20260930` (Modus `discover`)

## Eingabemodell

- Die Rego-Regeln (`policy/o6_2/*.rego`, Paket `oepul.o6_2`) lesen das Canonical Farm Profile
  plus die in `rules/profile_changes.json` vorgeschlagenen Ergänzungen (u. a. `farm.oepul`,
  `livestock.nitrogen`, `livestock.species_groups[].rgve_key_id`, `land.parcels[].oepul_codes`,
  `land.parcels[].operations.fertilizer.inputs`, `land.parcels[].operations.psm_applications`).
- Maßnahmen werden in `farm.oepul.participating_measures` und `land.parcels[].parcel_measures`
  mit den SRL-Nummern (`1A`, `1B`, `2`, `16`, …) angegeben, weil Anhang L diese Codes verwendet.
- Die Parzellenkategorie wird aus `land_use`, `crop.crop_category` und `crop.crop_name`
  abgeleitet. Ackerfutter und Obst werden über den Kulturnamen gegen die geschlossenen Listen
  in `data/o6_2_inputs_and_crops.json` erkannt (Vergleich ohne Groß-/Kleinschreibung). Eine
  Obstanlage mit einem nicht gelisteten Kulturnamen gilt als nicht prämienfähig.
- Fehlende optionale Felder werden zugunsten des Betriebes ausgelegt (z. B. fehlender Ernteanteil
  = kein Verstoß; fehlender Kontrollverweigerungs-Flag = keine Verweigerung). Nur ausdrücklich
  negative Angaben lösen Ausschlüsse aus. Ausnahme: `psm_used = true` auf Grünland/Ackerfutter
  ohne Details erzeugt einen Prüfhinweis (`review_items`), keinen Verstoß.

## Fachliche Auslegungen

1. **Tierhaltereigenschaft / Besatzstufe:** „RGVE/ha“ in der Prämientabelle wird als RGVE je ha
   Futterfläche (Grünland + Ackerfutter) ausgelegt, wie bei der 0,30-Schwelle. Almweideflächen
   (`land_use = alpine_pasture`) zählen nicht zur Futterfläche.
2. **Stichtag der Tierhaltereigenschaft:** Die Tierzahl (`animal_count`) wird als bereits nach
   der vorgeschriebenen Methode ermittelt übernommen (Rinderdatenbank-Durchschnitt bzw.
   Stichtag 1. April / Durchschnittstierliste). Betriebsstrukturwechsel (O6_2-LIVESTOCK-009) sind
   vorab in der Tierzahl zu berücksichtigen.
3. **Stickstoffgrenze 170 kg N/ha:** Die Bezugsfläche ist die Summe der Parzellen in Österreich
   ohne Almweideflächen (Alm-N wird separat abgezogen). Der N-Anfall nach Stall- und
   Lagerverlusten wird als Eingabe erwartet; die Berechnung aus Tierbestand und
   N-Anfallsfaktoren liegt nicht in den Quellen und ist nicht implementiert.
4. **Organische Rückstände und Klärschlamm** werden unabhängig von der Herkunft als unzulässig
   behandelt, weil das Informationsblatt sie ohne Einschränkung als unzulässig bezeichnet.
   Eigener, nicht nach VO (EU) 2018/848 zulässiger Kompost und eigene Biogasgülle gelten als
   nicht betriebsfremd und damit zulässig. Unbekannte, betriebsfremde, N-haltige Mittel gelten
   als unzulässig.
5. **Saatgutbeizung:** Sie zählt als flächige Anwendung. Die Ausnahme für ausschließlich
   Bio-zulässige Wirkstoffe wird auch auf die Beizung angewendet (das Blatt sagt „daher nicht
   zulässig“ nur in Bezug auf die Einordnung als flächig).
6. **PSM-Verbot bei Ackerfutter als Zweitkultur:** Das Verbot gilt für die tatsächliche
   Ackerfutterkultur auch dann, wenn diese als Zweitkultur beantragt wurde. Die
   Zweitkultur-Regel betrifft laut Quelle nur Prämie und Futterfläche.
7. **Bio-Kombination:** Die SRL nimmt Bio-Teilbetriebe allgemein aus; das Informationsblatt
   beschränkt die Ausnahme auf den Kulturbereich Wein, Obst und Hopfen. Implementiert ist die
   engere Fassung des Informationsblatts. **Offen**, ob ein Bio-Teilbetrieb mit Kulturbereich
   Acker/Grünland zulässig wäre (praktisch ausgeschlossen, weil UBB nur Acker/Grünland betrifft).
8. **Nicht kombinierbare Einzelflächen (Anhang L):** Liegt eine Parzelle in einer mit 2
   prämienmäßig nicht kombinierbaren Maßnahme (z. B. 18 Naturschutz, 4 Bergmähder), erhält sie
   keine o6_2-Prämie. Die Verpflichtungen gelten trotzdem gesamtbetrieblich, und die Fläche zählt
   weiter zur Futterfläche. Für die Zelle 2/16 („a“) trifft der Abschlag laut SRL 2.16 die
   Basisprämie von Maßnahme 16, nicht o6_2.
9. **GLÖZ-8-NPF bis 2024:** „keine Ackerfutterflächen-Prämie“ wird als o6_2-Prämie von 0 €/ha
   umgesetzt. **Offen**, ob stattdessen die Ackerflächenprämie zustünde.
10. **Flächenzugang ab 2026:** Welche konkreten Parzellen bei Überschreitung des Zugangs nicht
    prämienfähig sind, regeln die Quellen nicht. Die Kürzung wird als überschießende Fläche mal
    durchschnittlicher Nettoprämiensatz umgesetzt.
11. **Reihenfolge der Kürzungen:** Umgesetzt ist die Reihenfolge inhaltliche Sanktion →
    Modulation → Obergrenze je Schlag → Zugangskürzung (Ausschnitt aus SRL 1.12.2). Die übrigen
    Kürzungsarten (Über-/Untererklärung, Fristversäumnis, Konditionalität) sind nur als
    Datenliste abgebildet, da keine Eingaben existieren. `other_area_payments_eur_per_ha` wird als
    bereits modulierter Betrag angenommen.
12. **Sanktionsstufe:** Die Einstufung (Schwere, Ausmaß, Dauer, Häufigkeit) nimmt die AMA vor. Das
    Regelwerk übernimmt die Stufe als Eingabe und bestimmt daraus den Kürzungssatz; ab 2027 wird
    „Verwarnung“ als Einbehalt von 1 % umgesetzt.
13. **Weiterbildung:** Stunden mehrerer anrechenbarer Kurse werden summiert. Der Verstoß wird ab
    Antragsjahr 2025 gemeldet, wenn bis 31.12.2025 weniger als 3 anrechenbare Stunden vorliegen.
    Für 2025 kann das vor Jahresende noch vorläufig sein.
14. **Modulation:** Bezugsgröße ist `land.total_area_ha` (sonst die Summe der Parzellen ohne Alm).
    Almbewirtschaftung und Behirtung werden getrennt moduliert und sind hier nicht relevant.
15. **Dürre 2026:** Die Gebietskulisse wird über Bundesland und Bezirk der Parzelle (sonst des
    Betriebes) geprüft. Die Einschränkung auf „üblicherweise im Spätsommer oder Herbst geerntete
    Ackerkulturen“ ist als Eingabe-Flag umgesetzt, weil die Quelle keine Kulturliste nennt.
16. **Maßnahmenbezogene OP-Codes:** Die Quellen nennen keinen o6_2-spezifischen OP-Code. Nur `OP`
    (und `VF`) schließen die o6_2-Prämie aus. Codes wie `OPUBB`/`OPBIO` (Trockenheits-Hinweis
    vom 22.05.2026) betreffen nur UBB/BIO und lassen o6_2 unberührt.
17. **Bagatellgrenze 50 €:** Als Kann-Bestimmung umgesetzt (`payout_may_be_waived`), nicht als
    automatische Nullsetzung.

## Nicht automatisierte (prozedurale) Regeln

O6_2-OBL-PSM-CODE-003, O6_2-OBL-TRAIN-005, O6_2-COMB-CORR-001, O6_2-PREM-CODE-003,
O6_2-EXIT-002, O6_2-LIVESTOCK-009 und O6_2-GEN-KOND-001 sind im Katalog belegt, haben aber keine
Rego-Symbole, weil Zeitpunkte von Meldungen und Korrekturen, AMA-Aufforderungen oder
Konditionalitätsprüfungen im Profil nicht abgebildet sind.

## Quellenumfang

- Das Informationsblatt o6_2, die Allgemeinen Teilnahmebedingungen und die vier 2026-Hinweise
  wurden vollständig geprüft. Die Hinweise vom 12.06.2026 (Rebzikade/Insektizidverzicht) und die
  Biodiversitäts-, Begrünungs-, Naturschutz- und Nutztierrassen-Teile betreffen andere Maßnahmen
  (Coverage `not_rule`).
- Sonderrichtlinie: Allgemeiner Teil vollständig, Maßnahmenteil gezielt (2.2 sowie Fundstellen zu
  Maßnahme 2 auf S. 44, 77, 92). Anhänge: A (GVE-Schlüssel) und L (Kombinationstabelle). Die
  Zeile 2 von Anhang L wurde über die Koordinaten der PDF-Textelemente rekonstruiert, weil die
  Textextraktion Leerzellen nicht erhält; Zeile und Spalte 2 stimmen überein.
- Die GSP-AV (u. a. § 6 höhere Gewalt, §§ 42–48 Kürzungen) und das MOG 2021 lagen nicht vor.
  Verweise darauf sind als Querverweise erfasst, aber nicht inhaltlich implementiert.
