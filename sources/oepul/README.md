# AMA-ÖPUL-Quellen

Dieser Ordner enthält einen prüfbaren AMA-ÖPUL-Quellenstand. Das Root-Manifest
verweist auf den frischen Abruf vom 10.10.2026 mit den SRL/Anhängen vom
01.10.2026. Die unveränderlichen September-Manifeste und damals verlinkten
2024-Originale bleiben erhalten. Der Pflichtkern
besteht aus den aktuell verlinkten allgemeinen Teilnahmebedingungen und allen
26 Maßnahmeninformationsblättern. Ergänzend werden die aktuell von AMA
verlinkte Sonderrichtlinie samt Anhängen sowie ausgewählte, regelrelevante
amtliche Meldungen des Jahres 2026 archiviert.

Die Quellen werden nicht pauschal auf „Stand 2026“ umbenannt. Das Manifest
unterscheidet ausdrücklich zwischen Dokumenten mit einer 2026-Ausgabe und
Dokumenten, für die die AMA weiterhin eine Ausgabe mit Stand Oktober 2025
verlinkt.

## Inhalt

- `originals/`: unveränderte, editionsbezogen benannte Original-PDFs
- `legal/`: aktuell verlinkte Sonderrichtlinie und Anhänge unter ihrem echten
  offiziellen Dateinamen und -datum
- `notices/2026/`: unveränderte HTML-Seiten ausgewählter 2026-Ausnahmen
- `manifest.json`: aktueller, maschinenlesbarer Quellenstand
- `manifest.schema.json`: Strukturvertrag des Manifests
- `provenance/<run-id>/`: Snapshots aller drei Indexseiten, Manifest-Snapshot
  und Abrufprotokoll
- `manage_sources.py`: Update und lokale bzw. Online-Validierung
- `intake.json` / `source_intake.py`: getrennte aktuelle Aufnahmeverpflichtungen,
  Originalbelege, Indexbeobachtungen und vollständige Tabellen-/Register-/GIS-Prüfung
- `supplemental/`: unveränderliche, nach Inhalts-Hash abgelegte Originale ergänzender Quellen

Die Informationsblätter weisen selbst darauf hin, dass sie rechtlich
unverbindlich sind. Dieser Pack behauptet auch mit Sonderrichtlinie, Anhängen
und Jahresmeldungen **keine rechtliche Vollständigkeit**: weitere nationale
und unionsrechtliche Grundlagen, Änderungen sowie einzelfallbezogene
Entscheidungen können relevant sein. Diese Scope-Grenze ist zusätzlich als
maschinenlesbares Feld `scope.legal_completeness_claimed: false` festgehalten.

## Voraussetzungen

- Python 3.11 oder neuer
- `pypdf`

## Aktualisieren

```bash
python3 sources/oepul/manage_sources.py update
```

Das Update:

1. lädt die offiziellen AMA-Seiten für Merkblätter, Rechtsgrundlagen und
   Aktuelles 2026,
2. erwartet exakt die allgemeinen Teilnahmebedingungen und die 26 bekannten
   Maßnahmenkennungen,
3. lädt jedes aktuell verlinkte Kern-PDF, die beiden ausgewählten
   Rechtsgrundlagen-PDFs und vier ausgewählte 2026-Meldungen,
4. prüft PDF-Kopf, Dateiname und den im Dokument gedruckten Stand,
5. legt neue Originaldateien atomar ab,
6. erzeugt einen unveränderlichen Provenance-Lauf,
7. aktualisiert das Root-Manifest.

Vorhandene Originale werden nie mit abweichenden Bytes überschrieben. Eine
solche Kollision bricht das Update ab und muss als neue Quellenedition geklärt
werden. Bei geänderten HTML-Meldungen kann ein neuer Capture ausdrücklich unter
einem eigenen Inhalts-Hash-Pfad archiviert werden:

```bash
python3 sources/oepul/manage_sources.py update --capture-changed-notices
```

Ohne diese Option bleibt der Kollisionsschutz aktiv; er wird für PDFs durch die
Option nicht verändert. Nicht mehr aktuelle Originale und Meldungsbytes bleiben
erhalten. Das Inhaltsdatum einer Meldung wird nicht auf das Abrufdatum umgestellt.

## Validieren

Nur lokale Dateien und Metadaten prüfen:

```bash
python3 sources/oepul/manage_sources.py validate
```

Zusätzlich prüfen, ob das Manifest noch exakt der live verlinkten AMA-Seite
entspricht:

```bash
python3 sources/oepul/manage_sources.py validate --check-index
```

`--check-index` benötigt Netzwerkzugriff und prüft alle drei offiziellen
Indexseiten. Ein späterer Abruf kann legitime amtliche Aktualisierungen melden;
dann ist zuerst `update` auszuführen und der entstandene Delta zu prüfen. Neue
regelrelevante Jahresmeldungen werden bewusst kuratiert: `NOTICE_SOURCES` im
Updater ist die explizite, überprüfbare Auswahlliste und kann erweitert werden.

## Aktuelle Quellenaufnahme für App #139 — Lab #104

`intake.json` erhält 43 erforderliche Scopes: alle 27 Merkblätter, aktuelle SRL
und Anhänge, WRRL/Anlage 3, GSP-AV/NAPV, Anbieter, Prämien, L-/J-Matrizen samt
Fußnoten, Tier-/N-Faktoren, Produkt-/Betriebsmittelregister, echte GIS-Fassungen
und die benötigte kuratierte Jahresmeldungsmenge. Scopes dürfen nicht entfernt
werden, um die Prüfung grün zu bekommen. Nicht jede Quelle ist für jede Maßnahme
erforderlich; die Aufnahmeprüfung kann auf den konkreten Verbraucher begrenzt werden.

Am 10.10.2026 wurden alle 27 AMA-Merkblätter frisch heruntergeladen. Ihre Bytes
stimmen mit den September-Originalen überein; 11 Dokumente tragen eine
2026-Ausgabe und 16 weiterhin den offiziell verlinkten Stand Oktober 2025.
Die neuen SRL/Anhänge bestehen die Prüfung auf 94/104 Seiten und die Kennung
2026-0.267.890. Der unveränderliche Lauf
`provenance/20261010T205920107220Z/` enthält alle drei rohen Indexsnapshots,
das Manifest und die Abrufprovenance des Pflichtkerns einschließlich vier
kuratierter Meldungen. Geänderte HTML-Seiten liegen additiv in `notices/2026/captures/`;
die Artikel-HTMLs der vier Meldungen sind unverändert, ihre Umgebungs-HTMLs nicht.

Aktuell sind **33/43 Aufnahme-Scopes bereit**, zehn bleiben offen. Vollständige
Originalaufnahme, Tabelleninventar und fachliche Zulassung bleiben eigene Nachweise.
WRRL-Programm/Anlage 3, Bildungsanbieter sowie die datierten AMA-Spiegel der
GSP-AV/NAPV sind ebenfalls archiviert. Die beiden Rechtsfassungen brauchen noch
den Abgleich mit der aktuellen RIS-Konsolidierung. J-Matrix, WRRL-Anlage 3 und
Bildungsanbieter haben vollständige, separat inventarisierte Quellenreviews.
L-Matrix und Tierfaktoren bleiben trotz erfasster Originaltabellen offen:
L-Fußnote 4 ist im amtlichen Original abgeschnitten; Anhang A belegt allein
keine Jahres-, Weide- und Almzeiträume. `reviews/20261010/reconciliation.json`
dokumentiert den nachträglichen Abgleich der Extraktionen, deren Entstehungsstand
in den einzelnen Artefakten erhalten bleibt. Details und weitere Quellenlücken
stehen in `docs/changes/current-source-intake/`.

Die zwei im Expertenagenda-Issue genannten fehlenden Meldungen vom 25.08.2026
(Grundwasserschutz-Aufzeichnungen) und 02.09.2026 (Tiermeldungen) ergänzen die
vier Kernmeldungen über separate unveränderliche Imports. Der Meldungsscope
pinnt alle sechs Originale und Ziel-URLs, bleibt aber bis zur vollständigen
verbraucherspezifischen Auswahl und Quellenprüfung offen.

Mit erlaubtem Netzwerkzugriff archiviert der bestehende Updater den aktuellen
Pflichtkern samt SRL/Anhängen, Indexsnapshots und vier ausdrücklich kuratierten
Meldungen. Er behauptet damit weder die Vollständigkeit aller Jahresmeldungen noch
aller österreichischen/EU-Rechtsakte:

```bash
python3 sources/oepul/manage_sources.py update
python3 sources/oepul/manage_sources.py validate --check-index
```

Bereitgestellte Originale können ohne Netzwerk über **denselben Manager** importiert
werden. Quelle und tatsächliches Abrufdatum sind anzugeben; es wird keine HTTP-
Antwort erfunden. Import allein aktualisiert weder das Root-Manifest noch die
fachlichen Regeln oder Tabellenfreigaben:

```bash
python3 sources/oepul/manage_sources.py import \
  --source-id oepul_sonderrichtlinie_2023 \
  --file /tmp/srl_oepul_2023_20261001.pdf \
  --official-url https://www.ama.at/media/tp2fbtou/srl_oepul_2023_20261001.pdf \
  --retrieved-at 2026-10-10T08:00:00Z \
  --evidence-note 'Unverändertes amtliches Original, durch Betreuer bereitgestellt'
```

Der Manager prüft PDFstruktur, registrierte Änderungskennung und die bekannten
94/104 Seiten der neuen SRL/Anhänge. Historische 2024-Originale bleiben erhalten.
WRRL-Originale und Bildungsanbieter sind ebenfalls registriert. Zusätzliche
`gsp_av`, `napv`, `premium_rates`, `nitrogen_factors`,
`plant_protection_register`, `bio_input_catalogue`, `gis_layer_versions` und
`year_specific_notices` unterstützen die passenden PDF-/HTML-/XLSX-/CSV-/JSON-/
XML-/ZIP-/GeoPackage-Formate aus der geprüften Herausgeberliste. Beispiel für
eine tatsächlich bereitgestellte Prämien-XLSX: dieselbe Importanweisung mit
`--source-id premium_rates`, ihrem lokalen Dateinamen und der echten BMLUK-URL.
XLSX-Struktur, GeoJSON-FeatureCollection bzw. GeoPackage-Katalog werden geprüft;
das ist noch keine vollständige Tabellen-, GIS- oder Rechtsprüfung. Bei weiteren
Herausgebern ist die Registry zuerst überprüfbar zu erweitern. Selbst erzeugte
Extraktionsdateien werden nicht als amtliche Originale ausgegeben.

Danach werden in `intake.json` die Original-/Provenancepins und die **rohen,
gehashten Indexsnapshots** aufgenommen. Quellenprovenance verweist auf den
unveränderlichen Abruf-/Importlauf, nicht den überschreibbaren Root-Manifestzeiger.
Ein Originalimport beweist allein nicht, dass dessen URL noch aktuell verlinkt ist.
Datum und Zielmenge der Indexaufnahme müssen exakt zum Inventarstichtag passen;
bei mehreren Originalen eines Register-/GIS-/Meldungsscope werden zusätzliche
Captures und Indexziele explizit erfasst. Fehlende oder künftig datierte Belege
dürfen keine aktuelle Aufnahme vortäuschen.

Für Tabellen/Register/GIS und ergänzende Rechtsfassungen braucht `review` eine
gehashte vollständige Erfassung und ein **separat gepinntes Sollinventar**:
`scope_id`, `original_source_hashes`, `source_locator`, `established_by`,
`expected_item_ids`, `expected_footnote_ids`. Ein anderer Reviewer kontrolliert
die Erfassung; deren `items` tragen `id`, `value`, `source_locator`, deren
`footnotes` tragen `id`, `text`, `source_locator`. GIS ergänzt `crs`,
`layer_version`, `spatial_extent`. Die Maschine prüft die Bindung und vollständige
Abdeckung dieses unabhängig erstellten Inventars. Die korrekte Ermittlung aller
amtlichen Tabellen-/Listen-/Fußnotenelemente bleibt eine dokumentierte manuelle
Originalprüfung. Eine selbst verkleinerte Extraktionsliste gilt nicht als Sollinventar.
Für L-/J-Matrizen und RGVE-Faktoren wird die aktuelle Anhang-PDF als Original
verwendet; ihre Extraktion ist eine Reviewdatei. Ein alter 441-/64-Zellenaudit
beweist keine aktuelle Abdeckung.

```bash
python3 sources/oepul/source_intake.py
python3 sources/oepul/source_intake.py --require-ready --scope o6_3
python3 sources/oepul/source_intake.py --require-ready
```

`ready` gilt ausschließlich **zum angezeigten Inventarstichtag**, nicht als
automatisch erneuter Livecheck bei jedem Aufruf. Der einzelne Aufnahmescope
`o6_3` besteht jetzt; die strikte Gesamtprüfung scheitert weiterhin an zehn
ausstehenden Scopes. Beide ändern keine App-Empfehlung und schließen keine
Expertenfrage. Die acht o6_3-Zulassungsgates bleiben offen. Abschnitt 1.20 der neuen SRL
benennt die Anwendung der zweiten Änderung ab 01.01.2027 und die Ausnahme für
PSM-Angaben im Antragsjahr 2026. Für letztere wird kein zusätzlicher kalendarischer
Geltungsbeginn erfunden. Andere Klauseln und alte Belege behalten ihren eigenen
Zeitbezug; zukünftige Leistungen werden nicht als heutige Erfüllung aufgenommen.
