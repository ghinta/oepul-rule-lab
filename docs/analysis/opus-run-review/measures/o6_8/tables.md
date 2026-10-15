# o6_8: Vollständiger Tabellen- und Verbraucheraudit

Geprüft ist ausschließlich der unveränderte rohe Run `v2-o6_8-opus-5.5-high-20261001` am Kandidatencommit `e009eed4a83ff076b26eba33ac433ac2b0642621`. Die neue Maßnahmenquelle mit Stand April 2026 wurde auf allen zwölf Seiten einschließlich Beispielen, Tabellen, Übergängen, Aktualisierungen und Impressum gelesen. Alle zehn Produktionsmodule und 24 Rohannahmen wurden vollständig gelesen. Die sieben gemeinsamen Originalquellen sind durch identische SHA256 an die frühere vollständige Lektüre gebunden; einschlägige aktuelle Klauseln wurden erneut abgeglichen. GSP-AV ist kein Bestandteil dieses historischen Quellenpakets.

Die acht Datendateien enthalten 30 Inventarcontainer mit 2.407 direkten Einträgen. Alle Zeilen, verschachtelten Werte und Fußnoten wurden gegen die Originale geprüft; weitere 72 Metadatenblätter außerhalb der Inventarpointer sind separat erfasst. Es gibt hier keine überlappenden Eltern-/Kindpointer. Die korrekte Datenübernahme ist von der tatsächlichen fachlichen Ausführung und amtlichen Zahlungsentscheidung getrennt.

| Datendatei | Container | Direkte Einträge | SHA256 |
| --- | ---: | ---: | --- |
| `eligible_crops.json` | 6 | 89 | `995f76168733bd831883acb7d70be50565aae1a2eaeecb3754d7dd9096a99b4b` |
| `premium_rates.json` | 1 | 12 | `8e3e3a812801310ce716f28d9ba727127d7236edeaeaefed74b44283258b690e` |
| `measure_parameters.json` | 6 | 18 | `1f25ce183e838ae4a1ee5816a0e8ede5009398ace7ddfe3169fc6f09ef793f80` |
| `general_conditions.json` | 8 | 54 | `3407d12bb0338b2034be489460023a7b3c34a3cc6332a7a90cc55ea61d8d554c` |
| `definitions.json` | 4 | 82 | `9f239f07220c4e299989f45ea9b1b55cac2bd4e8c49ebfe42edfeae8b247a1be` |
| `drought_2026.json` | 1 | 41 | `2a2ba51a42df95e8a693ddaa8015af8b7b6c487fa5e220b34439fcfa7abe6045` |
| `anhang_f_erosion_pathways.json` | 1 | 1.952 | `2120d4677ba43fff75c07aeef4d188b13813158bd47050e5958b4e6ea6cd8f32` |
| `anhang_l_combinations.json` | 3 | 159 | `a0aef68551768934ba22e618fce8a27ce9d2efbcd5e5a33b6691c5c12e03dd66` |

Die maschinenlesbare Zeilenprüfung und sämtliche Originalbelege stehen in [tables.json](tables.json). Für jede Zeile sind Originalwert, Quellenbindung, Verbraucherstatus und exakte Codeverweise erhalten. Ein gefundener Verweis allein wird nicht als Ausführung jeder Bedingung gewertet.

## Vollständige Quellenvergleiche

Anhang F wurde unabhängig aus sämtlichen Tabellenzeilen der Originalseiten 12–37 ausgelesen. Alle 1.952 Zeilen stimmen in Bundeslandkürzel, ausgeschriebenem Bundesland, politischer Gemeinde, Katastralgemeinde, KG-Nummer und Seite überein, ebenso die vollständige Reihenfolge. Es gibt 1.952 eindeutige KG-Nummern, keine fehlende oder zusätzliche Zeile und keine Dublette. Die Verteilung ist Burgenland 79, Niederösterreich 764, Oberösterreich 612 und Steiermark 497. Seite 12 enthält 74 Zeilen, Seiten 13–36 jeweils 78 und Seite 37 sechs. Der aktive Verbraucher baut die KG-Menge aus allen Zeilen. Die notwendige KG-Mitgliedschaft ersetzt die lagegenaue Überlagerung mit dem AMA-GIS-Pfad nicht; diese Grenze benennt bereits die native Annahme 6.

Die vollständige Kombinationstabelle auf Anhangseite 103 wurde anhand der ursprünglichen gedrehten Tabelle und einer unabhängig daraus transkribierten Koordinatenmatrix geprüft. Gespeichert sind 134 positive Zellen. Zusätzlich wurden alle 286 impliziten leeren Offdiagonalpaare abgeglichen, insgesamt 420 Koordinaten. Die 21 Diagonalen sind keine zusätzlichen Paarurteile. Alle 21 Überschriften mit Headerfußnoten und alle vier Fußnotentexte sind richtig. Eigene Maßnahme 8 hat die acht positiven Partner 1A, 1B, 2, 6, 7, 9, 16 und 24; Fußnoten und konkrete Verfahren bleiben zusätzliche Voraussetzungen.

Alle 31 MS/DS-Kulturen sind richtig; zehn Kartoffelzeilen sind nur für MS und 21 für beide Verfahren zulässig. Die 27 US-Zeilen enthalten elf unveränderte Einträge und 16 Erweiterungen ab 2025. Alle zehn AH-Kulturen und fünf BAW-Kulturen stimmen; Kleegras ist für Neueinsaaten ausgeschlossen. Unterschiede wie „Sonnenblumen“ bei MS/DS gegenüber „Sonnenblume“ bei US und verschiedene Gemenge-Schreibweisen stehen bereits in der Originalquelle. Sie sind durch den ausdrücklichen nativen Vertrag wortgetreuer MFA-Schlagnutzungsarten eingegrenzt, keine nachgewiesenen botanischen Ausschlussfehler. Die Kartoffel-DS-Sperre, US-Jahresgrenze und Kleegras-Altbestandsqualifikation werden tatsächlich konsumiert.

Alle zwölf Tarife samt Jahren und Zuschlagsrolle sind korrekt: 2023 MS 50, DS 80, AH 150, BAW 550, US 75 und zusätzlicher BIO-US-Zuschlag 15 Euro/ha; ab 2024 entsprechend 54, 86,4, 162, 594, 81 und 16,2 Euro/ha. Die BIO-Komponente wird tatsächlich zusätzlich zur US-Basis berechnet. Alle vier Vorfruchtprogramme mit ihren Varianten, Gültigkeitsjahren und Überwinterungsbedingungen werden aktiv gelesen. Die 11 Getreide-, 8 Nichtgetreide-/Gemenge-, 7 Ackerfutter- und 56 Feldgemüsezeilen sind vollständig. Nur Ackerfutter wird aus dieser Definitionstabelle direkt verwendet.

Die Dürrekulisse enthält 39 benannte Bezirke und zwei Ganzlandfälle für Burgenland/Wien, als 41 flache Zeilen gespeichert. Sämtliche Namen, Bundesländer und Notice-Daten stimmen. Der Verbraucher verlangt neben der Kulisse zusätzlich 2026, tatsächlich dürrebedingt fehlenden Erntebestand und eine üblicherweise im Spätsommer oder Herbst geerntete Kultur. Andere Verpflichtungen werden dadurch nicht aufgehoben.

## Befunde und Grenzen

| ID | Einordnung | Ergebnis |
| --- | --- | --- |
| `O68-TABLE-001` | info / `EXTERNAL_DEPENDENCY` | Vollständige KG-Liste ist kein lagegenauer Erosionspfadnachweis |
| `O68-TABLE-002` | info / `TABLE_CONSUMPTION` | Kombinationswerte vollständig, Qualifikationen nur für dargestellte native Tatbestände |
| `O68-TABLE-003` | info / `SOURCE_VERSION` | 25%-BAW-Grenze, neue US-Kulturen und Konfliktzahlung bleiben ausdrücklich erklärte Auslegungen |
| `O68-TABLE-004` | info / `IDENTITY_NORMALIZATION` | Exakte MFA-Namen bewusst originalgetreu, offene Klassifikationen bleiben vorgelagert |
| `O68-TABLE-005` | info / `TABLE_CONSUMPTION` | Kappungs- und Sanktionsdaten sind keine ausgeführte amtliche Nettozahlung |
| `O68-TABLE-006` | low / `FOREIGN_SCOPE` | Unverbrauchter Force-majeure-Cutoff ist zu breit benannt |

Die beiden besonderen Fußnote-4-Verbraucher für BAW und Wiener MS/DS-Sperren sind separat implementiert. Für die Qualifikation „Auswaschungsgefährdete Ackerflächen“ innerhalb Maßnahme 16 fehlt dagegen ein eigenes natives Eingabefeld. Das ist eine Grenze der modellierten Tatsachen und der allgemeinen Zellhelper; es wird kein erfundener AG-Fall mit einem nicht vorhandenen Feld als konkrete Zahlungsprobe ausgegeben.

Die Mindest-Viertelgrenze des neuen Merkblatts gegenüber „zumindest teilweise“ und vierfacher Förderfläche in der älteren SRL bleibt als ausdrücklich erklärte Rechtsstandsfrage offen. Die mathematische Beziehung setzt dieselbe Bezugsfläche voraus und entscheidet nicht allein über identische Zugangsfolgen. US bei Sudangras folgt dem neueren Merkblatt; die ältere SRL nennt ab 2025 nur Mais/Sorghum. Bei MS/DS plus AH steht die fehlende prämienfähige Kombination fest, die Auswahl der zu streichenden Zahlung ist nicht festgelegt. Die native Nullsetzung aller betroffenen Verfahren bleibt als Zahlungswahl gekennzeichnet.

Der gespeicherte Schlüssel `force_majeure_premium_year_cutoff_mmdd` ist zu breit benannt. Seine Zahl 15. April stammt aus SRL Seite 15, Abschnitt 1.7.4.2 für dauerhafte flächen- und bewirtschaftungsverändernde Umstände. Diese Klausel nimmt höhere Gewalt ausdrücklich aus. Daraus folgt kein allgemeiner Force-majeure-Stichtag. Das Feld ist vollständig unreferenziert und verändert die eigene Entscheidung nicht; es wird als niedriger Metadaten-/Bereichsbefund erfasst.

Modulationsbänder, neun Caps, neun Sanktionszeilen und elf Kürzungsschritte sind korrekt. Die Modulation wird tatsächlich auf die Prämie angewandt. Der Cap-Verbraucher exportiert ein Überschreitungsflag, kürzt damit aber den ausgegebenen Eurobetrag nicht. Sanktionsstufen und Reihenfolge sind Exporthelper; amtliche Einstufung und vollständige Nettozahlung sind daraus nicht automatisch ausgeführt. Konkrete Prämien- und Sanktionsfolgen werden mit dem allgemeinen Auditteil zusammengeführt.

## Neue Quellenproben und Abschlussbindung

22 neue Probeobjekte prüfen die vollständigen Kultur-Gates, alle zwölf Tarifzeilen einschließlich späterer Jahresgeltung, alle 1.952 KG-IDs, alle 420 Matrix-Lookups, beide LSE-Ausnahmen gegenüber voller anderer Förderung, sämtliche Bezirks-/Ganzlandzeilen, alle sieben Ackerfuttergruppen sowie Modulations- und Sanktionshelper. Die Eingabevoraussetzungen und Quellenbelege sind jeweils ausdrücklich festgehalten. Technische Namens-/Typfälle und reine Symbol-Lookups sind als solche bezeichnet. Es werden keine neuen tatsächlichen Orts-, Pflanzen- oder Sortenzulassungen erfunden. Jede abweichende Query steht direkt im Probeobjekt; sämtliche Erwartungen verwenden `equals` auf dem tatsächlichen skalaren, Tupel- oder Arrayresultat.

Die eigene vollständige Quellen-/Boundsprüfung fand 2.981 wörtliche Belegvorkommen mit 2.309 verschiedenen Bindungen und 7.790 Codeverweisvorkommen mit 133 verschiedenen exakten Codezeilen. Alle Quellen- und Inventarhashes, Zeilenwerte und Codegrenzen stimmen; es bleiben null Beleg-/Boundsfehler. Der Hinweis auf gedrehte PDF-Texte wurde durch den ursprünglichen vollständigen Tabellenrender und die Koordinatenprüfung berücksichtigt.

Die Tabellen-JSON wurde ausdrücklich vor dem gemeinsamen Replay eingefroren. Root/QC führen den Replay mit der gepinnten OPA und unveränderten ursprünglichen Daten-/Policy-Verzeichnissen aus; hier erfolgte keine eigene Ausführung und keine Datentypnormalisierung. Ein Quellenabgleich ist keine allgemeine fachliche Freigabe des gesamten Runs. Es wurden weder produktive/historische Dateien geändert noch weitere Maßnahmen begonnen.

JSON-SHA256: `27307c9584ccd4637554333fd67a297c27d021fe4a7633790bbecf5e9249bc8c`.
