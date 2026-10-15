# o6_9: allgemeine Voraussetzungen und Verfahrensregeln

Historischer Opus-Run `v2-o6_9-opus-5.5-high-20261003`, unveränderter Kandidat `e009eed4a83ff076b26eba33ac433ac2b0642621`. Dies ist eine öffentliche Quellenprüfung im Sammelissue #112 und auf demselben Branch. Weder Studienreferenzen, GM-Urteile, frühere manuelle Adaptationen noch generierte Selbsttests wurden als Sollurteil verwendet.

51 historische IDs sind einzeln in [general.json](general.json) beurteilt: 33 durch den Elternprüfer und 18 durch einen unabhängigen Teilprüfer. 135 neue Fälle mit 135 Checks sind lokal nativ ausgeführt: **135 definiert, 125 Erwartungen erfüllt, 10 abgewichen, keine Laufzeitfehler oder undefinierten Ergebnisse**. Die gemeinsame unveränderte Wiederholung und Qualitätsabnahme bleiben beim Root. Die zehn Abweichungen umfassen zwei Kontrollen derselben Verlängerungsursache; sie sind keine zehn unabhängig gezogenen Modellfehler.

## Quellen und tatsächliche Lektüre

Das neue Merkblatt wurde auf allen neun Seiten einschließlich Tabellen, Aktualisierungen und Rechtsunverbindlichkeit gelesen, die neue NAPV auf allen 42 Seiten einschließlich sämtlicher Anlagen, Fußnoten und Gebietstabellen. Dazu kommen sämtliche acht Rego-Module und alle 21 historischen Annahmen samt Eingabeersatzwerten. Alle zehn Originalhashes wurden bestätigt.

Die acht gemeinsamen Originale werden über identische Hashes und dokumentierte frühere Volllektüre gebunden. Die aktuellen relevanten ATB-, SRL- und GSP-Seiten wurden erneut gelesen; die Seitenlisten stehen im JSON. Alle vier bereitgestellten Mitteilungen wurden in ihrem vollständigen Artikeltext erneut gelesen. Die GSP-Fassung ist in diesem Run tatsächlich enthalten. Ein früherer Run ohne dieses Original erhält dadurch keine rückwirkende Quellenabdeckung.

109 Belegdatensätze wurden nochmals direkt auf der gebundenen Seite bzw im Original-HTML geprüft. Der Belegabgleich normalisiert ausschließlich Leerraum und Soft Hyphen. Hochgestellte Zeichen bleiben erhalten; es wird keine NFKC-Normalisierung verwendet.

## Konkrete Abweichungen

| Komponente | Positiv feststehender Sachverhalt | Quelle / Erwartung | Native Beobachtung |
| --- | --- | --- | --- |
| Beginn des Maßnahmenvertrags | Einziger Vertrag beginnt 2027; Bewertungsjahr 2026; rechtzeitige Vorbeantragung | MB 6: gültiger Vertrag ab Folgejahr; aktuelle Zulässigkeit `false` | `eligible=true` |
| Beginn der Schweineoption | Alter Maßnahmenvertrag wirksam, einzige Kategorie beginnt erst 2027; Bewertung 2026 | MB 5–6: aktuelle Option noch nicht wirksam; `false` | `eligible=true` |
| Automatische Verlängerung | Keine Jahresmenge oder aktuelle Schweineoption; Vertrag ist nachweislich erloschen | MB 1–2/6: `auto_renewal=false` | `contract_lapsed=true`, zugleich `auto_renewal=true`; Eltern- und Teilprüfer kontrollieren dieselbe Ursache |
| FM-Meldefrist | Meldefähig ab 9. Mai 2026; 21. Tag ist Samstag, 30. Mai; Meldung Montag, 1. Juni | GSP 10–11: allgemeine Wochenendverschiebung; rechtzeitig | Helfer liefert `false` |
| Ausländische Schweine | Bekannte ausländische Tiere neben inländischen, GVE-Fallback aktiv | ATB 9: nur inländische Tiere zählen | GVE-Summe und daraus abgeleiteter Zugang sind überhöht; zwei Komponentenchecks |
| Ausländische Rinder | Bekannte ausländische Rinder, GVE-Fallback aktiv | ATB 9: ausländische Tiere nicht anrechnen | Rinder-GVE-Summe überhöht; ein Komponentencheck |
| Ackerfutter | Tatsächlich ordnungsgemäß angelegt/gepflegt und vollflächig beweidet | ATB 5–6: eigene Mahd-/Weidealternative, keine 85%-Erntepflicht | Aktueller Schlagfilter schließt wegen `harvest_share=0` aus |
| Qualifizierte Nationalparkfläche | Bekannte förderfähige Fläche ohne relevante Nationalparkauflagen, keine spezielle Ausschlusskulisse | ATB 7/SRL 11: ausdrücklich zulässige Ausnahme | Pauschales Nationalparkflag schließt aus |

Alle Gegenfälle enthalten feststehende Quelltatsachen. Ein nicht ausdrückbares Parkdetail, eine vorgelagerte Anerkennung oder eine fehlende Eingabe wird nicht als erwiesene rechtswidrige Bewirtschaftung bezeichnet. Bei den geografischen GVE-Fällen ist die vorhandene negative Hauptdiagnose ausdrücklich von der weiterhin falschen numerischen Anrechnung getrennt.

## Funktionsfähige Komponenten und Grenzen

Rechtsformen und die 25%-Grenze, explizit falsche persönliche Voraussetzungen, geschlossene Erst-/Optionseinstiegsjahre, rechtzeitige und verspätete Mengenanträge, wirksame aktuelle Abmeldung und Hauptzugangsverletzungen werden tatsächlich verarbeitet. Die Quellenfaktoren der Flächenmodulation bestehen mit intern konsistenten reinen Heimflächen. Dürregebiet, Jahr, Ursache und betroffene Kulturzeit werden wirklich miteinander verknüpft. Die gleichlautende, tatsächlich fortbestehende Schweineoption der Maßnahme 16 blockiert die Schweinekomponente.

Die 50-Euro-Schwelle bleibt korrekt eine Kann-Warnung. Ein positiver nominaler Betrag unterhalb dieser Schwelle ist für sich kein Fehler. Übererklärungsrechnung, Sanktionsaddition, Kürzungsreihenfolge, Flächenobergrenze, Revisionsende und Zahlungsempfänger existieren als Helfer, Listen oder Diagnose; daraus wird keine vollständige ausgeführte Nettoabrechnung behauptet. **Root besitzt `OUTPUT_SCOPE`** für die übergreifende Darstellung positiver Komponenten trotz negativer Zulässigkeit. Ein beliebiger Bewirtschaftungsfehler bekommt hier keinen erfundenen 100%-Abschlag.

Eine rechtzeitige FM-Meldung ist noch keine Anerkennung. Ebenso ist `force_majeure.occurred` kein selbständiger Nachweis einer rechtlich anerkannten Ausnahme. Kontrolle, Bescheidwirkung und passende Ursachen bleiben getrennt.

Die vollständige NAPV-Beigabe bedeutet keine vollständige Baseline-Modellierung. Insbesondere Einarbeitung/Hanglagen, Gewässerabstände, Lagerkapazitäten, tatsächliche Stickstoffbilanz und detaillierte Gebietspflichten besitzen nicht alle benötigten Eingaben und Verbraucher. Der ÖPUL-Hinweis auf vier Jahre Aufbewahrung verkürzt nicht die zusätzlichen sieben Jahre für einschlägige NAPV-Unterlagen.

## Erhaltene Quellen- und Vertragsgrenzen

Das Merkblatt nennt für 2028 den 17. April. Dieser Tag ist Ostermontag; die tatsächlich beigefügte aktuelle GSP-§5-Fassung verlängert die gewöhnliche Aprilfrist auf den 18. April. Die Ausnahmen für 31. Dezember und 30. November gelten weiterhin. Der Fall kontrolliert den nativen Merkblatt-Literalwert, hält aber den Gegensatz zur GSP-Fassung offen. Die neue §5-Fassung wird nach §242(7) nicht ohne Beleg auf 2024/2025 zurückdatiert.

Letzter Neueinstieg der Maßnahme 2027 und bedingter Optionseinstieg 2028 belegen kein generelles Ende aller bestehenden Jahresverträge 2028. Ein früher Entwurf mit `2029 → false` wurde vor Einfrieren entfernt. Die unbeschränkte native Zeitachse bleibt eine offene Bereichs-/Versionsfrage und zählt nicht als harter Gegenfall.

GSP §48 betrifft bei wiederholten Sanktionen die Förderperiode; die ATB-Formulierung „im Vertragszeitraum“ und der aktuelle Einjahresvertrag werden nicht stillschweigend gleichgesetzt. Die Begrenzung der Rückforderung auf im Ausschlussjahr beantragte Flächen bleibt erhalten. Aktueller §51 betrifft Junglandwirte und liefert keine erfundene Sanktionsnorm für Maßnahme 9.

14 überlappende Befundgruppen und 9 überlappende zusätzliche Pflichtgruppen sind mit Belegen dokumentiert. Ein begrenzter Check vorhandener Enum-Werte prüft nur diese Werte; er ist kein vollständiges Schemazertifikat. Quelle, Profilkonvention, direkte Helfer und Hauptentscheidung bleiben sichtbar getrennt.

## Vor dem Einfrieren korrigierte Prüfartefakte

Zwei Eltern-Queries referenzierten zunächst interne Namen statt vollständiger nativer Datenpfade; die vier betroffenen Mengenprüfungen wurden vor Übernahme korrigiert und erneut ausgeführt. Die Kürzungsreihenfolge wurde im ersten Entwurf als englische Bedeutungsliste formuliert; für die deklarierte deutsche Schnittstelle wurden die korrekten quellengebundenen Bezeichnungen verwendet und erneut geprüft. Kein solcher Konstruktionsfehler wurde als Modellfehler gezählt. Modulations- und Mindestgrößenprofile wurden vor dem letzten Lauf intern flächenkonsistent gemacht.

Der unabhängige Teilbericht folgt zur prüfbaren Herkunft der 18 Teil-IDs. Seine 54 Fälle sind bereits in den obigen 135 enthalten und werden nicht nochmals addiert.

---

# o6_9 — bounded legal/general source audit

Run `v2-o6_9-opus-5.5-high-20261003`, frozen candidate `e009eed4a83ff076b26eba33ac433ac2b0642621`. Only18assigned GEN IDs; no policy edits.

Fresh native controls: 54 cases/checks, 54 defined, 48 met and 6 unmet, no errors/undefined. The observations do not replace source expectations.

Full new source reading: MB1–9 and NAPV1–42, all eight current modules and21 assumptions. Identical-byte shared prior full source audit readings reused; selected current complete pages reread and exact source quotes checked.

Known failures are foreign-animal GVE numerical consumers, the arable-forage grazing alternative, qualified nationalpark eligibility and auto-renewal after known lapse. Correct gates, code filters, one-year metadata, real violations, combinations, ordinary takeover deadlines, all stage percentages and payment ceiling/date controls are explicitly credited.

The sanction map is an authority component. There is no invented automatic100percent sanction. GSP§48(2)Z6 uses Förderperiode for twice100percent and limits recovered area; the ATB current wording says Vertragszeitraum. Scope/version is retained. Payment schedule is an informational conditional ceiling. Root owns the cross-cutting monetary OUTPUT_SCOPE finding.

## Historical ID assessments

- `O69-GEN-003` — implemented_with_input_contract_limits: The 1.50 ha OR 0.50 ha protected-area first-year threshold and later-year waiver are real main admission gates. Totals must already mean the actual source-qualified Austrian aggregate, including source-listed additions; missing first participation year defaults to zero and thereby waives the check.
- `O69-GEN-004` — implemented_with_input_contract_limits: A known later ÖPUL participation year waives the general size threshold correctly. Equality alone cannot distinguish a future or unknown first participation year; do not infer verified prior participation from a default.
- `O69-GEN-005` — partial_geographic_consumer_gap: Global foreign-area false and individual foreign-animal flags create real main violations. Parcel pig premium respects individual location, but cattle and pig GVE fallback sums do not filter kept_in_austria. The fertilizable-area and whole-farm arithmetic require a source-qualified Austrian contract; a diagnostic is not itself removal from those numerical consumers.
- `O69-GEN-006` — partial_overbroad_and_missing_duties: The cereal 85-percent threshold, recognized force majeure and qualified2026 drought exception are real parcel filters. Ackerfutter is not excepted: fully grazed arable forage with harvest_share0 is incorrectly excluded. Proper sowing, annual care and the grassland/arable-forage mowing-or-grazing alternatives are not represented by the harvest-share scalar.
- `O69-GEN-007` — partial_overbroad_and_missing_duties: Known noneligible, nationalpark and outside-Austria flags really filter the pig area. The blanket park flag drops explicit park/source exceptions. April1 availability, correct MFA identification/reference, agricultural predominance and full noneligible categories are not independently represented; generic upstream flags are not source proofs.
- `O69-GEN-008` — implemented_component: Actual op_coded checks OP, OP9 and VF; other-measure OPBIO does not erase measure9 eligibility. This real scalar parcel filter is consumed by the54EUR pig area, while quantity components have a different source unit.
- `O69-GEN-009` — implemented_with_input_contract_limits: Known false whole-year fulfillment produces a real main violation. Missing is treated true and the scalar does not allocate per-unit loss; main admissibility and nominal monetary components remain distinct, with monetary output-scope finding owned by Root.
- `O69-GEN-010` — implemented_component: Measure9 is in the one-year data list, and the actual contract metadata has January1–December31 of the assessed year. This does not by itself establish a valid prior/current application or program-year membership.
- `O69-GEN-013` — partial_temporal_consumer_gap: Actual auto_renewal is defaulttrue, false only for current-year deregistration; known current lapse nevertheless displays automatic renewaltrue. Source continuation also requires the annual application with relevant units and is bounded by program duration.
- `O69-GEN-014` — partial_event_history_gap: Actual control-announcement comparison rejects exit from announcementday onward and creates the correct main violation. Separate control performance and communicated administrative-result events are not represented. The date flag still treats a known ineffective blocked request as operative deregistration; no blanket authority approval is inferred from an unknown event.
- `O69-GEN-015` — helper_only_history_gap: The reentry helper genuinely covers lapse, current-year deregistration, exclusion and previous-year omitted MFA. It is not consumed to compare an actual new measure-application event after the triggering loss; the old application deadline alone cannot establish a valid reentry.
- `O69-GEN-016` — normative_output_only: The main obligations collection really exposes duties until exit, correctly as a general obligation. It is not a separate calendar/event/field compliance engine and does not prove full duty fulfillment.
- `O69-GEN-017` — implemented_component_with_procedure_gap: The21-column Annex L row and pot/substrate footnote are real same-parcel conflict consumers when code9 is present. The measure9–16 pig-category conflict is separately checked. Correction before payment notice without inspection objection is a source procedure without event-history representation; a currently conflicting draft remains a current conflict, not a completed correction.
- `O69-GEN-018` — partial_open_scope_and_approval_gap: The three source grounds, same-previous-farm flag and deadline are real takeover components. A19 openly requires animal/area identity even for all measure9 categories although the source limits this to animal-related measures. AMA single-case approval, previously nonparticipating recipient, residual term and request/area-expansion history are not modeled; modeled allowed is not an authority approval.
- `O69-GEN-019` — implemented_text_component_with_version_boundary: The ordinary15April and explicit2023/2028 17April ATB cutoff strings are faithfully stored. Current supplied GSP§5 weekend/holiday extension can create a2028Tuesday18April boundary conflict with the explicit ATB date; parent general audit owns that conflict. No2024/2025 retroactive use of amended2026§5 is made here.
- `O69-GEN-020` — helper_only_incomplete_sanction_history: All seven source stages and the2027 one-percent replacement are correct callable helpers. No stage is assigned or applied automatically; repetition, same-duty identity, control type and twice100percent within the Förderperiode are not represented. ATB says Vertragszeitraum, supplied GSP§48(2)Z6 instead Förderperiode and recovery only for exclusion-year areas: retain version/scope distinction and authority assessment.
- `O69-GEN-021` — implemented_diagnostic_with_determination_gap: Claimed-versus-recorded application volumes by technique and separated sum comparisons really produce violations. Lack of records is handled separately by actual documentation rules. A records mismatch alone does not supply the officially determined premium or final reduction; overdeclaration helper and root monetary output scope remain separate.
- `O69-GEN-022` — implemented_informational_schedule: Actual schedule exposes December1 informational lower-bound date, June30 nextyear and75percent maximum of nominal component. Sources say payments afterDecember1 and optional advance only after administrative checks and budget availability; no actual advance release or net final-payment decision is implemented.

## Unmet source controls

- `O69-LEGAL-pig-foreign-gve`: expected `2.8`, actual `5.6` (defined).
- `O69-LEGAL-pig-foreign-access`: expected `false`, actual `true` (defined).
- `O69-LEGAL-cattle-foreign-gve`: expected `1`, actual `2` (defined).
- `O69-LEGAL-arable-forage-grazing`: expected `true`, actual `false` (defined).
- `O69-LEGAL-nationalpark-allowed`: expected `true`, actual `false` (defined).
- `O69-LEGAL-renew-lapsed`: expected `false`, actual `true` (defined).

The complete bounded evidence, exact page/quote/hash bindings, native consumer locations and fresh input/query expectations are in the JSON. These are public targeted development controls and provide no held-out accuracy or expert approval claim.


Finales gemeinsames General-JSON SHA256: `75f3f58c883babcacda6d5a57cd6d3b077826239db21be1abaa34a5647475f0c`.


## Ergänzung der direkten Belegbindung

Nach der Root-Gegenprüfung wurden den unveränderten Fällen `O69-LEGAL-arable-forage-grazing` und `O69-LEGAL-nationalpark-allowed` die entscheidenden wörtlichen Belege unmittelbar beigefügt: ATB 5 die Ackerfutterausnahme, ATB 6 der eigene Maßstab samt vollflächiger Beweidung als Alternative sowie ATB 7 die qualifizierte Nationalparkausnahme und die Aussage zu den anderen Nationalparks. Dieselben Belege wurden an die zugehörigen Regelbewertungen und Befunde gehängt. Die zuvor verwendeten allgemeinen Verweisstellen allein trugen diese beiden entscheidenden Ausnahmen nicht vollständig.

Dies ändert ausschließlich Quellenfelder und den Belegledger. Alle 135 Eingaben, Queries, Sollurteile und gespeicherten Beobachtungen sind mit dem vorherigen eingefrorenen Teil exakt gleich; die Hashnachweise stehen in `source_binding_revision`. Es gibt keinen neuen Normfall und keine Laufzeitänderung. Alle 109 Belegdatensätze wurden direkt im Original erneut geprüft, ausschließlich mit Leerraum-/Soft-Hyphen-Normalisierung.
