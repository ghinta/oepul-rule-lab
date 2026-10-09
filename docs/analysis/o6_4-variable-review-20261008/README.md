# o6_4: individuelle Prüfung Bewirtschaftung von Bergmähdern

**Aufnahme offen.** Luna `v2-o6_4-luna-high-20261001` liefert 20 Vorschläge,
43 neue Blattwerte und 24 Katalogregeln; Opus
`v2-o6_4-opus-5.5-high-20260925` liefert 21 Vorschläge, 46 neue Blattwerte
und 74 Katalogregeln. [Vorher/nachher-Diff](../all-measure-variable-review-20261008/o6_4/diff.md)
und `leaf-review.json` erfassen alle 89 Blätter in sieben Sachgruppen.
Lunas Werte sind vorgeschlagene Beispieldaten, keine bestätigten Betriebsfakten
oder zulässigen Defaults. Keine Pfad-/Enum-Gleichsetzung ist genehmigt.

Alle vier Seiten des Maßnahmenblatts Oktober 2025 und SRL PDF-Seite 51 wurden
mit Mahd-/Weide-/Substanz-/Antrags-/Prämienausnahmen gelesen; allgemeine
Teilnahmebedingungen und Anhang L im jeweiligen Scope berücksichtigt.
79 verwendete Vorschlagsfundstellen sind wörtlich auf Originalseite und mit
Quellhash gebunden. Auffindbarkeit bestätigt keine normative Freigabe sämtlicher
98 Katalogregeln. Beide Runs und App nutzen dasselbe Maßnahmenblatt mit Hash
`5c41df92f32e30cadf861474f4b51e3af9b8c74fe2b4494020bc876bc2ae149e`.
Die geprüften 2026-Nachrichten begründen keine pauschale Bergmähder-Ausnahme;
insbesondere NAT-Nachweide ab 12.8. ersetzt nicht den hier genannten 16.8.

[Pfadvergleich](path-review.md) trennt GIS-Flächenanteil, Höhenpunkt, lokale
Siedlungsgrenze und Almbetriebs-Ausnahme. [13 OPA-Beobachtungen](policy-findings.md)
zeigen fehlende Zweijahresprüfung bei Luna, unvollständige Vorjahresbelege bei
Opus und vom Vertrags-/Pflichtenstatus unabhängige Prämien. Acht
[präzisierte Fachfragen](questions.md) ergänzen die bisherigen fünf o6_4-IDs
im [Sammelissue #140](https://github.com/ghinta/oepul-recommender/issues/140);
alle bisherigen Entscheidungen bleiben offen.

App-Stand ist gepinnt auf `5296108f5756ef1463c25a49d93d4a346e9b5e9c`.
Das Tool fragt Schnittdaten und gemeinsame Schlagcodes ab, o6_4 bleibt aber
Category C mit `missing_data`, selbst bei gefüllten Eingaben. Beide vollständigen
Rohmodellstrukturen werden nicht zu einer Bergmähder-Empfehlung ausgewertet.

Mahd-/Weide-/Substanzereignisse und Quellen-/Jahreskontext sind belegte
Wiederverwendungskandidaten. Die fachlichen Scopes bleiben verschieden:
NPA-Pflege verlangt keinen Mahdgutabtransport, Bergmähder verlangen ihn;
Heuwirtschaft bepreist gemähte Flächen, Bergmähder erlauben ein BM0-Jahr mit
fortbestehenden anderen Pflichten. [Laufende Synergien](../sequential-variable-reviews-20261008/synergies.md).

Keine Policy-Implementierung, kein Modelllauf, kein Merge, keine Änderung an
App, Thesis, Quellen oder Runs. Vollständiger Helper-Konsum, neue amtliche
Fassungen, reale Snapshots und unabhängige Golden-/App-E2E-Prüfungen bleiben offen.
