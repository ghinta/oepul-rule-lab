# o6_5 – Eingabevertrag und tatsächliche App-Projektion

Geprüft wurde ausschließlich der ursprüngliche Opus-Run `v2-o6_5-opus-5.5-high-20260925` am Candidate-Commit `e009eed4a83ff076b26eba33ac433ac2b0642621`. Sein natives Ziel ist `data.oepul.o6_5.decision`. Der Beitrag sammelt Befunde in Issue #112 / PR #111; er verändert weder historische Regeln und Profile noch Quellen oder Produktfunktionen und erteilt keine fachliche Freigabe.

[inputs.json](inputs.json) enthält alle sieben Profilvorschläge mit 62 neuen Blättern, ihren Typen, Einheiten, Bedeutungen, Defaults, Lesestellen und Ergebniswirkungen. Zusätzlich enthält es sieben Befunde und 48 neue öffentliche Eingabeprobes mit unveränderten nativen Beobachtungen. Der tatsächliche App-Projektionslauf und dessen anschließende native Auswertung sind separat gespeichert. Es wurden keine Studienreferenzfälle, privaten Fälle, Experten-/GM-Urteile, manuellen Anpassungstests oder Modell-Selbsttests als Sollantworten verwendet.

## Quellen und Code

Das neue Original `o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf` wurde auf allen zehn Seiten vollständig gelesen: jährlicher Vertrag und Erlöschen, teilnahmefähige Tiere und Rassen, sämtliche Kategorien einschließlich Stichtagen, Zuchteinsatz und Nachkommen, Haltedauer, VIS/Equidenkennzeichnung, Bestätigung der Zuchtorganisation, Abgang und Nachbesetzung, zeitweilige Weitergabe, Beantragung und Wiedereinstieg, alle Prämienperioden und Zuschläge, vollständige Rassenliste sowie Aktualisierungen und Unverbindlichkeitshinweis. SHA256: `3a6df7cf48c357caa5fade68751bdbdb719e7d7ac7a7374cc4049dd7b50f152b`.

Das Paket enthält acht Quellen: das neue Maßnahmenblatt und sieben bereits in vorigen Audits vollständig gelesene gemeinsame Dateien. SRL, Anhänge, allgemeine Teilnahmebedingungen und vier Originalmitteilungen werden nur nach erneutem exaktem Hashvergleich wiederverwendet; die zugeordneten Belege und ihre Abschnitte wurden gezielt erneut gelesen. Alle acht Hashes stimmen mit dem Run überein. Alle 26 unterschiedlichen Belege der Profilvorschläge sind nach ausschließlicher Leerraumnormalisierung auf der angegebenen Originalseite auffindbar. Die zusätzlichen Finding-/Probe-Zitate wurden ebenso überprüft; sie sind keine zusammengesetzten angeblichen Originalzitate.

Eine GSP-AV gehört diesem Run-Paket nicht an. Ihre Verweise in der gelieferten SRL bleiben eine Grenze des Quellenpakets. Die in o6_4 tatsächlich bereitgestellte GSP-AV wird hier weder als gelieferte Quelle ausgegeben noch als ungebundenes zusätzliches Sollwertorakel benutzt. Diese Korpusgrenze ist von einer Abweichung gegenüber tatsächlich gelieferten Quellen zu unterscheiden. Die 2026-Mitteilungen sind gebunden; die fachlichen Übergangsfälle liegen bei den Begleitbeiträgen.

Alle sieben Produktionsmodule wurden vollständig gelesen: `common`, `eligibility`, `holding`, `participation`, `reporting`, `premium` und `decision`. Die vollständigen Rohannahmen erklären den historischen Aufgabenvertrag, liefern aber keine unabhängigen Quellen-Sollantworten.

## Vollständiger Vorschlagsabgleich

Alle 62 Blätter sind neu; bestehende Canonical-Typen bleiben unverändert. Alle werden im ausführbaren Code gelesen. Kein Blatt bleibt ungelesen oder nur in einem ungenutzten getrennten Helfer.

| Nr. | Vorschlag | Blätter | Tatsächlicher Zweck |
|---:|---|---:|---|
| 1 | `livestock.endangered_breed_animals` | 39 | Individuelle Identität, Kategorie/Rasse, Zuchtbelege, Datums-/Wurf-/Nachkommendaten, Bestätigung, Haltung, MFA, Kennzeichnung, Abgang, Ersatz und vorübergehende Aufenthalte |
| 2 | `farm.applicant` | 5 | Rechtsform, Gebietskörperschaft/Beteiligung, aktiver Landwirt und ausgeübte landwirtschaftliche Tätigkeit |
| 3 | `oepul_participation` | 14 | Erstes ÖPUL-Jahr, Maßnahmenbeginn und Antrag, Ausstieg, Kontrollen, Erlöschen/Wiedereinstieg, Übernahme und bewertete Kürzungsstufe |
| 4 | `land.protected_cultivation_area_ha` | 1 | Alternative für allgemeines Erstjahres-Betriebsminimum |
| 5 | `documentation.inspection_refused` | 1 | Tatsächliche Kontrollverweigerung |
| 6 | `documentation.inspection_refusal_force_majeure` | 1 | Positive Ausnahme von der Kontrollverweigerungsfolge |
| 7 | `documentation.vis_reports_complete` | 1 | VIS-Beleg für Schafe/Ziegen; Meldefinding |

Sieben Blätter wirken ausschließlich auf die in `decision.findings` sichtbaren Melde-/Kennzeichnungsbefunde: `identification`, `ueln_in_application`, `equine_database_and_vis_reported`, `departure.reported_date`, `replacement_reported_date`, `temporary_absences[].reported_before_transfer` und `documentation.vis_reports_complete`. Sie werden tatsächlich ausgegeben, entziehen dem Tier aber nicht unmittelbar die Förderbarkeit. Eine rechtlich nicht festgelegte automatische Geldstrafe wird daraus nicht erfunden.

Die nativen Verwaltungsdaten liegen unter **top-level `oepul_participation.o6_5`**. Sie sind weder das frühere `farm.oepul` noch die App-Struktur `oepul.shared`/`oepul.measures`. Die Tiere stehen im Einzeltierarray `livestock.endangered_breed_animals`. Eine bloße Ähnlichkeit von Feldnamen begründet keinen zugelassenen Alias.

## Tatsächliche Lesestellen, Canonical-Pfade und Identitäten

Der historische Scanner findet nur `input.farm.year` und `input.documentation.vis_reports_complete`. Der vollständige Abgleich enthält dagegen 156 kontextbezogene Lesestellen einschließlich `object.get`, des `val`-Helfers und direkter Referenzen. Der dynamische Helfer `offspring_by_reference(a, field)` wird über seine zwei tatsächlichen Aufrufschlüssel zu `first_offspring_date` und `first_purebred_farrowing_date` zurückverfolgt. Die generische Definition `val(obj,key)` erzeugt keine erfundenen unabhängigen Eingabefelder.

Die Bedeutung lokaler Variablen wird berücksichtigt: `r`/`r2` bezeichnen in `holding` Ersatztiere, `r` in `reporting` ebenfalls ein Ersatztier, in `premium` und `participation` hingegen statische Tabellenzeilen. Ein pauschaler Alias würde dort falsche Eingabepfade `category`, `rate_period`, `reason` und `stage` erfinden oder das tatsächlich gelesene `replacement_reported_date` übersehen. Der geprüfte Abgleich enthält keine zusätzlichen nicht verwalteten Eingabepfade.

Zwei vorhandene Canonical-Pfade werden zusätzlich gelesen: `farm.year` als Auswertungs-/Kalenderjahr und `land.total_area_ha` als Betriebsfläche in Hektar für Erstjahresminimum und Modulation. Beide bleiben in der tatsächlichen App-Projektion erhalten. Das Jahr ist weder Run-Zeitstempel noch Alter eines Tieres; die Betriebsfläche muss den zutreffenden Quellumfang abbilden.

Die bestehenden `livestock.species_groups` werden nicht gelesen. Aggregierte Tierzahlen, RGVE und Produktionssystem ersetzen keine individuellen Rassen-, Zuchtbuch-, Geburts-, Halte- und Ersatznachweise. Die individuelle Kategorie wird hier tatsächlich mit der Rassenspezies verbunden: Ein gelisteter Rassenname allein genügt nicht, wenn die Kategorie eine andere Spezies beschreibt. Dies ist eine deutliche Verbesserung gegenüber unverbundenen Klassifikationsschlüsseln früherer Runs. Unaufgelöste Rassenstrings und nicht vorgesehene Kategorie-Tokens werden sicher abgelehnt; daraus wird keine neue biologische Rasse oder ein Synonym abgeleitet.

`animal_id` ist eine stabile eindeutige Tieridentität, auf der Dictionaries, Förderplätze und Ersatzverknüpfungen beruhen. Der Ersatz wird über `replaces_animal_id` verbunden. Kollisionsfreiheit, Existenz der referenzierten Tiere und widerspruchsfreie Ereignisdaten sind vorgelagerte Integritätsverträge. Root und Domain prüfen deren Gegenfälle; dieser Beitrag erfindet weder ein gesetzlich vorgeschriebenes Fehlerformat noch zusätzliche Identitätslabels.

Arraycontainer bleiben von Blättern getrennt. `endangered_breed_animals` und `temporary_absences` sind Arrays von Datensätzen; `[]` im Ledger bezeichnet den wiederholten Datensatz. `eligible_animal_ids`, `applicant_failures`, `contract_failures` und die tierbezogenen `failures` sind Stringmengen bzw. Stringarrays. `base_failures` und `holding_failures` bestehen aus Zweierarrays. Nur `findings` enthält Objekte mit `rule_id`. Die eigenen Probes verwenden ausschließlich `equals` und `status_equals`; Stringarrays und Paare werden nicht an Objekt-Matcher übergeben.

## Verbesserte Nachweisbehandlung und verbleibende Grenzen

Reinrassigkeit, Zuchtbucheintragung, genehmigtes Erhaltungsprogramm und regelmäßiger Zuchteinsatz verlangen tatsächlich exakt `true`. Dasselbe gilt für reinrassige Anpaarung bei weiblichen Tieren und Inlandshaltung. Fehlende oder anwendbare nullable unbekannte Fakten erzeugen keine positive Tierfreigabe. Auf Antragstellerebene sind aktiver Landwirt **und** tatsächlich ausgeübte landwirtschaftliche Tätigkeit getrennte positive Voraussetzungen. Diese neuen Gates werden ausdrücklich anerkannt; frühere günstige Default-Befunde werden nicht pauschal übernommen.

Die Kategorie-/Rassentabellen werden tatsächlich verbunden. Fehlende/null Erstgeburt, Beginn am Betrieb, anwendbares männliches Geburtsdatum oder Wurfzahlen werden in den geprüften Fällen sicher ohne positive Tierfreigabe behandelt. Auch beide fehlenden/null Verwaltungsfelder Maßnahmenbeginn und Antragsdatum verhindern den Zugang. Die Meldefrist prüft nicht nur die Obergrenze, sondern auch, dass das gemeldete Datum nicht vor dem Ereignis liegt.

Bei der Bestätigung der Zuchtorganisation bleibt eine bewusst dokumentierte Lücke: `status="confirmed"` mit fehlendem oder ausdrücklich erlaubtem `date=null` gilt als bestätigt, weil der Verspätungscheck ohne Datum nicht wahr wird. Das ist in Rohannahme A32 ausdrücklich zugelassen. Das Original verlangt die Beurteilung bis zum 10. Februar des Folgejahres. Die entsprechenden Probes verlangen einen positiven Fristnachweis; sie behaupten weder eine tatsächlich verspätete Beurteilung noch einen aus unbekanntem Datum folgenden rechtlichen Sanktionsbetrag.

Eine fehlende `legal_form` verhält sich anders als explizites `null`: Der fehlende direkte Referenzwert unterdrückt die negierte Tabellenmitgliedschaft, sodass das isolierte ansonsten vollständige Kontrollpayload Zugang erhält. Explizites `null` oder ein unbekannter nicht-null Token löst dagegen den Rechtsformfehler aus. Null und unbekannter Token sind außerhalb des vorgeschlagenen Enums; die fehlende Angabe ist die gewünschte Nachweisanforderung. Auch `public_body_share_percent=null` ist erlaubt und nicht `>25`; eine gesonderte Unbekanntdiagnose fehlt. Daraus wird keine tatsächlich unzulässige Rechtsform oder öffentliche Beteiligung behauptet.

Wurfzahlen sind als `int|null` vorgeschlagen. Die native `is_number`-Prüfung schützt vor null-Arithmetik, validiert aber keine Ganzzahligkeit: 2,5 Gesamtwürfe und 1,5 reinrassige Würfe können das Verhältnis erfüllen. Das ist ausdrücklich ungültiger Integer-Schema-Stress. Ob ein aggregierter Anteil die zeitliche Aussage „mindestens jeder 2. Wurf“ vollständig beschreibt, bleibt eine andere fachliche Auslegung; dieser Typentest entscheidet sie nicht.

Kennzeichnungs-, Herdbuch- und Programmflags benötigen weiterhin echte externe Belege mit zutreffender Identität und Periode. Ein technisch nicht-null leerer Identifikationsstring bestätigt keine gültige UELN. Zeitweilige Aufenthalte bilden strukturierte Ereignisse, aber keine vollständige Bewegungsdatenbank. Die Konsistenz von tatsächlichem Ersatz-Zugang und `replacement_date`, Alters-/Fohlengrenzen, Ersatzketten, weiteren Ereignisperioden sowie Zuschlags- und Prämienbedingungen liegt bei den zuständigen Begleitbeiträgen.

## Null- und Laufzeitdiagnostik

Die 48 eigenen Probes liefern 45 definierte Antworten und drei unverändert dokumentierte strikte Laufzeitfehler. Die drei Fehler liegen ausschließlich außerhalb des vorgeschlagenen Datenschemas:

| Ungültiger Eingabewert | Native Beobachtung |
|---|---|
| `measure_application_date="PUBLIC-NOT-A-DATE"` | `time.parse_ns` bricht die Hauptentscheidung ab |
| `first_offspring_date="PUBLIC-NOT-A-DATE"` | Derselbe Datumsparser bricht ab |
| `temporary_absences[].start_date=null` | Nichtnullable Datum erreicht `time.parse_ns` und bricht ab |

Bei ausdrücklich gültigen nullable Eingaben wurde in diesen fokussierten Fällen kein Laufzeitabbruch beobachtet. Das ist eine Verbesserung und kein Totalitätsbeweis über beliebige Eingaben. Nullable fehlende Wurfzahlen und Datumsbelege werden nicht als tatsächlich null Würfe, keine Geburt oder tatsächliche Nichthaltung umgedeutet. Ein unbekanntes Rückkehrdatum kann die Ausnahme für einen begrenzten vorübergehenden Aufenthalt nicht positiv begründen.

Die 48 Probes bestehen aus sieben bekannten Quellenkomponenten, 25 gewünschten Anforderungen an positive Nachweise, einem Identitäts-/Eingaberobustheitsfall und 15 ausdrücklich außerhalb des Schemas liegenden Stressfällen. Technische `status_equals`-Erwartungen verlangen sichere Diagnostik; eine Quelle schreibt keinen OPA-Verfügbarkeitsstatus vor. Fachliches `false`, natives `undefined` und Laufzeitfehler sind verschiedene Zustände. Fehlgeschlagene Assertions bilden keine fachliche Fehlerquote.

## Tatsächliche App-Projektion

`adapt_payload_for_measures` wurde auf App-Commit `529eadb34c4fdd249fbf739a372d63185b7374a2` tatsächlich ausgeführt. Alle sieben vorgeschlagenen Pfade sind im synthetischen Eingang vorhanden. `CursorWrapper.execute` hätte jeden SQL-Aufruf sofort abgebrochen; es gab keinen Datenbankaufruf. Eingang, Ausgang, drei Codehashes und Pfadvergleich stehen vollständig im JSON.

Nach der Projektion bleiben **0 von 7** neuen nativen Vorschlagspfaden und **2 von 2** zusätzlich gelesenen vorhandenen Pfaden erhalten. Insbesondere fehlen das Einzeltierarray, `farm.applicant` und `oepul_participation`. Die erhaltenen aggregierten Daten und anderen Verwaltungsstrukturen stellen diese Belege nicht her.

Ein gesonderter nativer Lauf mit genau dem projizierten Payload liefert eine definierte Antwort: Zugang `false`, `ACTIVE-FARMER`, `APP-DEADLINE` und `MIN-PARTICIPATION`, leere Tierergebnisse und Auszahlung 0. Diese verfügbare Ablehnung ist keine brauchbare Integration des Roh-Runs, keine Feldaliasfreigabe und keine Bewertung eines davon verschiedenen produktiven App-Regelpfads. Der zusätzliche Kompatibilitätslauf wird nicht als 49. unabhängiger Quellen-/Referenzfall gezählt.

Alle nativen Auswertungen verwenden die unveränderte, über Repository-Prüfsumme gebundene OPA 1.18.2, strikte Builtin-Fehler, zehn Sekunden Evaluationslimit und gesperrte Netzwerk-/Zufalls-/Jetztzeit-Builtins. Geladen werden die historischen Verzeichnisse `workspace/policy` und `workspace/data` mit der ursprünglichen verschachtelten Wurzel `data.o6_5`. Es gibt keine Datenumformung, alternative Laufzeit, historischen Fix oder daraus erzeugte Quellenwahrheit. Eigene und Begleitprobes können sich in Kontrollkomponenten überschneiden; ihre Fallzahlen sind keine unabhängige Genauigkeitsstichprobe. Es gab keine neue Modellabfrage, Promotion, Branchanlage oder Commit.
