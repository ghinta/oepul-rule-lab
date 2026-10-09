# o6_10: unveränderte Modellnotizen

Sämtliche Modellannahmen sind unbestätigt. Auch nicht einzeln priorisierte Auslegungen müssen vor Übernahme geprüft werden.

## luna: `v2-o6_10-luna-high-20261003`

# Annahmen und offene Punkte

- Das Canonical Farm Profile enthält keine o6_10-Struktur. Die benötigten Eingaben werden deshalb ausschließlich als Vorschläge in `rules/profile_changes.json` geführt; das Canonical Farm Profile wurde nicht verändert.
- Die Regelimplementierung verwendet `land.parcels[].crop.crop_category` als technische Abbildung der Wein-, Obst- und Hopfenflächen. Die tatsächliche AMA-Kulturcodierung und die automatische Hangneigung aus INVEKOS-GIS sind als Eingaben zu liefern.
- Die Maßnahmequelle nennt den optionalen Zuschlag als Anwendung auf zumindest einem Schlag, während die Prämiensätze je Hektar angegeben sind. Die Rego-Berechnung setzt den Zuschlag auf denjenigen teilnahmefähigen Parzellen an, die `surcharge_applied` tragen; die genaue AMA-Flächenabgrenzung bleibt zu verifizieren.
- Die 2026-Trockenheitsmitteilung ist eine zeitlich begrenzte fachliche Abwicklungserleichterung. Sie ersetzt nicht die ordnungsgemäße Anlage und lässt sonstige o6_10-Auflagen unberührt.
- Die vier weiteren 2026-HTML-Hinweise wurden vollständig geprüft. Der Biodiversitätsflächen-Hinweis betrifft UBB/BIO, der Rebzikaden-Hinweis den Insektizidverzicht, und der 12.08.-Hinweis Ackerbegrünung/Acker-Biodiversität; daraus wurde keine zusätzliche o6_10-Regel abgeleitet.
- Die Rechtsgrundlage und der Anhang wurden gezielt auf Maßnahme 2.10, die Obstdefinition und die Kombinationstabelle geprüft. Eine vollständige Regelgewinnung aus sämtlichen übrigen Maßnahmenabschnitten war für o6_10 nicht erforderlich.


## opus: `v2-o6_10-opus-5.5-high-20260925`

# o6_10 – Erosionsschutz Wein, Obst und Hopfen: Annahmen und offene Fragen

Run: `v2-o6_10-opus-5.5-high-20260925` · Modus `discover`

Laut den Informationsblättern sind sie rechtlich unverbindlich (ATB Kap. 1). Bei
Abweichungen gilt daher die Sonderrichtlinie (SRL 2.10, Stand 2024-0.489.174).
Die Regeln bilden beide Quellen ab. Wo der Wortlaut nicht eindeutig ist, gelten die
folgenden Annahmen.

## Eingabemodell

- **A-00 Profilerweiterungen.** Das Canonical Farm Profile enthält weder Angaben zur
  förderwerbenden Person noch Maßnahmen- oder Antragsdaten. Es fehlen auch
  Angaben zur Fahrgassenbegrünung, zu ÖPUL-Codes am Schlag und zu
  Aufzeichnungen. Alle benötigten Felder sind als `add`-Vorschläge in
  `rules/profile_changes.json` erfasst. Die Rego-Regeln verwenden für fehlende
  Felder konservative Defaults über `object.get` (siehe jeweilige Regel).
- **A-01 Hangneigung fehlt.** Ist `slope_percent` `null` bzw. fehlt es, wird 0 %
  angenommen, also die niedrigste Prämienstufe. Eine Terrasse gilt dann nicht als
  anerkannt. Laut Quelle wird die Hangneigung aus INVEKOS-GIS übernommen und ist
  nicht änderbar.
- **A-01b Kulturart.** Primär zählt `permanent_crop.type`. Fehlt das Feld, wird auf
  `crop.crop_category` zurückgegriffen (`vineyard`→Wein, `orchard`→Obst, `hop`→Hopfen).
  Bei Obst wird `crop.crop_name` gegen die Obstliste des Antragsjahres geprüft. Ist
  `crop_name` `null`, gilt die Fläche als Obst.

## Fachliche Mehrdeutigkeiten

- **A-02 Selbstbegrünung vs. bestehende Begrünung.** Das Informationsblatt lässt
  „bereits bestehende Begrünung … ohne Neueinsaat belassen“ zu und erklärt
  gleichzeitig „Selbstbegrünungen sind nicht zulässig“. Die SRL spricht von
  „reine Selbstbegrünungen“. Modelliert wird das so: `establishment_method =
  existing_greening_retained` ist zulässig. Nur `cover_type = self_greening` (reine
  Selbstbegrünung ohne etablierte Begrünungskultur) ist ein Verstoß. Die Abgrenzung
  im Einzelfall bleibt offen.
- **A-03 Terrasse unter 25 % Hangneigung.** Wie eine als Terrasse deklarierte Fläche
  mit weniger als 25 % zu behandeln ist, sagt die Quelle nicht. Sie wird als normale
  Weinfläche geführt: Begrünungspflicht gilt, Prämie nach der Wein-Stufe unter 25 %.
  Sie wird nicht ausgeschlossen.
- **A-04 Kürzung des EOP-Zuschlags: betrieblich oder je Schlag.** Informationsblatt
  und SRL knüpfen an die „Teilnahme (des Betriebes)“ an Maßnahme 12 oder 1B an.
  Anhang L (Fußnote 3) zeigt dagegen einen Prämienabschlag auf der Einzelfläche.
  Umgesetzt ist die betriebliche Lesart über `farm.oepul.participating_measures`.
  Bei Bio-Teilbetrieben wäre auch eine schlagbezogene Kürzung denkbar (offen).
- **A-05 Mindestteilnahmefläche.** Zu den 0,50 ha zählen alle teilnahmefähigen
  Wein-, Obst-, Hopfen- und Terrassenschläge „gemäß Mehrfachantrag“, also auch
  Schläge mit Prämienausschluss (Code OP, Nationalpark, unveredeltes Obst). Nicht
  gezählt werden Flächen außerhalb Österreichs, GLÖZ-Elemente und nicht
  teilnahmefähige Kulturarten.
- **A-06 Frist bei Rodung/Neuauspflanzung.** „8 Wochen nach … Rodung/Neuauspflanzung“
  ist mehrdeutig. Folgt auf eine Rodung eine Neuauspflanzung, beginnt die Frist mit
  der (spätesten) Neuauspflanzung. Sonst beginnt sie mit der Rodung bzw. dem
  Umbruch. In jedem Fall gilt die Obergrenze 1. Oktober desselben Jahres. Liegt ein
  Umbruch nach dem 1. Oktober (außer bei Rodung nach dem 15. September), ist die
  Neuanlage nicht mehr fristgerecht möglich. Das gilt als Verstoß.
- **A-07 Offene Frist nach später Rodung.** Nach einer Rodung nach dem 15. September
  läuft die Frist bis 15. Mai des Folgejahres. Fehlen Ereignisse aus dem Folgejahr,
  wird die Frist als offen ausgewiesen (`pending_reestablishments`), nicht als
  Verstoß. Grundsätzlich gelten die Ereignislisten als vollständige
  Jahresaufzeichnung. Eine fehlende Neuanlage innerhalb der Frist wird als Verstoß
  gewertet, auch wenn das Auswertungsdatum vor dem Fristende liegt.
- **A-08 Bemessungsfläche des Zuschlags.** Der Zuschlag wird in €/ha angegeben.
  Welche Fläche ihm zugrunde liegt, regelt die Quelle nicht ausdrücklich. Angenommen
  wird: Der Zuschlag wird für die Fläche aller mit `EOP` gekennzeichneten, prämienfähigen
  Schläge gewährt, sofern auf mindestens einem Schlag ein anrechenbarer Einsatz
  vorliegt.
- **A-09 Mehrere Kontrollfeststellungen.** Laut ATB 8.2 wird maßnahmenbezogen
  beurteilt. Wie mehrere Feststellungen zu kumulieren sind, bleibt offen. Umgesetzt
  wird die höchste festgestellte Stufe (`max`). Die Sanktionsstufe selbst (Schwere,
  Ausmaß, Dauer, Häufigkeit) ist eine behördliche Bewertung und wird als Eingabe
  (`control_findings[].stage`) übernommen, nicht aus den Verstößen abgeleitet.
- **A-10 Obergrenze für Flächenzahlungen.** Die Obergrenze gilt für die Summe aller
  Flächenzahlungen je Schlag. Wie eine Überschreitung auf die Maßnahmen verteilt
  wird, ist nicht geregelt. Umgesetzt ist eine anteilige Zurechnung:
  Überschreitung × Anteil o6_10 an der Summe. Anwendung ab 2025, weil o6_10 in
  2023 und 2024 nicht eingerechnet wird. Geprüft wird nur die allgemeine
  Obergrenze. Die Sonderobergrenzen (13, 18/19, K20) sind in den Daten erfasst,
  kommen wegen der Kombinationsausschlüsse nach Anhang L auf o6_10-Schlägen aber
  praktisch nicht vor.
- **A-11 Folge unmöglicher Kombinationen.** Anhang L legt nur die prämienmäßige
  Kombinierbarkeit fest. Welche Maßnahme bei einem Konflikt entfällt, ist nicht
  geregelt. Konflikte werden daher nur ausgewiesen (`combination_conflicts`),
  zusammen mit dem Hinweis auf die Korrekturmöglichkeit bis zur
  Auszahlungsmitteilung. Eine Prämie wird nicht automatisch gestrichen.
- **A-12 Ausstieg aus 12 im Jahr 2026 (Rebzikade).** Nach einem genehmigten
  rückzahlungsfreien Ausstieg endet der Vertrag für Maßnahme 12 mit der Meldung,
  und 2026 wird keine Prämie für 12 gewährt. Angenommen wird: Der Betrieb nimmt
  2026 dann nicht mehr an 12 teil, die 50 %-Kürzung des EOP-Zuschlags entfällt
  also. Umsetzung: 12 wird nicht mehr in `participating_measures` geführt. Wird es
  trotz Ausstiegskennzeichen geführt, erscheint ein Hinweis. Offen ist, ob ein
  behördlich angeordneter Insektizideinsatz die Anrechenbarkeit von
  Organismen/Pheromonen („ersetzt einen PSM-Einsatz“) beeinflusst (Coverage
  `N0612-ORDER` = `unresolved`).
- **A-13 Förderwerbende Person.** Fehlen Angaben zur Person, wird eine natürliche
  Person angenommen, die aktiver Landwirt ist und auf eigene Rechnung
  bewirtschaftet. Juristische Personen mit mehr als 25 % Beteiligung von
  Gebietskörperschaften werden wie Gebietskörperschaften behandelt. Für o6_10 sind
  sie nur bis einschließlich 2024 zulässig.
- **A-14 Mindestauszahlung.** Die Regel ist eine Kann-Bestimmung („kann abgesehen
  werden“). Sie wird deshalb nur als Kennzeichen und Hinweis ausgegeben, der Betrag
  wird nicht auf 0 gesetzt.
- **A-15 Dürre 2026, Ernteverpflichtung.** Die Bezirkslisten der Meldungen vom
  05.08. und 12.08.2026 betreffen ausschließlich Ackerkulturen. Sie wurden nicht als
  Daten übernommen, weil o6_10-Flächen Dauerkulturen sind. Die Ernteverpflichtung
  auf Dauerkulturen bleibt unberührt (Mindestbewirtschaftung).
- **A-16 Dürre 2026, Begrünung.** Die Erleichterung („keine Beanstandung“) setzt eine
  ordnungsgemäße Anlage voraus (`properly_established`). Sie gilt nur für die
  Verpflichtungen zur Flächendeckung und zur 50 %-Grenze, nicht für andere Auflagen.
- **A-17 Prämienbänder 2023/2024.** Bis 2024 wird der garantierte Mindestbetrag
  gerechnet und der Höchstbetrag zusätzlich ausgewiesen. Der tatsächlich ausbezahlte
  Satz hing von Budget und Flächen ab und ist nicht rekonstruierbar.
- **A-18 Maßnahmenbezogener OP-Code.** Der konkrete Code für Maßnahme 10 ist in den
  Quellen nicht genannt. Er wird deshalb über `op_excluded_measures` (Maßnahmencode
  „10“) abgebildet, nicht über einen erfundenen Codenamen.

## Nicht abgebildet (bewusst)

- Höhere Gewalt bzw. außergewöhnliche Umstände (§ 6 GSP-AV) sind
  Einzelfallentscheidungen der AMA. Sie sind nur als Regel bzw. Hinweis erfasst,
  mit Ausnahme der automatischen Anerkennung 2026.
- Konditionalitätskürzungen nach VO (EU) 2021/2116 werden nur als Hinweis
  ausgegeben, nicht berechnet.
