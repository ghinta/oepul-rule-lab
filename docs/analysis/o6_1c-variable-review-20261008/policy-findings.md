# o6_1c: reproduzierte Policy-Befunde

Alle 13 Proben verwenden synthetische Daten und unveränderte historische
Policies bzw. eine gehashte Kopie der aktuellen App-Policy. Sie sind
Prüfbeobachtungen, keine Golden Tests und keine gewünschte Förderlogik.

| Proben | Beobachtung | Bedeutung vor Integration |
| --- | --- | --- |
| `LUNA_ELIGIBLE_WITH_VIOLATIONS` | `eligible:true` neben `NPA_FERTILIZER:fail`, `NPA_CHEMICAL_INPUTS:fail` und fehlender Pflege. | `eligible` ist faktisch nur Scope (ID/Jahr/Region), im Katalog auch `in_scope` genannt. Darf nicht als vollständige Förderentscheidung in den App-Ergebnisvertrag übersetzt werden. |
| `LUNA_GENUS_SPECIES`, `LUNA_GENUS_LITERAL`, `OPUS_GENUS_SPECIES` | Luna findet `Elaeagnus angustifolia` nicht, aber den wörtlichen Gattungsnamen; Opus erkennt die Art über die Gattung. | MB S. 2 und SRL S. 46 listen Ölweiden (Elaeagnus). Taxonvergleich und Name müssen belegbar sein; ein exakter Stringvergleich reicht hier nicht. Dies bewertet nur diesen konkreten Fall, nicht die Gesamtqualität der Modelle. |
| `OPUS_TREE_SPACING_MISSING`, `OPUS_TREE_SPACING_OVER_LIMIT` | Fehlender maximaler Abstand erzeugt keine Definitionsfehler; 16 m erzeugt DEF-AFS-005. | `object.get(..., 0)` macht fehlende Abstandsevidenz zum Einhalten der 15-m-Grenze. Andere fehlende AFS-Angaben nutzen ebenfalls positive Defaults; vollständigen Nachweis vor positiver Entscheidung verlangen. |
| `OPUS_CARE_PREVIOUS_MISSING`, `OPUS_CARE_BEFORE_YEAR_END` | Ohne Vorjahreswert keine Pflegeverletzung; bei ausdrücklich `false` eine Verletzung auch mit Datenstand 01.06. und unvollständigen Ereignissen. | Fehlend wird als Vorjahrespflege `true` behandelt; `context.as_of`/Vollständigkeit werden nicht gelesen. Eine noch mögliche laufende Jahrespflicht darf vor Fälligkeit nicht als verletzt bewertet werden. Jahresabschluss und confirmed-empty-Zustand fehlen im Vertrag. |
| `OPUS_FIRST_YEAR_MISSING` | Neuansaat ohne Erstdeklarationsjahr erlaubt einen Reinigungsschnitt. | Default = aktuelles Jahr belegt keine Erstdeklaration. Bei unbekannter Historie bleiben Frist/Ausnahme offen. MB S. 3 unterscheidet Neuansaat von bestehender Grünbrache. |
| `OPUS_PREMIUM_WITH_FERTILIZATION` | Bekannte Düngung erzeugt NPA-007, zugleich Prämienband 175–225 € für 0,5 ha. | Geometrisch berechnetes Band ist nicht bestätigte Auszahlung. Keine konkrete Kürzung aus der Probe ableiten; fachlicher Status, Datenlücken und mögliche AMA-Sanktion müssen neben der unverbindlichen Schätzung sichtbar sein. ATB S. 17–18. |
| `OPUS_ARBITRARY_OP_PREFIX` | `OPINVENTED` gilt als erfüllte OP-Kennzeichnung; dieselbe Eingabe erzeugt keinen Code-Prämienausschluss. | `startswith("OP")` bestätigt keinen amtlichen Code. Verbindliche, maßnahmenbezogene Code-/Wirkungsliste erforderlich; ATB S. 7–9 nennen konkrete Codes/Beispiele. |
| `APP_NPA_PROXY` | Positives Kennzeichnungsflag ergibt `eligible / phase1_proxy_signal_detected` ohne Antrag/Pflege-/Geometrie-/Mittelbelege. | Bestehende App-Prüfung ist eine Phase-1-Erkennung, keine vollständige Maßnahmenprüfung. |
| `APP_AFS_OUTSIDE_ARABLE` | Bei positiver AFS-Kennzeichnung auf einem Element mit `land_use:other` meldet die App `missing_data / no_arable_parcels_available`. | Synthetische Probe des aktuellen Filters. Sie beweist den Konsum auf Acker-Schlägen, nicht die tatsächliche Nutzungsart jedes realen AMA-Elements. Vor Integration den bestätigten AFS-Entitätsvertrag festlegen. |

Weitere Codebefunde: Lunas NPA-PSM-Prüfung verwirft jede Anwendung, obwohl die
Quelle ausschließlich bio-zugelassene Wirkstoffe ausnimmt; seine vorgeschlagene
Wirkstoffliste wird nicht gelesen. Die 4-%-Prämiengrenze wird als `fail` gemeldet,
während Quelle und Opus eine Kappung der Prämienfläche beschreiben. Lunas
Prämienband ist nicht an Verstöße oder Antrags-/Jahresgültigkeit gebunden.
Diese Punkte benötigen einen expliziten Ergebnisvertrag, keine Umdeutung von
`eligible`, `pass`, `fail` oder eines Bands durch Namensähnlichkeit.

Fachlich ungeklärt bleiben unter anderem die Teilflächen-/Frühschnittabgrenzung,
Reinigungsschnitt als Zweijahrespflege, situativ notwendige AFS-Pflege sowie
AFS-Prämienkombination gegenüber Feldstücksanrechnung. Die zehn Expertenfragen
enthalten die Originalbelege; keine Modellannahme wird als Antwort übernommen.
