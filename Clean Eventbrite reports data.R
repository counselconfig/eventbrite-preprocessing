# Make sure required packages are installed
list.of.packages <- c("dplyr", "openxlsx", "chron")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[, "Package"])]
if(length(new.packages)) install.packages(new.packages, repos = "http://cran.us.r-project.org")

#setting: avoid scientific notation
options("scipen"=100, "digits"=4)
library("dplyr")
library("openxlsx")
library("chron")

input_path <- "Y:\\ModelCitizenDataExtracts\\2018\\wired and eventbrite input\\"
output_path <- "Y:\\ModelCitizenDataExtracts\\2018\\wired and eventbrite\\"
input_filename <- "MyEvents.csv"
output_filename <- "MyEvents.xlsx"

# variables to keep
# Note that spaces in column names are turned into '.' by R.
columns_to_keep <- c(
  "Event",
  "Date",
  "Status",
  "Tickets.Sold",
  "Tickets.Available"
)

# Sometimes columns change names, which break downstream processes
# This makes sure they're always called the same.
# If a name changes in the input file, change it above, but leave
# the list below as it is, to ensure that the name is correct
# when input into the downstream process.
column_names <- c(
  "Event",
  "Date",
  "Status",
  "TicketsSold",
  "TicketsAvailable"
)

# Read data
df <- read.csv(paste0(input_path, input_filename), colClasses = "character")

# Validate columns
if(!setequal(intersect(columns_to_keep, names(df)), columns_to_keep)) {
  missing = paste(setdiff(columns_to_keep, names(df)), collapse=", ")
  stop(paste('Missing columns in ', input_filename, ':', missing, sep=" "))
}

# Rename columns
df <- df[columns_to_keep]
names(df) <- column_names

# Helper function to replace \n with space
remove_newline <- function(x) {
  gsub("\n", " ", x)
}

# Remove newlines from event name
df$Event <- lapply(df$Event, remove_newline)


# Clear 'Repeating Event' from Date
df$Date[df$Date == 'Repeating Event'] <- ''

# Reformat date to YYYY-MM-DD HH:MM.
df$Date <- format(
  as.chron(df$Date, format='%d %b %Y %H:%M'),
  '%d/%m/%Y %H:%M')

# Make sure counts are numeric
df$TicketsSold <- as.numeric(df$TicketsSold)
df$TicketsAvailable <- as.numeric(df$TicketsAvailable)

print('Writing file...')
write.xlsx(df,paste0(output_path, output_filename))
