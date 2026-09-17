package smoke.generated

test_allow_when_enabled if {
	allow with input as {"enabled": true}
}

test_deny_when_disabled if {
	not allow with input as {"enabled": false}
}
