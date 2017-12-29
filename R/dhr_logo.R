dhr_logo <- function( copy_to = getwd(), style = "normal" ) {

    # There are 2 styles currently available

    if(style == "normal") {
        style <- "./data/DHR_Logo.png"
    } else {
        style <- "./data/DHR_Logo_Pin.png"
    }

    # Copy to the www folder if it exists
    if( dir.exists("www") ) {
        # copy the style to www folder
        copy_to <- normalizePath( paste0( copy_to, "/www") )
        invisible( file.copy(system.file(style, package = "DHRInternal") , copy_to) )
    } else {
        # copy the style to some folder specified by the user
        copy_to <- normalizePath(copy_to)
        invisible( file.copy(system.file(style, package = "DHRInternal") , copy_to) )
    }

}
