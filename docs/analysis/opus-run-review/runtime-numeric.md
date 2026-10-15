# Gemeinsamer Prüfbefund: numerische Vergleiche der gepinnten Binary

Bei der Prüfung von BIO/o6_1b wurde der Hinweis aus dessen ursprünglicher
`notes/assumptions.md`, Abschnitt 3, eigenständig nachgeprüft. Die exakt im
Repository gepinnte Linux-Binary OPA 1.18.2 mit SHA-256
`9903e5125ac281104f2c4b7371d10cc3b74a98933743fcbfc174f9bf0ab20de8`
liefert bei ausgewählten Zahlenvergleichen ein falsches Ergebnis:

| Ausdruck | Exakte Dezimalrechnung | Beobachtete Binary |
|---|---|---|
| `1 < 10.0` | true | false |
| `1 == 10.0` | false | true |
| `3 >= 30.0` | false | true |
| `1 < 10` | true | true |
| `1 == 1.0` | true | true |
| `1.5 < 10.0` | true | true |

Das ist ein Befund zu **dieser konkreten Binary**. Der Build meldet einen
Commit mit `-dirty`. Daraus wird keine pauschale Aussage über alle
OPA-Versionen, andere Plattformen oder ein anderes ausgeliefertes Image
abgeleitet. Die 26 veröffentlichten Kandidaten werden weiterhin an ihre
jeweiligen Original-Metadaten gebunden; eine gemeinsame Versionsnummer allein
beweist weder den gleichen Fehlerpfad noch ein falsches Ergebnis jeder Regel.

`runtime_numeric.py` führt 60 festgelegte Zahlenvergleiche aus. Die
unabhängigen Sollwerte entstehen mit Python `Decimal` direkt aus den
Dezimalliteralen, ohne Kandidatenpolicy oder Modell-Selbsttest. 17 Vergleiche
weichen ab. [runtime-numeric.json](runtime-numeric.json) enthält sämtliche
Kontroll- und Fehlerfälle, den Binärhash und die Versionsausgabe. Eine getrennte
Qualitätsprüfung hat die Beobachtungen reproduziert. Diese Zahlen sind weder
Modellfehlerzahlen noch eine Modellgenauigkeitsquote.

```bash
python docs/analysis/opus-run-review/runtime_numeric.py \
  --opa /path/to/pinned-opa-1.18.2 --verify
```

Der Eingabevertragsfehler `null < 18` ist hiervon zu unterscheiden: Rego
definiert eine Ordnung zwischen verschiedenen Werttypen. Eine unbekannte
Hangneigung wird erst durch einen fehlenden Zahlen-/Nachweisguard fälschlich
als fachlich kleiner als 18 behandelt.

Die historischen Ausgaben bleiben unverändert. In der gemeinsamen Sammlung
wird die Familie `SHARED_RUNTIME_NUMERIC` getrennt von `TYPE_NULL` und
regelbezogenen Rechenfehlern geführt. Vor einer späteren Reparatur sind
betroffene konkrete Vergleiche und die tatsächlich eingesetzte App-Laufzeit
zu binden. Hier werden weder Binary noch Pin, Eingaben oder Regeln umgestellt.
