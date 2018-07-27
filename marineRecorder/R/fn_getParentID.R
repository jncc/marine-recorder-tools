#' Get Parent AphiaID
#'
#' This function allows you retrieve the parent of a given Aphia ID.
#' @param inputAphiaID The Aphia ID of the taxon that you want the parent Aphia ID from.
#' @keywords AphiaID, WoRMS
#' @export
#' @examples
#' # Enter aphia ID - Animalia (2)
#' getParentID(2)
#' #[1] 1
#' @import stringr
#' @import RCurl



getParentID <- function(inputAphiaID){
  #this function uses the worms API to fetch the parent ID record

  require(RCurl)
  require(stringr)
  if(!is.na(inputAphiaID)){
    if(inputAphiaID == 1){return(1)}
  else{
  restURL <- paste("http://www.marinespecies.org/rest//AphiaClassificationByAphiaID", inputAphiaID, sep="/")
  response <- getURL(restURL)
  regpattern <- "\"AphiaID\":([0-9]+)"
  matches <- stringr::str_match_all(response, regpattern)
  matchgroups <- matches[[1]][,2] #vector or list containing full tree
  parentID <- as.integer(matchgroups[length(matchgroups)-1])

  return(parentID)
  }
  }
  else{return(NA)}
}
