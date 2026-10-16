# o6_12 – Insektizidverzicht: fachliche Domänenprüfung

Run `v2-o6_12-opus-5.5-high-20261009`, Rohsnapshot `e009eed4a83ff076b26eba33ac433ac2b0642621`; aktueller Run 14/26. Dieser Teil besitzt exakt 30 historische Regel-IDs. Root sammelt die fünf Teile erst nach deren Einfrieren und unabhängiger QA.

**165 native Fälle,165 definierte Ergebnisse,149 erfüllte lokale Sollwerte.** Neun abweichende lokale Checks gehören zu vier konkreten Familien. Sieben weitere sind ausdrücklich Quellenqualifikationen oder bedingte Aufzeichnungsverträge. Das sind weder 16 unabhängige Defekte noch eine globale Genauigkeitsquote.

## Originale und tatsächliche Lektüre

Alle vier neuen Originalseiten wurden vollständig persönlich gelesen, einschließlich der vollständigen Tabellen, Warnungen, Aktualisierungen und des Schlussvermerks. Dasselbe gilt für alle sechs tatsächlichen Module mit 1063 Zeilen und alle 17 nummerierten Rohannahmen samt Quellenkonflikten, offenen Fragen und technischen Hinweisen.

Primäroriginal: `sources/oepul/originals/o6_12_insektizidverzicht_wein_obst_hopfen_2026_04.pdf`, SHA-256 `720df07d4aa2fcc42fc8f087ff9e32abdced5be950408c0292f7b3bcf48415b8`.

Acht gemeinsame Originale wurden über exakte Hashes und Dateigrößen an frühere vollständige Lektüren gebunden. Aktuell wurden die vollständigen relevanten Seiten SRL9/10/11/15/16/18/25/37/44/65/67, ATB3/4/7/8/13/14, GSP18/20/23/25 und AnhangL103 erneut gelesen. Das vollständige Original des Rebzikadenhinweises vom 12.06.2026 wurde erneut persönlich gelesen. Tables/QA prüfen dessen Kombinationsbilder; General/Root binden zusätzlich die Übergangsbestimmungen.

Hier ist GSP-AV tatsächlich Teil des historischen Neunerpackets; NAPV fehlt. Andere maßnahmenspezifische Merkblätter und die öffentliche Studienkonvention sind keine nachträglich eingeführten Orakel.

## Konkrete lokale Befunde

### O612-MEASURE-01: Konkrete Schalenfrucht und wörtlicher MFA-Name werden trotz Obststatus ausgeschlossen

Die neue Liste enthält tatsächlich die Sammelposition Andere Schalenfrüchte; diese Verbesserung wird erhalten. Eine positiv identifizierte Pistazienanlage wird jedoch nicht dieser Kategorie zugeordnet. Auch Walnüsse, der im aktuellen Merkblatt ausdrücklich verwendete MFA-Name, ist gegenüber der gespeicherten Singularform Walnuss nicht gelistet. Beide Kontrollen erhalten fruit_crop_not_listed=1 statt 0. Die Kontrollen verwenden veredeltes hochwertiges Pflanzgut; das Prämienverbot für unveredeltes Material wird nicht angegriffen. Anders als im vorherigen Run hängt der Ganzbetriebsverzicht diesmal nicht an der Namensliste: die zwei eigenen Anwendungsprüfungen liefern richtigerweise einen Verstoß. Veredelte Walnuss und Edelkastanie sind in Maßnahme 12 grundsätzlich prämienfähig; der generelle Artenausschluss aus 11 wird nicht importiert. Freie wörtliche Quellnamen und positiv identifizierte Schalenfrüchte sind keine Enumverstöße oder beliebige Tippfehler.

> „Haselnuss sowie andere Schalenfrüchte“
> 20241011_srl_oepul_2023.pdf, PDF-Seite9.

> „als „Walnüsse“ mit dem Code OP beantragt werden und erhalten keine ÖPUL-Prämien.“
> o6_12_insektizidverzicht_wein_obst_hopfen_2026_04.pdf, PDF-Seite3.

Native Fälle: `o6_12-source-fruit-Pistazie`, `o6_12-source-fruit-Walnüsse`.

### O612-MEASURE-02: Nicht gelistetes Obst und unregistrierte Rebfläche erfüllen die Mindestfläche mit

Jeweils 0,40 ha tatsächlich geeignete AT-Kultur plus 0,10 ha ausdrücklich nicht geeignete Kultur ergeben nativ den Erstjahresstatus met statt not_met. Ein zusätzlicher 1 ha-Ackerschlag hält die allgemeine Betriebsgröße unabhängig bei 1,50 ha. Im ersten Fall ist Kaki als physische Frucht positiv bekannt, gehört aber nicht zur geschlossenen ÖPUL-Obstliste und wird von der eigenen Prämienprüfung ausgeschlossen. Im zweiten Fall ist der fehlende Weinkatastereintrag positiv false, und der Prämienverbraucher schließt den Schlag korrekt aus. counts_for_minimum_area verwendet dagegen allein die breite Kulturkategorie, Nutzungsart und AT-Lage. Die Legaldefinition der gezählten Kultur wird nicht übernommen. Es fehlen keine Orts- oder Kulturinformationen. Die aktuelle AT-Filterung und die Grenze 0,50 ha funktionieren in eigenen Kontrollen; die offene A08-Lesart zu Sonstigen Flächen wird nicht durch diesen Gegenfall entschieden.

> „Im ersten Teilnahmejahr müssen in Summe mindestens 0,50 ha Wein-, Obst- oder Hopfenflächen bewirtschaftet werden.“
> o6_12_insektizidverzicht_wein_obst_hopfen_2026_04.pdf, PDF-Seite1.

> „Obstflächen sind Flächen mit den Kulturen Apfel, Aronia und deren verwandte Züchtungen, Birne, Brombeere sowie deren Kreuzungen, Eberesche, Edelkastanie, Feige, Gojibeere, Haselnuss sowie andere Schalenfrüchte, Heidelbeere, Himbeere, Holunder, Johannisbeere, Kirsche, Kiwi, Kornelkirsche, Mandel, Marille, Mispel, Nektarine, Olive, Pflaume, Pfirsich, Preiselbeere, Quitte, Sanddorn, Schlehe, Stachelbeere, Walnuss, Weichsel und Zwetschke.“
> 20241011_srl_oepul_2023.pdf, PDF-Seite9.

> „Weinflächen sind im Weinbaukataster erfasste Flächen, die mit Rebkulturen bestanden sind, nach einem regelmäßigen System angelegt sind und zur Erzeugung von qualitativ hochwertigem Erntegut dienen.“
> gsp-av-fassung-vom-28012026.pdf, PDF-Seite20.

> „Nicht im Weinkataster eingetragene, mit Rebkulturen bestandene Weinflächen sind nicht förderfähig.“
> gsp-av-fassung-vom-28012026.pdf, PDF-Seite23.

Native Fälle: `o6_12-minimum-known-unlisted-fruit`, `o6_12-minimum-known-unregistered-vine`.

### O612-MEASURE-03: BIO-Fungizid und CS-Insektizid werden allein mit PSMCSI als vollständig gemeldet

Bei tatsächlichem flächigem BIO-Fungizid und chemisch-synthetischem Insektizid auf derselben Obstkultur erzeugt has_chem_insecticide alleinCSI. has_bio_only wird bereits durch diesen Insektizidbefund false, ohne dass ein anderer BIO/CS-Code entsteht. Die lokale Zahl fehlender Codes ist 0 statt 1. Das Quellenbeispiel lässt PSMCS für die gemischte Behandlung zu und verlangt bei CS-Insektizid jedenfalls zusätzlichCSI. Für die gezielte Zähldiagnose gelten CSI+BIO oder CSI+CS als ausreichende Kontrollen; es wird keine exklusive zusätzliche Codeart erfunden. BIO+chemisch-synthetisches anderes Mittel mitCS funktioniert. Der eigentliche Insektizidverstoß bleibt korrekt; eine volle Compliance oder feste 100%-Kürzung wird daraus nicht abgeleitet. Kein reales Produkt mit erfundener widersprüchlicher BIO-/CS-Zulassung ist nötig.

> „PSMBIO im Biolandbau zugelassene Pflanzenschutzmittel“
> o6_12_insektizidverzicht_wein_obst_hopfen_2026_04.pdf, PDF-Seite2.

> „Schlag nur der Code PSMCS angegeben wird. Bei Einsatz eines chemisch-synthetischen Insektizids ist jedenfalls die separate Angabe mit dem Code PSMCSI erforderlich.“
> o6_12_insektizidverzicht_wein_obst_hopfen_2026_04.pdf, PDF-Seite3.

Native Fälle: `o6_12-mixed-bio-fungicide-CSinsecticide-PSMCSI`.

### O612-MEASURE-04: Bekannt noch nicht genehmigter Rebzikade-Antrag beendet den Verzicht bereits

Bei einem vollständig eingereichten, ausdrücklich noch unbearbeiteten Antrag reicht nativ approved=null oder ein fehlendes approval-Feld. Nach offengelegter A07 wird nur ein ausdrückliches false ausgeschlossen. So wird der rückzahlungsfreie wirksame Ausstieg in zwei lokalen Kontrollen bereits mit 1 statt 0 bestätigt; eine Anwendung nach der Meldung erzeugt in den beiden Folgekontrollen 0 statt 1 Verstoß. Das Original spricht von genehmigtem vorzeitigem Ausstieg. Antrag, Genehmigung und Wirksamkeit dürfen nicht durch bloßes Fehlen einer Ablehnung gleichgesetzt werden. Es geht um bekannte noch ausstehende Entscheidung, nicht um ein negativ unterstelltes Behördenurteil. Die positiv genehmigten Gegenkontrollen funktionieren: davor bleibt der Verzicht, danach entfällt er, und im 2026-Ausgangsjahr entfällt die gesamte Maßnahmenprämie einschließlich Obst und Hopfen. Die Rückzahlungsfreiheit späterer 2027-Fälle bleibt nach A07 gesondert offen.

> „Bei einem genehmigten vorzeitigen und rückzahlungsfreien Ausstieg wird keine Prämie für die ÖPUL-Maßnahme „Insektizidverzicht Wein, Obst und Hopfen“ im Antragsjahr 2026 gewährt.“
> 2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html, Original vom12.06.2026.

> „Ab dem Ausstieg dürfen chemisch-synthetische Insektizide nach den gesetzlichen Regelungen eingesetzt werden.“
> 2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html, Original vom12.06.2026.

> „Mit dem rückzahlungsfreien Ausstieg endet der ursprüngliche Vertragszeitraum für diese Maßnahme mit Beginn der einzelbetrieblichen Meldung vorzeitig, ohne dass bereits ausbezahlte Maßnahmenprämien aufgrund der nicht erfüllten Mindestlaufzeit zurückgefordert werden.“
> 2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html, Original vom12.06.2026.

Native Fälle: `o6_12-Rebzikade-exit-approval-None`, `o6_12-Rebzikade-postrequest-use-None`, `o6_12-Rebzikade-exit-approval-omit`, `o6_12-Rebzikade-postrequest-use-omit`.

## Quellen-, Evidenz- und Aufzeichnungsgrenzen

### O612-MEASURE-05: Räumliche und zeitliche Deckung der Anordnung ist im engen Wirkstoffvertrag nicht darstellbar

Zwei ausdrücklich bekannte Sachverhalte sind getrennt von unbekannten Fakten: der behandelte Schlag liegt außerhalb des angeordneten Gebiets, beziehungsweise der tatsächliche Einsatz liegt vor Beginn der Anordnung. Unter der engen wörtlichen Lesart von substance_approved_by_order bedeutet true hier lediglich, dass dieser Wirkstofftyp in der Anordnung zugelassen ist; es bestätigt nicht die Deckung der konkreten Anwendung. Unter dieser Lesart fehlt die lokale Verbotsdiagnose:0 statt 1. Gültigkeitsdaten und Zuordnung der betroffenen Schläge sind nicht im Profil; vorhandene Bundesland-/Schaderregerangaben steuern die Freigabe nicht. Falls das Flag bereits eine vollständig geprüfte Deckung der konkreten Anwendung einschließlich Gebiet, Zeitpunkt und Zweck garantieren soll, sind die negativen Szenarien inkonsistente Eingaben außerhalb dieses stärkeren vorbereiteten Vertrags. Sie sind deshalb source_only_missing_order_qualification und keine unbedingten normalen Eingabegoldfälle. Identische Eingabe-/Query-Paare mit positiven vollständig deckenden Quellenkontexten sind ausdrücklich dokumentiert. Die tatsächliche Wirkstoffdeckung und 2026-BIO-Priorität werden in den normalen Positivkontrollen geprüft.

> „Im Falle einer behördlich angeordneten Maßnahme zur Bekämpfung von Schaderregern, wie z. B. der amerikanischen Rebzikade, ist ein Einsatz des behördlich zugelassenen Wirkstoffs zur Bekämpfung zulässig.“
> o6_12_insektizidverzicht_wein_obst_hopfen_2026_04.pdf, PDF-Seite2.

> „Wird hingegen dezidiert der Einsatz eines chemisch-synthetischen Wirkstoffs angeordnet oder stehen keine Bio-Wirkstoffe zur Verfügung, so gilt der Einsatz eines chemisch-synthetischen Wirkstoffs in den betroffenen Gebieten nicht als Verstoß gegen die Förderauflagen.“
> 2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html, Original vom12.06.2026.

> „Die behördliche Anordnung sowie die durchgeführten Maßnahmen am Betrieb sind zu dokumentieren.“
> 2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html, Original vom12.06.2026.

### O612-MEASURE-06: Die offene Stock-Ausnahme A05 benötigt mehr als eine beliebige vorhandene Anordnungs-ID

Die Kauf-/Lagerausnahme bei behördlicher Anordnung ist in den gelieferten Quellen nicht ausdrücklich geregelt und bleibt als A05 offen. Nativ genügt trotzdem die bloße Existenz irgendeiner verknüpften Anordnung. Der bedingte Gegenfall betrifft ausdrücklich aktuellen Bestand, keinen Altbestand: nichtBIO-Stock ist für Wein bestimmt; unter der bekannten Anordnung sind BIO-Alternativen vorhanden, der CS-Wirkstoff ist nicht angeordnet und der konkrete Stockwirkstoff ist nicht gedeckt. EineID allein entfernt die Stockdiagnose (0 statt 1). Produktdeckung des Bestands hat kein eigenes Eingabefeld. Auch hier gilt: garantiert eine vorgelagerte qualifizierte Zuordnung bereits vollständige Deckung, liegt der negative ID-Verweis außerhalb dieses vorbereiteten Vertrags. Der Fall bleibt source_conditional_stock_order_A05, kein harter automatischer Modellfehler aus einer unbelegten Kauffreigabe. Die normale BIO-Ausnahme sowie Mengen- und Aufzeichnungsvoraussetzungen anderer tatsächlich angebauter, rechtmäßig behandelter Kulturen werden erhalten.

> „Nicht nur der Einsatz, sondern auch der Kauf und die Lagerung von Insektiziden (mit Ausnahme der Mittel gemäß der Bio-Verordnung (EU) 2018/848) sind verboten. Für Insektizide, die erlaubterweise in anderen Kulturen eingesetzt werden, gilt dieses Verbot nicht.“
> o6_12_insektizidverzicht_wein_obst_hopfen_2026_04.pdf, PDF-Seite3.

> „Im Falle einer behördlich angeordneten Maßnahme zur Bekämpfung von Schaderregern, wie z. B. der amerikanischen Rebzikade, ist ein Einsatz des behördlich zugelassenen Wirkstoffs zur Bekämpfung zulässig.“
> o6_12_insektizidverzicht_wein_obst_hopfen_2026_04.pdf, PDF-Seite2.

### O612-MEASURE-07: Erweiterte Anwendungshistorien brauchen Vertrags- und Antragsjahresfilter

Zwei Tests erweitern ausdrücklich den vorbereiteten aktuellen Aufzeichnungsvertrag: abgeschlossene Anwendung 2022 vor Vertragsbeginn 2023 sowie alleinigeBIO-Anwendung 2024 in einer vollständig abgeschlossenen 2025-Meldeliste. Die Anwendungen sind tatsächlich erfolgt und die Daten sind gültig; es gibt keine aktuelle Anwendung oder verbleibenden Vorrat. Native werden dennoch der aktuelle Verzicht beziehungsweise ein fehlender aktueller Meldecode diagnostiziert (je 1 statt 0). Die Regeln prüfen Anwendung.date nicht gegen Vertragsbeginn oder Antragsjahr; nur die besondere Rebzikade-Endeausnahme existiert. Ein vorbereiteter ausschließlich aktueller Jahresdatensatz muss diese Archive jedoch nicht enthalten. Daher bleiben beide source_conditional_history_contract. General besitzt die übergreifende zeitliche Vertrags-/Regelausstiegsfamilie; der erste Fall wird dort zugeordnet und nicht als weiterer unabhängiger OBL-Defekt gezählt.

> „Im Vertragszeitraum muss auf der gesamten Wein-, Obst- und Hopfenfläche des Betriebes vollständig auf Insektizide verzichtet werden.“
> o6_12_insektizidverzicht_wein_obst_hopfen_2026_04.pdf, PDF-Seite2.

> „Im Fall eines flächigen Pflanzenschutzmitteleinsatzes besteht bis einschließlich dem Antragsjahr 2025 eine gesonderte Angabeverpflichtung im Mehrfachantrag.“
> o6_12_insektizidverzicht_wein_obst_hopfen_2026_04.pdf, PDF-Seite2.

### O612-MEASURE-08: Vorabmeldung und unverzügliche Streichung bleiben nur Katalogpflicht

Die echte historische ID O612-PSM-03 hat keinen rego_symbol. Planungs-, Kenntnis- und Korrekturzeitpunkte können nicht gespeichert oder geprüft werden. Bei ausdrücklich bekanntem seit Juni aufgegebenem Plan am Ende des abgeschlossenen Jahres erscheint in der allgemeinen Übersicht keine Korrekturpflicht (0 statt 1). Der bestehende spezifische Wert psm_codes_missing bedeutet fehlende Codes und wird nicht zu einer falschen Stale-Code-Diagnose umgedeutet. Derselbe eingegebene PSMCS-Code ohne Anwendungen kann früher im Jahr eine legitime Vorabplanung sein. Die Probe belegt nur die fehlende Workflowqualifikation und ist kein deterministischer normaler Eingabegoldfall.

> „Die Angabe der Codes kann auch im Vorhinein erfolgen, wenn ein entsprechender Pflanzenschutzmitteleinsatz geplant ist. Sobald absehbar ist, dass doch kein Einsatz durchgeführt wird, ist die Codierung zu streichen. Änderungen oder Nachtragungen von Codes haben umgehend zu erfolgen.“
> o6_12_insektizidverzicht_wein_obst_hopfen_2026_04.pdf, PDF-Seite2.

### O612-MEASURE-09: Die besondere BIO-Priorität des Rebzikadenhinweises 2026 wird global rückerstreckt

A04 legt ausdrücklich fest, die Einschränkung des speziellen 2026-Hinweises in allen Jahren anzuwenden. Ein gesonderter bedingter 2025-Fall setzt die tatsächliche allgemeine behördliche Bekämpfung samt positiv zugelassenem Wirkstoff und voller Anwendungsdeckung voraus. Der CS-Wirkstoff ist dabei zugelassen, jedoch nicht dezidiert angeordnet; BIO-Alternativen existieren. Nach der allgemeinen MB/SRL-Wirkstoffausnahme wäre die Anwendung zulässig, während native aufgrund der rückerstreckten 2026-Priorität ein Verstoß erscheint. Diese Abweichung ist ausdrücklich source_conditional_authority_temporal_A04. Sie entscheidet keine historische kommerzielle Zulassung und behauptet kein unbedingtes Rechtsgold. Für den tatsächlich räumlich/zeitlich einschlägigen 2026-Rebzikadenfall funktionieren Priorität und alternative Freigaben.

> „Im Falle einer behördlich angeordneten Maßnahme zur Bekämpfung von Schaderregern, wie z. B. der amerikanischen Rebzikade, ist ein Einsatz des behördlich zugelassenen Wirkstoffs zur Bekämpfung zulässig.“
> o6_12_insektizidverzicht_wein_obst_hopfen_2026_04.pdf, PDF-Seite2.

> „Wird hingegen dezidiert der Einsatz eines chemisch-synthetischen Wirkstoffs angeordnet oder stehen keine Bio-Wirkstoffe zur Verfügung, so gilt der Einsatz eines chemisch-synthetischen Wirkstoffs in den betroffenen Gebieten nicht als Verstoß gegen die Förderauflagen.“
> 2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html, Original vom12.06.2026.

> „Die behördliche Anordnung sowie die durchgeführten Maßnahmen am Betrieb sind zu dokumentieren.“
> 2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html, Original vom12.06.2026.

### O612-MEASURE-10: Merkblattende 2026 und weiterhin geltende formale PSM-Angabe sind nicht aufgelöst

Das tatsächlich gelieferte neue MB3 beendet die PSM-Codierung 2026. Die ebenfalls tatsächlich gelieferte formalhöhere GSP-AV §34 Abs 2 Z12 litf verlangt weiterhin die Angabe bei 70-10 für Obst/Hopfen/Wein; SRL1.12.1.3 bewertet sie als inhaltliche Auflage. General/Root/QA lesen zusätzlich die Übergangsbestimmungen§242; die konkrete Abhängigkeit ist dort gebunden. Native entscheidet nach A01 zugunsten des Merkblatts. Die 2026-Probe beschreibt deshalb nur native_MB_priority_A01; sie ist kein unmarkiertes Rechtsgold und keine stillschweigende Aufhebung der höheren Norm. Bei der tatsächlichen 2026-Rebzikadenanordnung verlangt das aktuelle Spezialoriginal außerdem nur Betriebsdokumentation, keine AMA-Übermittlung. A02 verallgemeinert dies auf das Ende aller Uploadpflichten 2026; für andere Anordnungen bleibt diese Reichweite offen. Die Quelle macht eine fehlende Meldung sanktionsrelevant, bestimmt daraus aber keine automatische 100%-Kürzung.

> „Ab dem Antragsjahr 2026 entfallen die Regelungen zur PSM-Codierung und es müssen keine Pflanzenschutzmitteleinsätze mehr im Mehrfachantrag erfasst werden.“
> o6_12_insektizidverzicht_wein_obst_hopfen_2026_04.pdf, PDF-Seite3.

> „der Fördermaßnahmen 70-09 und 70-10 bei Obst-, Hopfen- und Weinflächen“
> gsp-av-fassung-vom-28012026.pdf, PDF-Seite25.

> „anzugeben ist, ob und welche Art von Pflanzenschutzmitteln auf der Fläche verwendet werden“
> gsp-av-fassung-vom-28012026.pdf, PDF-Seite25.

> „Die Angabe betreffend die Verwendung von Pflanzenschutzmitteln gemäß § 34 Abs. 2 Z 12 lit. f GSP- AV wird als inhaltliche Bewirtschaftungsauflage in den genannten Maßnahmen gewertet.“
> 20241011_srl_oepul_2023.pdf, PDF-Seite25.

### O612-MEASURE-11: Die reine Antragsdatumprüfung beweist noch keinen rechtzeitigen BIO-Vertragswechsel

Die native Funktion prüft requested und application_date<=31.12.2025. Die SRL nennt dagegen spätestens Vertragswechsel 31.12.2025 mit Maßnahmenantrag des Vorjahres; ATB13 nennt ebenfalls den letzten Vertragswechsel 2025 und MB3 Umstieg bis 31.12.2025. Antrag, tatsächlicher Wirksamkeitsbeginn und Fortführung der höherwertigen Verpflichtungen sind verschiedene Tatsachen. Eine Ende 2025-Antragskontrolle wird daher nur als native_application_deadline_reading bezeichnet. Der 2026-Antrag ist nach beiden Lesarten zu spät; der 2024-Antrag passt grundsätzlich in beide. Die zulässige getrennte BIO-Acker-/Grünlandausnahme und die weiter verbotene VollBIO-Kombination funktionieren; ein bloßer Wechselwunsch hebt diese Kollision im aktuellen Run nicht auf.

> „Während des Vertragszeitraumes kann mit spätestem Vertragswechsel am 31.12.2025 mit Maßnahmenantrag des jeweiligen Vorjahres eine beantragte Maßnahme in eine bestimmte andere, höherwertige Maßnahme umgewandelt werden.“
> 20241011_srl_oepul_2023.pdf, PDF-Seite15.

> „Während des Vertragszeitraumes kann mit spätestem Vertragswechsel am 31. Dezember 2025 mittels Maßnahmenantrag des jeweiligen Mehrfachantrages eine beantragte Maßnahme in eine bestimmte andere, höherwertige Maßnahme umgewandelt werden.“
> o6_allgemeine_teilnahmebedingungen_2026_04.pdf, PDF-Seite13.

> „Während der Laufzeit der Maßnahme kann bis spätestens am 31. Dezember 2025 in die Maßnahme „Biologische Wirtschaftsweise“ umgestiegen werden.“
> o6_12_insektizidverzicht_wein_obst_hopfen_2026_04.pdf, PDF-Seite3.

### O612-MEASURE-12: Vorgewendebreite und vollständige Dauerkulturqualifikation haben keinen Verbraucher

Die echte historische ID O612-DEF-06 besitzt keinen rego_symbol. Insbesondere die maximal 10 m breite unmittelbar angrenzende Vorgewendefläche mit räumlicher/organisatorischer Einheit wird nicht im Profil abgebildet. Positivfälle setzen tatsächliche regelkonforme Dauerkulturen mit hochwertigem Pflanzgut, regelmäßigem System und passender Geometrie voraus; das boolean properly_planted ist kein eigenständiger Geometriebeweis. Es wird kein nicht deklariertes Geometriefeld erfunden und kein deterministischer Gegenfall aus fehlender Information konstruiert. Dies bleibt eine statisch belegte Quellenabdeckungslücke.

> „Dauer- und Spezialkulturen können als Vorgewende eine unmittelbar an die Kultur angrenzende Fläche von maximal 10 m Breite, die zwar nicht mit einer Kultur bestanden ist, aber mit der dieser eine räumliche und organisatorische Einheit bildet, beinhalten.“
> gsp-av-fassung-vom-28012026.pdf, PDF-Seite20.

## Bereits richtige Verbraucher und Stufengrenzen

Die Quellenkontrollen erhalten die erste Mindestteilnahmegrenze, deren aktuellen AT-Filter, die bekannte historische Erstjahresfläche und Schnittwein. Die ausdrückliche Rebschulenausnahme und die Prämienausschlüsse für Reb-/Baumschulen sind belegt. Für Baumschulen beschreiben Bann- und Mindestflächenhelper dagegen nur die offengelegte A03-Bereichskonvention; ihre Rechtsreichweite bleibt offen. Der Verzicht gilt tatsächlich auch ohne Einzelanmeldung, aufOP-Flächen und nach offengelegter Lesart auf Sonstigen Wein-/Spezialkulturflächen. Die Namensliste begrenzt diesmal nur die Prämieneignung; der Verzicht wird dadurch nicht entfernt.

Nur der positiv bestätigte BIO-Befund gewährt die Ausnahme für Anwendung und Bestand. Ein PSMBIO-Code schafft keine Zulassung. Die Positivfälle stipulieren fachlich verifizierte Klassen und Anwendungsbefunde als vorbereitete Tatsachen; sie behaupten keinen erfundenen echten Produktregisterabruf oder Handelsnamen. Registryherkunft, rechtmäßige andere Kultur, Mengenplausibilität sowie BIO-Trennung bleiben eigene Nachweisvoraussetzungen.

Im tatsächlich passenden 2026-Anordnungsfall werden zugelassener Wirkstoff, expliziterCS-Auftrag beziehungsweise fehlendeBIO-Alternativen und Betriebsdokumentation verbraucht. Der Spezialhinweis verlangt keine AMA-Übermittlung. Bei tatsächlich genehmigtem Ausstieg funktionieren die Anwendung davor/danach und der Verlust der gesamten 2026-Maßnahmenprämie einschließlich Obst/Hopfen.

Die gewöhnliche BIO-/CS-Mischmeldung, separateCSI, direkteOP-Pflicht für unveredeltesObst und Kombinationshinweise sind vorhanden. VeredelteWalnuss/Edelkastanie sind in Maßnahme 12 grundsätzlich erlaubt; ein Verbot aus 11 wird nicht importiert. Der Organismenfaktor 0,5 ist eine tatsächliche Schnittstelle, keine selbst berechnete Zahlung eines anderen Maßnahmenlaufs.

Lokale Regelverstöße und fehlendeCodes werden von der behördlichen Einstufung und dem eigentlichen Zahlungsmodul getrennt geprüft. Es wird keine feste 100%-Sanktion erfunden. Root erhält die tatsächlichen Zahlungssperren, das Schätzungslabel und die positiven Geldkontrollen; General besitzt Wiedereinstieg 04 sowie Geografie und regulären/zeitlichen Vertragsausstieg.

## Exakte Regelmatrix

| Historische ID | Stand | Verbraucher / Grenze |
|---|---|---|
| `O612-DEF-01` | implemented | Schnittweingarten zählt als Wein zur Mindestfläche und behält den Insektizidverzicht. Beide Verbraucher sind nativ kontrolliert. |
| `O612-DEF-02` | partial | Rebschulen sind laut MB ausdrücklich keine Weinfläche; der native Ausschluss bei Verzicht und Mindestfläche ist dafür belegt. Der Prämienausschluss für Reb- und Baumschulen ist ebenfalls ausdrücklich belegt. Die zusätzliche Übertragung des Baumschul-Prämienausschlusses auf Ganzbetriebsverzicht und gezählte WFH-/Obstfläche ist dagegen die offengelegte A03-Bereichskonvention und bleibt als Quellenlesart offen. Die beiden Baumschulproben beschreiben nur diesen tatsächlichen Helpervertrag. |
| `O612-DEF-03` | partial | Die neue Sammelposition Andere Schalenfrüchte ist vorhanden. Eine positiv identifizierte Pistazie und der wörtliche aktuelle MFA-Name Walnüsse verlieren dennoch die Prämieneignung. Der Verzicht hängt diesmal korrekt nicht an dieser Namensliste. |
| `O612-DEF-04` | partial | Bekannt fehlender Weinkatastereintrag schließt die Prämie korrekt aus. Die Fläche zählt jedoch weiter zur Mindestteilnahme. Tatsächliches regelmäßiges System und Registerherkunft werden nicht selbst geprüft. |
| `O612-DEF-05` | implemented | Die Codes S, WI und WT werden im Prämienverbraucher geprüft. Die negativen Kultur-/Nutzungscode-Paarungen sind ausdrücklich als Konstruktion der Eingabegrenze gekennzeichnet. |
| `O612-DEF-06` | catalog_only | Die historische ID besitzt keinen rego_symbol. Dauernde Kultur, regelmäßiges System und Vorgewendeeinheit mit maximal 10 m haben keine eigenen Prüfmerkmale. Positivfälle setzen ihre tatsächliche Erfüllung voraus. |
| `O612-ACCESS-01` | partial | 0,50 ha, AT-Lage und erster Verpflichtungsjahresbezug haben Verbraucher; später wird die bekannte Erstjahresfläche verwendet. Nicht gelistetes Obst und bekannt unregistrierte Rebfläche zählen trotz eigener Prämienausschlüsse mit. A08 zu Sonstigen Flächen bleibt offen. Der Baumschul-Helperwert0 wird nur als native A03-Bereichskonvention geführt; aus dem reinen Prämienausschluss folgt er nicht unabhängig. |
| `O612-COMB-01` | implemented | Volle BIO-Kombination kollidiert; ein tatsächlich getrennter BIO-Ackerteilbetrieb ist möglich. Ein bloßer BIO-Wechselwunsch hebt die Kollision hier nicht auf. |
| `O612-COMB-02` | partial | Der vorbereitete Kulturbereich arable_grassland wird verbraucht; permanent_crops ist nicht ausgenommen. Eigenständige Anlagen, getrennte Bewirtschaftung und Lagerung müssen tatsächlich vorausgeprüft sein. |
| `O612-COMB-03` | implemented | Die vorhandenen Zellen werden auf geeigneten Flächen geprüft: 1A, 2, 10 und 11 sind möglich, 1B und 3 nicht. Tables besitzt die vollständige Originalbild- und Zellenprüfung. |
| `O612-COMB-04` | partial | Die Beschränkung auf Landschaftselemente hat einen tatsächlichen Hinweisverbraucher. Eine eigene Zahlung für Landschaftselemente der Maßnahme 1A wird hier nicht berechnet. |
| `O612-COMB-05` | partial | Der tatsächliche Faktor 0,5 wird bei Teilnahme an 12 ausgegeben. Er ist eine Schnittstelle; eine vollständige Zahlung des anderen Maßnahmenlaufs wird nicht berechnet. |
| `O612-SWITCH-01` | unresolved | Die native Prüfung akzeptiert das Antragsdatum bis 31.12.2025. Die Fristlesart zwischen MB3 und SRL15/ATB13 zu Vertragswechsel und Vorjahresantrag bleibt offen. Ein Antrag 2026 ist nach beiden Lesarten zu spät. |
| `O612-OBL-01` | partial | Der Verzicht gilt auf dem gesamten erkannten Wein-/Obst-/Hopfenbereich auch ohne Einzelanmeldung, mit OP und nach A03 auf Sonstigen Flächen. Erweiterte Anwendungshistorien brauchen einen ausdrücklich begrenzten Aufzeichnungsvertrag. |
| `O612-OBL-02` | implemented | Der bekannte registrierte action_type=insecticide entscheidet. AGES-Klassifizierung ist eine vorgelagerte Tatsache; Produktname und PSM-Code ersetzen sie nicht. |
| `O612-OBL-03` | implemented | Nur eu_2018_848_permitted=true gewährt die BIO-Ausnahme für Anwendung und Bestand. Ein PSMBIO-Code schafft keine Zulassung. Reale Produktgenehmigungen werden nicht erfunden. |
| `O612-OBL-04` | partial | Order-Verweis, positive Wirkstoffdeckung und Dokumentation werden verbraucht. Gebiet, Gültigkeitszeit und Zweck brauchen einen geklärten Eingabevertrag: enger Wirkstoffbefund oder vollständig qualifizierte tatsächliche Anwendung. |
| `O612-OBL-05` | unresolved | Im tatsächlichen 2026-Rebzikadenfall werden expliziter CS-Auftrag oder fehlende BIO-Alternativen und Betriebsdokumentation geprüft. Die globale Rückerstreckung nach A04 bleibt eine zeitliche Quellenlesart. |
| `O612-OBL-06` | partial | BIO-freigegebener Bestand wird ausgenommen; anderer aktueller Bestand grundsätzlich erfasst. Die offene Stock-Ausnahme A05 verwendet bereits irgendeine vorhandene Order-ID. Ihr Produktdeckungsvertrag bleibt ausdrücklich bedingt. |
| `O612-OBL-07` | partial | Bei positiv rechtmäßiger anderer tatsächlich angebauter Kultur müssen Mengenplausibilität und Aufzeichnungen true sein. Rechtmäßigkeit und Kultur werden nicht selbst aus intended_for_other_crops bewiesen. |
| `O612-PSM-01` | partial | Bis 2025 bestehen tatsächliche Codeverbraucher für flächige Anwendungen. Anwendungshistorien haben keinen Antragsjahresfilter; der Gegenfall ist bedingt. Ab 2026 besteht der echte formale Konflikt mit GSP §34. |
| `O612-PSM-02` | partial | BIO plus chemisch-synthetisches anderes Mittel wird korrekt mit CS gemeldet. Bei BIO-Fungizid plus CS-Insektizid genügt nativ allein CSI; die weitere BIO-/CS-Meldung fehlt. Der Anwendungsverstoß bleibt getrennt. |
| `O612-PSM-03` | catalog_only | Die historische ID besitzt keinen rego_symbol. Planung, Kenntnis und unverzügliche Streichung werden weder im Profil noch in einem Workflowverbraucher dargestellt. |
| `O612-PSM-04` | unresolved | Bis 2025 wird der Upload behördlich angeordneter CS-Insektizidanwendungen geprüft. Der spezielle Hinweis 2026 verlangt nur Betriebsdokumentation; die pauschale Reichweite von A02 auf andere Anordnungen bleibt offen. |
| `O612-PSM-05` | unresolved | Native folgt MB3 und beendet die Codierung 2026. Die gelieferte formalhöhere GSP §34 verlangt die Angabe weiter; General/QA binden zusätzlich §242. Dieser Konflikt wird nicht als Rechtsgold aufgelöst. |
| `O612-PSM-06` | partial | Fehlende Codes erzeugen den tatsächlichen Verstoß psm_codes_missing. Die Quelle macht die Angabe zur inhaltlichen Auflage; ihre behördliche Sanktionsstufe ist ein getrennter Eingang, kein automatischer vollständiger Abzug. |
| `O612-ELIG-02` | implemented | Sonstige Wein-/Spezialkulturfläche ist prämienlos und behält nach offengelegter Ganzbetriebslesart den Verzicht. Maßnahme 12 enthält keinen generellen Walnuss-/Edelkastanienausschluss aus 11. |
| `O612-ELIG-04` | implemented | Unveredeltes Obst wird ausgeschlossen und löst fehlenden OP-Code unmittelbar aus. Ein zusätzliches op_cases-Feld ist nicht erforderlich. Veredelte Walnuss/Edelkastanie bleibt grundsätzlich geeignet. |
| `O612-EXIT-05` | partial | Weinfläche, Beginn 2026, Antragskanal, Begründung und ausdrücklich negative Entscheidung werden geprüft. Fehlende oder null-Genehmigung genügt nach A07 bereits für den wirksamen rückzahlungsfreien Ausstieg; die Quelle sagt genehmigt. |
| `O612-EXIT-06` | partial | Vor tatsächlich genehmigtem Rebzikaden-Ausstieg gilt der Verzicht, danach entfällt er. Ein bekannt noch nicht genehmigter Antrag setzt denselben Befreiungszweig bereits frei. General besitzt Wiedereinstieg 04. |

## Enge Quellenqualifikation nach unabhängiger QA

Der sichere Prämienausschluss von Reb- und Baumschulen wird von ihrer Rolle beim Ganzbetriebsverzicht und der gezählten Mindestfläche getrennt. MB2 nimmt ausdrücklich nur Rebschulen aus der Weinfläche aus; ATB7 belegt den Prämienausschluss beider Schulen. GSP20 zählt Reb-/Baumschulen allgemein zu Dauer-/Spezialkulturen. Die Baumschulwerte 0 bei Bann und Mindestflächenhelper sind deshalb ausschließlich native A03-Konvention, keine unabhängig abgeleiteten Rechtsgoldfälle. DEF02 wird als partial geführt. Alle 165 Inputs, Queries, Erwartungen und nativen Beobachtungen bleiben exakt unverändert; 149 erfüllt/16 abweichend. Es entsteht kein zusätzlicher Modellbefund.

Vorheriger JSON-Freeze: `f7e41f85be24c56be2eace41736136b0793a85f4f9cafcf6a764ffdd999017b3`; vorheriger MD-Freeze: `a688a0de9a698869b18415b83bfe58e8d1dfc7a0ad2be075e1d7e0413802b31c`. Die Revisionsledger bindet den unveränderten nativen Gesamtinhalt über SHA-256 `952d29820f9853254d871466b87eed5e6da59c14e1ae5201e598bc9a79e8e929`.

## Konstruktion, native Ausführung und Freeze

Alle vollständigen Inputs und lokalen Sollwerte wurden vor der Ausführung gespeichert. Vor dem Endfreeze wurde allein der reine Planungsworkflow auf die allgemeine Verstoßübersicht präzisiert; der semantisch andere Wert psm_codes_missing wird nicht als Streichungspflicht umgedeutet. Zusätzlich wurden begleitende Angaben deklarierter/ermittelter Fläche an die bereits vorhandenen Zielschläge angepasst. Queries und Erwartungen der übrigen Fälle blieben gleich. Ein gesonderter älterer Anordnungsfall wurde ausdrücklich als bedingte A04-Lesart ergänzt. Vorheriger Part-SHA und alte/neue Input-/Querybindungen sind in der Korrekturledger enthalten. Anschließend wurden alle 165 finalen Fälle vollständig neu ausgeführt.

Das Replay verwendet `/tmp/issue-51-review-opa`, `--strict-builtin-errors`,10 s OPA-/20 s Prozessgrenzen und die ursprünglichen vollständigen Verzeichnisse `workspace/policy` und `workspace/data`. Keine Policyänderung, kein Flattening, kein Typadapter. Die tatsächliche Queryfamilie liegt unter `data.oepul.o6_12`, Rohdaten unter `data.o6_12`.

Die Konstruktion wird gegen unverändertes Canonical und die tatsächlichen 24 Profilvorschläge geprüft. Der notwendige Objektcontainer oepul folgt ausschließlich aus vorhandenen deklarierten oepul.*-Vorschlagspfaden. Diese begrenzte Prüfung beweist weder Vollständigkeit noch Quellwahrheit. Die Quellzitate behalten Unicode; nur Leerraum und weiche Trennzeichen werden beim Literalvergleich normalisiert.

Abschlusskontrolle: 2560 Enumwerte und 23706 vorhandene Typwerte ohne Abweichung; 893 Zitatvorkommen / 96 einzigartige Zitate literal belegt; 61 Codebindungen und 27 Lesebereiche gültig. OPA-Hash entspricht dem historischen Runtime-Binding.

JSON-Freeze: `e67bb024ffa3591a22b39fd2787acf17ca08d13c5d3a51c9ab5e8fc7fdb82d87`. Vollständige Originalausgaben, positive/negative Kontrollen, Quellenbelege, Codebindungen, externe Kontextpaare und Leseprotokoll stehen in `measure.json`. Unabhängige Root-/QA-Abnahme steht noch aus.
