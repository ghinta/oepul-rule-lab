# Verifikation dieses Prüfberichts

- 136 Repositorytests und elf Validatortests lokal erfolgreich.
- Strenge Kompilierung des unveränderten Bundles mit OPA 1.18.2;
  Binärhash und sämtliche gebundenen Originalartefakte geprüft.
- Haupt-Replay bytegenau reproduziert: 43 Fälle, 55 Einzelerwartungen,
  42 definierte Ausgaben und ein dokumentierter Laufzeitfehler. 27 erfüllte
  und 28 unerfüllte Erwartungen sind diagnostische Befunde, keine Modellquote.
- 418 historische Zitate und 21 Hauptfall-Belege auf der jeweiligen
  Originalseite/im HTML gefunden; Wortlautkontrolle ersetzt keine Inhaltsprüfung.
- 166 eindeutige historische Regelkennungen, 53 Tabellen, 67 Profilvorschläge
  mit 191 effektiven Blättern und 26 Warteschlangeneinträge konsistent.
- Separate Qualitätsprüfung wiederholt zusätzlich alle 35 allgemeinen,
  42 Eingabe-, fünf Maßnahmen- und acht rechtlichen Teilproben. Diese
  überschneidenden Sätze werden nicht als unabhängige Fallzahl addiert.
- Historischer Kandidatencheckout und Quellen-/Profilhashes unverändert;
  keine produktive App-Policy, Migration oder Serverinstallation geändert.

Die ergänzte CI-Stufe wiederholt den Haupt-Replay am fest gebundenen
Kandidatencommit. Sie prüft die Reproduzierbarkeit einschließlich bekannter
Fehler. Einen erfolgreichen CI-Lauf als fachliche Freigabe zu lesen wäre falsch.
