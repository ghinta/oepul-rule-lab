# Opus 2026: manuelle Korrekturen und ausführbare App-Bündel

Die 26 historischen Opus-Runs wurden im Quellen-Audit einzeln untersucht. Dieses
Paket korrigiert konkrete Befunde außerhalb der historischen Runs und exportiert
alle 26 nativen Regelpakete für eine getrennte App-Auswertung. Es ist **keine
fachlich freigegebene Gesamtentscheidung und keine Studienreferenz**.

Ausgangspunkt ist der unveränderte Kandidatenstand
`e009eed4a83ff076b26eba33ac433ac2b0642621`, Auditstand
`41470a2284c9b1553db6c573b7e8da31a9343143` ([Audit-PR #111](https://github.com/ghinta/oepul-rule-lab/pull/111)).
`lineage.json` bindet jeden übernommenen und angepassten Artefakt-Hash.
[`changes.patch`](changes.patch) zeigt ausschließlich die eigentlichen Regeländerungen
gegen den unveränderten Kandidaten (1.321 Diff-Zeilen).
Originalquellen, Canonical Farm Profile und historische Runs bleiben unverändert.

## Umgesetzte Korrekturen

| Maßnahme | Korrigierter Umfang |
| --- | --- |
| 1A UBB | Vergleichsschnitt bei DIVSZ, mitgenommener Reinigungsschnitt, invasive Arten auf älteren Beständen, Verbotsende nach Umbruch, NFZ-Nutzung, Wildkräuter-Ernte/PSM |
| 1B Bio | K20-/Projektflächen-Gutschrift, gültige Grünlanddeklaration, Zusatznutzungen nur während Mindestanlage, frühe invasive Mahd davon getrennt, Düngung nach Umbruch |
| 1C | Mahden auf das Prüfjahr begrenzen; positive Geometrie-, Bestands- und Lageangaben für Agroforstdefinition |
| 2 | Historische Mahd erfüllt keine aktuelle Mindestbewirtschaftung |
| 3 Heuwirtschaft | Aktuelle Mahd, VF-Ausschluss, Modulation vor Obergrenzenvergleich; fehlende Vorjahresfläche bleibt ungeklärt und verursacht keinen Rechenabbruch |
| 4 | Über den Jahreswechsel laufende Beweidung im Verbotszeitraum erfassen |
| 5 | Ersatzalter am tatsächlichen Ersatzdatum, Zuchtzulassungsjahr, Zeitraum der Abwesenheit, längere Ersatzketten |
| 6 | Problemunkräuter-Ausnahme für Häckseln, nicht beliebige Mahd; V7-Ereignisse im Verpflichtungszeitraum; Rücknahme bei Folgedeklaration als Hauptkultur |
| 7 | Dürre erleichtert bestimmte 30-/50-Tage-Fristen, nicht die unmittelbare Erneuerung; ungerundete 85-%-Grenze; Pflegeregel am Anlagetag |
| 8 | Physische Fläche nicht mehrfach für AH/BAW/US zählen; unzulässige betriebliche Kombination 6 und 7 melden |
| 9 | Brache bleibt ohne N-Bedarf; ausgeschlossene Biogasmenge dem bekannten Verfahren zuordnen; offene Kappungszuordnung liefert keinen erfundenen Betrag; künftiger Einstieg und Vertragsablauf; NAPV auf sonstigen landwirtschaftlichen Flächen |
| 10 | Nachweislich zerstörende Tiefenlockerung/Neupflanzung; abgelaufene Wiederbegrünungsfrist bleibt nicht dauerhaft „ausständig“ |
| 11 | BIO-Anwendung zusätzlich zur chemisch-synthetischen Herbizidanwendung berücksichtigen |
| 12 | Antrag auf Rebzikaden-Ausstieg ist keine Genehmigung; gemischte BIO-/CSI-Anwendung |
| 13 | Ausschließlich Verkaufs-/Schau-/Lagerfläche erfüllt keine Mindestteilnahme |
| 14 | Null-Kategorie erlaubt Ableitung aus bekannter Tierart/Alter/Rasse; nicht teilnahmefähige Arten verlängern keine Almbelegung |
| 15 | Künftiger Hundeoptionsbeginn begründet keine aktuelle Zahlung; Hirtinnen/Hirten anhand eindeutiger Personen zählen |
| 16 | Vorhandene Maisbezeichnungen konsistent im PSM-Verbot; bekannte nicht prämienfähige Nationalparkfläche auch im AG-Zweig ausschließen |
| 17 | Umwandlung vor Vertragsbeginn und aktuelle Mindestbewirtschaftung unterscheiden |
| 18 | Aktuelle Mahden; Beweidung als zweite Nutzung und Dürre-Freigabe; Düngemittelart; NW05 gleichzeitiger Besatz; NW06 GVE statt ausschließlich RGVE |
| 19 | Künftiges Pflegejahr erfüllt keinen aktuellen Nachweis |
| 20 | Unverändert eingebunden; offene Quellen-/Zuordnungsfragen bleiben bestehen |
| 21 | Tiere ohne bekanntes Gewicht verschwinden nicht aus der Mindestflächen-Untergrenze |
| 22 | Bekannter Nichterfüllung im gesamten Haltungsintervall keine förderfähigen Köpfe zuordnen; nicht teilnehmende Gruppen und Zuschläge getrennt behandeln; GVO/unkupiert/Kompost-Zuschlag entfällt bei bekanntem Gegenbeleg, gültige Basis bleibt erhalten |
| 23 | Unverändert eingebunden; insbesondere Reihenfolge der Flächenobergrenze bleibt fachlich zu klären |
| 24 | Nmin bei Gemüse außerhalb der Prämientabelle; kein künftiger Wasserbefund; fehlenden Mineraldünger-Produktnamen melden |

103 zuvor nicht erfüllte Audit-Erwartungssätze werden jetzt erfüllt. Das sind
**keine 103 unabhängigen Fehler**. Insgesamt sind 391 öffentliche
Komponenten-/Integrationsfälle eingefroren. Ein erfüllter Test schließt weder
seine ganze Befundfamilie noch die gesamte Maßnahme fachlich ab.
`correction-status.json` nennt die Fälle, `tests/` enthält Eingaben, Erwartungen
und Belege. `verification/source-quotes.json` verifiziert 255 Zitatstellen in den
hashgebundenen Originalen. Tabellen werden mit `pdftotext -layout` und `-raw`
extrahiert; nur Leerraum und Soft-Hyphen werden normalisiert.

## Weiterhin offen

Die restlichen Befunde des Audits sind nicht pauschal behoben. Dazu gehören
insbesondere positive Nachweise statt günstiger Standardannahmen, ein
vollständiger Jahres-/Vertragsstatus, aktuelle und schlagbezogene
Behördenanerkennungen, Art-/Kulturklassifikation sowie Zahlungsbegrenzung und
Sanktionen über mehrere Komponenten. Die fachliche App-Freigabe fehlt.

Konkrete Grenzen dieser Korrekturrunde:

- Maßnahme 9: Mengen oberhalb einer gemeinsamen Grenze dürfen bei mehreren
  Verfahren ohne belegte Aufteilung nicht proportional frei verteilt werden.
- Maßnahmen 12/16: Verhältnis der Merkblatt-Codierungen zum GSP-AV-Stand 2026
  bleibt offen; der lokale Mischanwendungs-Fix entscheidet diese Quellenfrage nicht.
- Maßnahme 16: `in_national_park` ist weiterhin ein unzureichender Eingabevertrag.
  Die Korrektur des AG-Zweigs gilt für **bekannt nicht prämienfähige** Parkflächen.
  Andere Parks ohne relevante Bewirtschaftungsbeschränkungen und unbekannte
  Parkidentität dürfen daraus keine generelle Ablehnung erhalten. Keine Freigabe
  dieses Booleschen Vertrags als geografischer Klassifikator.
- Maßnahmen 5/18: Identität, Chronologie und Vollständigkeit von Ersatzketten bzw.
  Weideintervallen müssen vor einer verbindlichen Entscheidung validiert werden.
- Maßnahme 21: Die kleinste Flächenklasse liefert bei unbekanntem Gewicht nur
  eine Untergrenze. Aus ausreichender Untergrenze folgt keine positive Platzprüfung.
- Maßnahme 22: Bekannte Haltungsfehler beziehen sich in den korrigierten Fällen
  auf das gesamte relevante Gewichtsintervall. Eine einzelne Stallbeobachtung
  belegt das nicht. Vollständige Intervall-/Kohortennachweise sind weiter offen.
- Maßnahmen 20/23: Halbe Basis-/Zuschlagsprämie bzw. Reihenfolge gemeinsamer
  Obergrenzen sind nicht durch erfundene Auslegungen ersetzt worden.

## App-Vertrag und reproduzierbare Prüfung

`contracts/` friert die deklarierten Typen aus Canonical-Profil und den
maßnahmenspezifischen `profile_changes.json` ein. Es ist ein geschlossener
**Typvertrag**, noch keine vollständige Definition fachlicher Anwendbarkeit oder
Nachweisvollständigkeit. Fehlende Werte bleiben fehlend. Es gibt keine
Typumwandlung und keine automatisch ergänzten Ja-/Nein-/Null-Euro-Angaben.
Der Feldkatalog enthält auch vom Kandidaten noch nicht konsumierte Vorschläge;
alle erfassten Angaben werden im Lauf erhalten, eine Entscheidungswirkung darf
nicht allein aus der Erfassung abgeleitet werden.

Manuelle Vertragsergänzungen: Maßnahme 9 erhält die tatsächlich konsumierten
Schlagfelder `district` und `federal_state` mit Beleg auf die Mitteilung vom
05.08.2026. Sie ersetzen keine automatische geografische Klassifikation.
`enum(1|2|3)` bezeichnet die numerische Alm-Erschließungskategorie; Maßnahmen-
und Sanktionscodes bleiben Zeichenketten.

Der Export isoliert **jede Maßnahme** unter `opus_2026.<measure>` und führt
Tabellendaten entsprechend ihrer OPA-Verzeichnispfade zusammen. Konflikte brechen
ab. 12 und 14 verwenden ihre vollständigen nativen Entscheidungsdokumente statt
der alten Screening-Teilabfragen. 16 besitzt kein solches Dokument; dort werden
die benannten Zugangs-, Verpflichtungs-, Schulungs-, Proben- und
Prämienkomponenten zusammen ausgegeben. Die App darf daraus kein künstliches
Gesamturteil herstellen. Ein gemeinsamer Engine-Hash wird von OPA zurückgegeben.

```bash
python adaptations/opus-2026/tools/build_contracts.py --candidate /path/to/pinned-candidate
python adaptations/opus-2026/tools/check_sources.py --candidate /path/to/pinned-candidate --output /tmp/opus-quotes.json
python adaptations/opus-2026/tools/replay.py --opa /path/to/pinned-opa --output /tmp/opus-native.json
python adaptations/opus-2026/tools/export.py --output /tmp/empty-opus-export
/path/to/pinned-opa check --strict /tmp/empty-opus-export/policy
python adaptations/opus-2026/tools/replay.py --opa /path/to/pinned-opa --bundle /tmp/empty-opus-export/policy --output /tmp/opus-export.json
```

Die CI wiederholt Quellenprüfung, Vertragsgenerierung, native Regression und
Export-Regression. Historische Audit-Fälle außerhalb der hier aufgenommenen
Regressionen bleiben diagnostisch; ihre teilweise ungeklärten Erwartungen sind
keine freigegebenen Goldlabels.
