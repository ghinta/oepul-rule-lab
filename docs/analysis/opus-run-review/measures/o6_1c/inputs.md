# o6_1c – Eingabevertrag und tatsächliche App-Projektion

Geprüft wird ausschließlich `v2-o6_1c-opus-5.5-high-20261009` am unveränderten Kandidatencommit `e009eed4a83ff076b26eba33ac433ac2b0642621`. Dies ist ein Auditteil der gemeinsamen Sammlung [Issue #112](https://github.com/ghinta/oepul-rule-lab/issues/112) / [PR #111](https://github.com/ghinta/oepul-rule-lab/pull/111). Er sammelt Quellenbefunde, Eingabeverträge und öffentliche Diagnoseproben; er ändert keine Policy und erteilt keine Förderfreigabe.

Das originale Informationsblatt Oktober 2025 wurde vollständig gelesen: **5 Seiten**, einschließlich Negativliste, Ausnahmen, Antragsfristen, Prämienbändern und Impressum. Alle **neun produktiven Rego-Module** wurden hinsichtlich Eingaben und ihrer Ergebniswirkung durchgesehen. Sieben Quellhashes stimmen mit den vorherigen UBB-/BIO-Prüfungen überein; relevante Stellen wurden hier gezielt nachgelesen. Die zusätzlich gebundene GSP-AV wird im allgemeinen Quellen-Audit vollständig geprüft. Dieser Teil behauptet keine vollständige zusätzliche Lektüre jener gesamten Verordnung.

## Vollständiger Eingabeledger

[inputs.json](inputs.json) enthält alle **16 Vorschläge mit 88 neuen Blattpfaden**: Typen, Einheiten, bedingte Erforderlichkeit, Bedeutung, Zeit- und Identitätsbezug, exakte Lesestellen und Hinweise zu fehlenden/null-Werten. **86** vorgeschlagene Blätter werden im Code gelesen. Ungelesen bleiben `force_majeure_claims[].case_id` und `force_majeure_claims[].event_date`.

Der historische Scanner meldet lediglich `input.farm.year`. Die manuelle Prüfung samt aufgelösten `object.get`-Empfängern und der dynamischen Schleife `care[k]` weist **139 deklarierte Lesestellen** nach. Zusätzlich zu den vorgeschlagenen Pfaden werden **acht bereits vorhandene Canonical-Blattpfade** genutzt. Kein nicht verwalteter Blattpfad bleibt übrig. Alle **74** verschiedenen Proposal-Belege sind auf der angegebenen Originalseite bei reiner Leerraumnormalisierung auffindbar. Ein Wortlauttreffer ersetzt keine fachliche Beurteilung.

Acht gelesene vorgeschlagene Blätter wirken ausschließlich in nicht ausgegebenen Helfern: die beiden Feldstückattribute für UBB-/BIO-Anrechnung, die beiden tatsächlich gelesenen Datumsfelder eines Höhere-Gewalt-Antrags, das Sträucherflag, die zugeordnete Agroforst-Feldstück-ID und die beiden Kontrollverweigerungsflags. Die beiden zusätzlich vorgeschlagenen, ungelesenen Höhere-Gewalt-Felder werden davon getrennt gezählt.

| Vorhandener Canonical-Pfad | Tatsächliche native Verwendung |
|---|---|
| `farm.year` | Auswertungsjahr; direkt erforderlich. |
| `land.total_area_ha` | Mindestgröße und Prämienmodulation; fehlend 0. |
| `land.arable_area_ha` | Bezugsfläche der 4%-NPA-Kappung; fehlend 0. |
| `land.parcels[].parcel_id` | Join für Verstöße und Ausschlüsse; fehlend wird zu `unknown`, keine Eindeutigkeitsprüfung. |
| `land.parcels[].area_ha` | Schlagfläche, Mindestgröße, GLÖZ4-Abzug und Prämie; fehlend 0. |
| `land.parcels[].operations.psm_used` | Nur für NPA: bekannter Einsatz verlangt positive Bio-Wirkstoffzulässigkeit. AFS liest stattdessen seinen eigenen Maßnahmenpfad. |
| `land.parcels[].operations.fertilizer.mineral_n_kg_per_ha` und `organic_n_kg_per_ha` | Beide Mengen gelten im historischen NPA-Vertrag als Angaben für die Verbotsperiode; jährliche App-Werte sind nicht automatisch gleichbedeutend. |

## Nachgewiesenes Verhalten

Es sind **44 Eingabeproben** mit vollständigem Input, Query, Erwartungen, Quellen und unveränderten Laufzeitbeobachtungen dokumentiert. Quellenkomponenten, gewünschte positive Nachweise und Stress mit Daten außerhalb des vorgeschlagenen Schemas sind ausdrücklich getrennt. Überschneidungen mit anderen Audit-Teilen werden nicht als unabhängige Referenzfälle oder Genauigkeitsmessung gezählt.

| Bereich | Beobachtung am unveränderten Run | Einordnung |
|---|---|---|
| Antrag und Zugang | Fehlender erster Vertragsbeginn, fehlendes/null Antragsdatum oder Feldlistendatum und unbekannter Aktivitätsstatus können `contract_valid=true` ergeben. | Die gewünschte Positivnachweisregel wird nicht durchgehend erfüllt. Eine unbekannte Angabe beweist dabei keinen tatsächlichen Fristverstoß. |
| Agroforstdefinition | Fehlende Breite, Länge oder Baumzahl können die jeweilige Prüfung überspringen. Länge null erzeugt ebenfalls keine Dichte. Der Definitionshelfer kann dann positiv bleiben. | Unbekannte Geometrie darf nicht als positiver Nachweis für 2–10 m Breite und 10–25 Bäume je 100 m gelten. |
| Pflege | Fehlendes Pflegeobjekt oder null bei Pflanzpfahl erzeugt keinen Pflegeverstoß. Fehlende/null Vorjahresschnittangabe verhindert bei abgeschlossenem Jahr die Mindestpflegebeanstandung. | Positiver Nachweis fehlt. Die bereits dokumentierte Frage zur Erforderlichkeit von Pflanzpfählen bei alten Bäumen bleibt offen. |
| Ansaat | Bei bekannter Neuansaat erzeugen fehlendes/null NPA-Ansaatdatum keinen Fristverstoß. 15. Mai und 16. Mai werden bei vorhandenen Daten korrekt unterschieden. | Der Datumsvergleich allein prüft keine Vollständigkeit des Nachweises. |
| Bekannter PSM-Einsatz | NPA verlangt bei `operations.psm_used=true` eine positive Bio-Wirkstoffangabe; fehlend/null/false führt zum Verstoß. AFS erkennt den Einsatz im eigenen Pfad, ignoriert aber denselben Einsatz im alleinigen Canonical-Pfad. | Die zwei Pfade und ihre Perioden müssen ausdrücklich abgebildet werden. Dieses Audit genehmigt keinen Alias. |
| Bekannter Umbruch | Vorhandenes Umbruchdatum plus fehlendem oder `none`-Beseitigungsverfahren erzeugt keinen mechanischen Nachweis. | Mit dem Tabellen-Audit abgestimmte Nachweis-/Konsistenzlücke; es wird kein tatsächlicher chemischer Einsatz behauptet. |
| Identität | Bei unterschiedlichen IDs sperrt eine ausländische Parzelle die inländische nicht. Bei kollidierenden IDs werden beide über die gemeinsame Ausschluss-ID entfernt. | Der Stresstest dokumentiert diese konservative Wirkung. Er verlangt keine erfundenen Ersatz-IDs; der Adapter muss die Identität vorab prüfen. |
| Teilflächen | Ein negativer GLÖZ4-Anteil kann die vermeintlich förderfähige Schlagfläche von 0,4 auf 0,5 ha vergrößern, wenn die Betriebskappung dies zulässt. | Ungültige Geometrie muss vor der nativen Berechnung abgefangen werden. |

Die fünf beobachteten Arithmetikfehler dieses Probe-Satzes betreffen **außerhalb des vorgeschlagenen Schemas liegende** Eingaben: null/Boolean/String als verpflichtendes Vertragsjahr, null als Baumzahl und null als numerische GLÖZ4-Fläche. Sie werden nicht als Fehler fachlich gültiger Eingaben ausgegeben. Die erlaubten nullable Datumsfelder haben andere Wirkungen: Sie können Prüfungen ohne Fehler überspringen. Originale Fehlerausgaben und die gepinnte OPA-Version bleiben unverändert; ein separat in anderen Audit-Teilen beobachtetes numerisches Laufzeitproblem wird damit weder repariert noch widerlegt.

## App-Vertrag

Der aktuelle App-Adapter wurde erneut mit einem öffentlichen synthetischen 1c-Payload ausgeführt. Jeder Datenbankzugriff war dabei durch eine sofort fehlschlagende `CursorWrapper.execute`-Sperre verboten; kein solcher Zugriff erfolgte. Vorher-/Nachher-Payload und SHA-256-Werte der App-Quelldateien stehen unter `app_projection` im JSON.

**Keiner der 16 nativen Vorschlagspfade bleibt in der tatsächlichen OPA-Projektion erhalten.** `farm.applicant`, `farm.oepul`, Feldstückinventar, `field_use_type`, Code-Listen und beide `o6_1c`-Detailobjekte fehlen danach. Die vorhandenen flachen Biodiversitäts-/Agroforst-Proxys sind kein dokumentierter Ersatz für die nativen Kategorien oder Verpflichtungen.

Bereits vorhandene PSM-/N-Pfade werden teilweise erhalten. Auch hier wäre eine bloße Pfadgleichheit irreführend: Der historische Run interpretiert NPA-Angaben laut eigenen Annahmen als Fakten innerhalb des Verbotszeitraums. Die App liefert ohne zusätzliche Datierung nicht automatisch genau diesen Zeitraum. Für AFS verwendet die Policy außerdem eigene Flags und liest die allgemeinen Mengen nicht mit.

Genauso wenig dürfen die rechtliche Spezialkulturklassifikation nach §25 Abs.4 GSP-AV, eine positive Referenzflächenlage oder eine stabile Feldstückzuordnung aus ähnlichen Feldnamen abgeleitet werden. Erforderliche externe Quellen-/Sachverhaltsprüfungen bleiben als solche erkennbar.

## Alle 16 Vorschläge

| # | Vorschlag | Gelesene Blätter / gesamt | Kontext |
|---:|---|---:|---|
| 1 | `farm.applicant` | 4 / 4 | Antragsteller-Zugang |
| 2 | `farm.oepul` | 22 / 24 | Teilnahme und Maßnahmenantrag |
| 3 | `land.protected_cultivation_area_ha` | 1 / 1 | Mindestbetriebsgröße im ersten ÖPUL-Jahr |
| 4 | `land.field_pieces` | 2 / 2 | Agroforst-Anrechnung in UBB/BIO |
| 5 | `land.parcels[].field_use_type` | 1 / 1 | Schlagnutzungsart |
| 6 | `land.parcels[].oepul_codes` | 1 / 1 | MFA-Codes am Schlag |
| 7 | `land.parcels[].other_oepul_measures` | 1 / 1 | andere Maßnahmen auf demselben Schlag |
| 8 | `land.parcels[].national_park` | 3 / 3 | Nationalpark-Ausschluss |
| 9 | `land.parcels[].in_austria` | 1 / 1 | Flächenlage |
| 10 | `land.parcels[].transfer` | 2 / 2 | unterjährige Weitergabe |
| 11 | `land.parcels[].public_funding_overlap` | 1 / 1 | Leistungsüberschneidung |
| 12 | `land.parcels[].statutory_requirement_overlap` | 1 / 1 | gesetzlichvorgeschriebene Leistung |
| 13 | `land.parcels[].third_party_fault_noncompliance` | 1 / 1 | Fremdverschulden |
| 14 | `land.parcels[].correctly_identified` | 1 / 1 | Flächenidentifikation |
| 15 | `land.parcels[].non_eligible_area_types` | 1 / 1 | Flächenart-Ausschlüsse |
| 16 | `land.parcels[].o6_1c` | 43 / 43 | NPA/Agroforst-Verpflichtungen |

Canonical Farm Profile, Quellen, historische Runs und App bleiben unverändert. Es wurden keine Modellaufrufe ausgeführt und keine privaten Referenzen oder Modell-Selbsttests als Sollwerte genutzt. Alle Befunde bleiben in der gemeinsamen Sammlung; dieser Teil startet keine Policy-Reparatur oder Promotion.
