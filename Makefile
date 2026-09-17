.PHONY: test source-validate opa-unit opa-smoke

PYTHON ?= python3

test: opa-unit
	PYTHONDONTWRITEBYTECODE=1 PYTHONPATH=src $(PYTHON) -m unittest discover -s tests -v

opa-unit:
	PYTHONDONTWRITEBYTECODE=1 $(PYTHON) -m unittest discover -s runner/validation/tests -v

opa-smoke:
	$(PYTHON) runner/validation/opa_validate.py validate --workspace runner/validation/fixtures/valid --pretty

source-validate:
	$(PYTHON) sources/oepul/manage_sources.py validate
