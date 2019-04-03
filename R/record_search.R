#' @title Filter employee records
#' @description This function allows users/analysts to filter a data.frame using an arbitrary list of criteria. This function and other filtering functions in this package are based on the JPACT extract, which contains a few of the required column names (e.g., APPOINTMENT_ID, EMPLOYEE_ID)
#' @param df The data.frame to which the criteria list is applied.
#' @param filter_list A list of criteria.
#' @return A data.frame that has been filtered to show the most recent employee records. Use this function to find current employees based on any number of criteria. The only criteria that must be provided is the EXPIRATION_DT being equal to 12319999.
#' @examples
#' ## Not run:
#' require(lubridate)

#' # Find the queried records and then get a count
#' jpact %>%
#'    record_search(
#'        list(
#'            EXPIRATION_DT = c(mdy("12319999")) ,
#'            HOME_DEPT_CD = grep("GJ|NL|SC|NB", unique(jpact$HOME_DEPT_CD), value = TRUE, invert = TRUE),
#'            EMPLMT_STA_CD = c("A") ,
#'            SUB_TITLE_CD = c("A", "D", "L", "N")
#'        )
#'    ) %>%
#'    nrow()


# Filter employee records
#' @export
record_search <- function(df, filter_list) {
    df %>%
        dplyr::filter( is.na(APPOINTMENT_ID) ) %>%  # make sure appt id is blank (primary job)
        dplyr::group_by(EMPLOYEE_ID) %>%
        dplyr::slice( c( n() ) ) %>%  # get last record of group
        dplyr::ungroup() %>%
        my_filter(filter_list)
}
