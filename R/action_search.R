#' @title Filter actions (Personnel Action Codes) occurring within a user-specified date range.
#' @description This function allows users/analysts to apply an arbitrary list of filtering criteria within a date range. This function and other filtering functions in this package are based on the JPACT extract, which contains a few of the required column names (e.g., APPOINTMENT_ID, EMPLOYEE_ID).
#' @param df The data.frame to which the criteria list is applied.
#' @param filter_list A list of criteria.
#' @param action_dates A time interval ( lubridate::interval() )
#' @return A data.frame that has been filtered based on the provided criteria (i.e., MAPP, Gender, Department) and date range.
#' @examples
#' ## Not run:
#' # Find turnover
#' to <- c("20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "31", "32", "33", "34", "35", "36", "37", "38", "39")
#' time_frame <- lubridate::interval( mdy("01012018"), mdy("12312018"))
#'
#' jpact %>%
#'    action_search(
#'        list(
#'            HOME_DEPT_CD = my_depts,
#'            PERS_ACTN_CD = to,
#'            SUB_TITLE_CD = c("A", "D", "L", "N")
#'        ),
#'        action_dates = time_frame
#'    )


#' @export
action_search <- function(df, filter_list, action_dates) {
    df %>%
        dplyr::filter( is.na(APPOINTMENT_ID) &
                    EFFECTIVE_DT %within% action_dates ) %>%
        my_filter(filter_list) %>%
        dplyr::distinct(EMPLOYEE_ID, PERS_ACTN_CD, TITLE_CD, .keep_all = TRUE)
}
