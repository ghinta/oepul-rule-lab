# Erosionsschutz Acker: allgemeine Voraussetzungen und Verfahren

Öffentliche Entwicklungsprüfung des unveränderten historischen Roh-Runs `v2-o6_8-opus-5.5-high-20261001` am Kandidaten `e009eed4a83ff076b26eba33ac433ac2b0642621`. Es wurden keine Policies, Quellen, Profile, Daten oder numerischen Typen korrigiert. Studienfälle, Expertenurteile, generierte Selbsttests und manuelle Adaptations-Sollwerte wurden nicht als Referenz verwendet. Dieser Teil ist keine fachliche Endabnahme des gesamten Runs.

Das eingefrorene [Detailprotokoll](general.json) bewertet **46 echte historische IDs** und enthält **91 frische Kontrollen, 11 Befunde, 63 ausgewählte exakte Zitate sowie 87 aktuelle Regel-Codeanker**. JSON-SHA-256: `e12cd5a3b703eb70346afe8466405a05d290dbba22157b756f071fb66da29a2a`. Finale gemeinsame Ausführungszahlen und unabhängige Qualitätsprüfung stehen im übergeordneten Runbericht; das Detailprotokoll wird nicht für reine Replay-Statistikänderungen umgeschrieben.

Das neue Maßnahmenblatt mit Stand April 2026 wurde auf **allen zwölf tatsächlichen PDF-Seiten** vollständig gelesen: jede Norm, Ausnahme, Kultur-/Tarifliste, Fußnotenkonkretisierung, jedes Beispiel, die Änderungen und der Haftungshinweis. Acht tatsächlich bereitgestellte Quellen sind gegen die historischen Run-Metadaten hashgeprüft. Die sieben identischen gemeinsamen Quellen werden auf ihre frühere vollständige Lektüre gebunden; einschlägige aktuelle Klauseln wurden gegen die jetzigen Verbraucher erneut gelesen. Das ATB-PDF hat ausdrücklich **21 Seiten**. Keine Lektüre einer nicht vorhandenen ATB-Seite wird behauptet. Die genaue Seiten-/Arbeitsteilung steht im JSON.

Vollständig geprüft sind `general.rego` (279 Zeilen), `notices_2026.rego` (53), `cross_measures.rego` (53), `premium.rego` (173), `common.rego` (97), alle 24 Rohannahmen und die relevanten tatsächlichen Kultur-/Verfahrensschnittstellen. Der ausführbare Namespace lautet `data.oepul.o6_8`, die statischen Daten stehen unter `data.o6_8`. Die Ausführung lädt die unveränderten ursprünglichen Policy- und Datenverzeichnisse mit der exakt gepinnten OPA-Binary. Eine vollständige GSP-AV oder ein MOG-Volltext wurde diesem Run nicht geliefert; detaillierte Vorschriften aus anderen Quellenpaketen werden nicht rückwirkend als Modellinput ausgegeben.

## Aktuelle Umsetzungen

- `contract_active` prüft tatsächlich die gültigen Startkohorten 2023/2024/2025 und den Zeitraum ab Vertragsbeginn bis Ende 2028. Eine reine Zeitgrenze ersetzt allerdings keine Beendigungsereignisse.
- Für einen vorhandenen Antragsteller gibt es eine echte positive Rechtsform-/Aktivitätskomponente; bekannte Negativfälle sperren den Zugang. Öffentliche Antragsteller sind für die eigene Maßnahme 8 zutreffend nicht ausgenommen.
- Die Ernte-Dürreausnahme verlangt jetzt die tatsächlich zutreffende Spätsommer-/Herbstkultur, Dürreschaden und Gebietskulisse. Ein gestellter Einzelantrag allein ist keine anerkannte Ausnahme.
- Andere Nationalparks werden bei tatsächlich relevanten Auflagen ausgeschlossen. Eine belegte öffentliche Leistungsüberschneidung wird unabhängig vom bereits gesetzten OP-Code gelesen.
- Die jährliche Flächenvariabilität der eigenen Maßnahme 8 wird erkannt. Eine bloße Inventarverringerung übernimmt nicht pauschal die generische mehrjährige Flächenrückforderung; die mehrjährige Vertragspflicht und jährliche Mindestteilnahme bleiben bestehen.
- Quellengetreue Frist-/50%-Übernahmekomponenten, Tarif-/Versionszeilen, OP/OPEROA-Abgrenzung, Kleinbetragsgrenze und gewichtete Modulationsstaffeln sind vorhanden. Diese Helfer sind jeweils enger als ein vollständiger Genehmigungs- oder Auszahlungsprozess.

## Befunde und praktische Wirkung

### O68-GEN-ADM-01: Wirksamer Ausstieg und fehlender Zahlungsantrag sperren die aktuelle Prämienfähigkeit nicht

Die entsprechenden vorgeschlagenen Tatsachen besitzen eigene Rückforderungs-/No-premium-Helfer, werden aber weder von contract_active noch code_premium_eligible und premium_gross_eur konsumiert.

Die App kann neben einem erkannten Ausstieg oder nachweislich nicht gestelltem aktuellen Zahlungsantrag eine positive aktuelle Codeprämie anzeigen. Verpflichtungsfortbestand bei fehlendem Antrag ist vom Zahlungsanspruch zu trennen.

Verbraucher/Katalog: [rules/rules.json:2733](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/rules/rules.json#L2733), [policy/o6_8/general.rego:210](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L210), [policy/o6_8/general.rego:208](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L208), [policy/o6_8/general.rego:218](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L218), [policy/o6_8/general.rego:220](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L220).

Quellen: o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 13 (6 Antragstellung); o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 15 (7.1 Flächenabgänge); 20241011_srl_oepul_2023.pdf PDF-Seite 13 (1.7.2 Spezifische Bestimmungen mehrjähriger Maßnahmen); 20241011_srl_oepul_2023.pdf PDF-Seite 13 (1.7.2.1 Verlust der Verfügungsgewalt); 20241011_srl_oepul_2023.pdf PDF-Seite 22 (1.10.5.3 Zahlungsantrag).

### O68-GEN-ADM-02: Persönliche Voraussetzungen und bestimmender öffentlicher Einfluss sind nur teilweise repräsentiert

Rechtsform, Beteiligungsquote und aktiver Landwirt werden tatsächlich gelesen; eigene Rechnung/eigener Name, tatsächliche Landwirtschaft, Verfügungsgewalt und anderer bestimmender Einfluss fehlen. Die positive vorhandene Komponente ist deshalb noch keine vollständige persönliche Fachfreigabe.

Ein bewusster Eingangs-/Nachweisvertrag ist nötig. Ein fehlender Beleg ist kein bewiesener Verstoß; die bekannten vorhandenen Negativgates werden ausdrücklich anerkannt.

Verbraucher/Katalog: [policy/o6_8/general.rego:69](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L69), [policy/o6_8/general.rego:63](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L63), [policy/o6_8/general.rego:65](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L65), [policy/o6_8/general.rego:78](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L78), [policy/o6_8/general.rego:76](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L76).

Quellen: o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 4 (5.2 Förderwerbende Personen); 20241011_srl_oepul_2023.pdf PDF-Seite 8 (1.4 Förderwerbende Personen); o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 5 (5.2 Förderwerbende Personen); o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 4 (5.2); 20241011_srl_oepul_2023.pdf PDF-Seite 8 (1.4).

### O68-GEN-ADM-03: Übernahme-, Übergabe- und Anerkennungshelfer ersetzen keine Behördenhistorie

Die vorhandenen Teilfunktionen berechnen Frist/50%-Grenze oder vergleichen Reason-Flags. Antrag, AMA-Genehmigung, kausale Anerkennung, Nachfolger und konkrete Ereigniszeitpunkte sind nicht vollständig verbunden.

Die App darf diese Komponenten als Hilfsprüfung anbieten; eine vollständige Genehmigung, ein allgemeiner Rückforderungsverzicht oder Haftungsübergang ist damit nicht belegt.

Verbraucher/Katalog: [policy/o6_8/general.rego:227](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L227), [policy/o6_8/general.rego:231](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L231), [policy/o6_8/general.rego:225](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L225), [policy/o6_8/general.rego:216](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L216), [policy/o6_8/general.rego:208](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L208).

Quellen: o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 14 (6.3 Maßnahmenübernahme); 20241011_srl_oepul_2023.pdf PDF-Seite 14 (1.7.3.1 Übernahme); o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 16 (7.1 Flächenabgänge); 20241011_srl_oepul_2023.pdf PDF-Seite 13 (1.7.2.2 Betriebsübertragung); 20241011_srl_oepul_2023.pdf PDF-Seite 15 (1.7.4.2 Dauerhafte Umstände).

### O68-GEN-ADM-04: Umgehende Korrektur, Selbstanzeige und Konditionalität bleiben Katalogpflichten

Keine aktiven Änderungs-, Meldungs- oder allgemeine Konditionalitätszustände. Aktuelle Codefehler können keine Prüfung eines rechtzeitig veranlassten Verwaltungsverfahrens ersetzen.

Für endgültige Auszahlung und aktuelle fachliche Handlungshinweise bleiben zusätzliche Tatsachen und Prozesse erforderlich; ein fixer pauschaler Sanktionsprozentsatz wird nicht erfunden.

Verbraucher/Katalog: [rules/rules.json:1580](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/rules/rules.json#L1580), [rules/rules.json:2549](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/rules/rules.json#L2549), [rules/rules.json:2239](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/rules/rules.json#L2239).

Quellen: o6_8_erosionsschutz_acker_2026_04.pdf PDF-Seite 7 (5 Beantragung); o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 9 (5.5.2 ÖPUL-Code OP); o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 4 (5.1 Konditionalität); o6_8_erosionsschutz_acker_2026_04.pdf PDF-Seite 7 (5); o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 9 (5.5.2).

### O68-GEN-O68-P-F01: General fodder/retired-land management is classification-only

The current rule identifies fodder but never checks the source annual mowing/removal or grazing duty, nor generic biennial retired-land care. BAW correctly has its own exempt status and specific maintenance rules. The actual applicable general duty must be established before claiming payment impact.

This candidate cannot independently verify these catalogue duties; a category label is not a compliance proof.

Verbraucher/Katalog: [policy/o6_8/general.rego:106](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L106), [policy/o6_8/general.rego:109](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L109).

Quellen: o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 6 (5.4 Ernte und Mindestpflege); o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 6 (5.5 Ausnahmen von Mindestbewirtschaftung).

### O68-GEN-O68-P-F02: Several non-eligible land facts are absent from the proposed contract

Non-arable/crop/code checks do not represent actual non-agricultural dominance, wrong reference identification, inactive production or GLÖZ landscape status. There is no independent proposed classification or fact for those exclusions.

An arable/crop declaration alone cannot justify a complete eligibility release; these source facts require an upstream authority classification or additional evidence.

Verbraucher/Katalog: [policy/o6_8/general.rego:171](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L171), [policy/o6_8/premium.rego:16](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego#L16).

Quellen: o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 6 (5.5 Aktive Produktion); o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 7 (5.5.1 Nicht förderfähige Flächen).

### O68-GEN-O68-P-F03: Control refusal has no executable input or consequence

The source requires denial of the current claim, termination and unwinding of existing contracts for an unexcused prevention/refusal, with higher-force/extraordinary exceptions. The catalogue has no executable symbol and the proposed input has no control-refusal fact; no consumer applies the consequence.

The app cannot evaluate this explicit authority rejection/recovery condition and must not treat an otherwise computed amount as approved despite it.

Verbraucher/Katalog: [policy/o6_8/premium.rego:52](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego#L52), [policy/o6_8/premium.rego:63](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego#L63).

Quellen: 20241011_srl_oepul_2023.pdf PDF-Seite 23 (1.11.1.2 Kontrollverweigerung und Ausnahme).

### O68-GEN-O68-P-F04: Sanction stages and ordered deductions remain lookup data

The source-year lookup is present, but no assessed stage/history or ordered deductions are consumed by the financial result. A mere detected management breach cannot select a unique reduction percentage or mandatory zero. Core owns the distinct code-compliance automatic exclusion mechanism.

premium_after_modulation_eur is not a completed authorised net calculation after all source deductions or recoveries.

Verbraucher/Katalog: [policy/o6_8/general.rego:273](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L273), [policy/o6_8/general.rego:279](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L279), [policy/o6_8/premium.rego:142](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego#L142).

Quellen: o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 18 (8.2 Stufen und Warnung ab2027); 20241011_srl_oepul_2023.pdf PDF-Seite 24 (1.12.1.3 Inhaltliche Auflagen); 20241011_srl_oepul_2023.pdf PDF-Seite 25 (1.12.2 Reihenfolge).

### O68-GEN-O68-P-F05: Area-cap detection uses the own premium before modulation

The delivered order applies modulation before the area-payment cap. area_cap_exceeded adds raw parcel_premium_eur/area to the supplied other payments. With a relevant 500 ha home area the factor is 0.92; an 81 EUR/ha US component becomes 74.52. If other correctly countable payments after prior stages equal 1220 EUR/ha, the source total is 1294.52, below 1300; the native comparison is 1301 and incorrectly flags excess.

The app can warn of a cap excess that does not exist at the required calculation stage. This finding does not invent an allocation of a real excess among measures.

Verbraucher/Katalog: [policy/o6_8/premium.rego:130](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego#L130), [policy/o6_8/premium.rego:140](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego#L140).

Quellen: o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 19 (9.2 Vollständige Obergrenzentabelle); 20241011_srl_oepul_2023.pdf PDF-Seite 25 (1.12.2 Reihenfolge).

### O68-GEN-O68-P-F06: Modulation assumes the alpine separation is irrelevant

Assumption 16 states that the alpine special treatment is irrelevant for measure 8. The actual consumer reads the whole land.total_area_ha. A known 100 ha home holding plus 200 ha separately treated Almbewirtschaftung area gives native factor 290/300 instead of the home factor 1. The source exception concerns the denominator scope and remains relevant to a mixed farm.

A mixed home/alpine farm can receive an excessive reduction on the home arable component.

Verbraucher/Katalog: [policy/o6_8/premium.rego:140](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego#L140).

Quellen: o6_allgemeine_teilnahmebedingungen_2026_04.pdf PDF-Seite 19 (9.3 Modulation, Beispiel und Heim-/Almtrennung); 20241011_srl_oepul_2023.pdf PDF-Seite 17 (1.9.2.2 Modulation).

### O68-GEN-O68-P-F07: UBB/BIO cross-effects accept procedure coding as actual implementation

The legal trigger is the absence of an erosion-reducing procedure. The native helper tests only whether the code set intersects all_codes, without consulting actual establishment or proved procedure failures. A US code on a steep erosion-prone parcel where no undersowing was actually established suppresses the cross-effect. A coding label is not positive proof of an implemented procedure.

The interface can omit the UBB/BIO basic-premium effect despite an established absence of a qualifying erosion procedure. These are cross-effect helpers, not a full audit or calculation of other measures.

Verbraucher/Katalog: [policy/o6_8/cross_measures.rego:32](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/cross_measures.rego#L32).

Quellen: 20241011_srl_oepul_2023.pdf PDF-Seite 34 (2.1A Höhe der Förderung, steile Schläge (Satzbeginn)); 20241011_srl_oepul_2023.pdf PDF-Seite 35 (2.1A Höhe der Förderung, steile Schläge (Satzfortsetzung)); 20241011_srl_oepul_2023.pdf PDF-Seite 44 (2.1B Höhe der Förderung, steile Schläge und Übergang 2025); o6_8_erosionsschutz_acker_2026_04.pdf PDF-Seite 4 (4.4 Ordentliche Anlage und Feldaufgang der Untersaat).

## Kontrollen, Behördenzustände und Grenzen

Der Elternteil enthält 48 frische Kontrollen zu echten Vertragsjahren und Dauern, normaler Antragsfrist, letztem Einstieg, Rechtsformen und öffentlicher Beteiligung, erstem ÖPUL-Jahr, laufendem Zahlungsantrag, tatsächlich wirksamem Ausstieg, wirksamer Revisionsbeendigung, Flächeninventar, Übernahmefristen/-ausweitung, Übergabe und erforderlichem Code. Der zusätzliche Quellenreview umfasst 43 Kontrollen zu Management, OP/VF, Park-/Gebietsbindung, Dürre, US, Zahlungsgrenzen, Cap-Reihenfolge, Modulationsbasis und der eng begrenzten UBB/BIO-Querwirkung. Jede Erwartung ist mit frischem Originalwortlaut und der tatsächlichen nativen Abfrage gebunden.

Die reine Zeitbindung passt in diesen aktuellen Kontrollen. Der bekannte fehlende Zahlungsantrag wird als No-premium-Komponente erkannt, aber nicht zur aktuellen Codefreigabe weitergereicht. Beim vorläufig fortbestehenden Mehrjahresvertrag bedeutet das keine aktuelle Zahlung; eine noch offene einjährige Nachreichungsmöglichkeit darf nicht als bereits abgelaufene konkrete Frist ausgegeben werden. Ebenso werden tatsächliche aktuelle/vorjährige Ausstiege und ein nach wirksamer Revisionsverweigerung beendeter Vertrag nicht durch den noch passenden Start-/Endjahresrahmen aufgehoben.

Nicht repräsentierte Kontrollverweigerung, eigene Rechnung, tatsächliche Landwirtschaft, Verfügungsgewalt oder anderer bestimmender öffentlicher Einfluss bleiben ausdrücklich Quellen-/Interfacekontrollen. Es werden keine unbekannten produktiven Felder eingeführt und keine extern stipulierte Behördenentscheidung als vollständiges Input-only-Goldlabel ausgegeben. Übernahmehelfer prüfen nur Frist und Ausweitung; bisherige Nichtteilnahme, Übernahmeantrag und AMA-Genehmigung bleiben zusätzliche Voraussetzungen. Bei einem rückzahlungsfreien dauerhaften Umstand ist im positiven Szenario die tatsächliche AMA-Anerkennung ausdrücklich zusätzlich zur Meldung stipuliert. Eine bloße Meldung belegt diesen Verzicht nicht.

Der Tabellen-Metadatenhinweis `force_majeure_premium_year_cutoff_mmdd` ist kein aktiver allgemeiner Höhere-Gewalt-Stichtag. Die gebundene SRL-Seite 15 behandelt bei diesem Datum dauerhafte Umstände ausdrücklich außerhalb höherer Gewalt; der generische Name darf diese Reichweite nicht erweitern. Die Tabellenprüfung dokumentiert den unbenutzten Metadatenumfang separat.

Eine bewiesene beliebige Managementverletzung schreibt nicht automatisch 100 Prozent Kürzung vor. Behördenbewertung, einzelne Prämienkomponente, Jahreszahlung und historische Rückabwicklung bleiben getrennt. Bei der UBB/BIO-Querwirkung wird nur die konkrete Schnittstellenaussage geprüft, keine vollständige fremde Maßnahmenprämie erfunden. Der Modulationsfall stipuliert die getrennte tatsächliche Heim-/Almfläche; er behauptet keine frei erfundene fremde Förderung. Die Flächenobergrenzenkontrolle bindet die anderen Zahlungen an bereits autorisierte Kombinationen und an bereits durchlaufene frühere Berechnungsstufen.

Die Ausführung verwendet Gleichheit für tatsächliche Strings, Tupel und Stringmengen sowie explizite Bool-/Count-Projektionen für Prädikate. Gewöhnliche Rego-Prädikatsabwesenheit wird nicht als vom Gesetz vorgeschriebener OPA-Status behandelt. Laufzeitfehler und der gesondert bestätigte gemischte Zahlenvergleichsfehler der gepinnten OPA bleiben technische Befunde; Quellenerwartungen und historische numerische Typen werden daran nicht angepasst.

## Vollständige historische Regelzuordnung

Alle 46 zugewiesenen IDs besitzen im JSON eine einzelne semantische Bewertung mit Quelle, Version und Codeanker. Weitere Quellenpflichten stehen separat und erhalten keine erfundenen historischen IDs. Reine Katalogregeln werden nicht als implementierte Verbraucher gezählt.

| Historische ID | Bewertung | Erster Verbraucher oder Kataloganker |
|---|---|---|
| `o6_8.contract.duration` | `implemented_with_input_contract_limits` | [policy/o6_8/general.rego:13](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L13) |
| `o6_8.application.deadline_31_dec` | `implemented_with_input_contract_limits` | [policy/o6_8/general.rego:28](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L28) |
| `o6_8.application.last_entry_2025` | `implemented_with_input_contract_limits` | [policy/o6_8/general.rego:34](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L34) |
| `o6_8.application.codes_required` | `implemented_with_input_contract_limits` | [policy/o6_8/common.rego:35](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/common.rego#L35) |
| `o6_8.application.cancel_codes_immediately` | `catalog_only` | [rules/rules.json:1580](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/rules/rules.json#L1580) |
| `gen.source_precedence` | `catalog_only_source_package_boundary` | [rules/rules.json:2188](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/rules/rules.json#L2188) |
| `gen.definitions.crop_groups` | `implemented_with_input_contract_limits` | [policy/o6_8/common.rego:15](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/common.rego#L15) |
| `gen.conditionality` | `catalog_only` | [rules/rules.json:2239](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/rules/rules.json#L2239) |
| `gen.applicant.eligible_persons` | `partial` | [policy/o6_8/general.rego:69](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L69) |
| `gen.applicant.public_bodies_excluded` | `implemented_with_input_contract_limits` | [policy/o6_8/general.rego:76](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L76) |
| `gen.min_farm_size.first_year` | `implemented_with_input_contract_limits` | [policy/o6_8/general.rego:85](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L85) |
| `gen.self_report` | `catalog_only` | [rules/rules.json:2549](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/rules/rules.json#L2549) |
| `gen.commitment_period_calendar_year` | `implemented_with_input_contract_limits` | [policy/o6_8/general.rego:151](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L151) |
| `gen.area_annually_variable` | `implemented_with_input_contract_limits` | [policy/o6_8/general.rego:189](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L189) |
| `gen.area_reduction_tolerance` | `implemented_generic_component_not_own_measure_repayment` | [policy/o6_8/general.rego:194](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L194) |
| `gen.area_increase_not_restricted` | `implemented_with_input_contract_limits` | [policy/o6_8/general.rego:192](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L192) |
| `gen.contract_period_repayment` | `partial` | [policy/o6_8/general.rego:210](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L210) |
| `gen.exit_procedure` | `catalog_only_with_unconsumed_event_inputs` | [rules/rules.json:2733](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/rules/rules.json#L2733) |
| `gen.farm_handover` | `partial` | [policy/o6_8/general.rego:216](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L216) |
| `gen.takeover` | `implemented_deadline_and_expansion_components_only` | [policy/o6_8/general.rego:227](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L227) |
| `gen.missing_payment_application` | `partial` | [policy/o6_8/general.rego:218](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L218) |
| `gen.access_condition_consequence` | `implemented_diagnostic_component_with_scope_limits` | [policy/o6_8/general.rego:53](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L53) |
| `gen.force_majeure_circumstances` | `partial` | [policy/o6_8/general.rego:208](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L208) |
| `gen.revision_clause` | `partial` | [policy/o6_8/general.rego:208](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L208) |
| `gen.amendment_application_dates` | `implemented_version_components_with_source_boundaries` | [policy/o6_8/premium.rego:93](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego#L93) |
| `gen.min_management.arable_harvest_85` | `implemented_with_input_contract_limits` | [policy/o6_8/general.rego:109](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L109) |
| `gen.min_management.fodder_and_set_aside` | `partial` | [policy/o6_8/general.rego:109](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L109) |
| `gen.non_eligible_areas` | `partial` | [policy/o6_8/general.rego:151](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L151) |
| `gen.national_parks` | `implemented_with_input_contract_limits` | [policy/o6_8/general.rego:127](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L127) |
| `gen.trial_areas_vf` | `implemented_with_input_contract_limits` | [policy/o6_8/general.rego:151](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L151) |
| `gen.op_code.no_premium` | `implemented_with_input_contract_limits` | [policy/o6_8/general.rego:138](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L138) |
| `gen.op_code.mandatory` | `partial` | [policy/o6_8/general.rego:176](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L176) |
| `gen.location_austria` | `implemented_with_input_contract_limits` | [policy/o6_8/general.rego:100](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L100) |
| `gen.controls` | `catalog_only` | [rules/rules.json:2922](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/rules/rules.json#L2922) |
| `gen.sanction_stages` | `implemented_with_input_contract_limits` | [policy/o6_8/general.rego:273](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L273) |
| `gen.multiple_reductions_order` | `partial` | [policy/o6_8/general.rego:279](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L279) |
| `gen.payment` | `implemented_with_input_contract_limits` | [policy/o6_8/general.rego:246](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L246) |
| `gen.area_payment_cap` | `partial` | [policy/o6_8/general.rego:252](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L252) |
| `gen.modulation` | `partial` | [policy/o6_8/general.rego:262](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego#L262) |
| `n2026.us_full_coverage_waived` | `implemented_with_input_contract_limits` | [policy/o6_8/notices_2026.rego:10](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/notices_2026.rego#L10) |
| `n2026.harvest_obligation_drought_districts` | `implemented_with_input_contract_limits` | [policy/o6_8/notices_2026.rego:19](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/notices_2026.rego#L19) |
| `n2026.harvest_obligation_individual_application` | `implemented_with_input_contract_limits` | [policy/o6_8/notices_2026.rego:39](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/notices_2026.rego#L39) |
| `n2026.controls_consider_drought` | `implemented_with_input_contract_limits` | [policy/o6_8/notices_2026.rego:53](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/notices_2026.rego#L53) |
| `n2026.div_early_use_baw_obligations_remain` | `implemented_with_input_contract_limits` | [rules/rules.json:3222](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/rules/rules.json#L3222) |
| `o6_8.cross.ubb_basic_premium_steep_parcels` | `partial` | [policy/o6_8/cross_measures.rego:32](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/cross_measures.rego#L32) |
| `o6_8.cross.bio_basic_premium_steep_parcels` | `partial` | [policy/o6_8/cross_measures.rego:45](../../../../../runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/cross_measures.rego#L45) |

Der historische Katalog umfasst 114 IDs: dieser Teil 46, Domain 65 und Core 3. Die drei Core-IDs einschließlich `o6_8.premium.calculation` werden vom Rootteil unabhängig bewertet; hier dokumentierte Schnittstellenbefunde erzeugen keine zusätzlichen historischen IDs.
