# Vorher-/Nachher-Vertrag o6_13

Basis: App5296108f5756ef1463c25a49d93d4a346e9b5e9c, Lab7a296d28cb5b92e2758c5a3889c929ea1db60fe5.
Historische Runs: v2-o6_13-luna-high-20261004 / v2-o6_13-opus-5.5-high-20260926.
Alle vorherigen Werte, neuen Blätter, Vorschlagsreferenzen und Quellen sind in
[leaf-review.json](leaf-review.json) sowie dem [gepinnten Variablendiff](../all-measure-variable-review-20261008/o6_13/variable-diff.json) enthalten.
Kein Pfad ist als fachlicher Alias freigegeben.

| Gruppe / Blätter | Vorher → Luna → Opus | Entität, Einheit, Zeit und offene Bindung |
| --- | --- | --- |
| Struktur/Geometrie/Klassifikation32 | land.parcels → protected_cultivation mit ganzer Rolle und kombinierter structure_type → Strukturtyp+Material, growing_system, structure_id, Teilflächenha, NUE/OP/VF-Codes | Haus/Tunnel und Schlag brauchen eigenen Join; notwendige Gänge/Verkauf/Schau/Lager/Zwischenflächen geometrisch, keine negativen/überlappenden Komponenten. A/GA und belegter1.April-Wechselstand. |
| Organismen/Register/Ereignisse/Aufzeichnungen23 | ohne fachlich ausreichende Einsätze → organism_application Einzelobjekt → beneficial_organism_applications[] plus records.kept_per_parcel | Register-/Produkt-/Kultur-/Ziel-ID und Version, Menge+Einheit+Fläche, tatsächlicher Datum/PSM-Ersatz, Beleg je Einsatz/Schlag. Boolesche Rate/Flächendeckung ist kein Register-/Geometrienachweis. |
| Vertrag/Geschichte22 | farm.year → farm.measure_application → farm.oepul.o6_13 mit Vorjahres-/Kontroll-/Übernahme-/Compliancefeldern | heutiger Host-Snapshot, Jahresvertrag, Erst-/Wiedereinstieg vs Verlängerung, NUE/MFA-Historie, tatsächliche Abmeldung und Übernahmegenehmigung. Nicht aliasieren. |
| Programm/Kombination12 | Ohne Evidenzvertrag → farm.operation_program + other_premium → PO-Programmmitgliedschaft, funding_overlap/OP-/andere Maßnahmencodes | Betriebsauszahlung und Programmabgeltung sind verschieden; vollständige tatsächliche Prämien pro Einzelfläche/Jahr, keine bloßen Codes als Auszahlung. |
| Management/Dürre8 | Aggregate → Ernte/Pflege/Anbau sowie betrieblicher Dürreflag → minimum_management, parcel.drought/force_majeure | echte schlagbezogene Historie/Bezirk, Quelle/Datum/Pflichtscope. Gewächshaus-A/GA-Ausnahme ist offen, fehlende Ernte bleibt unbekannt. |
| Person/Lage8 | farm.region.country → AT-Lageflag → farm.applicant und flächenbezogene Lage/Referenz | bestätigte aktive Person/Verfügung und GIS-Lage; Betriebsregion bestätigt nicht alle Flächen. |
| Allgemeines Erstjahr/Flächenbasis4 | Landaggregate → first_participation und beantragte NUE-Fläche → first_participation_year + protected_cultivation_area_ha/minimum_size_additional_area_ha | erstes ÖPUL-Jahr, vollständige MFA-Fläche unabhängig NUE; 0,50ha geschützt oder vollständige1,50ha. Aggregat nicht ohne Deduplizierung übernehmen. |

Die App projiziert payload.oepul.measures.o6_13.{protected_cultivation_area_ha,parcels,beneficials};
Rego liest nur parcel.is_protected_cultivation und beliebige beneficials-Einträge.
Luna und Opus lesen land.parcels und eigene Vertragswurzeln. Diese drei Sammlungen
brauchen überprüfte Adapter-/Entitätsjoins; bloßes Umbenennen setzt die Regeln nicht
fachlich korrekt in die App um. Keine echte AGES-/MFA-/Betriebssnapshot-Eingabe in den Proben.
