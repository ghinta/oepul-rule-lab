# System Immergrün: Teilnahme, Verfahren, Aufzeichnungen und Prämien

Dies ist ein öffentlicher Entwicklungsprüfbericht für den unveränderten historischen Roh-Run `v2-o6_7-opus-5.5-high-20260925` am Kandidaten `e009eed4a83ff076b26eba33ac433ac2b0642621`. Es wurden keine historischen Policies, Quelldateien, Typen oder Profile repariert und keine Studienfälle, Expertenurteile oder generierten Selbsttest-Sollwerte verwendet. Dieser Teil ist keine fachliche Endabnahme des gesamten Runs.

Das gebundene [Detailprotokoll](general.json) enthält **54 echte historische Regel-IDs, 80 frische Kontrollen, 65 ausgewählte überprüfte Zitate und 11 Befunde**. JSON-SHA-256: `bab93369adea3f058a27004f6faa3fb716768425fa8482da7f7508da64f3535d`. Die endgültigen gemeinsamen Replay-Ergebnisse und die unabhängige Qualitätsprüfung stehen im übergeordneten Runbericht; dieses Teilprotokoll wird nach der Sammlung nicht für reine Statistikänderungen umgeschrieben.

Das neue Maßnahmenblatt wurde auf allen elf Seiten vollständig gelesen, einschließlich Definitionen, Tabellen, Beispielen, Ausnahmen, Änderungen und Haftungshinweis. Alle acht tatsächlich gelieferten Quellen sind gegen die historischen Run-Metadaten hashgeprüft. Die sieben identischen gemeinsamen Quellen werden auf die frühere vollständige Lektüre gebunden; einschlägige aktuelle Klauseln wurden gezielt erneut gelesen. Die genauen Seiten, Methoden und die echte Arbeitsteilung sind im JSON-Leseledger erhalten. Eine GSP-AV-Vollfassung gehört **nicht** zu diesem Quellenpaket; deren Einzelheiten aus anderen Runs werden nicht rückwirkend als bereitgestellter Modellinput ausgegeben.

Vollständig geprüft wurden `eligibility.rego` (161 Zeilen), `exit.rego` (105), `records.rego` (58), `general.rego` (114), `premium.rego` (178), alle Rohannahmen sowie die tatsächlichen gemeinsamen Verbraucher. Die Daten liegen unter `workspace/data/oepul/o6_7`; damit ist der Daten-Namespace `data.oepul.o6_7`, der Policy-Namespace dagegen `data.o6_7`. Die Ausführung lädt die ursprünglichen Policy- und Datenverzeichnisse mit der exakt gepinnten OPA-Binary.

## Nachweisbare Umsetzungen

- Der Jahresfilter der Maßnahmenliste verhindert einen Konflikt allein durch eine beendete Vorjahresteilnahme an Maßnahme 6.
- Die ausdrückliche Ausnahme für Gebietskörperschaften und öffentlich beherrschte juristische Personen gilt für Maßnahme 7. Landwirtschaft, eigene Rechnung und sonstige persönliche Voraussetzungen bleiben erforderlich.
- Bekannte falsche Aktivitätsangaben, aktuelle Maßnahme 6 und tatsächliche unentschuldigte Kontrollverweigerung sperren das lokale Vertrags-Gate. Eine bereits anerkannte Ausnahme bei der Kontrolle ist getrennt vorgesehen.
- Bekannte Aufzeichnungslücken werden für den Betrieb, alle Ackerschläge, alle vier Ereignisse und das volle Kalenderjahr erkannt. Auch die Fläche innerhalb der verbleibenden 15 Prozent benötigt Aufzeichnungen.
- Das 70–90-Euro-Band, die Verwendung eines tatsächlich festgelegten Satzes, die jahresbezogene NPF-2024-Sperre, OP/VF, monetärer Auslandsausschluss, Prämienobergrenzen-Ausnahme und die gewichteten Modulationsstaffeln besitzen aktive Verbraucher. Dies ersetzt keine vollständige behördliche Nettozahlung.

## Befunde und Auswirkungen

### O67-GEN-ADM-01: Bekannte persönliche und Wiederantragsmängel erreichen das Vertrags-Gate nicht

measure_valid liest nur die begrenzte eligibility-Blockerliste; OWN-ACCOUNT fehlt darin, die beiden exit-Befunde werden überhaupt nicht abgefragt.

Die App kann einen positiven Vertrag und ein positives lokales Prämienband neben bereits erkannten tatsächlichen Vertragsmängeln anzeigen.

Verbraucher/Katalog: [policy/o6_7/eligibility.rego:16](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/eligibility.rego#L16), [policy/o6_7/exit.rego:16](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/exit.rego#L16), [policy/o6_7/exit.rego:16](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/exit.rego#L16).

Quellen: o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 4 (5.2 Förderwerbende Personen); o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 13 (6 Antragstellung); 20241011_srl_oepul_2023.pdf PDF-Seite 22 (1.10.5.3 Zahlungsantrag); o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf PDF-Seite 10 (6 Achtung); o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 4 (5.2).

### O67-GEN-ADM-02: Zeitliche Vertragsbindung und fortwirkender Austritt sind unvollständig

Kein aktiver Test first_contract_year<=year, kein allgemeiner Programmrahmen und nur current-year withdrawal. auto_renewed_next_year ignoriert das Programmende und tatsächlichen Ausgangsvertrag.

Zukünftige, vor Programmstart oder nach Programmende liegende Jahre sowie ein nach Austritt nicht neu begründeter Vertrag können lokal gültig erscheinen.

Verbraucher/Katalog: [policy/o6_7/eligibility.rego:158](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/eligibility.rego#L158), [policy/o6_7/exit.rego:102](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/exit.rego#L102), [policy/o6_7/eligibility.rego:16](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/eligibility.rego#L16), [policy/o6_7/eligibility.rego:84](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/eligibility.rego#L84), [policy/o6_7/exit.rego:11](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/exit.rego#L11).

Quellen: o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf PDF-Seite 1 (3.1 Vertragszeitraum); o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 12 (5.9 Vertragszeitraum); 20241011_srl_oepul_2023.pdf PDF-Seite 12 (1.7.1.1 Einjährige Maßnahmen); 20241011_srl_oepul_2023.pdf PDF-Seite 12 (1.7.1 Verpflichtungsdauer und Vertragszeitraum); o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 10 (5.8 Verpflichtungsdauer).

### O67-GEN-ADM-03: Bekannte Auslandsfläche füllt die Inlands-Zugangssumme

lib.arable_parcels filtert ausschließlich land_use=arable, und arable_area_ha summiert auch explizit ausländische Schläge. Der separate monetäre Auslandsausschluss korrigiert diese vorgelagerte Summe nicht.

Ein Betrieb mit tatsächlich weniger als 1,50 ha Inlandsacker kann den Zugang allein durch ausländische Flächen erfüllen.

Verbraucher/Katalog: [policy/o6_7/eligibility.rego:14](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/eligibility.rego#L14), [policy/o6_7/eligibility.rego:16](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/eligibility.rego#L16), [policy/o6_7/eligibility.rego:16](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/eligibility.rego#L16), [policy/o6_7/eligibility.rego:113](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/eligibility.rego#L113).

Quellen: o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf PDF-Seite 1 (3.2 Mindestteilnahme); 20241011_srl_oepul_2023.pdf PDF-Seite 57 (2.7 Zugangsvoraussetzungen); o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 5 (5.3 Betriebsmindestgröße); 20241011_srl_oepul_2023.pdf PDF-Seite 10 (1.6.1 Mindestgröße des Betriebes); o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 9 (5.6).

### O67-GEN-ADM-04: Historische Segmente werden als aktuelle MFA- oder Doppelnutzung gelesen

records.violations und exit.violations iterieren lib.segments ohne aktuelle Jahresüberschneidung. Vorjahresabschnitte sind für Jahresanfang ausdrücklich erlaubt; endgültig vergangene Historie darf nicht als aktuelle Erklärung fehlen.

Alte bekannte Befunde erscheinen als aktuelle Verstöße oder sperren die heutige Flächennutzung; historische Verletzungen bleiben gesondert zu behandeln.

Verbraucher/Katalog: [policy/o6_7/records.rego:8](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/records.rego#L8), [policy/o6_7/exit.rego:16](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/exit.rego#L16), [policy/o6_7/catch_crop.rego:20](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego#L20).

Quellen: o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf PDF-Seite 9 (6 Beantragung); o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf PDF-Seite 2 (4.1 Begrünungskultur); o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf PDF-Seite 8 (5.2.5 Zulässige Nutzung); o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf PDF-Seite 9 (6); o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf PDF-Seite 8 (5.2.5).

### O67-GEN-ADM-05: Behördliche Übernahme- und Verfahrenswege bleiben ohne Ausführung

Vorgeschlagene Daten oder Katalogzeilen ersetzen weder die konkrete AMA-Genehmigung noch aktuelle Kontroll-/Korrektur- und Anerkennungsereignisse. Ein genehmigter Übernahmepfad kann sogar am regulären Antrag vor Vertragsbeginn blockieren.

Für eine fachlich belastbare App-Zulassung braucht es belegte Behördenzustände beziehungsweise ausdrücklich begrenzte Komponentenanzeigen; die native Ausgabe ist keine vollständige Verfahrensentscheidung.

Verbraucher/Katalog: [data/oepul/o6_7/parameters.json:85](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/data/oepul/o6_7/parameters.json#L85), [data/oepul/o6_7/general.json:223](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/data/oepul/o6_7/general.json#L223), [policy/o6_7/exit.rego:14](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/exit.rego#L14), [rules/rules.json:1020](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/rules/rules.json#L1020), [rules/rules.json:954](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/rules/rules.json#L954).

Quellen: o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 14 (6.3 Maßnahmenübernahme); o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 15 (6.3 Maßnahmenübernahme); o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf PDF-Seite 10 (7 Ausstieg bzw. Abmeldung); o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 13 (6 Antragstellung); 20241011_srl_oepul_2023.pdf PDF-Seite 21 (1.10.5.2 Maßnahmenantrag).

### O67-GEN-O67-P-F01: The harvest predicate omits explicitly represented protected arable cultivation

The source includes both arable land except arable fodder and protected cultivation in the 85% harvest duty. The proposed enum separately represents protected_cultivation_arable, while general.rego checks only main_crop. A protected arable parcel with a known zero harvest share and no exception therefore escapes both the harvest diagnosis and this premium exclusion.

A protected arable parcel can remain in eligible premium area despite a proven unmet harvest obligation.

Verbraucher/Katalog: [policy/o6_7/general.rego:43](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/general.rego#L43), [policy/o6_7/premium.rego:79](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/premium.rego#L79).

Quellen: o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 5 (5.4 Mindestbewirtschaftung: Acker und geschützter Anbau); o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 6 (5.4 Ernte und Mindestpflege).

### O67-GEN-O67-P-F02: Arable-fodder and retired-land minimum management remain catalogue-only

The current catalogue explicitly leaves minimum management outside the package. No executable check establishes annual full-area mowing with removal or grazing for arable fodder, or cover establishment plus at least biennial care on land out of production. A scalar harvest share cannot substitute for these separate duties.

The app cannot substantiate compliance with these management duties from this candidate. Known breaches can remain unreported; missing evidence must be labelled separately.

Verbraucher/Katalog: [policy/o6_7/general.rego:43](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/general.rego#L43).

Quellen: o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 6 (5.4 Ernte und Mindestpflege).

### O67-GEN-O67-P-F03: Automatic drought harvest relief lacks the notice crop-season limitation

The August 5 body expressly restricts automatic relief to cultures normally harvested in late summer or autumn and particularly affected by heat and low rain. The native predicate checks only 2026, no harvestable crop due to drought and region. The catalogue and input proposal omit the usual harvest-season condition. August 12 supplements the earlier exceptions and expands regions; it does not state a removal of that scope.

A declared drought loss on an early-harvest crop can incorrectly waive the 85% obligation without individual recognition. Do not replace this open factual condition by an invented closed crop list.

Verbraucher/Katalog: [policy/o6_7/general.rego:31](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/general.rego#L31).

Quellen: 2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html – Meldungstext (Automatische Ausnahme und sachlicher Geltungsbereich); 2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html – Meldungstext (Erweiterung der Gebietskulisse).

### O67-GEN-O67-P-F04: Control refusal blocks current premium without contract unwinding

Known unexcused control refusal correctly makes current premium zero. The source additionally terminates and unwinds existing contracts; no recovery or contract-termination result exists in these consumers. A recognised exceptional circumstance is correctly allowed by the proposed exception flag rationale.

The app must not describe current zero alone as complete administration of this source consequence, especially where an advance has already been paid.

Verbraucher/Katalog: [policy/o6_7/general.rego:104](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/general.rego#L104), [policy/o6_7/premium.rego:97](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/premium.rego#L97).

Quellen: 20241011_srl_oepul_2023.pdf PDF-Seite 23 (1.11.1.2 Kontrollverweigerung und Ausnahme).

### O67-GEN-O67-P-F05: Sanction steps and reduction order are not consumed by the financial result

The step lookup and eleven-stage sequence exist, but premium_eur is only eligible area times the selected rate times modulation. There is no proposed assessed-sanction or deduction input and no reduction-chain consumer. Raw assumptions acknowledge that content breaches do not automatically imply zero and that authority stages are only a table. This is a declared incomplete calculation rather than a justified final payment.

The computed amount may overstate an authorised net payment after an assessed content reduction or other simultaneous deductions. Retain a clearly labelled component estimate; do not invent a sanction percentage from any detected breach.

Verbraucher/Katalog: [policy/o6_7/general.rego:94](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/general.rego#L94), [policy/o6_7/premium.rego:135](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/premium.rego#L135).

Quellen: o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 18 (8.2 Stufen und Warnung ab2027); 20241011_srl_oepul_2023.pdf PDF-Seite 24 (1.12.1.3 Inhaltliche Auflagen); 20241011_srl_oepul_2023.pdf PDF-Seite 25 (1.12.2 Reihenfolge).

### O67-GEN-O67-P-F06: Modulation reads the whole holding without the source home/alpine separation

The formula is correct for the relevant home area, but total_area_ha is consumed as the whole holding without a home-area contract or alpine subtraction. With a known 100 ha home arable holding and 200 ha separately treated alpine area, source factor for the home premium is 1 while raw total gives 290/300. Supplying only home area under total_area_ha could avoid this, but that narrowed meaning is absent from the proposal and raw assumptions say the whole holding.

Mixed home/alpine farms can receive excessive reductions; a missing total fallback can create the opposite error when home non-arable area is omitted.

Verbraucher/Katalog: [policy/o6_7/premium.rego:115](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/premium.rego#L115), [policy/o6_7/premium.rego:121](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/premium.rego#L121).

Quellen: o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 19 (9.3 Modulation, Beispiel und Heim-/Almtrennung); 20241011_srl_oepul_2023.pdf PDF-Seite 17 (1.9.2.2 Modulation).

## Frische Kontrollen und verbleibende Grenzen

Die 47 Teilnahme-/Verfahrenskontrollen decken echte Fristgrenzen, letzten Einstieg, zukünftigen Erstbeginn, Programmgrenzen, bekannte persönliche Tatsachen, öffentlichen Ausnahmefall, aktuellen und fortwirkenden Austritt, neuen Antrag nach Erlöschen, jährliche Kombinationsfilter, Wechseltermin, alle Aufzeichnungen, historische Segmente, MFA-Reklassifikation und allgemeinen Mindestgrößen ab. Hinzu kommen 33 unabhängig aus den gelieferten Finanz-/Verwaltungsquellen abgeleitete Kontrollen zu Tarif, Ernte, Dürre, Transfer, Kontrolle, OP/VF, NPF, Ausland, Obergrenze, Modulation und diskretionärer Kleinbetragsgrenze.

Der genehmigte Übernahmefall ist ausdrücklich als Behörden-Ausnahmeszenario qualifiziert: rechtzeitiger Übernahmeantrag, keine Ausweitung und AMA-Genehmigung sind unabhängig stipuliert. Das Profil besitzt keinen vollständigen Genehmigungskanal. Der Fall zeigt die Darstellungsgrenze des gewöhnlichen Erst-Antrags-Gates und erfindet keine Genehmigung allein aus einem Datum. Ebenso setzt die frühe-Ernte-Dürregegenkontrolle den tatsächlich üblichen Erntezeitraum ausdrücklich voraus; die Quelle enthält keine geschlossene Kulturliste. Diese zusätzliche Tatsachengrenze bleibt vollständig im JSON erhalten.

Die ES-Acker-Folgejahrformulierung gegenüber Rohannahme A11, die Grünbrache-/DIV-Sonderauslegung gegenüber weiteren Ausnahmen und die Art.-70-Überschrift der Revisionsklausel gegenüber der eigenen Art.-31-Öko-Regelung bleiben als Auslegungs- beziehungsweise Aufnahmefragen erhalten. Dafür werden keine harten unbeklärten Goldlabels erzeugt. Andere Nationalparks können bereits über eine autoritative `national_park_no_premium`-Klassifikation übertragen werden; die Prüfung behauptet deshalb keinen pauschalen Fehler jeder anderen Parkfläche. Leistungsvergleich bei Doppelförderung, behördlich festgelegte Inhaltsstufen und die vollständige Kürzungskette besitzen keinen ausreichenden Eingabekanal und bleiben klar gekennzeichnete Quellenkontrollen.

Fehlender Beleg bedeutet keinen nachgewiesenen tatsächlichen Verstoß. Eine Inhaltsverletzung schreibt auch nicht automatisch 100 Prozent Kürzung vor. Ein unwirksamer Ausstiegsversuch nach Kontrollankündigung erhält grundsätzlich den Vertrag und ist von tatsächlicher Kontrollverweigerung zu trennen. Aktuelle lokale Prämie, endgültige Zahlung, vergangene Rückabwicklung und behördlicher Ermessensentscheid sind verschiedene Ergebnisse. Der bekannte gemischte Zahlenvergleichsfehler der gepinnten OPA wird gesondert behandelt; Quellenorakel werden deshalb weder an die Engine angepasst noch werden Originaldaten umtypisiert.

Alle ausführbaren Erwartungen verwenden die tatsächliche native Form. Regelobjektlisten, Strings und Tupel werden nicht verwechselt; Stringmengen und leere Gegenfälle nutzen passende explizite Gleichheit. Bool-Abfragen bilden gewöhnliche Rego-Prädikatsabwesenheit ausdrücklich ab, ohne OPA-Statusdarstellung als Rechtsnorm auszugeben.

## Vollständige Zuordnung der 54 historischen IDs

Die vollständige Einzelbewertung samt aktuellem Quellenwortlaut, Version, tatsächlichem Verbraucher und Codezeilen steht für jede Zeile im JSON. Reine Katalog-/Informationsregeln und ungelöste Quellenauslegungen werden als solche erhalten. Weitere Quellenpflichten stehen separat und erhalten keine erfundenen historischen IDs.

| Historische ID | Bewertung | Erster tatsächlicher Verbraucher oder Kataloganker |
|---|---|---|
| `O67-CONTRACT-ONE-YEAR` | `partial` | [policy/o6_7/eligibility.rego:158](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/eligibility.rego#L158) |
| `O67-CONTRACT-AUTO-RENEWAL` | `partial` | [policy/o6_7/exit.rego:102](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/exit.rego#L102) |
| `O67-ACCESS-MIN-ARABLE` | `partial` | [policy/o6_7/eligibility.rego:14](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/eligibility.rego#L14) |
| `O67-CONTRACT-LAPSE` | `partial` | [policy/o6_7/exit.rego:44](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/exit.rego#L44) |
| `O67-CONTRACT-LAPSE-REAPPLY` | `partial` | [policy/o6_7/exit.rego:16](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/exit.rego#L16) |
| `O67-REENTRY-NEW-APPLICATION` | `partial` | [policy/o6_7/exit.rego:16](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/exit.rego#L16) |
| `O67-FIELD-FODDER-DOUBLE-USE` | `partial` | [policy/o6_7/exit.rego:16](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/exit.rego#L16) |
| `O67-RECORDS` | `implemented_with_input_contract_limits` | [policy/o6_7/records.rego:8](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/records.rego#L8) |
| `O67-RECORDS-TEMPLATE` | `catalog_only` | [rules/rules.json:645](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/rules/rules.json#L645) |
| `O67-APPLICATION-DEADLINE` | `partial` | [policy/o6_7/eligibility.rego:16](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/eligibility.rego#L16) |
| `O67-LAST-ENTRY` | `implemented_with_input_contract_limits` | [policy/o6_7/eligibility.rego:16](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/eligibility.rego#L16) |
| `O67-MFA-MAIN-CROPS` | `partial` | [policy/o6_7/records.rego:8](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/records.rego#L8) |
| `O67-MFA-CATCH-CROPS-NOT-DECLARED` | `implemented_with_input_contract_limits` | [policy/o6_7/catch_crop.rego:20](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego#L20) |
| `O67-COMB-NOT-WITH-6` | `implemented_with_input_contract_limits` | [policy/o6_7/eligibility.rego:16](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/eligibility.rego#L16) |
| `O67-SWITCH-TO-6` | `partial` | [policy/o6_7/exit.rego:72](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/exit.rego#L72) |
| `O67-COMB-PREREQUISITE-FOR-8-16` | `implemented_with_input_contract_limits` | [policy/o6_7/eligibility.rego:16](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/eligibility.rego#L16) |
| `O67-EXIT-AFTER-ONE-YEAR` | `partial` | [policy/o6_7/exit.rego:14](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/exit.rego#L14) |
| `O67-EXIT-DURING-YEAR` | `partial` | [policy/o6_7/exit.rego:11](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/exit.rego#L11) |
| `O67-EXIT-ES-ACKER` | `source_interpretation_boundary` | [policy/o6_7/exit.rego:26](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/exit.rego#L26) |
| `O67-APPLICANT-TYPE` | `implemented_with_input_contract_limits` | [policy/o6_7/eligibility.rego:16](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/eligibility.rego#L16) |
| `O67-APPLICANT-PUBLIC-SHARE` | `implemented_with_input_contract_limits` | [policy/o6_7/eligibility.rego:25](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/eligibility.rego#L25) |
| `O67-APPLICANT-ACTIVE-FARMER` | `implemented_with_input_contract_limits` | [policy/o6_7/eligibility.rego:16](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/eligibility.rego#L16) |
| `O67-APPLICANT-OWN-ACCOUNT` | `partial` | [policy/o6_7/eligibility.rego:16](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/eligibility.rego#L16) |
| `O67-GEN-FARM-MIN-SIZE` | `implemented_with_input_contract_limits` | [policy/o6_7/eligibility.rego:16](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/eligibility.rego#L16) |
| `O67-GEN-SELF-REPORT` | `catalog_only` | [rules/rules.json:954](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/rules/rules.json#L954) |
| `O67-GEN-CONDITIONALITY` | `catalog_only` | [rules/rules.json:998](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/rules/rules.json#L998) |
| `O67-GEN-IMPOSSIBLE-COMBINATION-CORRECTION` | `catalog_only` | [rules/rules.json:1020](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/rules/rules.json#L1020) |
| `O67-GEN-TAKEOVER` | `catalog_only` | [data/oepul/o6_7/parameters.json:85](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/data/oepul/o6_7/parameters.json#L85) |
| `O67-GEN-AREA-ACCESS-UNRESTRICTED` | `implemented_with_input_contract_limits` | [data/oepul/o6_7/general.json:205](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/data/oepul/o6_7/general.json#L205) |
| `O67-GEN-FORCE-MAJEURE` | `partial` | [policy/o6_7/general.rego:37](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/general.rego#L37) |
| `O67-GEN-REVISION-CLAUSE` | `catalog_only_source_applicability_boundary` | [rules/rules.json:1163](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/rules/rules.json#L1163) |
| `O67-GEN-MULTI-YEAR-CONTEXT` | `catalog_only_out_of_scope_context` | [data/oepul/o6_7/general.json:140](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/data/oepul/o6_7/general.json#L140) |
| `O67-PREMIUM-RATE` | `implemented_with_input_contract_limits` | [policy/o6_7/premium.rego:135](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/premium.rego#L135) |
| `O67-PREMIUM-FUNDING-ECO-SCHEME` | `implemented_with_input_contract_limits` | [data/oepul/o6_7/lists.json:452](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/data/oepul/o6_7/lists.json#L452) |
| `O67-PREMIUM-NPF-2024` | `implemented_with_input_contract_limits` | [policy/o6_7/premium.rego:20](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/premium.rego#L20) |
| `O67-GEN-HARVEST-OBLIGATION` | `partial` | [policy/o6_7/general.rego:43](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/general.rego#L43) |
| `O67-GEN-MIN-MANAGEMENT-OTHER` | `catalog_only` | [rules/rules.json:877](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/rules/rules.json#L877) |
| `O67-GEN-DROUGHT-2026-HARVEST` | `partial` | [policy/o6_7/general.rego:31](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/general.rego#L31) |
| `O67-GEN-ELIGIBLE-AREAS` | `partial` | [policy/o6_7/premium.rego:20](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/premium.rego#L20) |
| `O67-GEN-NATIONAL-PARK` | `partial` | [policy/o6_7/premium.rego:20](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/premium.rego#L20) |
| `O67-GEN-TRIAL-AREA-VF` | `implemented_with_input_contract_limits` | [policy/o6_7/premium.rego:20](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/premium.rego#L20) |
| `O67-GEN-OP-CODE` | `implemented_with_input_contract_limits` | [policy/o6_7/premium.rego:20](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/premium.rego#L20) |
| `O67-GEN-OP-OTHER-MEASURES-UNAFFECTED` | `implemented_with_input_contract_limits` | [policy/o6_7/premium.rego:20](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/premium.rego#L20) |
| `O67-GEN-LOCATION-AUSTRIA` | `implemented_with_input_contract_limits` | [policy/o6_7/general.rego:58](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/general.rego#L58) |
| `O67-GEN-COMMITMENT-PERIOD` | `implemented_with_input_contract_limits` | [policy/o6_7/general.rego:52](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/general.rego#L52) |
| `O67-GEN-DOUBLE-FUNDING` | `implemented_with_input_contract_limits` | [policy/o6_7/premium.rego:20](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/premium.rego#L20) |
| `O67-GEN-CONTROL-ACCESS` | `partial` | [policy/o6_7/general.rego:104](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/general.rego#L104) |
| `O67-GEN-SANCTION-STEPS` | `partial` | [policy/o6_7/general.rego:94](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/general.rego#L94) |
| `O67-GEN-MULTIPLE-REDUCTIONS-ORDER` | `partial` | [data/oepul/o6_7/general.json:235](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/data/oepul/o6_7/general.json#L235) |
| `O67-GEN-PAYMENT` | `implemented_with_input_contract_limits` | [data/oepul/o6_7/parameters.json:70](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/data/oepul/o6_7/parameters.json#L70) |
| `O67-GEN-MIN-PAYOUT-50` | `implemented_with_input_contract_limits` | [policy/o6_7/premium.rego:151](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/premium.rego#L151) |
| `O67-GEN-PAYMENT-CAP-EXCLUSION` | `implemented_with_input_contract_limits` | [policy/o6_7/premium.rego:157](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/premium.rego#L157) |
| `O67-GEN-MODULATION` | `partial` | [policy/o6_7/premium.rego:125](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/premium.rego#L125) |
| `O67-GEN-COMBINATION-ANNEX-L` | `partial` | [policy/o6_7/premium.rego:20](../../../../../runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/premium.rego#L20) |

Der ursprüngliche Katalog enthält insgesamt 107 IDs. Dieser Teil bewertet 54; Domain bewertet 52 und Core die echte Scope-ID. Überschneidende Quellenauslegungen im Gesamtprotokoll erweitern diese historische ID-Menge nicht.
