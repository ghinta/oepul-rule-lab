# Einzelprüfung 16/26: Almbewirtschaftung

Die Quellenprüfung von `v2-o6_14-opus-5.5-high-20260926` ist abgeschlossen;
die Befunde blockieren eine fachliche Freigabe.
Gebunden ist der unveränderte Kandidatencommit
`e009eed4a83ff076b26eba33ac433ac2b0642621`. Alle Befunde gehören in das
[Sammelissue #112](https://github.com/ghinta/oepul-rule-lab/issues/112)
und auf den bestehenden gemeinsamen Branch. Historische Policies werden
nicht repariert; die Sammlung erteilt keine Expertenfreigabe oder Promotion.
Der nächste Run beginnt erst nach dem dokumentierten Prüfabschluss.

Das neue Merkblatt wurde auf allen 16 Seiten einschließlich Tabellen,
Fortsetzungen, Beispiele, Aktualisierungen und Schlussvermerken vollständig
gelesen. Alle acht Produktionsmodule mit 1.377 Zeilen, sämtliche 17
nummerierten Annahmen und übrigen Fragen sowie die vier tatsächlichen
Vorschlagsbäume wurden vollständig gelesen. Für die Kernkontrollen wurden
SRL-Seiten 69–71 und Anhang A auf Seite 3 aktuell vollständig rückgelesen.

Das Paket enthält acht Originale. Sieben identische gemeinsame Originale
werden mit Hashnachweis an frühere vollständige Lektüren gebunden; aktuelle
Klauseln und Verbraucher werden erneut verglichen. GSP-AV und NAPV sind
nicht beigefügt und werden nicht rückwirkend aus anderen Paketen als damals
bereitgestellte Originale angerechnet.

## Bekannte Tier-, Alm- und Tarifkomponenten

Drei frische öffentliche Szenarien für 2023, 2024 und 2026 verwenden jeweils
drei österreichische Almen mit fünf Hektar je Alm und den Erschließungsstufen
1, 2 und 3. Auf jeder Alm stehen vier getrennt identifizierte erwachsene
Standardrinder mit Geburtsdatum 1. Jänner 2020 und bekannter Nichtzwergrasse.
Jedes Tier hat einen eigenen Datensatz mit Stückzahl eins. Die öffentlichen
Kennungen sind keine echten Tierregisterbelege; Art, Alter, Rasse,
Anwesenheit und Meldesachverhalte sind ausdrücklich positiv stipulierte
Tatsachen des hypothetischen Szenarios.

Jedes Tier ist vom 1. Juni bis zum 1. August auf genau seiner Alm; Auf- und
Abtrieb sind am tatsächlichen Tag gemeldet. Das ergibt jeweils 61
tatsächliche und angerechnete Alpungstage, eine RGVE je Tier, vier RGVE je
Alm und eine Besatzdichte von 0,8 RGVE/ha. Die optionale vorbereitete
RGVE-Kategorie ist bewusst **nicht gesetzt**. Dadurch prüfen die Kontrollen
die tatsächliche Ableitung aus positiver Tierart, Rasse und Geburtsdatum;
eine nullige Kategorie wird nicht heimlich entfernt oder umgewandelt.

Jede Alm erhält wegen der Begrenzung auf einen Hektar je RGVE vier
Prämienhektar. Für 2023 ergeben die drei Stufen 160, 240 und 320 Euro,
zusammen 720 Euro. Für 2024 und 2026 ergeben sich 172,80, 259,20 und
345,60 Euro, zusammen jeweils 777,60 Euro. Alle 213 Vergleiche der drei
nativen Auswertungen sind erfüllt. Die Query enthält die tatsächliche
Hauptentscheidung sowie ausdrücklich bezeichnete RGVE-, Tages- und
Besatzprojektionen, keine alleinige Helferfreigabe.

Der tatsächliche ursprüngliche Maßnahmenantrag vom 1. Dezember 2022,
Vertragsbeginn 2023, aktuelle fristgerechte Flächen-/Zahlungsanträge,
Bekanntheit aller persönlichen Zugangsvoraussetzungen und ganzjährig
ordnungsgemäße Almbewirtschaftung sind positive Szenarioprämissen. Die
natürliche Futtergrundlage ist ausreichend; Pflanzenschutz- und Düngemittel,
Silage und fremdes Grünfutter werden nicht eingesetzt. NATA und Almweideplan
sind nicht beantragt. Andere Prämien, behördliche Kürzungen, Kontroll- oder
sonstige Sonderereignisse liegen nicht vor. Nicht eingetretene Ereignisse
bekommen keine erfundenen Daten.

15 Hektar tatsächliche Almfläche und zwölf prämienfähige RGVE erreichen das
betriebliche Erstjahresminimum sicher. Die bekannten zwölf Prämienhektar
bleiben unter der Modulationsgrenze. Die offene Frage zur globalen
Modulationsbasis gegenüber der Summe einzelalmweise begrenzter Hektar wird
durch diese kleinen, gleichartig bestoßenen Almen nicht entschieden.

## Numerische Enumnotation und Ausgabeumfang

Der tatsächliche Vorschlag nennt für die Erschließungsstufe und deren
Teilflächeneinträge `enum(1|2|3)`. Der Code und die nativen Datentabellen
verwenden Zahlen. Der vorhandene Repository-Vertrag definiert die
Primitivinterpretation solcher Zifferntokens nicht: `value_after` ist ein
Shape-Blueprint mit beliebigem JSON-Wert, der Änderungsanwender kopiert ihn.
Die beiden Pfade bleiben deshalb ausdrücklich als Zahl-/String-Mehrdeutigkeit
dokumentiert. Numerische Stufen in diesen Komponenten sind die offen
benannte native Konvention. Es gibt keine stille Konvertierung, keinen
ungeprüften String-Schemafehler und keine pauschale Schemakonformitätsbescheinigung.

Die historische Annahme 4 bezeichnet `premium_total` ausdrücklich als
Betrag vor inhaltlichen Kürzungen. Tatsächliche Zugangs-, Flächen-, Tier-
und Modulationsverbraucher werden gewürdigt. Die informative Ausgabegrenze
trennt diesen Komponentenbetrag von echter Behördenentscheidung. Ein
unbewerteter lokaler Auflagenbefund erhält keinen erfundenen pauschalen
100-Prozent-Abschlag.

## Gemeinsames Ergebnis und Grenzen

Alle 126 historischen Regel-IDs sind einzeln beurteilt; vier tatsächliche
Profilvorschläge und alle 27 Tabellenzeiger sind erfasst. Die gemeinsame
native Ausführung umfasst 618 öffentliche Entwicklungsproben mit 883
Einzelprüfungen: 807 erfüllt und 76 abweichend. 587 Ergebnisse sind definiert,
31 sind Laufzeitfehler, keines ist undefiniert. Das sind gezielte,
überlappende Proben und keine Modellgenauigkeit oder unabhängigen
Expertenurteile. Die 45 Befundgruppen sind ebenfalls keine 45 unabhängigen
Defekte. Die Original-Selbsttests und die 24 GM-Studienfälle liefern keine
Sollwerte dieser Untersuchung.

Die wichtigsten konkret belegten Verbraucherfamilien sind:

- **Modulationsbasis:** Bei zwei zulässig bestoßenen Almen mit 100 ha/150 RGVE
  und 200 ha/100 RGVE sind lokal jeweils 100 Prämienhektar korrekt. Das
  Merkblatt verlangt für die Modulation jedoch das globale Minimum aus
  300 ha und 250 RGVE. Die native Summe lokaler Minima ergibt 200 statt 250,
  Faktor 1 statt 0,98 und 8.640 statt 8.467,20 Euro. Die Quellannahme A07
  widerspricht hier dem aktuellen Original; ihr angebliches 230-ha-Beispiel
  steht dort nicht. Die konkrete Gegenprobe liegt im Allgemeinteil.
- **Nullable RGVE-Kategorie:** Bei bekannter Tierart, Geburt und Rasse
  verhindert ein zulässiges explizites `null` die Ableitung. Drei bekannte
  erwachsene Rinder ergeben dadurch 0 statt 3 RGVE und 0 statt nominal
  129,60 Euro. Die Tabellengegenproben und Eingabekontrollen belegen
  dieselbe Familie. Die getrennten Kontrollen mit ausgelassenem optionalem
  Kategorieschlüssel funktionieren; die Nullgegenfälle bleiben unverändert.
- **Tierbereich der Alm-Tage:** Ein bekanntes nicht teilnahmefähiges
  Hausschwein verlängert die Almbelegung von 30 auf 61 Tage. MAIN bleibt
  im abgegrenzten Szenario korrekt bei 0 Euro; nachgewiesen ist der lokale
  Bereichsfehler, keine falsche Gesamtzahlung.

Aktueller Vertragsbeginn/-ausstieg, ursprüngliche Zuschlagsanträge,
wirksame AWP-Abmeldung, tatsächlich fehlender aktueller Flächenantrag,
OP/VF-Flächen und unentschuldigte Kontrollverweigerung sind weitere
getrennt dokumentierte Rechtsfolgen. Historische Vertragsbildung,
nominale physische Betragskomponenten und aktuelle Zahlungsfreigabe
werden dabei unterschieden. Der 2,4-RGVE-Gegencheck bleibt ausdrücklich
vom Bedeutungsvertrag des vorbereiteten Antragsflags abhängig. Ein bloß
beantragtes Dürreansuchen gilt nicht bereits als behördlich anerkannt.
Ein freier OPALM-Bezeichner bleibt ein hypothetischer technischer Fall,
kein behaupteter amtlicher Code.

Alle 31 Laufzeitfehler stammen aus dem Eingabeteil: 17 zulässige Nullable
in MAIN, zwei zulässige Nullable in separaten Helfern, ein fehlendes
Startjahr mit nativem Null-Default, zwei Identitätskonflikte, acht
Outside-Schema-Stresse und ein String-Multiplikationsfehler unter offener
Enumprimitive. Die letzte Klasse ist kein unbedingter Schemafehler.
Fehlende Nachweise, bekannte Nichterfüllung, separate Helfer und tatsächliche
Gesamtentscheidungen bleiben getrennt. Unbekannte Voraussetzungen dürfen
keine Freigabe begründen; daraus folgt kein erfundener tatsächlicher
Agrarverstoß oder frei gewählter Sanktionstotalverlust.

## Tabellen und tatsächliche App-Grenze

Vier native Datenobjekte enthalten 147 direkte Einträge und insgesamt
576 Skalarwerte einschließlich fünf übriger Metadaten; alle Zählungen
stimmen. Alle 18 RGVE-Klassen, Alterskanten, vier Zwergrassen, Tarife,
Anhang-E-Codes und Fristen sind quellengebunden geprüft. Die native
Kombinationsdatei enthält nur die 20 leeren Gegenmaßnahmen der Zeile 14.
Sie wird nicht als vollständige native 134-Zellen-Matrix ausgegeben.

Die vier Vorschläge enthalten 136 Blätter: 131 werden an 263 dokumentierten
Lesestellen verwendet, fünf bleiben ungelesen. 14 wirken nur in separaten
Helfern, 51 in MAIN-Meldungen und 66 bedingt in MAIN-Nachweisen, Fläche
oder Betrag. Zwei weitere gelesene Pfade gehören zum unveränderten Canonical.
Die tatsächliche App-Projektion am gebundenen Commit
`529eadb34c4fdd249fbf739a372d63185b7374a2` erhält keine der vier Wurzeln und
keines der 136 Vorschlagsblätter, aber beide Canonicalpfade. Der SQL-Guard
verzeichnet null Aufrufe. Die exakte App-Ausgabe wurde separat unverändert
nativ ausgewertet und liefert definiert `access_conditions_met=false`
sowie `premium_total_eur=0`. Diese Beobachtung zählt nicht zu den 618 Proben.

## Reproduzierbarkeit und transparente Konstruktionen

Alle fünf Teile wurden vor der gemeinsamen Sammlung eingefroren. Die
ursprünglichen Policy-/Datenverzeichnisse werden unverändert unter der
gepinnten OPA-Binärdatei geladen; strikte Builtinfehler und feste Limits
sind aktiv, Netzwerk-/Jetzt-/Zufalls-/Runtimebuiltins gesperrt.

Eigene Entwurfsfehler sind dokumentiert und keine Modellbefunde: Zwei
General-Prädikate brauchten Boolprojektionen; beim bekannten fehlenden
FSL-Antrag wurde das widersprüchliche eingereichte FSL-Datum entfernt.
Im Domainentwurf aktivierten acht Meldefälle Optionen mit inaktiven
Null-Basisdaten. Elf aktive Optionsfixtures mit 78 Lifecycle-/Kurs-/Planblättern
wurden vor dem vollständigen finalen 318-Fälle-Replay berichtigt; alter
Entwurf und jede Änderung bleiben erhalten. Die wirklichen Nullable-
Gegenfälle sind weiterhin enthalten. Drei zusätzliche Tabellenkontrollen
prüfen Abwesenheit des optionalen Kategorieblatts; die ursprünglichen
Nullfälle und Erwartungen wurden nicht umgeschrieben. Die spätere enge
Tabellenrevision korrigiert ausschließlich die Navigation der Modulation
zum Allgemeinteil und bewahrt beide alten Freezehashes.

Die Originale, 47 historischen Bindungen, alle aktuellen Teildateien,
nativen Ausgaben und die abschließende unabhängige Qualitätsprüfung sind
im Dossier gebunden. [General](general.md), [Maßnahme](measure.md),
[Tabellen](tables.md), [Eingaben/App](inputs.md) und [Qualität](quality.md)
enthalten die vollständigen Einzelbelege. Kein historischer Policycode,
Canonical, Originaltext oder Appcode wurde verändert; keine Promotion,
Expertenabnahme oder Serverfreigabe erfolgt.
