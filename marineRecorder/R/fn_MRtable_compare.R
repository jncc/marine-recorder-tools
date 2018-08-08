#' Find new surveys in the snapshot
#'
#' This function will identify new surveys that have been added into the new snapshot.
#' @param DSN1 - file location of database 1
#' @param tablename1 - name of table in quotations for comparison in database 1
#' @param DSN2 - file location of database 2
#' @param tablename2 - name of table in quotations for comparison in database 2
#' @param primaryKey - column name of the primary key (the column used to compare the tables)
#' @keywords snapshot, RODBC, surveys
#' @export
#' @examples
#'
#' #find and paste new snapshot filepath
#' filepath_new_snapshot <- "SnapshotDatav51_Public_20180524.mdb"
#'
#' #find and paste old snapshot filepath
#' filepath_old_snapshot <- "SnapshotDatav51_Public_20180131.mdb"
#'
#' #run the function on the 'Survey' table where the primary key for the table is 'Survey_Key'
#' surveysAdded <- newSurveys(DSN1 = filepath_new_snapshot, tablename1 = "Survey", DSN2 = filepath_old_snapshot, tablename2 = "Survey", primaryKey = "Survey_Key" )

#'
#' @import RODBC


newSurveys<-function(DSN1, tablename1, DSN2, tablename2, primaryKey){

  require(RODBC, quietly = TRUE)
  #connection and extract survey table of first dataset
  con1<-odbcConnectAccess(DSN1) #insert location of snapshot
  Survey1 <- sqlFetch(con1, tablename1)

  #connection and extract survey table to seconnd dataset
  con2<-odbcConnectAccess(DSN2) #insert location of snapshot
  Survey2 <- sqlFetch(con2, tablename2)

  #pull out all the data that is not in table 2
  New <- Survey1[,primaryKey] %in% Survey2[,primaryKey]
  new_in_old <- cbind(New, Survey1)
  results <- subset(new_in_old, new_in_old$New == FALSE)
  results[1]<- NULL

  odbcCloseAll()

  return(results)

}
