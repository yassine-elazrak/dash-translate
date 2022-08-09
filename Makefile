

SHELL 			:= /bin/bash
CMD 			:= . venv/bin/activate && python3.8
VENV 			:=  test -d venv || python3.8 -m venv venv
ACTIVATE 		:= . venv/bin/activate
INSTALL  		:= . venv/bin/activate && pip install
PYTHON 			?= python3




# Setup environment
export FLASK_APP 	:= server
export FLASK_ENV 	:= development
export PYTHONPATH	:= .:..:$PYTHONPATH



all: 
	@echo "run server"
	$(shell export PYTHONPATH=.:..:$PYTHONPATH)
	@$(CMD) src/app.py
	@echo "down server"


translate:
	@echo "translate"
	$(shell export PYTHONPATH=.:..:$PYTHONPATH)
	@. venv/bin/activate && cd src && pybabel extract -F ../babel.cfg -k lazy_gettext -o messages.pot .
	@. venv/bin/activate && cd src && pybabel init -i messages.pot -d ../translations -l es
	@. venv/bin/activate && cd src && pybabel init -i messages.pot -d ../translations -l fr
	@echo "Our next task is to go to translations , open the *.po files and translate all the text in the respective language.\n"
	@echo "When you are done, run the following command:\n"
	@echo "make compile"

compile:
	@echo "compile"
	$(shell export PYTHONPATH=.:..:$PYTHONPATH)
	@. venv/bin/activate && cd src && pybabel compile -d ../translations 
	@echo "The translations are now compiled and ready to be used."


update:
	@echo "update"
	$(shell export PYTHONPATH=.:..:$PYTHONPATH)
	@. venv/bin/activate && cd src && pybabel update -i messages.pot -d ../translations
	@echo "The translations are now updated."
install:venv
	: # Activate venv and install smthing inside
	@echo "Installing..."
	@$(INSTALL) --upgrade pip
	@$(INSTALL) -r requirements.txt --no-cache-dir
	@echo "Done."

venv:
	#: # Create venv if it doesn't exist
	@echo "Creating venv..."
	@$(VENV)
	@echo "Done."


clean:
	@echo "Cleaning..."
	@rm -rf translations
	@rm -rf dist build *.egg-info
	@find . -name "*.pyc" -exec rm {} \;
	@find . | grep -E '(__pycache__|\.pyc|\.pyo$$)' | xargs rm -rf



fclean: clean
	@rm -rf venv


re:  clean venv install 

.PHONY:   all  install venv clean 