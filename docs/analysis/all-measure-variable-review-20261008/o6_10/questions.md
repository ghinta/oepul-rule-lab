# o6_10: offene Fachentscheidungen

Alle Antworten und App-Zuordnungen bleiben offen. Die Zitate sind Modellnotizen bzw. Prüfbeobachtungen, keine bestätigte Fachauslegung.

### o6_10-INPUT_CONTRACT

Welche der im Diff einzeln gelisteten Eingaben werden fachlich benötigt und aufgenommen? Für jede: verbindlicher Name, Betrieb/Schlag/Tier/Gruppe/Projekt, Einheit, Zeitbezug, Herkunft/Nachweis und Abgrenzung zu bestehenden App-Feldern. Luna- und Opus-Strukturen sind alternative Vorschläge; keine automatische Umbenennung.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_10-luna-high-20261003/workspace/rules/profile_changes.json:8–11`

```text
      "path": "o6_10",
      "value_after": {
        "requested": false,
        "compliance": false,
```

Ursprung: `runs/v2-o6_10-opus-5.5-high-20260925/workspace/rules/profile_changes.json:8–11`

```text
      "path": "farm.applicant",
      "value_before": null,
      "value_after": {
        "person_type": "enum(natural_person|registered_partnership|legal_person|association_of_persons|territorial_authority)",
```

### o6_10-GREENING

Wie wird erlaubte bestehende Begrünung von unzulässiger Selbstbegrünung unterschieden? Welche Behandlung gilt für Terrassen unter 25 %?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_10-opus-5.5-high-20260925/workspace/notes/assumptions.md:29–39`

```text
- **A-02 Selbstbegrünung vs. bestehende Begrünung.** Das Informationsblatt lässt
  „bereits bestehende Begrünung … ohne Neueinsaat belassen“ zu und erklärt
  gleichzeitig „Selbstbegrünungen sind nicht zulässig“. Die SRL spricht von
  „reine Selbstbegrünungen“. Modelliert wird das so: `establishment_method =
  existing_greening_retained` ist zulässig. Nur `cover_type = self_greening` (reine
  Selbstbegrünung ohne etablierte Begrünungskultur) ist ein Verstoß. Die Abgrenzung
  im Einzelfall bleibt offen.
- **A-03 Terrasse unter 25 % Hangneigung.** Wie eine als Terrasse deklarierte Fläche
  mit weniger als 25 % zu behandeln ist, sagt die Quelle nicht. Sie wird als normale
  Weinfläche geführt: Begrünungspflicht gilt, Prämie nach der Wein-Stufe unter 25 %.
  Sie wird nicht ausgeschlossen.
```

### o6_10-SURCHARGE_SCOPE

Zählt EOP nur auf Schlägen mit eigenem Einsatz oder auf allen EOP-Schlägen nach einem einzigen Einsatz? Wirkt BIO/12-Kürzung betrieblich oder schlagbezogen?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_10-opus-5.5-high-20260925/workspace/notes/assumptions.md:40–49`

```text
- **A-04 Kürzung des EOP-Zuschlags: betrieblich oder je Schlag.** Informationsblatt
  und SRL knüpfen an die „Teilnahme (des Betriebes)“ an Maßnahme 12 oder 1B an.
  Anhang L (Fußnote 3) zeigt dagegen einen Prämienabschlag auf der Einzelfläche.
  Umgesetzt ist die betriebliche Lesart über `farm.oepul.participating_measures`.
  Bei Bio-Teilbetrieben wäre auch eine schlagbezogene Kürzung denkbar (offen).
- **A-05 Mindestteilnahmefläche.** Zu den 0,50 ha zählen alle teilnahmefähigen
  Wein-, Obst-, Hopfen- und Terrassenschläge „gemäß Mehrfachantrag“, also auch
  Schläge mit Prämienausschluss (Code OP, Nationalpark, unveredeltes Obst). Nicht
  gezählt werden Flächen außerhalb Österreichs, GLÖZ-Elemente und nicht
  teilnahmefähige Kulturarten.
```

### o6_10-REESTABLISHMENT

Was startet die Acht-Wochen-Frist bei Rodung plus Neuauspflanzung? Wie werden noch nicht fällige Folgejahresereignisse behandelt?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_10-opus-5.5-high-20260925/workspace/notes/assumptions.md:50–66`

```text
- **A-06 Frist bei Rodung/Neuauspflanzung.** „8 Wochen nach … Rodung/Neuauspflanzung“
  ist mehrdeutig. Folgt auf eine Rodung eine Neuauspflanzung, beginnt die Frist mit
  der (spätesten) Neuauspflanzung. Sonst beginnt sie mit der Rodung bzw. dem
  Umbruch. In jedem Fall gilt die Obergrenze 1. Oktober desselben Jahres. Liegt ein
  Umbruch nach dem 1. Oktober (außer bei Rodung nach dem 15. September), ist die
  Neuanlage nicht mehr fristgerecht möglich. Das gilt als Verstoß.
- **A-07 Offene Frist nach später Rodung.** Nach einer Rodung nach dem 15. September
  läuft die Frist bis 15. Mai des Folgejahres. Fehlen Ereignisse aus dem Folgejahr,
  wird die Frist als offen ausgewiesen (`pending_reestablishments`), nicht als
  Verstoß. Grundsätzlich gelten die Ereignislisten als vollständige
  Jahresaufzeichnung. Eine fehlende Neuanlage innerhalb der Frist wird als Verstoß
  gewertet, auch wenn das Auswertungsdatum vor dem Fristende liegt.
- **A-08 Bemessungsfläche des Zuschlags.** Der Zuschlag wird in €/ha angegeben.
  Welche Fläche ihm zugrunde liegt, regelt die Quelle nicht ausdrücklich. Angenommen
  wird: Der Zuschlag wird für die Fläche aller mit `EOP` gekennzeichneten, prämienfähigen
  Schläge gewährt, sofern auf mindestens einem Schlag ein anrechenbarer Einsatz
  vorliegt.
```

### o6_10-ORDER_EXIT

Welche Auswirkung hat genehmigter Rebzikaden-Ausstieg auf EOP-Kürzung und Anrechenbarkeit von Organismen/Pheromonen?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_10-opus-5.5-high-20260925/workspace/notes/assumptions.md:85–93`

```text
- **A-12 Ausstieg aus 12 im Jahr 2026 (Rebzikade).** Nach einem genehmigten
  rückzahlungsfreien Ausstieg endet der Vertrag für Maßnahme 12 mit der Meldung,
  und 2026 wird keine Prämie für 12 gewährt. Angenommen wird: Der Betrieb nimmt
  2026 dann nicht mehr an 12 teil, die 50 %-Kürzung des EOP-Zuschlags entfällt
  also. Umsetzung: 12 wird nicht mehr in `participating_measures` geführt. Wird es
  trotz Ausstiegskennzeichen geführt, erscheint ein Hinweis. Offen ist, ob ein
  behördlich angeordneter Insektizideinsatz die Anrechenbarkeit von
  Organismen/Pheromonen („ersetzt einen PSM-Einsatz“) beeinflusst (Coverage
  `N0612-ORDER` = `unresolved`).
```
