#' Marine Recorder GIS sample extract
#'
#' This function creates a shapefile of the sample records found in a marine recorder snapshot. It saves the output to your working directory.
#' @param snapshot_filepath The file path to the the snapshot. Please enter this filepath in quotations.
#' @param snapshot_version The version of the MR snapshot you are using. Please enter these in quotations e.g. "MRv5_Public_20161205"
#' @details
#' For this function to work you will need to use a 32-bit version R.
#' This can be done by clicking on the 'Tools' tab -> 'Global Options' -> 'General' -> 'R Version' click 'Change' and select the 32-bit version of R.
#' The function will return a shapefile saved to your working directory.
#'
#' The saved shapefile will follow this format ("C", Sys.Date(), "_Sample_", snapshot_version) e.g. 'C2018-05-05_Sample_MRv5_Public_20161205.shp')
#' @keywords Marine Recorder, GIS, shapefile, sample
#' @export
#' @examples
#' @import RODBC
#' @import rgdal
#' @import sp
#' MR_GIS_Sample()

MR_GIS_Sample <- function(snapshot_filepath, snapshot_version) {
  #connect to the database
  gdb <- RODBC::odbcConnectAccess(snapshot_filepath)
  #Add error statement if the R version is not 32 -bit

  #finds all the tables in the database and save in a data frame
  tables <- RODBC::sqlTables(gdb)

  #writing the query
  qry <- RODBC::sqlQuery(
    gdb,
    "SELECT Survey.SurveyKey,
    Survey.SurveyName,
    SurveyEvent.SURVEY_EVENT_KEY AS SurvEvtKey,
    Sample.SAMPLE_REFERENCE AS SampleRef,
    Sample.Habitat, First(Sample.Description) AS HabDesc,
    Sample.Date,
    Sample.LongWGS84,
    Sample.LatWGS84,
    Survey.DataAccess,
    Survey.Copyright,
    Survey.MDBName
    FROM Survey
    INNER JOIN (SurveyEvent INNER JOIN Sample ON SurveyEvent.SURVEY_EVENT_KEY = Sample.SURVEY_EVENT_KEY)
    ON Survey.SurveyKey = SurveyEvent.SURVEY_KEY
    GROUP BY Survey.SurveyKey,
    Survey.SurveyName,
    SurveyEvent.SURVEY_EVENT_KEY,
    Sample.SAMPLE_REFERENCE,
    Sample.Habitat,
    Sample.Date,
    Sample.LongWGS84,
    Sample.LatWGS84,
    Survey.DataAccess,
    Survey.Copyright,
    Survey.MDBName
    HAVING (((Sample.LongWGS84)<10
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
  rgdal::writeOGR(spdf,
                  ".",
                  paste0("C", Sys.Date(), "_Sample_", snapshot_version),
                  driver = "ESRI Shapefile")

  RODBC::odbcCloseAll()
  #Return the shapefile to the global environment
  return(spdf)
}
