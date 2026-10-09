# Variablendiff und Aufnahme

| Bereich | Gepinnte App vorher | Luna-Vorschlag / tatsächlicher Konsum | Opus-Vorschlag / tatsächlicher Konsum | Aufnahme |
| --- | --- | --- | --- | --- |
| Fläche/Kultur | special_crops_area_ha, special_crop-Parzellen | summiert alle Parzellen, eligible_parcel nicht verwendet; crop_category statt offizieller MFA-Kultur | permanent_crop.type mit crop_category-Fallback; Obstname fehlt erlaubt | offen: vollständige Flächen, MFA-Codes, Kulturdefinition/Jahr |
| Hang/Terrasse | irgendein slope>=25 plus globale soil_cover | o6_10.is_terrace pro Parzelle; keine belegte GIS-Version | vine_terrace, slope fehlt=>0; unter25=>vine | offen: unveränderliche GIS-/Hangabschnittdaten, echte Terrasse |
| Vertrag | kein bestätigter Jahresvertrag | top-level o6_10 requested; entry/application/withdrawal-Vorschläge ignoriert | farm.oepul.o6_10 Datum/Abmeldung/Übernahme, keine Vorjahreserlöschungskette | offen: aktueller Jahres-/Historien-/Hostvertrag |
| Begrünung | globale Bodenbedeckung | parcel.o6_10.* Bool/Partner/Anteile/Streifen | operations.inter_row_greening.* neben permanent_crop.planting_system | offen: alle Fahrgassen, echte Jahresgeschichte, Altbestand/Selbstbegrünung |
| Ereignisse | kein Rodungs-/Neuanlagevertrag | reseeding.* Fristbooleans, renewal_count_per_year ungenutzt | events[] + Datum/Eventtyp; keine as_of-Bindung | offen: Fristanker, Vergangenheit/Zukunft, Vollständigkeit |
| Nutzung/PSM | keine zeit-/flächengebundenen Events | globale Parzellenflags; Weideflag hebt Nutzungsverstoß auf | Enum/Boolstatus ohne Nutzungs-/PSM-Ereigniszeit | offen: Aufwuchs/Ernte getrennt, Umfang der Weideausnahme |
| EOP | kein Zuschlag-/Register-/Codescope | global requested/use/replaces Flag; surcharge_applied pro Schlag ungenutzt | EOP-Codes, creditable_use auf beliebigem VFH-Schlag; keine Produkt-/Datumsbindung | offen: EOP-Basisfläche, tatsächliche AGES-Anwendung, Nachweise |
| Personen/Belege/Prämie | kein vollständiger Fachvertrag | records.farm nur falls records vorhanden; Unterfelder ignoriert | Checklistenlabels; Person/Pflege/Pflanzgut defaults; control_findings separat | offen: unbekannt vs bestätigt, theoretische Beträge/behördliche Kürzung |

Alle 113 konkreten Original-vorher/nachher-Blätter: [leaf-review.json](leaf-review.json).
App-Pin `5296108f5756ef1463c25a49d93d4a346e9b5e9c`; API, Policy und
Review-Katalog direkt am Commit gelesen/gepinnt. Kein bloßer Namensvergleich
entscheidet eine semantische Gleichheit oder Aufnahme.
