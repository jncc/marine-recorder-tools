#' Marine Recorder GIS species extract
#'
#' This function creates a shapefile of the species records found in a marine recorder snapshot. It saves the output to your working directory.
#' @param snapshot_filepath The file path to the the snapshot. Please enter this filepath in quotations.
#' @param snapshot_version The version of the MR snapshot you are using. Please enter these in quotations e.g. "MRv5_Public_20161205"
#' @details
#' For this function to work you will need to use a 32-bit version R.
#' This can be done by clicking on the 'Tools' tab -> 'Global Options' -> 'General' -> 'R Version' click 'Change' and select the 32-bit version of R.
#' The function will return a shapefile saved to your working directory.
#' The saved shapefile will follow this format ("C", Sys.Date(), "_Species_", snapshot_version) e.g. 'C2018-05-05_Species_MRv5_Public_20161205.shp')
#'
#' @keywords Marine Recorder, GIS, shapefile, species
#' @export
#' @examples
#' MR_GIS_Species()
#' @import RODBC
#' @import rgdal
#' @import sp

MR_GIS_Species <- function(snapshot_filepath, snapshot_version) {
  #check if running 32-bit version of R
  if (Sys.getenv("R_ARCH") != "/i386"){
  stop("Must be running 32 bit version of R!")
}

  #connect to the database
  gdb <- RODBC::odbcConnectAccess(snapshot_filepath)
  #add an error statement if the R version is not 32 -bit

  #finds all the tables in the database and save in a data frame
  tables <- RODBC::sqlTables(gdb)

  qry <- RODBC::sqlQuery(
    gdb,
    "SELECT
    Survey.SurveyKey,
    Survey.SurveyName,
    SurveyEvent.SURVEY_EVENT_KEY AS SurvEvtKey,
    Sample.SAMPLE_REFERENCE AS SampleRef,
    SampleSpecies.TaxonOccurrenceKey AS TaxoOccKey,
    SampleSpecies.SpeciesName AS Species,
    SampleSpecies.Uncertain,
    SampleSpecies.DeterminedBy AS Determiner,
    SampleReplicate.Method,
    SampleReplicate.RepId,
    Sample.LongWGS84,
    Sample.LatWGS84,
    Survey.DataAccess,
    Survey.Copyright,
    Survey.MDBName
    FROM (Survey
    INNER JOIN (SurveyEvent
    INNER JOIN Sample
    ON SurveyEvent.SURVEY_EVENT_KEY = Sample.SURVEY_EVENT_KEY)
    ON Survey.SurveyKey = SurveyEvent.SURVEY_KEY)
    INNER JOIN (SampleReplicate
    INNER JOIN SampleSpecies
    ON SampleReplicate.SAMPLE_Key = SampleSpecies.SAMPLE_Key)
    ON Sample.SAMPLE_REFERENCE = SampleReplicate.SAMPLE_REFERENCE
    WHERE (((Sample.LongWGS84)<10
    And (Sample.LongWGS84)>-15)
    AND ((Sample.LatWGS84)<65
    And (Sample.LatWGS84)>45));",
    rows_at_time = 1
  )


  #write the edited database a shapefile

  xy <- qry[, c("LongWGS84", "LatWGS84")] #the long, lat fields
  spdf <-
    sp::SpatialPointsDataFrame(
      coords = xy,
      data = qry,
      proj4string = sp::CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")
    )


  #write shape file - this is saved to your working directory
  filename <- paste0("C", Sys.Date(), "_Sample_", snapshot_version)
  rgdal::writeOGR(spdf,
                  ".",
                  filename,
                  driver = "ESRI Shapefile")

  RODBC::odbcCloseAll()
  #return the shapefile to the global environment
  print(paste("The shapefile", "'",filename, "'", "'has been saved to your working directory."))
  return(spdf)

}
