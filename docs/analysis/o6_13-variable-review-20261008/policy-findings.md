# Original- und Ausführungsbefunde o6_13

MB1–4 und SRL 68: jährlich mindestens ein konformes Gewächshaus/Folientunnel;
Prämie für flächendeckend eingesetzte Organismen nach tatsächlichem Registeraufwand,
als Ersatz eines PSM-Einsatzes. Hummel-Bestäubung zählt nicht. Art/Menge/Zukauf/Grund/
Ziel/Datum schlagbezogen dokumentieren. Container ausdrücklich zulässig; Verkauf,
Schau/Lager/Zwischenflächen ausgeschlossen, notwendige Gangflächen begrenzt.
Gewachsener BodenA, Topf/SubstratGA, beim Wechsel Stand1.April. NUE je Schlag.
Vier Prämienzeilen2023=2000€/ha, ab2024=2160€/ha fürA/GA entsprechen den Originalen.

Allgemeine Bedingungen5: im ersten ÖPUL-Jahr0,50ha geschützter Anbau unabhängig
von NUE oder vollständig definierte1,50ha; später keine allgemeine Mindestgröße.
Jährlicher Maßnahmenvertrag verlängert sich, ohneNUE endet er und braucht neuen
fristgerechten Antrag; letzter Einstieg2027 ist kein Verbot jeder Verlängerung2028.
Ausstieg im betroffenen Jahr beendet die Gültigkeit. Programmabgeltung beim PO-
Organismeneinsatz schließt unabhängig von individueller Betriebszahlung aus.
MB4/SRL 68: auf Einzelfläche keine andere Prämie. Visuelle Anhang-L-Prüfung: Zeile/
Spalte13 leer, Opus relevante Zellen stimmen. Fußnote2 nennt Topf/Substrat; keine
eigene Konfliktlösung zum eigenständigen MB-/SRL-Verbot. Kein Vollmatrix-Review.

## Reproduzierte historische Luna-Befunde

- Vollständige boolesche Register-/Mengen-/Zukaufs-/PSM-Ersatzbehauptungen reichen
  für2160€, ohne reale Register-/Beleg-/Flächendeckungs-/Person-/Historiennachweise.
- Einsatz2027-05-01 gilt im Jahr2026 und withdrawal_date2026-01-01 wird ignoriert.
- contract_year2028 wird als zu später Einstieg abgelehnt, trotz Fortsetzung.
- 0,4haNUE plus0,2ha nichtbeantragter geschützter Fläche erfüllt Mindestgröße nicht;
  die Quelle verlangt0,50ha geschützte Fläche unabhängig von NUE. Aggregatfläche
  total_area_ha ersetzt die fehlenden vollständig definierten Alternativkomponenten nicht.
- ContainerGA scheitert an geschlossener Medienliste. Ein1.April-Wert überschreibt
  selbst nichtwechselnden Bodenanbau und lässt korrekteA-Fläche scheitern.
- GA/Topfkultur und0%Ernte werden bei BetriebsbezirkBurgenland/Dürreflags akzeptiert;
  die im Modell ausdrücklich offene Gewächshauslesart hindert die Ausführung nicht.
- Einzelobjekt ersetzt die tatsächliche Anwendungsgeschichte. Flächendeckung und
  Menge pro Aufwandfläche nicht geprüft; unvollständige records blockieren hier die
  gesamte ausgewählte Menge, keine fachlich bestätigte Teilflächen-/Sanktionslogik.

## Reproduzierte historische Opus-Befunde

- Bei gültigem Antragsdatum/NUE und Einsatzflags werden unbekannte Person/Lage/
  Pflege/Ernte/Register-ID akzeptiert; Ergebniseligible=true, netto2160€.
- 2026-99-99 gilt als Datum im Förderjahr. Menge-1 gilt als vorhandenes vollständiges
  Aufzeichnungsfeld und die Rate bleibt durch applied_at_register_rate=true erfüllt.
- Fehlender Zukaufsbeleg erzeugt DOC-Verletzung; eligible=true/netto2160 bleiben bei
  sanction_stage=none. Die amtliche Kürzungsstufe wird nicht aus dem Befund abgeleitet.
  Das ist keine fachliche Festlegung, dass jeder Aufzeichnungsmangel100%Kürzung bewirkt.
- Ein zusätzlicher undatierter Einsatz ohne Beleg wird aus der DOC-Prüfung ausgesiebt;
  ein guter Einsatz gibt den Schlag weiter frei. records.kept_per_parcel missing gilt
  nicht als false. Vollständiger tatsächlicher Beleg-/Anwendungssatz muss bestätigt werden.
- Verlängerung mit fehlendem Vorjahres-MFA wird akzeptiert. Unzulässige Übernahme
  nach Frist, über50% und ausdrücklich ohne Genehmigung wird gemeldet, stoppt aber
  einen sonst gültigen eigenen Vertrag/2160€nicht. Der konkrete Übernahme-/Eigener-
  Vertragsscope ist mit Experten festzulegen, keine universale Sperre daraus erfinden.
- sales_area_ha=-1 bei1ha erhöht eligible_area auf2ha und netto auf4320€.
- Fortsetzung2028 mit Vorjahresnachweisen funktioniert; gleiches Muster2029 zahlt
  weiter, ohne Programm-/Quellenstandgrenze. Aktuelles Hostjahr darf nicht frei wählbar sein.
- GA-Dürreflag/Betriebsregion führt trotz0%Ernte zur Freigabe. Schlagbezirk/zulässige
  Kultur/Datum fehlen; die Augustquelle sagt Ackerflächen, GA-/Gewächshausfrage offen.
- Andere Maßnahmeo6_1a auf dem Schlag blockiert0€, obwohl keine tatsächliche andere
  Prämie vorliegt. Die Eingabe braucht Freigabe für Teilnahme- gegenüber Zahlungsscope.
- structure_id/necessary_path_area_ha/quantity_unit sind keine vollständigen Gates;
  Mindeststruktur zähltparcel_id. Any(covers_entire_area) belegt keine echte Geometrie
  und bildet die gemeinsame Flächendeckung mehrerer Teilanwendungen nicht ab.

## Tatsächliche App

Pin5296108: API übernimmt protected_cultivation_area_ha und separate parcels/
beneficials. RegoCategoryC prüft nur, ob eigene Sammlungen nichtleer sind. Leerer
Inputmeldet zwei fehlende Pfade; is_protected_cultivation=false plus bloßer
Hummelstring ergibt keinefehlendenPfade, aber weiter missing_data mit technischer
Limitation. Keine fachliche Freigabe, kein AGES-/Beleg-/Vertrags-/Flächenjoin.
Adapterkatalog kennzeichnet die technischen Pfade und QuellenstandOktober2025.

Alle22 Proben sind technische Beobachtungen unter vollständigen historischen
Policies+Daten, keine gewünschten Golden-Ergebnisse. Verwendete73 Quoten sind
wörtlich geprüft; keine vollständige normative Regel-/Klauselfreigabe. App-E2E und
unabhängige aktuelle Register-/MFA-/Betriebssnapshots bleiben ausstehend.
