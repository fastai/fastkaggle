.ONESHELL:
SHELL := /bin/bash

exp:
	nbdev_clean
	nbdev_export

help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

sync: ## Propagates any change in the modules (.py files) to the notebooks that created them 
	nbdev_update

deploy: docs ## Push local docs to gh-pages branch
	nbdev_ghp_deploy

preview: ## Live preview quarto docs with hot reloading.
	nbdev_sidebar
	nbdev_export
	IN_TEST=1 &&  nbdev_quarto --preview

docs: .FORCE ## Build quarto docs and put them into folder specified in `doc_path` in settings.ini
	nbdev_export
	nbdev_quarto

prepare: ## Export notebooks to python modules, test code and clean notebooks.
	nbdev_export
	nbdev_test
	nbdev_clean
	
test: ## Test notebooks
	nbdev_test

release_all: pypi release_conda ## Release python package on pypi and conda.  Also bumps version number automatically.
	nbdev_bump_version
	nbdev_export

release_pypi: pypi ## Release python package on pypi.  Also bumps version number automatically.
	nbdev_export
	nbdev_bump_version

release_conda:
	fastrelease_conda_package

pypi: dist
	twine upload --repository pypi dist/*

dist: clean
	python setup.py sdist bdist_wheel

clean:
	rm -rf dist
	

install: install_quarto ## Install quarto and the latest version of the local python pckage as an editable install
	pip install -e ".[dev]"

install_py: .FORCE
	nbdev_export
	pip install -e ".[dev]"

install_quarto: .FORCE ## Install the latest version of quarto for Mac and Linux.  Go to https://quarto.org/docs/get-started/ for Windows.
	./install_quarto.sh

.FORCE:

