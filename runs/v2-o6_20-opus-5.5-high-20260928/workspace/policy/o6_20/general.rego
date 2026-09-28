# Allgemeine Bedingungen mit Relevanz für "Tierwohl – Weide" (Konditionalität, Kontrollen,
# Verpflichtungsdauer, Kombination; Allgemeine Teilnahmebedingungen 5.1, 5.8, 6.1, 8; SRL 1.7, 1.9.4, 1.11, 1.12).
package oepul.o6_20.general

import data.oepul.o6_20.common

participation := object.get(input, ["farm", "oepul_participation"], {})

tw := common.tw

# Konditionalität: Verstöße führen zu Kürzungen nach Art. 83–89 VO (EU) 2021/2116.
violations contains v if {
	object.get(participation, "conditionality_compliant", true) == false
	v := {
		"rule_id": "o6_20.gen.conditionality",
		"severity": "sanction_risk",
		"message": "Konditionalität bzw. soziale Konditionalität nicht eingehalten – Förderung nicht in voller Höhe",
	}
}

# Verweigerung/Verhinderung einer Vor-Ort-Kontrolle ohne höhere Gewalt: Ablehnung, Vertragsbeendigung.
violations contains v if {
	object.get(tw, ["control", "on_site_control_refused"], false) == true
	object.get(tw, "force_majeure_recognized", false) == false
	v := {
		"rule_id": "o6_20.gen.control_refusal",
		"severity": "contract_invalid",
		"message": "Vor-Ort-Kontrolle verweigert oder verhindert – Antrag abzulehnen, Verträge beendet und rückabgewickelt",
	}
}

# Förderverpflichtungen gelten während der gesamten Verpflichtungsdauer (Kalenderjahr); Tiere sind
# nur förderfähig, wenn sie gemäß den relevanten Bestimmungen gehalten werden.
violations contains v if {
	object.get(tw, "obligations_kept_whole_year", true) == false
	v := {
		"rule_id": "o6_20.gen.commitment_whole_year",
		"severity": "no_premium",
		"message": "Förderverpflichtungen nicht während der gesamten Verpflichtungsdauer (1.1.–31.12.) erfüllt",
	}
}

# Leistungsüberschneidung: dieselbe Leistung darf nicht aus anderem öffentlichen Titel gefördert sein.
violations contains v if {
	object.get(tw, "same_service_funded_elsewhere", false) == true
	v := {
		"rule_id": "o6_20.gen.double_funding",
		"severity": "no_premium",
		"message": "Leistung wird bereits aus einem anderen Titel der öffentlichen Hand gefördert bzw. ist gesetzlich vorgeschrieben",
	}
}

# Unmögliche Maßnahmenkombinationen können bis zur Auszahlungsmitteilung korrigiert werden.
review_items contains r if {
	some m in object.get(tw, "excluded_combinations_applied", [])
	r := {
		"rule_id": "o6_20.gen.combination",
		"message": sprintf("Nicht kombinierbare Maßnahme %v beantragt – Korrektur bis zum Erhalt der Auszahlungsmitteilung zulässig", [m]),
	}
}
