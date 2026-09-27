# Annahmen und offene Fragen – o6_18 Naturschutz

Run `v2-o6_18-opus-5.5-high-20260927`, Modus `discover`.

## Quellen und Umfang

- **Seiten der Belege:** Die Seitenangaben beziehen sich auf die seitenmarkierten Textfassungen der PDFs. Die Evidenztexte wurden wörtlich aus diesen Seiten übernommen. Wo die Textextraktion Wörter zerreißt (z. B. „Maßnahme n“, „Vertrag sabschluss“), steht der Beleg bewusst in dieser extrahierten Schreibweise.
- **Sonderrichtlinie:** Geprüft wurden gezielt der Allgemeine Teil (1.1–1.20), Kapitel 2.18 sowie die Querverweise auf Naturschutz in 2.1 A (UBB), 2.19 (EBW) und 2.23 (Natura 2000).
- **Anhänge:** Geprüft wurden die Anhänge A, I, J und L. Die Anhänge B–H und K betreffen andere Maßnahmen.
- **Rebzikade-Meldung (12.06.2026):** Sie betrifft ausschließlich die Maßnahme 12 und ist in `coverage.json` als `not_rule` erfasst.

## Anhang I (data/o6_18/annex_i_auflagen.json)

- **Umfang:** Die Tabelle enthält alle 332 Auflagencodes. Aliascodes (z. B. `GE01/BC01`, `GJ05/BF05/WD01`) werden als `aliases` der Hauptzeile geführt. Für die Kapitelprüfung nach Anhang J zählt der Anfangsbuchstabe des tatsächlich vergebenen Codes.
- **Text:** Das Feld `text` fasst Auflagentitel und Bewirtschaftungsauflage wortgetreu zusammen. Die Trennung beider Spalten ist aus der Textextraktion nicht zuverlässig möglich.
- **Prämiensätze:**
  - Sie gelten ab 2024.
  - Für 2023 enthalten die Quellen keine Anhang-I-Sätze; die Schlagprämie wird daher nicht berechnet (Regel `O618-PREM-012`). Nur der Zuschlag Regionaler Naturschutzplan (250 €) ist für 2023 belegt.
  - GG03/GG04 haben 2024 und ab 2025 unterschiedliche Sätze.
  - K20-Codes gelten nur bis 2024.
  - KF01 hat keinen Satz.
- **„Ab dem Antragsjahr 2025“:** Das gilt für GA21, GC05, GD03, GR02/WF02, WC03, BI01 und BI02. Die Quelle nennt „BI02 und BI02“; interpretiert als BI01 und BI02.
- **Abgeleitete Merkmale:** Felder wie `required_mowings_per_year`, `fertilization_rule`, `psm_ban` und `requires_grazing` sind Auslegungen des Auflagentextes:
  - GA-Mahdanzahl „3 x Mahd“ wird als *genau* diese Anzahl je Jahr geprüft.
  - Verpflichtende Beweidung wird nur für GA16, GA18, WA01, WA03, BA03 und BA04 angenommen. GA15/GA17 sehen nur „max. 2 x Beweidung“ vor.
  - „Keine zusätzliche Düngung“ wird wie ein Düngeverbot für ausgebrachte Dünger behandelt; Weideausscheidungen sind nicht erfasst.
- **SC02:** Die Pflichtkombination mit SA01 folgt aus dem Merkblatt („SA01 (inkl. SB01 bis SB18 bzw. SC02)“). Im Anhang steht sie ausdrücklich nur für SB.
- **Großtrappe (Monitoring-Pflicht):** Das Merkblatt nennt „TA und TB“, im Anhang steht die Pflicht nur bei TA01. Umgesetzt für TA01 und TB01; ob TC01/TD01 (in der Tabelle „Zusatzauflagen (TB)“) erfasst sind, bleibt offen.
- **N-Auflagen und `$`-Parameter:** Nur Teile sind maschinell geprüft, nämlich Termine, Beweidungs-, Bewässerungs- und Silageverbote sowie PSM. Die übrigen Auflagen sind als Daten verfügbar und über `O618-OBL-016` abgedeckt.
- **NE01:** Die Kulturartenliste liegt als Daten vor, ist aber nicht in Rego geprüft (Kulturnamen im Profil sind frei). Siehe `O618-OBL-017`.

## Kombinationen

- **Anhang L:** Aus dem extrahierten Text ist nur Zeile 18 zuverlässig lesbar (1A/1B nur für Landschaftselemente, 23 kombinierbar). Die übrigen Zeilen und Spalten wurden nicht übernommen.
- **Punktförmige Landschaftselemente:** Das Merkblatt spricht von „punktförmigen Landschaftselementen“, die SRL allgemein von Landschaftselementen der 1A/1B. Modelliert über das Flag `ubb_bio_only_landscape_elements`.
- **0,15-ha-Regel bei Feldstücken über 5 ha (`O618-KOMB-009`):** Umgesetzt wie im Merkblatt beschrieben. Die UBB-Schwellen (ab 10 ha Acker bzw. 10 ha gemähtem Grünland) werden nicht zusätzlich geprüft.

## Prämie

- **Reihenfolge der Berechnung:**
  1. Summe der Teilprämien plus Zuschläge.
  2. Modulation.
  3. Kappung auf die Obergrenze je ha abzüglich der übrigen Flächenzahlungen am Schlag. Dies folgt der Reihenfolge in SRL 1.12.2 (Modulation vor Obergrenze).
- **Stilllegungs- und Zugangsgrenze:** Werden sie überschritten, wird anteilig gekürzt (Faktor). Welche Flächen konkret betroffen sind, legt die Quelle nicht fest.
- **Nationalparks:** Keine Prämie in Neusiedlersee und Donau-Auen. In anderen Nationalparks entfällt die Prämie nur, wenn relevante Bewirtschaftungsauflagen festgelegt sind (Eingabe-Flag).
- **Kleinbetrag bis 50 €:** Die Auszahlung *kann* unterbleiben; ausgegeben wird nur ein Flag.

## Abwicklung und 2026

- **Freigabe 12.08.2026:** Umgesetzt als „frühester Termin = min(Termin laut Projektbestätigung, 2026-08-12)“, für die erste und zweite Nutzung (GL-/NM05-Termine sowie GN01/GN02).
- **Dürre-Gebietskulisse Ernte:** Sie wird nur auf NAT-Ackerflächen mit Kapitel-A-Auflagen angewendet. Die Mindestbewirtschaftungskriterien gelten laut SRL nur, soweit die Maßnahme nichts Abweichendes bestimmt. Für NAT-Grünland gilt die Nutzung laut Projektbestätigung und „alle 2 Jahre“, deshalb dort keine jährliche Mahdpflicht.
- **Sanktionsstufen:** Die Zuordnung eines konkreten Verstoßes zu einer Stufe (Schwere, Ausmaß, Dauer, Häufigkeit) ist nicht öffentlich festgelegt. Modelliert sind nur die Stufen, die Änderung ab 2027 und der Ausschluss.
- **`land.parcels[].constraints.is_contract_nature_area`:** Das vorhandene Feld ist mehrdeutig. Die Teilnahme wird über den Code `NAT` in `land.parcels[].oepul.codes` bestimmt (neu vorgeschlagen).
