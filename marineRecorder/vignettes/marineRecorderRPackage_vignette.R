## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- echo=TRUE, results="hide", message=FALSE, eval= FALSE--------------
#  # install.packages("devtools")
#  library("devtools")
#  devtools::install_github("jncc/marine-recorder-tools", subdir = "marineRecorder")

## ---- echo=TRUE, results="hide", message=FALSE, eval= FALSE--------------
#  #find and paste snapshot filepath
#  filepath <- "SnapshotDatav51_Public_20180524.mdb"
#  
#  #write down the version - usually the same as the file name
#  version <- "SnapshotDatav51_Public_20180524"
#  
#  #run function MR_GIS_Sample
#  Sample <- MR_GIS_Sample(snapshot_filepath = filepath, snapshot_version = version)
#  #the following will be printed in the R Console
#  #[1] "The shapefile ' C2018-07-30_Sample_SnapshotDatav51_Public_20180524 ' 'has been saved to your working directory."
#  
#  #run function MR_GIS_Species
#  Species <- MR_GIS_Species(snapshot_filepath = filepath, snapshot_version = version)
#  #the following will be printed in the R Console
#  #[1] "The shapefile ' C2018-07-30_Species_SnapshotDatav51_Public_20180524 ' 'has been saved to your working directory."
#  
#  

## ---- echo=TRUE, results="hide", message=FALSE, eval= FALSE--------------
#  #find and paste new snapshot filepath
#  filepath_new_snapshot <- "SnapshotDatav51_Public_20180524.mdb"
#  
#  #find and paste old snapshot filepath
#  filepath_old_snapshot <- "SnapshotDatav51_Public_20180131.mdb"
#  
#  #run the function on the 'Survey' table where the primary key for the table is survey key
#  surveysAdded <- newSurveys(DSN1 = filepath_new_snapshot, tablename1 = "Survey", DSN2 = filepath_old_snapshot, tablename2 = "Survey", primaryKey = "Survey_Key" )
#  

## ----  echo=TRUE, results="hide", message=FALSE, eval= FALSE-------------
#  ## not run
#  #find and paste NBN filepath
#  filepathNBN<- ""
#  
#  #run the function
#  lastKeyChanges <- updateLastKeyNBN(filepathNBN)
#  
#  ## End (not run)

## ---- echo=TRUE, results="hide", message=FALSE, eval= FALSE--------------
#  data(marineKingdoms)
#  
#  #Run missingValidAphiaIDs function to check if any Valid Aphia ID records are missing from the dataset.
#  missingValidAphiaIDs(marineKingdoms)
#  #[1] 6
#  # Aphia ID 6 is a valid AphiaID for a record but is missing from the dataset. Use 'addValidAphiaIDs' function to enter this record.
#  
#  #run add valid IDs function
#  x <- addValidAphiaIDs(marineKingdoms)
#  #Added Aphia ID records: 6
#  #1 new records have been added.
#  
#  # Aphia ID 6 is a valid Aphia ID but is not in the dataset as an individual record.
#  
#  #Run to check if there any more missing valid AphiaID records
#  missingValidAphiaIDs(x)
#  #[1] "All valid aphiaIDs are also individual records"
#  

## ---- echo=TRUE, results="hide", message=FALSE, eval = FALSE-------------
#  
#  # Enter aphia ID - Animalia (2)
#  getParentID(2)
#  #[1] 1
#  
#  data(marineKingdoms)
#  #run add parents function
#  u <- addParentAphiaIDs(marineKingdoms)
#  
#  #check for missing parents as individual records
#  missingParentAphiaIDs(u)
#  # Error in missingParentAphiaIDs(u) :
#  #  Some Parent AphiaIDs are NA. Re- run 'updateParentAphiaIDs' function.
#  
#  #Run update parent IDs function
#  v <- updateParentAphiaIDs(u)
#  
#  #check for missing parents as individual records
#  missingParentAphiaIDs(v)
#  #[1] "All parent aphiaIDs are also individual records."

## ---- echo=TRUE, results="hide", message=FALSE, eval = FALSE-------------
#  # Enter a string
#  createShortcodes("Salmo salar")
#  #[1] "Salsal"

