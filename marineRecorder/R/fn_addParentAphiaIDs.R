#' Add Parent AphiaID
#'
#' @description This function allows you add Parent records to your data frame and outputs missing parents according to their status.
#' @details
#' This function depends on 'missingParentAphiaIDs' and 'updateParentAphiaIDs' functions.
#' This function differs from those as because of the outputs. Four outputs will be generate to know the Parent Aphia ID records that have been added in by their status.
#'
#' Outputs:
#' dataset - input dataset with missing parents added in. If there is no "Parent_AphiaID" column the function will run the 'updateParentAphiaID' function.
#' accepted_missing_parents - missing parent records that have accepted valid AphiaI IDs.
#' alt_rep_missing_parents - missing parent records with a valid status of 'alternate representation'.
#' other_missing_parents - all other missing parent records (not accepted or an alternate representation).
#' @param dataset data frame that has the column "AphiaID".
#' @keywords AphiaID, WoRMS, ParentAphiaID
#' @export
#' @examples
#' data(marineKingdoms)
#' #run add parents function
#' u <- addParentAphiaIDs(marineKingdoms)
#'
#' #check for missing parents as individual records
#' missingParentAphiaIDs(u)
#'
#' #Run update parent IDs function
#' v <- updateParentAphiaIDs(u)
#' # Error in missingParentAphiaIDs(u) :
#' #  Some Parent AphiaIDs are NA. Re- run 'updateParentAphiaIDs' function.
#'
#' #check for missing parents as individual records
#' missingParentAphiaIDs(v)
#' #[1] "All parent aphiaIDs are also individual records."
#'
#' @import dplyr
#' @import worms


addParentAphiaIDs <- function(dataset) {
  parents <- updateParentAphiaIDS(dataset)

  missing_parents <- missingParentAphiaIDs(parents)

  if (typeof(missing_parents) != "integer") {
    return(parents)
  }


  #filter the records with missing parents aphia IDs
  MSBIAS_missing_parents <-
    dplyr::filter(parents, Parent.AphiaID %in% missing_parents)

  #pull of the missing parents through worms

  missing_parents_worms <-
    worms::wormsbyid(missing_parents, verbose = FALSE)

  #add missing parents to the iLUT

  updated_dataset <-
    dplyr::bind_rows(parents, missing_parents_worms)

  ### these outputs are ready to be added into the LUT - but will be pooled for now.

  if ("accepted" %in% missing_parents_worms$status) {
    accepted_missing_parents <<-
      dplyr::filter(missing_parents_worms, status == "accepted")
  }

  #extract alternate representation

  if ("alternate representation" %in% missing_parents_worms$status) {
    alt_rep_missing_parents <<-
      subset(missing_parents_worms,
             status == "alternate representation")
  }

  #write to global environment

  #all other issues

  other_missing_parents <<-
    subset(missing_parents_worms,
           status != "acccepted" |
             status != "alternate representation")


  return(updated_dataset)
}
