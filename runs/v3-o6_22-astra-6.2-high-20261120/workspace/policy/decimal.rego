package oepul.o6_22

import rego.v1

# Dezimale Eingaben und Tabellenwerte auf ganze Einheiten gleicher Stellenzahl
# bringen. So bleibt z. B. eine exakt erreichte GVE- oder Flächengrenze erhalten.
second_or(parts, fallback) := parts[1] if count(parts) > 1

else := fallback

unsigned_integer(s) := 0 if trim_left(s, "0") == ""

else := to_number(trim_left(s, "0"))

signed_integer(s) := n if {
	startswith(s, "-")
	n := 0 - unsigned_integer(trim_prefix(s, "-"))
} else := unsigned_integer(s)

decimal_parts(n) := {"units": units, "power": power} if {
	is_number(n)
	exponential := split(lower(json.marshal(n)), "e")
	pieces := split(exponential[0], ".")
	fraction := second_or(pieces, "")
	digits := concat("", pieces)
	units := signed_integer(digits)
	power := to_number(second_or(exponential, "0")) - count(fraction)
}

power_of_ten(0) := 1

power_of_ten(p) := v if {
	p > 0
	v := to_number(concat("", ["1", sprintf("%0*d", [p, 0])]))
}

decimal_number(units, power) := n if {
	n := to_number(sprintf("%de%d", [units, power]))
}

decimal_sum(xs) := 0 if count(xs) == 0

else := total if {
	parts := [p | some x in xs; p := decimal_parts(x)]
	count(parts) == count(xs)
	power := min([p.power | some p in parts])
	units := [u | some p in parts; u := p.units * power_of_ten(p.power - power)]
	total := decimal_number(sum(units), power)
}

decimal_product(a, b) := result if {
	x := decimal_parts(a)
	y := decimal_parts(b)
	result := decimal_number(x.units * y.units, x.power + y.power)
}
