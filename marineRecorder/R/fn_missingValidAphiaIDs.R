#' Find aphia ID records with missing valid records in the dataset
#'
#' This function identifies if the valid aphia IDs are entered as individual records
#' @param dataset data frame that has the column "AphiaID" and "valid_AphiaID".
#' @keywords AphiaID, WoRMS, Parent
#' @details
#' To use this function the dataset must have an "AphiaID" column and a "valid_AphiaID" column.
#' @export
#' @examples
#' data(marineKingdoms)
#'
#' #Run missingValidAphiaIDs function to check if any Valid Aphia ID records are missing from the dataset.
#' missingValidAphiaIDs(marineKingdoms)
#' #[1] 6
#' # Aphia ID 6 is a valid AphiaID for a record but is missing from the dataset. Use 'addValidAphiaIDs' function to enter this record.
#'
#' @importFrom dplyr



missingValidAphiaIDs <- function(dataset){

  #this function identifies if the valid aphia IDs are entered as individual records
  #please make sure there this an AphiaID column and a valid_aphiaID column

  if("AphiaID" %in% colnames(dataset) & "valid_AphiaID" %in% colnames(dataset)) {
    diff <- dplyr::setdiff(dataset$valid_AphiaID, dataset$AphiaID)
    if(length(diff) > 0) {
      if (any(is.na(diff))){
        warning("Some Valid AphiaIDs are NA. Calm down and drink a beer (and call WoRMS).")
        return(diff)
        #print("Some Valid AphiaIDs are NA. Calm down and drink a beer (and call WoRMS). How to resolve this temporarily? What would the 'Preferred Name' be? Would leaving it as NA break MR?"))
      }else{
        return(diff)
      }
    }

    else{print("All valid aphiaIDs are also individual records")}

  }

  else {stop("Make sure you have the correct column names OR the columns, 'AphiaID' and 'valid_AphiaID', exist in the data frame.")}
}
