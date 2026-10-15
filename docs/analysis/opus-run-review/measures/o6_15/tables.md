# o6_15 – Tabellen, Listen und tatsächliche Verbraucher

Die Tabellenprüfung ist für den gemeinsamen Lauf und die unabhängige QA abgeschlossen. Sie betrifft ausschließlich `v2-o6_15-opus-5.5-high-20260926` am unveränderten Kandidatencommit `e009eed4a83ff076b26eba33ac433ac2b0642621`. Native Regeln, Daten, Originale, Canonical und App wurden nicht geändert.

Das neue Maßnahmenblatt wurde persönlich auf allen **zehn Seiten** vollständig gelesen, einschließlich aller Tabellen, Beispiele, Fußnoten, Aktualisierungen und Impressum. Ebenfalls vollständig gelesen wurden alle **sechs Module mit 1.175 Zeilen**, alle **20 Rohannahmen samt übrigen Notizen** und alle **sieben tatsächlichen Profilvorschlagsbäume**. Die Originalseiten 7/8 wurden zusätzlich als Bild angesehen. Sieben gemeinsame Originale werden mit identischen Hashes und belegter früherer Volllektüre wiederverwendet. Anhang A 3, SRL 18/72/73 und ATB 4/5/12/15/18–20 wurden aktuell ganz zurückgelesen; weitere aktuelle Klauseln und die Alm-Mitteilung vom 22. Mai wurden mit den gespeicherten Feldern verglichen. **GSP-AV und NAPV fehlen diesem Paket.**

## Tatsächliches Inventar

Alle **42 gebundenen Dateien** stimmen im Hash. Die fünf nativen Datendateien enthalten **20 Inventarcontainer, 146 direkte Einträge und 616 Skalarblätter**. Das Inventar deklariert 147 Zeilen. Genau eine Zähldifferenz betrifft `/measure_parameters/deadlines`: zehn direkte Schlüssel, elf skalare Werte durch zwei verschachtelte Ausnahmejahre, elf deklarierte Zeilen. **Kein Termin fehlt.** Direkte Einträge, Skalarblätter und Rechtsnormen sind unterschiedliche Einheiten.

| Datei | Pointer | Tatsächlich / deklariert |
|---|---|---:|
| `annex_a_gve_key.json` | `/annex_a_gve_key/dwarf_cattle_breeds` | 4 / 4 |
| `annex_a_gve_key.json` | `/annex_a_gve_key/footnotes` | 2 / 2 |
| `annex_a_gve_key.json` | `/annex_a_gve_key/rows` | 23 / 23 |
| `measure_parameters.json` | `/measure_parameters/applicant_forms` | 5 / 5 |
| `measure_parameters.json` | `/measure_parameters/dairy_age_requirements` | 3 / 3 |
| `measure_parameters.json` | `/measure_parameters/deadlines` | 10 / 11 |
| `measure_parameters.json` | `/measure_parameters/eligible_species` | 5 / 5 |
| `measure_parameters.json` | `/measure_parameters/herding_categories` | 6 / 6 |
| `measure_parameters.json` | `/measure_parameters/minimum_farm_size_first_year` | 2 / 2 |
| `measure_parameters.json` | `/measure_parameters/one_year_measures` | 13 / 13 |
| `measure_parameters.json` | `/measure_parameters/public_body_exception_measures` | 5 / 5 |
| `measure_parameters.json` | `/measure_parameters/reporting_rules` | 5 / 5 |
| `measure_parameters.json` | `/measure_parameters/takeover_only_on_restructuring/measures_and_supplements` | 10 / 10 |
| `premium_rates.json` | `/premium_rates/federal_state_top_up` | 4 / 4 |
| `premium_rates.json` | `/premium_rates/limits` | 4 / 4 |
| `premium_rates.json` | `/premium_rates/rate_periods` | 3 / 3 |
| `reductions.json` | `/reductions/modulation_bands` | 4 / 4 |
| `reductions.json` | `/reductions/multiple_reduction_order` | 11 / 11 |
| `reductions.json` | `/reductions/sanction_levels` | 9 / 9 |
| `rgve_key.json` | `/rgve_key/rows` | 18 / 18 |

Alle tatsächlichen Werte, Unterfelder, Einheiten, Nullwerte, Bezeichnungen und Qualifikationen sind vollständig im JSON erfasst und mit Originalen sowie aktuellen Verbrauchern gebunden. Zusätzlich liegen **24 Metadatenblätter** außerhalb der Inventarcontainer: zwölf besitzen echte direkte Feldverweise, zwölf nicht. Dazu gehören technische IDs/Beschreibungen, erforderliche Kombination 14, Mindest-RGVE/-Tage, 45 Milchtage, Vertragsparameter, Übernahmevoraussetzungen, 50 € Bagatellgrenze, 75 % Vorschuss, Zahlungstermin 30. Juni des Folgejahres und Altersstichtag 1. Juli. Hardcodierte Äquivalente und tatsächlich gelesene Felder werden getrennt beschrieben.

## Tabellen und Quellenqualifikationen

Der allgemeine **Anhang A enthält 23 Zeilen**: 20 RGVE-Zeilen und drei Schweine-GVE-Zeilen. Beide vollen Fußnoten einschließlich der landwirtschaftlichen Nutzflächenbedingung für gehaltene Wildhuftiere und alle vier Zwergrassen (Dahomey, Dexter, Kerry, Zwergzebu) sind vorhanden. Die abgeleitete eigene Teilnahmequalifikation umfasst 17 positive Zeilen, eine nur für Neuweltkamele geltende Mischzeile und fünf negative Zeilen. Sie ist kein zusätzlicher Originaltabellenwert. Der eigene **Maßnahmenschlüssel enthält 18 RGVE-Zeilen** für Rinder, Schafe, Ziegen, Equiden und Neuweltkamele. Die übrigen allgemeinen Arten sind keine fehlenden eigenen Klassen.

Die RGVE-Werte, Altersgrenzen am 1. Juli, Größenklassen und Rassen wurden vollständig verglichen. Kleine Equiden müssen Höhen- **und** Gewichtsgrenze einhalten; große überschreiten mindestens eine. Die nativen Boolean-Klassen sind vorgelagerte Tatsachenannahmen. Alle 18 bekannten Klassen, 22 Werte an elf Altersgrenzen und vier Rassen wurden frisch gegen die tatsächliche Ableitung geprüft. **Die Nullkategorie funktioniert in diesem Run**; der Fehler aus `o6_14` wurde nicht übertragen. Positive Tierklassen und gruppierte Originalbeispielzahlen behaupten keine realen Tierregistereinträge.

Alle **sechs Behirtungskategorien** und **fünf Meldearten-Tupel** stimmen. Milchschafe/-ziegen gehören zur jeweiligen Schaf-/Ziegenkategorie; Milchkühe sind von sonstigen Rindern getrennt. Die Behirtungspflicht betrifft alle Tiere der beantragten Kategorie. Rinder werden binnen 14 Tagen gemeldet, die übrigen Arten binnen sieben Tagen; Schafe/Ziegen brauchen Ohrmarken, Equiden/Neuweltkamele werden in Stück beantragt. Deren übereinstimmender geplanter Abtrieb benötigt keine Nachmeldung. Für nachgereichte Milchkennzeichen gelten 14/7 Tage; nur Schafe/Ziegen besitzen zusätzlich die feste Grenze 15. Juli. Diese Grenze ist nicht die bis 17. Juli verschobene Zahlungsantragsfrist. Milchvieh benötigt 45 Milchtage; Rinder 24 Monate plus Abkalbung, Schafe/Ziegen zwölf Monate am 1. Juli.

Alle **elf verschiedenen Originalpreise** sind in drei Zeiträumen richtig gespeichert: 2023 Behirtung 75/25 € und Milchvieh 140/100 € je RGVE, ab 2024 Behirtung 81/27 € und Milchvieh 151,2/108 €; Hunde 700 € im Jahr 2023,756 € im Jahr 2024 und 1.200 € ab 2025. Es gelten maximal 50 RGVE je Person, 20 RGVE zum höheren Satz je 50er-Block und **höchstens fünf Hunde je Alm**. Das Originalbild bestätigt die gesamten verbundenen Jahres-/Tarifzellen. Die Milchviehzuordnung bleibt die offen deklarierte sequenzielle Auslegung aus den konkreten Originalbeispielen; ein beliebiger unabhängiger Allokationsnachweis wird daraus nicht gemacht.

Das wörtliche Beispiel mit 95 RGVE, davon 40 Milchvieh, und zwei Hirten ergibt native 4.725 € Basis plus 5.184 € Milchvieh, insgesamt 9.909 €. Das Zweialmbeispiel liefert 48/52 RGVE und 32/15,5 Milchvieh-RGVE; die eigenen Rechenkomponenten werden von der gedruckten Summenabweichung getrennt. Der optionale Hund muss die 60 Tage auf **einer** Alm erreichen und während der gesamten Alpungsdauer anwesend sein. Alle Zertifikats-, Versicherungs-, Herdenteilnahme- und Einmalbeantragungsfakten in den Komponentenproben sind abstrakte positive Voraussetzungen, keine erfundenen realen Nachweise.

Das Landes-Top-up von 40 €/RGVE für den hohen Milchviehsatz, Finanzierung ausschließlich aus Landesmitteln und Meldung bis 15. Mai sind korrekt erfasst. Tatsächliche Gewährung, rechtzeitige Mittelbereitstellung und Meldung bleiben externe Voraussetzungen; die positive Komponentenprobe mit 800 € benennt diese Annahmen und erfindet kein Landesprogramm. Die übrigen Sourcebedingungen zu gleichen Modulations-/Kürzungsregeln gelten weiter.

Die geschlossenen Listen umfassen **13 einjährige Maßnahmen**, **fünf Gebietskörperschaftsausnahmen** mit 2024-Ende für Maßnahme 10 und 2025-Beginn für 1C sowie **zehn Übernahmegruppen** samt ausdrücklich einbezogener Zuschläge. Alle Namen und Qualifikationen wurden vollständig verglichen. Technische ID-Aliase sind keine zusätzlichen Originalmitglieder. Für Übernahmen gelten genau Auflösung, Teilung oder Zusammenführung und Tiere/Flächen desselben Vorbetriebs. Die eigene einjährige Maßnahme verlängert sich automatisch; letzter Neueinstieg 2027, letzter Hundezuschlag 2028. Allgemeine Erstteilnahmeflächen 0,5 ha geschützter Anbau oder 1,5 ha Landwirtschaft sind von jährlich erforderlichen 3 RGVE verschieden.

Die fünf Datenfiles enthalten **keine Anhang-E- oder Anhang-L-Tabelle**. Maßnahme 15 liegt als Tiermaßnahme außerhalb der 21 Anhang-L-Codes; erforderliche Teilnahme an 14 ist gesondert codiert. Es wird keine fremde Matrixabdeckung aus einem früheren Run oder ein fehlender Headerfußnotenbefund kopiert. Der 11er-Mehrfachkürzungskatalog wird als IDfolge exportiert, ohne vollständigen Kürzungsmotor. Die neun Stufenzeilen bestehen aus der geteilten Warnung, sechs Prozentstufen und Ausschluss. Die tatsächliche behördliche Stufe und GSP-Kürzungen werden nicht erfunden. Dürre kann einen Antrag auf höhere Gewalt begründen, hebt aber nicht automatisch die Behirtungsdauer auf.

## Zwei Quellenrechenkonflikte

Das frisch angesehene MB 8 druckt für **20 × 81 € + 30 × 27 € den Betrag 2.295 €**, rechnerisch sind es **2.430 €**. Der gedruckte Folgetotal 12.534,60 € liegt deshalb 135 € unter der Summe 12.669,60 € aus den angegebenen Rechengliedern. Native folgt den Rechengliedern. Die Komponentenprobe bindet Originalzahlen und gedruckte Abweichung ausdrücklich; sie behauptet keine rechtliche Entscheidung über den verbindlichen Beispielbetrag.

ATB 20 enthält in diesem Run tatsächlich das 230-ha/250-RGVE-Beispiel und nennt **98,66 %**. Die angegebenen Bänder ergeben **(200+30×0,9)/230=98,695652…%**. Die native Bandfunktion stimmt mit der Formel. Alle vier Bandzeilen sind wörtlich gebunden; der mathematische Komponentencheck verwendet vier Dezimalstellen in Prozent. Der gedruckte Wert wird nicht stillschweigend normalisiert und ist kein unabhängiger Rundungsoracle. Die Alm-Modulationsbasis und die Zuordnung auf mehrere Almen bleiben von der korrekten Bandfunktion und von Rohannahme 6 getrennt.

## Frische Proben, Konstruktion und Abschluss

Alle **43 Quellenproben** wurden im abschließenden isolierten Lauf vollständig wiederholt: **43 definiert, 43 Erwartungen erfüllt**, keine Runtimefehler oder undefinierten Abfragen. Vollständige Arrays/Tupel und konkrete Zahlen/Booleans werden strikt verglichen. Sortierende Queries besitzen extern deterministisch sortierte Quellenmitgliedschaften. Die zwei mathematischen Quellenkonfliktproben sind ausdrücklich als solche markiert. Historische Selbsttests, Modelloutputs, Studien- und private/expertische Fälle liefern keine Sollwerte.

Vor der ersten Ausführung wurden fünf eigene Queries rein syntaktisch korrigiert: Ein Comprehension-Separator lag außerhalb der Klammern. Umschließung und Auswahl [0] änderten weder Input noch Quellerwartung. Voriger Teilehash und jede Vorher-/Nachher-Query sind im Revisionsledger dokumentiert. Dies ist kein Modellfehler und keine Anpassung an beobachtete Ergebnisse. Danach wurden keine Inputs, Queries oder Erwartungen geändert.

Die Prüfung aller vorhandenen Eingabefelder umfasst **1.547 Skalarwerte, 237 Objekte, 72 Arrays**; 29 explizite Helperargumente sind getrennt typisiert. Alle **142 Enumvorkommen** passen zu den tatsächlich vorhandenen Stringdeskriptoren an vier Pfaden. Numerische Enum-Primitive sind in diesen Vorschlägen kein Thema; eine Ambiguität aus anderen Runs wird nicht übertragen. Es gibt keine Typ-/Enumfehler. Die Prüfung zertifiziert weder Vollständigkeit abwesender Felder noch tatsächliche Registrierung, Genehmigung oder Sachrichtigkeit.

Der isolierte Lauf nutzt OPA 1.18.2 mit SHA `9903e5125ac281104f2c4b7371d10cc3b74a98933743fcbfc174f9bf0ab20de8`, die tatsächlichen gebundenen Policy-/Datenverzeichnisse und einen erfolgreichen strikten Paketcheck. Keine Netzfreigabe; `http.send`, `net.lookup_ip_addr`, `time.now_ns`, `uuid.rfc4122`, `rand.intn`, `opa.runtime` sind gesperrt. Evalgrenze 10 s, Prozessgrenze 20 s. Die 43 Fälle liefen in 4.849 s; langsamster Fall 0.234 s.

Der finale Quellencheck bindet **1.097 Zitatvorkommen, 97 eindeutige Quellen-/Seiten-/Zitatbindungen und 42 Codeanker** ohne Fehler. Nur Whitespace-/Soft-Hyphen-Normalisierung und gegebenenfalls Layoutextraktion derselben Originalseite sind zulässig; keine Satzzeichenumschreibung oder NFKC. Alle 42 Dateihashes, 146 tatsächlichen Zeilenwerte, 616 Skalarblätter und 24 übrigen Metadaten stimmen. Die einzige deklarierte Zähldifferenz ist oben erklärt.

Probeprojektion (`case_id`, `input`, `query`, `expectations`): `5eb353e2d5499b5a99764c766fb7b5228b8a5bf561bdfdf9a527f9cbaca57794`. Diese Projektion bleibt nach dem 43er-Replay unverändert; spätere Ergänzungen betreffen ausschließlich Prüfmetadaten. Tabellen-JSON-Freeze: `344c6d3ea034b1b2d242850bd391ba823fc772a7a1889947189277480aef71c5`. Gemeinsamer Root-Replay und unabhängige QA folgen. Diese öffentliche Quellen-/Verbraucherprüfung ist keine private Genauigkeitsmessung und keine fachliche Freigabe.
