# DHR CSS
dhr_style <- function( copy_to = getwd() ) {

    # Copy to the www folder if it exists
    if( dir.exists("www") ) {
        # copy the style to www folder
        copy_to <- normalizePath( paste0( copy_to, "/www") )
        invisible( file.copy(system.file("./data/paper.css", package = "DHRInternal") , copy_to) )
    } else {
        # copy the style to some folder specified by the user or working directory
        copy_to <- normalizePath(copy_to)
        invisible( file.copy(system.file("./data/paper.css", package = "DHRInternal") , copy_to) )
    }
}
