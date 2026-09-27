# Annahmen und offene Punkte

- Die SRL und das Maßnahmenblatt verlangen teilweise Nachweise, Einträge im Mehrfachantrag und AGES-Registerdaten. Das Canonical Farm Profile enthält diese Verwaltungsdaten nicht; sie sind als `discover`-Ergänzungen vorgeschlagen und die Rego-Prüfung bewertet nur die ausdrücklich modellierten Tatsachen.
- Die 2026-Dürremeldung befreit bei ordnungsgemäßer Anlage von der tatsächlich erreichten Flächendeckung bzw. von der 50-%-Grenze durch Ausfallgetreide. Sie ändert weder die Pflicht zur ordnungsgemäßen Anlage noch andere Maßnahmeauflagen. Die konkrete Beurteilung der ordnungsgemäßen Anlage bleibt eine fachliche Tatsachenprüfung.
- Die SRL bezeichnet Terrassen als bewirtschaftbare Alternative zur Begrünung; das Informationsblatt präzisiert die Prämienfähigkeit als durchschnittliche Hangneigung von mindestens 25 %. Rego benötigt deshalb `is_terrace` und eine GIS-bestimmte Neigung als separate Eingaben.
