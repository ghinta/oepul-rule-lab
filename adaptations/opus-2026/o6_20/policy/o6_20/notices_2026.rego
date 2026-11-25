# Jahresspezifische AMA-Hinweise 2026 mit Bezug zu "Tierwohl – Weide".
package oepul.o6_20.notices_2026

import data.oepul.o6_20.common

tw := common.tw

# Trockenheit 2026: Bei Vor-Ort-Kontrollen wird die besondere Situation u. a. hinsichtlich des
# Grundfutterbedarfs auf der Weide berücksichtigt (Hinweis vom 22.05.2026).
drought_consideration_applies if {
	common.year == 2026
	object.get(tw, "drought_affected_2026", false) == true
}

review_items contains r if {
	drought_consideration_applies
	some c in common.categories
	object.get(c, "forage_mainly_from_grazing", true) == false
	r := {
		"rule_id": "o6_20.notice2026.drought_forage_consideration",
		"category_code": c.category_code,
		"message": "Grundfutterbedarf nicht überwiegend über Beweidung gedeckt: Trockenheit 2026 wird bei Vor-Ort-Kontrollen berücksichtigt (Einzelfallbeurteilung)",
	}
}

# Höhere Gewalt (§ 6 GSP-AV, SRL 1.7.4.1): anerkannter Antrag schließt Sanktionen wegen
# nicht einhaltbarer Förderverpflichtungen aus.
force_majeure_recognized if object.get(tw, "force_majeure_recognized", false) == true

review_items contains r if {
	object.get(tw, "force_majeure_claimed", false) == true
	not force_majeure_recognized
	r := {
		"rule_id": "o6_20.notice2026.force_majeure_application",
		"message": "Ansuchen auf Anerkennung höherer Gewalt über eama.at (Register „Eingaben“) einzubringen; Anerkennung durch AMA ausständig",
	}
}
