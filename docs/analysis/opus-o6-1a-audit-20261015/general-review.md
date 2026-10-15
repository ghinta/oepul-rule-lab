# UBB: allgemeine Teilnahmebedingungen und Zugang

Geprüft wird ausschließlich der unveränderte historische Run
`v2-o6_1a-opus-5.5-high-20260929` aus Kandidaten-Commit
`e009eed4a83ff076b26eba33ac433ac2b0642621`. Diese Prüfung ist eine öffentliche,
manuelle Entwicklungsprüfung. Sie ist keine fachliche Freigabe durch GM oder
Domainexpert:innen und kein Gold-Test.

**Die allgemeinen Bedingungen reichen für eine Übernahme der nativen
Gesamtentscheidung in die App noch nicht aus.** Numerische Einzelregeln sind
vielfach richtig. Die Gesamtentscheidung verbindet jedoch Vertragsgültigkeit,
Zahlungsantrag, Flächenausschlüsse und mehrere errechnete Rechtsfolgen nicht
vollständig mit dem ausgewiesenen Betrag. Ein positives `access_conditions_met`
und `premium.net` dürfen deshalb keine bestätigte Förderfähigkeit oder Auszahlung
darstellen.

## Tatsächlicher Prüfungsumfang

- Allgemeine Teilnahmebedingungen, April 2026: **alle 21 PDF-Seiten** gelesen,
  einschließlich Flächendefinitionen, Ausnahmen, Beispielen, Obergrenzentabelle,
  Aktualisierungen und Impressum.
- UBB-Informationsblatt, April 2026: **alle 46 PDF-Seiten** als Kontext gelesen.
  Der vollständige Abgleich der Tabellenzeilen mit den Datendateien wird in der
  gesonderten Tabellenprüfung geführt.
- Sonderrichtlinie vom 11.10.2024: **alle 94 PDF-Seiten** vollständig im
  extrahierten Text auf UBB-Relevanz gelesen. **59 Seiten** wurden vertieft gegen
  die UBB-Implementierung geprüft: 1–36, 44–51, 59–60, 74–83, 91–92 und 94.
  Andere Maßnahmen wurden als Quellkontext gelesen; ihre eigenen Policies sind
  nicht Gegenstand dieser Prüfung. Das JSON enthält eine Zuordnung jeder Seite.
- Vollständig gelesen: `general_conditions.rego`, `general_obligations.rego`,
  `eligibility.rego`, `livestock.rego`, `main.rego` und `common.rego`. Der
  Rechtsfolgenabgleich schließt `premium.rego` sowie die FWK-Zuschlagsfunktionen
  ein. Die übrigen UBB-Fachmodule werden gesondert geprüft.
- **50 Regelkatalog-Einträge** sind einzeln mit Befund, ursprünglicher
  Quellenbindung und Codebeleg verzeichnet. Für die allgemeinen Bedingungen
  sind außerdem sämtliche 33 ursprünglichen Coverage-Einträge unabhängig
  eingeordnet. „Im Katalog vorhanden“ bedeutet dabei nicht „vollständig
  ausgeführt“.

Die maschinenlesbare Prüfspur steht in [general-review.json](general-review.json).
Sie enthält die vollständigen Eingaben, Abfragen, Sollwerte, beobachteten Werte,
Quellenzitate und OPA-Bindung der Entwicklungsproben.

## Gesicherte Befunde und Wirkung in der App

### Vertragsgültigkeit und Zahlungsantrag bleiben außerhalb der Gesamtentscheidung

`eligibility.rego:19` berechnet `contract_active`. `main.rego:28` verwendet diesen
Helfer nicht: Teilnahme und das Fehlen von sieben bestimmten Verstoß-IDs reichen
für einen positiven Zugangsflag. Fehlende Vertragsangaben erzeugen keinen
entsprechenden Verstoß. Ebenso berechnet `eligibility.rego:148` einen fehlenden
Zahlungsantrag, ohne ihn in `decision` oder `premium.net` zu berücksichtigen.

Ein neu aus den öffentlichen Quellen abgeleitetes Szenario mit einem gültigen
2025-Vertrag, rechtzeitigem Antrag, 2 ha Dauerweide und erfüllter Weiterbildung
ergibt im Jahr 2026 `access_conditions_met=true`, 54 Euro und keine Verstöße.
Folgende Änderungen lassen dieses Ergebnis unverändert:

- Vertragsbeginn und Antragsdatum beide entfernen;
- das Auswertungsjahr auf **2029** setzen;
- `payment_application_submitted=false` setzen, auch zusammen mit mehr als einem
  Jahr Verspätung.

Die Sonderrichtlinie, S. 13, § 1.7.1.2, begrenzt den Vertrag auf den
31.12.2028. S. 22, § 1.10.5.3, schließt die aktuelle Zahlung bei fehlendem
Zahlungsantrag ausdrücklich aus. Die App braucht daher getrennt erkennbare
Vertrags-, Vollständigkeits- und Zahlungsfolgen. Der native Betrag allein ist
hier kein hinreichendes Ergebnis.

### Eine ausdrücklich ausländische Fläche verdient einen Zuschlag

ATB S. 9, § 5.6: „Bewirtschaftete Flächen außerhalb von Österreich werden nicht
gefördert und können auch bei diversen Begrenzungen (z. B. Kulturartenanteil)
nicht berücksichtigt werden.“ Die Sonderrichtlinie bestätigt den Österreichbezug
auf S. 9, § 1.4.2.1.

`common.rego:39` und die folgenden Flächensummen filtern `in_austria` nicht.
`eligibility.rego:102` meldet die Auslandsfläche, behauptet dabei jedoch, sie werde
nicht berücksichtigt. Der Flächenfilter in `premium.rego:66` schützt die
Basismodulfläche, erreicht aber nicht alle Zuschlagsfunktionen.

Im Szenario `foreign_arable_area` werden der genannten 2-ha-Dauerweide-Basis
**10 ha Buchweizen mit `in_austria=false`** hinzugefügt. Die Ackerfläche steigt
von 0 auf 10 ha; Diversifikations- und DIV-Pflichten entstehen. Zugleich steigt
`premium.net` von **54 auf 702 Euro**, darunter **648 Euro FWK-Zuschlag**.
Dies ist ein konkreter Fehler der Flächen- und Zuschlagsberechnung. Die App muss
den gemeinsamen Flächenumfang vor allen abgeleiteten Prüfungen und Zahlungen
konsistent bilden.

### Der Förderwerber wird nur teilweise geprüft

ATB S. 4–5, § 5.2, verlangt eigenen Namen/eigene Rechnung,
Verfügungsgewalt, aktiven Landwirt und landwirtschaftliche Tätigkeit.
Sonderrichtlinie S. 8, § 1.4, erfasst außerdem mittelbaren sowie sonstigen
wirtschaftlichen oder organisatorischen öffentlichen Einfluss.

`eligibility.rego:70` prüft lediglich Rechtsform und direkte numerische
Beteiligung. Fehlende Angaben werden zu `natural_person` beziehungsweise 0
vorbelegt. Die zusätzlichen Voraussetzungen stehen teilweise im Regeltext,
haben aber weder die nötigen nativen Eingaben noch ausführbare Prüfungen.
Ein vorhandener Regelbezeichner ist hierfür kein Nachweis. Gleiches gilt für
Konditionalität und Kontrollverweigerung, die ausdrücklich nur katalogisiert
sind. Letztere führt nach SRL S. 23, § 1.11.1.2, zur Ablehnung und
Vertragsrückabwicklung.

### Bewirtschaftung und Historie sind nicht vollständig nachgewiesen

ATB S. 6, § 5.4, verlangt vollflächige Mahd mit Verbringung oder vollflächige
Beweidung. `general_conditions.rego:94` akzeptiert bereits ein einzelnes
passendes Ereignis, ohne einen Flächenumfang zu prüfen. Fehlende `use_events`
überspringen den Verstoß; ein ausdrücklich leeres Array erzeugt ihn.
Fehlender Ernteanteil wird in Zeile 81 mit **100 %** angesetzt.
Ordnungsgemäßer Anbau und Pflege sowie mehrere Anforderungen an Flächen im
geschützten Anbau bleiben ebenfalls offen.

Bei der Grünlanderhaltung stimmen die 1-ha-Grenze und die Grundrechnung bei
vollständigen Eingaben. Fehlendes Referenzobjekt überspringt jedoch die Prüfung;
fehlende Komponenten werden 0. Die auf UBB S. 4 ausdrücklich beschriebene
AMA-Bestätigung eines tatsächlichen Umbruchs vor Vertragsbeginn hat weder eine
eigene Eingabe noch einen entsprechenden Prüfzweig. Ein externer Aufbereiter
müsste diese Ausnahme bereits korrekt in die Summen eingerechnet haben.

### Die botanische Kulturidentität wird an die Eingabe delegiert

UBB S. 5, § 5.2: „Körnermais und Silomais gelten als eine Kultur“; auch Winter-
und Sommerform derselben botanischen Art werden zusammengefasst.
`general_obligations.rego:38` übernimmt ein frei eingegebenes
`botanical_species`-Label. Fehlt dieses, wird das konkrete Nutzungslabel
übernommen. Eine Vereinheitlichung der genannten Fälle, der Erstkultur oder des
Hauptanteils einer Mischung findet nicht statt. Die Kommentare beschreiben eine
externe Vorbedingung. Für die App braucht diese Vorverarbeitung einen belegten,
geprüften Vertrag; bloße Feldgleichheit reicht nicht.

### OP-Verfahren und errechnete Rechtsfolgen sind unvollständig verbunden

Der Profilvorschlag enthält `compliance.third_party_fault`, aber
`general_conditions.rego:136` verwendet diese Angabe nicht. Die Regel akzeptiert
OP oder Selbstanzeige unabhängig von der Ursache. ATB S. 8–9, § 5.5.2,
unterscheidet dagegen reines Fremdverschulden von eigener Nichterfüllung, bei der
der betroffene Code zu löschen oder Selbstanzeige einzubringen ist. Auch eine
tatsächliche Löschung wird vom Prüfzweig nicht kontrolliert.

Flächenzugangsgrenze, Rückzahlungsfläche, Austritt, wiederholte 100%-Kürzung und
einige weitere Folgen sind als Helfer vorhanden. Die Gesamtentscheidung und der
Nettobetrag wenden sie nicht vollständig an. Daraus folgt **nicht**, dass jeder
inhaltliche Verstoß automatisch eine Nullprämie verlangt: Schwere, Ausmaß,
Dauer und Häufigkeit bestimmen die Sanktionsstufe. Ebenso ist das Absehen von
einer Zahlung bis 50 Euro ausdrücklich eine Möglichkeit und keine zwingende
Nullsetzung. Die App muss den Berechnungsstand und noch nicht entschiedene
Rechtsfolgen kenntlich machen.

## Was tatsächlich funktioniert

**35 neu abgeleitete numerische Entwicklungsproben wurden ausgeführt; alle
35 liefern das aus den Originalquellen abgeleitete Ergebnis.** Geprüft sind
rechtzeitiger/verspäteter Antrag, 25%-Beteiligung, 0,50/1,50-ha-Mindestgröße,
1-ha-Grünlandtoleranz, 75% Getreide/Mais, 55% Kulturanteil, die Brache-Ausnahme ab
2025, 3 Stunden und Kurszeitfenster, 0,30 RGVE/ha, Abgangstoleranz 5%/5ha/0,50ha,
Flächenzugang 50%/mindestens5ha sowie Verwarnung und wiederholte Vollkürzung.

Diese Proben verwenden bewusst vollständige, passende native Eingaben und
interne Unterabfragen. Sie belegen die jeweilige Teilrechnung. Die acht
zusätzlichen Szenarien des Rechtsfolgenabgleichs prüfen dagegen die native
Gesamtentscheidung und zeigen die oben beschriebenen Lücken. Keiner dieser
Entwicklungsfälle ersetzt eine unabhängige fachliche Abnahme.

## Noch erforderliche Arbeit

Die Prüfung anderer UBB-Fachmodule und Tabellen muss mit dieser Prüfspur
zusammengeführt werden. Für eine spätere App-Übernahme sind ein expliziter
Eingabe- und Nachweisvertrag, ein konsistenter Flächenumfang, die botanische
Kulturzuordnung sowie sichtbar getrennte Vertrags-, Pflicht-, Zahlungs- und
Sanktionsfolgen nötig. Historische Run-Artefakte und das Canonical Farm Profile
bleiben unverändert; Reparaturen gehören in eine getrennte manuelle Adaptation.

Der historische Coverage-Text behauptet, SRL § 1.4–1.20 vollständig gelesen zu
haben, nennt aber S. 8 mit den Förderwerbervoraussetzungen nicht in
`pages_reviewed`. Die vorliegende Prüfung verwendet deshalb ihre eigene
Seitenzuordnung statt diese Selbstaussage als Abnahme zu übernehmen.
