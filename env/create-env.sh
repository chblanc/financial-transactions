#!/bin/bash

# make sure that anaconda/miniconda is install before proceeding and update
# conda, if missing, install from: https://www.continuum.io/downloads
#
# NOTE: when prompted to append the Anaconda path to your systems PATH, it is
# strongly advised that you say *NO*, unless you intend to allow Anaconda to
# overwrite your system version of Python

# change dir to where this script lives
CURR_DIR=$(pwd)
SH_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SH_DIR

# create env
conda create -y --name fin-payments python=3.7

# activating the env:
#   in windows: activate chill
#   in os/linux: source activate chill
#
# deactivating the env:
#   in windows: deactivate
#   in os/linux: source deactivate

source activate fin-payments

# install python packages -----------------------------------------------------
conda install -y numpy
conda install -y pandas
conda install -y scikit-learn
conda install -y matplotlib

# install R -------------------------------------------------------------------

# R, RStudio, and useful packages
conda install -y -c rdonnelly rstudio=1.2.502
conda install -y -c r r-base r=3.5.1
conda install -y -c r r-essentials
conda install -y -c r r-devtools
conda install -y -c r r-e1071
conda install -y -c r r-matrix 
conda install -y -c r r-reticulate
conda install -y -c r r-png
conda install -y -c r r-igraph
conda install -y -c r r-units

# install non-r channel packages
Rscript install-r-pkgs.R

# add .Rprofile ---------------------------------------------------------------

# set environment variables to specify where the conda versions of `R` and
# `python` reside
PYPATH="$(which python)"
echo "Sys.setenv(RETICULATE_PYTHON = '$PYPATH')" > ../.Rprofile

# save yml --------------------------------------------------------------------

# note: the output here is OS specific (so will not work cross-platform)
conda env export --name fin-payments > env-export-fin-payments-osx.yml 

# return to original pwd
cd $CURR_DIR
