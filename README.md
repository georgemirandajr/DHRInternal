# DHRInternal
Functions to help new DHR analysts get started with R

This package contains functions that:
 1. Provides CSS to use in all work products so that graphs and UI maintain the same look and feel.
 2. Provides DHR logos to use in work products.
 3. Provides specifications for importing datasets, which can also help you explore the fields that are available in all datasets.
 4. Provides a function that obtains the latest datasets on the LAC network. 

Install this package by running: `devtools::install_github("georgemirandajr/DHRInternal")`
Or find it on Dropbox at https://www.dropbox.com/sh/836uuknhvv2u2dj/AAA_ifobe--SZ-YofPzfxdCya?dl=0

## Style
Use `dhr_style()` to import a CSS file that has been used on other DHR work products. After using this function, you can always modify the CSS file to further improve the style of the work you are doing. The provided CSS file is simply meant to help you get started without having to think about the style too much right away.

 <pre><code>
 dhr_style()  # by default, it will copy the CSS to the www folder if it exists in your working directory
 
 dhr_style(copy_to = "my_folder")  # or you can specify where to copy it to
</code></pre>

## Logo
Use `dhr_logo()` to import the DHR logo into your project as a PNG file. There are currently two choices of logo: the "normal" logo (default) and the "pin" logo. This function works similarly to `dhr_style()`.

<pre><code>
 dhr_logo()  # by default, it will copy the PNG file the www folder if it exists in your working directory
 
 dhr_logo(copy_to = "my_folder")  # or you can specify where to copy it to
 
 dhr_logo(style = "normal")  # this is the default, but you can specify "pin" to get the other version of the logo
</code></pre>

## Data Sources
Use `dhr_data()` to specify a data extract and it will return the file path to the latest available data. You can then use this file path in other functions that will read the file. Note: this function will do a check to see if you have access to the shared folders where the data exists, which are currently the Advantage and WPTRA folders. In this current version, you must type certain file names in lower case and others in upper case. This will be changed and more standard in future versions of this package.

<pre><code>
Returns the file path to: 
dhr_data("jpact")  # JPACT file
dhr_data("title")  # title reference extract
dhr_data("vacancy")  # the vacancy reports
dhr_data("EmplDemogr")  # employee demographic extract 
</code></pre>

## Specifications
Use `import_specs()` to:
 1. Explore the possible tables and fields available in the data extracts
 2. Select the fields you want and pass the output of `import_specs()` to functions that can actually read in the data (examples below)

### Explore
<pre><code>
View( import_specs() )  # returns a large table with all the fields and their start/end positions and length.

unique( import_specs()$SpecName )  # returns a list of all available tables
</code></pre>

### Select Fields
<pre><code>
library(dplyr)  # requires dplyr to work

demo_specs <- import_specs("EmplDemogr")  # isolates the file specifications for the demographic extract and assigns it to demo_specs

# Or depending on how many fields there are and how many you need to drop or keep, you may use the keep or drop arguments.

demo_specs <- import_specs("EmplDemogr", keep = c("EmployeeID", "LastName"))  # if only keeping a couple of fields

demo_specs <- import_specs("EmplDemogr", drop = c("Prefix", "Suffix", "HomeDeptCode"))  # drops a few fields you may not need
</code></pre>

## Example of Putting It All Together

<pre><code>
jpact_specs <- DHRInternal::import_specs("JPACT",  # Identify the file specifications you want
                                           keep = c("EMPLOYEE_ID", "TITLE_CD", "SUB_TITLE_CD", "HOME_DEPT_CD", 
                                                    "EMPLMT_STA_CD", "EXPIRATION_DT", "PERS_ACTN_CD", "JOB_APPT_DT") )  

jpact_file <- dhr_data("JPACT")  # Obtain the file path to the current dataset

library(readr)  # a package to read in fixed width text files (all our extracts are this type) 
library(data.table)

jpact_data <- data.table::setDT(readr::read_fwf( jpact_file,  # the file path
                                              skip = 1,       # first row is metadata
                                              progress = FALSE,  # no need to print a progress bar to console
                                              col_types = paste( rep("c", length(jpact_specs$FieldName)), 
                                                                 collapse = "" ),
                                              fwf_positions(jpact_specs$Start,
                                                            jpact_specs$End,
                                                            col_names = jpact_specs$FieldName)))
</code></pre>
