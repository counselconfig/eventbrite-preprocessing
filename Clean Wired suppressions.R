######################################################################
######################################################################
######
######   SUPPRESSIONS
######
######################################################################
######################################################################

# Make sure required packages are installed
list.of.packages <- c("dplyr", "openxlsx")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[, "Package"])]
if(length(new.packages)) install.packages(new.packages, repos = "http://cran.us.r-project.org")

#setting: avoid scientific notation
options("scipen"=100, "digits"=4)
library("dplyr")
library("openxlsx")

input_path <- "Y:\\ModelCitizenDataExtracts\\2018\\wired and eventbrite input\\"
output_path <- "Y:\\ModelCitizenDataExtracts\\2018\\wired and eventbrite\\"
input_filename <- "Suppression-export.csv"
output_filename <- "Suppression-export_clean.xlsx"

suppression_raw <- read.csv(paste0(input_path, input_filename), colClasses = "character")

# variables to keep
# Note that spaces in column names are turned into '.' by R.
vars_to_keep_supp <- c("ï..Email"
                       ,"EmailType"
                       ,"DateRemoved"
                       ,"Status")

# Sometimes columns change names, which break downstream processes
# This makes sure they're always called the same.
# If a name changes in the input file, change it above, but leave
# the list below as it is, to ensure that the name is correct
# when input into the downstream process.
new_names <- c("ï..Email"
				,"EmailType"
				,"DateRemoved"
				,"Status")					   
# Validate columns
if(!setequal(intersect(vars_to_keep_supp, names(suppression_raw)), vars_to_keep_supp)) {
  missing = paste(setdiff(vars_to_keep_supp, names(suppression_raw)), collapse=", ")
  stop(paste('Missing columns in ', input_filename, ':', missing, sep=" "))
}



# 3.  keep only variables required
suppression <- suppression_raw[, names(suppression_raw) %in% vars_to_keep_supp]
# 4. Rename (if necessary) column names to the expected
names(suppression) <- new_names
# 5. Format DateRemoved correctly
suppression$DateRemoved <- as.Date(suppression$DateRemoved, "%d/%m/%Y")
# 6.  export as tab delimited
# write.table(suppression,paste0(suppression_export_path, "Suppression-export_clean.txt"),sep="\t",row.names=FALSE, quote = FALSE, na= "")
write.xlsx(suppression,paste0(output_path, output_filename))