#' @title The core filter function
#' @description This function is used by the other functions in this package to apply the filter criteria provided by the user/analyst.
#' @param df The data.frame to which the criteria list is applied.
#' @param filt_list A list of criteria.
#' @return This function returns a data.frame that has been filtered.


# Filter criteria
#' @export
my_filter <- function(df, filt_list){
cols = as.list(names(filt_list))
conds = filt_list
fp <- purrr::map2(cols, conds,
                  function(x, y) rlang::quo( (!!(as.name(x))) %in% !!y) )
dplyr::filter(df, !!!fp)
}
