# Unabhängige Gegenprüfung: roher Bergmähder-Run

Die Gegenprüfung des unveränderten Runs `v2-o6_4-opus-5.5-high-20261009` ist abgeschlossen. Innerhalb des unten begrenzten Umfangs bleibt kein materieller Fehler des Prüfdossiers offen. Der Kandidat bleibt für die native App-Aufnahme blockiert; dies erteilt keine Expertenfreigabe und repariert keine historischen Regeln.

Alle vier Seiten des neuen Maßnahmenblatts, sämtliche sechs Produktionsmodule und die Rohannahmen wurden unabhängig gelesen. Einschlägige GSP-Klauseln zu Definition, höherer Gewalt, amtlicher Fläche, Sanktionen und GLÖZ2 sowie die Kürzungsreihenfolge, Modulation und Kombinationszeile wurden erneut mit den Verbrauchern verglichen. Die neun Quellen enthalten tatsächlich die identische GSP-AV. Frühere vollständige gemeinsame Quellenlektüren werden über ihre Hashes wiederverwendet. Eine zweite vollständige fachliche Abnahme aller gemeinsamen Seiten, Regeln und Tabellenzeilen wird hier nicht behauptet.

Der vollständige eigene `--verify`-Lauf endete mit Exitcode 0 und reproduzierte die gespeicherten Beobachtungen bytegenau: **185 Fälle, 222 Erwartungen, 182 erfüllt und 40 nicht erfüllt; 178 definierte Ausgaben und 7 Laufzeitfehler, keine undefinierte Ausgabe**. Das bestätigt die Reproduktion auch der Abweichungen. Die gezielte Mischung aus Quellenfällen, positiven Nachweisen, Robustheit und Schema-Stress ergibt keine Modellgenauigkeitsquote.

Unabhängig abgeglichen wurden exakt 90 historische Katalog-IDs mit 97 erhaltenen Bewertungen, 13 Proposal-Pfade als Multimenge sowie 31 Tabellenpointer in einer Datendatei. Alle 216 gespeicherten Zeilen/Schlüssel stimmen einschließlich verschachtelter Werte überein. Alle 40 gebundenen Originaldateien stimmen in Hash und Größe. Die 30 überlappenden Teilbefunde sind keine 30 unabhängigen Fehlerursachen. 684 annotierte Codebereich-/Zeilenstellen und 435 zitierte Zeilenvorkommen sind gültig; Wiederholungen werden mitgezählt.

**1.350 gebundene Zitatvorkommen auf 487 eindeutigen Quellen-/Seiten-/Zitatkombinationen** wurden ohne Fehlzitat oder typografischen Fallback gefunden. Sieben Summary-Wiederholungen sind exakt durch ihre bereits belegten eigenen Quellkinder gedeckt. Ein Texttreffer bestätigt die Fundstelle, nicht automatisch Auslegung oder vollständige Falltatsachen. Die historische Fehlannotation „Anlage 3“ bei zwei GLÖZ2-Zitaten wird in `general.md` ausdrücklich eingeordnet; die aktuelle Anlage 2, PDF 90 und § 242(10) sind korrekt belegt.

Alle 45 Regelobjekt-Matcher zielen auf echte Verstoßobjekte mit `rule_id`, auch bei leeren Gegenkontrollen. String-ID-, Missing- und Kombinationslisten verwenden strukturelle Erwartungen. Die expliziten Booleanprojektionen erhalten echte Laufzeitfehler und verwechseln keine Prädikatsabwesenheit mit einem rechtlich vorgeschriebenen OPA-Status. `invalid_rule_collection` kommt nicht vor. Die 50 eingebetteten Eingabebeobachtungen und 28 eingebetteten Maßnahmenresultate stimmen in Status beziehungsweise typbewussten Werten mit dem Schlusslauf überein.

Die fachlichen Grenzen bleiben ausdrücklich erhalten:

- Jahresfilter, positive Vollflächen-/Abtransportprüfung, Missinglisten, selektive Teilnahme, VF und die implementierte Kürzungsfolge werden als vorhandene Verbesserungen gewürdigt.
- Die Weideabweichung hat ein bekanntes Enddatum und tatsächliche Jahresüberschneidung. Fehlende Mähdaten allein beweisen keine unterlassene Mahd.
- Amtliche Flächenbasis und Übererklärungsfolge werden nur in eindeutig zugeordneten Ein-Schlag-Fällen geprüft. LSE-Fälle setzen sonstige Berechtigung und ein vollständig bekanntes Feldstück voraus; keine Cap-Verteilung auf Maßnahme 4 wird erfunden.
- Heim-/Almstandort, die 2028-Feiertagsfrage und BM0 nach tatsächlich ausgeführter unzulässiger Mahd bleiben offene Vertrags-/Auslegungsfragen. HM-Fristkontrollen setzen die übrigen notwendigen Anerkennungs-/Kausalitätsfakten ausdrücklich voraus.
- Drei zulässige numerische Nullwerte erzeugen Fehler: einer in der Hauptentscheidung, zwei im gesonderten Übererklärungshelfer. Vier weitere Datum-null-Fehler liegen außerhalb des vorgeschlagenen Schemas. Fehlende Nachweise sind keine bewiesenen tatsächlichen Verstöße.
- Prämienkomponenten und behördliche Endauszahlung bleiben getrennt. Die separat untersuchten numerischen Eigenheiten der eingefrorenen OPA-Binary werden weder pauschal Modellfehlern noch allen 26 Runs zugerechnet.

Der zusätzliche App-Projektionslauf ist als primärer Integrationsnachweis getrennt dokumentiert und wurde in dieser QC nicht erneut ausgeführt oder als 186. Quellenfall gezählt. Private/öffentliche Studienreferenzen, GM-/Expertenlabels, Modellselbsttests und Sollwerte manueller Adaptationen wurden nicht als Orakel gelesen. Es gab keine Original-, Profil-, Policy-, Laufzeit- oder App-Änderung und keinen Commit.

[quality.json](quality.json) bindet die 14 final geprüften Artefakte, alle Quellenhashes und den eigenen Reproduktionsbefehl. Der veränderliche Abschlussstatus von `audit.json` ist aus diesen Artefakthashes bewusst ausgenommen.
