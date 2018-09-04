
`marineRecorder` Package <img src="man/figures/logo.png" align="right" width="150" />
=====================================================================================

A Marine Recorder R Package was developed to work with the marine recorder snapshot. The functions included in this package create shapefiles, find the newly added surveys and check species to update the species dictionary (a separate database used with the main application).

Installation of `marineRecorder` Package
----------------------------------------

``` r
# install.packages("devtools")
library("devtools")
devtools::install_github("jncc/marine-recorder-tools", subdir = "marineRecorder", build_vignettes = TRUE, force = TRUE)
```

List of functions currently available:
--------------------------------------

-   **MR\_GIS\_Sample()** - creates a shapefile of samples from the snapshot
-   **MR\_GIS\_Species()** - creates a shapefile of species from the snapshot
-   **newSurveys()** - find new surveys added to the new snapshot
-   **addParentAphiaIDs()** - adds parent aphia IDs as records to the data frame
-   **addValidAphiaIDs()** - adds valid aphia IDs, if valid aphia IDs are missing from the data frame
-   **createShortcodes()** - creates short codes, first three letters of the first and second word from a given string
-   **getParentID()** - finds out the aphia ID of parent
-   **missingParentAphiaIDs()** - identifies the missing parent aphia IDs from the data frame
-   **missingValidAphiaIDs()** - identifies the missing valid aphia IDs from the data frame
-   **updateParentAphiaIDs()** - updates parent aphia ID records

Examples
--------

### 1. MR\_GIS\_Sample(), MR\_GIS\_Species() and newSurveys()

To use these function you will need to use the **32-bit version** of R, for RODBC to connect to the Access database. To change the version of R you are using in RStudio:

1.  Click the '**Tools**' tab at the top of your RStudio window
2.  Click on '**Global Options**'
3.  Click on '**General**' tab in the left hand sidebar
4.  Click '**Change**' under the '**R version:**' section
5.  Click on '**Use your machine's default version of R (32-bit)**' and Click '**OK**'
6.  A dialog box '**Change R Version**' will open stating '**You need to quit and re-open RStudio for this change to take effect.**'
7.  Click '**OK**'
8.  Click '**Apply**' followed by '**OK**'
9.  Close and re-open RStudio
10. Call the `marineRecorder` package to the global environment using `library(marineRecorder)`

Also, to use this function you will need to download the Marine Recorder Snapshot available to download from the [JNCC Marine Recorder webpage](http://jncc.defra.gov.uk/page-1599). Once downloaded extract the Snapshot Access Database and copy into your working directory.

#### Generate shapefiles

**N.B.** These functions still use the 'sp' package and so the functions may take a while to run.

``` r
#find and paste snapshot filepath 
filepath <- "SnapshotDatav51_Public_20180524.mdb"

#write down the version - usually the same as the file name
version <- "SnapshotDatav51_Public_20180524"

#run function MR_GIS_Sample
Sample <- MR_GIS_Sample(snapshot_filepath = filepath, snapshot_version = version)
#the following will be printed in the R Console 
#[1] "The shapefile ' C2018-07-30_Sample_SnapshotDatav51_Public_20180524 ' 'has been saved to your working directory."

#run function MR_GIS_Species
Species <- MR_GIS_Species(snapshot_filepath = filepath, snapshot_version = version)
#the following will be printed in the R Console 
#[1] "The shapefile ' C2018-07-30_Species_SnapshotDatav51_Public_20180524 ' 'has been saved to your working directory."
```

#### Find new surveys

The following function will also need a **32-bit version** of R.

You will need two versions of a snapshot to compare. This function will work on any table found within the snapshot or access database e.g. 'Sample' table.

``` r
#find and paste new snapshot filepath 
filepath_new_snapshot <- "SnapshotDatav51_Public_20180524.mdb"

#find and paste old snapshot filepath 
filepath_old_snapshot <- "SnapshotDatav51_Public_20180131.mdb"

#run the function on the 'Survey' table where the primary key for the table is survey key
surveysAdded <- newSurveys(DSN1 = filepath_new_snapshot, tablename1 = "Survey", DSN2 = filepath_old_snapshot, tablename2 = "Survey", primaryKey = "Survey_Key" )
```

### 2. Updating the Last Key table in Marine Recorder NBN

This function was developed as a work around solution to a 'Run-Time Error 3022'.

**Only** use this function if you encounter "Run-Time Error '3022': The Changes you Requested to the Table were not Successful", when attempting to enter data into Marine Recorder.

Please ensure that you are working on a **copy** of the NBN data file and not the original.

The function will automatically update the NBN and return a list of the changes that have been made to the NBN.

``` r
## not run
#find and paste NBN filepath
filepathNBN<- ""

#run the function
lastKeyChanges <- updateLastKeyNBN(filepathNBN)

## End (not run)
```

### 3. Adding and finding missing valid aphia IDs

These two functions find whether there are any missing valid aphia IDs missing from the data frame and adds them in. These examples can also be found in the function help page.

``` r
data(marineKingdoms)

#Run missingValidAphiaIDs function to check if any Valid Aphia ID records are missing from the dataset.
missingValidAphiaIDs(marineKingdoms)
#[1] 6
# Aphia ID 6 is a valid AphiaID for a record but is missing from the dataset. Use 'addValidAphiaIDs' function to enter this record.

#run add valid IDs function
x <- addValidAphiaIDs(marineKingdoms)
#Added Aphia ID records: 6
#1 new records have been added.

# Aphia ID 6 is a valid Aphia ID but is not in the dataset as an individual record.

#Run to check if there any more missing valid AphiaID records
missingValidAphiaIDs(x)
#[1] "All valid aphiaIDs are also individual records"
```

### 4. Adding, updating and finding missing parent aphia IDs

These functions find out what the parent aphia ID of given aphia ID is (getParentID), finds out if any parent aphia IDs are missing from the data frame (missingParentAphiaIDs), adds in parent aphia ID records (addParentAphiaIDs) and update the parent aphia IDs (updateParentAphiaIDs).

All these examples can be found on the help page of the given function.

``` r

# Enter aphia ID - Animalia (2)
getParentID(2)
#[1] 1

data(marineKingdoms)
#run add parents function
u <- addParentAphiaIDs(marineKingdoms)

#check for missing parents as individual records
missingParentAphiaIDs(u)
# Error in missingParentAphiaIDs(u) :
#  Some Parent AphiaIDs are NA. Re- run 'updateParentAphiaIDs' function.

#Run update parent IDs function
v <- updateParentAphiaIDs(u)

#check for missing parents as individual records
missingParentAphiaIDs(v)
#[1] "All parent aphiaIDs are also individual records."
```

### 5. Create Shortcodes

This function creates an abbreviation of a given string.

``` r
# Enter a string
createShortcodes("Salmo salar")
#[1] "Salsal"
```

Dependencies
------------

-   [RCurl](https://cran.r-project.org/web/packages/RCurl/index.html)
-   [RODBC](https://cran.r-project.org/web/packages/RODBC/index.html)
-   [daff](https://cran.r-project.org/web/packages/daff/index.html)
-   [dplyr](https://cran.r-project.org/web/packages/dplyr/index.html)
-   [rgdal](https://cran.r-project.org/web/packages/rgdal/index.html)
-   [sp](https://cran.r-project.org/web/packages/sp/index.html)
-   [sqldf](https://cran.r-project.org/web/packages/sqldf/index.html)
-   [stringr](https://cran.r-project.org/web/packages/stringr/index.html)
-   [worms](https://cran.r-project.org/web/packages/worms/index.html)
