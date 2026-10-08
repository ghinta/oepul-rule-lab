# o6_3: Rohmodell-Beobachtungen und bereits bekannte Adaptationsgrenzen

| Probe | Reproduziertes Ergebnis | Integrationsbedarf |
| --- | --- | --- |
| `LUNA_AFTER_CONTRACT_END` | Eingabe 2030 bleibt `eligible:true` | Historischer Run prüft Vertragsbeginn, nicht Ende. Vorhandene Adaptation hat separate Jahres-/Vertragsguards. 2030 ist synthetischer Entwicklungsfall, keine aktuelle Empfehlung. |
| `LUNA_SMALL_HORSE_MAPPING` | Ein adultes Pferd ergibt 1 RGVE | Luna mappt horses immer zu große_equiden; es gibt kein Größen-/Rassenunterscheidungsfeld. Kleines adultes Pferd benötigt laut Tabelle 0,5. Eingabe kann die nötige Unterscheidung nicht ausdrücken. |
| `LUNA_CAMEL_CATEGORY` | Neuweltkamel ergibt 0 RGVE | Die vollständige Tabelle ist vorhanden, der Species-Helper implementiert nur cattle/sheep_goats/horses. Tabellenexistenz ist kein Konsumnachweis. |
| `LUNA_VALID_FIRST_YEAR_NO_CURRENT_STOCK` | Gültige Erstjahresbelege, aktueller Nullbestand: eligible false und Erstjahres-TIERHOLDING-Verstoß | Luna verwendet aktuelle statt historische RGVE für Zugang. MB S. 4 trennt späteren Nullprämienstatus von damaliger Zugangserfüllung. |
| `LUNA_FLAGGED_PASTURE_PREMIUM` | Markierte Dauerweide ohne Schnittdatum zählt mit 2 ha zur Prämienfläche | Das globale Premiumflag ersetzt keine Kategorie-/Mahd-/Ausschlussprüfung. |
| `OPUS_MISSING_SILAGE_FACTS` | Fehlende Silagebereitungs/-fütterungs/-lagerungsdaten erzeugen keine solchen Verstöße | Defaults false sind kein Ausschlussnachweis; eine vollständige Erfüllung darf daraus nicht entstehen. |
| `OPUS_BLANKET_RECOGNITION` | Bekannte Silagelagerung und Grünfütterungsbefund: Rohverstöße vorhanden, effective violations leer | recognised:true ist nicht an Pflicht/Fläche/Zeit/Rechtsfolge gebunden. Die Adaptation behandelt Anerkennungen genauer, hat aber RECOGNITION_TIME weiterhin offen. |
| `OPUS_SPECIES_CATEGORY_MISMATCH` | Schweinegruppe mit gültiger Rinder-Kategorie erzeugt 1 RGVE | Tabellenkategorie wird ohne passenden Species-Vertrag akzeptiert. Adaptationsschema prüft die Kategorienzuordnung strenger. |
| `OPUS_GREEN_DAYS_ADDITION` | 50 Heimtage + 50 Alm-/Gemeinschaftsweidetage ergeben Mehrheit | Keine Intervalle und keine Überlappungs-/Teil-Tagesprüfung. Das Ergebnis bestätigt nur die Addition, keine fachliche Mehrheit. |
| `OPUS_PREMIUM_WITH_SILAGE` | 291,60 € Bruttoprämie neben Silagelagerungsverstoß | Betragsberechnung und Verletzungs-/Sanktionsstatus getrennt; kein bestätigter Zahlungsanspruch und keine automatische Sanktion aus der Probe. |
| `APP_FILLED_MANAGEMENT` | Gefüllte Schnitt-/Bewirtschaftungslisten: missing_data / category_c_conservative_missing_data | Lab-Adaptation ist noch nicht die ausgeführte App-Policy. |

Die zehn bereits bestehenden `development-probes.json`-Fälle des
Vertragsdossiers bleiben unverändert gebunden, einschließlich Saisonhistorie,
Durchschnittszahl ohne Listenbeleg und Anerkennung vor dem heutigen Prüfstichtag.
Dieser Slice reproduziert elf zusätzliche Rohmodell-/App-Beobachtungen.
Alles synthetische Entwicklungsdaten; keine unabhängigen Golden Tests.
