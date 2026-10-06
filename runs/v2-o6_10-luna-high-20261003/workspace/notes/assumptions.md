# Annahmen und offene Punkte

- Das Canonical Farm Profile enthält keine o6_10-Struktur. Die benötigten Eingaben werden deshalb ausschließlich als Vorschläge in `rules/profile_changes.json` geführt; das Canonical Farm Profile wurde nicht verändert.
- Die Regelimplementierung verwendet `land.parcels[].crop.crop_category` als technische Abbildung der Wein-, Obst- und Hopfenflächen. Die tatsächliche AMA-Kulturcodierung und die automatische Hangneigung aus INVEKOS-GIS sind als Eingaben zu liefern.
- Die Maßnahmequelle nennt den optionalen Zuschlag als Anwendung auf zumindest einem Schlag, während die Prämiensätze je Hektar angegeben sind. Die Rego-Berechnung setzt den Zuschlag auf denjenigen teilnahmefähigen Parzellen an, die `surcharge_applied` tragen; die genaue AMA-Flächenabgrenzung bleibt zu verifizieren.
- Die 2026-Trockenheitsmitteilung ist eine zeitlich begrenzte fachliche Abwicklungserleichterung. Sie ersetzt nicht die ordnungsgemäße Anlage und lässt sonstige o6_10-Auflagen unberührt.
- Die vier weiteren 2026-HTML-Hinweise wurden vollständig geprüft. Der Biodiversitätsflächen-Hinweis betrifft UBB/BIO, der Rebzikaden-Hinweis den Insektizidverzicht, und der 12.08.-Hinweis Ackerbegrünung/Acker-Biodiversität; daraus wurde keine zusätzliche o6_10-Regel abgeleitet.
- Die Rechtsgrundlage und der Anhang wurden gezielt auf Maßnahme 2.10, die Obstdefinition und die Kombinationstabelle geprüft. Eine vollständige Regelgewinnung aus sämtlichen übrigen Maßnahmenabschnitten war für o6_10 nicht erforderlich.
