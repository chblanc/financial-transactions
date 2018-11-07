# set-up
you will need to run a few bash scripts to get up and running 

  1. `bash create-env`: creates a conda environment w/both `python` and `R`
  2. `bash get-data` downloads the kaggle dataset. *Note*: the kaggle cli and
      proper authentication is required for this script to run. See
      [here](https://github.com/Kaggle/kaggle-api) for details on installing
      the cli and getting authenticated (it will be necessary to have a
      kaggle account)
  3. activate the conda environment `source activate fin-payments`
  4. use the `conda` installed version of rstudio via `rstudio` 
     
# financial payments dataset
the wonderful folks over at kaggle have opened up a synthetic financial
transaction dataset to the masses. this dataset contains over 500K customer
transactions and includes information like the transaction amount, the
transaction category, transaction merchant, and even the customer age! In
addition, there is an binary indicator for fraudulent charges!  

this repo will serve as a demo for projects/analyses that can be done with
data science tools. specifically, we'll focus on anomaly detection, network
analysis, and predictive modeling. 