# o6_3: 96 Blätter, neue Modellpfade und vorhandener Adaptationsvertrag

| Gruppe / Blätter | Luna | Opus | App / Adaptation / offene Aufnahme |
| --- | --- | --- | --- |
| `participation` / 23 | `farm.heuwirtschaft.measure/year/contract_start_year`, Kombination, Antragsdatum | `farm.applicant`, `farm.oepul.o6_3` mit Vertrag/Antrag/Ausstieg/Übernahme | App-Adapter verliert beide Vertragsstrukturen. Adaptation behält native `farm.heuwirtschaft`, aber aktuelles `farm.year`/strikten Hostkontext statt Lunas eigenem Jahr. Historische Erstjahresbelege sind keine aktuellen Bestände; Antrag und Kombination datieren. MB S. 1–2, 4. |
| `land_scope` / 23 | `land.parcels[].oepul.*`, fertiges Prämienflag und aggregierte Erstjahresfläche | `grassland_type`, `crop.forage_crop_type/is_second_crop`, Codes/Maßnahmen/Österreich/Nationalpark, Mahd-/Weideflags | App-Parzellenadapter verliert neue Typen/Code-/Mengenflags; nur Schnittdaten bleiben im o6_3-Vertrag. Adaptation verlangt vollständige Schlagliste und explizite vollflächige Mahd/Abfuhr oder Beweidung. Mindestfläche, Futterfläche und gemähte Prämienfläche bleiben getrennt. Ackerweide zählt nur zum Nenner. MB S. 2, 4–5. |
| `livestock_history` / 8 | vorgeschlagene Erstjahres-RGVE/Futter-ha und aktuelle Dichte; Policy liest stattdessen aktuelle species_groups mit bestehendem category | `average_count`, `rgve_category`, Österreich und erweiterter species-Enum | App speichert inzwischen rgve_cohorts mit Nachweisen, kopiert im Maßnahmenadapter aber nur reduzierte Artgruppen ohne Kategorien/Durchschnitt. Adaptation hat strikte 20 Kategorien und Erstjahresvertrag; Gruppenidentität/Bestandsbasis bleiben acht-Blocker-Dossierfragen. Opus-Kuh-ID `cattle_2y_plus` ist anders als o6_2-Opus `cattle_ge_2y`. Kein Alias ohne verbindliches Mapping. MB S. 2, 5–6; ATB Bestandsmethode. |
| `green_feeding` / 4 | globales `green_feeding_majority_april_to_september` | Heimtage + Alm-/Gemeinschaftsweidetage und `all_roughage_animals_included` | App transportiert weder Tageslisten noch globalen Nachweis. Adaptation übernimmt nur belegtes Prüfergebnis, erfindet keine 92-Tage-Regel; saisonaler Nullbestand und Nachweismethode bleiben offen. Opus summiert ohne Überlappungsprüfung und nutzt aktuellen RGVE-Bestand. MB S. 3. |
| `feeding_storage` / 14 | globale Silage-/Gärungsflags | einzelne Herstellung/Fütterung/Lagerung/Altvorrats-/Nebenproduktflags, `feedstuffs[]` | App transportiert diese Listen nicht. Adaptation erfordert bekannte Booleans; Opus fehlende Flags erzeugen keine Silageverletzung. Betriebweiter Scope einschließlich sämtlicher Gebäude/Tierarten und Herkunft/Herstellungsverfahren nötig. MB S. 2–3. |
| `hay_transfer` / 4 | `third_party_cuttings_only_dry_hay` | Transferliste mit Form, Empfänger, Kreiseln und Silageindiz | App keine Projektion. Adaptation aggregiert nur bei explizit vollständigem Nachweis; keine Transfers und unbekannte Liste unterscheiden. Kreiseln/Abgabezustand und Grünfuttertausch nicht aus Empfängername ableiten. MB S. 3. |
| `machinery_option` / 7 | Option, Geräte/Einsatzflags, vorgeschlagenes `option_application_year` | jährliche Option beantragt + MFA-Markierung; `farm.machinery` | Luna liest Optionsjahr nicht. App keine o6_3-Optionsprojektion. Adaptation kennt Jahresoption und bekannte Einsatz-/Vorhandenseinsflags; stillgelegtes Gerät fachlich offen. Gesamtfläche einschließlich Eingrasen, kein bloßes Prämienflächenflag. MB S. 1, 4. |
| `recognition` / 6 | globales Dürre-/kein-erntbarer-Bestand-Flag | globaler force_majeure-Status mit Ursache | App-Maßnahmenadapter keine scoped-Anerkennung. Adaptation verwendet eigene `exceptions.recognitions[]` mit Pflicht/Fläche/Zeit/AMA-Referenz; Vorfallszeit vs. späteres as_of bleibt offen. Opus unterdrückt alle Verstöße mit einem Boolean. Automatische allgemeine Acker-Ernteausnahme ist keine Silage-/Grünfütterungsbefreiung. SRL 1.7.4.1; Notices. |
| `payment_history` / 7 | kein vollständiger zusätzlicher Zahlungsvertrag | 2025-/Vorjahres-/aktuelle Grünlandfläche, Verlust/Umwandlung, volle Kürzungen, andere Zahlungen | App keine vollständige Berechnung. Adaptation ist begrenzter maßnahmenspezifischer Slice; GENERAL_FUNDING bleibt offen. Opus fehlende 2025-Basis verhindert keine Flächenkappungsumgehung. Historische Beträge/Codes und AMA-Sanktionen gesondert belegen. ATB S. 14–19. |

## Grenzen der bestehenden Adaptation

46 typisierte Pfade, 17 Regel-/Berechnungsgruppen und 20 RGVE-Kategorien sind
bereits separat dokumentiert und getestet. Das ist ein drittes, manuell
adaptierter Vertrag neben den beiden Rohmodellvorschlägen; Namensähnlichkeit
ersetzt keine Übernahmeentscheidung. Dieser Slice pinnt die bestehende Schema-,
Policy-, Variablen-, Quellenreview- und Entwicklungsproben-Evidenz unverändert.

Die App erwartet `{measure_id,payload}` mit vertrauenswürdigem
`evaluation_context`; der Lab-Kandidat nativen Input mit `context`. Noch nötige
Projektion: current_year/snapshot_year/as_of, tatsächliche Kategorien-/Bestands-
nachweise und Pflicht-/Flächen-/Zeitevidenz, bei Erhaltung von Snapshot-Digest,
IDs und Provenienz. Eine Artgruppe mit einer einzigen Kategorie zu überschreiben
würde mehrere Kohorten derselben Art verlieren. Keine neue solche Projektion
wird hier implementiert.
