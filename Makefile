.PHONY: test source-validate opa-unit opa-smoke

test: opa-unit
	PYTHONDONTWRITEBYTECODE=1 PYTHONPATH=src python3 -m unittest discover -s tests -v

opa-unit:
	PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s runner/validation/tests -v

opa-smoke:
	python3 runner/validation/opa_validate.py validate --workspace runner/validation/fixtures/valid --pretty

source-validate:
	python3 sources/oepul/manage_sources.py validate
