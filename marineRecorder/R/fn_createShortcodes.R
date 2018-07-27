#' Create 3 + 3 letter short codes from a string
#'
#' This function will take a string and return the first three letters of the first word and first three letters of the second word.
#' @param string The string you would like to create a code for.
#' @keywords string, shortcodes, abbreviations
#' @export
#' @examples
#' # Enter a string
#' createShortcodes("Salmo salar")
#' #[1] "Salsal"
#' @importFrom stringr



createShortcodes <- function(string){

  require(stringr, quietly = TRUE)
  #separate abbrev by spaces
  split <- stringr::str_split(string, " ")

  first.3 <- substr(split[[1]], start=1, stop=3)

  if(is.na(first.3[2])){
    abbrev <- first.3[1]
  }
  else{
  abbrev <- abbrev <- paste0(first.3[1], first.3[2])}
   return(abbrev)
  #

}
