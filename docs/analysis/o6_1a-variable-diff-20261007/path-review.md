# Pfadvergleich und offene Aufnahmeentscheidungen

Status: Entwurf; kein Host-Zielpfad und kein neuer App-Default ist freigegeben.
Die Namen in dieser Tabelle sind Vergleichskandidaten, keine Aliasregeln.
Originale Begründungen und Quellen-IDs stehen vollständig in `variable-diff.json`.

| Sachverhalt | Luna-Vorschlag | Opus-Vorschlag | App vorher / Entscheidung |
| --- | --- | --- | --- |
| Feldstücksidentität | `land.parcels[].fieldpiece_id` | `land.parcels[].field_piece_id` | AMA `parcel_ref.feldstueckskennung` und `feldstuecksnummer` existieren; `field_piece_identifier`/`field_piece_number` sind derzeit Display-Metadaten. Gruppierungsschlüssel **offen**, im Chat erfragt. Nicht mit Schlag-ID gleichsetzen. |
| MFA-/DIV-Codes | `land.parcels[].measure_codes[]` als Objekt mit `code` und `source_measure` | `land.parcels[].codes[]` als String; zusätzliche `project_conditions[]` | Bestehende Collection `oepul.shared.parcels[].oepul_codes` und Projektcodes müssen einzeln auf Typ, Herkunft, Codeumfang und Consumption geprüft werden. Informationsverlust durch Objekt→String-Übersetzung ungeklärt. |
| Biodiversitätsflächen | Schlagwert `biodiversity_area_ha` und Betriebsaggregate `documentation.arable_div_ha` / `grassland_div_ha` | Schlagcodes, Maßnahmen-/Projektbedingungen und daraus berechnete Anrechnung | App-Dependency `ama_additional.land.fsl.aggregate.existing_biodiversity_area_ha` summiert bisher DIV-Codeflächen. Das ist kein belegter Ersatz für getrennte UBB-Anrechnungsflächen nach Nutzungsart. Aufnahme/Ableitung **offen**. |
| Biodiversitätstyp | Zusätzlicher Variantenpfad `biodiversity_management.variant` | Vorhandenen Typ `annual/multi_year` durch `DIV/DIVRS/DIVSZ/DIVNFZ/DIVAGF` ersetzen | Unterschiedliche Dimensionen (Dauer vs. MFA-Variante). Keine Umbenennung oder Überschreibung beschlossen; getrennte Darstellung ist zu prüfen. |
| Weiterbildung | Mehrere `documentation.training_*`-Angaben und Teilnehmerliste | Objekt `farm.oepul.ubb.training` | Identität, Stunden/Datum, Anerkennung und Vollständigkeit pfadweise abgleichen; keine automatische Gleichsetzung der Aggregate. |
| Tierhaltereigenschaft | `documentation.livestock_status` als deklarierter abgeleiteter Status | RGVE-Kategorie und Durchschnittszahl in Artgruppen, eigene RGVE-Berechnung | Nach #137 existieren separate `livestock.rgve_cohorts` mit Bestandsbasis und Zeitbelegen. GVE oder ein unbelegter Status ist kein Ersatz; Wiederverwendung des RGVE-Vertrags erst nach Quellen-/Scopevergleich. |
| Pheromonfallen und Aufbewahrung | `documentation.pheromone*`, Schlagaufzeichnungen | Schlagobjekt `pheromone_traps`, darin u. a. `traps_kept_until_sept_30` | SRL-Ende der Vegetationsperiode vs. Merkblatt mindestens 30. September: fachlich erforderlicher Beleg und Zielpfad **offen**, im Chat erfragt. |

## Sofort vorgelegte Fragen

1. **PHEROMONE_PERIOD — offen:** Wie wird das Ende der Vegetationsperiode
   fachlich bestimmt und belegt? Die Modellannahme „30. September genügt“ wird
   nicht übernommen. Quelle der Unsicherheit: Opus `notes/assumptions.md`, Punkt 3.
   Belege: Merkblatt PDF-Seite 27, `REF-UBB-P27-PZR-07`: „Die verwendeten
   Pheromonfallen sind zumindest bis 30. September“; SRL PDF-Seite 32,
   `REF-SRL-P32-UBB-20`: „Pheromonfallen sind bis zum Ende der Vegetationsperiode“.
   Beide wörtlichen Belege und PDF-Hashes werden im Dossier-Check geprüft.
2. **FIELD_PIECE_IDENTITY — offen:** Ist `feldstueckskennung` innerhalb eines
   Betriebs und Antragsjahres der bestätigte Gruppierungsschlüssel mehrerer
   Schläge? Die App nutzt ihn aktuell nur zur Anzeige; es wird weder ein Fallback
   auf Schlag-ID noch eine Gleichsetzung mit `feldstuecksnummer` eingeführt.

Weitere Modellannahmen sind als unbestätigter Originaltext im Dossier enthalten.
Ihre Quellenprüfung erfolgt vor Aufnahme der betroffenen Variablen/Regeln.
Ungeklärte Punkte bleiben offen, auch wenn andere Variablen später belegt sind.
Ohne Antwort werden keine abhängigen fachlichen Ableitungen implementiert.
