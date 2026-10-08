# Maßnahmenspezifische Befunde

## Vertrag und heutiger Stand

Luna unbekannte Anwendungs-/Registerhistorie mit participation/Pflanzgutflags liefert
premium_eligible=true, Satz 270. Ungültiger Vertragsbeginn 2026 bei Jahr 2029 ebenfalls.
BIO-Ganzbetriebs-Konflikt lässt combination_allowed undefiniert, premium_eligible bleibt
true. Genehmigter Rebzikaden-Ausstieg erzeugt separaten Nullbetragshelper, ändert
premium_eligible nicht. Die Helper bilden keinen vollständigen aktuellen Vertrag.

Opus ohne Antragsdatum/Person/Register-/Pflegenachweise meldet keine Verletzung und
270 Euro. Ausstieg 2025 blockiert nur Jahr 2025, im aktuellen 2026 werden wieder
270 Euro berechnet. Rebzikaden-Meldung 2026 mit fehlender Genehmigung gilt approved=true,
2026 Betrag 0; 2027 trotz beendendem Ausstieg wieder 270 Euro. Quelle nennt einen
**genehmigten** Ausstieg und Ende des ursprünglichen Vertrags mit der Meldung;
unbekannter Antrag ist keine Bestätigung und spätere Jahre sind nicht erneut aktiv.

## Biologische Mittel und konkrete Anordnung

Quelle unterscheidet aktuellen Wirkungstyp, erlaubte Mittel nach Bio-Verordnung und
behördlich zugelassenen/angeordneten Wirkstoff. Die Register-/Betriebsmittelabfragen
selbst sind nicht implementiert. Luna prüft nur globale Einsatz-/Ausnahmebooleans.
Opus erwartet den technischen String insecticide; eine wirklich datierte Register-
und Produktbindung fehlt. Bei fehlendem product_name und application_date entsteht
kein Verbotsbefund, obwohl effect_type=insecticide/chemical_synthetic/keine Ausnahme
explizit vorliegen. Zukunftsanwendung 2027 erzeugt heute 2026 einen Verstoß plus 270 Euro.

Opus eine Anordnung für OTHER in Tirol, in_designated_area=false, aber
prescribes_chemical_synthetic=true genügt, um beliebiges als authority_ordered_control
markiertes Produkt freizustellen. Lediglich Orderdokumentation fehlt; 270 Euro bleiben.
Kein Pest-, Produkt-, Wirkstoff-, Schlag-, Datums- oder Gebietsjoin verbindet Einsatz
und Anordnung. designated_area_orders/-permitted ist separat und nicht das Gate der
Ausnahme. Die 2026-Mitteilung betrifft ausdrücklich **betroffene Gebiete** in ST/B/NÖ;
eine Modellübernahme derselben Konkretisierung für alle früheren Jahre bleibt offen.

## Lager, Kultur, Umstieg und Codierung

Luna Kauf/Lager eines biologisch erlaubten Mittels wird ohne andere-Kulturflag als
Verstoß gewertet, obwohl das Original beim Lager die Bio-Ausnahme nennt.
Opus Kauf mit permitted_use_in_other_crop/quantity_plausible/records_available=true
ist ohne reale andere Kultur, Zulassung, Menge oder Bestandszeit unbeanstandet.
Keine Boolfreigabe ersetzt konkrete Nachweise.

Opus frei erfundener Name Apfel_DOES_NOT_EXIST gilt über startswith(apfel) als Obst
und erhält 270 Euro. Luna verändert Originalgruppenstrings und bindet sie exakt;
Schnittweingarten/Rebschule/Sonstige müssen ausdrücklich nach amtlicher Nutzungsart
abgegrenzt werden. Walnuss/Edelkastanie haben bei 12 gegenüber 11 keinen besonderen
Prämienausschluss, Pflanzgut-/sonstige Bedingungen bleiben erforderlich.

Opus switch.effective_date=2026-01-01 wird gegen Antragsfrist31.12.2025 abgelehnt.
Damit werden rechtzeitiger Antrag und Wirksamkeit im Folgejahr vermischt. Umgekehrt
switch.effective_date=2025-12-31 ->switch_valid=true, Prämie 12 bleibt 270 Euro.
Die Umstiegsregel wird nur für Rückforderung, nicht als vollständige Vertragsbeendigung
konsumiert. BIO-Teilbetrieb muss wirklich nur Acker/Grünland umfassen.

Luna Bio-Flächeneinsatz bis2025 liefert PSMCS statt PSMBIO; Reporting-/Authorityhelper
sind nicht mit kompletter Compliance verknüpft. Opus lässt PSMCSI andere PSMCS-Angaben
ersetzen, ohne ausdrückliche Originalstelle; Einsätze werden für Codes nicht nach Jahr
gefiltert. Ab2026 Wegfall von Codes/Übermittlung ist vom fortbestehenden tatsächlichen
Anordnungs-/Anwendungsnachweis getrennt.

## Kombinationen und Betrag

Anhang L103 visuell: Zeile12 erlaubt1A nurLSE,2,10 Fußnote3 und11;1B und Diagonaleleer.
Luna ergänzt1B/eigene12 und lässt2weg, obwohl die Rohquelle anders liegt.
Opus relevante Zeile stimmt. Fußnote3 kürzt den Organismen-/Pheromonzuschlag10,
nicht Maßnahme12. [Zeilenabgleich](annex-l-row-12-audit.json) ist keine Gesamtmatrixfreigabe.

Opus 270 Euro trotz bestätigtem Insektizideinsatz/fehlender Orderdokumentation ist ein
beobachteter Rechenbetrag, keine bestätigte Auszahlung. Sanktionen werden separat
behördlich eingegeben. Global force_majeure.recognised nimmt sämtliche Sanktionen/
Kontrollsperren weg, ohne ID-/Jahr-/Pflichtscope; Cap wird aus Brutto abgezogen statt
aus der bereits gekürzten/modulierten Basis. Kürzungszuordnung bleibt fachlich offen.
Acker-Dürreerleichterungen werden nicht automatisch auf Dauerkulturen übertragen.

App bleibt Category C mit generic PSM-Feldern, ohne Bio-/Anordnungs-/Genehmigungsvertrag.
[19 historische OPA-Beobachtungen](policy-probes.json) sind technische Belege und
keine gewünschten Golden-Fachantworten.
