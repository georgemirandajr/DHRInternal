#' @title Find the file path to the latest dataset
#' @description This allows the user to obtain the full file path to the latest data. This function only works on finding the most current data and does not work on finding older datasets.
#' @param data_source A single string (character) that relates to one of the specification names. This must match the specification name exactly.
#' @return A character string containing the full file path of the desired file, including the server name. This requires that the user has access to the shared drives on the network. This function utilizes the check_folder_access() function to ensure that the analyst has access to the data.
#' @examples
#' ## Not run:
#' require(dplyr)
#' require(stringr)
#' jpact_file <- dhr_data("JPACT")
#' jpact_file  # print the file path


# Data connections (sources)
#' @export
dhr_data <- function( data_source ) {

    # Check folder access
    if( !( check_folder_access("Advantage") & check_folder_access("WPTRA") ) )
        stop("You don't have access to one the following folders: Advantage, WPTRA")

    # Validate that the requested data source is available
    if( ! data_source %in% c("JPACT", "Title", "EmplJob", "Vacancy",
                             "TitleGroup", "PayPolicyRate",
                             "DetlPayEmployee", "DetlPayEarnings", "DetlPayDeductions",
                             "EmplBonus", "EmplDemogr", "EmplLeav", "Catg", "Evnt", "Dedt",
                             "Dpln", "PosnInfo", "DeptJobType", "LeaveProgRule", "LeavePolicy",
                             "PersonnelAction", "Subtitle", "UnionLocal", "FLSAProfile",
                             "Relationship", "Location", "SnbAcctn") )

        stop("That data source does not exist.
             Available data sources are: 'JPACT', 'Title', 'EmplJob', 'Vacancy', 'TitleGroup', 'PayPolicyRate',
             'DetlPayEmployee', 'DetlPayEarnings', 'DetlPayDeductions', 'EmplBonus', 'EmplDemogr',
             'EmplLeav', 'Catg', 'Evnt', 'Dedt', 'Dpln', 'PosnInfo', 'DeptJobType', 'LeaveProgRule',
             'LeavePolicy', 'PersonnelAction', 'Subtitle', 'UnionLocal', 'FLSAProfile', 'Relationship',
             'Location', 'SnbAcctn'")


    thisYr <- as.numeric( format( Sys.Date(), "%Y") ) # what year are we in now?

    if( data_source == "Title" ) {

        dirs <- list.dirs("//ISDOWFSV04.HOSTED.LAC.COM/D100SHARE/Advantage Data/Historical Extracts/", recursive = FALSE)

        # get last four characters of each directory
        dir_last <- substr(dirs, start = nchar(dirs)-3, nchar(dirs))

        # identify the directory that matches the year we are in and set it
        dir <- dirs[dir_last == thisYr]

        # list all the sub-directories
        dirs <- list.dirs(dir, recursive = FALSE)
        dir_info <- file.info(dirs)

        dir <- rownames( dir_info[ which(dir_info$ctime == max(dir_info$ctime) ), ] )

        title_file <- paste0(dir, "./References/TITLE_Reference_Extract.txt")

        return(title_file)

    } else if( data_source == "JPACT" ) {

        dirs <- list.dirs("//ISDOWFSV04.HOSTED.LAC.COM/D100SHARE/Advantage Data/Historical Extracts/", recursive = FALSE)

        # get last four characters of each directory
        dir_last <- substr(dirs, start = nchar(dirs)-3, nchar(dirs))

        # identify the directory that matches the year we are in and set it
        dir <- dirs[dir_last == thisYr]

        # list all the sub-directories
        dirs <- list.dirs(dir, recursive = FALSE)
        dir_info <- file.info(dirs)

        dir <- rownames( dir_info[ which(dir_info$ctime == max(dir_info$ctime) ), ] )

        jpact_file <- list.files(dir, pattern = "JPACT", full.names = TRUE)

        return(jpact_file)

    } else if( data_source == "EmplJob" ) {

        dirs <- list.dirs("//ISDOWFSV04.HOSTED.LAC.COM/D100SHARE/Advantage Data/Historical Extracts/", recursive = FALSE)

        # get last four characters of each directory
        dir_last <- substr(dirs, start = nchar(dirs)-3, nchar(dirs))

        # identify the directory that matches the year we are in and set it
        dir <- dirs[dir_last == thisYr]

        # list all the sub-directories
        dirs <- list.dirs(dir, recursive = FALSE)
        dir_info <- file.info(dirs)

        dir <- rownames( dir_info[ which(dir_info$ctime == max(dir_info$ctime) ), ] )

        job_file <- list.files(dir, pattern = "JOB", full.names = TRUE)

        return(job_file)

    } else if( data_source == "TitleGroup" ) {

        dirs <- list.dirs("//ISDOWFSV04.HOSTED.LAC.COM/D100SHARE/Advantage Data/Historical Extracts/", recursive = FALSE)

        # get last four characters of each directory
        dir_last <- substr(dirs, start = nchar(dirs)-3, nchar(dirs))

        # identify the directory that matches the year we are in and set it
        dir <- dirs[dir_last == thisYr]

        # list all the sub-directories
        dirs <- list.dirs(dir, recursive = FALSE)
        dir_info <- file.info(dirs)

        dir <- rownames( dir_info[ which(dir_info$ctime == max(dir_info$ctime) ), ] )

        title_group_file <- paste0(dir, "./References/TITLE_GROUP_Reference_Extract.txt")

        return(title_group_file)

    } else if( data_source == "PayPolicyRate" ) {

        dirs <- list.dirs("//ISDOWFSV04.HOSTED.LAC.COM/D100SHARE/Advantage Data/Historical Extracts/", recursive = FALSE)

        # get last four characters of each directory
        dir_last <- substr(dirs, start = nchar(dirs)-3, nchar(dirs))

        # identify the directory that matches the year we are in and set it
        dir <- dirs[dir_last == thisYr]

        # list all the sub-directories
        dirs <- list.dirs(dir, recursive = FALSE)
        dir_info <- file.info(dirs)

        dir <- rownames( dir_info[ which(dir_info$ctime == max(dir_info$ctime) ), ] )

        pprt_file <- paste0(dir, "./References/PAY_POLICY_RATE_Reference_Extract.txt")

        return(pprt_file)

    } else if( data_source == "Vacancy" ) {

        dirs <- list.dirs("//ISDOWFSV04.HOSTED.LAC.COM/D100SHARE/WPTRA/Recruitment & Workforce Reduction/Vacancy Reports/New Model (position control summary)/",
                          recursive = FALSE)

        # get last four characters of each directory
        dir_last <- substr(dirs, start = nchar(dirs)-3, nchar(dirs))

        # identify the directory that matches the year we are in and set it
        dir <- dirs[dir_last == thisYr]
        # setwd(dir)  # set the working directory to this most current directory

        # obtain the most recent vacancy report file
        vacancyFile <- max(list.files(dir))

        # Remove the double forward-slash with a single slash
        dir <- stringr::str_replace(dir, "//[0-9]", "/2")

        vacancyFile <- paste0(dir, "/", vacancyFile)

        return(vacancyFile)

    } else if (data_source == "DetlPayEmployee") {

        dirs <- list.dirs("//ISDOWFSV04.HOSTED.LAC.COM/D100SHARE/Advantage Data/Historical Extracts/", recursive = FALSE)

        # get last four characters of each directory
        dir_last <- substr(dirs, start = nchar(dirs)-3, nchar(dirs))

        # identify the directory that matches the year we are in and set it
        dir <- dirs[dir_last == thisYr]

        # list all the sub-directories
        dirs <- list.dirs(dir, recursive = FALSE)
        dir_info <- file.info(dirs)

        dir <- rownames( dir_info[ which(dir_info$ctime == max(dir_info$ctime) ), ] )

        file <- list.files(dir, pattern = "DETLPAY_EMPLOYEE", full.names = TRUE)

        return(file)

    } else if (data_source == "DetlPayEarnings") {

        dirs <- list.dirs("//ISDOWFSV04.HOSTED.LAC.COM/D100SHARE/Advantage Data/Historical Extracts/", recursive = FALSE)

        # get last four characters of each directory
        dir_last <- substr(dirs, start = nchar(dirs)-3, nchar(dirs))

        # identify the directory that matches the year we are in and set it
        dir <- dirs[dir_last == thisYr]

        # list all the sub-directories
        dirs <- list.dirs(dir, recursive = FALSE)
        dir_info <- file.info(dirs)

        dir <- rownames( dir_info[ which(dir_info$ctime == max(dir_info$ctime) ), ] )

        file <- list.files(dir, pattern = "DETLPAY_EARNINGSHOME", full.names = TRUE)

        return(file)

    }  else if (data_source == "DetlPayDeductions") {

        dirs <- list.dirs("//ISDOWFSV04.HOSTED.LAC.COM/D100SHARE/Advantage Data/Historical Extracts/", recursive = FALSE)

        # get last four characters of each directory
        dir_last <- substr(dirs, start = nchar(dirs)-3, nchar(dirs))

        # identify the directory that matches the year we are in and set it
        dir <- dirs[dir_last == thisYr]

        # list all the sub-directories
        dirs <- list.dirs(dir, recursive = FALSE)
        dir_info <- file.info(dirs)

        dir <- rownames( dir_info[ which(dir_info$ctime == max(dir_info$ctime) ), ] )

        file <- list.files(dir, pattern = "DETLPAY_DEDUCTION", full.names = TRUE)

        return(file)

    } else if (data_source == "EmplBonus") {

        dirs <- list.dirs("//ISDOWFSV04.HOSTED.LAC.COM/D100SHARE/Advantage Data/Historical Extracts/", recursive = FALSE)

        # get last four characters of each directory
        dir_last <- substr(dirs, start = nchar(dirs)-3, nchar(dirs))

        # identify the directory that matches the year we are in and set it
        dir <- dirs[dir_last == thisYr]

        # list all the sub-directories
        dirs <- list.dirs(dir, recursive = FALSE)
        dir_info <- file.info(dirs)

        dir <- rownames( dir_info[ which(dir_info$ctime == max(dir_info$ctime) ), ] )

        file <- list.files(dir, pattern = "EMPL_BONUS", full.names = TRUE)

        return(file)

    } else if (data_source == "EmplDemogr") {

        dirs <- list.dirs("//ISDOWFSV04.HOSTED.LAC.COM/D100SHARE/Advantage Data/Historical Extracts/", recursive = FALSE)

        # get last four characters of each directory
        dir_last <- substr(dirs, start = nchar(dirs)-3, nchar(dirs))

        # identify the directory that matches the year we are in and set it
        dir <- dirs[dir_last == thisYr]

        # list all the sub-directories
        dirs <- list.dirs(dir, recursive = FALSE)
        dir_info <- file.info(dirs)

        dir <- rownames( dir_info[ which(dir_info$ctime == max(dir_info$ctime) ), ] )

        file <- list.files(dir, pattern = "EMPL_DEMOGR", full.names = TRUE)

        return(file)

    } else if (data_source == "EmplLeav") {

        dirs <- list.dirs("//ISDOWFSV04.HOSTED.LAC.COM/D100SHARE/Advantage Data/Historical Extracts/", recursive = FALSE)

        # get last four characters of each directory
        dir_last <- substr(dirs, start = nchar(dirs)-3, nchar(dirs))

        # identify the directory that matches the year we are in and set it
        dir <- dirs[dir_last == thisYr]

        # list all the sub-directories
        dirs <- list.dirs(dir, recursive = FALSE)
        dir_info <- file.info(dirs)

        dir <- rownames( dir_info[ which(dir_info$ctime == max(dir_info$ctime) ), ] )

        file <- list.files(dir, pattern = "EMPL_LEAV", full.names = TRUE)

        return(file)

    } else if (data_source == "Catg") {

        dirs <- list.dirs("//ISDOWFSV04.HOSTED.LAC.COM/D100SHARE/Advantage Data/Historical Extracts/", recursive = FALSE)

        # get last four characters of each directory
        dir_last <- substr(dirs, start = nchar(dirs)-3, nchar(dirs))

        # identify the directory that matches the year we are in and set it
        dir <- dirs[dir_last == thisYr]

        # list all the sub-directories
        dirs <- list.dirs(dir, recursive = FALSE)
        dir_info <- file.info(dirs)

        dir <- rownames( dir_info[ which(dir_info$ctime == max(dir_info$ctime) ), ] )

        file <- paste0(dir, "./References/CATG_Reference_Extract.txt")

        return(file)

    } else if (data_source == "Evnt") {

        dirs <- list.dirs("//ISDOWFSV04.HOSTED.LAC.COM/D100SHARE/Advantage Data/Historical Extracts/", recursive = FALSE)

        # get last four characters of each directory
        dir_last <- substr(dirs, start = nchar(dirs)-3, nchar(dirs))

        # identify the directory that matches the year we are in and set it
        dir <- dirs[dir_last == thisYr]

        # list all the sub-directories
        dirs <- list.dirs(dir, recursive = FALSE)
        dir_info <- file.info(dirs)

        dir <- rownames( dir_info[ which(dir_info$ctime == max(dir_info$ctime) ), ] )

        file <- paste0(dir, "./References/EVNT_Reference_Extract.txt")

        return(file)

    } else if (data_source == "Dedt") {

        dirs <- list.dirs("//ISDOWFSV04.HOSTED.LAC.COM/D100SHARE/Advantage Data/Historical Extracts/", recursive = FALSE)

        # get last four characters of each directory
        dir_last <- substr(dirs, start = nchar(dirs)-3, nchar(dirs))

        # identify the directory that matches the year we are in and set it
        dir <- dirs[dir_last == thisYr]

        # list all the sub-directories
        dirs <- list.dirs(dir, recursive = FALSE)
        dir_info <- file.info(dirs)

        dir <- rownames( dir_info[ which(dir_info$ctime == max(dir_info$ctime) ), ] )

        file <- paste0(dir, "./References/DEDT_Reference_Extract.txt")

        return(file)

    } else if (data_source == "Dpln") {

        dirs <- list.dirs("//ISDOWFSV04.HOSTED.LAC.COM/D100SHARE/Advantage Data/Historical Extracts/", recursive = FALSE)

        # get last four characters of each directory
        dir_last <- substr(dirs, start = nchar(dirs)-3, nchar(dirs))

        # identify the directory that matches the year we are in and set it
        dir <- dirs[dir_last == thisYr]

        # list all the sub-directories
        dirs <- list.dirs(dir, recursive = FALSE)
        dir_info <- file.info(dirs)

        dir <- rownames( dir_info[ which(dir_info$ctime == max(dir_info$ctime) ), ] )

        file <- paste0(dir, "./References/DPLN_Reference_Extract.txt")

        return(file)

    } else if (data_source == "PosnInfo") {

        dirs <- list.dirs("//ISDOWFSV04.HOSTED.LAC.COM/D100SHARE/Advantage Data/Historical Extracts/", recursive = FALSE)

        # get last four characters of each directory
        dir_last <- substr(dirs, start = nchar(dirs)-3, nchar(dirs))

        # identify the directory that matches the year we are in and set it
        dir <- dirs[dir_last == thisYr]

        # list all the sub-directories
        dirs <- list.dirs(dir, recursive = FALSE)
        dir_info <- file.info(dirs)

        dir <- rownames( dir_info[ which(dir_info$ctime == max(dir_info$ctime) ), ] )

        file <- list.files(dir, pattern = "POSN_INFO", full.names = TRUE)

        return(file)

    } else if (data_source == "DeptJobType") {

        dirs <- list.dirs("//ISDOWFSV04.HOSTED.LAC.COM/D100SHARE/Advantage Data/Historical Extracts/", recursive = FALSE)

        # get last four characters of each directory
        dir_last <- substr(dirs, start = nchar(dirs)-3, nchar(dirs))

        # identify the directory that matches the year we are in and set it
        dir <- dirs[dir_last == thisYr]

        # list all the sub-directories
        dirs <- list.dirs(dir, recursive = FALSE)
        dir_info <- file.info(dirs)

        dir <- rownames( dir_info[ which(dir_info$ctime == max(dir_info$ctime) ), ] )

        file <- paste0(dir, "./References/DEPT_JOB_TYP_Reference_Extract.txt")

        return(file)

    } else if (data_source == "LeaveProgRule") {

        dirs <- list.dirs("//ISDOWFSV04.HOSTED.LAC.COM/D100SHARE/Advantage Data/Historical Extracts/", recursive = FALSE)

        # get last four characters of each directory
        dir_last <- substr(dirs, start = nchar(dirs)-3, nchar(dirs))

        # identify the directory that matches the year we are in and set it
        dir <- dirs[dir_last == thisYr]

        # list all the sub-directories
        dirs <- list.dirs(dir, recursive = FALSE)
        dir_info <- file.info(dirs)

        dir <- rownames( dir_info[ which(dir_info$ctime == max(dir_info$ctime) ), ] )

        file <- paste0(dir, "./References/LEAVE_PROG_RUL_Reference_Extract.txt")

        return(file)

    } else if (data_source == "LeavePolicy") {

        dirs <- list.dirs("//ISDOWFSV04.HOSTED.LAC.COM/D100SHARE/Advantage Data/Historical Extracts/", recursive = FALSE)

        # get last four characters of each directory
        dir_last <- substr(dirs, start = nchar(dirs)-3, nchar(dirs))

        # identify the directory that matches the year we are in and set it
        dir <- dirs[dir_last == thisYr]

        # list all the sub-directories
        dirs <- list.dirs(dir, recursive = FALSE)
        dir_info <- file.info(dirs)

        dir <- rownames( dir_info[ which(dir_info$ctime == max(dir_info$ctime) ), ] )

        file <- paste0(dir, "./References/LEAVE_POLICY_Reference_Extract.txt")

        return(file)

    } else if (data_source == "PersonnelAction") {

        dirs <- list.dirs("//ISDOWFSV04.HOSTED.LAC.COM/D100SHARE/Advantage Data/Historical Extracts/", recursive = FALSE)

        # get last four characters of each directory
        dir_last <- substr(dirs, start = nchar(dirs)-3, nchar(dirs))

        # identify the directory that matches the year we are in and set it
        dir <- dirs[dir_last == thisYr]

        # list all the sub-directories
        dirs <- list.dirs(dir, recursive = FALSE)
        dir_info <- file.info(dirs)

        dir <- rownames( dir_info[ which(dir_info$ctime == max(dir_info$ctime) ), ] )

        file <- paste0(dir, "./References/PERSONNEL_ACTION_Reference_Extract.txt")

        return(file)

    } else if (data_source == "Subtitle") {

        dirs <- list.dirs("//ISDOWFSV04.HOSTED.LAC.COM/D100SHARE/Advantage Data/Historical Extracts/", recursive = FALSE)

        # get last four characters of each directory
        dir_last <- substr(dirs, start = nchar(dirs)-3, nchar(dirs))

        # identify the directory that matches the year we are in and set it
        dir <- dirs[dir_last == thisYr]

        # list all the sub-directories
        dirs <- list.dirs(dir, recursive = FALSE)
        dir_info <- file.info(dirs)

        dir <- rownames( dir_info[ which(dir_info$ctime == max(dir_info$ctime) ), ] )

        file <- paste0(dir, "./References/SUB_TITLE_Reference_Extract.txt")

        return(file)

    } else if (data_source == "UnionLocal") {

        dirs <- list.dirs("//ISDOWFSV04.HOSTED.LAC.COM/D100SHARE/Advantage Data/Historical Extracts/", recursive = FALSE)

        # get last four characters of each directory
        dir_last <- substr(dirs, start = nchar(dirs)-3, nchar(dirs))

        # identify the directory that matches the year we are in and set it
        dir <- dirs[dir_last == thisYr]

        # list all the sub-directories
        dirs <- list.dirs(dir, recursive = FALSE)
        dir_info <- file.info(dirs)

        dir <- rownames( dir_info[ which(dir_info$ctime == max(dir_info$ctime) ), ] )

        file <- paste0(dir, "./References/UNION_LOCAL_Reference_Extract.txt")

        return(file)

    } else if (data_source == "FLSAProfile") {

        dirs <- list.dirs("//ISDOWFSV04.HOSTED.LAC.COM/D100SHARE/Advantage Data/Historical Extracts/", recursive = FALSE)

        # get last four characters of each directory
        dir_last <- substr(dirs, start = nchar(dirs)-3, nchar(dirs))

        # identify the directory that matches the year we are in and set it
        dir <- dirs[dir_last == thisYr]

        # list all the sub-directories
        dirs <- list.dirs(dir, recursive = FALSE)
        dir_info <- file.info(dirs)

        dir <- rownames( dir_info[ which(dir_info$ctime == max(dir_info$ctime) ), ] )

        file <- paste0(dir, "./References/FLSA_PROFILE_Reference_Extract.txt")

        return(file)

    } else if (data_source == "Relationship") {

        dirs <- list.dirs("//ISDOWFSV04.HOSTED.LAC.COM/D100SHARE/Advantage Data/Historical Extracts/", recursive = FALSE)

        # get last four characters of each directory
        dir_last <- substr(dirs, start = nchar(dirs)-3, nchar(dirs))

        # identify the directory that matches the year we are in and set it
        dir <- dirs[dir_last == thisYr]

        # list all the sub-directories
        dirs <- list.dirs(dir, recursive = FALSE)
        dir_info <- file.info(dirs)

        dir <- rownames( dir_info[ which(dir_info$ctime == max(dir_info$ctime) ), ] )

        file <- paste0(dir, "./References/RELATIONSHIP_Reference_Extract.txt")

        return(file)

    } else if (data_source == "Location") {

        dirs <- list.dirs("//ISDOWFSV04.HOSTED.LAC.COM/D100SHARE/Advantage Data/Historical Extracts/", recursive = FALSE)

        # get last four characters of each directory
        dir_last <- substr(dirs, start = nchar(dirs)-3, nchar(dirs))

        # identify the directory that matches the year we are in and set it
        dir <- dirs[dir_last == thisYr]

        # list all the sub-directories
        dirs <- list.dirs(dir, recursive = FALSE)
        dir_info <- file.info(dirs)

        dir <- rownames( dir_info[ which(dir_info$ctime == max(dir_info$ctime) ), ] )

        file <- paste0(dir, "./References/LOCATION_Reference_Extract.txt")

        return(file)

    } else if (data_source == "SnbAcctn") {

        dirs <- list.dirs("//ISDOWFSV04.HOSTED.LAC.COM/D100SHARE/Advantage Data/Historical Extracts/", recursive = FALSE)

        # get last four characters of each directory
        dir_last <- substr(dirs, start = nchar(dirs)-3, nchar(dirs))

        # identify the directory that matches the year we are in and set it
        dir <- dirs[dir_last == thisYr]

        # list all the sub-directories
        dirs <- list.dirs(dir, recursive = FALSE)
        dir_info <- file.info(dirs)

        dir <- rownames( dir_info[ which(dir_info$ctime == max(dir_info$ctime) ), ] )

        file <- list.files(dir, pattern = "SNBACCTN", full.names = TRUE)

        return(file)

    }

}
