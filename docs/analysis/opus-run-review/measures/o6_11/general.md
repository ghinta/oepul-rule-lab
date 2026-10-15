# o6_11: allgemeine Voraussetzungen und Verfahren

Historischer Run `v2-o6_11-opus-5.5-high-20261001`, unveränderter Kandidat `e009eed4a83ff076b26eba33ac433ac2b0642621`. Die Prüfung gehört zum gemeinsamen Audit für Issue #112. Originalquellen, Policy, Canonical Profile und App wurden nicht geändert. Frühere GM-/Studienurteile, manuelle Adaptationen und generierte Selbsttests sind keine Sollquelle.

**52 historische IDs sind einzeln bewertet: 34 durch den Elternprüfer, 18 durch den unabhängigen Legal-Teilprüfer. 162 neue Kontrollen sind definiert: 148 erfüllt, 14 abgewichen, keine Laufzeitfehler oder undefinierten Ergebnisse.** Eine der 14 Abweichungen ist ausdrücklich eine gesonderte positive Evidenz-/Eingabevertragskontrolle, keine bewiesene tatsächliche Nichtbeantragung. Die gezielten öffentlichen Fälle sind keine Modellgenauigkeitsstichprobe und keine Expertenabnahme. 16 Befundgruppen und 15 Pflichtgruppen überlappen; insbesondere belegen mehrere Auslöser dieselbe Vertragsstatuslücke.

Alle Inputs, Abfragen, Erwartungen, vollständigen nativen Beobachtungen und unmittelbaren Originalbelege stehen in [general.json](general.json). Gemeinsamer Replay und unabhängige Endabnahme des gesamten Runs liegen beim Root.

## Quellen und tatsächliche Lektüre

Das neue Merkblatt, Hash `3cbe2c5c271afcc4045eb56658d3457227087dc9e9402cf1b5ba640e1a1f7556`, wurde auf allen vier Seiten persönlich vollständig gelesen: Laufzeittabelle, Erstjahresminimum, Herbizidumfang, PSM-Regeln, Kauf-/Lagerausnahme, Kombinationen, Tarife, Aktualisierungen und Rechtsunverbindlichkeit. Sämtliche sechs aktuellen Rego-Module mit 1.199 Zeilen sowie alle 19 nummerierten Rohannahmen einschließlich Quellenrangfolge, 2026- und Technikhinweisen wurden vollständig gelesen.

Alle acht tatsächlichen Originalhashes sind bestätigt. Sieben identische gemeinsame Originale binden die dokumentierte frühere Volllektüre. Die einschlägigen aktuellen ATB-/SRL-Seiten wurden erneut vollständig gegen die aktuellen Verbraucher gelesen, ebenso die vier Mitteilungen durch den Elternprüfer; der Legal-Teilprüfer bindet zusätzlich seine eigenen erneuten Seiten-/Klausellektüren. Für Anhang L wird hier keine neue General-Zellenrekonstruktion behauptet; aktuelle Maßnahmenkombinationen und Tabellen haben eigene Prüfteile.

142 gebundene Belegdatensätze wurden im tatsächlichen Original geprüft. Normalisiert werden nur Leerraum und Soft Hyphen, keine Unicode-Kompatibilitätsumformung; hochgestellte Zeichen bleiben erhalten. Entscheidende Alternativen und Ausnahmen stehen direkt an den jeweiligen Regeln, Fällen und Befunden, beispielsweise die qualifizierte Nationalparkausnahme, Österreich für sonst maßgebliche Flächen und die konkrete Erstjahresmindestteilnahme.

Das tatsächliche Paket enthält **keine GSP-AV und keine NAPV**. Die in Run o6_9 vorhandene GSP-Datei wird hier nicht nachträglich zugerechnet. Verweise in ATB/SRL ersetzen das fehlende Original nicht. Insbesondere bleiben Detailfragen zu Anerkennung, Sanktionen und gesetzlichen Fristen von externen Normen abhängig. Der ATB-Wert 17. April 2028 für Übernahmen ist ausdrücklich nur ein beigefügter Quellenliteral; eine neuere Feiertags-/Fristregel wird nicht heimlich zum Solloracle.

## Konkrete Abweichungen

| Komponente | Positiv festgelegte Tatsachen und Erwartung | Native Beobachtung |
| --- | --- | --- |
| Auslandsumfang | Eine tatsächlich ausländische Weinfläche gehört nicht zum österreichischen Betrieb; dort rechtmäßige Behandlung erzeugt keine Verletzung von Maßnahme 11 | Ein Herbizidverstoß wird gezählt |
| Erstjahresmindestteilnahme | 0,40 ha österreichischer Wein + 0,10 ha Auslandswein; zusätzliche 1,50 ha österreichischer Acker erfüllen die allgemeine Betriebsgröße unabhängig. Maßgeblich bleiben 0,40 ha, Zugang fehlt | Summe 0,50 ha und kein Zugangsfehler |
| Definitiv abgelaufener Vertrag | Original nennt ausdrücklich Ende 31.12.2028; im Jahr 2029 besteht kein aktueller Vertrag | `contract_valid=true`, Zahlung korrekt 0 |
| Wirksamer Ausstieg | Zulässige wirksame Abmeldung 2026 beendet aktuelle Gültigkeit | `contract_valid=true`, Zahlung korrekt 0 |
| Überfälliger Altantrag | Tatsächlich nicht nachgeholter Zahlungsantrag 2024 ist 2026 über ein Jahr offen; Verpflichtung ist beendet, kein neuer Vertrag | Beendigungshelfer `true`, Vertragsstatus zugleich `true` |
| Einziger Antrag vor Programmanwendbarkeit | Nur Antrag 2021, kein neuer Antrag/keine Übernahme; SRL gilt für ab 2.11.2022 gestellte Anträge und begründete Verpflichtungen | Reiner Obergrenzenvergleich bestätigt Vertrag ab vorgeschlagenem Start 2023 |
| Endgültige andere Förderung | Andere unabhängig endgültige, unverändert fortbestehende Förderung bereits 1.300 €/ha; kein weiterer Betrag innerhalb derselben festen Summenobergrenze | Eigene Zahlung bleibt 447,13 € für 2 ha |
| Heimfläche und Alm | Ungefilterte 400 ha bestehen ausdrücklich aus 200 ha Heimfläche und 200 ha separat behandelter Alm; Heimflächenfaktor muss 1 sein | Faktor 0,9375 |
| Weiterlaufender vorübergehender Umstand | Eintritt 2025, tatsächliche Nichterfüllung dauert 2026 fort; Quelle knüpft an das Jahr der Nichterfüllung | Ereignis wird wegen abweichendem Eintrittsjahr nicht gesperrt |
| Betroffene Fläche | Dauerhafter bzw vorübergehender anerkannter Sachverhalt betrifft nur einen von zwei 1-ha-Schlägen; der unbetroffene erfüllende Schlag behält 270 € | Beide Fälle werden global auf 0 gesetzt |
| Erster Jahresantrag | Separater gültiger Maßnahmenantrag 2022, aber tatsächlicher erster MFA/Zahlungsantrag samt ergänzenden Angaben 2023 nicht eingereicht; Parzellenzuordnung bezeichnet ausdrücklich nur Entwurf | Vertrag, Prämienjahr und 500 € werden bestätigt |
| Fehlender Schlagnachweis | Tatsächliche Beantragung ist unbekannt. Unter dem separat erklärten positiven Evidenzvertrag entsteht daraus keine Freigabe | Fehlende Liste wird durch Annahme 16 zu positiver Beantragung 11 |

Die letzte Zeile ist **keine normative Feststellung, dass der reale Schlag nicht beantragt wurde**. Die Quelle verlangt tatsächliche Angaben; sie schreibt nicht selbst eine boolesche Regel `unknown=false` vor. Diese eine Kontrolle prüft den ausdrücklich erklärten Autorisierungs-/Evidenzvertrag. Historische Annahme 16 definiert den günstigen Ersatzwert offen. Fehlende Evidenz und erwiesener landwirtschaftlicher Verstoß bleiben getrennt.

CAP, Heim-/Alm-Gesamtsumme und der erste nicht eingereichte Jahresantrag sind bedingte Eingabevertragsfälle. Wird die andere Förderung gleichzeitig neu verteilt, ist die Gesamtsumme schon reine Heimfläche oder enthält die Parzellenliste ausschließlich bereits eingereichte Jahresanträge, folgt daraus dieser jeweilige Gegenfall nicht. Die genaue Bedeutung ist unmittelbar am Fall festgelegt. Für gleichzeitige Bruttoanträge wird keine frei erfundene Kürzungspriorität behauptet.

Bei besonderen Umständen sind der betroffene und der unbetroffene Schlag sowie tatsächliche fortdauernde Nichterfüllung ausdrücklich festgelegt. Das fehlende Feld für betroffene Fläche wird offengelegt. Weder wird aus einem bloßen Ereignisnamen eine behördliche Anerkennung abgeleitet noch ein beliebiger Bewirtschaftungsfehler mit einer erfundenen 100%-Sanktion gleichgesetzt.

## Tatsächlich funktionierende Verbraucher

Maßnahme 11 ist hier **mehrjährig bis 2028**, mit ursprünglichen Starts 2023/2024/2025 und sechs/fünf/vier Jahren. Die aktuellen Zeitbereichs- und Zahlungsgates funktionieren. Anders als beim vorigen jährlichen Run verlangt die Maßnahme 0,50 ha nur im ersten Teilnahmejahr. Der Fall mit ursprünglich erfülltem Erstjahr und aktuellen 0,10 ha erhält deshalb zu Recht die aktuelle Betragskomponente. Auch die allgemeine Betriebsgröße gilt nur im ersten ÖPUL-Jahr.

Rechtsformen, korrekt qualifizierte öffentliche Beteiligung, bekannte öffentliche Einrichtung und bekannte fehlende persönliche Voraussetzungen sind echte Zugangskontrollen. Maßnahme 11 übernimmt keine öffentliche Ausnahme anderer Maßnahmen. Fehlende Dauerkulturpflege, tatsächliche Nichtaktivität, Reb-/Baumschule, sonstige Nutzung, GLÖZ, benannte Parkausschlüsse und bekannte Auslandslage filtern tatsächlich die betroffene Prämie.

OP, genau maßnahmenspezifischer Ausschluss sowie alle sieben vorhandenen qualifizierten OP-Fälle sind echte Filter; beim tatsächlich feststehenden Pflichtfall wird zusätzlich fehlender Code diagnostiziert. Eine kompatible echte Teilnahme an Maßnahme 12 mit ausschließlich dortigem Ausschluss entwertet die Prämie 11 nicht. Ein österreichischer nicht einzeln beantragter Weinschlag bleibt im gesamtbetrieblichen Herbizidverzicht; bloße Prämienfreiheit beendet diese Pflicht nicht.

Die jährliche Flächenflexibilität ist real konsumiert. Ein Rückgang von 100 auf 2 ha löst deshalb keine pauschale 5%-Rückforderung für Maßnahme 11 aus. Gewöhnliche verfügbare Zugänge von 1 auf 20 ha sind nicht der separaten 50%-Übernahmegrenze unterworfen. Die allgemeine Abgangsformel ist ein Informationshelfer, ihr Rückzahlungszweig greift für die ausdrücklich flexible Maßnahme nicht.

Bewertete einzelne Sanktionsstufen und Warnung 0% bis 2026 bzw 1% ab 2027 werden angewandt. Der direkte Leistungsüberschneidungsfilter funktioniert. Kontrollverweigerung besitzt jetzt eine ausdrücklich repräsentierte anerkannte Ausnahme höherer Gewalt, die tatsächlich berücksichtigt wird. Später fehlender Zahlungsantrag blockiert Zahlung wirklich. Die 50-Euro-Klausel bleibt eine Kann-Bestimmung; die 75%-Teilzahlung ist eine Obergrenze, keine automatisch freigegebene Zahlung.

## Verbleibende Grenzen

Der Übernahmehelfer prüft Datum, bisherige Nichtteilnahme und 50%-Erweiterung. Er erteilt keine AMA-Genehmigung und erzeugt keine eigenständige neue Vertragsgrundlage für die Restlaufzeit nach letztem regulärem Einstieg. Genehmigter Ursprung, eingereichter Antrag und neue Übernahmegrundlage müssen getrennt repräsentiert werden. Eine unbekannte Entscheidung wird in den Kontrollen weder erteilt noch verweigert.

Kontrollankündigung/-durchführung und Verwaltungsmitteilung als Austrittsgrenze, neue Verträge nach historischer Unterbrechung, Nachfolge und Solidarhaftung, tatsächliche Selbstanzeige, Fremdschadensnachweise sowie Versuchsgenehmigung haben keine vollständigen Ereignisverbraucher. Qualifizierte Vorgaben wie `op_cases` werden als solche gewürdigt und ersetzen den dahinterliegenden Nachweis nicht.

Der Meldungshelfer `circumstance_repayment_waived` wird tatsächlich nur zur Negativliste ungemeldeter Umstände und deren Hinweis verwendet. Er kann deshalb als Meldevoraussetzung abgegrenzt werden; sein Name allein belegt keine fehlerhafte echte AMA-Waiverentscheidung. Die entsprechende freie behördliche Entscheidung bleibt unrepräsentiert. Konditionalität und die elfzeilige Kürzungsreihenfolge sind ebenfalls kein vollständiger behördlicher Bewertungs-, Rückforderungs- und Auszahlungsprozess.

Die vier 2026-Mitteilungen begründen keine automatische Herbizidausnahme oder rückzahlungsfreien freiwilligen Ausstieg aus Maßnahme 11. Rebzikade betrifft Maßnahme 12; die August-Ernteausnahme qualifizierte Ackerkulturen. Individuelle höhere Gewalt bleibt ein anderer Anerkennungsweg.

**Root besitzt `OUTPUT_SCOPE`** für die übergreifende Trennung von Verpflichtungsverletzung, nominalem Betrag, tatsächlich gegatetem Betrag und behördlicher Bewertung. Der hier korrekte Zahlbetrag 0 nach Vertragsende heilt den zugleich falschen aktuellen Vertragsstatus nicht; umgekehrt wird aus einer fehlenden Sanktionsentscheidung kein frei gewählter Komplettabzug.

## Konstruktions- und Typkontrollen

Alle 105 Elternfälle wurden nach der endgültigen Konstruktion vollständig erneut ausgeführt, die 57 Legal-Fälle separat ebenfalls. Vor dem Einfrieren wurden alle 162 Inputs gemeinsam gegen unverändertes Canonical Profile plus tatsächliche Vorschläge dieses Runs geprüft: **7.634 vorhandene primitive Blattwerte und 1.044 explizite Enum-Werte ohne Abweichung**, keine unverwalteten Pfade. Fehlende Pflichtangaben, vollständige Tatsachenwahrheit und tatsächliche behördliche Genehmigung sind dadurch nicht pauschal zertifiziert.

Die eigenständige Legal-Unterprüfung ist über ihre eingefrorenen SHA256-Bindungen im General-JSON erhalten. Unterschiedliche Auslöser derselben aktuellen Vertragsstatuslücke werden als überlappende Familie behandelt. Keine Probe, Beobachtung oder Regel des nächsten Runs ist Teil dieser Prüfung.

General-JSON SHA256: `06d396afed8a1cde61abc0a1065a65eb01f33ed6a3d1647c9d328c267447c5ef`.
