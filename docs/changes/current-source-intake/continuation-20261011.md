# Quellenaufnahme nach neuer Cloud-Veröffentlichung — 11.10.2026

Die neue Sitzung verwendet Konfigurationsversion
`cecfgver_6acb2101fb988198bc942ad2df1c3c3d`, Revision 2, und frisch beobachtetes
`unrestricted/enforced`. Echte öffentliche HTTPS-Abrufe über den vorgesehenen
Proxy mit TLS-Prüfung liefern für AMA, BMLUK und beide RIS-Hosts HTTP 200.
Die früheren CONNECT-403 betreffen die alte Instanz; sie werden nicht als
aktueller Netzwerkstand übernommen. `network-check-20261011.json` enthält
Runtime-Identität und die tatsächlichen Probeantworten.

## Neue Originalaufnahme

Der bestehende Quellen-Manager hat den gesamten AMA-Pflichtkern erneut
abgerufen: 27 Merkblätter, SRL/Anhänge, drei rohe Indizes und vier Kernmeldungen.
Der unveränderliche Lauf ist `sources/oepul/provenance/20261011T071518180217Z/`.
Alle PDF-Bytes und die vier ausgewählten Meldungsbytes stimmen mit dem
10. Oktober überein. Die drei ergänzenden AMA-Quellen, beide datierten
Rechtsspiegel und die zwei weiteren Meldungen sind ebenfalls frisch erfasst;
deren HTTP-, Index- und Importbelege stehen im Supplemental-AMA-Report.
Historische Reviewartefakte bleiben mit ihrem Entstehungsdatum erhalten und
sind wegen identischer Originalhashes wiederverwendbar.

Die BMLUK-Prämien-XLSX ist erstmals als vollständiges amtliches Original
archiviert (95.793 Bytes, SHA-256
`2750d4f96ef0007c05ba0bfbcdee08f6a46418bea3c038de33bd07e9ec39ad02`).
Der echte Link im rohen Ministeriumsindex enthält `jcr:`; die mit `%3A`
kodierte Probe-URL wird nicht nachträglich als wörtlicher Indexlink behauptet.
Importkennzeichnung und die separat dokumentierte tatsächliche HTTP-Antwort
bleiben getrennt. Inventar und Extraktion sind unabhängig aus dem Original
erstellt; sie werden nicht aus einer gegenseitig verkleinerten Liste abgeleitet.

Die datierten vollständigen RIS-Konsolidierungen der GSP-AV (94 Seiten) und
NAPV (42 Seiten einschließlich Anlagen 1–5) sind erfasst. Amtliche
Kundmachungs-/Änderungsoriginale und rohe ELI-Indizes liegen ergänzend mit
eigenen HTTP-, Original- und Importpins vor. Details und Grenzen stehen in
`ris-gsp-av-20261011.md` und `ris-napv-20261011.md`.

Der separate NAPV-Struktur-/Tabellen-/Notenreview ist inzwischen unabhängig
inventarisiert und mit beiden echten Originalhashes (datierte HTML und exakt
verlinkte PDF) gepinnt. Die HTML ist als zusätzliches vollständiges Original
erhalten; das aktuelle Intake enthält damit **42 unterschiedliche Originale**.
Der rohe datierte Index verlinkt seine PDF, jedoch nicht sich selbst. Der
strikte Ein-Index-Vertrag kann dieses Paket deshalb nicht aktuell freigeben;
`napv` bleibt offen. Die Reviewzählungen bezeichnen Quellartefakte, nicht
unterschiedliche normative Tatsachen oder ausführbare Regeln.

## Belegte Abweichungen und verbleibende Entscheidungen

Bei der GSP-AV ergibt der vollständige maschinelle Vergleich zum AMA-Spiegel
vom 28.01.2026 nur die geänderte Konsolidierungsdatumszeile. Die Seiten 2–94
haben identische dekodierte PDF-Inhaltsstreams. Dieser Befund ersetzt keinen
vollständigen unabhängigen Klausel-/Anhang-/Fußnotenreview.

Der AMA-NAPV-Spiegel vom 28.10.2024 enthält noch § 2 Abs. 1a mit einer
befristeten Ausnahme. Die aktuelle RIS-Konsolidierung enthält diesen Absatz
nicht. BGBl. II Nr. 277/2024, § 12 Abs. 3, belegt das Außerkrafttreten mit
Ablauf des 31.12.2024. Der alte Spiegel darf daher nicht pauschal als aktueller
Rechtsvolltext eingesetzt werden. Konsolidierungs- und Abrufdatum werden nicht
als Inkrafttretensdatum ausgegeben.

Die Prämien-XLSX enthält sechs Blätter, davon zwei versteckte historische
Blätter. Das OOXML enthält 2.633 tatsächlich befüllte Zellen, darunter 16 von
gängigen Workbook-Lesern verdeckte Werte unter verbundenen Zellen. Weitere
214 verbundene Bereiche, 286 Formeln samt gespeicherten Ergebniswerten,
Leerzellen, Noten, Einheiten und Bedingungen bleiben erhalten. Leere
Jahresspalten werden nicht mit älteren Werten aufgefüllt. Projektbestätigungen,
regionale Gebietskulissen, `$`-Platzhalter und alle benötigten SRL-Prämienklauseln
sind dadurch nicht abschließend zugeordnet; der breite Prämien-Scope bleibt
offen, auch bei vollständigem Workbookreview.

Das Intake wird nur mit tatsächlich neuen Abruf-/Indexbelegen auf den
11.10.2026 fortgeschrieben. GSP-AV/NAPV, Prämien, L-Fußnote, Tierzeiträume,
N-Faktorfamilien, Register, GIS und vollständige Meldungsauswahl benötigen
weiteren Quellen-/Scope-Review. Die acht o6_3-Gates und 418 bestehenden
Frage-IDs bleiben offen. Keine fachliche Regel, kein Canonical Profile, kein
historischer Modellrun und keine Thesis-Datei werden verändert; kein Merge.
