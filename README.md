# Processing ECI data releases

## Purpose

The code in this repository creates some raw analysis, input to further editorializing and interpretation of the ECI releases at ILR.

All the standard charts are being automatically generated, and are available within the repository for download. Processing happens via Github Actions, in the [Compute Analysis workflow](https://github.com/labordynamicsinstitute/eci-processing/actions/workflows/compute.yml). If properly authorized, simply choosing the workflow action and hitting "Go" will generate a new data pull and analysis.

## Structure

- "[main](https://github.com/labordynamicsinstitute/eci-processing)" tree is where the live code is. Any edits go here.
- "[results](https://github.com/labordynamicsinstitute/eci-processing/tree/results)" tree is where the output from the code goes. Never edit anything here, it will get overwritten. Each run is a "commit", visible here: [https://github.com/labordynamicsinstitute/eci-processing/commits/results](https://github.com/labordynamicsinstitute/eci-processing/tree/results) (they all appear as if I ran it). Example: [this log file](https://github.com/labordynamicsinstitute/eci-processing/commit/799fc6f1b9bb5c840efc9612878d85933c7edc80) is the run from March 18, 2023.

## Running Things

To run things, go to "[Actions](https://github.com/labordynamicsinstitute/eci-processing/actions/)", choose "[Compute Analysis](https://github.com/labordynamicsinstitute/eci-processing/actions/workflows/compute.yml)", choose "Run workflow", then "run workflow' again (don't ask). 

To modify things, you can try it out locally (techno: `git clone` the main branch, change stuff, `git commit` back), but be sure to try out if the automated workflow still works.

## Notes for enhancing

It is fairly straightforward to create an Excel "shell" which generates the graphs, and simply fill in the numbers each time we run the code. Just need to remove the "replace" in a bunch of "export excel" commands.


## Outputs

- bunch of Excel spreadsheets in the "[Outputs](https://github.com/labordynamicsinstitute/eci-processing/tree/results/Analysis/Output)" folder.
- some pre-configured graphs in the same folder. Example:

![Example graph](https://raw.githubusercontent.com/labordynamicsinstitute/eci-processing/results/Analysis/Output/eci_tb_allworkers.png)
