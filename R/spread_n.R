#' @title Spread any number of variables as new columns in a data.frame
#' @description This expands tidyr::spread() to take on any number of variables and spread them out all at once.
#' @param df data.frame
#' @param key The new spread-out column names will be taken from this specified column
#' @param value What values (i.e., data) should be filled in these new columns?
#' @param fill How should missing values be filled? Usually '0'.
#' @return A wider data.frame than the original.
#' @examples
#' require(tidyr)
#' require(dplyr)
#'
#' set.seed(100)
#'
#' df <- tibble( Dept = c(rep("DeptA", 2), rep("DeptB", 2)),
#'               Gender = rep(c("Male", "Female"), 2),
#'               Count = sample(1:10, 4, replace=T),
#'               Percent = runif(4, 20, 80) )
#'
#' df %>% spread_n( key = Gender, value = c(Count, Percent), fill = 0 )

# Import Specifications
#' @export
spread_n <- function(df, key, value, fill) {
    # quote key
    keyq <- rlang::enquo(key)
    # break value vector into quotes
    valueq <- rlang::enquo(value)
    s <- rlang::quos(!!valueq)
    df %>% tidyr::gather(variable, value, !!!s) %>%
        tidyr::unite(temp, !!keyq, variable) %>%
        tidyr::spread(temp, value, fill)
}
