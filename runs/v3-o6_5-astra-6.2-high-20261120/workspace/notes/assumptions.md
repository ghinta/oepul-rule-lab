# Auslegung für Maßnahme 5

## Geltungs- und Zeitbezug

Die Sonderrichtlinie vom 11. Oktober 2024 liefert die rechtlichen Kriterien, das Maßnahmenblatt vom Oktober 2025 die Vollzugshinweise und die historischen Tarife für 2023. Das allgemeine Blatt hat Stand April 2026. Für das Antragsjahr 2026 gilt zusätzlich die österreichweite Mitteilung vom 12. August. Die vier HTML-Quellen sind über einzelne Absätze des jeweiligen datierten Artikels erschlossen. Teaser zu anderen Meldungen gehören zur Seitennavigation.

Die Haltedauer endet regulär am 31. Dezember und 2026 am 31. August, jeweils einschließlich. Ein Abgang an diesem letzten Tag fällt noch in die Haltedauer. Ab dem Folgetag ist die Halteauflage erfüllt. Die Bewegungsmeldungen laufen 2026 bis Jahresende weiter. Für einen Abgang bis 31. August setzt die Policy weiterhin die Fünfwochenfrist an, auch wenn die Nachbesetzung erst im September erfolgt. Der Hinweis befreit ausdrücklich von der *Meldung* der Nachbesetzung nach dem 31. August. Diese Auslegung betrifft die Regeln `haltung-2026`, `bewegung-2026`, `ersatzmeldung-2026` und `nachbesetzung`.

Sieben Kalendertage werden als spätester Ereignistag plus sieben Tage berechnet. Für die Fünfwochenfrist bestätigt das Beispiel mit Schlachtung am 20. Dezember und Nachbesetzung bis 24. Jänner die Berechnung über die Jahresgrenze. Monatsfristen verwenden Kalendermonate. Fehlt der entsprechende Tag im Zielmonat, gilt dessen letzter Tag. Bei belegten Abwesenheiten ist die Rückkehr der erste Tag zurück am Betrieb. Eine Meldung vor der Weitergabe kann am selben Kalendertag erfolgt sein. Dafür wird der belegte zeitliche Vorrang erfasst.

## Tier und Förderposition

Eine Förderposition enthält das am 1. April beantragte oder aus der Rinderdatenbank ermittelte Tier und danach seine tatsächlichen Ersatztiere in zeitlicher Reihenfolge. `beginn` ist der Beginn der Haltung beziehungsweise der tatsächliche Nachbesetzungstag. `abgang` ist der erste Tag des dauerhaften Abgangs. Ein ausdrücklich leeres Abgangsdatum zusammen mit `beurteilt_bis` belegt die weiterlaufende Haltung bis zum dokumentierten Prüfstand. Vorübergehende Aufenthalte werden eigens erfasst. Jedes Tier benötigt eine eindeutige Identität. Ersatztiere erhöhen die Zahl der Förderpositionen nicht.

Für Ersatztiere sind die Kategoriebedingungen ab dem tatsächlichen Nachbesetzungstag zu erfüllen. Das gilt auch für ein erst nach Jahresende zugegangenes Tier. Die Abrechnung der Position verwendet das ursprüngliche Förderjahr. Die Bestätigung muss durch den zuständigen Verband bis 10. Februar des Folgejahres vorliegen. Für Rinder dokumentiert der Registereintrag den Ersatz. Die Schreibweisen „Rinderzucht Steiermark eG“ im Maßnahmenblatt und „Rinderzucht Steiermark eGen“ in Anhang D bezeichnen hier denselben Verband.

Bei weiblichen Tieren erfasst `geburten` die chronologische Folge eigener, zur Kategorie gehörender Geburten bis zum belegten Beurteilungstag. Für Stuten umfasst die Prüfung sowohl abgeschlossene Abfohlungsintervalle als auch die laufende Frist bis zu diesem Tag. Für Hengste über fünf Jahre wird das Datum der Registrierung eines lebend geborenen Nachkommens im Zuchtbuch verwendet. Die Zweijahresgrenze ist als einschließlich modelliert. Ein Hengst, der am 31. Mai genau fünf wird, braucht diesen Zusatznachweis noch nicht.

Die Tabelle verlangt bei weiblichen Tieren reinrassige Anpaarung und bei Zuchtsauen mindestens jeden zweiten Wurf reinrassig. Die Reinrassigkeit der Anpaarung wird als eigenständiger Zuchtprogrammnachweis erfasst. Für die Wurffolge dürfen keine zwei unmittelbar aufeinanderfolgenden nicht reinrassigen Würfe vorkommen. Zusätzlich muss bis zum Stichtag bereits mindestens ein reinrassiger Wurf vorliegen. Die Behandlung einer abweichenden programmspezifischen Bestätigung bleibt fachlich offen.

Der detaillierte GEP-Nachweis betrifft die Arbeit der Züchter und der Organisation. Für den Zuschlag sind Listeneintrag und Umsetzung durch den Verband entscheidend. Ein leeres GEP-Feld der Rassenliste ergibt keinen Zuschlag. Eine Bestätigung der Milchleistungskontrolle begründet den Zuschlag nur bei einer förderbaren Kuh.

## Prämie und offene Entscheidungen

Bei Ersatz eines weiblichen Tiers durch ein männliches oder eines Tiers mit Milchleistungskontrolle durch eines ohne Kontrolle wird der niedrigere Betrag verwendet. Identische Tarife sind eindeutig. Bei abweichenden Tarifen in anderen Ersatzrichtungen lässt die Policy den Betrag offen. Die fachliche Tier- und Halteprüfung bleibt für diese Position abrufbar.

Die allgemeine Betriebsmindestgröße bezieht sich auf das erste ÖPUL-Jahr des Betriebs. Die beiden Flächenwerte im Profilvorschlag sind überlappungsfrei ermittelte österreichische MFA-Werte für das jeweilige Jahr. RGVE-Dichte und geschlossene Listen zum allgemeinen Betriebsstatus werden separat ausgewertet. Für den Zugang zu Maßnahme 5 zählt mindestens ein förderbares Stichtagstier. Die Modulation verwendet die maßgebliche Heimfläche laut MFA. Bei einer Heimfläche von null wird kein Größenabschlag berechnet.

`data.oepul.o6_5.pruefung` wertet ein Betriebsprofil mit `farm.year` und `livestock.foerderpositionen` aus. Es liefert Stichtage, den Stand der Mindestteilnahme und der Anmeldung, bezifferbare Positionen, Ersatzfristen und Meldewege. Eine fehlende Bestätigung oder ein fehlendes Meldedatum erscheint als fehlender Nachweis. Die modulierte Tarifsumme wird nur ausgegeben, wenn Betriebszugang, Anmeldung und sämtliche Positionen bezifferbar belegt sind. Sie liegt vor etwaigen Sanktionen und Rückforderungen. Für deren Einstufung berücksichtigt die AMA Schwere, Ausmaß, Dauer und Häufigkeit. Aus einem verspäteten Meldeeintrag allein lässt sich kein bestimmter Kürzungssatz ableiten.

Anhang L behandelt Kombinationen auf der Einzelfläche. Seine 21 Zeilen und 21 Spalten sind einschließlich Leerzellen und Fußnoten erfasst. Maßnahme 5 hat darin keine eigene Achse. Hektarobergrenzen für Schläge sowie die Nutzungs-, Ernte- und Insektizidausnahmen anderer Maßnahmen werden im Ledger nach ihrem sachlichen Geltungsbereich eingeordnet.
