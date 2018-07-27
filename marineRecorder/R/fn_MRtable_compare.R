NewSurveys<-function(DSN1, tablename1, DSN2, tablename2, colname){
#################################################################################
# INFORMATION ON THE FUNCTION 'NewSurveys' - May 2016 (roweena.patel@jncc.gov.uk)
#  
# Input values
# DSN1 - file location of database 1
# tablename1 - name of table in quotations for comparison in database 1
# DSN2 - file location of database 2
# tablename2 - name of table i quotations for comparison in database 2
# colname - column name of tables in quotations used for comparison - it is assumed that the databases will have the same colname  
#
################################################################################  
  require(RODBC)
  #connection and extract survey table of first dataset
  con1<-odbcConnectAccess(DSN1) #insert location of snapshot
  Survey1 <- sqlFetch(con1, tablename1)
  
  #connection and extract survey table to send dataset
  con2<-odbcConnectAccess(DSN2) #insert location of snapshot
  Survey2 <- sqlFetch(con2, tablename2)

  #pull out all the data that is not in table 2
  New <- Survey1[,colname] %in% Survey2[,colname]
  new_in_old <- cbind(New, Survey1)
  results <- subset(new_in_old, new_in_old$New == FALSE)
  results[1]<- NULL
  
  odbcCloseAll()
  
  return(results)
  
}