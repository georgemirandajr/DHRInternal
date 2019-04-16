#' @title Filter employee records
#' @description This allows users to filter a data.frame using an arbitrary list of criteria. You can search for current employees using EXPIRATION_DT = "12319999" in your list of criteria, or employees at a specified time using the optional arguments date and grp. This function and other filtering functions in this package are based on the JPACT extract, which contains a few of the required column names (e.g., APPOINTMENT_ID, EMPLOYEE_ID)
#' @param df The data.frame to which the criteria list is applied.
#' @param filter_list A list of criteria.
#' @param date (Optional) A date or character vector of length 1.
#' @param grp (Optional) A character vector of length 1 that specifies how to group the data.
#' @return A data.frame that has been filtered to show the employee records or grouped by the specified variable and displayed with a count. Use this function to find current employees based on any number of criteria. The only criteria that must be provided is the EXPIRATION_DT being equal to 12319999.
#' @examples
#' ## Not run:
#' require(lubridate)

#' # Find the records of current employees
#' jpact %>%
#'    record_search(
#'        list(
#'            EXPIRATION_DT = c(mdy("12319999")) ,
#'            HOME_DEPT_CD = grep("GJ|NL|SC|NB", unique(jpact$HOME_DEPT_CD), value = TRUE, invert = TRUE),
#'            EMPLMT_STA_CD = c("A"),
#'            SUB_TITLE_CD = c("A", "D", "L", "N")
#'        )
#'    )
#'
#' # Same as above, but grouped by department code
#' record_search(df = jpact, grp = HOME_DEPT_CD, filter_list = list(
#' EXPIRATION_DT = mdy("12319999"),
#' HOME_DEPT_CD = grep("GJ|NL|SC|NB", unique(jpact$HOME_DEPT_CD), value = TRUE, invert = TRUE),
#' EMPLMT_STA_CD = c("A") ,
#' SUB_TITLE_CD = c("A", "D", "L", "N") ) )
#'
#' # Find employees at a specified time
#' record_search(df = jpact, date = mdy("01012014"), filter_list = list(
#' HOME_DEPT_CD = grep("GJ|NL|SC|NB", unique(jpact$HOME_DEPT_CD), value = TRUE, invert = TRUE),
#' EMPLMT_STA_CD = c("A") ,
#' SUB_TITLE_CD = c("A", "D", "L", "N") ) )
#'
#' # Same filter as above, but now grouped
#' record_search(df = jpact, date = mdy("01012014"), grp = HOME_DEPT_CD, filter_list = list(
#' HOME_DEPT_CD = grep("GJ|NL|SC|NB", unique(jpact$HOME_DEPT_CD), value = TRUE, invert = TRUE),
#' EMPLMT_STA_CD = c("A") ,
#' SUB_TITLE_CD = c("A", "D", "L", "N") ) )

# Filter employee records
#' @export
record_search <- function(df, filter_list, date, grp) {

    date_var <- rlang::enquo(date)
    grp_var <- rlang::enquo(grp)

    if ( missing(date) ) {
        if( missing(grp) ) {
            df %>%
                dplyr::filter( is.na(APPOINTMENT_ID) ) %>%  # make sure appt id is blank (primary job)
                dplyr::group_by(EMPLOYEE_ID) %>%
                dplyr::slice( c( n() ) ) %>%  # get last record of group
                dplyr::ungroup() %>%
                my_filter(filter_list)
        } else {
            df %>%
                dplyr::filter( is.na(APPOINTMENT_ID) ) %>%  # make sure appt id is blank (primary job)
                dplyr::group_by(EMPLOYEE_ID) %>%
                dplyr::slice( c( n() ) ) %>%  # get last record of group
                dplyr::ungroup() %>%
                my_filter(filter_list) %>%
                dplyr::group_by(!!grp_var) %>%
                summarise(Count = n() )
        }
    } else {
        # Employee records at a given time (NO GROUPING)
        if ( missing(grp) ) {
            df %>%
                dplyr::filter( is.na(APPOINTMENT_ID) ) %>%
                # Enter the cutoff date below
                dplyr::filter( ( EFFECTIVE_DT <= !!date & EXPIRATION_DT >= !!date ) ) %>%
                dplyr::group_by( EMPLOYEE_ID ) %>%
                dplyr::slice( c( n() ) ) %>%
                dplyr::ungroup() %>%
                my_filter(filter_list)
        } else {
            # Employee records at a given time (GROUPED)
            df %>%
                dplyr::filter( is.na(APPOINTMENT_ID) ) %>%
                # Enter the cutoff date below
                dplyr::filter( ( EFFECTIVE_DT <= !!date & EXPIRATION_DT >= !!date ) ) %>%
                dplyr::group_by( EMPLOYEE_ID ) %>%
                dplyr::slice( c( n() ) ) %>%
                dplyr::ungroup() %>%
                my_filter(filter_list) %>%
                dplyr::group_by(!!grp_var) %>%
                summarise(Count = n() )
        }
    }
}
