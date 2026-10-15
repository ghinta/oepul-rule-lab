# Einzelprüfung 6/26: Bewirtschaftung von Bergmähdern

Der unveränderte Run `v2-o6_4-opus-5.5-high-20261009` bleibt für eine native
App-Aufnahme blockiert. Die Befunde werden im
[Sammelissue #112](https://github.com/ghinta/oepul-rule-lab/issues/112) und im
bestehenden gemeinsamen Branch gesammelt. Historische Regeln werden nicht repariert;
die Prüfung erteilt keine Expertenfreigabe.

Vollständig gelesen wurden das neue vierseitige Maßnahmenmerkblatt und sämtliche
sechs Produktionsmodule samt Rohannahmen. Alle 90 historischen Regeln, 31
Tabellencontainer und 13 Profilvorschläge sind einzeln erfasst. Die neun gebundenen
Quellen enthalten diesmal tatsächlich die GSP-AV. Ihre identische, bei o6_1c
vollständig gelesene Fassung wird mit Hashnachweis wiederverwendet; einschlägige
Klauseln wurden erneut mit den aktuellen Verbrauchern verglichen. Die sieben
weiteren gemeinsamen Quellen sind entsprechend gebunden wiederverwendet.
Quellentreue gegenüber dem damaligen Paket und heutige fachliche Aufnahmebedingungen
bleiben getrennte Prüffragen.

Die Teilberichte [general.md](general.md), [measure.md](measure.md),
[tables.md](tables.md) und [inputs.md](inputs.md) besitzen jeweils ein JSON-Ledger.
[core.json](core.json) ergänzt Auswahl, Gesamtentscheidung und drei administrative
Metadatenregeln. [audit.json](audit.json) erhält alle 97 Bewertungen der 90 IDs und
30 überlappende Teilbefunde. Diese sind keine unabhängigen Fehlerzahlen.

| Bereich | Quellenvergleich und Abgrenzung |
|---|---|
| Erhaltene Jahres- und Mahdprüfung | Mahd-, Dünger- und PSM-Ereignisse werden korrekt nach Antragsjahr ausgewählt. Eine qualifizierende Mahd verlangt Vollflächigkeit und Abtransport; Mulchen wird getrennt erfasst. Der Vorjahresschnittfehler aus o6_3 wird diesem Run nicht übertragen. |
| Teilnahme und Definition | Die Teilnahme kann je Schlag gewählt werden. Drei Kernkontrollen ergeben die bekannte BM1-Komponente von 756 Euro und zeigen die korrekte Abgrenzung eines nicht eingebrachten zweiten Schlages. Fehlende Bergmahd-Pflichtangaben blockieren die Prämie; mehr als 50 Prozent über 1.200 m wird strikt geprüft. |
| Standorte und Parkauflagen | Die gelieferte GSP verlangt die Lage über der Heimbetriebsstätte; das Merkblatt erlaubt die Lage unter der Almbetriebsstätte. Diese verschiedenen Begriffe begründen keine pauschale Ausnahme unterhalb des Heimbetriebs. Bei anderen Nationalparks kann ein bereits qualifizierter Ausschlussgrund geliefert werden; dessen vorgelagerte Auflagenprüfung ist ein eigener Vertrag. |
| Weideintervalle | Zulässige Nachweide ab 16. August wird auch ohne Mahd im selben Jahr berücksichtigt. Ein im Vorjahr beginnendes Intervall kann aber unerlaubte Beweidung im aktuellen Jahr enthalten und bleibt wegen der reinen Startjahresprüfung unberücksichtigt. |
| Amtliche Flächenbasis | In eindeutig zugeordneten Ein-Schlag-Fällen wird die bekannte Antrags-/Ermittlungsfläche nicht durchgehend zur Basis der Zahlung. Die isolierenden Gegenfälle bleiben unter der 3-Prozent-Sanktionsgrenze. Ein weiterer eindeutiger Übererklärungsfall liefert 756 statt 189 Euro, weil der getrennte Sanktionshelfer nicht verrechnet wird. |
| Kürzungsfolge | Inhaltskürzung, Modulation, Obergrenze und Zugangskürzung sind diesmal tatsächlich integriert. Die Kontrolle 7.560 → 3.780 → Faktor 218/220 → Faktor 0,75 ergibt korrekt 2.809,23 Euro. Vorgelagerte Über-/Untererklärung und weitere Rechtsfolgen sind damit noch nicht vollständig umgesetzt. |
| Fremde LSE-Komponente | Die Daten enthalten korrekte SRL-Sätze für UBB/BIO-Landschaftselemente. Der Verbraucher ignoriert aber die 80-Bäume-Grenze am Feldstück und berücksichtigt beim Cap ihre Modulation nicht. Die Bedingung eines vollständig bekannten Feldstücks und sonstiger Berechtigung bleibt ausdrücklich bestehen; eine frei erfundene Verteilung des Cap-Überhangs wird nicht geprüft. Für 2023 wird kein im Paket unbelegter LSE-Satz erfunden. |
| Vertrag und höhere Gewalt | Antrags-/Startdaten werden positiv verlangt. Beendigung, übernommene Flächen und Rückabwicklung sind dennoch unvollständig gebunden. Die Dreiwochenfrist muss nach §5 GSP bei Wochenende auf den nächsten Arbeitstag verschoben werden. Anerkennungs-, Kausalitäts- und Pflichtenbezug bleiben behördliche Eingaben; eine bloß rechtzeitige Meldung ist keine tatsächliche Anerkennung. |
| Nullable Eingaben | Drei ausdrücklich zulässige Nullwerte erzeugen Arithmetikfehler: einmal in der Hauptentscheidung und zweimal nur im Übererklärungshelfer. Vier zusätzliche Datum-null-Abstürze liegen außerhalb des Schemas. Günstige Defaults und fehlende Belege werden getrennt von nachgewiesenen tatsächlichen Verstößen bewertet. |
| Offene Auslegung | Ob eine tatsächlich erfolgte, aber unzulässige Mahd als BM0 zu codieren ist, bleibt eine offene Quellen-/Auslegungsfrage. Dafür wird kein numerisches Goldlabel vorgegeben. |

Alle Werte der einen Datendatei wurden gelesen: 31 Container mit 216 direkten
Zeilen/Schlüsseln einschließlich ihrer Verschachtelungen. Alle sieben eigenen
BM-Tarifzeilen stimmen; LSE-Sätze sind fremde Komponenten. Das verkürzte
Höhere-Gewalt-Beispiel verliert die Quellenbedingung „auf derselben Alm oder Weide“
und wird als Datenbefund dokumentiert. Die offene Beispielsliste ist kein
abschließendes Verzeichnis zulässiger Anerkennungsgründe.

## Entwicklungsfälle und Eingabekompatibilität

[development-probes.json](development-probes.json) enthält 185 öffentliche
Entwicklungsfälle mit 222 Komponentenprüfungen. 178 Ausgaben sind definiert;
sieben enden im ursprünglichen Laufzeitfehler. 182 Prüfungen treffen zu, 40 nicht.
Die gezielte Auswahl aus Quellenfällen, positiven Nachweisanforderungen,
Robustheitskontrollen und schemawidrigem Stress ergibt keine Modellgenauigkeitsquote.
Ein erfolgreiches Wiederholen bestätigt die Reproduktion dieser Abweichungen.

Die drei zulässigen Nullfehler betreffen die 2025-Flächenbasis und die beiden
nullable Antrags-/Ermittlungsflächen im getrennten Helfer. Die vier übrigen
Abstürze sind Datum-null-Stress außerhalb des Eingabevertrags. Bloße
Prädikatsabwesenheit wird von einem rechtlichen false und von einem nativen Fehler
unterschieden. Stringarrays werden mit passenden Erwartungen geprüft;
`invalid_rule_collection` tritt in keiner Beobachtung auf.

13 Profilvorschläge enthalten 69 neue Blätter. 67 werden gelesen, davon sieben
nur in getrennten Helfern. Ungelesen bleiben das Weide-Enddatum und die Kategorie
der Höhere-Gewalt-Meldung. 124 Lesestellen und sechs bestehende Canonical-Pfade
wurden geprüft; es gibt keine weiteren unvorgeschlagenen Lesefelder.

Die tatsächliche App-Projektion wurde bei gesperrtem SQL-Zugriff ausgeführt.
Sie erhält keinen der 13 neuen Pfade. Die native Ausführung mit dem projizierten
Payload liefert diesmal eine definierte leere Entscheidung mit fehlenden
Vertragsangaben. Das dokumentiert die Roh-Run-Schnittstelle; es belegt keine
fachliche Nutzbarkeit oder Änderung des gesonderten produktiven Regelpfads.
Dieser Integrationslauf wird nicht als zusätzlicher Quellenfall gezählt.

```bash
python docs/analysis/opus-run-review/audit_runner.py --measure o6_4 \
  --candidate-root /path/to/e009eed-checkout --opa /path/to/pinned-opa --verify
```

Die unabhängige Gegenprüfung steht in [quality.md](quality.md). Die separat
untersuchten [numerischen Laufzeitabweichungen](../../runtime-numeric.md) bleiben
auf die exakt gebundene Binary und ihre Kontrollen begrenzt. Keine öffentlichen
oder privaten Studienreferenzen, Expertenantworten oder Test-Sollwerte manueller
Adaptationen wurden als Orakel verwendet. Originale, Canonical-Profile und
produktive App bleiben unverändert. Gemeinsame Lösungen werden nach dem
vollständigen Durchgang aller 26 Runs besprochen.
