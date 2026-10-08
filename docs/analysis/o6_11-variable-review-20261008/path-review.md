# Variablendiff und Aufnahme

| Bereich | App vorher | Luna-Vorschlag / tatsächlicher Konsum | Opus-Vorschlag / tatsächlicher Konsum | Aufnahme |
| --- | --- | --- | --- | --- |
| Vertrag | keine bestätigte Fachhistorie | farm.oepul.o6_11_application_year/contract_start_year + measure_applications[]; eligible nur aktuelle Fläche | farm.oepul.measures[] ID11, erster Eintrag; Antragsdatum fehlt verhindert Zahlung nicht | offen: aktiver datierter Vertrag, echte erste Teilnahme/Historie |
| Fläche/Kultur | generic land.parcels[] | crop_category, crop_name; ausgeschlossene Pluralnamen | crop.usage_type mit Fallback, 34Obstnamen, eigenes oepul.codes/measures | offen: MFA-Code/Kulturidentität, Erstzugang vs Verbots-/Prämienfläche |
| Anwendung | operations.psm_used und shared.parcels[].psm_applications | operations.pesticide_applications[]: application_date, effect_type=Herbizid / is_herbicide | operations.psm_applications[]: date, effect_type=herbicide, active_substances[], zone | offen: Produkt-ID/AGES-Version/Zulassungszeit und echte Ereignisse |
| Kauf/Lager | kein vollständiger fachlicher Inventarvertrag | farm.oepul.herbicide_purchases_storage[]; permitted_for_other_crops Bool | documentation.plant_protection_inventory[]; records_documented/quantity_plausible | offen: erlaubte Kultur/Zulassung, Mengen/Bestände/Zeit/Belege |
| BIO/Umstieg | keine datierte fachliche Scopekette | IDo6_1b und participation_type teilbetrieb_acker_gruenland | ID1B, is_organic_partial_farm + organic_partial_culture_areas; conversion_target entfernt Konflikt zu früh | offen: echter BIO-Teilbetrieb, wirksamer rechtzeitiger Umstieg |
| Prämie/Pflege | CategoryC ohne normative Auszahlung | OP/OP11 Einzelstring, plant_material_is_grafted defaulttrue; Standort/Pflege ungenutzt | crop.is_grafted, parcel.oepul.* und permanent_crop_management; fehlende Merkmale permissiv | offen: alle Nachweise, theor. Betrag, Behördenkürzung/Modulation/Cap |

Alle99 konkreten vorher/nachher-Blätter: [leaf-review.json](leaf-review.json).
Luna-Anwendungsdatum und Opus-date, technische Wirkungstypstrings, ID11/o6_11
und vier Pflege-/Pflanzgut-/Codepfade werden nicht automatisch aliasiert.
App-API projiziert PSM-Proxyfelder; ein erfolgreicher CategoryC-Eingabecheck
ist keine Prüfung des fachlichen Herbizidverzichts.
