# o6_4: vollständige Tabellen- und Verbraucherprüfung

Gebunden an den rohen Run `v2-o6_4-opus-5.5-high-20261009`, Kandidatencommit `e009eed4a83ff076b26eba33ac433ac2b0642621`. Das neue Originalmerkblatt Oktober 2025 wurde vollständig gelesen: **vier von vier Seiten** einschließlich Ausnahmen, Beispielen und Tarifen. Sämtliche sechs Produktionsmodule wurden vollständig gelesen. Die neun Originalquellen wurden gehasht; acht identische frühere Volllektüren einschließlich der 94-seitigen GSP-AV werden ausdrücklich per Hash wiederverwendet. Relevante Klauseln wurden neu verglichen.

Der einzelne Artefakteintrag enthält tatsächlich genau **eine JSON-Datei, 31 Inventarcontainer und 216 direkte Zeilen/Objektschlüssel**. Alle verschachtelten Arrays, Labels, Bedingungen, Fußnoten und Gegenmaßnahmen wurden gelesen; kein zusätzlicher Rootcontainer liegt außerhalb des Inventars. 418 wörtliche Quellbindungen und 47 unterschiedliche Codezeilen wurden verifiziert, ohne Fehlzitat. Dazu gehören die indirekten Verbraucher der drei Abgangstoleranzen über `ac := cfg.area_change`. Keine Studien-, Experten- oder manuellen Adaptations-Sollwerte verwendet.

Alle sieben eigenen BM-Tarifzeilen sind korrekt: BM0=0; 2023 BM1/2/3=350/550/900 EUR/ha, ab 2024=378/594/972 EUR/ha. Vier Mähcodes und fünf Methodenabbildungen sind vollständig. Die Zahlen in der Rangtabelle sind technische Ableitungen; die Quelle belegt das Hauptverfahren am Beispiel Motormäher mit ergänzendem Ausmähen durch Sense. Eine allgemeine normative Rangfolge aller Arbeitskombinationen wird nicht behauptet.

## Befunde

- **O64-TABLE-001 · TABLE_CONSUMPTION · hoch**: Die gespeicherte Grenze von 80 Bäumen pro Feldstück-ha wird beim aktiven fremden LSE-Betrag nicht gelesen. Bei ausdrücklich einem vollständigen 1-ha-Feldstück und 100 sonst berechtigten Streuobstbäumen wären höchstens 80×13=1040 EUR zu berücksichtigen; der Helper berechnet 1300 EUR. Zwei bedingte Quellproben isolieren diese Grenze. Keine unbelegte Aufteilung des kombinierten Obergrenzenüberhangs auf die eigene 4-Prämie/LSE gewählt.
- **O64-TABLE-002 · SOURCE_VERSION · mittel**: Die LSE-Sätze 13/8,6 EUR gelten laut SRL-Tabellen ab 01.01.2024. Daten und Verbraucher enthalten dafür keine Jahresgrenze und verwenden sie auch 2023. Der korrekte damalige LSE-Satz ist im gelieferten Paket nicht ausdrücklich vorhanden; dafür wird kein Zahlenorakel erfunden. Eigene BM-Jahressätze sind korrekt versioniert.
- **O64-TABLE-003 · EXTERNAL_DEPENDENCY · niedrig**: Das HM-Beispiel zum vorzeitigen Herdenabtrieb lässt die Bedingung „auf derselben Alm oder Weide“ aus GSP §6 Abs.1 Z4 weg. Die Liste bleibt offen und unreferenziert; daraus folgt kein unbekannter-Fallcode-Verbot. Frist/Anerkennung prüft der Allgemeinagent.
- **O64-TABLE-004 · TABLE_CONSUMPTION · mittel**: Inhaltskürzung, Modulation, Flächenobergrenze und Zugang werden tatsächlich ausgeführt. Die vollständige gesetzliche Kürzungskette ist trotzdem nicht implementiert: der Übererklärungshelper ist eine unverbundene Hektardiagnose; §46 Abs.2 verlangt bei Art.70 den Prämienbezug. Weitere fehlende Kürzungsschritte bleiben getrennt von richtigen Konstanten.
- **O64-TABLE-005 · FOREIGN_SCOPE · niedrig**: Antragstellertypen sowie nicht förderfähige Verwendungen/Auflagen setzen teilweise vorgelagerte positive Klassifikation voraus. Stabile Nationalparkkeys stehen jetzt getrennt von Anzeigevarianten; der frühere reine Parknamenvergleich wird nicht pauschal übertragen. Die zehn Bergmahd-Ausschlüsse anderer Maßnahmen sind Dokumentation, keine Ausführung ihrer Entscheidungen.

## Positive Umsetzungen und Abgrenzung

Die eigene 4-Flächenprämie ist von fremder LSE-Abgeltung und von Sanktionsdiagnosen zu unterscheiden. Jede andere Flächenprämie wird anhand der vollständigen Kombinationszeile 4 gesperrt, auch 1A/1B-Flächenprämien. Die Ausnahme betrifft ausschließlich getrennte punktförmige LSE. Alle **20 Partner** stimmen: zwei `x1)` bei 1A/1B und 18 Leerzellen; keine fehlenden oder doppelten Partner.

Die Tabellenwerte der Inhaltskürzung und Obergrenze werden in diesem Run tatsächlich im Zahlungsfluss verwendet. Der Quellen-/Regelagent prüft separat, dass der fremde LSE-Betrag vor dem Obergrenzenvergleich richtig moduliert werden muss; hier wird dessen 80-Bäume-Grenze isoliert. Die Daten stellen noch keine vollständige UBB-/BIO-Berechtigungsprüfung dar.

Ausdrücklich keine eigene Mindestteilnahmefläche wird korrekt durch `null` dargestellt, nicht durch eine unbekannte benötigte Zahl. Ebenso korrekt: keine Kombinationspflicht, keine notwendige Teilnahme aller Bergmahdflächen, allgemeine Betriebsmindestgröße nur im ersten ÖPUL-Jahr. Die 50-EUR-Regel bleibt eine Kann-Bestimmung und setzt die Zahlung nicht automatisch auf null.

## Vollständiges Inventar

Jede Originalzeile und jeder verschachtelte Wert stehen unverändert im JSON-Ledger mit Quellseite, wörtlichem Beleg und nachgewiesenem Verbraucher. Direkte Referenz beweist noch keine vollständige Ausführung aller Bedingungen. Unreferenzierte Container können dokumentarisch sein; tatsächliche Folgen sind oben gesondert benannt.

| Container | Direkte Einträge | Verbraucher |
|---|---:|---|
| `/oepul_data/o6_4/measure` | 12 | direkt referenziert |
| `/oepul_data/o6_4/contract_periods` | 3 | direkt referenziert |
| `/oepul_data/o6_4/eligibility_thresholds` | 3 | direkt referenziert |
| `/oepul_data/o6_4/mowing_rules` | 4 | direkt referenziert |
| `/oepul_data/o6_4/mowing_codes` | 4 | nicht referenziert |
| `/oepul_data/o6_4/mowing_method_to_code` | 5 | direkt referenziert |
| `/oepul_data/o6_4/mowing_method_rank` | 5 | direkt referenziert |
| `/oepul_data/o6_4/premium_rates` | 7 | direkt referenziert |
| `/oepul_data/o6_4/fertilizer_types` | 11 | direkt referenziert |
| `/oepul_data/o6_4/annex_l_combination_row_4` | 20 | direkt referenziert |
| `/oepul_data/o6_4/landscape_element_rates_combinable` | 4 | direkt referenziert |
| `/oepul_data/o6_4/conversion_targets` | 2 | direkt referenziert |
| `/oepul_data/o6_4/area_change` | 9 | direkt referenziert |
| `/oepul_data/o6_4/area_change_allowed_conversions` | 4 | nicht referenziert |
| `/oepul_data/o6_4/area_increase_restricted_measures` | 9 | nicht referenziert |
| `/oepul_data/o6_4/annually_variable_area_measures` | 5 | nicht referenziert |
| `/oepul_data/o6_4/takeover` | 5 | direkt referenziert |
| `/oepul_data/o6_4/farm_minimum_size` | 3 | direkt referenziert |
| `/oepul_data/o6_4/applicant_types` | 5 | direkt referenziert |
| `/oepul_data/o6_4/public_body_exception_measures` | 5 | nicht referenziert |
| `/oepul_data/o6_4/non_eligible_areas` | 10 | direkt referenziert |
| `/oepul_data/o6_4/national_parks` | 4 | direkt referenziert |
| `/oepul_data/o6_4/op_code_mandatory_cases` | 7 | nicht referenziert |
| `/oepul_data/o6_4/area_payment_caps` | 9 | direkt referenziert |
| `/oepul_data/o6_4/modulation_bands` | 4 | direkt referenziert |
| `/oepul_data/o6_4/sanction_levels` | 8 | direkt referenziert |
| `/oepul_data/o6_4/sanction_rules` | 7 | direkt referenziert |
| `/oepul_data/o6_4/reduction_order` | 11 | nicht referenziert |
| `/oepul_data/o6_4/force_majeure_categories` | 6 | nicht referenziert |
| `/oepul_data/o6_4/deadlines` | 15 | direkt referenziert |
| `/oepul_data/o6_4/cross_measure_bergmaehder_exclusions` | 10 | nicht referenziert |

Die vollständigen geschlossenen Listen umfassen unter anderem elf Düngerklassen, vier fremde LSE-Sätze, neun Zugangsbeschränkungsgruppen, fünf jährlich variable Flächengruppen, fünf Antragstellerklassen, fünf Gebietskörperschaftsausnahmen, zehn Nichtförderfähigkeitsklassen, vier Nationalparkklassen, sieben OP-Anlässe, neun Obergrenzen und acht versionierte Sanktionszeilen. Die sechs HM-Einträge sind ausdrücklich eine offene Beispielsammlung mit EU-Verweis. Alle 15 Frist-/Betragsparameter und zehn Bergmahd-Querverweise wurden einzeln gegen die einschlägigen Originalstellen geprüft.

49 öffentliche Quellproben sind vorbereitet: sieben eigene Tarifzeilen, zwei zusätzliche Methodenaliasfälle, elf Düngerklassen plus nicht bedarfsgerechter Festmist, alle 20 fremden Flächenprämienpaare, vier fremde LSE-Satzfälle, zwei bedingte 80-Bäume-Feldstückfälle und zwei Fälle an der 50%-Grenze. Eingabevokabeln stammen aus dem nativen Kandidaten; Sollwerte aus den Originalquellen. Stringarrays werden mit strukturellem `equals` geprüft. `contains_rule`/`excludes_rule` werden ausschließlich bei Regelobjektarrays mit `rule_id` verwendet. Keine eigene OPA-Ausführung behauptet; numerisches Verhalten der angehefteten Laufzeit bleibt getrennt von Quellenzahlen.

Keine historischen oder produktiven Dateien, Quellen oder Profile verändert. Keine Commits, Modelle, privaten Studienfälle oder fachliche Freigabe.

JSON-Freeze SHA256: `484cd48f17673b69309771d075a4f0e968bbf55b23f87dc25089e724aa760f9e`.

Unveränderte Datenquelle SHA256: `f9cfbdc0a8bf38056dee6cea1bd10cb2870598b2f416fb9434216607c9c3a333`.
