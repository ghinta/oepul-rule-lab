# Annahmen und offene Fragen – o6_23 Natura 2000 und andere Schutzgebiete – Landwirtschaft

Run: `v2-o6_23-opus-5.5-high-20260928` (Modus `discover`)

## Datenmodell und Eingaben

1. **Profilerweiterungen.** Das Canonical Farm Profile enthält keine schlagbezogenen
   Natura 2000-Angaben. Die Rego-Module lesen deshalb die in `rules/profile_changes.json`
   vorgeschlagenen Pfade (`land.parcels[].constraints.natura2000`, `land.parcels[].oepul`,
   `land.parcels[].eligibility`, `farm.applicant`, `farm.oepul`, `farm.oepul.o6_23`).
   Fehlende Felder werden mit neutralen Defaults ausgewertet (z. B. `located_in_austria`
   = true). Fehlt jedoch `project_confirmation_present`, gilt die Projektbestätigung als nicht vorhanden.
2. **Beantragte Schläge.** Als beantragt gelten nur Schläge mit `n2_code_marked = true`
   (Code N2 in der Feldstücksliste). Schläge mit Projektbestätigung ohne N2 werden nur als
   Befund `project_confirmation_without_n2_code` gemeldet.
3. **Maßnahmenbezogener OP-Code.** Die Quellen nennen keinen konkreten OP-Code für o6_23.
   Analog zu `OPBIO`/`OPUBB` wird `OPN2` angenommen; zusätzlich blockiert der allgemeine Code `OP`.
4. **Düngung.** Eine Düngung liegt vor, wenn `fertilization_applied` gesetzt ist oder
   mineralischer bzw. organischer N-Einsatz > 0 kg/ha gemeldet wird.

## Fachliche Auslegung

5. **Nutzungshäufigkeit bei GI05/GI06/GI07.** Die Auflagentitel nennen „dreimalige
   (bzw. häufigere) / zweimalige / einmalige Nutzung“. Verbindliche Bewirtschaftungsauflage
   laut Anhang I ist das Düngeverbot. Ob die Nutzungsanzahl eine eigenständige,
   sanktionsrelevante Verpflichtung ist, bleibt offen. Abweichungen werden daher nur als Hinweis
   `use_frequency_mismatch` ausgegeben (Nutzungen = Schnitttermine + `grazing_uses`).
6. **Schnittzeitpunktauflagen.** Geprüft wird jeder Schnitttermin gegen den in der
   Projektbestätigung festgelegten frühesten Mahdtermin (`$1`). Die Beweidung vor diesem
   Termin wird nicht geprüft, weil die GL-Auflagen nur die Mahd regeln.
7. **Dürre 2026.** Wird der Schnittzeitpunkt per Landesverordnung geändert, gilt im Jahr 2026
   `earliest_cut_date_state_ordinance_2026`; die Prämie bleibt unverändert. Die generelle
   Freigabe ab 12. August gilt laut Hinweis nur für die Maßnahme „Naturschutz“ und wird für
   N2-Auflagen nicht automatisch angewendet. Die DIV-Ausnahmen (OPUBB/OPBIO) gelten nicht für
   N2-Flächen, weil dort „auch andere Vorgaben“ gelten (analog zum Beispiel Naturschutz).
8. **Kombinationskonflikte.** Liegt auf demselben Schlag eine nicht kombinierbare Maßnahme
   (Anhang L) oder eine Naturschutz-Auflage eines unvereinbaren Kapitels (Anhang J) vor, wird
   für o6_23 keine Prämie auf diesem Schlag berechnet. Welche der beiden Maßnahmen tatsächlich
   entfällt, regeln die Quellen nicht. Dieser Punkt ist offen.
   `1B_TB` (BIO-Teilbetrieb) wird für Anhang L wie 1B behandelt.
9. **Anhang J innerhalb Kapitel G.** Die Kapitelmatrix regelt nur die Kombination zwischen
   Kapiteln. Unvereinbarkeiten innerhalb von Kapitel G (z. B. GI05 mit GA-Auflagen) sind in den
   vorliegenden Quellen nicht tabelliert. Sie werden deshalb nicht geprüft.
10. **Anhang L.** Die Tabelle wurde aus dem PDF-Layout (pypdf, Spaltenpositionen) vollständig
    in `data/o6_23/combinations.json` übernommen. Zeile und Spalte 23 stimmen mit Maßnahmenblatt
    und SRL 2.23 überein (1A, 1B, 2, 18, 19). Bei den übrigen Zeilen ist ein
    Spaltenzuordnungsfehler durch die Textextraktion nicht völlig ausgeschlossen.

## Berechnung

11. **Obergrenzen.** Die Obergrenze wird je Schlag auf den €/ha-Satz angewendet:
    min(Summe N2-Sätze, Obergrenze − sonstige Flächenzahlungen). Die Obergrenze beträgt
    1.500 €/ha, wenn auf dem Schlag Maßnahme 18 oder 19 beantragt ist, sonst 1.300 €/ha
    (2023: 1.200/1.300 €/ha). Wie die Obergrenze zwischen den Maßnahmen aufgeteilt wird,
    regeln die Quellen nicht. Hier wird angenommen, dass o6_23 zuletzt gekürzt wird.
12. **Reihenfolge der Kürzungen.** Die Reihenfolge laut SRL 1.12.2 ist als Daten erfasst.
    Rego wendet vereinfacht an: Obergrenze je Schlag, danach inhaltliche Kürzung
    (Sanktionsstufe) und danach Modulation. Die SRL sieht die Obergrenze nach der Modulation vor.
    Das kann bei gekappten Schlägen zu Rundungs- und Reihenfolgeabweichungen führen.
13. **Modulation.** Basis ist `land.total_area_ha` (Gesamtfläche laut Mehrfachantrag). Der
    Faktor wird gewichtet berechnet (Beispiel 220 ha → 99,09 %).
14. **Sanktionen.** Die Einstufung eines Verstoßes (Schwere, Ausmaß, Dauer, Häufigkeit) nimmt
    die AMA vor. Sie ist nicht aus Rohdaten ableitbar und wird als Eingabe
    `content_violation_stage` erwartet. Konditionalitätsverstöße werden nur als Befund gemeldet.
15. **Kleinbetragsgrenze.** Nach SRL 1.10.7 „kann“ von einer Gewährung bis 50 € abgesehen
    werden. Das wird nur als Befund gemeldet, der Betrag wird nicht auf 0 gesetzt.

## Nicht bzw. nur teilweise abgebildete Punkte

16. **Revisionsklausel (SRL 1.7.5).** Sie bezieht sich auf Art. 70 VO (EU) 2021/2115. o6_23 ist
    eine Art.-72-Intervention, daher ist die Anwendbarkeit offen (Coverage: `unresolved`).
17. **Höhere Gewalt und besondere Umstände (SRL 1.7.4, § 6 GSP-AV).** Das sind
    Einzelfallentscheidungen der AMA. Sie sind nur als Regeln im Katalog erfasst, nicht als
    ausführbare Logik.
18. **Korrektur unmöglicher Kombinationen (COMB-006).** Diese Verfahrensregel ist ohne
    Profilfelder nur im Katalog erfasst.
19. **Mehrjährige Bestimmungen.** Flächenabgangs-Toleranzen und Rückzahlung bei Vertragsbruch
    gelten nur für mehrjährige Maßnahmen und sind für o6_23 bewusst nicht implementiert
    (Coverage `not_rule`).
