#' marineRecorder: A package to work with the Marine Recorder Application
#'
#' Marine Recorder R package was developed to work with the Marine Recorder snapshot (available on the JNCC website).
#' The R package contains functions to work with the snapshot by creating shapefiles, checking for new surveys and checking the species in the species dictionary (a separate database used with the main application).
#'
#' It has three main goals:
#'
#' \itemize{
#' \item Creating shapefiles from the snapshot (Samples, Species).
#' \item Check for valid taxa and to retrieve the parent taxa by using the World Register of Marine Species (WoRMS) API.
#' \item Check for new surveys that have been added to the UK wide snapshot.
#' }
#'
#' @author
#'
#'  \itemize{
#' \item Roweena Patel
#' }
#'
#' Maintainer: \email{MarineRecorder@jncc.gov.uk}
#'
#' Contributors:
#' \itemize{
#'  \item Jordan Pinder
#' \item Graeme Duncan
#' \item Emily Sym}
#'
#' @seealso
#'
#' Useful links:
#'
#' \itemize{
#' \item Marine Recorder Information and Snapshot Download - \link{http://jncc.defra.gov.uk/page-1599}
#' \item Marine Recorder Application Download - \link{https://www.esdm.co.uk/marine-recorder-downloads}}
#'
#' @docType package
#' @name marineRecorder
NULL
