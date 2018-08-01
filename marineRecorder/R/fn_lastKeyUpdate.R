#' update the Last Key table
#'
#' This function will update the Last Key table in the NBN data file.
#' @param NBNfilepath  filepath of Marine Recorder NBN
#' @details Only use this function if you encounter "Run-Time Error '3022': The Changes you Requested to the Table were not Successful", when attempting to enter data into Marine Recorder.
#'
#' When entering data into Marine Recorder make sure that you have the debug = 1 (this can be found in the .ini file where the Marine Recorder Application was installed).
#'
#' Please ensure that you are working on a copy of the NBN data file and not the original.
#'
#' The function will automatically update the NBN and return a list of the changes that have been made to the NBN.
#' @keywords NBN, RODBC, last key
#' @export
#' @examples
#'
#' ## not run
#' #find and paste NBN filepath
#' filepathNBN<- ""
#'
#' #run the function
#' lastKeyChanges <- updateLastKeyNBN(filepathNBN)
#'
#'## End (not run)
#' @import RODBC
#' @import dplyr

updateLastKeyNBN <- function(NBNfilepath){

  require(RODBC, quietly = TRUE)
  #check if running 32 bit version of R
  if (Sys.getenv("R_ARCH") != "/i386"){
    stop("Must be running 32 bit version of R!")
  }
  #connect to the database
  gdb <- RODBC::odbcConnectAccess(NBNfilepath)
   #finds all the tables in the database and save in a data frame
  query <- "SELECT *
  FROM LAST_KEY
  WHERE ((LAST_KEY.TABLE_NAME) In ('BIOTOPE_OCCURRENCE',

  'INDIVIDUAL'             ,
  'JOURNAL'                ,
  'LASTKEY'                ,
  'LOCATION'               ,
  'LOCATION_ADMIN_AREAS'   ,
  'LOCATION_DATA'          ,
  'LOCATION_NAME'          ,
  'NAME'                   ,
  'ORGANISATION'           ,
  'REFERENCE'              ,
  'REFERENCE_AUTHOR'       ,
  'REFERENCE_EDITOR'       ,
  'REFERENCE_NUMBER'       ,
  'SAMPLE'                 ,
  'SAMPLE_DATA'            ,
  'SAMPLE_RECORDER'        ,
  'SOURCE'                 ,
  'SPECIMEN'               ,
  'SURVEY'                 ,
  'SURVEY_DATA'            ,
  'SURVEY_EVENT'           ,
  'SURVEY_EVENT_DATA'      ,
  'SURVEY_EVENT_RECORDER'  ,
  'SURVEY_SOURCES'         ,
  'TAXON_DETERMINATION'    ,
  'TAXON_OCCURRENCE'       ,
  'TAXON_OCCURRENCE_DATA'))"


x <- RODBC::sqlQuery(gdb, query, rows_at_time = 1)
colnames(x)[1] <- "oldLastKeyValue"

#biotope OCCURRENCE table
biotope_OCCURRENCE <-   paste("SELECT Max(Right(BIOTOPE_OCCURRENCE.BIOTOPE_OCCURRENCE_KEY,8)) AS NewLastKey FROM BIOTOPE_OCCURRENCE WHERE BIOTOPE_OCCURRENCE.BIOTOPE_OCCURRENCE_KEY Not Like '%JNCCMNCR%'")
biotope_OCCURRENCE <- data.frame(TABLE_NAME = "BIOTOPE_OCCURRENCE",  RODBC::sqlQuery(gdb, biotope_OCCURRENCE, rows_at_time = 1, believeNRows = FALSE, as.is = TRUE))

#biotope OCCURRENCE data table
biotope_occurrence_data <- "SELECT Max(Right(BIOTOPE_OCCURRENCE_DATA.BIOTOPE_OCCURRENCE_DATA_KEY,8)) AS NewLastKey FROM BIOTOPE_OCCURRENCE_DATA WHERE BIOTOPE_OCCURRENCE_DATA.BIOTOPE_OCCURRENCE_DATA_KEY Not Like '%JNCCMNCR%'"
biotope_occurrence_data <- data.frame(TABLE_NAME = "BIOTOPE_OCCURRENCE_DATA",  RODBC::sqlQuery(gdb, biotope_occurrence_data, rows_at_time = 1, believeNRows = FALSE, as.is = TRUE))

#individual table
individual <- "SELECT Max(Right(INDIVIDUAL.NAME_KEY,8)) AS NewLastKey FROM INDIVIDUAL WHERE INDIVIDUAL.NAME_KEY Not Like '%JNCCMNCR%'"
individual <- data.frame(TABLE_NAME = "INDIVIDUAL",  RODBC::sqlQuery(gdb, individual, rows_at_time = 1, believeNRows = FALSE, as.is = TRUE))

#journal table
journal <- "SELECT Max(Right(JOURNAL.JOURNAL_KEY,8)) AS NewLastKey FROM JOURNAL WHERE JOURNAL.JOURNAL_KEY Not Like '%JNCCMNCR%'"
journal <- data.frame(TABLE_NAME = "JOURNAL",  RODBC::sqlQuery(gdb, journal, rows_at_time = 1, believeNRows = FALSE, as.is = TRUE))

#location table
location <- "SELECT Max(Right(LOCATION.LOCATION_KEY,8)) AS NewLastKey FROM LOCATION WHERE LOCATION.LOCATION_KEY Not Like '%JNCCMNCR%'"
location <- data.frame(TABLE_NAME = "LOCATION",  RODBC::sqlQuery(gdb, location, rows_at_time = 1, believeNRows = FALSE, as.is = TRUE))

#location admin areas table
location_admin_areas <- "SELECT Max(Right(LOCATION_ADMIN_AREAS.LOCATION_ADMIN_AREAS_KEY,8)) AS NewLastKey FROM LOCATION_ADMIN_AREAS WHERE LOCATION_ADMIN_AREAS.LOCATION_ADMIN_AREAS_KEY Not Like '%JNCCMNCR%'"
location_admin_areas <- data.frame(TABLE_NAME = "LOCATION_ADMIN_AREAS",  RODBC::sqlQuery(gdb, location_admin_areas, rows_at_time = 1, believeNRows = FALSE, as.is = TRUE))

#location data table
location_data <- "SELECT Max(Right(LOCATION_DATA.LOCATION_DATA_KEY,8)) AS NewLastKey FROM LOCATION_DATA WHERE LOCATION_DATA.LOCATION_DATA_KEY Not Like '%JNCCMNCR%'"
location_data <- data.frame(TABLE_NAME = "LOCATION_DATA",  RODBC::sqlQuery(gdb, location_data, rows_at_time = 1, believeNRows = FALSE, as.is = TRUE))

#location name table
location_name <- "SELECT Max(Right(LOCATION_NAME.LOCATION_NAME_KEY,8)) AS NewLastKey FROM LOCATION_NAME WHERE LOCATION_NAME.LOCATION_NAME_KEY Not Like '%JNCCMNCR%'"
location_name <- data.frame(TABLE_NAME = "LOCATION_NAME",  RODBC::sqlQuery(gdb, location_name, rows_at_time = 1, believeNRows = FALSE, as.is = TRUE))

#name table
name <- "SELECT Max(Right(NAME.NAME_KEY,8)) AS NewLastKey FROM NAME WHERE NAME.NAME_KEY Not Like '%JNCCMNCR%'"
name <- data.frame(TABLE_NAME = "NAME",  RODBC::sqlQuery(gdb, name, rows_at_time = 1, believeNRows = FALSE, as.is = TRUE))

#organisation table
organisation <- "SELECT Max(Right(ORGANISATION.NAME_KEY,8)) AS NewLastKey FROM ORGANISATION WHERE ORGANISATION.NAME_KEY Not Like '%JNCCMNCR%'"
organisation <-  data.frame(TABLE_NAME = "ORGANISATION",  RODBC::sqlQuery(gdb, organisation, rows_at_time = 1, believeNRows = FALSE, as.is = TRUE))

#reference table
reference <- "SELECT Max(Right(REFERENCE.SOURCE_KEY,8)) AS NewLastKey FROM REFERENCE WHERE REFERENCE.SOURCE_KEY Not Like '%JNCCMNCR%'"
reference <- data.frame(TABLE_NAME = "REFERENCE",  RODBC::sqlQuery(gdb, reference, rows_at_time = 1, believeNRows = FALSE, as.is = TRUE))

#reference author table
reference_author <- "SELECT Max(Right(REFERENCE_AUTHOR.AUTHOR_KEY,8)) AS NewLastKey FROM REFERENCE_AUTHOR WHERE REFERENCE_AUTHOR.AUTHOR_KEY Not Like '%JNCCMNCR%'"
reference_author <- data.frame(TABLE_NAME = "REFERENCE_AUTHOR",  RODBC::sqlQuery(gdb, reference_author, rows_at_time = 1, believeNRows = FALSE, as.is = TRUE))

#reference editor table
reference_editor <- "SELECT Max(Right(REFERENCE_EDITOR.EDITOR_KEY,8)) AS NewLastKey FROM REFERENCE_EDITOR WHERE REFERENCE_EDITOR.EDITOR_KEY Not Like '%JNCCMNCR%'"
reference_editor <- data.frame(TABLE_NAME = "REFERENCE_EDITOR",  RODBC::sqlQuery(gdb, reference_editor, rows_at_time = 1, believeNRows = FALSE, as.is = TRUE))

#reference number table
reference_number <- "SELECT Max(Right(REFERENCE_NUMBER.NUMBER_KEY,8)) AS NewLastKey FROM REFERENCE_NUMBER WHERE REFERENCE_NUMBER.NUMBER_KEY Not Like '%JNCCMNCR%'"
reference_number <-  data.frame(TABLE_NAME = "REFERENCE_NUMBER",  RODBC::sqlQuery(gdb, reference_number, rows_at_time = 1, believeNRows = FALSE, as.is = TRUE))

#sample table
sample <- "SELECT Max(Right(SAMPLE.SAMPLE_KEY,8)) AS NewLastKey FROM SAMPLE WHERE SAMPLE.SAMPLE_KEY Not Like '%JNCCMNCR%'"
sample <-  data.frame(TABLE_NAME = "SAMPLE",  RODBC::sqlQuery(gdb, sample, rows_at_time = 1, believeNRows = FALSE, as.is = TRUE))

#sample data table
sample_data <- "SELECT Max(Right(SAMPLE_DATA.SAMPLE_DATA_KEY,8)) AS NewLastKey FROM SAMPLE_DATA WHERE SAMPLE_DATA.SAMPLE_DATA_KEY Not Like '%JNCCMNCR%'"
sample_data <-  data.frame(TABLE_NAME = "SAMPLE_DATA",  RODBC::sqlQuery(gdb, sample_data, rows_at_time = 1, believeNRows = FALSE, as.is = TRUE))

#source table
source <- "SELECT Max(Right(SOURCE.SOURCE_KEY,8)) AS NewLastKey FROM SOURCE WHERE SOURCE.SOURCE_KEY Not Like '%JNCCMNCR%'"
source <-  data.frame(TABLE_NAME = "SOURCE",  RODBC::sqlQuery(gdb, source, rows_at_time = 1, believeNRows = FALSE, as.is = TRUE))

#specimen table
specimen <- "SELECT Max(Right(SPECIMEN.SPECIMEN_KEY,8)) AS NewLastKey FROM SPECIMEN WHERE SPECIMEN.SPECIMEN_KEY Not Like '%JNCCMNCR%'"
specimen <- data.frame(TABLE_NAME = "SPECIMEN",  RODBC::sqlQuery(gdb, specimen, rows_at_time = 1, believeNRows = FALSE, as.is = TRUE))

#survey table
survey <- "SELECT Max(Right(SURVEY.SURVEY_KEY,8)) AS NewLastKey FROM SURVEY WHERE SURVEY.SURVEY_KEY Not Like '%JNCCMNCR%'"
survey <- data.frame(TABLE_NAME = "SURVEY",  RODBC::sqlQuery(gdb, survey, rows_at_time = 1, believeNRows = FALSE, as.is = TRUE))

#survey data table
survey_data <- "SELECT Max(Right(SURVEY_DATA.SURVEY_DATA_KEY,8)) AS NewLastKey FROM SURVEY_DATA WHERE SURVEY_DATA.SURVEY_DATA_KEY Not Like '%JNCCMNCR%'"
survey_data <-  data.frame(TABLE_NAME = "SURVEY_DATA",  RODBC::sqlQuery(gdb, survey_data, rows_at_time = 1, believeNRows = FALSE, as.is = TRUE))

#survey event table
survey_event <- "SELECT Max(Right(SURVEY_EVENT.SURVEY_EVENT_KEY,8)) AS NewLastKey FROM SURVEY_EVENT WHERE SURVEY_EVENT.SURVEY_EVENT_KEY Not Like '%JNCCMNCR%'"
survey_event <-  data.frame(TABLE_NAME = "SURVEY_EVENT",  RODBC::sqlQuery(gdb, survey_event, rows_at_time = 1, believeNRows = FALSE, as.is = TRUE))

#survey event data table
survey_event_data <- "SELECT Max(Right(SURVEY_EVENT_DATA.SURVEY_EVENT_DATA_KEY,8)) AS NewLastKey FROM SURVEY_EVENT_DATA WHERE SURVEY_EVENT_DATA.SURVEY_EVENT_DATA_KEY Not Like '%JNCCMNCR%'"
survey_event_data <-  data.frame(TABLE_NAME = "SURVEY_EVENT_DATA",  RODBC::sqlQuery(gdb, survey_event_data, rows_at_time = 1, believeNRows = FALSE, as.is = TRUE))

#survey event recorder table
survey_event_recorder <- "SELECT Max(Right(SURVEY_EVENT_RECORDER.SE_RECORDER_KEY,8)) AS NewLastKey FROM SURVEY_EVENT_RECORDER WHERE SURVEY_EVENT_RECORDER.SE_RECORDER_KEY Not Like '%JNCCMNCR%'"
survey_event_recorder <- data.frame(TABLE_NAME = "SURVEY_EVENT_RECORDER",  RODBC::sqlQuery(gdb, survey_event_recorder, rows_at_time = 1, believeNRows = FALSE, as.is = TRUE))

#survey sources table
survey_sources <- "SELECT Max(Right(SURVEY_SOURCES.SOURCE_LINK_KEY,8)) AS NewLastKey FROM SURVEY_SOURCES WHERE SURVEY_SOURCES.SOURCE_LINK_KEY Not Like '%JNCCMNCR%'"
survey_sources <- data.frame(TABLE_NAME = "SURVEY_SOURCES",  RODBC::sqlQuery(gdb, survey_sources, rows_at_time = 1, believeNRows = FALSE, as.is = TRUE))

#taxon determination table
taxon_determination <- "SELECT Max(Right(TAXON_DETERMINATION.TAXON_DETERMINATION_KEY,8)) AS NewLastKey FROM TAXON_DETERMINATION WHERE TAXON_DETERMINATION.TAXON_DETERMINATION_KEY Not Like '%JNCCMNCR%'"
taxon_determination <- data.frame(TABLE_NAME = "TAXON_DETERMINATION",  RODBC::sqlQuery(gdb, taxon_determination, rows_at_time = 1, believeNRows = FALSE, as.is = TRUE))

#taxon OCCURRENCE table
taxon_OCCURRENCE <- "SELECT Max(Right(TAXON_OCCURRENCE_DATA.TAXON_OCCURRENCE_DATA_KEY,8)) AS NewLastKey FROM TAXON_OCCURRENCE_DATA WHERE TAXON_OCCURRENCE_DATA.TAXON_OCCURRENCE_DATA_KEY Not Like '%JNCCMNCR%'"
taxon_OCCURRENCE <- data.frame(TABLE_NAME = "TAXON_OCCURRENCE",  RODBC::sqlQuery(gdb, taxon_OCCURRENCE, rows_at_time = 1, believeNRows = FALSE, as.is = TRUE))

#taxon OCCURRENCE data table
taxon_OCCURRENCE_data <- "SELECT Max(Right(TAXON_OCCURRENCE.TAXON_OCCURRENCE_KEY,8)) AS NewLastKey FROM TAXON_OCCURRENCE WHERE TAXON_OCCURRENCE.TAXON_OCCURRENCE_KEY Not Like '%JNCCMNCR%'"
taxon_OCCURRENCE_data <- data.frame(TABLE_NAME = "TAXON_OCCURRENCE_DATA",  RODBC::sqlQuery(gdb, taxon_OCCURRENCE_data, rows_at_time = 1, believeNRows = FALSE, as.is = TRUE))



#combine all the tables together
newLastKeys <- suppressWarnings(dplyr::bind_rows(biotope_OCCURRENCE, biotope_occurrence_data, individual, journal, location, location_admin_areas, location_data, location_name, name, organisation, reference, reference_author, reference_editor, reference_number, sample, sample_data, source, specimen, survey, survey_data, survey_event, survey_event_data, survey_event_recorder, survey_sources, taxon_determination, taxon_OCCURRENCE, taxon_OCCURRENCE_data))

newLastKeys <- subset(newLastKeys, !is.na(NewLastKey))

newLastKeys <- dplyr::left_join(newLastKeys, x)

toSave <- newLastKeys
toSave$LAST_KEY_TEXT <- NULL
colnames(toSave)[2] <- "LAST_KEY_TEXT"

sqlUpdate(gdb, toSave, tablename = "LAST_KEY", index = "TABLE_NAME")

odbcCloseAll()

return(newLastKeys)

}
