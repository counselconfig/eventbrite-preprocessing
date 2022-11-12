list.of.packages <- c("openxlsx", "plyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[, "Package"])]
if(length(new.packages)) install.packages(new.packages, repos = "http://cran.us.r-project.org")

library("openxlsx")
library("plyr")


input_path <- "Y:\\ModelCitizenDataExtracts\\2018\\wired and eventbrite input\\"
output_path <- "Y:\\ModelCitizenDataExtracts\\2018\\wired and eventbrite\\"
output_filename <- "survey_data_all.xlsx"

# Read all files called matching 'SurveyData*Q*.csv'. Note that pattern is a regular expression.
# For more info on regular expressions
survey.all <- ldply( .data = paste0(input_path,list.files(input_path,pattern="SurveyData.*Q.*\\.csv")),
                    .fun = read.csv,
                    header = TRUE)


# Helper function to remove single dashes
remove_dash <- function(x) {
  gsub("^-$", "", x)
}

# Convert all newlines (\n) in data to space
to.import <- data.frame(lapply(survey.all, remove_dash))

write.xlsx(to.import,paste0(output_path, output_filename))
