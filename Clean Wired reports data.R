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
input_filename <- "Reporting-summaries-export.csv"
output_filename <- "Reporting-summaries-export.xlsx"

df <- read.csv(paste0(input_path, input_filename), colClasses="character")

# variables to keep
# Note that spaces in column names are turned into '.' by R.
columns_to_keep <- c(
  "ï..DateSent",
  "CampaignName",
  "NumTotalSent",
  "NumTotalDelivered",
  "PercentageDelivered",
  "NumTotalUniqueOpens",
  "PercentageUniqueOpens",
  "NumTotalUsersClicked",
  "NumTotalSoftBounces",
  "NumTotalUnsubscribes",
  "PercentageUnsubscribes",
  "NumTotalUniqueClicks",
  "PercentageUniqueClicks",
  "PercentageUniqueClicksToOpens"
)

# Sometimes columns change names, which break downstream processes
# This makes sure they're always called the same.
# If a name changes in the input file, change it above, but leave
# the list below as it is, to ensure that the name is correct
# when input into the downstream process.
column_names <- c(
  "DateSent",
  "CampaignName",
  "NumTotalSent",
  "NumTotalDelivered",
  "PercentageDelivered",
  "NumTotalUniqueOpens",
  "PercentageUniqueOpens",
  "NumTotalUsersClicked",
  "NumTotalSoftBounces",
  "NumTotalUnsubscribes",
  "PercentageUnsubscribes",
  "NumTotalUniqueClicks",
  "PercentageUniqueClicks",
  "PercentageUniqueClicksToOpens"
)

# Validate columns
if(!setequal(intersect(columns_to_keep, names(df)), columns_to_keep)) {
  missing = paste(setdiff(columns_to_keep, names(df)), collapse=", ")
  stop(paste('Missing columns in ', input_filename, ':', missing, sep=" "))
}

# Rename columns
df <- df[columns_to_keep]
names(df) <- column_names

# Make sure counts are numeric, makes importing to SQL easier
df$NumTotalSent <- as.numeric(df$NumTotalSent)
df$NumTotalDelivered <- as.numeric(df$NumTotalDelivered)
df$PercentageDelivered <- as.numeric(df$PercentageDelivered)
df$NumTotalUniqueOpens <- as.numeric(df$NumTotalUniqueOpens)
df$PercentageUniqueOpens <- as.numeric(df$PercentageUniqueOpens)
df$NumTotalUsersClicked <- as.numeric(df$NumTotalUsersClicked)
df$NumTotalSoftBounces <- as.numeric(df$NumTotalSoftBounces)
df$NumTotalUnsubscribes <- as.numeric(df$NumTotalUnsubscribes)
df$PercentageUnsubscribes <- as.numeric(df$PercentageUnsubscribes)
df$NumTotalUniqueClicks <- as.numeric(df$NumTotalUniqueClicks)
df$PercentageUniqueClicks <- as.numeric(df$PercentageUniqueClicks)
df$PercentageUniqueClicksToOpens <- as.numeric(df$PercentageUniqueClicksToOpens)

print('Writing file...')
write.xlsx(df,paste0(output_path, output_filename))

