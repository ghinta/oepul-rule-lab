# o6_11 – Herbizidverzicht: fachliche Domänenprüfung

Run `v2-o6_11-opus-5.5-high-20261001`; Rohsnapshot `e009eed4a83ff076b26eba33ac433ac2b0642621`. Nur der aktuelle Run 13/26. Dieser Teil besitzt exakt 21 historische Regel-IDs. Root sammelt und prüft die fünf getrennten Teile anschließend gemeinsam.

**Native Kontrolle: 130 Fälle, 130 definierte Ergebnisse, 120 erfüllte lokale Sollwerte.** Acht abweichende Checks gehören zu drei konkreten Fehlerfamilien. Zwei weitere betreffen einen nur in der Quelle beschriebenen Planungsworkflow und einen ausdrücklich erweiterten Inventararchivvertrag. Das sind keine zehn unabhängigen Defekte und keine globale Genauigkeitsquote.

## Gelieferte Quellen und tatsächliche Lektüre

Alle vier Seiten des neuen Merkblatts wurden vollständig persönlich gelesen, einschließlich der Tabellen, Hinweise, Aktualisierungen und des Schlussvermerks. Alle sechs tatsächlichen Module mit insgesamt 1199 Zeilen und sämtliche 19 nummerierten Rohannahmen einschließlich technischer und Quellenhinweise wurden vollständig gelesen.

Primäroriginal: `sources/oepul/originals/o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf`, vier Seiten, SHA-256 `3cbe2c5c271afcc4045eb56658d3457227087dc9e9402cf1b5ba640e1a1f7556`.

Die sieben identischen gemeinsamen Originale sind über Hash und Dateigröße an frühere vollständige Lektüren gebunden. Aktuell wurden die vollständigen relevanten Seiten SRL 9/10/15/18/25/37/66, ATB 4/7/8/13/14 und Anhang L 103 erneut gelesen. Tables und QA kontrollieren die Originalbilder der Kombinationszeile selbst; hier wird keine zusätzliche eigene Bildprüfung behauptet. Die acht gelieferten Quellen enthalten weder GSP-AV noch NAPV. Quellen anderer Runs werden nicht rückwirkend eingeführt.

## Konkrete lokale Befunde

### O611-MEASURE-01: Quellenqualifikatoren und tatsächliche MFA-Namen fallen aus dem Obstbereich

Die 31 gespeicherten Grundnamen und drei Ergänzungen ab 2025 funktionieren. Die gespeicherten Hinweise zu Aronia-Verwandten, Brombeer-Kreuzungen und anderen Schalenfrüchten haben dagegen keinen Verbraucher. Eine positiv bekannte Pistazienanlage zählt deshalb nicht als Obst. Auch die im aktuellen Original ausdrücklich verwendeten MFA-Namen Walnüsse und Edelkastanien werden gegenüber den allein gespeicherten Singularformen verworfen. Alle sechs lokalen Kontrollen ergeben 0 statt 1: je eine Obstbereichs- und eine tatsächliche Herbizidanwendungsprüfung pro Name. Das sind sechs Auswirkungen derselben Familienlücke. Die vorhandenen singularen Walnuss-/Edelkastanienkontrollen erhalten die Verzichtsdiagnose korrekt; Root bewahrt deren ebenfalls korrekten Prämienausschluss. Freie crop_name-Strings sind hier keine Enumverstöße; ein beliebiger Tippfehler wird nicht zum Gold erhoben. Andere Kreuzungs- oder Züchtungsnamen werden ohne positive Identifikation nicht erfunden. Eine unverifizierte Art erhält dadurch keine Freigabe.

> „Aronia und deren verwandte Züchtungen, Birne, Brombeere sowie deren Kreuzungen“
> 20241011_srl_oepul_2023.pdf, PDF-Seite 9.

> „Haselnuss sowie andere Schalenfrüchte“
> 20241011_srl_oepul_2023.pdf, PDF-Seite 9.

> „als „Walnüsse“ mit dem Code OP beantragt werden und erhalten keine ÖPUL-Prämien.“
> o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf, PDF-Seite 3.

> „Die Schlagnutzungsarten Sonstige Weinflächen, Sonstige Spezialkulturflächen, Walnüsse und Edelkastanien erhalten in dieser Maßnahme keine Prämie.“
> o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf, PDF-Seite 4.

> „Im Vertragszeitraum muss auf der gesamten Wein-, Obst- und Hopfenfläche des Betriebes vollständig auf Herbizide verzichtet werden.“
> o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf, PDF-Seite 2.

Native Fälle: `o6_11-source-fruit-Pistazie`, `o6_11-source-fruit-ban-Pistazie`, `o6_11-source-fruit-Walnüsse`, `o6_11-source-fruit-ban-Walnüsse`, `o6_11-source-fruit-Edelkastanien`, `o6_11-source-fruit-ban-Edelkastanien`.

### O611-MEASURE-02: BIO-Fungizid plus chemisch-synthetisches Herbizid bleibt mit allein PSMCSH vollständig gemeldet

Bei zwei tatsächlich bekannten flächigen Anwendungen auf derselben Obstkultur unterdrückt has_cs_herbicide den benötigten BIO-Code. Gleichzeitig erzeugt nur has_cs_other einen PSMCS-Code. So genügt nativ allein PSMCSH; die getrennte Meldung des BIO-Einsatzes fehlt. Die lokale Zahl fehlender Codes ist 0 statt 1. Das Quellenbeispiel erlaubt PSMCS für den gemischten Einsatz und verlangt bei Herbizid jedenfalls zusätzlich PSMCSH; die Kontrollen akzeptieren sowohl PSMCSH+PSMCS als auch PSMCSH+PSMBIO und behaupten keinen eindeutigen exklusiven Code aus der Quelle. BIO-Fungizid plus chemisch-synthetisches anderes Mittel mit PSMCS funktioniert. Der tatsächliche Herbizideinsatz verletzt unabhängig davon korrekt den Verzicht; es wird weder volle Compliance noch eine willkürliche Geldkürzung abgeleitet. Ein real BIO-zugelassenes Herbizid ist nicht Teil dieses Gegenfalls.

> „PSMBIO im Biolandbau zugelassene Pflanzenschutzmittel“
> o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf, PDF-Seite 2.

> „Schlag nur der Code PSMCS angegeben wird. Bei Einsatz eines Herbizids ist jedenfalls die separate Angabe mit dem Code PSMCSH erforderlich.“
> o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf, PDF-Seite 3.

Native Fälle: `o6_11-combined-bio-fungicide-csherb-PSMCSH`, `o6_11-combined-bio-fungicide-csherb-PSMCSH-PSMBIO`, `o6_11-combined-bio-fungicide-csherb-PSMCSH-PSMCS`, `o6_11-combined-bio-fungicide-csherb-PSMCS`.

### O611-MEASURE-03: Ein verspäteter BIO-Zielvermerk unterdrückt die weiterhin unzulässige Betriebskombination

Für die tatsächlich gleichzeitig zur Beurteilung eingereichten Maßnahmen 11 und volle 1B liegt kein rechtmäßiger Ersatz des bisherigen Vertrags vor. Der Umstiegsantrag vom 1. Januar 2026 ist nach beiden gelieferten Fristlesarten verspätet. Diese Fristdiagnose erscheint korrekt. Trotzdem entfernt converted_to_organic allein wegen conversion_target=1B die lokale Betriebskollision: 0 statt 1. Die Funktion prüft weder bewilligten Ersatz noch zulässigen Antrag oder Wirksamkeitsjahr. Ein Antrag wird hier nicht als genehmigter Doppelvertrag behauptet; geprüft wird genau die vorgelegte unzulässige Kombination. Der offene Ende-2025-Fall entscheidet dieses klare spätere Datum nicht. Es wird keine zusätzliche pauschale Zahlungssanktion erfunden.

> „mit der Maßnahme „Biologische Wirtschaftsweise“ ist ausgeschlossen. Dies ist nur bei Teilnahme an „Biologische Wirtschaftsweise – Teilbetrieb“ mit dem Kulturbereich Acker und Grünland möglich.“
> o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf, PDF-Seite 3.

> „Während der Laufzeit der Maßnahme kann bis spätestens am 31. Dezember 2025 in die Maßnahme „Biologische Wirtschaftsweise“ umgestiegen werden.“
> o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf, PDF-Seite 3.

Native Fälle: `o6_11-late2026-target-cannot-waive-fullbio-conflict`, `o6_11-late2026-switch-diagnosis-preserved`.

## Offene Quellen- und Eingabeverträge

### O611-MEASURE-04: Vorabplanung und unverzügliche Streichung sind nur als Katalogtext enthalten

Die historische ID O611-PSM-CODE-ADVANCE hat absichtlich keinen rego_symbol. Das Profil enthält weder Planungs-, Kenntnis- noch Korrekturzeitpunkte. Bei ausdrücklich bekanntem, seit Juni aufgegebenem Plan am Ende des abgeschlossenen Jahres erzeugt der verbliebene PSMCS-Code keine lokale Korrekturpflicht (0 statt 1). Dieser fachliche Kontext ist nicht im Profil darstellbar. Dasselbe Profil könnte früher im Jahr eine legitime Vorabmeldung darstellen. Der Fall belegt eine fehlende Workflowqualifikation; er zählt nicht als deterministischer ordinary-input-Genauigkeitsfehler. Die Lücke ist schon in der ursprünglichen Annahme A08 offengelegt.

> „Die Angabe der Codes kann auch im Vorhinein erfolgen, wenn ein entsprechender Pflanzenschutzmitteleinsatz geplant ist. Sobald absehbar ist, dass doch kein Einsatz durchgeführt wird, ist die Codierung zu streichen. Änderungen oder Nachtragungen von Codes haben umgehend zu erfolgen.“
> o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf, PDF-Seite 2.

### O611-MEASURE-05: Ein ausdrücklich erweitertes Altarchiv wird als aktueller Kauf oder Lagerbestand bewertet

Kaufdatum und in_storage werden im Verbraucher nicht benutzt. Unter einer ausdrücklich erweiterten Inventarhistorie führt ein vollständig verbrauchter Kauf aus 2022 ohne spätere Anwendung oder Lagerrest im 2023 beginnenden Vertrag zu einer aktuellen Diagnose (1 statt 0). Ein vorbereiteter aktueller Kauf-/Bestandsvertrag muss solche Altarchive jedoch nicht aufnehmen. Deshalb bleibt dies eine bedingte Schnittstellengrenze und kein unbedingter landwirtschaftlicher Modellfehler. Aktuelle 2025-Käufe werden auch bei bereits verbrauchter Menge korrekt erfasst; rechtmäßige Käufe für tatsächlich vorhandenen Weizen benötigen sowohl Mengen- als auch Aufzeichnungsnachweis. Aus der generellen Feldanwendungsnorm für Ameisensäure wird hier kein unbelegtes Verbot aller chemischen Käufe zu anderen Zwecken gewonnen.

> „Im Vertragszeitraum muss auf der gesamten Wein-, Obst- und Hopfenfläche des Betriebes vollständig auf Herbizide verzichtet werden.“
> o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf, PDF-Seite 2.

> „Nicht nur der Einsatz, sondern auch der Kauf und die Lagerung von Herbiziden sind verboten. Für Herbizide, die erlaubterweise in anderen Kulturen eingesetzt werden, gilt dieses Verbot nicht.“
> o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf, PDF-Seite 3.

### O611-MEASURE-06: Ende 2025 beantragter BIO-Wechsel mit Wirkung 2026 bleibt zwischen Quellen und A13 offen

Die gelieferte SRL 1.7.3.2 nennt den spätesten Vertragswechsel am 31.12.2025 mit Maßnahmenantrag des jeweiligen Vorjahres; ATB13 nennt ebenfalls den spätesten Vertragswechsel 2025. Das neue MB3 erlaubt einen Umstieg bis 31.12.2025. A13 setzt hingegen die Beantragung 2025 mit Wirkung ab Folgejahr 2026 um. Die native Funktion und ihr offengelegtes Folgejahr werden separat korrekt wiedergegeben. Die Ende-2025-Kontrollen sind ausdrücklich native_disclosed_A13, kein neues hartes Rechtsgold. Ein Ende-2024-Antrag mit Wirkung 2025 passt in beide Lesarten, ein 2026-Antrag liegt nach beiden außerhalb. Vor einer Reparatur ist die anzuwendende Frist-/Antragslesart zu klären.

> „Während des Vertragszeitraumes kann mit spätestem Vertragswechsel am 31.12.2025 mit Maßnahmenantrag des jeweiligen Vorjahres eine beantragte Maßnahme in eine bestimmte andere, höherwertige Maßnahme umgewandelt werden.“
> 20241011_srl_oepul_2023.pdf, PDF-Seite 15.

> „Während des Vertragszeitraumes kann mit spätestem Vertragswechsel am 31. Dezember 2025“
> o6_allgemeine_teilnahmebedingungen_2026_04.pdf, PDF-Seite 13.

> „Während der Laufzeit der Maßnahme kann bis spätestens am 31. Dezember 2025 in die Maßnahme „Biologische Wirtschaftsweise“ umgestiegen werden.“
> o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf, PDF-Seite 3.

## Bereits richtiges Verhalten

Die Kontrollen erhalten die Grenze von 0,50 ha ausschließlich im ersten Vertragsjahr, den Schnittwein- und Schulflächenbereich, den Verzicht auf ungewählten und OP-Flächen sowie den gesamten Vertragsverlauf mit Vorvertrags- und Austrittsgrenze. Sie bestätigen Stamm- und Zaunverbote, den AGES-Wirkungstyp und alle fünf im Merkblatt genannten Ameisensäurenamen bei tatsächlicher Feldanwendung. Ab 2026 entfällt die Meldung, der Verzicht bleibt bestehen. Normaler BIO-/CS-Mischfall, getrennte CSH-Meldung, beide Nachweisflags für andere Kulturen, BIO-Ackerteilbetrieb, Veredelung/OP und Kombinationshinweise haben echte Verbraucher.

Die Probe mit BIO-Flag bei Wirkungstyp Herbizid ist ausdrücklich ein künstlicher Klassifikationsstress. Sie behauptet keine existierende BIO-Zulassung eines echten Herbizids. Der konkrete Meldungsgegenfall verwendet dagegen einen bekannten BIO-Fungizidbefund neben einem chemisch-synthetischen Herbizid.

Registrybefund, tatsächlich erkannte Kultur, rechtmäßige andere Verwendung, Mengenplausibilität und sachlich getrennte BIO-Einrichtungen sind positiv vorbereitete Tatsachen. Die Policy ruft keine Register ab und beweist diese Tatsachen nicht selbst. Ameisensäure ist bei tatsächlicher Feldproduktion unzulässig; daraus wird kein unbelegtes Verbot beliebiger chemischer Käufe für andere Zwecke abgeleitet.

Es wird aus einem lokalen Verstoß weder ein pauschaler vollständiger Prämienverlust noch eine behördliche Endzahlung abgeleitet. Root erhält die tatsächlich vorhandenen Zugangs-/Zahlungssperren und die positiven Tarifkontrollen. General besitzt separat die bekannte Auslandsflächenzählung; diese wird hier nicht nochmals als eigener Defekt gezählt.

## Exakte Regelmatrix

| Historische ID | Stand | Tatsächlicher Verbraucher / Grenze |
|---|---|---|
| `O611-DEF-OBST` | partial | Die 31 Grundnamen sowie die drei Ergänzungen ab 2025 werden korrekt ausgewertet. Andere Schalenfrüchte und wörtliche MFA-Namen verlieren dagegen den Obststatus und damit auch den lokalen Verzicht; siehe gemeinsame Fehlerfamilie 01. |
| `O611-MIN-AREA` | implemented | Die Grenze 0,50 ha wird nur im ersten Vertragsjahr verbraucht; darunter, genau darauf und darüber sind kontrolliert. General dokumentiert separat den bekannten Auslandsanteil ohne geografischen Filter; keine doppelte Fehlerzählung. |
| `O611-SCHNITTWEIN-COUNTS` | implemented | Schnittweingärten zählen zur Mindestfläche und unterliegen tatsächlich dem Herbizidverzicht. Beide Verbraucher wurden kontrolliert. Root besitzt die gesonderte Tarifbeurteilung. |
| `O611-REBSCHULE-EXCL` | implemented | Reb- und Baumschulen zählen nicht zur VFH-Mindestfläche und nicht zum besonderen Herbizidverzicht. Allgemeine Verbote unzulässiger Feldanwendungen bleiben davon unabhängig. |
| `O611-HERB-BAN` | partial | Der gesamte erkannte VFH-Bereich wird unabhängig von einzelner Maßnahmenwahl oder OP geprüft. Der ganze Vertragsverlauf wird einschließlich Vorvertrags-/Austrittsgrenze verbraucht. Die fehlende Fruchtnamenabdeckung begrenzt diesen Bereich; keine pauschale Geldsanktion wird erfunden. |
| `O611-HERB-WIRKUNGSTYP` | implemented | Der bekannte AGES-Wirkungstyp entscheidet; es gibt keine aus Maßnahme 12 importierte BIO-Ausnahme. Registryprüfung ist eine vorbereitete Tatsache. Der explizit künstliche BIO-Klassifikationsstress behauptet keine reale BIO-Herbizidzulassung. |
| `O611-STAMM` | implemented | Eine bekannte Herbizid-Stammanwendung erzeugt die eigene Diagnose O611-STAMM. Das Produkt wird nach registriertem Wirkungstyp und nicht nach Werbename eingeordnet. |
| `O611-FENCE` | implemented | Ein bekannter Herbizideinsatz am Zaun eines tatsächlich eingezäunten Schlages erzeugt die eigene Diagnose O611-FENCE. Ein vermeintlich freier Zaunstreifen wird nicht angenommen. |
| `O611-AMEISENSAEURE` | implemented | Alle fünf Originalnamen sowie Groß-/Kleinschreibung werden bei tatsächlicher Feldanwendung erkannt, auch auf einem anderen Ackerschlag. Das weitergehende Inventarverbot wird nicht ohne passende Quelle auf beliebige chemische Zwecke verallgemeinert. |
| `O611-PSM-CODE-REQ` | partial | Aktuelle flächige Anwendungen erzeugen bis 2025 lokale Codepflichten. Nicht flächige und andere Antragsjahre werden getrennt behandelt. Der BIO-Fungizid/CS-Herbizid-Mix zeigt eine fehlende separate Meldediagnose. |
| `O611-PSM-CODE-ADVANCE` | catalog_only | Die historische ID hat keinen rego_symbol und keinen Zeit-/Workflowverbraucher. Ein bekannter aufgegebener Plan belegt fehlende Quellenabdeckung, keinen aus dem bloßen Jahresprofil deterministisch ableitbaren Fehler. |
| `O611-PSM-CODE-COMBINED` | partial | BIO plus chemisch-synthetisches anderes Mittel wird korrekt mit PSMCS gemeldet. Bei BIO-Fungizid plus CS-Herbizid entfällt zusätzlich jeder BIO/CS-Codebedarf; allein CSH genügt nativ zu Unrecht. Die Herbizidverbotsdiagnose bleibt korrekt. |
| `O611-PSM-CODE-HERB` | implemented | Ein tatsächlicher chemisch-synthetischer Herbizideinsatz benötigt den separaten Code PSMCSH, auch wenn PSMCS schon vorliegt. Es wird kein real BIO-zugelassenes Herbizid erfunden. |
| `O611-PSM-CODE-2026-ABOLISHED` | implemented | Ab 2026 entfällt tatsächlich die PSM-Codierung; Verzicht und Kauf-/Lagerbedingungen bleiben bestehen. Quellen aus anderen historischen Packets werden nicht nachträglich als geliefert behauptet. |
| `O611-PURCHASE-STORAGE` | partial | Aktuelle verbotene Käufe und Bestände werden erkannt. Kaufdatum und Restbestand haben keinen Verbraucher; die Altarchivabweichung ist ausdrücklich an einen erweiterten Eingabevertrag gebunden. |
| `O611-PURCHASE-OTHER-CROPS` | partial | Die vorhandene andere Kulturkategorie wird verbraucht. Die Rechtmäßigkeit des konkreten Produkts/Zwecks und fachlich passende Mengen werden in den Positivfällen ausdrücklich vorausgeprüft; Kategorie allein beweist sie nicht. |
| `O611-PURCHASE-PLAUSIBLE` | implemented | Beide bekannten Expertenbefunde records_documented und quantity_plausible müssen true sein; jedes false verhindert die Ausnahme. Daraus folgt keine eigenständige numerische Mengenprüfung. |
| `O611-COMB-BIO` | partial | Volle BIO-Teilnahme kollidiert; ein tatsächlich getrennter BIO-Teilbetrieb ausschließlich Acker/Grünland ist ausgenommen. Ein bloßer Zielvermerk hebt die lokale Kollision sogar bei sicher verspätetem 2026-Antrag auf. |
| `O611-SWITCH-BIO` | unresolved | Die native Folgejahrannahme A13 ist nachvollzogen. Die echte Lesart zwischen neuem MB3 und SRL15/ATB13 zum spätesten Vertragswechsel bleibt offen; Ende-2025-Antrag mit Wirkung 2026 ist kein unbedingtes Rechtsgold. |
| `O611-OBST-VEREDELT` | implemented | Unveredeltes Obst wird tatsächlich von der Prämie ausgeschlossen; veredeltes bleibt grundsätzlich geeignet. Die OP-Kontrollen enthalten konsistent den positiv bekannten OP-Fall. Das Ganzbetriebsverbot bleibt auch für unveredeltes Obst bestehen. |
| `O611-COMB-PARCEL` | implemented | 2, 10 und 12 sind kombinierbar; 1A bleibt auf Landschaftselemente beschränkt und erzeugt den Hinweis. 1B auf derselben Weinfläche kollidiert unabhängig von einem zulässigen BIO-Ackerteilbetrieb. Tables/QA besitzen die vollständige Bild-/Zellenprüfung. |

## Eingabekonstruktion und Wiederholung

Die vollständigen Inputs und lokalen Sollwerte wurden vor der nativen Ausführung gespeichert. Eine erste Enumprüfung fand in zwei noch nicht eingefrorenen BIO-Gruppenkontrollen den falschen Entwurfswert `permanent_crops`. Er wurde durch den tatsächlichen Proposalwert `wine_fruit_hop` ersetzt. Beide Sollwerte bleiben 1; Queries und fachliche Tatsachen änderten sich nicht. Die Korrekturledger enthält den zuvor gesicherten Draft-SHA sowie die exakten Vorher-/Nachher-Inputhashes. Anschließend wurden alle 130 Fälle vollständig neu ausgeführt.

Die Ausführung verwendet den fest gebundenen `/tmp/issue-51-review-opa`, `--strict-builtin-errors` und die vollständigen ursprünglichen Verzeichnisse `workspace/policy` und `workspace/data`. Keine Policyänderung, kein Flattening und keine Typnormalisierung. Die fachlichen Abfragen verwenden `data.oepul.o6_11`; Rohdaten liegen unter `data.o6_11`.

Ein unabhängig gefundener gültiger `exit_date=null`-Wert kann die Hauptentscheidung in `year_of` abbrechen; Inputs besitzt diesen Fehler. Die positiven Fälle ohne Austrittsantrag lassen ausschließlich dieses optionale Datumsfeld bewusst weg. Eine abgeänderte Policy oder ein Reparaturadapter wird nicht benutzt.

Die expliziten Enum- und vorhandenen Typwerte werden vor der Sammlung gegen unverändertes Canonical und die tatsächlichen 10 Profilvorschläge geprüft. Diese begrenzte Konstruktionskontrolle beweist weder Vollständigkeit noch landwirtschaftliche Quellwahrheit. Quellzitate behalten Unicode-Zeichen; lediglich Leerraum und weiche Trennzeichen werden beim Literalvergleich normalisiert.

Abschlussprüfung: 1431 Enumwerte und 12745 vorhandene Typwerte ohne Abweichung; 555 Zitatvorkommen / 55 einzigartige Zitate vollständig literal belegt; 35 Codebindungen und 17 Seitenbereiche gültig.

JSON-Freeze: `39e9d6edb7027003be2ac928388cd1b59d007d397045b44cbb02d6ca13b6af06`. Die vollständigen originalen OPA-Ergebnisse, Quellenbelege, Codebindungen, Leseprotokolle und Grenzen stehen in `measure.json`. Root/QA müssen diesen Teil noch unabhängig abnehmen.
