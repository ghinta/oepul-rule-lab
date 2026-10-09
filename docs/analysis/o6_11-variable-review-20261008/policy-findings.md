# Konkrete Befunde

## Vertrag, Fläche und Wörter

Luna mit gültig aussehendem start_year2023 ohne tatsächlichen Maßnahmenantrag,
Register-/Anwendungshistorie oder aktive Teilnahme liefert eligible/270Euro.
Auch2029 außerhalb Vertragsende2028 liefert270Euro. Späteres Jahr mit0,4ha
wird dagegen als Zugang abgelehnt, obwohl die0,50ha nur im ersten Verpflichtungsjahr
gefordert sind; trotzdem108Euro. Allgemeine Mindestgröße wird ebenfalls jährlich
statt nur im ersten ÖPUL-Jahr geprüft.

Walnuss im Singular liefert270Euro, Walnüsse im Plural0Euro. Beide zählen zur
Luna-Zielfläche, entgegen der Notiz, die eine Nichtanrechnung behauptet.
Opus prüft echte Nutzungsarten genauer, akzeptiert aber fehlende Obst-/Pflanzgut-/Pflege-
/Lage-/Schlagantragsinformationen. Vollständiger Originalname
„Aronia und deren verwandte Züchtungen“ ergibt dagegen keine Obstfläche/0Euro,
weil nur der Kurzname implementiert ist. Eine Fachnormalisierung ist nicht genehmigt.

Opus ohne Antragsdatum/Person/Registerhistorie liefert compliant=true,
contract=true und270Euro. application_date_missing ist berechnet, aber kein
Access-/Prämienblocker. Nach echtem Ausstieg2025 oder bei Jahr2029 wird Betrag0,
contract_valid und compliant bleiben abertrue. Vertragsanzeige ist daher kein
verlässlicher Nachweis aktiver heutiger Teilnahme.

## Register und tatsächliche Ereignisse

Luna erwartet genau „Herbizid“ oder is_herbicide; Opus erwartet genau „herbicide“.
Beim jeweils anderen String wird ein realitätsnah markierter Herbizideinsatz nicht
erkannt. Kein Run holt Register-IDs, Gültigkeit oder aktuellen AGES-Stand ab.
Leere/fehlende Ereignislisten werden nicht als unbekannter Verzicht ausgewiesen.

Luna Zukunftsanwendung2027 wird heute2026 als Verstoß gesehen, eligible/Betrag bleiben
true/270. Opus Zukunftsanwendung2027 am Zaun erzeugt heute2026 einen Verstoß mit270Euro;
fehlendes Datum wird aktuelles Jahr und Stammanwendung als heutiger Verstoß.
Opus prüft den gesamten Vertrag, ohne Host-as_of oder Kenntniszeit der Ereignisse.
Tatsächliche historische Verletzung, heutiger Stand und zukünftiger Plan brauchen
getrennte Ereignis-/Statusverträge.

Ameisensäure: Luna prüft nur exakten deutschen Namen auf Zielschlag; Opus mehrere
Synonyme auch außerhalbZielschlag, bindet dies aber weiterhin an11-Vertragszeit.
Zusätzliche englische Alias-/Inventarverbotsableitung ist keine separate Rechtsquelle.
Das allgemeine Feldproduktionsverbot darf nicht mit dem Maßnahmenscope gleichgesetzt werden.

## Lager, Umstieg und Kombination

Luna99999Einheiten mit permitted_for_other_crops=true ohne tatsächliche Kultur/
Aufzeichnungen sind unbeanstandet. Opus entsprechender Zukunftskauf2027, in_storage=false,
angepasste angebautecrop_category und zwei Plausibilitäts-/Recordbooleans ebenfalls
compliant/270. Zulässiger Einsatz auf der anderen Kultur, Mengengrundlage, Bestand
und Kauf-/Verbrauchszeit sind nicht belegt.

Opus conversion_target=1B und verspätetes conversion_application_date2026-11-01
entfernen den betrieblichen BIO-Konflikt, weil converted_to_organic nur den Zielstring
prüft. Meldung verspäteter Umstieg erscheint, Betrag270 bleibt. Rechtzeitigkeit und
Wirksamkeit im Folgejahr dürfen nicht durch Umstiegsabsicht ersetzt werden.
Luna bestätigt BIO-Konflikt, bleibt aber eligible/270.

Original-AnhangL, PDF103, visuell geprüft: Zeile11 hat1A nurLSE sowie2,10,12.
1B und eigene Diagonale sind leer. Luna-Kurzmatrix ergänzt falsch1B/eigenex und
lässt2/12 weg. Die relevante Opus-Zeile stimmt. [Gepinnter Zeilenabgleich](annex-l-row-11-audit.json)
gibt weder andere Zellen noch die fachliche Wirkung einer Kombination frei.

## MFA-Codes, App und Beträge

Opus Kontrollpaar: fungicider Flächeneinsatz2025 ohneCode ->PSMCS fehlt;
2026 ->keine MFA-Codepflicht. Die zeitliche Aktualisierung vorausgeplanter Codes
bleibt unverbunden. Der Wegfall von Codes beseitigt keine Register-/Verzichtsevidenz.
BIO-/chemische gemischte Einsatzfälle und separate Herbizidcodes bleiben offene Labels.

Die App prüft generic psm_used und shared.parcels[].psm_applications statt
Registerwirkung und Inventar. psm_used=false allein bleibt missing_data, also kein
Beweis des Verzichts. API konsumiert weder die vollständige Luna- noch Opus-Ereigniskette.

Positive Beträge trotz bestätigter Herb-/Kauf-/BIO-Verletzung sind beobachtete
Rechenausgaben. Behördliche Sanktionsstufen, Caps und Kürzungszuordnung werden
nicht erfunden; aktuelles Empfehlungsergebnis benötigt bestätigten oder offen
gekennzeichneten Daten-/Pflichtstatus.
