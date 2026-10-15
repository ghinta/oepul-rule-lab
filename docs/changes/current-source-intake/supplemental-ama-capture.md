# AMA-Zusatzquellen: Originalaufnahme vom 10. Oktober 2026

Die drei registrierten AMA-Originale wurden mit den bestehenden Funktionen
`manage_sources.request`, `pdf_response` und `import_original` aufgenommen.
Der Import änderte weder den historischen Manifeststand noch `intake.json`.
Bestehende Originaldateien wurden nicht überschrieben. Die nachfolgenden
Tabellenreviews belegen Quellenabdeckung; rechtliche Vollständigkeit und
einzelbetriebliche Zulässigkeit werden nicht behauptet.

Vollständige Capture- und Index-Payloads einschließlich Original-, Import- und
Snapshot-Hashes stehen in
`sources/oepul/provenance/supplemental-ama-20261010T205753528595Z/capture-report.json`
(SHA-256 `e73ea8c95291d792e9d703646d3f45577be0f537f5c836e8a4ee048e335d7a90`).
Die Original-URLs wurden aus den erhaltenen HTML-Bytes der AMA-Rechtsgrundlagen-
und Listenindizes aufgelöst. Alle drei Originalantworten waren HTTP 200 mit
`application/pdf`; sämtliche Originale und Indizes wurden am 10. Oktober 2026
erneut abgerufen. Die separaten HTTP-Beobachtungen ändern nicht die wahrheitsgemäße
Importkennzeichnung `supplied_original_file`.
Der unveränderte Capture-Report dokumentiert den Aufnahmezustand vor der
anschließenden Erstellung der Reviewartefakte.

| Source-ID | Originalseiten | Original-SHA-256 |
| --- | ---: | --- |
| `wrrl_programme` | 11 | `d96e759017f5d19721c02fec78050fda9914beaa742c9d747e4e366495093338` |
| `wrrl_annex3` | 6 | `a8e3350cc070209213513f1e7711ec71dddb7f842f0c65eb92957bedc0f209d2` |
| `training_providers` | 2 | `81f82e2f676f51a4359a3b43e622891ee92697501e2ffe2709859c7c1ac32199` |

Alle drei Capture-Verträge wurden mit `source_intake.verify_capture` geprüft;
die erhaltenen Snapshot-Hashes und enthaltenen Original-URLs wurden separat
überprüft. Diese Prüfungen sind Herkunfts- und Byteprüfungen, keine fachlichen
Tabellenreviews.

## Vollständig inventarisierte Quellenreviews

Die separaten Dateien unter `sources/oepul/reviews/20261010/` enthalten die
an Originalhashes gebundenen Reviews und unabhängig aus den Originalen
etablierten Expected-Inventare. Beide vollständigen Item- und Fußnoten-ID-Sätze
stimmen überein; `source_intake.verify_review` bestand für beide Quellen.
Ein weiterer unabhängiger Abgleich der erfassten Werte mit den visuell
geprüften Originalen fand keine fachlichen Transkriptionsabweichungen.

| Scope | Vollständig erfasste Originalinhalte | Review / Expected |
| --- | --- | --- |
| `training_providers` | 15 Anbieter, 7 Spalten, sämtliche 105 Anerkennungszellen (43 X und 62 Leerzellen), Datum, Geltungshinweis und UBB-Fußnote; 129 Items / 1 Fußnote | `training_providers.review.json` / `training_providers.expected.json` |
| `wrrl_annex3` | Alle fünf Tabellen, 127 inhaltliche Zeilen, sämtliche 399 Werte-/Datums-/Intervallzellen, die zusätzliche gedruckte Leerzeile mit sechs Leerzellen, Spalten, Einheiten, Bildsignatur und alle 31 Absätze/Hinweise/Bedingungen; 540 Items / 31 Fußnoten | `wrrl_annex3.review.json` / `wrrl_annex3.expected.json` |

Die X-/Leerzellen wurden auf beiden Originalseiten visuell geprüft. Sämtliche
sechs Anlage-3-PDF-Seiten wurden einschließlich Tabellenfortsetzungen und
Bildsignatur visuell geprüft. Anlage 3 besitzt keine gedruckten Seitennummern;
ihre Review-Locators beziehen sich ausdrücklich auf den PDF-Seitenindex.

## Weiterhin erforderliche fachliche Entscheidungen und Quellen

- **WRRL-Programm:** Die aktuelle vollständige 11-Seiten-Datei ist erhalten.
  § 9a Abs. 2 auf Druckseite 4 nennt den **8. Juni 2026** als Inkrafttreten der
  Änderungen aus LGBl. Nr. 47/2026 an § 5 Abs. 2 Z 4 lit. b und Anlage 3;
  die auf dem Deckblatt genannte konsolidierte Fassung vom **1. Juli 2026**
  darf nicht als allgemeines Wirkungsdatum verwendet werden. Fachliche Anwendung,
  räumlicher Geltungsbereich, Ausnahmen, Übergänge und einzelne Bewilligungen
  bleiben zu prüfen. Die geografischen Anlagen 1, 2A und 2B-1 bis 2B-58 sind in
  diesem Original als externe Anhänge bezeichnet; deren Originalkarten und
  GIS-Versionen werden durch diese PDF-Aufnahme nicht abgedeckt.
- **Anlage 3:** Die Tabellen- und Begleittextabdeckung ist nun vollständig
  inventarisiert und überprüft. Die Anwendung der Bedingungen der
  10-%-Erhöhung (PDF-Seite 4), deren Einordnung mit WRG-/NAPV-Grenzen und
  Wintergersten-Sonderregelung sowie individuelle
  Bewilligungstatbestände bleiben ausdrücklich fachlich zu prüfen.
- **Bildungsanbieter:** Das Original trägt `STAND Oktober 2025` und ist weiterhin
  Ziel des aktuell aufgenommenen AMA-Listenindex. Die Anerkennungsmatrix ist
  vollständig abgedeckt; das Original enthält keine gesonderten individuellen
  Anerkennungsdaten pro Anbieter. Eine Anerkennungszelle ersetzt keinen Nachweis
  eines tatsächlich absolvierten Kurses oder dessen konkreter Anrechnung.

Quellenreview, Expert Review und Aufnahme einer ausführbaren Regel bleiben
getrennte Entscheidungen. Keine ausführbare Regel wurde durch diese Arbeit
hinzugefügt oder freigegeben.
