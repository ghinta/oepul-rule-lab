# Unabhängige Qualitätskontrolle: BIO (o6_1b)

Stand 15.10.2026. Die geprüfte finale Fassung enthält keine offene wesentliche
Unstimmigkeit im Dossier oder Replay. **Der historische BIO-Kandidat bleibt für
seine native App-Aufnahme blockiert.** Diese Kontrolle ist keine Abnahme durch
GM oder Domainexpert:innen und schließt keine andere Maßnahme ab.

Alle 107 öffentlichen Entwicklungsfälle mit 108 Komponentenprüfungen wurden
unabhängig bytegenau reproduziert. Es gibt 101 definierte Ergebnisse, drei
undefinierte und drei Laufzeitfehler; 59 Erwartungen treffen zu, 49 nicht.
Die gezielten und teilweise verwandten Fälle ergeben keine Genauigkeitsquote.
Die drei undefinierten Ergebnisse betreffen den Zeitraum vor dem ersten
Prämienjahr sowie zwei direkte Standortprädikate bei fehlender bzw. zu hoher
Hangneigung. Sie entstehen nicht durch fehlenden Daten-Namensraum.

Der korrekte Verzeichnislader wurde zusätzlich unabhängig mit der vollständig
veröffentlichten ursprünglichen BIO-Baseline verglichen: alle zehn Ergebnisfelder
und sämtliche Unterwerte stimmen typisiert überein. Auch der echte Namespace
mit 40 Prämiensatzzeilen und ein 235-EUR-Satzverbraucher funktionieren. Die
frühere Einzeldatei-Ladung liefert dagegen `undefined`; dieser vorläufige
fehlerhafte Lauf wurde verworfen. Die ursprüngliche Ausgabe dient hier nur als
technische Regression und liefert keinen fachlichen Sollwert.

Die Regelabdeckung enthält genau 200 historische Kennungen. 214 Bewertungen
mit 14 Überschneidungen bleiben vollständig erhalten. Alle 92 Tabellenpointer
in acht Datendateien sind auflösbar; die Eintrags- und Prüfzeilenzahlen stimmen,
insgesamt 940 direkte Zeilen/Schlüssel. Die 89 Vorschlagspfade entsprechen auch
als Multimenge dem ursprünglichen Katalog. Diese Kontrollen bestätigen
Identität und Abdeckung, keine zweite vollständige fachliche Beurteilung aller
Regeln, Blattpfade oder Tabellenzeilen.

In den Originalquellen wurden ausgewählte Hauptbefunde nachgelesen: LSE-
Kombinationsbeschränkungen auch ohne DIV, OPUBB-Ausnahme bei weiter möglicher
BIO-Prämie, SLK-Kultur/Sorte und die eng begrenzte Mohn-Ausnahme, unmähbare
Weideflächen im DIV-Zähler, physische Flächen bei überlappenden KW-Eigenschaften,
WB bis einschließlich 30. Juni, Ansaat im richtigen Kalenderjahr sowie
zertifizierte Eigenbedarfshühner und Nullgruppen bei Equiden. Die konkreten
Leseseiten und Grenzen stehen im JSON-Bericht. Dies ist keine vollständige
zweite Quellenlektüre.

Die Wortlautkontrolle findet 2.590 dokumentgebundene Zitatvorkommen an 986
unterschiedlichen Kombinationen aus Quelle, Seite und Zitat. Vier Treffer
benötigen kompakte Typografie-Normalisierung; alle übrigen stimmen nach
Whitespace-Normalisierung. Wiederholte Zitate sind keine zusätzlichen
unabhängigen Begründungen. Ein Wortlauttreffer allein bestätigt keine
fachliche Schlussfolgerung oder Quellenhierarchie.

Wichtige Aussagegrenzen bleiben ausdrücklich erhalten: Fehlende Nachweise
beweisen keinen tatsächlichen Verstoß. Die Fälle des positiven App-Nachweisvertrags
sind entsprechend gekennzeichnet. Die native Darstellung vor dem ersten
Prämienjahr ist eine technische Beobachtung; die Quelle verlangt nicht
`undefined`. Vier gebrochene Kopfzahlen sind Typ-/Einheiten-Stresstests außerhalb
des eingefrorenen Ganzzahlvertrags. Die WB-Juni-Probe nimmt synthetisch an,
dass vorher kein Drusch erfolgte; ein unvollständiges reales Ereignisprotokoll
würde das allein nicht beweisen. Früherer Drusch kann das Betriebsmittelverbot
beenden. Die getrennten numerischen Abweichungen der gepinnten Binary sind
keine pauschalen Modellfehler oder ein Nachweis für alle 26 Runs.

BIO wurde auf seine eigenen Regeln geprüft. Vorhandene Normalisierung und
anders modellierte Reinigungsschnitte wurden berücksichtigt; UBB-Befunde
wurden nicht pauschal übertragen. Die drei Nullwert-Laufzeitfehler bleiben
mit ihren ursprünglichen Fehlermeldungen erhalten.

Die Sammlung kopiert bereits verfasste Erwartungen und Quellenbelege,
bewahrt überlappende Bewertungen und macht beobachtete Werte nicht zu
Sollantworten. Ein ausdrücklich angeforderter Sammlungsabschluss bestätigt
Abdeckung; daraus folgt keine Expertenfreigabe oder App-Promotion.

Reproduktionsbefehl, Ergebnis- und Dateihashes, einzelne Quellenkontrollen und
verbleibende Grenzen stehen in [quality.json](quality.json). Historische
Artefakte, Quellen, Canonical-Profil, Binary-Pin und produktive App blieben
unverändert.

Einheiten-Erratum vom 16.10.2026 (eigene Protokollbeschriftung): land.parcels[].oepul_area_payment_eur_per_ha: EUR/ha; land.parcels[].operations.pheromone_traps.traps_per_ha: traps/ha. Eingaben, Queries, Quellenbelege, Sollwerte und sämtliche nativen Ausgaben/Status/Checks bleiben exakt gleich. Alle Fälle wurden vollständig neu ausgeführt und exakt wiederholt. Alte und neue Hashbindungen stehen im [gemeinsamen Erratum](../../unit-label-erratum-20261016.json). Die Ergänzung ist Roots eigene Gegenkontrolle; sie behauptet keine neue Experten- oder unabhängige Personenabnahme.
