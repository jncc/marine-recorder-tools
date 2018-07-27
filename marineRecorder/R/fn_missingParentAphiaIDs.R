#' Find records with missing Parent records
#'
#' This function allows you identify missing Parent records to your data frame.
#' @param dataset data frame that has the column "AphiaID" and "Parent.AphiaID.
#' @keywords AphiaID, WoRMS, Parent
#' @export
#' @examples
#' data(marineKingdoms)
#'
#' #run 'updateParentAphiaIDs' function
#' x <- updateParentAphiaIDs(marineKingdoms)
#'
#' #Run missingParentAphiaIDs function to check if any parent records are missing from the dataset.
#' missingParentAphiaIDs(x)
#' #[1] 1 8
#'
#' @importFrom dplyr




missingParentAphiaIDs <- function(dataset) {
  #this function identifies whether there are parent aphia IDs entered as individual records in the dataset.
  #please make sure there this an AphiaID columns and a Parent.AphiaID column

  if ("AphiaID" %in% colnames(dataset) & "Parent.AphiaID" %in% colnames(dataset)) {
    diff <- unlist(dplyr::setdiff(dataset$Parent.AphiaID, dataset$AphiaID))
    if (length(diff) > 0){
      if (any(is.na(diff))){
        stop("Some Parent AphiaIDs are NA. Re- run 'updateParentAphiaIDs' function. ")
      }else{
        return(diff)
      }
    }else{
      print("All parent aphiaIDs are also individual records.")
    }
  }else{
    stop("Make sure you have the correct column names OR the columns, 'AphiaID' and 'Parent.AphiaID', exist in the data frame.")
  }
}
