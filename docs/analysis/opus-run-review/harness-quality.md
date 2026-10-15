# Unabhängige Qualitätskontrolle der Prüfwerkzeuge

Stand 15.10.2026. Nach den dokumentierten Korrekturen ist keine wesentliche
offene Unstimmigkeit an Bindung, Replay oder Strukturprüfung der geprüften
Werkzeugfassung bekannt. Diese technische Kontrolle schließt keine weitere
fachliche Einzelprüfung ab. Die ursprüngliche Werkzeugsichtung fand während
des o6_1b-Reviews statt; ihre Kontroll- und Batchzahlen beschreiben diesen
damaligen Stand. Der unten dokumentierte Nachtrag während des rohen o6_3-Reviews
prüft ausschließlich die zusätzliche Matcher-Absicherung.

Diese Fassung ersetzt die frühere Werkzeugbewertung nach einem von der
Hauptprüfung gefundenen Namespace-Fehler: Einzelne JSON-Dateien mit `--data`
zu laden entfernt den ursprünglichen Verzeichniskontext. Dadurch lieferte der
generische BIO-Replay fälschlich zahlreiche `undefined`-Ergebnisse. Die ersten
synthetischen Kontrollen griffen nur auf `input` zu; der geprüfte UBB-Batch nutzte
seinen separaten, bereits korrekten Loader. Beides deckte diesen Fehler nicht ab.
Der vorläufige fehlerhafte BIO-Lauf wurde verworfen und nicht als Policybefund
verwendet.

Der korrigierte Loader lädt die Originalverzeichnisse `bundle/policy` und
`bundle/data`. Unabhängig wurden der vollständige öffentliche BIO-Baseline-
Rohwert mit allen zehn Ergebnisfeldern und sämtlichen Unterwerten, der Namespace
mit 40 Prämiensatzzeilen sowie ein tatsächlicher 235-EUR-Satzverbraucher geprüft.
Alle stimmen. Dieselbe Baseline wird mit der früheren Einzeldatei-Ladung
nachweislich `undefined`. Dieser Vergleich mit einer eingefrorenen Veröffentlichung
ist eine technische Regression und kein fachlicher Sollwert. Der gemeinsame
Runner führt zusätzlich einen verpflichtenden Namespace-Vorabcheck aus.

Die numerischen Kontrollen wurden unabhängig reproduziert. Die exakt gebundene
Binary mit SHA-256
`9903e5125ac281104f2c4b7371d10cc3b74a98933743fcbfc174f9bf0ab20de8`
liefert bei 60 ausgewählten Vergleichen 17 Abweichungen von der Python-Decimal-
Referenz. Beispielsweise ergibt `1 == 10.0` dort `true`. Alle 60 Ausdrücke
wurden zusätzlich einzeln ausgeführt; die Ergebnisse stimmen mit der gebündelten
Abfrage überein. Die Versionsausgabe bezeichnet das Programm als OPA 1.18.2
und nennt einen Build-Commit mit `-dirty`.

Dieser Nachweis gilt für die konkrete Binary und die dokumentierten Vergleiche.
Die 17 Abweichungen sind weder 17 Modellfehler noch eine Genauigkeitsquote oder
ein Beweis, dass alle 26 Regeln-Kandidaten betroffen sind. Für einen einzelnen
Policybefund bleiben die jeweilige Quelle, der Codepfad und ein konkreter
Eingabefall erforderlich. Der Umgang mit `null` oder `false` in Rego-Vergleichen
ist davon als Eingabe- und Typprüfungsproblem getrennt zu beurteilen. Kein Pin,
keine Binary und keine historische Ausgabe wurden korrigiert oder ersetzt.

Sieben temporäre technische Kontrollfälle mit zwölf Erwartungen prüfen ein
vorhandenes `null`, `undefined`, fehlende Ausgabeschlüssel, `false` gegenüber
numerischer Null, verschachtelte Werte und einen strikten Laufzeitfehler.
Zwei Ausführungen erzeugten identische Bytes. Die absichtlich gegensätzlichen
Erwartungen dienen der Kontrolle des Vergleichers und sind keine landwirtschaftlichen
Sollfälle. Pfadausbrüche, doppelte JSON-Schlüssel, NaN/Infinity und nicht
freigegebene Fremdabfragen werden zurückgewiesen.

Im Review wurden Lücken der Strukturprüfung reproduziert und anschließend
behoben: typisierte Vergleiche gespeicherter Checks/Zähler, exakte moderne
Fall-/Run-/Maßnahmenidentität, effektive Abfrage, Runtime-Metadaten und eindeutige,
nichtleere Fallkennungen. Der gültige Kontrollsatz wird akzeptiert; sieben
gezielt beschädigte Varianten werden jetzt abgelehnt. Die Integritätsprüfungen
der numerischen Erhebung bleiben auch mit `python -O` wirksam; eine falsche
Binary wurde dabei vor der Auswertung abgewiesen.

Die gemeinsame Batch-Verifikation wurde unabhängig ausgeführt. Sie reproduziert
den bereits abgeschlossenen UBB-Bericht mit 43 Fällen bytegenau und überspringt
25 noch nicht abgeschlossene Einträge ausdrücklich. Ungültige Batch-Aufrufe
für Schreiben, Bindung, fehlende OPA oder widersprüchliche Ziele werden abgelehnt.
Dadurch entstehen keine weiteren Quellenprüfungen, Expertenabnahmen oder
App-Promotionen.

Bindung und Runtime bleiben auf die veröffentlichten Originaldateien beschränkt.
Capability-Sperren, genaue SHA-Prüfung, strikte Kompilierung und begrenzte Laufzeit
sind erhalten. Ein Strukturcheck ohne `--opa` prüft gespeicherte Zusammenhänge;
der tatsächliche Replay erfolgt mit `--verify`. Quellenlektüre und fachliche
Auslegung ersetzt beides nicht.

Die neue Sammlung `collect_review.py` wurde gesondert kontrolliert. Sie
übernimmt nur bereits verfasste Bewertungen und Erwartungen, erhält sämtliche
überlappenden Regelurteile und weist ihre Herkunft aus. Beobachtete Ausgaben
werden nicht zu Sollwerten. `--complete` verlangt alle Teilberichte und deren
exakte Katalogabdeckung; es bestätigt einen ausdrücklich verlangten
Sammlungsabschluss und ändert die gemeinsame Warteschlange nicht. Quellenpfade
belegen dabei Identität, keine automatische Quellenlektüre oder fachliche
Richtigkeit. Temporäre Kontrollen bestätigten unveränderte Erwartungen und
Quellenbelege sowie die Erhaltung beider überlappender Regelbewertungen.

Die Einzelkontrollen, Ergebnisse und Dateihashes stehen in
[harness-quality.json](harness-quality.json). Die jeweiligen fachlichen
Einzelprüfungen und Expertenabnahmen folgen aus diesem Werkzeugbericht nicht.

Nachtrag zur Matcher-Absicherung während o6_3, 15.10.2026: Einige verfasste
Zugangsproben in o6_2 und o6_3 verwendeten Objektregel-Matcher für Stringlisten.
Die Proben vergleichen nun ausdrücklich die erwarteten Stringlisten; fachliche
Erwartungen, Eingaben und historische Policies bleiben unverändert. Die beiden
vollständigen Replays wurden nach der Korrektur unabhängig erneut ausgeführt.

Der hier gesondert geprüfte Werkzeug-Diff ergänzt drei Validatorzeilen: Ein
neu berechnetes `invalid_rule_collection: true` verhindert jetzt den Abschluss
als gültige Quellenprobe. Der Vergleich selbst wurde nicht umdefiniert. Das
zugehörige Doku-Addendum verlangt `rule_id`-Objektarrays und nennt für Stringlisten
explizite Gleichheit oder zugelassene Bool-Abfragen. Ein leeres Array erlaubt
keine automatische Ableitung seines Elementtyps.

Die drei neuen technischen Tests wurden unabhängig ausgeführt und bestanden:
acht unzulässige Kombinationen werden abgewiesen; zwei Leerarray- und vier
wohlgeformte Varianten bleiben zulässig, einschließlich legitimer nicht erfüllter
Erwartungen. Diese Kontrolle betrifft den engen Diff und die genannten Tests.
Frühere numerische, Collector-, Namespace- und sonstige Werkzeugtests werden
hiermit nicht als erneut ausgeführt ausgegeben; ihre übrigen Dateihashes sind
unverändert. Eine vollständige Repository-Testsuite ist eine getrennte Prüfung.
