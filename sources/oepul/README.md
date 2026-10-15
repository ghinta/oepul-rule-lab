# AMA-ÖPUL-Quellen

Dieser Ordner spiegelt einen prüfbaren AMA-ÖPUL-Quellenstand. Der Pflichtkern
besteht aus den aktuell verlinkten allgemeinen Teilnahmebedingungen und allen
26 Maßnahmeninformationsblättern. Ergänzend werden die aktuell von AMA
verlinkte Sonderrichtlinie samt Anhängen, ausgewählte weitere Rechtsgrundlagen
(GSP-AV, NAPV, Grundwasserschutzprogramm Graz bis Bad Radkersburg) sowie
ausgewählte, regelrelevante amtliche Meldungen des Jahres 2026 archiviert.

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
3. lädt jedes aktuell verlinkte Kern-PDF, die ausgewählten
   Rechtsgrundlagen-PDFs (`LEGAL_SOURCES`) und die ausgewählten 2026-Meldungen
   (`NOTICE_SOURCES`),
4. prüft PDF-Kopf, Dateiname und den im Dokument gedruckten Stand,
5. legt neue Originaldateien atomar ab,
6. erzeugt einen unveränderlichen Provenance-Lauf,
7. aktualisiert das Root-Manifest.

Vorhandene Originale werden nie mit abweichenden Bytes überschrieben. Bei den
2026-Meldungen wird vor dem Vergleich nur die Seitenleiste „Aktuelle News“
(`c-news-page__quicklink-more`) ausgeblendet, weil AMA dort laufend neuere
Meldungen verlinkt. Ist der übrige Inhalt gleich, bleibt die archivierte Datei
samt Hash unverändert; jede andere Abweichung bricht weiterhin ab. Eine
solche Kollision bricht das Update ab und muss als neue Quellenedition geklärt
werden. Nicht mehr aktuelle Originale bleiben erhalten.

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

## Zuordnung zu Maßnahmen

Rechtsgrundlagen und Meldungen ohne `applies_to_measures` gehen in jeden Run.
Mit `applies_to_measures` nimmt `rulelab prepare` sie nur für die genannten
Maßnahmen in den Workspace auf. So erhalten etwa nur o6_24 das
Grundwasserschutzprogramm Graz bis Bad Radkersburg samt Anlage 3 und nur die
tierbezogenen Maßnahmen die Meldung zu Meldepflichten, statt jeden Run mit
allen Dokumenten zu belasten. Die GSP-AV gilt maßnahmenübergreifend und hat
daher keine Einschränkung.
