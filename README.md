# Sets of `bu2s` Runs for Looking at Different Dynamical Behavior

## Purpose
Files present here are related to exploration of sets of data archived at [https://drive.google.com/open?id=1ipaL2u-CjWEsA5Yf6V7X51gqaW8646ow](https://drive.google.com/open?id=1ipaL2u-CjWEsA5Yf6V7X51gqaW8646ow)

Datasets are divided into three main sets:

1. "Abrupt": Populations evolve for some time period with little divergence or structure, and then an abrupt evolutionary transition occurs
2. "Gradual": Populations diverge steadily from one another from the very beginning of simulations
3. "Neutral": There is no selection; populations never diverge

## Explanation of files here

#### Comma-separated data files:
+ '`AbruptParameterCombinations.csv`', '`GradualParameterCombinations.csv`', and '`NeutralParameterCombinations.csv`':  These small .csv files give the specific parameter combinations that were used to filter through over 9000 runs of the `bu2s` model to choose the runs that comprise the datasets.
+ '`FullListOfAbruptRuns.csv`', '`FullListOfGradualRuns.csv`', and '`FullListOfNeutralRuns.csv`': These .csv files have the full list of all parameters for every individual run included in the datasets.
+ **A note about parameter names**:  What we refer to as _m_ (migration rate) and _s_ (mean selection coefficient of selected mutations) in written work are coded in the model, and in the parameter spreadsheets, as `SD_MOVE` and `MEAN_S`, respectively.

#### R Scripts:
+ '`CompareEffectiveMigRates.R`': Script used to make PDF figures (see below) that show the behavior of the different categories of runs.
+ '`CompareListsOfRuns.R`': Script that was used to create the filtering of all available runs to limit it to the sets now archived at the Google Drive link above.

#### Shell Scripts:
+ '`ReduceDirectorySizes.sh`': Shell script used to delete some data files in order to reduce overall size of archives (no need to run anymore; those files are already deleted in the archive linked above)
+ '`TransferRunsToHereFromHD2.sh`':  Shell script used to pull data from hard drives containing all the original data (only works for Sam when connected to the big hard drive of runs)
+ '`BU2SparameterParsing.sh`': Shell script that CAN be used to convert `parameters.m` files (which are MATLAB-readable scripts) into scripts that are readable by `R`.  Comments in the script explain it briefly.  

#### PDF visualizations:
+ '`ContrastingRunsEffectiveMigRates.pdf`': Contrasting three sets of runs by their effective migration rates over time.  Subset of the next PDF.
+ '`FourSetsOfRunsEffMigRates.pdf`': Contrasting four sets of runs; same three as in the last PDF, but with one additional dataset added.
