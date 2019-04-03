#' @title Filter a data.frame and find the average value of a group
#' @description This function allows users/analysts to apply an arbitrary list of filtering criteria and find the average of one column by a user-specified group. This function and other filtering functions in this package are based on the JPACT extract, which contains a few of the required column names (e.g., APPOINTMENT_ID, EMPLOYEE_ID).
#' @param df The data.frame to which the criteria list is applied.
#' @param mean_col The column to find apply the mean() function on. Should be of numeric or interger class.
#' @param grp The column that will be grouped and for which the mean() function will be applied.
#' @param filter_list A list of criteria.
#' @return A data.frame that has been filtered based on the provided criteria with new columns for the mean and count of the group.
#' @examples
#' ## Not run:
#' # Assign a named vector of dept codes and find the average current age by MAPP/Non-MAPP designation
#' my_depts <- c("AA", "AD", "AN", "AO", "AR", "AS", "AU", "AW", "BH", "BS", "CA", "CC", "CD", "CH", "CS", "DA", "FR", "HA", "HM", "HS", "IO", "IS", "ME", "MH", "MV", "NH", "PB", "PD", "PH", "PK", "PL", "PW", "RP", "RR", "SH", "SS", "TT")
#'
#' jpact %>%
#'    employee_average(Age_Current, MAPP, list(
#'        EXPIRATION_DT = c( mdy("12319999") ) ,
#'        HOME_DEPT_CD = my_depts,
#'        EMPLMT_STA_CD = c("A") ,
#'        SUB_TITLE_CD = c("A", "D", "L", "N")
#'    ))

#' @export
employee_average <- function(df, mean_col, grp, filter_list) {
    calc_var <- rlang::enquo(mean_col)
    grp_var <- rlang::enquo(grp)

    df %>%
        dplyr::filter( is.na(APPOINTMENT_ID) ) %>%  # make sure appt id is blank (primary job)
        dplyr::group_by(EMPLOYEE_ID) %>%
        dplyr::slice( c( n() ) ) %>%  # get last record of group
        dplyr::ungroup() %>%
        my_filter(filter_list) %>%
        dplyr::group_by(!!grp_var) %>%
        dplyr::summarise(Mean = mean(!!calc_var, na.rm = TRUE),
                  Count = n())
}
