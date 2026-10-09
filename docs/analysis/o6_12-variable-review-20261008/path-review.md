# Variablendiff und Aufnahme

| Bereich | App vorher | Luna-Vorschlag / konsumierter Pfad | Opus-Vorschlag / konsumierter Pfad | Aufnahme |
| --- | --- | --- | --- | --- |
| Vertrag | Category-C-Proxys ohne bestätigten Fachvertrag | farm.measures.o6_12.*; Vertrags-/Antrag-/Umstiegshelper nicht an premium_eligible gebunden | top-level oepul.measures[] code/commitment_start_year; Antragsdatum fehlt ohne Blocker | offen: heutiger Vertrag, vollständige erste Jahre/Ausstiege |
| Kultur/Fläche | land.parcels[] / PSM-Proxy | crop_category + exakte abweichende Obststrings, crop_name erforderlich; globale Pflanzgutflags | crop.special_crop_type + category-Fallback; fruit_grafted und Präfixnamen | offen: amtliche MFA-/Kulturidentität, alle Pflicht-/Prämienflächen |
| Anwendung | operations.psm_used und shared.parcels[].psm_applications | operations.insecticide_use/Bio-/Authoritybooleans | plant_protection_applications[] effect_type/product_name/application_date/organic_regulation_permitted | offen: aktuelle AGES-/Bio-Produktfreigabe, echte datierte Ereignisse |
| Anordnung | keine dokumentierte Verordnungs-/Anwendungskette | parcel.operations.insecticide_authority_order/documented plus unverbundene Farmhelper | oepul.o6_12.authority_orders[] ohne ID-/Produkt-/Schlag-/Gültigkeitsbindung | offen: tatsächlich zuständige Anordnung zu jedem Einsatz |
| Rebzikaden-Ausstieg | keine bestätigte Fachgenehmigung | early_exit_reason/approved; Helper getrennt von premium_eligible | leafhopper_exit.requested/request_date/approved; approved fehlt => true | offen: behördliche Bestätigung, dauerhafte Vertragsbeendigung |
| Kauf/Lager | kein vollständiger Inventarvertrag | parcel purchase/storage/other_culture/plausible Bool | insecticide_stock[] purchased/stored + Bio/andere Kultur/records Bool | offen: wirkliche Produkt-/Mengen-/Bestands-/Kultur-/Zeitnachweise |
| BIO/Umstieg | keine aktive Teilbetriebs-/Umstiegskette | biological_farming_scope + switch_request_date; unverbundene Helper | organic_partial_farm.*, switch_to_organic.effective_date mit Antragsfrist verglichen | offen: Kulturbereich, Antrag gegenüber Vertragswirkung |
| Prämie/PSM-Codes | keine normative Prämie | global premium_target_type; Bioeinsatz meldet PSMCS | tatsächliche Codes, Sanktion separat, Brutto-Cap trotz späterer Modulation | offen: aktuelle Fristen/Codewegfall, theoretischer Betrag, Behördenbewertung |

Alle 113 konkreten Blätter: [leaf-review.json](leaf-review.json).
App-Pin `5296108f5756ef1463c25a49d93d4a346e9b5e9c`; API/Policy tatsächlich
geprüft. Keine stillen Aliase zwischen Herbizid-/Insektizidereignissen, drei
Wurzeln, Pflanzgut-/Codescopes oder BIO-/Behördenfreigabe.
