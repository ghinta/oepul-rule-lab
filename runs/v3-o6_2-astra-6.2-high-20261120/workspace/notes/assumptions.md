# Auslegung zu o6_2

## Betriebsjahr und Prämienberechnung

Das Förderjahr steht in `farm.year`. Der reguläre Ersteinstieg, die Übernahme eines bestehenden Vertrags und der Wechsel zu BIO haben eigene Fristen. Die Übernahme kann auch nach 2025 erfolgen. Für einen unterjährigen Strukturwechsel muss der aus der Rinderdatenbank übernommene Durchschnitt die Zuordnung ab dem Wechseltag bereits enthalten.

`data.oepul.o6_2.base_rates` liefert den Jahrestarif je Schlag. `parcel_exclusions` nennt einzeln festgestellte Ausschlussgründe. `amount_before_adjustments` multipliziert für den beantragten inländischen Schlag die bereits festgestellten förderfähigen Hektar mit dem Tarif. Das Ergebnis ist ein Betrag vor Modulation, Obergrenzen und Sanktionen. Für eine abschließende Auszahlung sind insbesondere andere Schlagzahlungen, Verwaltungskontrollen und Feststellungen der AMA maßgeblich. Die Sonderrichtlinie legt die Reihenfolge der Kürzungen fest. Die Zuteilung eines behördlichen Gesamtabzugs auf einzelne Schläge lässt sich aus den vorliegenden Quellen allein nicht eindeutig bestimmen.

Bei `land.commitment.new_ha` ist ab 2026 die gesamte im betrachteten Jahr vorhandene Ausweitung gegenüber der Basis 2025 einzugeben. Ein jährlich neu verbrauchbarer Freibetrag würde den zulässigen Zugang über die Laufzeit erhöhen. Bereits vorher mit derselben Verpflichtung belegte Flächen werden gesondert erfasst. `relevant_loss_ha` enthält die nach Abzug anerkannter Ausnahmen verbleibende Jahresdifferenz.

## Flächen- und Tierbestände

`mfa.declared` bezeichnet die Beantragung im MFA einschließlich anderer Maßnahmen. `mfa.claimed_o6_2` bezeichnet die Beantragung für die Maßnahme 2. Der Standort des Schlags bestimmt die Dürrekulisse. Bei Antragstellung für eine Futter-Zweitkultur bezeichnet `crop_name` diese Schlagnutzung und `is_second_crop` ihre Stellung. Für den Nenner ist derselbe physische Schlag nur einmal zu zählen. Der PSM-Einsatz ist der tatsächlich behandelten Kultur zuzuordnen.

Bei null Hektar Futterfläche bleibt die RGVE-Dichte offen. Der Ackertarif und der Tarif für Wein, Obst und Hopfen können dennoch ermittelt werden. Für die Tierhaltereigenschaft wird vor der Einstufung gegen 0,30 und 1,40 kein fachlicher Rundungsschritt angenommen.

Tiergruppen bilden jeweils eine Art, Alters-, Rassen- und Bestandskategorie ab. Die Altersgrenzen sind in Monaten ausgedrückt. Die kleine Equidengruppe setzt beide Rassengrenzen voraus. Für andere Wildhuftiere folgt die Berechnung der ausdrücklichen Tabelle in Kapitel 8 und der Fußnote ** in Anhang A. Die Kurzbeschreibung in Kapitel 4 zählt weniger Wildarten auf. Die Schweinezeilen des Anhangs weisen allgemeine GVE aus.

Die Anerkennung von Obstzüchtungen, Brombeerkreuzungen und weiteren Schalenfrüchten erfordert eine fachliche Zuordnung zur veröffentlichten Kulturgruppe. Für die Einstufung gelten die Bezeichnungen in der Obstliste. Bei Walnüssen ist die Erfassung der Kultur von der Beurteilung der Pflanzgutqualität zu unterscheiden. Die Ausnahme für die LSE-Option Streuobstbäume betrifft eine andere Abgeltung.

## Betriebsmittel und Weiterbildung

Der Stickstoffanfall wird aus der inländischen Tierhaltung im Kalenderjahr vor Stall- und Lagerverlusten abgeleitet. Die Eingabemengen für Verluste und anteiligen Anfall auf Almen/Gemeinschaftsweiden müssen überschneidungsfrei sein. Die Quellen geben keine tierartspezifischen N-Anfallskoeffizienten vor. Bei Biogasgülle sind Liefer- und Rücklauf in derselben fachlich vergleichbaren Mengeneinheit zu erfassen. Ein Umrechnungsverfahren für abweichende Konzentrationen ist in den Quellen nicht vorgegeben.

`fertilizer_status` verwendet deutsche Mittelklassen, etwa `Einzel-/Mehrnährstoffdünger`, `Sonstiger Dünger`, `Biogasgülle` und `Anderer organischer Rückstand`. Die fünf im Merkblatt genannten Beispiele können auch einzeln angegeben werden. Produktrechtliche Eigenschaften wie die Zulässigkeit aller Wirkstoffe nach VO (EU) 2018/848, die BAES-Zulassung für die betreffende Anwendung und die Anerkennung eines Bildungsanbieters sind zum maßgeblichen Zeitpunkt zu bestimmen.

Kapitel 5.3 bezeichnet Saatgutbeizung auf Grünland und Ackerfutter ausdrücklich als flächig und unzulässig. Diese spezielle Aussage wird auch bei gesetztem Bio-Merkmal angewandt. Die SRL formuliert die allgemeine Wirkstoffausnahme ohne gesonderten Beizfall. Bei der Beurteilung eines konkret im Biolandbau zugelassenen Beizmittels sollte die fachliche Auslegung bestätigt werden. Eine PSMCS-Meldung in den Jahren bis 2025 erfüllt gegebenenfalls die Meldepflicht, legalisiert aber keine verbotene Anwendung.

Kursstunden werden je Person und unterscheidbarer Veranstaltung angerechnet. Verschiedene Personen erreichen die Dreistundenschwelle jeweils für sich. Bei Ausscheiden genau am 31. Dezember 2025 unterscheidet das Merkblatt nur die Fälle vor und nach diesem Datum. Sofern die Erfüllung von diesem Grenzfall abhängt, weist die Policy ihn zur Einzelfallprüfung aus. Die UBB-Biodiversitätsstunden benötigen eine gesonderte Anerkennung ohne Doppelanrechnung.

## Querverweise und Nachweisgrenzen

Die Kombinationstabelle aus Anhang L enthält 21 Zeilen mit je 21 Spalten. Leere Fremdzellen stehen für eine ausgeschlossene Einzelflächenkombination. Die Diagonale bildet die leeren Zellen des Originals ab. Bei Kombination mit Maßnahme 16 betrifft der Abschlag deren Basisprämie. UBB-Anforderungen und Dürreerleichterungen sind mit ihrem eigenen räumlichen und sachlichen Geltungsbereich erfasst. Die Bestätigung zur Maßnahme 18 oder 19 kann auf einem DIV-Schlag eigene Nutzungsauflagen vorgeben. Aus dem Rebzikadenhinweis ergibt sich ein Ausstiegstatbestand ausschließlich für Maßnahme 12.

Für DIVSZ nennt der Mai-Hinweis eine bezirksabhängige Vorverlegung von vier bis sieben Tagen sowie ein konkretes Beispiel für Tirol und Vorarlberg. Die vollständige phänologische Bezirkskarte liegt dem Run nicht bei. Bei der Dürre-Ernteausnahme sind dagegen die Gebietskulissen beider August-Hinweise als Daten erfasst. Die Jahresprüfung berücksichtigt die am 12. August ergänzten steirischen Bezirke.

Fehlende Tierbestände, Futterflächen oder Betriebsmitteldetails können eine Berechnung offenlassen. Ein leeres Set festgestellter Verstöße belegt bei fehlenden Eingaben keine umfassende Einhaltung. Bei gleichem Datum von Abmeldung und Kontrollankündigung ist die tatsächliche zeitliche Reihenfolge aufzuklären. Bei Ermessenstatbeständen wie Kleinbeträgen, höherer Gewalt, Nachfristen oder beantragten Maßnahmenübernahmen ist die Feststellung der zuständigen Stelle maßgeblich.
