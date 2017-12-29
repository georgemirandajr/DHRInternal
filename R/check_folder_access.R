# Check if user has access to Advantage and/or WPTRA folders

check_folder_access <- function(folder = "Advantage") {

    access <- FALSE  # assume no access

    if (folder == "Advantage") {
        access <- dir.exists("//ISDOWFSV04.HOSTED.LAC.COM/D100SHARE/Advantage Data")
    } else if (folder == "WPTRA") {
        access <- dir.exists("//ISDOWFSV04.HOSTED.LAC.COM/D100SHARE/WPTRA")
    }

    return(access)
}
