# Annahmen und offene Fragen – o6_17 „Humuserhalt und Bodenschutz auf umbruchsfähigem Grünland“

Run: `v2-o6_17-opus-5.5-high-20261010`, Modus `discover`.

## Fachliche Auslegungen

1. **Grundprämie nur unter 18 % Hangneigung.** Kapitel 1 des Informationsblatts sagt „ab dem
   Antragsjahr 2025 wird auch eine Hangneigung ab 18 % gefördert“. Die Prämientabelle (Kapitel 8)
   und SRL 2.17 („ab dem Antragsjahr 2025 auch für artenreiche Grünlandflächen mit einer
   Hangneigung >= 18 %“) sehen ab 18 % aber nur den AGL-Zuschlag (162 €/ha) vor. Umgesetzt ist:
   Grundprämie nur < 18 %, AGL ab 2025 auch >= 18 %.
2. **Grenze der Grünlandzahl.** Im Informationsblatt heißt die erste Stufe „bis 20“, die zweite
   „ab 20 bis unter 30“; die SRL schreibt „< 20“ bzw. „>= 20 und < 30“. Verwendet ist die
   SRL-Abgrenzung: Grünlandzahl 20 fällt in die zweite Stufe.
3. **Prämiensätze 2023 und ab 2024.** Für 2023 gelten die Sätze der Spalte „2023“, ab 2024 die
   Sätze „ab 2024“ (SRL: „Prämiensätze gelten ab 01.01.2024“).
4. **AGL-Obergrenze.** Die Obergrenze ist max(15 % bzw. 25 % des gemähten Grünlands; 2,00 ha).
   Wie die AMA kürzt, wenn die Obergrenze überschritten wird, ist nicht beschrieben. Umgesetzt
   ist ein proportionaler Flächenfaktor über alle AGL-Schläge (auch über beide
   Hangneigungsklassen). „Gemähtes Grünland“ sind einmähdige Wiesen, Mähwiesen/-weiden mit
   zwei bzw. drei und mehr Nutzungen und Streuwiesen; Bergmähder, Dauerweiden und Hutweiden
   zählen nicht dazu.
5. **Flächenzugang ab 2026.** Grenze für die prämienfähige Fläche:
   Basis 2025 + max(50 % der Basis; 5 ha). Sie wird als anteiliger Faktor nur auf die
   Grundprämie angewendet; der jährlich beantragte AGL-Zuschlag bleibt unbeschränkt. Als
   aktuelle Maßnahmenfläche dient näherungsweise die grundprämienfähige Fläche. Wie Zugänge
   konkret den Schlägen zugeordnet werden, bleibt offen.
6. **Kombination auf der Einzelfläche (Anhang L).** Ist ein Schlag zusätzlich in einer
   Maßnahme eingebracht, die nicht mit 17 kombinierbar ist (etwa 4, 18, 19, 23, 24), erhält er
   für Maßnahme 17 keine Prämie. Welche Maßnahme die AMA in diesem Fall tatsächlich bevorzugt,
   ist offen. Der Code `1B_TB` (BIO-Teilbetrieb) wird für Anhang L wie `1B` behandelt.
   Die Spaltenzuordnung von Zeile 17 wurde mit `pdftotext -layout` rekonstruiert; der
   einfache Seitentext verliert die Spaltenpositionen.
7. **Maßnahmenspezifischer OP-Code.** Für Maßnahme 17 nennen die Quellen keinen eigenen
   OP-Code. Ausgewertet werden nur `OP` und `VF`; maßnahmenbezogene Codes anderer Maßnahmen
   (z. B. OPUBB) schließen 17 nicht aus.
8. **Weiterbildung.** Die 5 Stunden werden je Person summiert (mehrere Kurse derselben
   Person); Stunden verschiedener Personen werden nicht addiert. Ein Verstoß wird ab dem
   Antragsjahr 2025 gemeldet, wenn die Bedingungen nicht erfüllt sind. Ob die Prüfung erst nach
   dem 31.12.2025 erfolgt, wird nicht unterschieden. Der Kursinhalt wird nur über
   `topic == grassland` geprüft; die Pflichtthemen laut SRL sind nicht einzeln modelliert.
9. **Bodenproben.** Die Basisfläche wird im Antragsjahr 2025 aus den Schlägen berechnet
   (Grünland < 18 %, ohne GLÖZ 2/4/9). Ab 2026 muss sie als Eingabe
   `farm.oepul.o6_17.soil_sample_basis_area_ha` vorliegen, sonst wird sie als fehlende Eingabe
   gemeldet. „Pro angefangene 5 ha“ ist als ceil(Fläche / 5) umgesetzt, nach Rundung auf drei
   Nachkommastellen (Beispiele: 4,90 → 1; 10,40 → 3; 10,00 → 2). Ob eine Probe dem richtigen
   Mehrfachantrag zugeordnet ist (Ziehungsjahr), wird nicht geprüft.
10. **Landwirtschaftliche Nutzfläche für den 40-%-Anteil.** Summe der Schläge mit
    `land_use` arable, grassland und special_crop; Almweiden und `other` sind ausgeschlossen.
    Für die Betriebsmindestgröße werden zusätzlich Almweiden und geschützter Anbau gezählt;
    GLÖZ-Landschaftselemente, K20-Flächen und Mehrnutzenhecken sind nicht modelliert.
11. **Tierbestand.** `animal_count` gilt bereits als maßgeblicher Bestand
    (Rinder-Durchschnittsbestand, Stichtag 1. April bzw. Durchschnittstierliste). Die
    RGVE-Zuordnung erfolgt über `rgve_category`; das Feld `species` des Profils wird nicht
    verwendet. Unbekannte Kategorien werden als fehlende Eingabe gemeldet.
12. **Kennarten.** Gezählt werden unterschiedliche Kennarten. Eine Kennart mit mehreren
    wissenschaftlichen Arten (z. B. Schlüsselblume: Primula elatior, P. veris) zählt einmal.
    Zuordnung über ID, deutschen Namen (auch ohne Klammerzusatz) oder wissenschaftlichen Namen.
    Abweichungen zwischen den Quellen sind in den Daten festgehalten, ohne Einfluss auf die
    Entscheidung:
    - Ehrenpreis: Informationsblatt „Wegerichgewächse“, Anhang H „Löwenmaulgewächse“.
    - Taubenkropf-Leimkraut: Informationsblatt „Nelkengewächse“; in Anhang H steht es laut
      Tabellenlayout im Block „Schmetterlingsblütler“ (vermutlich ein Layoutfehler).
    - Schreibweise „Karthäuser-Nelke“ im Informationsblatt, „Kartäuser-Nelke“ in Anhang H.
13. **Erhebungszeitpunkt.** Anhang H nennt „jedenfalls vor dem 30. Juni“, das
    Informationsblatt nur „sinnvoll … im Mai und Juni“. Beides ist als Empfehlung erfasst und
    nicht als Fördervoraussetzung umgesetzt. Geprüft wird nur, dass mindestens eine Erhebung
    im Antragsjahr stattfand.
14. **Nicht maschinell prüfbare Methodik.** Diagonale, Startpunkt 5 m innerhalb des Schlages,
    2 m breiter Streifen, Regelmäßigkeit der Verteilung und eindeutige Bestimmung sind
    dokumentiert, aber nicht in Rego geprüft. Rego prüft nur die eingegebenen Abschnitte.
15. **Mindestbewirtschaftung.** Die Prüfung der jährlichen Mahd oder Beweidung erfolgt erst,
    wenn `operations.season_completed == true` ist. Damit wird vermieden, dass während des
    Jahres fälschlich Verstöße gemeldet werden. Flächen mit DIV-Codes sind ausgenommen.
16. **Sanktionsstufen.** Die Ausgangsstufe eines Verstoßes legt die AMA nach ihrem internen
    Schema fest (`findings[].base_stage`). Die Policy wendet darauf Wiederholungserhöhung,
    Kumulation (höchstens 100 %), den Einbehalt von 1 % ab 2027 und den Ausschluss nach
    zweimaliger 100-%-Kürzung an.
17. **Prämienobergrenze je Schlag (1.300 €/ha).** Überschreitungen werden nur markiert. Wie
    die Kürzung auf die Maßnahmen aufgeteilt wird, ist in den Quellen nicht beschrieben. Die
    Reihenfolge der Mehrfachkürzungen (SRL 1.12.2) ist als Regel dokumentiert; in Rego sind
    nur Modulation und Flächenfaktoren berechnet.
18. **Vorzeitiger Ausstieg.** Nur `exit_reason == voluntary` (Standardwert) löst die
    Rückforderung aller seit Vertragsbeginn gewährten Prämien aus. Höhere Gewalt, dauerhafte
    Umstände und die Revisionsklausel lösen sie nicht aus. Eine Abmeldung im Antragsjahr macht
    den Vertrag für dieses Jahr inaktiv.
19. **Dürre 2026 (Ernteverpflichtung).** Die Ausnahme betrifft Ackerflächen und damit über die
    Kombinationsverpflichtung (UBB/BIO) auch Betriebe in Maßnahme 17. Die Einschränkung auf
    „Ackerkulturen, die üblicherweise erst im Spätsommer oder Herbst geerntet werden“ ist nicht
    eigens modelliert. Sie gilt als erfüllt, wenn `no_harvestable_crop_due_to_drought == true`
    ist. Bezirksnamen müssen exakt der Schreibweise der AMA-Hinweise entsprechen.
20. **Übrige 2026-Hinweise.** Biodiversitätsflächen UBB/BIO, Insektizidverzicht, Begrünung,
    Erosionsschutz, Naturschutz/Natura 2000 und gefährdete Nutztierrassen betreffen andere
    Maßnahmen und sind im Coverage-Ledger als `not_rule` begründet.
21. **Fristverschiebung bei Wochenende.** § 5 Abs. 2 GSP-AV schließt den Maßnahmenantrag
    (31.12.) von der Verschiebung aus; die Frist ist daher strikt umgesetzt. Für die
    Übernahmefrist (15. April bzw. 17. April) ist keine Verschiebung implementiert. Ob § 5
    Abs. 1 dort gilt, bleibt offen.
22. **Bergmähder.** Für die Grundprämie sind sie nicht ausdrücklich ausgeschlossen. Die
    Kombination mit Maßnahme 4 auf der Einzelfläche ist laut Anhang L aber nicht möglich. Vom
    AGL-Zuschlag sind Bergmähder ausgeschlossen.
23. **Kleinbetragsgrenze.** Bei ≤ 50 € „kann“ von der Gewährung abgesehen werden. Das wird nur
    markiert (`below_minimum_payout`); der Betrag wird nicht auf null gesetzt.
24. **Mindestgröße 50 m².** § 27 Abs. 2 GSP-AV ist pro Schlag (`area_ha >= 0,005`) umgesetzt.

## Technische Hinweise

- Die Tabellen liegen unter `data/o6_17_tables/` (Namensraum `data.o6_17_tables`), damit sie
  nicht mit dem Policy-Namensraum `data.oepul.o6_17` kollidieren.
- Alle `evidence_text`-Ausschnitte wurden geprüft: Sie stehen auf der angegebenen Seite in der
  seitenmarkierten `.txt`-Datei (auf einer Zeile) und im Text der PDF-Seite (`pdftotext`).
  HTML-Belege kommen wörtlich im HTML-Quelltext vor.
- Jeder Quellenbeleg in `rules/citations.json` wird von mindestens einer Regel verwendet.
  Abschnitte ohne Regelgehalt (Aktualisierungen, 2026-Hinweise zu anderen Maßnahmen) sind
  nur im Coverage-Ledger als `not_rule` mit Begründung erfasst.
- Bei HTML-Quellen (2026-Hinweise) bleibt `pages_reviewed` leer, weil sie keine Seiten
  haben; ihre Abschnitte sind als `notice`-Einträge erfasst.
- Tabellen mit Schlüssel-Wert-Struktur (`grassland_use_types`, `rgve_key/categories`) liegen
  als Arrays von Objekten mit Feld `id` vor. So entspricht `row_count` der Anzahl der
  Tabellenzeilen; Rego baut die Nachschlagetabellen per Comprehension auf.
