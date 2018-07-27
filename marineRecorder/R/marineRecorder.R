#' marineRecorder: A Package to work with the Marine Recorder Application
#'
#' mA Marine Recorder R Package was developed to work with the Marine Recorder snapshot (available on the JNCC website).
#' The R package contains functions to work with the snapshot by creating shapefiles, checking for new surveys and checking the species in the species dictionary (a separate database used with the main application).
#'
#' It has three main goals:
#'
#' \itemize{
#' \item Creating shapefiles from the snapshot (Surveys, Samples, Species). - Currently in progress.
#' \item To work with the World Register of Marine Species (WoRMS) API to check for valid taxa and to retrieve the parent taxa.
#' \item Check for new surveys that have been added to the UK wide snapshot. - Currently in progress.
#' }
#'
#'
#' Currently in progress...To learn more about marineRecorder, start with the vignettes:
#' `browseVignettes(package = "marineRecorder")`
#'
#'
#'
#'
#' @useDynLib marineRecorder, .registration = TRUE
#' @import rlang
#' @import dplyr
#' @import worms
#' @import daff
#' @import stringr
#' @import RCurl
#' @import sqldf
#'
#' @docType package
#' @name marineRecorder
"_PACKAGE"
