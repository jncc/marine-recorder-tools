#' Add Valid AphiaID
#'
#' @description This function allows you add Valid Aphia ID records to your data frame and outputs changes made to the dataframe.
#' @details
#' This function depends on the 'missingValidAphiaIDs' function.
#' This function differs from those as because of the outputs. Outputs will be generated to know the records that have been added or amended.
#'
#' Outputs:
#' dataset - input dataset with AphiaID and validAphiaIDs.
#' added records - this will presented in the R Console.
#' validAphiaIDUpdates - saved as csv to your working directory. This is only created when an valid aphia ID is not accepted but there is an accepted valid aphia ID.
#'
#' @param dataset data frame that has the column "AphiaID".
#' @keywords AphiaID, WoRMS, ParentAphiaID
#' @export
#' @examples
#' data(marineKingdoms)
#' #run add valid IDs function
#' x <- addValidAphiaIDs(marineKingdoms)
#' #Added Aphia ID records: 6
#' #1 new records have been added.
#'
#' # Aphia ID 6 is a valid Aphia ID but is not in the dataset as an individual record.
#'
#' #Run to check if there any more missing valid AphiaID records
#' missingValidAphiaIDs(x)
#' #[1] "All valid aphiaIDs are also individual records"
#'
#'
#' @import dplyr
#' @import worms
#' @import daff
#' @import sqldf


addValidAphiaIDs <- function(dataset) {
  #this function adds in missing valid aphiaIDs as individual records

  diff <- missingValidAphiaIDs(dataset)

  if (typeof(diff) != "integer") {
    stop("No valid aphiaIDs to add")
  }

  if (any(is.na(diff))) {
    diff <- subset(diff , !is.na(diff))
  } else {
    diff
  }

  #run through the missing valid aphia IDs through worms
  missing_valid_IDs <- worms::wormsbyid(diff, verbose = FALSE)

  #missingValidIDs <<- missing_valid_IDs



  #if the status of the missing records are accepted put straight into new LUT
  if ("accepted" %in% missing_valid_IDs$status) {
    accepted <- dplyr::filter(missing_valid_IDs, status == "accepted")

    iLUT_v1 <-suppressWarnings(dplyr::bind_rows(dataset, accepted))
  }

  else{
    iLUT_v1 <- dataset
  }


  #if deleted and unaccepted exist
  if ("deleted" %in% missing_valid_IDs$status &
      "unaccepted" %in% missing_valid_IDs$status) {
    unaccepted <-
      dplyr::filter(missing_valid_IDs, status == "unaccepted")
    deleted <-
      dplyr::filter(missing_valid_IDs, status == "deleted")

    Worms_flag_incorrect_valid_ID <-
      suppressWarnings(dplyr::bind_rows(deleted, unaccepted))
  }

  else{
    if ("deleted" %in% missing_valid_IDs$status) {
      deleted <- dplyr::filter(missing_valid_IDs, status == "deleted")
      Worms_flag_incorrect_valid_ID <- deleted
    }
    else{
      if ("unaccepted" %in% missing_valid_IDs$status) {
        unaccepted <-
          dplyr::filter(missing_valid_IDs, status == "unaccepted")
        Worms_flag_incorrect_valid_ID <- unaccepted
      }
      else{
        Worms_flag_incorrect_valid_ID <- NULL
      }

    }
  }

  #Worms_flag_incorrect_valid_ID <<- Worms_flag_incorrect_valid_ID

  #write.csv(Worms_flag_incorrect_valid_ID, paste("Worms_flag_incorrect_valid_ID", Sys.Date(),  ".csv"), row.names = FALSE)


  if ("alternate representation" %in% missing_valid_IDs$status) {
    alt_rep <-
      dplyr::filter(missing_valid_IDs, status == "alternate representation")
    alt_rep_worms <<-
      worms::wormsbyid(alt_rep$valid_AphiaID, verbose = FALSE)
    iLUT_v2 <- suppressWarnings(dplyr::bind_rows(dataset, alt_rep))
  }

  else{
    iLUT_v2 <- iLUT_v1
  }


  #extract the rest of the statuses from the 'missing' data frame

  dubious <-
    subset(
      missing_valid_IDs,
      status != "accepted" &
        status != "unaccepted" &
        status != "alternate representation" & status != "deleted"
    )



  #add into LUT

  iLUT_v3 <- suppressWarnings(dplyr::bind_rows(iLUT_v2, dubious))



  #Update the valid_aphia IDs of these records to the alternate representation records

  if (length(Worms_flag_incorrect_valid_ID) > 0) {
    iLUT_v3 <- suppressWarnings(sqldf::sqldf(
      c(
        "UPDATE iLUT_v3
        SET valid_AphiaID = ( SELECT Worms_flag_incorrect_valid_ID.valid_AphiaID
        FROM Worms_flag_incorrect_valid_ID
        WHERE iLUT_v3.valid_AphiaID = Worms_flag_incorrect_valid_ID.AphiaID
        )
        WHERE EXISTS (SELECT 1
        FROM Worms_flag_incorrect_valid_ID
        WHERE iLUT_v3.valid_AphiaID = Worms_flag_incorrect_valid_ID.AphiaID
        )",
                             "select * from iLUT_v3"
      )
    )
    )


    check_changes <- daff::diff_data(iLUT_v4, iLUT_v3)

    #validAphiaIDChanges <<- check_changes

    daff::write_diff(check_changes,
                     file = paste("validAphiaIDUpdates", Sys.Date(),  ".csv"))

  }
  else{
     iLUT_v3
  }

  addedValidRecords <- dplyr::anti_join(iLUT_v3, dataset, by = "AphiaID")
  #addedValidRecords <<- addedValidRecords

  cat("Added Aphia ID records:", addedValidRecords$AphiaID, "\n", nrow(addedValidRecords), "new records have been added.")

  return(iLUT_v3)


}
