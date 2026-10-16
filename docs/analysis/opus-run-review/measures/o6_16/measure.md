# o6_16 – Fachbedingungen und Optionen

138 öffentliche Entwicklungsfälle mit 286 typisierten Prüfungen: 277 erfüllt, 9 nicht erfüllt. Native Statuswerte: `{'defined': 138}`. Das sind gezielte Entwicklungsfälle, keine Genauigkeitsquote oder Expertenabnahme.

Alle 65 zugeteilten Regeln sind in [measure.json](measure.json) einzeln beurteilt. Das neue 17-seitige Merkblatt und der vollständige neue AMA-Hinweis vom 25.08.2026 wurden gelesen. Seite 12 wurde zusätzlich als Bild geprüft: Der Durchschnitt 157 g umfasst die drei Mastphasen; alternativ gelten 170/155/150 g. Es müssen nicht beide Alternativen erfüllt sein. Alle elf produktiven Module mit 1.702 Zeilen, acht Annahmenabschnitte und 34 tatsächlichen Profilvorschläge wurden vollständig gelesen.

Die Entwicklungsfälle prüfen unter anderem die strikten Übertragsschwellen >10 bis 2024 und >20 ab 2025, Deckel 100 vor dem Faktor, 80/60 %, die Quellenbeispiele 108/60 und 60−24=36, Herbstbegrünung samt später Ernte und Ackerfutterausnahme, einmalige Faktorverwendung, 14/15 Tage, Weiterbildung, Konzept, Labor-/Parameter-/Übernahmebedingungen, zulässige AG-Nutzungen, Umbruchgrenze im zweiten Jahr, Wien, Fütterungsalternativen und Cultan. Vorbereitete Nachweisflags und Mengen sind keine amtlichen Register- oder Dokumentbelege.

| Konkreter Gegenfall | Quellensoll | Native Ausgabe |
|---|---|---|
| 2 ha bekannte nicht prämienfähige AG-Nationalparkfläche, daneben 8,01 ha normale Fläche | AG 0 €, gesamt 913,14 € | AG 1.080 €, gesamt 1.993,14 € |
| Bekannter Metazachlor-Einsatz auf Körnermais/Silomais | Verbotsmeldung wie bei Mais | Meldung fehlt für beide Bezeichnungen |
| Je 10 ha Mais/Körnermais/Silomais ohne verbotenen Einsatz | jeweils 216 € PSM-Zuschlag, gesamt 1.356 € | Mais richtig; Körnermais/Silomais Zuschlag 0 €, gesamt 1.140 € |
| Nur Bio-zugelassener Einsatz, jedoch PSMCS statt PSMBIO, 2025 | Klassifizierung nicht erfüllt | Ausnahme für gemischten Einsatz greift auch hier |

Die Nationalpark-Grenze wird beim normalen Prämienzweig berücksichtigt, bei AG fehlt sie. Die Mais-Bezeichnungen sind auch innerhalb desselben Runs uneinheitlich: Die OÖ-Hilfsregel erkennt Körnermais und Silomais, die PSM-Verbots-/Prämienliste nicht. Für diese Versuche wurde keine reale Produktzulassung aus einem erfundenen Registerbeleg abgeleitet.

Das Merkblatt 04/2026 lässt die PSM-Codierung ab 2026 entfallen; die tatsächlich gelieferte GSP-AV 28.01.2026 §34 Abs.2 Z12 lit.f verlangt die Angabe weiterhin. Der Run benennt seinen Vorrang für das Merkblatt offen. Das löst den Quellenkonflikt nicht. Ebenso bleiben frühere KG-Kulisse, einzelne Schweinekategorien, Eber-GVE, OÖ-Landesfinanzierung und zeitliche Projektvorgaben als Abhängigkeiten sichtbar.

Die NAPV ist hier tatsächlich vollständig als Original geliefert. Viele ihrer materiellen Vorgaben werden trotzdem auf allgemeine Nachweisflags oder separate Hilfsfunktionen verlagert. Die Saldorechnung wird nicht als vollständige Kulturfolge mit Belegen geführt. Die vierjährige allgemeine Programmaufbewahrung ersetzt nicht eigenständig die längeren NAPV-Aufbewahrungspflichten. Der korrekte Programm-Helfer wird deshalb nicht als an sich falsche NAPV-Frist umgedeutet.

Eigene Konstruktionkorrekturen sind mit alten Teilhashes dokumentiert: Vor der ersten Domainausführung wurden widersprüchliche Kultur-/Tierzahl-/NAPV-Prämissen bereinigt. Danach wurden bei drei 2025er Codierungsfällen die versehentlich geerbten 2026er Begleitdaten und bei fünf Wiener Fällen die Probengebietsflags korrigiert. Queries und Sollwerte dieser Fälle wurden nicht angepasst; alle Fälle wurden vollständig erneut ausgeführt. Die drei zusätzlichen Mais-Prämienfälle wurden vor ihrer ersten Ausführung gespeichert. Der Literalbeleg für Silomais stammt aus der gelieferten NAPV, die Prämienkategorie Mais aus dem Merkblatt.
