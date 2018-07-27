#' Update or Add Parent Aphia IDs
#'
#' This function allows you add Parent records to your data frame. If there is no column called "Parent.AphidID" it will generate one and populate it.
#' @param dataset data frame that has the column "AphiaID".
#' @keywords AphiaID, WoRMS
#' @export
#' @examples
#' data(marineKingdoms)
#'
#' #run 'updateParentAphiaIDs' function. It add in the column 'Parent.AphiaID' and populates the column using the  'getParentID' function.
#' x <- updateParentAphiaIDs(marineKingdoms)
#'
#' #view the outputs
#' View(x)
#'
#' @importFrom dplyr
#' @importFrom RCurl
#' @importFrom stringr


updateParentAphiaIDs <- function(dataset) {
  #this functions adds parent aphiaID records or updates missing parent aphia ID records

  if ("Parent.AphiaID" %in% colnames(dataset))
  {
    #update the parentID column from parents table
    updated_parent_aphiaID <-
      dataset %>% dplyr::mutate(Parent.AphiaID = dplyr::if_else(
        !is.na(Parent.AphiaID),
        Parent.AphiaID,
        dplyr::if_else(
          is.na(Parent.AphiaID) &
            !is.na(AphiaID),
          as.integer(sapply(AphiaID, getParentID)),
          NULL
        )
      ))

    return(updated_parent_aphiaID)
  }

  else{
    #run function on whole dataset
    dataset$Parent.AphiaID <-
      as.integer(sapply(dataset$AphiaID, getParentID))
    #return the dataset
    return(dataset)
  }
}
