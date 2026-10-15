# Originalquellenprüfung der Tabellen – o6_5

Geprüft wird ausschließlich `v2-o6_5-opus-5.5-high-20260925` am unveränderten Kandidaten `e009eed4a83ff076b26eba33ac433ac2b0642621`. Alle zehn Seiten des Maßnahmenblatts Oktober 2025, die vier JSON-Datendateien und alle sieben Produktionsmodule wurden vollständig gelesen. Sieben gemeinsame Quellen werden durch identische SHA-256 an die vollständig gelesenen Vorgänger gebunden; Anhang D, SRL 2.5, allgemeine Teilnahmebedingungen und der aktuelle Dürrehinweis wurden erneut abgeglichen.

Der abgeschlossene, maschinenlesbare Zeilenledger ist [tables.json](tables.json), SHA-256 `ab0532d772b44fbe6d280d5c7d141f83ab97e3ea700a8159ad6d5181aa9a84c0`. Er enthält sämtliche 13 Inventarcontainer und 131 direkten Zeilen, jeweils mit vollständigem Originalwert, Quellenbeleg und tatsächlichen Codeverbrauchern. Keine eigenen OPA-Läufe: Die 63 neuen Quellenproben sind Vorschläge für die zentrale Ausführung am unveränderten Kandidaten.

| Datei / Pointer | Zeilen | Tatsächliche Verwendung |
|---|---:|---|
| `breeds.json/breeds` | 27 | Name/Art/Stufe/GEP gelesen; Organisation nur gespeichert |
| `breeds.json/gep_program_requirements` | 6 | Nicht referenziert; externe tatsächliche Umsetzung fehlt |
| `premium_rates.json/premium_rates` | 20 | Alle Kategorie-/Jahres-/Stufen- und Zuschlagswerte gelesen |
| `animal_categories.json/animal_categories` | 10 | Art/Geschlecht/Referenzdatum/Alter/Jahrespflicht gelesen; Label/Erstgeburttext nur dokumentiert |
| `general.json/parameters` | 25 | 23 Parameter direkt oder indirekt gelesen; Pferde-Referenzfeld ungenutzt, allgemeiner Stichtag an ungenutzten Helper gebunden |
| `general.json/year_specific_overrides` | 1 | Alle drei operativen Werte aktiv und getrennt gelesen |
| `general.json/applicant_legal_forms` | 4 | Vollständige Positivliste gelesen; Share-Flag nicht gelesen |
| `general.json/public_body_exempt_measures` | 5 | Zeitabhängiger Helper; eigene5 ist keine Ausnahme |
| `general.json/restricted_takeover_reasons` | 3 | Whitelist und gleicher Vorbetrieb aktiv |
| `general.json/modulation_brackets` | 4 | Alle vier Bänder gewichtet im Zahlungsfluss |
| `general.json/sanction_stages` | 8 | Stufe und Jahreswechsel aktiv im Zahlungsfluss |
| `general.json/multiple_reduction_order` | 11 | Nicht referenziert; nur Teilablauf tatsächlich implementiert |
| `general.json/absence_types` | 7 | Nicht referenziert; entsprechende Einzelregeln/Parameter separat aktiv |

Alle 27 Rassenzeilen stimmen feldweise mit Anhang D, PDF-Seite 9 überein: 9 Rinder-, 1 Pferde-, 8 Schaf-, 7 Ziegen- und 2 Schweinerassen. 23 Rassen tragen GEP, vier nicht: Braunes Bergschaf, Tiroler Steinschaf, Blobe Ziege und Gemsfarbige Gebirgsziege. Keine fehlende oder doppelte Rasse. Alle Organisationen, A/B-Stufen und GEP-Kennzeichnungen wurden verglichen, einschließlich der leeren GEP-Zellen. Eigene5 ist eine Tierprämie und deshalb keine fehlende Flächenkombinationszeile in Anhang L.

Die 20 Tarifzeilen bewahren 32 numerische A/B-Basissätze, 20 GEP-Sätze und zwei MLK-Sätze sowie die ursprünglichen Striche als `null`. 2023 und ab2024 sind vollständig getrennt. Die Proben prüfen alle 27 Rassen an einer jeweils passenden weiblichen Kategorie, sämtliche 32 numerischen A/B-Zellen und vier Kombinationen aus MLK-Jahr/Stufe. Positive GEP-Fälle setzen die tatsächliche Umsetzung durch die zuständige Zuchtorganisation ausdrücklich voraus. Die Gesamtsätze stammen aus der eigenständigen Originaltabelle; historische Selbsttests und Studien-/Adaptationslabels wurden nicht als Sollwerte benutzt.

**O65-TABLE-001 – GEP-Zuschlag liest Rassenkennzeichnung, nicht tatsächliche Jahresumsetzung** (EXTERNAL_DEPENDENCY, medium)

Alle27 Rassenkennzeichnungen und sechs GEP-Auflagen sind richtig gespeichert. gep_surcharge() hängt allein an special_gep=true; ein Feld zur tatsächlichen Umsetzung durch den jeweiligen Zuchtverband fehlt. Der native Run benennt dies selbst als A-31 offen. Bestätigung/Programmapproval ist keine explizit modellierte Jahresumsetzung. Deshalb keine unbedingte Förderfreigabe der GEP-Komponente allein aus der Tabelle: vollständige positive Tarifproben setzen die Umsetzung ausdrücklich voraus; kein erfundener Negativinput wird als bestätigter Originalfall ausgegeben.

> falls ein besonderes Generhaltungsprogramm vom jeweiligen Zuchtverband umgesetzt wird — `o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf`, PDF-Seite 5
> Für Rassen mit besonderem Generhaltungsprogramm (GEP) gilt: — `20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 9

**O65-TABLE-002 – Mehrfachkürzungsreihenfolge ist korrekt dokumentiert, nur teilweise ausgeführt** (TABLE_CONSUMPTION, medium)

Alle elf Schritte sind richtig kopiert, werden aber nirgends gelesen. Bei dieser Tierprämie entfallen die reinen Flächenschritte zu Recht. Eigene Auszahlung setzt Zugang/Vertrag als Nullgate und berücksichtigt Inhaltsstufe sowie Betriebsgrößenmodulation. Trotz applies_to_o6_5=true fehlt ein aktiver Fristversäumnis-/Konditionalitätskürzungsschritt; der fertige Nettobetrag ist keine vollständige amtliche Auszahlungsberechnung. GSP-AV ist nicht im Quellenpaket; darüber hinausgehende konkrete Tierübererklärungsformeln werden hier nicht aus zusätzlichem Kontext rückwirkend als Generationsorakel benutzt.

> Kürzung bei Fristversäumnis — `20241011_srl_oepul_2023.pdf`, PDF-Seite 25
> der sozialen Konditionalität — `20241011_srl_oepul_2023.pdf`, PDF-Seite 25

**O65-TABLE-003 – Zwei Organisationssuffixe unterscheiden sich zwischen Quellen, Daten folgen Anhang D** (SOURCE_VERSION, info)

Ennstaler Bergschecken und Murbodner stehen im Maßnahmenblatt S.8 mit Rinderzucht Steiermark eG, im Anhang D S.9 mit eGen. Native Daten verwenden vollständig eGen und die native A-35 dokumentiert diese Quellenwahl. Das ist keine falsche Rassenzeile und ändert weder Stufe noch Satz. Organisationsnamen werden ohnehin nicht geprüft; verantwortliche Organisation/Bestätigung bleibt ein externer Nachweis.

> Rinderzucht Steiermark eG — `o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf`, PDF-Seite 8
> Rinderzucht Steiermark eGen — `20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 9

Die 2026-Ausnahme ist positiv umgesetzt: Das Original vom 12. August verkürzt die Haltung bis einschließlich 31. August, erhält Tierbewegungsmeldungen bis zum Jahresende und erlässt Nachbesetzungsmeldungen erst nach dem 31. August. Der Verbraucher behandelt diese drei Aspekte getrennt. Richtige Datenwerte ersetzen dabei keine vollständige Prüfung aller Tierhaltungs- oder Meldebedingungen; diese erfolgt in den anderen Teilen derselben Maßnahmenprüfung.

Die zehn Kategorien bewahren die unterschiedlichen Bezugsdaten, Geschlechter, Arten und Altersgrenzen. Der jährliche Zuchteinsatz ist nur für Stier, Widder, Bock und Eber vorgegeben; Hengste behalten den eigenen Nachkommensnachweis. Die vier Rechtsformen werden tatsächlich positiv gelistet. Reine Flächenobergrenzen werden korrekt nicht auf die Tierprämie angewandt. Inhaltskürzung und Betriebsgrößenmodulation sind aktive Zahlungsschritte, keine bloßen Tabellendekorationen.

Die Abwesenheitsliste ist eine technische Klassifikation. Das Original nennt für kurze dokumentierte Aufenthalte offene Beispiele; daraus wird keine Pflicht zum Verwerfen jedes nicht aufgezählten Beispielnamens abgeleitet. Die 50%-Sauenwurfquote ist ausdrücklich eine offene native Interpretation von „mindestens jeder 2. Wurf“; aus den Aggregaten kann keine vollständige Reihenfolgeprüfung bewiesen werden.

GSP-AV liegt diesem historischen Run nicht bei. Frühere vollständige Lektüre bleibt zusätzlicher Kontext; konkrete weitere gesetzliche Formeln werden diesem Generator nicht rückwirkend als im Paket gelieferte Sollvorgabe angelastet. Amtliche Einstufung, korrekte Register- und Organisationsnachweise, tatsächliche GEP-Umsetzung, Verwaltungskontrollen sowie vorgelagerte Flächenklassifikation bleiben externe Grenzen. Ein etwaiger numerischer Effekt der gepinnten Laufzeit wird getrennt von den richtigen Originalwerten bewertet.

| Unveränderte native Datei | SHA-256 |
|---|---|
| `breeds.json` | `f457d3bd96f860167e726ca2597ce4da34f3c60867f12a1794b2f1a329819224` |
| `premium_rates.json` | `9a86b998179d74d1b47d22851f894272b9a7096ea2077c14d6eca2d72e7e447e` |
| `animal_categories.json` | `546743bd3a5eb3c1a694348c4293a276cb5282925390385d3ae5989c63d05b2b` |
| `general.json` | `9a385170b13fcf95dec113da28b9a8a0f164084dd12cbb88e6c3005855825090` |

| Originalquelle | SHA-256 |
|---|---|
| `20241011_srl_oepul_2023.pdf` | `b9b8daabcde20d6dd3dfa58987aee5c481d8993fe4b6c752fe778bc9468d4798` |
| `20241011_srl_oepul_2023_anhaenge.pdf` | `1f608a5a43f1f93df5f8fd542233b37d312d11fd5d0fa5164d3bd8d4b60a119a` |
| `2026-05-22__trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen.html` | `337f679255d85af31a4d55039b448420158e0647fd3f279153c0d67f4ec3e4b8` |
| `2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html` | `be5ae0458262511e840119e8e654f2b1331f510da87fe97506e38d49cb19bed4` |
| `2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html` | `6766adb41b9ae176b9aafb1db390f67bd25cbfcc9ce249012bbfc0d7b60acca4` |
| `2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html` | `661072233da37d1ac62aba860e36173e83c98c85119bc6170c0a27dd7d7e435c` |
| `o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf` | `3a6df7cf48c357caa5fade68751bdbdb719e7d7ac7a7374cc4049dd7b50f152b` |
| `o6_allgemeine_teilnahmebedingungen_2026_04.pdf` | `89ad678a94ad109f6ba92563be4650dd0d36a6f3599506a187b56b1398dca120` |

Die Quellenbelege sind auf der gebundenen Originalseite maschinell auffindbar. Beim mehrzeiligen Tabellenname „Gemsfarbige Gebirgsziege“ wurde für das Maßnahmenblatt ein unmittelbar auffindbares Fragment verwendet; der vollständige Name und alle restlichen Zeilenfelder sind zusätzlich unmittelbar an Anhang D gebunden. Rotierte andere Annexseiten sind nicht als fehlende Daten dieses Anhang-D-Blatts gewertet. Historische Quellen, Profile, Regeln und Laufzeitpins wurden nicht verändert.
