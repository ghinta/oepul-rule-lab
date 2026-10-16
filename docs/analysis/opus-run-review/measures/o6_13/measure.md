# o6_13 – Einsatz von Nützlingen: fachliche Domänenprüfung

Run `v2-o6_13-opus-5.5-high-20260926`, Rohsnapshot `e009eed4a83ff076b26eba33ac433ac2b0642621`; aktueller Run 15/26. Dieser Teil besitzt exakt 16 historische Regel-IDs. Root sammelt und prüft die fünf Teile anschließend gemeinsam.

**98 native Fälle, 98 definierte Ergebnisse, 94 erfüllte lokale Sollwerte.** Ein lokaler Mindesthelper weicht in einem bereits vollständig ausgeschlossenen Verkaufsfall ab; die ganze Entscheidung sperrt diesen Fall korrekt. Drei weitere Abweichungen betreffen ausdrücklich bedingte Geometrie-, Jahresrecord- und Prämienverträge. Die Kontrollen belegen keine unberechtigte Gesamtzahlung.

## Quellen und vollständige Lektüre

Alle vier neuen Originalseiten wurden vollständig persönlich gelesen, einschließlich Tabellen, Fortsetzungen, Warnungen, Aktualisierungen und Schlussvermerk. Das gilt ebenso für alle neun tatsächlichen Module mit 1136 Zeilen, sämtliche zwölf nummerierten Annahmen samt technischen Hinweisen und alle 23 aktuellen Profilvorschläge.

Primäroriginal: `sources/oepul/originals/o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf`, SHA-256 `0d162ef5c7ae913eb15463f6fb3fb0fd4685b320811022d78cf70e899b9e7ed1`.

Sieben identische gemeinsame Originale sind über Hash und Dateigröße an frühere vollständige Lektüren gebunden. Aktuell wurden die vollständigen Seiten SRL 9/18/68, ATB 3 und Anhang L 103 erneut persönlich gelesen. Tables/QA prüfen die Originalbilder der Matrix; General übernimmt die zusätzlichen allgemeinen und Ausnahmebestimmungen. Das historische Packet enthält acht Originale, weder GSP-AV noch NAPV. Quellen anderer Maßnahmen und Studienkonventionen wurden nicht nachträglich eingeführt.

## Befunde und begrenzte Verträge

### O613-MEASURE-01: Mindesthelper berücksichtigt keine tatsächlich förderfähige Produktionsfläche

Der lokale Helfer minimum_participation_met verwendet nur NUE-Code, passenden Strukturtyp und eine anrechenbare Anwendung. Im eng abgegrenzten Gegenfall besteht die einzige Kandidatenstruktur vollständig aus Verkaufsfläche und besitzt keine geeignete landwirtschaftliche Produktionsfläche; aktive Bewirtschaftung und korrekte Referenzzuordnung sind ausdrücklich false. Ein zusätzlicher bekannter2ha-Ackerschlag hält die allgemeine Betriebsgröße unabhängig ein. Eine abstrakt als zulässig vorbereitete aktuelle Nützlingsanwendung auf den aufbewahrten Pflanzen isoliert den Mindesthelper, ohne eine reale Produktzulassung zu behaupten. Der lokale Mindestwert ist1 statt0. Die tatsächliche Gesamtentscheidung bleibt jedoch korrekt eligible=false; die förderfähige Maßnahmenfläche ist0. Diese beiden Gegenkontrollen sind enthalten. Es wird daher eine begrenzte Beschriftungs-/Komponentengrenze festgestellt, keine unberechtigte Gesamtzahlung oder feste Sanktion. Falls der Helfer bewusst nur Struktur und Anwendung vorprüft, muss seine Ausgabe auch genau diesen begrenzten Anspruch tragen.

> „In jedem Teilnahmejahr muss zumindest ein Gewächshaus oder Folientunnel nach den Vorgaben der Maßnahme bewirtschaftet werden.“
> o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf, PDF-Seite 2.

> „Verkaufs-, Schau- und Lagerflächen sind nicht förderfähig und sind nicht Teil der Flächenreferenz.“
> o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf, PDF-Seite 2.

Native Fälle: `o6_13-minimum-only-known-retail-house`, `o6_13-retail-house-still-no-eligible-premiumarea`, `o6_13-retail-house-wholedecision-guard-preserved`.

### O613-MEASURE-02: Ein bekannter aktueller Record ohne Datum erreicht die Datumsdiagnose nicht

Der Feldhelper missing_record_fields erkennt das fehlende Datum korrekt. Die ausgegebene DOC-Diagnose verlangt dagegen zuerst, das Datum dem Förderjahr zuordnen zu können. Bei einer tatsächlich bekannten aktuellen2025-Anwendung mit tatsächlich fehlendem Datum im abgeschlossenen Jahresrecord wird deshalb keine DOC-Diagnose ausgegeben:0 statt1. Der Kontrast ist ausdrücklich an einen vorbereiteten aktuellen Jahresrecord und den positiven Nachweis tatsächlicher Aufzeichnungslücke gebunden. Fehlt bloß die extrahierte Eingabe oder ist das Jahr unbekannt, ist dies keine landwirtschaftliche Verletzung. Wenn jede Anwendung bereits ein vollständiges typisiertes Datum garantieren soll, liegt der undatierte Fall außerhalb dieses stärkeren Eingabevertrags. Der Fall bleibt source_conditional_undated_record_contract, kein gewöhnlicher deterministischer Goldfehler. Art, Menge, Beleg, Grund, Ziel und bekannte Schlagbezogenheit besitzen ansonsten tatsächliche Verbraucher; zusätzliche frische Abfragen belegen die ausgegebenen DOC-Diagnosen für die aktuellen vollständig datierten negativen Records. Die Sanktionsstufe bleibt ein getrennter behördlicher Eingang.

> „Über Art und Menge der eingesetzten Organismen, Belege über Zukauf, Grund und Ziel sowie Datum des Einsatzes sind schlagbezogene Aufzeichnungen zu führen.“
> o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf, PDF-Seite 2.

> „Auch andere Aufzeichnungen werden anerkannt, sofern diese die notwendigen Angaben enthalten.“
> o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf, PDF-Seite 2.

Native Fälle: `o6_13-known-unrecorded-date-field-helper`, `o6_13-known-undated-current-record-diagnosis`.

### O613-MEASURE-03: Bruttofläche und disjunkte Komponenten brauchen einen ausdrücklich vorbereiteten Geometrievertrag

Die numerische Fläche wird tatsächlich um Verkaufs-, Schau-, Lager-, ungenutzte Zwischen- und überschüssige Ganganteile vermindert. Notwendige Gänge bleiben im bereits angegebenen Brutto enthalten und werden korrekt nicht nochmals addiert. Alle gewöhnlichen Komponentenfälle setzen gemessene Brutto-Kandidatenfläche und disjunkte Teilflächen voraus; aggregierte Betriebs-/Schutzflächen verwenden die bereinigte Fläche. Zwei geometrische Kontexte erhalten bewusst identische Eingabe und Query:0,2ha Verkauf plus0,2ha Lager sind entweder disjunkt (0,6ha verbleiben) oder bezeichnen dieselbe0,2ha-Fläche (0,8ha verbleiben). Nativ verbleiben in beiden Fällen0,6ha. Der zweite Fall ist ausdrücklich eine Repräsentationsgrenze außerhalb eines starken Disjunktheitsvertrags. Auch seine unveränderten Begleitaggregate stammen aus der disjunkten Vorbereitung und sind unter der überlappenden Hypothese nicht eigenständig neu verifizierte Quelldaten. Er wird nicht als widerspruchsfreier normaler Eingabegoldfall oder eigenständiger monetärer Fehler behauptet. Ebenso darf bereits bereinigte MFA-Referenzfläche nicht erneut um dieselben Komponenten reduziert werden. Quellenprüfung und Projektion müssen Brutto, Referenz, Union und notwendige Wege eindeutig festlegen.

> „Verkaufs-, Schau- und Lagerflächen sind nicht förderfähig und sind nicht Teil der Flächenreferenz.“
> o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf, PDF-Seite 2.

> „Auch nicht genutzte Flächen zwischen Folientunneln oder Glashäusern sind keine landwirtschaftlichen Nutzflächen und daher nicht teilnahmefähig.“
> o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf, PDF-Seite 2.

> „Die zur Bewirtschaftung erforderlichen Gangflächen sind jedoch – auf das nötige Ausmaß beschränkt – Teil der förderfähigen Fläche.“
> o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf, PDF-Seite 2.

Native Fälle: `o6_13-two-area-components-disjoint`, `o6_13-two-area-components-overlapping`.

### O613-MEASURE-04: Andere Anmeldung und tatsächlich relevante weitere Flächenprämie sind verschiedene Tatsachen

Die aktuelle Kombinationstabelle hat für13 keine Partner. Merkblatt4 und SRL68 verbieten eine weitere Prämie auf derselben Einzelfläche sowohl beiA als auch beiGA; Fußnote2 ist zusätzlich spezifisch auf Topf-/Substratkultur begrenzt. Die normalen negativen Kombinationstests prüfen gleichzeitig als relevant vorgelegte Flächentitel; sie behaupten keine tatsächlich bewilligte oder ausgezahlte zweite Prämie und prüfen nicht die eigenständige Förderfähigkeit des anderen Programms. Ein gesonderter Kontext auf gewachsenem BodenA enthält nur eine andere nominale Anmeldung ohne bekannte weitere Prämie oder passenden Anspruch auf dieser Fläche. Unter dieser engen Anmeldungslesart erzeugt native trotzdem eine Kollision:1 statt0. Derselbe Input könnte einen tatsächlich relevanten konkurrierenden Prämienanspruch ausdrücken, dann ist die Diagnose korrekt. Bedeutet other_measures_on_parcel bereits einen qualifizierten konkurrierenden Anspruch bzw. eine rechtlich verbotene Flächenkombination, liegt der negative Kontext außerhalb dieses stärkeren vorbereiteten Vertrags. Deshalb bleibt er source_only_other_premium_qualification, kein gewöhnlicher Goldfehler. FürGA wird keine Ausnahme vom speziellen Fußnotenverbot erfunden. Andere Maßnahmen auf anderen Flächen bleiben in einer echten Gegenkontrolle möglich.

> „Die Prämie ist auf der Einzelfläche mit keiner anderen Prämie kombinierbar.“
> o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf, PDF-Seite 4.

> „Die Prämie ist auf der Einzelfläche mit keiner anderen Prämie kombinierbar.“
> 20241011_srl_oepul_2023.pdf, PDF-Seite 68.

> „2) Flächen im geschützten Anbau in Topf- oder Substratkultur sind mit keiner anderen Maßnahme kombinierbar“
> 20241011_srl_oepul_2023_anhaenge.pdf, PDF-Seite 103.

Native Fälle: `o6_13-actual-other-premium-A-o6_11`, `o6_13-known-other-declaration-no-actual-premium`, `o6_13-other-measure-only-other-parcel`.

### O613-MEASURE-05: AGES-, Raten-, Ersatz- und Aufzeichnungsbefunde sind vorbereitete Tatsachen

Die drei positiven Anrechnungsvoraussetzungen werden nativ tatsächlich geprüft, und das aktuelle Förderjahr wird berücksichtigt. Die Quellen enthalten jedoch keine konkrete Produktliste mit überprüfbaren Handelsprodukten, Kulturindikationen oder Aufwandmengen. Alle Positivkontrollen setzen diese Tatsachen abstrakt und ausdrücklich voraus. Die symbolische Organismenbezeichnung ist keine Behauptung eines echten registrierten Produkts oder eines erfolgten Liveabgleichs. Tatsächliche Hummelbestäubung wird mit fachlich negativen Register-/Raten-/Ersatzbefunden ausgeschlossen. Ein künstlicher Bestäubungs-Kreuzflagfall prüft ausschließlich die technische Priorität der Rolle; er behauptet keine fiktive Hummelzulassung. Ebenso beweist ein boolescher Belegbefund nicht, dass die Policy Dokumente selbst gelesen hat. Gleichwertige manuelle Aufzeichnungen werden entsprechend der Quelle akzeptiert, weil ausschließlich der erforderliche Inhalt geprüft wird und kein Pflichtformat existiert. Die Herkunft und Verlässlichkeit aller vorbereiteten Befunde muss im übergeordneten Aufbereitungsvertrag klar sein; dies ist keine zusätzliche feste Geldsanktion und kein neuer negativer Modellfall.

> „Als Nützlingseinsatz im Sinne der Maßnahme gilt ein Einsatz von Organismen gemäß Aufwandsmengen im AGES-Pflanzenschutzmittelregister des Bundesamts für Ernährungssicherheit in zumindest einem Gewächshaus oder Folientunnel.“
> o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf, PDF-Seite 2.

> „Anrechenbar sind nur Anwendungen, die einen Pflanzenschutzmitteleinsatz ersetzen.“
> o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf, PDF-Seite 2.

> „Über Art und Menge der eingesetzten Organismen, Belege über Zukauf, Grund und Ziel sowie Datum des Einsatzes sind schlagbezogene Aufzeichnungen zu führen.“
> o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf, PDF-Seite 2.

Native Fälle: `o6_13-known-creditable-current-application`, `o6_13-known-organism-not-registered`, `o6_13-known-register-rate-not-followed`, `o6_13-known-no-PSM-replacement`, `o6_13-actual-hummel-pollination-not-creditable`, `o6_13-technical-pollination-role-with-positiveflags`, `o6_13-record-format-manual-equivalent-contents`.

## Bereits richtige Verbraucher

Die Mitgliedschaft in einer Erzeugerorganisation mit einschlägigem operationellem Organismenprogramm sperrt auch dann, wenn der einzelne Betrieb keine Abgeltung erhält. Der vorbereitete gemeinsame Befund umfasst beide Voraussetzungen; individuelle Zahlung darf dieses Flag nicht ersetzen.

Befestigte Glas-, Folien- und Kunststoffgewächshäuser sowie tatsächliche unbefestigte Folientunnel werden erkannt. Gewachsener Boden, Töpfe, Substrat und Container sind berücksichtigt. NUE wählt die Schläge aus, A/GA und der tatsächliche Stand am 1. April werden geprüft. Notwendige Gänge bleiben in der Bruttofläche; nur überschüssige Anteile werden abgezogen.

Register-, Raten-, Ersatz- und aktuelle Jahresbefunde werden tatsächlich verbraucht. Bekannt fehlende Voraussetzungen schließen die Anrechnung aus. Für datierte aktuelle Records erzeugen bekannte inhaltliche Aufzeichnungslücken die tatsächlich ausgegebenen DOC-Diagnosen; die sieben zusätzlichen Integrationsabfragen bestätigen diesen Aufrufweg. Gleichwertige manuelle Records sind zulässig.

Vier frische Hauptentscheidungen für Boden, Topf, Substrat und Container liefern bei abstrakt positiv vorbereiteten Quellenfakten jeweils 2160 EUR und keine Diagnosen. Root besitzt die vollständigen Geldorakel. Hier wird keine tatsächliche Produktregistrierung oder behördliche Auszahlung behauptet. Die Sanktionsstufe ist ein anderer Eingang; lokale Mängel werden nicht in willkürliche vollständige Kürzungen umgerechnet.

Die tatsächliche Vertragsannahme A06 wird eingehalten: land.total_area_ha bezeichnet §25-Fläche ohne GA; GA steht gesondert in minimum_size_additional_area_ha. Geschützte Nettofläche wird separat geführt. System- und Stichtagsfälle wurden ohne Doppelzählung vorbereitet. A01 zur Einzelflächenvollabdeckung und zur Union mehrerer Teilanwendungen bleibt bei Root ausdrücklich qualifiziert.

## Exakte Regelmatrix

| Historische ID | Stand | Tatsächlicher Verbraucher / Grenze |
|---|---|---|
| `O6_13-ACC-01` | implemented | Der vorbereitete gemeinsame Befund aus EO-Mitgliedschaft und operationellem Organismenprogramm sperrt die Teilnahme. Eigene Bezahlung des Betriebs ist ausdrücklich irrelevant; sie darf nicht zur Verengung dieses Flags führen. |
| `O6_13-ACC-02` | partial | Zumindest eine NUE-codierte passende Struktur mit aktueller anrechenbarer Anwendung wird verbraucht. Andere flächenbezogene Förderbedingungen und netto geeignete Produktionsfläche steuern diesen Mindesthelper nicht. Die lokale Anzeige wird von der tatsächlich zusätzlich begrenzten Gesamtentscheidung getrennt. |
| `O6_13-ELIG-01` | implemented | Befestigtes Gewächshaus mit Folie/Glas/Kunststoff und unbefestigter Folientunnel werden erkannt; Boden, Töpfe, Substrat und Container sind abgedeckt. Tatsächlich vorhandene Bedeckung und Nutzungsrolle müssen zum deklarierten Strukturtyp passen. |
| `O6_13-ELIG-02` | partial | Verkaufs-, Schau- und Lagerkomponenten werden tatsächlich abgezogen. Die Kontrollen deklarieren Brutto-Kandidatenfläche und disjunkte gemessene Teilflächen. Schon bereinigte Referenzfläche oder überlappende Komponentengeometrie benötigt einen anderen vorbereiteten Vertrag. |
| `O6_13-ELIG-03` | implemented | Bekannt ungenutzte Zwischenflächen werden aus der Brutto-Kandidatenfläche abgezogen. Weder eine aktuelle Nutzung noch eine zusätzliche Förderfähigkeit wird aus unbekannten Geometrien erfunden. |
| `O6_13-ELIG-04` | implemented | Notwendige Gänge bleiben innerhalb der bereits brutto angegebenen Fläche; nur überschüssige Gänge werden abgezogen. Der notwendige Ganganteil wird zu Recht nicht nochmals hinzuaddiert. |
| `O6_13-OBL-01` | implemented | Registereintrag und registergemäße Aufwandsmenge werden zusammen mit aktuellem Förderjahr und PSM-Ersatz tatsächlich verbraucht. AGES-Produkt-/Kultur-/Anwendungsprüfung ist ein positiver vorgelagerter Befund, kein im Paket vorhandener Liveabgleich. |
| `O6_13-OBL-02` | implemented | Nur die positiv bekannte Ersetzung eines PSM-Einsatzes erlaubt die Anrechnung. Eine bloße Organismenfreisetzung oder Bestäubung genügt nicht. Es wird kein fiktiv real zugelassenes Produkt erfunden. |
| `O6_13-OBL-03` | implemented | Tatsächliche Hummelbestäubung ist mit nicht vorhandener Register-/Raten-/Ersatzvoraussetzung nicht anrechenbar. Ein gesonderter Kreuzflagtest ist ausschließlich technischer Stress; die Bestäubungsrolle hat auch dort Vorrang. |
| `O6_13-DOC-01` | partial | Art, Menge, Zukaufsbeleg, Grund, Ziel und Datum sowie bekannte Schlagbezogenheit haben Verbraucher. Fehlendes Datum wird zwar im Feldhelper erkannt, der aktuelle Diagnosepfad benötigt aber selbst das Datum zum Jahresbezug. Bekannte undatierte aktuelle Aufzeichnung ist daher eine bedingte Jahres-/Nachweisgrenze, kein globales fehlend→Verstoß-Orakel. |
| `O6_13-DOC-02` | implemented | Die Vorlage ist keine Zugangsvoraussetzung. Erforderliche Inhalte werden ohne Formatmerkmal geprüft; gleichwertige manuelle Aufzeichnungen sind unter demselben inhaltlichen Vertrag zulässig. Tatsächliche Dokumente werden nicht von der Policy selbst gelesen. |
| `O6_13-APP-03` | implemented | Nur Code NUE bildet die für die Maßnahme betrachtete Schlagmenge. Groß-/Kleinschreibung und alternative Codes werden nicht heimlich normalisiert; Fehlcodierung ist von tatsächlicher Anwendung getrennt. |
| `O6_13-APP-04` | implemented | A und GA sind tatsächlich zugelassen; eine andere deklarierte Feldstücksnutzungsart erhält die lokale Diagnose. Dies erzwingt keine zusätzliche Kulturartenliste aus anderen Maßnahmen. |
| `O6_13-APP-05` | implemented | Gewachsener Boden wird A, Töpfe/Substrat/Container werden GA zugeordnet. Bei Bruttoflächenrechnungen und A06-Betriebsgröße werden GA-Anteile gesondert ausgewiesen, nicht doppelt gezählt. |
| `O6_13-APP-06` | implemented | Bei wechselnder Bewirtschaftung steuert der bekannte Stand am 1.April die erwartete Nutzungsart; davor oder später anderes System ändert die Einstufung nicht. Herkunft und tatsächliches Stichtagsdatum sind vorbereitete Fakten. |
| `O6_13-COMB-01` | partial | Die aktuelle Zeile/Spalte13 hat keine Kombinationspartner. Tatsächlich gleichzeitig relevante andere Flächenprämien kollidieren bei A und GA. Das speziell auf Topf/Substrat begrenzte Fußnotenverbot wird nicht aus12 übernommen oder pauschal auf jede andere betriebliche Teilnahme ausgeweitet. Bloße andere Anmeldung ohne tatsächliche weitere Flächenprämie benötigt einen geklärten Eingabevertrag. Die Abfragen behaupten keine tatsächlich bewilligte zweite Prämie und prüfen deren eigenständige Programmbedingungen nicht. |

## Eingabekonstruktion und native Kontrolle

Die vollständigen Inputs und lokalen Sollwerte wurden vor Ausführung gespeichert. Vor dem ersten 91er-Replay wurde nur die begleitende Fläche des getrennten Weinschlags an seine tatsächliche Rolle angepasst; Query und Sollwert änderten sich nicht. Nach vollständiger Definition aller 91 Ergebnisse wurden sieben Quellkontrollen derselben Tatsachen auf die ausgegebenen DOC-/OBL-Diagnosen ergänzt. Alle 98 finalen Fälle wurden anschließend vollständig neu ausgeführt. Die vorherigen Part-SHAs und der genaue Umfang dieser beiden Schritte sind dokumentiert. Es gab keine nachträgliche Änderung eines lokalen Sollwerts, um eine Beobachtung passend zu machen.

Verwendet wurden der exakt gebundene `/tmp/issue-51-review-opa`, `--strict-builtin-errors`, 10s OPA-/20s Prozessgrenzen und die vollständigen ursprünglichen Verzeichnisse `workspace/policy` und `workspace/data`. Kein Policyumbau, kein Flattening, keine Typnormalisierung. Queries liegen unter `data.oepul.o6_13`, Rohdaten unter `data.o6_13`.

Die begrenzte Eingabekontrolle nutzt unverändertes Canonical und die tatsächlichen 23 Profilvorschläge. Notwendige Elternobjekte wie farm.oepul folgen nur aus deklarierten Kindpfaden. Vollständigkeit, Wahrheit vorgelagerter Nachweise und disjunkte Geometrie werden dadurch nicht automatisch bewiesen. Unicode-Quellzitate bleiben erhalten; der Literalvergleich normalisiert ausschließlich Leerraum und weiche Trennzeichen.

Abschlussprüfung: 1862 Enumwerte und 15100 vorhandene Typwerte ohne Abweichung; 332 Zitatvorkommen / 33 einzigartige Zitate vollständig literal belegt; 29 Codeanker und 9 Lesebereiche gültig. OPA-Hash entspricht dem historischen Run.

JSON-Freeze: `ddd7779d582f703072bf86aec5b4ced55fbe1512352676e21331ae9c61952acd`. Vollständige Originalausgaben, Quellanker, Codebindungen, Kontextpaare und Leseprotokoll stehen in `measure.json`. Unabhängige Root-/QA-Abnahme steht noch aus.
