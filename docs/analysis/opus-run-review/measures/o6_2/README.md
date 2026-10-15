# Einzelprüfung 4/26: Einschränkung ertragssteigernder Betriebsmittel

Der unveränderte Run `v2-o6_2-opus-5.5-high-20260930` bleibt für eine native
App-Aufnahme blockiert. Dieses Dossier sammelt Befunde für
[Sammelissue #112](https://github.com/ghinta/oepul-rule-lab/issues/112).
Es repariert keine Regeln und erteilt keine Expertenfreigabe.

Vollständig geprüft wurden das achtseitige Maßnahmenmerkblatt, sämtliche acht
Produktionsmodule, alle 82 Katalogregeln, 28 Tabellencontainer und 26
Profilvorschläge mit 72 neuen Blättern. Die sieben gemeinsamen Quellen sind im
Hash identisch mit früheren vollständigen Lesedurchgängen. Diese werden gebunden
wiederverwendet; maßgebliche Klauseln und tatsächliche Verbraucher wurden erneut
verglichen. Die GSP-AV fehlt ausdrücklich in diesem historischen Quellenpaket.
Ihre bei o6_1c gelesene Fassung wird diesem Run nicht nachträglich als gelieferter
Eingabekorpus oder als verdeckter Sollwert zugerechnet. Aktuelle fachliche
Verwendbarkeit und Quellentreue gegenüber dem damaligen Paket bleiben getrennt.

Die Teilberichte stehen in [general.md](general.md), [measure.md](measure.md),
[tables.md](tables.md) und [inputs.md](inputs.md), jeweils mit einem JSON-Ledger.
[core.json](core.json) ergänzt gemeinsame Helfer und die Gesamtentscheidung.
[audit.json](audit.json) erhält alle 93 Bewertungen der 82 historischen IDs und
34 Teilbefunde. Drei weitere, belegte Quellenpflichten stehen ausdrücklich
außerhalb des historischen Katalogs unter `additional_source_rules` im
Maßnahmenledger. Überlappende Befunde sind keine unabhängigen Fehlerzahlen.

## Konkrete Befunde und erhaltene Umsetzungen

| Bereich | Ergebnis und Abgrenzung |
|---|---|
| Ausgabe ohne Futterfläche | Ein reiner Ackerbetriebsfall hat keine Besatzdichte. Der versuchte `object.get`-Fallback kann den inneren undefinierten Wert nicht abfangen; dadurch verschwindet die ganze `decision`. Die Gegenkontrolle mit Grünland ohne Tiere liefert eine vollständige Ausgabe. Verfügbarkeit ist eine technische Schnittstellenanforderung; die Quelle schreibt keinen OPA-Status vor. |
| Vertrag und Zeit | Antrag und gültiges Beginnjahr werden hier bereits positiv verlangt. Die aktuelle Förderfähigkeit wird aber nicht vollständig an Beginn, Ende 2028, Ausstieg und die endgültige Zahlungsantragsfolge gebunden. Übernahme und nachgewiesene Betriebsfortführung bleiben unvollständig integriert. |
| Kontrollfolgen | `eligible` und der ausgegebene Nettobetrag sperren die aktuelle Kontrollverweigerung und den Ausschluss. Die zusätzlich in der gelieferten SRL verlangte Vertragsbeendigung und Rückabwicklung bleiben getrennte Helfer oder fehlen. Die Ausnahmeursache höherer Gewalt ist im Schema nicht darstellbar. |
| Ganzjährige Verpflichtung | Eine ausdrücklich gemeldete Weitergabe ohne Fortführung wird im OP-Helfer erkannt, aber nicht als Prämienausschluss verarbeitet. Im gepaarten Mischbetriebsfall bleiben für die bekannte nicht ganzjährig erfüllte Ackerfläche 129,60 Euro stehen. Das Quellensoll null betrifft diese Fläche; es ist keine erfundene pauschale Sanktion auf beliebige Pflegefehler. |
| Kombinationen | Die korrekte Matrixzeile ersetzt nicht die Unterbedingungen: AG innerhalb Maßnahme 16 und UBB-Acker-DIV benötigen zusätzliche, bereits gelieferte Quellensperren. Der 50-%-Abschlag bei Kombination 2/16 betrifft korrekt die Basisprämie 16 und wird nicht auf die 2-Prämie übertragen. |
| Bewirtschaftung | Ein Vorjahresschnitt kann die aktuelle Jahresmahd erfüllen. Die allgemeine DIV-Ausnahme fehlt lokal im 85-%-Erntecheck; eine korrekte Bewirtschaftungsausnahme begründet noch keine kombinierbare 2-Prämie. Mehrjährige Kulturen und unterschiedliche Zweijahrespflichten sind nicht vollständig ausgeführt. |
| Nullable Zahlen | Fünf Rechenfehler entstehen mit ausdrücklich erlaubten `number|null`-Werten: beide N-Aggregate, Flächenzugang, andere Flächenzahlungen und die Vorjahresfläche im getrennten Toleranzhelfer. Fehlendes Feld und vorhandenes `null` werden unterschiedlich behandelt. Drei weitere Fehler sind ausdrücklich außerhalb des Schemas. |
| Nutzfläche und Tiere | Ausdrücklich ausländische Flächen/Tiere und Ackerfutter-Zweitkulturen werden für die vorgesehenen Nenner richtig getrennt. Eine bekannte nichtlandwirtschaftliche Hoffläche darf die N-Belastung aber nicht verdünnen. `other` wird wegen seiner Mehrdeutigkeit nicht pauschal ausgeschlossen. Vorgeprüfte Jahresdurchschnittstierzahlen passen außerdem nicht durchgehend zum unveränderten ganzzahligen `animal_count`. |
| Nachweis und Identität | Herkunft, Ernte, Obstqualität oder Zahlungsantrag können günstig vorbelegt werden. Fehlende Belege beweisen keinen tatsächlichen Verstoß; die heutigen positiven Nachweisanforderungen sind gesondert markiert. Arten-/RGVE-Schlüssel, Fruchtgruppen, Nationalparkauflagen und die genaue PSM-Kulturphase benötigen einen präzisen externen Vertrag. |
| Betriebsmittel und Kürzungen | Bio-Ausnahmen und bekannte Biogasrücknahme verlangen bereits positive Angaben. Die Rücknahmemengen selbst fehlen. Die ausgeführte Folge aus Sanktion, Modulation, Obergrenze und Zugangskürzung besitzt eine korrekte 450-Euro-Komponentenkontrolle; weitere Kürzungsstufen und behördliche Entscheidungen bleiben offen. |

Die Tabellen wurden vollständig geprüft: sechs Datendateien, 28 Container mit
249 direkten Zeilen samt Verschachtelungen sowie 23 zusätzliche Metadatencontainer.
Alle 14 Prämienzeilen, 20 RGVE- und drei Schweine-GVE-Faktoren sind korrekt
kopiert. Die Kombinationszeile hat zwölf `x`, ein `a` und sieben Leerzellen.
Es wurden weder falsche Tabellenwerte noch ein erfundener eigener
50-%-Prämienabschlag festgestellt.

Die historischen Annahmen erwarten bereits vorverarbeitete Tierzahlen und
N-Werte. Der Run wird deshalb nicht nachträglich auf eine nicht versprochene
vollständige Tierereignishistorie geprüft. Die erforderliche Quellenmethode,
österreichischen Produktionseinheiten, Typen und Klassifikationen müssen bei
solcher Vorverarbeitung dennoch nachgewiesen werden. Dasselbe gilt für den
bereinigten Betrag anderer cap-relevanter Flächenzahlungen.

## Öffentliche Entwicklungsfälle und Reproduktion

[development-probes.json](development-probes.json) enthält 157 öffentliche
Entwicklungsfälle mit 167 Komponentenprüfungen. 148 Ausgaben sind definiert,
eine ist undefiniert und acht enden im ursprünglichen Laufzeitfehler.
123 Prüfungen treffen zu, 44 nicht. Gezielte und verwandte Gegenfälle,
Vertragsdiagnosen und Typstresstests ergeben keine Modellgenauigkeitsquote.

Die eine undefinierte Ausgabe ist der reine Ackerfall ohne Futterfläche.
Von den acht Fehlern betreffen fünf zulässige Nullable-Eingaben und drei
schemawidrige Boolean-/Arraywerte. Der Bruchkopfzahltest liegt außerhalb des
historischen int-Schemas; er belegt den Konflikt zur vorgesehenen Durchschnitts-
berechnung und ist kein gültiger Canonical-Farm-Genauigkeitsfall.

Ein widersprüchlicher Tierart-/RGVE-Schlüssel wird als Eingaberobustheit geprüft.
Sein erwarteter undefinierter Status ist eine gewünschte technische
Zurückweisung, keine gesetzlich vorgeschriebene Repräsentation. Bei unbekannter
2025-Flächenbasis legt der Run die Überschussfläche dennoch auf null fest;
die dazu verfassten Erwartungen verlangen eine offene Diagnose und erfinden
keine tatsächliche Basisfläche. Rohtexte einschließlich eines sichtbaren
Zahlenformatierungsartefakts bleiben erhalten, ohne es dem separat untersuchten
Vergleichsfehler der Binary zuzuschreiben.

```bash
python docs/analysis/opus-run-review/audit_runner.py --measure o6_2 \
  --candidate-root /path/to/e009eed-checkout --opa /path/to/pinned-opa --verify
```

Die [numerischen Laufzeitabweichungen](../../runtime-numeric.md) bleiben ein
eigenständiger Befund der exakt gepinnten Binary. Historische Selbsttests und
private Studienreferenzen liefern keine Sollwerte für diese Entwicklungsfälle.

69 von 72 neuen Blättern werden gelesen, sechs davon ausschließlich in
getrennten Helfern. Die drei ungelesenen Blätter und zwei tatsächlich gelesenen,
aber nicht vorgeschlagenen Lager-/Lieferfelder sind einzeln dokumentiert.
158 deklarierte Lesestellen und 14 bestehende Canonical-Pfade wurden geprüft.
Die tatsächliche App-Projektion wurde mit gesperrtem Datenbankzugriff ausgeführt:
Sie erhält zehn von 14 bestehenden nativen Pfaden und keinen der 26 neuen
Vorschlagspfade. Auch Kulturobjekt und regionale Fallbackpfade gehen verloren;
ein flaches `raw_label` ersetzt ihre Bedeutung im nativen Code nicht.

Die getrennte Gegenprüfung steht in [quality.md](quality.md). Historische
Regeln, Quellen, Profile und die produktive App wurden nicht verändert.
Gemeinsame Ursachen und Lösungen werden nach dem vollständigen Durchgang besprochen.
