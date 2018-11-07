#! /bin/bash

# use the kaggle cli to download the dataset, extract it, and clean up after
# it is done.
#
# *NOTE*: the kaggle cli **must** be installed and set up properly. This
#   involves setting up authentication as well. See the github page for
#   directions on how to do this: https://github.com/Kaggle/kaggle-api

OLDDIR=$(pwd)
PROJROOTDIR="$( cd .. "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#PROJROOTDIR="$(cd .. && pwd)"

if command -v kaggle ; then
    mkdir -p $PROJROOTDIR/data
    echo "downloading dataset ... "
    kaggle datasets download -d ntnu-testimon/banksim1 -p $PROJROOTDIR/data/banksim1; 
    unzip $PROJROOTDIR/data/banksim1/banksim1.zip -d $PROJROOTDIR/data
    rm -rf $PROJROOTDIR/data/banksim1
    echo "Set up complete!"
else
    echo "kaggle unavailable. pip install kaggle command line tool" ;
    echo "see kaggle github page for installation and authentication details: https://github.com/Kaggle/kaggle-api"
fi

cd $OLDDIR