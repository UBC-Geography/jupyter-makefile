.PHONY: create_env remove_env create_kernel remove_kernel jupyter

#################################################################################
# GLOBALS                                                                       #
#################################################################################

## Change this variable
PROJECT_NAME=My Project Name

## Update these variables if needed
LANG=Python
CONDA_FILE=./environment.yml
PYTHON_FILE=./requirements.txt
R_FILE=./install.R

## Avoid changing these variables
PROJECT_SLUG=$(notdir $(shell pwd))
PROJECT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
ENV=$(PROJECT_DIR)/env

#################################################################################
# COMMANDS                                                                      #
#################################################################################

## Create the project's conda environment and install packages from files
create_env:
ifeq (,$(shell mamba info --envs | grep $(ENV)))
	mamba create -p $(ENV)
ifneq (,$(wildcard $(CONDA_FILE)))
	mamba env update -p $(ENV) --file $(CONDA_FILE)
endif
ifneq (,$(wildcard $(PYTHON_FILE)))
	mamba run -p $(ENV) python -m pip install -r $(PYTHON_FILE)
endif
ifneq (,$(wildcard $(R_FILE)))
	mamba run -p $(ENV) Rscript -e "chooseCRANmirror(graphics=FALSE,ind=1);source('$(R_FILE)')"
endif
else
	@echo Environment already exists
endif

## Remove the project's conda environment
remove_env:
	mamba env remove -p $(ENV)
	mamba clean -afy

## Create a new Jupyter kernel with using the project environment
create_kernel: create_env
ifeq ($(LANG),R)
	mamba install -p $(ENV) r-irkernel -y
	mamba run -p $(ENV) Rscript -e "IRkernel::installspec(name='$(PROJECT_SLUG)',displayname='R ($(PROJECT_NAME))')"
else
	mamba install -p $(ENV) ipykernel -y
	mamba run -p $(ENV) python -m ipykernel install --user --name "$(PROJECT_SLUG)" --display-name "Python ($(PROJECT_NAME))"
endif

## Remove the kernel from Jupyter
remove_kernel: remove_env
	jupyter kernelspec remove $(PROJECT_SLUG) -f

## Run the kernel in a local Jupyter environment
jupyter: create_env
	mamba install -p $(ENV) jupyter -y
	$(MAKE) create_kernel
	mamba run -p $(ENV) --no-capture-output jupyter lab -y