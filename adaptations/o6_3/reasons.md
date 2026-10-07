# Warum diese Adaptation

[Issue #97](https://github.com/ghinta/oepul-rule-lab/issues/97) dokumentiert
belegte Grenzen des Luna-Kandidaten. Eine eigene Adaptation behebt sie,
während die ursprünglichen Modell-Runs als Vergleichsgrundlage erhalten bleiben.

Aktueller Tierbesatz bestimmt den aktuellen Prämiensatz; datierte
Erstjahresnachweise bestimmen den historischen Zugang. Alle 20 RGVE-Kategorien
werden verwendet, inklusive kleiner Equiden und Neuweltkamele. Bei Rindern
ist der Durchschnittsbestand erforderlich; bei anderen Kategorien hat eine
eingereichte Durchschnittstierliste Vorrang vor dem Stichtagsbestand.

Jahr, Snapshot und Stichtag müssen zusammenpassen. Falsche Jahresbasis und
fehlende Tatsachen ergeben `missing_data`. Nur bestätigte vollständige leere
Mengen gelten als null. Typprüfung verhindert String-/Boolean-Verwechslungen.

Prämienflächen werden aus Flächenart und tatsächlichen Mahddaten abgeleitet.
Eine rechnerische Indikation wird bei offenen oder verletzten Prüfbedingungen
unterdrückt. Normative RGVE-Faktoren und Sätze kommen aus gebundenen Tabellen.

Keine automatische Dürrebefreiung für Ackerfutter und keine pauschale
Unterdrückung durch höhere Gewalt. Anerkennungen werden nach Pflicht, Jahr,
Zeitraum und Fläche eingegrenzt; ihre Rechtsfolge bleibt fachlich zu prüfen.
„Überwiegend“ ist eine explizite fachliche Angabe, keine erfundene 92-Tage-Regel.

Quellenfälle, vollständige Kategorienprüfung, Schema-/Provenienzchecks und
OPA-Gates laufen lokal und in CI. Diese sichtbaren Entwicklungsfälle sind kein
Golden-/Held-out-Benchmark. P1/P2 und die tatsächliche App-Promotion folgen;
dieser begrenzte Kandidat verspricht keine vollständige Förderfähigkeitsprüfung.
