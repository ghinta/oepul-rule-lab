# Block 5: Amtliche Projekt-, Rechts- und Ausnahmegrundlage

Stand 08.10.2026 · gezielte Vertiefung nach den Einzelprüfungen · App-Pin
`5296108f5756ef1463c25a49d93d4a346e9b5e9c` · historische Quellenbasis
`7a296d28cb5b92e2758c5a3889c929ea1db60fe5`.

Die gemeinsame technische Grundlage ist ein datierter, einer tatsächlichen
Fläche oder Tiergruppe zugeordneter Beleg. Seine fachliche Bedeutung bleibt
maßnahmenspezifisch: NAT-Bewirtschaftungsauflage, EBW-Indikator, NATA-Plan,
ordnungsrechtliche N2-Auflage, WRRL-Verordnung und individuelle Ausnahme sind
unterschiedliche Verträge. Eine Liste von Projektcodes oder ein allgemeines
Schutzgebiets-/Anerkennungsflag beantwortet diese Anforderungen nicht.

Der Bericht ergänzt die [26 Einzelprüfungen](../sequential-variable-reviews-20261008/README.md),
den [Flächenabgleich](../area-credit-source-review-20261008/README.md) und die
[Block-4-Ereignisse](../material-operations-review-20261008/README.md).
Er bestätigt keine neue Variable, keinen Alias und keine fachliche Aufnahme.

## Vorher / benötigte Ergänzung

| Geprüfter heutiger App-Stand | Was damit belegt wird | Benötigte Ergänzung |
| --- | --- | --- |
| `oepul.shared.parcels[].project_confirmation_codes` | Editierbare dokumentierte Schlag-Code-Liste; generische NAT-/N2-Prüfung kontrolliert Datenvorhandensein. | Projekt-/Auflagensatz-ID, Version, ausstellende Stelle, Rechts-/Katalogfassung, verpflichtende Parameter, konkrete Wirkungsfläche und Gültigkeit. |
| `farm.region.is_protected_area` | Dokumentierbarer Betriebs-Bool; keine individuelle Schutzgebietsgeometrie oder Landesverordnung. | Schutzgebiet, räumliche Teilfläche und datierte Rechtsgrundlage getrennt von Projekt und Antrag. N2 umfasst auch die ausdrücklich genannten sonstigen Schutzgebiete. |
| Roh-AMA-/Blueprint-Kennzeichen und amtliche GIS-Kulissen | Ein vorhandener Import-/Blueprintwert ist noch kein konsumierter, vollständiger Projektbeleg. | Rohdaten, Adapter, registrierte Eingabe, Oberfläche und tatsächlichen Regelzugriff verlustfrei verbinden; bestehende Flächenidentitäten verwenden. |
| EBW-Basisregel `o6_19` | Kann bei mindestens 1 ha passender Flächen `eligible` mit `phase1_baseline_check_passed` liefern, ohne Projekt-/Indikatornachweis. | Bestätigte Projektfläche, Lebensraum-/Indikatorinstanz mit Parameterwerten, verbindlich gegenüber Zusatzindikator, datierte tatsächliche Beobachtungen. Basisstatus muss als begrenzter Prüfstand erkennbar bleiben. |
| Alm-Basisregel `o6_14` | Flächen-/GVE-/Weidetage-Proxy; keine NATA-Projekt- oder Anhang-E-Auflagenprüfung. | NATA als eigener optionaler Scope je konkreter Alm, alle Feldstücke, planmäßig verortete Auflagen und spezielle RGVE-/Habitatbedingungen. Basis-Almprüfung bestätigt den Zuschlag nicht. |
| Grünland-Basisregel `o6_17` | Aggregat-/Hang-/Jahresproxy; keine vollständige Boden-/Bewirtschaftungs- oder bedingte Aufschüttungsbewilligung. | Tatsächliche betroffene Vorgänge und erforderliche vorherige Landesbewilligung verknüpfen. Keine allgemeine Projektpflicht aus dem Wiener Zuschlag16 auf17 übertragen. |
| NAT18 / N223 / WRRL24 mit gefüllten vorhandenen Inputs | Die aktuellen generischen Zweige bleiben `missing_data`. | Konkrete bestätigte Projekt-/Rechtsprüfung nach Erfassung und Adapter, keine bloß zusätzlichen Pflichtfeldnamen. |
| `exceptions.recognitions` für die native o6_3-Teilprüfung | Typisierte Anerkennung mit Vorfall, Dokument-/Wirksamkeitsdatum und Scope; passender Beleg führt zur offenen Ausnahmeprüfung, nicht zum pauschalen Wegfall von Verstößen. | Bestehenden Belegvertrag gezielt weiterverwenden; allgemeine Bekanntmachung, individuelle Anerkennung und tatsächliche technische/gesundheitliche Sonderbedingung getrennt halten. |
| Generischer Editor / aktueller Faktenkontext / Auto-Generator | Generischer Editor verwendet Szenario-Endpunkte; vorhandener Auto-Run ist kein eigener Farm-Snapshot. | Aktuelle dokumentierte Fakten anbinden; historische gültige Dokumente über ihre Datumsrolle beurteilen; eigener dokumentierter Auto-Snapshot wie bereits entschieden. |

Exakte Zeilenanker und Dateihashes stehen in [app-paths.json](app-paths.json).
[proxy-observations.json](proxy-observations.json) enthält sechs reproduzierte
synthetische Beobachtungen der unveränderten aktuellen App-Policy. Sie sind kein
Golden-Soll und kein HTTP-/Datenbank-/Browser-E2E-Test. Besonders EBW zeigt
einen positiven Basisstatus ohne den in der Quelle erforderlichen Projektbeleg;
dieser Status belegt keine vollständige Maßnahmenerfüllung.

## Gemeinsam erfassen, getrennt prüfen

| Beleg-/Rechtsklasse | Eigenständiger Maßnahmenscope |
| --- | --- |
| NAT18-Projekt | Zuständige Landesstelle; vollständiger konkreter Auflagensatz aus Anhang I, individuelle `$`-Werte, flächenspezifische Ziele. Allgemeine Pflichten gelten zusätzlich; eine Null-Prämie beseitigt keine Pflicht. Änderung vor tatsächlicher abweichender Bewirtschaftung. |
| EBW19-Projekt | Beauftragte Koordinationsstelle, Lebensraum und Ziel-/Istzustand; verbindliche Indikatoren müssen erfüllt werden, Zusatzindikatoren sind nicht bindend. Gleichlautende Codes mit anderer Lebensraum-/Variantenbedeutung nicht vereinheitlichen. Freitext benötigt eine bestätigte Auslegung. |
| Regionaler Naturschutzplan18/19 | Eigene regionale Planung und aktuelle jährliche Teilnahmebestätigung zusätzlich zum Hauptprojekt. Bestätigung, Datenübermittlung und Zahlungsantrag bleiben unterscheidbar; Zahlungsberechnung folgt in Block7. |
| NATA14 | Landesbestätigung, alle Feldstücke einer konkreten Alm und planmäßig verortete Anhang-E-Auflagen. Grundmaßnahme, NATA und Almweideplan sind getrennte Optionen; NATA ist kein beliebiges Projektcode-Flag. |
| N223 | Landesbestätigung der zugrundeliegenden ordnungsrechtlichen Auflagen. Neun einschlägige GI-/GL-Codes; bei Schnittzeitpunktauflagen gehört der tatsächliche Termin zum individuellen Beleg. Natura-Flag allein bestätigt weder Auflage noch konkrete Fläche. |
| WRRL24 | Eigene Verordnung samt räumlicher Klassengeometrie und Anlage3. Bewilligungsfreies +10% nach §4 Z3 und bewilligte Abweichung nach §4 Z7 sind eigene Rechtswege. Auch Aufzeichnungsscope und Bewilligungsinhalt getrennt prüfen. |
| Anerkanntes Wiener Projekt16 / bedingte Landesbewilligung17 | BMLUK-anerkanntes wissenschaftliches Projekt und Teilnahmebestätigung bei16 sind nicht die vorherige Landesbewilligung für den besonderen Aufschüttungsfall bei17. |
| Individuelle o6_2-/o6_3-Anerkennung | Betroffene Pflicht, Vorfall, Wirkungsfläche/-gruppe, zeitliche Rechtsfolge und tatsächlich geltende Anerkennung. Ein allgemeiner Ernteausfall hebt weder den N-Grenzwert noch beliebige Heuwirtschaftspflichten auf. |
| Insektizidverzicht12 | Genehmigter vorzeitiger Ausstieg mit Vertrags-/Prämienfolge gegenüber konkret angeordnetem Einsatz bei weiterlaufendem Vertrag. Wirkstoff, Anordnung, betroffene Fläche und Zeitraum verbinden. |
| Tierwohl21/22-Sonderbedingung | Gesetzeskonforme Liegeboxen-/Kälberschlupf-Ausnahme21, ausdrücklich wasserrechtlich bewilligte Freilandhaltung22 und dokumentierte Krankheits-Einzelhaltung sind verschiedene Belegklassen. Keine pauschale zusätzliche Behörden-/Tierarztpflicht erfinden. |
| Quellenbasierte automatische Dürrewege2026 | NAT-Nutzung ab12.08. gegenüber N2 erst nach geänderter Landesverordnung; beide ohne Änderung der Projektbestätigung laut konkreter Mitteilung. Immergrün-Fristerleichterung mit verbleibenden festen Fristen; Untersaat-Ausnahme bei korrekter Anlage; verkürzte Nutztierrassen-Haltedauer mit fortbestehenden Bewegungsmeldungen. Eine individuelle AMA-Meldung nur verlangen, wenn die konkrete Quelle sie fordert. |

Die [Scopematrix](scope-matrix.json) verbindet jede Teilprüfung mit wörtlichen
Originalbelegen und bestehenden offenen Fragen. Der [Katalogabgleich](catalogue-review.json)
bindet die bereits vorhandenen historischen Tabellenprüfungen für NAT, EBW,
NATA und N2 sowie die eigenständige WRRL-Quellenlücke.
Ein vollständiger Codekatalog ersetzt weder den konkreten betrieblichen
Projektauflagensatz noch die maschinelle Prüfung seiner Erfüllung. Typ und
Einheit eines `$`-Parameters folgen seiner einzelnen Auflage; identische Tokens
sind keine globalen Aliase.

275 unterschiedliche lokale Originalfundstellen aus 18 Quellen und zusätzlich
295 wörtliche Katalogkontexte sind geprüft: 151 NAT-Parameterzeilen mit 165 Codes
einschließlich Aliassen sowie 144 EBW-Kontextzeilen mit 100 verschiedenen Codes.
73 belegte Teilscopes vertiefen 16 Maßnahmen; zwölf gemeinsame Themen und 107
bestehende Frageverweise verbinden sie mit den 25 Dossiers nach UBB. Reine
Kurs- beziehungsweise Kombinations-/Zahlungsscopes sind als Querverweise auf
Block6/7 markiert. Diese Zählungen messen keine Modellqualität.

## Belegvertrag als Vorbereitung

1. **Identität und Fassung:** interne Beleg-/Projekt-/Auflagensatz-ID,
   Aussteller und dessen Rolle, Quellen-/Rechts-/Katalogversion, Dokumentbezug
   und nachvollziehbare Änderungshistorie. Ein MFA-Code, ein Bescheid und eine
   im Snapshot dokumentierte Expertenangabe sind unterschiedliche Objekte.
2. **Wirkungsbereich:** tatsächlicher Betrieb, konkrete Alm, Feldstück,
   Schlag/Teilfläche oder Tiergruppe, ausgewählte Maßnahme/Option und einzelne
   Pflicht. Geltende übrige Pflichten ausdrücklich erhalten.
3. **Datumsrollen:** Ereignis/Vorfall, Ausstellung, Veröffentlichung,
   Inkrafttreten, Gültigkeitszeitraum und Übernahme/Änderung separat. Ein im
   Vorjahr ausgestelltes weiterhin gültiges Projekt ist nicht deshalb veraltet.
   Der aktuelle Datenstand und der Prüfzeitpunkt bleiben maßgeblich.
4. **Inhalt:** vollständige konkrete Auflagen-/Indikatorinstanzen mit
   Parameterwerten, deren Bedeutung/Einheit, Verbindlichkeit, tatsächlichem
   Ereignis-/Beobachtungsbezug und dokumentiertem Vollständigkeitsstand.
   Fehlende Liste ist nicht eine bestätigte Liste ohne Auflagen.
5. **Ausnahmewirkung:** konkrete Rechtsroute und Voraussetzungen, erlaubter
   geänderter Termin oder Vorgang, aufgehobene einzelne Pflicht, verbleibende
   Pflichten und gegebenenfalls eigene Vertrags-/Prämienfolge. Rückwirkender
   Vorfallbezug ist nicht dasselbe wie eine erlaubte zukünftige Empfehlung.
6. **Eingabeherkunft:** AMA-Baseline plus dokumentierte Experten-/Betreiberwerte,
   die AMA vorgehen. Abweichung allein blockiert sie nicht. Auto-Werte gelten
   im eigenen dokumentierten Snapshot, Quelle `auto`; neu angelegte Objekte
   bleiben sichtbar als Experte/Betreiber/Auto gekennzeichnet. Die zulässige
   Eingabeherkunft und die zitierte Rechts-/Projektgrundlage bleiben getrennt.

## Aktuelle Quellen und offene Umsetzung

Die aktuelle AMA-Mitteilung vom19.05.2026 bestätigt die flächenspezifische
Projektgrundlage und die vorherige schriftliche Projektänderung. Der aktuelle
Hinweis vom12.08.2026 unterscheidet insbesondere NAT-Freigabe und N2-Landesrecht.
SRL/Anhänge01.10.2026 wurden über den offiziellen Rechtsindex in ausgewählten
Block-5-Passagen geöffnet; keine vollständige aktuelle Katalogprüfung behauptet.
Die datierte WRRL-Konsolidierung und Anlage3 sind online gelesen; ihre Novelle
gilt ab08.06.2026. Der vollständige historische Tabellenstand davor und eine
lückenlose aktuelle Rechts-/GIS-/Projektaufnahme bleiben offen. Links,
Versionsgrenzen und Zugriffsgrenzen stehen in [evidence.json](evidence.json).

[Restfragen](questions.md) gehen ins Sammelissue #140. Sie schließen und
deduplizieren keine bestehende Frage. Kurse/Personen/Anträge folgen in Block6,
Kombination/Sanktion/Zahlung in Block7. Danach können bestätigte Verträge in
kleinen App-PRs mit typisierten Belegen, Editor, verlustfreiem Adapter und
konkreten Maßnahmenscopes angebunden werden. Unabhängig bewertete Fälle müssen
unter anderem gültige Altprojekte, vorherige Änderungen, nicht bindende
Zusatzindikatoren und eng begrenzte Ausnahmewirkungen abdecken.

Keine App-/Policy-/Canonical-/Thesisänderung und kein Modelllauf.
[Draft #103](https://github.com/ghinta/oepul-rule-lab/pull/103) und
[UBB-Draft #102](https://github.com/ghinta/oepul-rule-lab/pull/102) bleiben offen;
Merge und fachliche Aufnahme erfolgen nach gesonderter Freigabe.
