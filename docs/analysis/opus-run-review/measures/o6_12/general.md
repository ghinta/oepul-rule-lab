# o6_12: allgemeine Voraussetzungen und Verfahren

Run `v2-o6_12-opus-5.5-high-20261009`, unveränderter Kandidat `e009eed4a83ff076b26eba33ac433ac2b0642621`. Die Prüfung gehört zum gemeinsamen Audit für Issue #112. Originale, Policy, Canonical Profile, App und gemeinsamer Collector wurden nicht geändert. Frühere GM-/Studienurteile, Adaptationen und generierte Selbsttests sind keine Sollquelle.

**62 historische IDs sind einzeln bewertet: 33 durch den Elternprüfer, 29 durch den unabhängigen Legal-Teilprüfer. 222 frische Kontrollen sind definiert: 196 erfüllt, 26 abgewichen, keine Laufzeitfehler oder undefinierten Ergebnisse.** Die 19 Befundgruppen und 17 Pflichtengruppen überlappen. Mehrere Auslöser betreffen dieselbe Lifecycle- bzw Fristauslegung; 26 abweichende Kontrollen sind keine 26 unabhängigen Defekte und keine Modellgenauigkeit.

[general.json](general.json) enthält alle Eingaben, Abfragen, Erwartungen, vollständigen nativen Beobachtungen und unmittelbaren Originalbelege. Zwölf Quellenkontrollen bleiben ausdrücklich nicht ausführbar. Zwei zusätzliche Normkontroll-Einträge und ein gesonderter Literalbeleg bewahren den Konflikt zur höheren Norm und die ergänzenden §-5-Fälle; ihre bereits enthaltenen Fälle werden nicht nochmals gezählt. Die gemeinsame Wiederholung und unabhängige Endabnahme liegen beim Root.

## Tatsächliche Lektüre und Quellenbindung

Das neue Merkblatt mit SHA256 `720df07d4aa2fcc42fc8f087ff9e32abdced5be950408c0292f7b3bcf48415b8` wurde auf allen vier Seiten persönlich vollständig gelesen: Kohorten, Erstjahresminimum, sämtliche Verpflichtungen und Ausnahmen, PSM-Codes, Antragstellung, Tarife, Aktualisierungen und Rechtsunverbindlichkeit. Alle sechs Rego-Module mit 1.063 Zeilen und alle 17 Rohannahmen einschließlich Konflikten, offenen Fragen und technischen Lektüregrenzen wurden vollständig gelesen.

Alle neun tatsächlichen Originalhashes sind bestätigt. Acht gemeinsame Originale werden nur unter identischem Hash und dokumentierter früherer Volllektüre wiederverwendet; aktuelle einschlägige Klauseln wurden erneut gelesen. Das bedeutet keine nachträgliche Behauptung, der historische Generator habe alle Anhänge vollständig gelesen: Seine eigene Annahme 17 nennt ausdrücklich nur die Suche in A–K und die Lektüre von L.

Die **tatsächlich beigefügte 94-seitige GSP-AV** hat SHA256 `d01dd8024d9575da1ec094506744c3aa7b43d1f8f17552a6aab62f422a755c10`. Anders als bei o6_10/o6_11 sind ihre Normkontrollen hier möglich. §5 und §242 Abs.7, §14, §§27/28/31, §§33/34 sowie §§46–48 wurden an den aktuellen entscheidenden Stellen rückgelesen. §48 betrifft die inhaltlichen Sanktionen, §51 die Junglandwirte. NAPV ist nicht beigefügt und wird nicht als Quelle beansprucht.

184 unterschiedliche gebundene Belegdatensätze wurden direkt im tatsächlichen Original bestätigt. Nur Leerraum und Soft Hyphen werden normalisiert, keine Unicode-Kompatibilitätsumformung; etwa `m²` bleibt erhalten. Entscheidende Alternativen stehen unmittelbar bei Fällen und Befunden, insbesondere Österreich für sonst maßgebliche Flächen, die qualifizierte Nationalparkausnahme und die echten Fristausnahmen.

## Konkrete Abweichungen und ihre Grenzen

| Gegenstand | Positiv festgelegte Quellfakten / Soll | Native Beobachtung |
| --- | --- | --- |
| Antragsöffnung | Einziger Antrag 31.10.2024 für Start 2025 liegt vor der gesetzlichen Novemberöffnung; Antrag 2021 liegt vor Programmanwendbarkeit | Beide gelten im Obergrenzenvergleich als rechtzeitig |
| Regulärer Vorjahresaustritt | Wirksam 2025 beendet, kein neuer Antrag | 2026 werden weiter 540 € geschätzt |
| Unwirksamer Austrittsversuch | Nach aktueller Kontrollankündigung tatsächlich abgelehnt; Pflichten und Jahresantrag laufen erfüllt weiter | Helfer erkennt Unwirksamkeit, Betrag wird trotzdem auf 0 gesperrt |
| Letzter Verpflichtungstag | Abmeldung 31.12.2028 entwertet das Förderjahr; bei Erfüllung bis Jahresende darf erst am 1.1.2029 abgemeldet werden | Kein Rückforderungsgrund wegen strikt `< 31.12.` |
| Verlust der Verfügung | Alle Maßnahmenweinflächen an anderen Betrieb verloren, `loss_of_control` ausdrücklich bekannt; andere eigene Ackerbewirtschaftung bleibt | Reguläre nötige Abmeldung erzeugt trotzdem Rückforderungsgrund |
| Historische Anwendung | Rechtmäßiger Einsatz 2022 vor Vertrag bzw nach wirksamem regulärem Ausstieg | Je ein Verstoß wird weiter gezählt |
| Ausland | Tatsächlich rechtmäßiger Einsatz auf ausländischer Weinfläche außerhalb des österreichischen Betriebs | Wird als Maßnahme-12-Verstoß gezählt |
| OP-Pflicht | Bekannte gleiche öffentliche Leistung bzw fehlende Ganzjahresfortführung, OP fehlt | Fläche wird korrekt gesperrt, aber Codierungspflicht nicht diagnostiziert |
| Aktuelle Fristen | Betriebsanzeige 2026: Vierwochenende Samstag 30.5. → Montag 1.6.; Übernahme 2028: Samstag 15.4./Ostermontag 17.4. → Dienstag 18.4. | Rohe 28 Tage bzw ATB-Literal 17.4. bleiben maßgeblich |
| FM-Frist 2026 | Samstag-/Sonntagsende 30./31.5. → 1.6.; Fronleichnam 4.6. → 5.6. | Genau 21 Tage ohne Fristverschiebung |
| Anerkannte höhere Gewalt | Kausale Verhinderung einer Kontrolle bzw anerkannter allein entschuldigter Ernteausfall / positive AMA-Jahresgewährung | Positive Ausnahmehelfer erreichen den Betrag nicht; 0 statt 540 € |
| Jährlicher Antrag / Vertragsende | Erster Jahresantrag fehlt trotz gültigem Maßnahmenantrag; tatsächlich unbehebene 2024-Säumnis oder wirksame Revision beendet 2026 die Verpflichtung | Erster Betrag 500 € bzw weiter 540 € |
| Heimfläche / Alm | Ausdrücklich ungefilterte 400 ha = 200 ha Heimfläche + 200 ha getrennte Alm | Heimfaktor 0,9375 statt 1 |
| Finale Obergrenze | Unabhängig endgültige, unverändert fortbestehende kompatible andere Zahlungen bereits 1.300 €/ha | Weiter nominelle Schätzung 540 € |

Historische Anwendungsfälle gelten ausdrücklich für einen Archivvertrag der Eingabe. Beschränkt ein vorgelagertes System die Liste bereits auf Anwendungen der aktuellen Verpflichtung, liegt dieser Gegenfall außerhalb jenes engeren Vertrags. Domain verweist seine vorvertragliche Kontrolle auf dieselbe zeitliche Familie.

Die FM-Geldfälle setzen tatsächliche Anerkennung, Kausalität, Förderfähigkeit vor dem Ereignis und positive AMA-Jahresgewährung ausdrücklich voraus. Diese Tatsachen folgen nicht aus bloßer Meldung oder einem Katalogtoken. Falls `control_refused` vorgelagert ausschließlich rechtlich unentschuldigte Verweigerungen enthält, ist der anerkannte Verhinderungsfall außerhalb dieses engeren Feldvertrags. Unbekannte Anerkennung wird nicht erfunden.

Der erste fehlende Jahresantrag benutzt die Schlagzuordnung ausdrücklich als Entwurf bzw Verpflichtungszuordnung. Ein Export ausschließlich bereits eingereichter Jahresanträge ist ein engerer Vertrag. Beim alten versäumten Antrag ist die tatsächlich seit 2024 unbehobene Säumnis 2026 positiv festgelegt. Das Flag `payment_application_missing_over_one_year` erzeugt nativ einen **Rückforderungsgrund, keinen aktuellen Betragsschalter**.

Heim-/Alm- und Obergrenzenfälle sind ebenfalls bedingt. Ein bereits reines Heimtotal beseitigt den betreffenden Modulationsgegenfall. Bei der Obergrenze wird keine Zuteilungspriorität zwischen offenen Bruttoanträgen erfunden: Genau 0 folgt nur bei der unabhängig finalen unveränderten anderen Förderung. Annahmen 11/12 und der Schätzcharakter werden ausdrücklich gewürdigt; nominale Überschreitungsdiagnose ist keine abschließende Auszahlung.

## Erhaltene zusätzliche Normkontrollen

§5 Abs.1 verschiebt Fristen auf den nächsten Arbeitstag; die Ausnahmen des Abs.2 umfassen weder die hier geprüfte Übernahmefrist noch Betriebsübertragung oder §6-FM-Meldung. §242 Abs.7 setzt die neue Fassung erst 2026 in Kraft. Die gesetzlichen Kontrollen werden deshalb ausschließlich für 2026 bzw 2028 unter der tatsächlich beigefügten aktuellen Fassung geführt, **nicht rückwirkend für Anträge 2023/2024**. Unbekannte spätere Rechtsänderungen werden nicht behauptet.

Die bekannten Kalenderfakten sind ausdrücklich gebunden: Ostersonntag 16.4.2028, österreichischer Ostermontag 17.4., nächster Arbeitstag 18.4.; Fronleichnam 4.6.2026. Der ATB-Literal 17.4.2028 bleibt daneben dokumentiert. Weder er noch ältere rohe 21-/28-Tage-Kontrollen ersetzen die zusätzliche geltende Norm. Auch der negative Fall nach verlängerter Frist bleibt erhalten.

**A01 ist ein tatsächlicher Konflikt im beigefügten Paket.** GSP-PDF25, §34 Abs.2 Z12 lit.f, verlangt für 70-10 auf Obst/Hopfen/Wein die Angabe, ob und welche Art Pflanzenschutzmittel verwendet wird. Merkblatt-PDF3 erklärt ab 2026 jede PSM-Erfassung für entfallen. §242 Abs.7 ändert bei §34 nur Abs.1 Z2, hebt diese lit.f nicht auf. ATB2 stellt die rechtliche Verbindlichkeit der Rechtsgrundlagen klar.

Die höhere Norm nennt jedoch keine konkreten GIS-Codenamen. Deshalb wird aus §34 allein kein erfundener `PSMCSI`-Sollwert abgeleitet. Die Domain-Kontrollen der historischen MB-Priorität bleiben qualifiziert erhalten; daneben steht die gesonderte Normkonfliktkontrolle. Eine mögliche spätere, nicht beigefügte Rechtsänderung oder ein abweichender eAMA-Vollzug wird nicht unterstellt und nicht als gelesen behauptet.

## Tatsächlich funktionierende Verbraucher

Maßnahme 12 ist mehrjährig bis ausdrücklich 31.12.2028. Die ursprünglichen Kohorten 2023/2024/2025 mit sechs/fünf/vier Jahren und die tatsächlichen Zeit-/Zahlungsgates funktionieren. **`contract_established` bezeichnet historische Vertragsbildung**; sein Fortbestehen nach Ende ist kein aus o6_11 importierter aktueller Statusfehler.

Die allgemeine Betriebsgröße wird nur im ersten ÖPUL-Jahr verlangt. Die Erstjahresmindestteilnahme ist zeitlich getrennt; aktuelle kleine Fläche nach tatsächlich erfülltem Erstjahr bleibt möglich. Ausland wird diesmal korrekt aus Mindestteilnahme und Prämie genommen. Große gewöhnliche Zugänge sind nicht mit der 50%-Übernahmegrenze verwechselt; Rückgang von 100 auf 2 ha erzeugt bei jährlich variablen Flächen keine pauschale 5%-Rückforderung.

Rechtsformen, qualifizierte Anteilsschwelle und bekannte persönliche Negativvoraussetzungen sind echte Zugangsgates. Bekannte Pflege-/Erntefehler, unzulässige Nutzungen, OP und genau maßnahmenspezifischer Ausschluss, konkrete Parks, GLÖZ, Hauptnutzung, Vegetationstage, VF und 50-m²-Grenze filtern tatsächlich. Nichtlandwirtschaftliche Tage sind laut tatsächlichem Proposal bereits auf die Vegetationsperiode beschränkt; ein falscher Winter-Gegenfall wird nicht konstruiert.

Tatsächlich vorbewertete Sanktionsstufen, 2027-Warnersatz, Addition/Deckelung und vorbereitete Wiederholungen wirken. Ein periodenweit korrekt vorbereiteter `previous_full_reductions`-Zähler funktioniert: Kommentar/ATB-Vertragszeitraum gegenüber §48-Förderperiode allein begründet keinen zusätzlichen Rechenfehler. Der Input muss dieselbe Maßnahme/Verpflichtung/Förderperiode und die Rückforderung nur der im Ausschlussjahr beantragten Flächen sauber binden.

75%-Maximum, 50-Euro-Kann-Regel, Zahlungsdatumsmetadaten sowie homogene Übererklärungsgrenzen funktionieren als abgegrenzte Komponenten. Die vollständige elfteilige Kürzungsfolge und echte Behördenentscheidung werden dadurch nicht ersetzt. **Root besitzt `OUTPUT_SCOPE`**; kein lokaler Pflichtverstoß wird hier ohne Bewertung zu einer beliebigen 100%-Sanktion.

## Verbleibende Darstellung und QA

Übernahmeantrag, laufender Ursprung und tatsächlich genehmigter neuer Restlaufzeitvertrag benötigen eine eigenständige Vertragsgrundlage. Der vorhandene Datums-/Flächen-/Negativgenehmigungshelfer ist wirkliche Teilprüfung, keine vollständige Genehmigung. Bei negativen Verfahrenskomponenten wird keine widersprüchlich positive AMA-Zustimmung vorausgesetzt.

Verfügung am 1. April, Identifikation/Referenz, gleichwertiger öffentlicher Einfluss, schriftliche Versuchsgenehmigung, Fremdschadensnachweise/Selbstanzeige, nichtlandwirtschaftliche Vorabmeldung und Betriebsanzeigequalifikationen sind nicht vollständig erfasst. §14 verlangt auch Anzeige vor nächster Antragstellung und kennt die nicht beeinflussbare Verzögerungsausnahme. Datumswerte ohne Uhrzeit beweisen keine Reihenfolge am selben Kontrolltag. Diese Grenzen bleiben ausdrücklich offen.

Vor dem Einfrieren wurden alle 102 endgültigen Elternfälle erneut ausgeführt; der Legal-Teilprüfer führte seine 120 Fälle separat aus. Zusammen wurden **12.698 vorhandene primitive Blattwerte und 1.903 explizite Enumwerte** gegen unveränderte Canonical plus die tatsächlichen 24 Vorschläge geprüft: keine Typ-/Datums-/Enumabweichung und kein unverwalteter Pfad. Der gemeinsame Strukturaufbau löst den im separaten Legal-Prüfer noch transparent unbekannten reinen `oepul`-Container auf. Abwesende Pflichtangaben, reale Faktenwahrheit und Behördenbewilligung werden damit nicht pauschal zertifiziert.

Die eingefrorenen Legal-Teilbindungen, Quellen- und Code-QA, sämtliche Konstruktionskorrekturen und überlappenden Familien stehen im JSON. Kein nächster Run ist Teil dieser Prüfung.

General-JSON SHA256: `0e8f1227c3a40162860ab502ab7c2377750e69d45d79d2e21fbf21572d668d39`.
