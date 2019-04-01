
#' @title Text file specifications for weekly extracts
#' @description Returns the full table of specifications for fixed-width text files that are extracted weekly. You can explore the table for a full list of data fields that are available. The resulting table is designed to be used with the readr package to read text files.
#' @param spec A single string (character) that relates to one of the specification names. This must match the specification name exactly.
#' @param keep A character vector (e.g., c('EmployeeID', 'Birthdate', 'TitleCode')) that allows the user to keep only specific fields (columns) when importing a text file. This is useful when there are many fields that are unneeded. Defaults to keep all.
#' @param drop A character vector that allows the user to drop certain fields when importing a text file. This is useful when there are only a few fields that are unwanted. Defaults to NULL, which effectively keeps all fields when importing.
#' @return By default, import_specs() with no arguments specified returns a data.frame object containing all the names of the text files and their corresponding fields, start points, end points, and field widths. The resulting data.frame has columns SpecID, SpecName, FieldName, Start, Width, and End. By using the keep or drop arguments, you are effectively filtering this data.frame for the fields you want to keep or drop.
#' @examples
#' require(dplyr)
#' demo_specs <- import_specs("EmplDemogr")
#' demo_file <- dhr_data("EmplDemogr")
#'
#' require(readr)
#'
#' demo_data <- read_fwf( demo_file,
#'                       col_positions = fwf_positions(
#'                                       start = demo_specs$Start,
#'                                       end = demo_specs$End ,
#'                                       col_names = demo_specs$FieldName))

# Import Specifications
#' @export
import_specs <- function(spec = "all", keep = NULL, drop = NULL) {

    # Default behavior is to return all specs so the user can browse if needed.
    if ( spec == "all" )
        return(file_specs)

    # If a spec is provided, return the spec and any rows dropped/kept
    if ( is.null(drop) && is.null(keep) ) {

        file_specs <- file_specs

        spec <- file_specs %>%
            dplyr::filter( SpecName == spec )

    } else if ( !is.null(drop) ) {

        if ( !is.character(drop) )
            stop("Specify the columns to drop as a character or character vector")

        spec <- file_specs %>%
            dplyr::filter( SpecName == spec ) %>%
            dplyr::filter( !(FieldName %in% drop ) )

    } else if ( !is.null(keep) ) {

        if ( !is.character(keep) )
            stop("Specify the columns to keep as a character or character vector")

        spec <- file_specs %>%
            dplyr::filter( SpecName == spec ) %>%
            dplyr::filter( FieldName %in% keep )

    }

    return(spec)

}
