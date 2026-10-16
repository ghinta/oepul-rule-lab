# o6_10: allgemeine Voraussetzungen und Verfahrensregeln

Historischer Run `v2-o6_10-opus-5.5-high-20260925`, unveränderter Kandidat `e009eed4a83ff076b26eba33ac433ac2b0642621`. Die Prüfung gehört zu Sammelissue #112 und demselben Auditbranch. Weder GM-/Studienurteile, frühere manuelle Adaptationen noch generierte Selbsttests dienen als Sollurteile.

51 historische IDs sind einzeln in [general.json](general.json) bewertet: 33 durch den Elternprüfer und 18 durch einen unabhängigen Teilprüfer. **124 neue Fälle mit 124 Checks: alle definiert, 116 erfüllt, 8 abgewichen, keine Laufzeitfehler oder undefinierten Ergebnisse.** Die gemeinsame Wiederholung und unabhängige Qualitätsabnahme erfolgen beim Root. Hinzu kommt eine ausdrücklich getrennte native Beobachtung zu A09 ohne Solloracle.

Die 14 Befundgruppen und 13 zusätzlichen Pflichtgruppen überlappen. Die gezielten öffentlichen Prüfungen bilden keine Genauigkeitsstichprobe. Mehrere Abweichungen gelten ausdrücklich nur bei der jeweils angegebenen Bedeutung vorgelagerter Eingaben.

## Quellen und tatsächliche Lektüre

Das neue Merkblatt mit Hash `cb2988f1292088ee42d90f9e0267e80ecef4ea64de64e601678335e6b1368aec` wurde auf allen sechs Seiten vollständig gelesen, einschließlich Tariftabelle, Ausnahmen, Aktualisierungen und Rechtsunverbindlichkeit. Sämtliche acht Rego-Module mit 1.196 Zeilen und alle 20 Rohannahmen samt Eingabeersatzwerten wurden persönlich vollständig gelesen.

Alle acht tatsächlichen Originalhashes sind bestätigt. Bei sieben gemeinsamen Quellen bindet der identische Hash die dokumentierte frühere Volllektüre; aktuelle relevante ATB-/SRL-Klauseln wurden wieder gelesen. Anhang L, Seite 103, wurde vollständig extrahiert und visuell geprüft, insbesondere Zeile 10, Legende und Fußnoten 1–4. Die exakten Leseseiten und Herkunftsbindungen stehen im JSON. Der unabhängige Teilprüfer hat auch die vier Mitteilungen erneut vollständig gelesen.

Das Quellenpaket enthält **keine GSP-AV und keine NAPV**. Die im vorigen Run tatsächlich vorhandene GSP-Datei wird diesem Run nicht zugerechnet. Ein Verweis in ATB/SRL ersetzt das fehlende Original nicht. Insbesondere werden weder die geänderte Wochenend-/Feiertagsregel noch die Detailregel zur Kumulation aus dem vorigen Paket heimlich zum Solloracle.

156 gebundene Belegdatensätze wurden direkt im tatsächlichen Original erneut geprüft. Normalisiert werden ausschließlich Leerraum und Soft Hyphen; hochgestellte Zeichen bleiben erhalten. Entscheidende Ausnahmen und Alternativen stehen unmittelbar bei den entsprechenden Fällen, Regelbewertungen und Befunden.

## Konkrete Abweichungen und ihre Grenzen

| Komponente | Positiv feststehende Quellfakten | Erwartung | Native Beobachtung |
| --- | --- | --- | --- |
| Unterer Antragszeitbereich | Einziger Antrag 2021, kein neuer Antrag/keine Übernahme; SRL 27 gilt erst für ab 2. November 2022 gestellte Anträge und begründete Verpflichtungen | Kein aktueller Vertrag | `contract_valid=true` |
| Wortform Walnüsse | Bekannte Walnusskultur, genau so im MB-4-Beispiel bezeichnet; unveredeltes Material und OP sind bereits richtig codiert | Kultur bleibt Obst; kein Prämienanspruch behauptet | Obstklassifikation `false` |
| Andere Schalenfrucht | Unabhängig positiv bestimmte Pistazienkultur; ATB 4/SRL 9 umfassen ausdrücklich „andere Schalenfrüchte“ | Obstklassifikation `true` | Exakte Literalnamenliste liefert `false` |
| Erstjahresgröße bei Bruttototal | Bekannte 0,50 ha Österreich und 1,50 ha Ausland; `total_area_ha` ist ausdrücklich die ungefilterte Summe | Österreichische Erstjahresgröße nicht erfüllt | Vertrag wird zugelassen |
| Kalenderjahr der Kontrollankündigung | Kontrolle derselben aktuellen Verpflichtung am 31. Dezember des Vorjahres angekündigt, Austrittsversuch am 1. Jänner danach | Kontrollsperre greift | `deregistration_blocked=false` |
| Anerkannte Kontrollverhinderung | Das rohe Ereignisflag bezeichnet ausdrücklich auch eine unabhängig anerkannte höhere Gewalt | Ausnahme bleibt berücksichtigt | Tatsächliche Nullzahlungssperre greift auch hier |
| Endgültige andere Förderung | Unabhängig endgültig feststehende, unverändert fortgeführte andere Flächenförderung bereits 1.300 €/ha | Kein weiterer Betrag auf diese feste Summe | Anteilsformel lässt positive eigene Zahlung stehen |
| Heimfläche/Alm | `total_area_ha` ist ausdrücklich ungefilterte 400 ha mit 200 ha Heimfläche und 200 ha separat behandelter Alm | Heimflächenfaktor 1 | Faktor 0,9375 |

Die drei letzten Teilprüferfälle sowie das österreichische Bruttototal sind **bedingte Eingabevertragsfälle**. Wenn vorgelagert bereits nur rechtlich unentschuldigte Kontrollverhinderungen, nur österreichische bzw reine Heimfläche oder synchron neu berechnete andere Zahlungen übergeben werden, folgt daraus dieser jeweilige Gegenfall nicht. Die entscheidende Bedeutung muss im Eingabevertrag festgelegt werden. Bei der Förderungskappung wird keine frei erfundene Prioritätsregel für gleichzeitige Bruttoanträge behauptet.

Die Pistazienkontrolle gibt kein beliebiges unbekanntes Label frei. Ihre tatsächliche Zugehörigkeit zur ausdrücklich offenen Schalenfruchtgruppe ist als unabhängiger positiver Fallfakt festgelegt. Ein unbekannter String und ein bestimmtes Mitglied einer offenen Quellgruppe sind verschieden. Bei „Walnüsse“ wird nur die bekannte Kulturidentität geprüft; OP und fehlende Veredelung begründen ausdrücklich keinen aktuellen Prämienanspruch.

## Tatsächlich funktionierende Verbraucher

Die aktuelle Mindestteilnahmefläche, reguläre Antragstellung für das Folgejahr, künftiger Vertragsbeginn, letzte Ersteinstiegsjahre, persönliche Negativvoraussetzungen und die öffentliche Ausnahme nur bis 2024 sind echte Vertragsgates. Aktuell fehlender MFA und bekannte unentschuldigte Kontrollverweigerung blockieren die Auszahlung tatsächlich. Ein neuer Antrag nach wirksamer Abmeldung kann wieder einsteigen.

Ausländische Schläge werden aus Teilnahme- und Prämienflächen genommen. GLÖZ, nicht teilnahmefähige Kulturen, konkrete Parkkulissen, OP, maßnahmenspezifischer Ausschluss, bekannte fehlende Dauerkulturpflege und nicht fortgeführte unterjährige Weitergabe werden als echte Schlagfilter verarbeitet. Die pauschale 85%-Ackerregel wird nicht auf Dauerkulturen übertragen. Andere Nationalparks bleiben bei ausdrücklich quellenqualifizierten positiven Tatsachen möglich.

Bewertete behördliche Sanktionsstufen werden diesmal tatsächlich angewandt; Modulation und Kappungsregime haben konkrete Verbraucher. Einzelne endgültig zugewiesene Stufen, Warnung 0% bis 2026 bzw 1% ab 2027, sowie qualifizierter Ausschluss sind von einer frei aus einem Bewirtschaftungsfehler erfundenen 100%-Sanktion getrennt. Die 50-Euro-Klausel bleibt eine Kann-Bestimmung und setzt den Betrag nicht automatisch auf null.

**Root besitzt `OUTPUT_SCOPE`** für die übergreifende Interpretation von Verpflichtungsverletzungen und nominalen bzw zahlbaren Beträgen. Hier wird eine nicht modellierte behördliche Bewertung weder als Vollgenehmigung noch als beliebiger Komplettabzug dargestellt.

## Erhaltene offene Punkte

A09 nimmt bei mehreren bewerteten Feststellungen `max`. ATB enthält Stufen und maßnahmenbezogene Beurteilung, SRL verweist auf die nicht beigefügte GSP-AV. Die vorangegangene Run-9-Fassung liefert diesem Paket keine nachträglich bereitgestellte Summenregel. Darum gibt es dazu eine separate native Beobachtung und Quellenabhängigkeit, keinen aus externer Norm eingeführten harten Summen-Oracle.

Die tatsächliche ATB nennt für die Übernahme 2028 den 17. April. Dieser Wert wird als beigefügter Quellenliteral kontrolliert; die abschließende gesetzliche Fristbehandlung einschließlich Feiertagen braucht die passende fehlende GSP-Fassung. Ebenso beweisen letzte Ersteinstiegsdaten allein kein generelles Ende bestehender Jahresverträge 2028. Ein harter `2029 → false`-Oracle wird nicht erzeugt.

Historische Mindestflächenunterbrechung, ein volles früheres Jahr ohne MFA, tatsächliche Selbstanzeige, nachgewiesenes Fremdverschulden, Eingang der eAMA-Meldung und erforderliche Übernahmegenehmigung sind nicht durch einfache aktuelle Flags vollständig festgestellt. Positive Übernahmekomponenten setzen in ihren Fallfakten die tatsächliche Genehmigung voraus. Direkte Helfer erteilen diese Genehmigung nicht selbst.

Die allgemeine Flächendefinition und Getreideliste sind gespeicherte Daten; sie beweisen keine vollständige geometrische Prüfung bzw botanische Anteilsberechnung. Kombinationsfußnote 1 erlaubt 1A nur für Landschaftselementabgeltung, nicht beliebige UBB-Grundförderung auf Weinflächen. Die konkreten positiven Kombinationsfälle legen genau diese zulässige Leistung fest. Zurücknahme einer unmöglichen Kombination bleibt ein eigener Verfahrensschritt.

## Konstruktions- und Typprüfung

Vor dem Einfrieren wurden die Erstjahresfälle mit passenden Antragsjahren, sämtliche Flächensummen und die OPBIO-Konstellation intern konsistent gemacht und anschließend alle 81 Elternfälle vollständig erneut ausgeführt. Der Teilprüfer hat seine 43 Fälle separat vollständig ausgeführt. Der generische temporäre Helpername kollidierte zwischen Reviewern; die Teilprüfer verwenden seitdem eigene Konstruktiondateien. Kein eingefrorenes Artefakt und kein historischer Kandidat wurde dadurch geändert.

Eine gemeinsame begrenzte Prüfung aller 124 Inputs fand bei 8.634 vorhandenen primitiven Blattwerten keine Typ-, Enum-, Datums- oder Objekt-/Array-Abweichung und keine unverwalteten Pfade. Fehlende Pflichtangaben, vollständige Quellwahrheit und Tatsachenkonsistenz werden damit nicht pauschal zertifiziert. Die Enum-Gegenprüfung wird zusätzlich separat gebunden.

Der unabhängige Teilbericht folgt zur Herkunft der 18 IDs. Seine 43 Fälle sind bereits in den obigen 124 enthalten.

---

# o6_10 — bounded legal/general source audit

Exactly18historicalIDs; 43 fresh public cases/checks, 43 defined, 40 met and 3 unmet, 0 errors, 0 undefined.

All six new MB pages and eight modules/all raw notes fully read. Actual current ATB/SRL assigned pages and all four HTML notices reread against exact-byte prior full shared sources. Packet8originals contains noGSP-AV orNAPV. A09cumulation is retained as an open dependency with native observation only, no new normative oracle.

The genuine refusal payment block, individual sanction stages, base-plus-EOP reduction, band modulation, code-driven exclusions and conditional payment/minimum-payment outputs are credited. Three targeted failures concern the recognized refusal exception, final fixed other funding at the combined cap, and gross total including separate alpine area. Their source-fact/input contracts are explicit.

## Historical assessments

- `O610-GEN-CONDITIONALITY` — notice_only_source_dependency: The explicit breach flag produces a real notice, no conditionality/social-conditionality amount or approved percentage input. Referenced MOG/EU/GSP and Konditionalität leaflet are not supplied; full rule/percentage assessment remains an external source and authority dependency.
- `O610-GEN-CONTROLS` — input_only_authority_scope: findings genuinely consumes supplied stage records, but no execution of administrative/on-site/audit control procedure or evidence-access/missing-document deadlines. SRL24 explicitly says the inspecting person cannot assess legal consequences: stage values must be final competent AMA assessments, not raw inspection opinions.
- `O610-GEN-CONTROL-REFUSAL` — implemented_block_with_missing_exception_contract: A known unexcused refusal/prevention is an actual payable_total0 block and notice, recognized as a working consumer. The explicit force-majeure/extraordinary-circumstances exception has no separate input. If the boolean means the raw physical event, recognized exceptional prevention is blocked identically; if upstream already supplies only legally unexcused events, that countercase does not apply. Contract termination/rollback are not represented.
- `O610-GEN-SANCTION-GROUNDS` — catalogue_data_only: All five source ground categories are stored. No direct stage assignment derives from them, correctly avoiding an invented universal management100percent sanction. The multiannual-contract ground is generic catalogue information, not an annual measure10 prerequisite.
- `O610-GEN-SANCTION-STAGES` — implemented_with_open_cumulation_and_history_scope: Single already assessed source stages are consumed, including warning0until2026/1from2027, exclusion and two distinct finalized full reductions within the actual contract. A09 selects max for multiple findings without a supplied detailed accumulation rule. Referenced GSP§48 is absent; do not import previous run9 GSP bytes as if provided. Repetition identity, authorized recovery scope and lifecycle still require history/authority contracts.
- `O610-GEN-SANCTION-MEASURE-LEVEL` — implemented_assessed_component: content_factor really applies the assessed measure reduction to base and EOP supplement, followed by modulation/cap. This is a supported use of a finalized source stage, not proof that raw obligation diagnostics independently map to that same stage.
- `O610-GEN-REDUCTION-ORDER` — partial_pipeline: All11source reduction-order rows are stored. The actual executable path covers assessed content reduction then modulation then area cap, with contract/refusal/exclusion/payment blocks. Over-/underdeclaration, deadline, conditionality and refund stages are not a complete11-step implementation, and data rows have no general executable order dispatcher.
- `O610-GEN-PAYMENT` — implemented_information_component: Actual deadline30June nextyear and max75percent of payable component are correct. Advance requires completed administrative control and budget availability; helper max is a ceiling, not release authorization. December start is only an external referenced GSP dependency in this packet, so no exact new December-oracle is introduced.
- `O610-GEN-MIN-PAYOUT` — implemented_discretionary_flag: Actual <=50 positive payable amount produces a notice/flag and retains the numeric component. Correctly preserves Kann language; zero is unflagged but no material zero-payment entitlement is inferred.
- `O610-GEN-CAP` — partial_final_other_payment_contract: Actual year table excludes10in2023/24 and includes10from2025; ordinary bounds work. A10 proportionally allocates excess to this measure only. Without a synchronized reallocation of other funding, declared independently final retained other funding at1300 still leaves a positive current amount beyond combined cap. Countercase applies only to that explicit final-other-funding contract; proportional allocation remains open for simultaneous gross claims.
- `O610-GEN-MODULATION` — implemented_with_home_area_contract_gap: Correct source bands and220ha example are really consumed. One aggregate total is used with no explicit home/alpine distinction: if total includes separately treated Alm, the home measure factor is too low. If upstream already provides home-only total, that countercase does not apply. Input meaning must be explicit.
- `O610-GEN-FORCE-MAJEURE` — partial_special_notice_only: Only the narrow2026automatic greening relief has a native consumer. General recognized force majeure, permanent/temporary changed circumstances, AMA acceptance, notification and BML exceptions are not represented. Referenced §6GSP not supplied and MFA2026leaflet not supplied; no amended deadline or invented blanket waiver is used.
- `O610-GEN-TRIAL-AREAS` — implemented_code_with_upstream_evidence: VF genuinely excludes actual premium units. Source separately requires BMLwritten approval availability and documented type/extent/location. Those conditions have no independent current input/proof check; a code alone is no proof, and research that still meets obligations is not automatically an excluded trial.
- `O610-GEN-DOUBLE-FUNDING` — upstream_code_only: Only already set general OP or op_excluded_measures10 remove overlapping service units. No native same-service legal/other-public-title determination is modeled. Correctly distinguish known same-service continued funding from merely compatible other area payments; missing OP is not evidence of no overlap.
- `O610-GEN-REVISION-CLAUSE` — catalogue_only_missing_input_and_consumer: The source norm is catalogued without executable symbol or rejected-adaptation/contract-ended input. A valid rejected mandatory adaptation ends the original contract without historical recovery for duration, preserving other independently accrued claims. No generic no-refund or main payment oracle invented.
- `O610-2026-FORCE-MAJEURE-APP` — catalogue_only_external_application: May22explicitly permits individual eAMA applications for otherwise unfulfillable drought duties; the application route is real but has no native general submission/recognition interface. Application is not acceptance; no auto approval inferred.
- `O610-2026-DROUGHT-SCOPE` — implemented_scope_component: The model correctly keeps permanent-crop harvest and other greening duties separate from arable-only harvest relief and narrow measure10coverage relief. Full drought causation/temporal adequacy of that relief is reviewed by measure owner; the broad statement onlygreening is qualified by the still-available individual force-majeure route.
- `O610-GEN-COMBINATION-CORRECTION` — implemented_informational_procedure: Conflict triggers a real notice with before-payment-notice/noinspection-objection qualification. No event dates, fulfilled correction or objection history input exists. It is an informational route, not an unconditional correction authorization or automatic claim cancellation.

## Unmet controls

- `O610-LEGAL-refusal-recognised-exception`: expected `432 `; actual `0 ` (defined).
- `O610-LEGAL-cap-other-final-at-ceiling`: expected `0 `; actual `370.4485488126649 ` (defined).
- `O610-LEGAL-modulation-known-home-alpine-split`: expected `1 `; actual `0.9375 ` (defined).

Full exact exception/qualification quotes, actual consumer locations, source hashes and current read pages are bound in the JSON. There are no policy/canonical/source changes and no official approval claim.


Gemeinsames General-JSON SHA256: `d12492bc0ee0cf7cead1864962eab44a563cd5bc4272bc18384ab0d1bd27a19c`.


Zusätzlicher begrenzter Enum-Abgleich vor Freeze: alle 124 Fälle, 1.916 vorhandene explizite Enum-Werte, keine Abweichung. Dieser Wert zählt Enum-Vorkommen; die 8.634 Werte des getrennten Typchecks sind primitive Blattwerte.
