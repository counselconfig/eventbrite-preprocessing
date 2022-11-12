
# EVENTBRITE DATA PROCESSING

# 1. please run the Model_citizens_v5 report in Eventbrite
# 2. save the file as .csv with filename "Attendee Summary Report (CSV)" in C:\MarketingData\Raw_Data\EventBrite\Data refreshes
# 3. run this script in order to import that file, keep the variables required only in the right format, and export it as tab delimited text file

# Make sure required packages are installed
list.of.packages <- c("openxlsx")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[, "Package"])]
if(length(new.packages)) install.packages(new.packages, repos = "http://cran.us.r-project.org")

library("openxlsx")

#setting: avoid scientific notation
options("scipen"=100, "digits"=4)

input_path <- "Y:\\ModelCitizenDataExtracts\\2018\\wired and eventbrite input\\"
output_path <- "Y:\\ModelCitizenDataExtracts\\2018\\wired and eventbrite\\"
input_filename <- "Attendee Summary Report (CSV).csv"
output_filename <- "Eventbrite_full_data.xlsx"

# 1. list variables to keep
# Note that spaces in column names are turned into '.' by R.
vars_to_keep <- c(
  "Event.Name"
  ,"Event.ID"
  ,"Order.no."
  ,"Order.Date"
  ,"Prefix"
  ,"First.Name"
  ,"Surname"
  ,"Email"
  ,"Quantity"
  ,"Ticket.Type"
  ,"Venue.Name"
  ,"Venue.No."
  ,"Organiser.Name"
  ,"Attendee.no."
  ,"Barcode.no."
  ,"Buyer.Surname"
  ,"Buyer.First.Name"
  ,"Buyer.Email"
  ,"Date.Attending"
  ,"Device.Name"
  ,"Check.In.Date"
  ,"Discount"
  ,"Hold"
  ,"Order.Type"
  ,"Total.Paid"
  ,"Eventbrite.Fees"
  ,"Eventbrite.Payment.Processing"
  ,"Attendee.Status"
  ,"Delivery.Method"
  ,"Home.Address.1"
  ,"Home.Address.2"
  ,"Home.City"
  ,"County.of.Residence"
  ,"Home.Postcode"
  ,"Home.Country"
  ,"Gender"
  ,"Age"
  ,"Birth.Date"
  ,"Would.you.like.to.receive.email.updates.from.The.National.Archives."
  ,"Would.you.like.to.receive.our.free.enewsletter.and.emails.about.news..products.and.services.from.The.National.Archives."
  ,"Join.our.mailing.list"
  ,"How.did.you.hear.about.this.event."
  ,"Billing.Address.1"
  ,"Billing.Address.2"
  ,"Billing.City"
  ,"Billing.State.Province.County"
  ,"Billing.Postcode"
  ,"Billing.Country"
)

# Sometimes columns change names, which break downstream processes
# This makes sure they're always called the same.
# If a name changes in the input file, change it above, but leave
# the list below as it is, to ensure that the name is correct
# when input into the downstream process.
new_names <- c(
  "Event.Name"
  ,"Event.ID"
  ,"Order.no."
  ,"Order.Date"
  ,"Prefix"
  ,"First.Name"
  ,"Surname"
  ,"Email"
  ,"Quantity"
  ,"Ticket.Type"
  ,"Venue.Name"
  ,"Venue.No."
  ,"Organiser.Name"
  ,"Attendee.no."
  ,"Barcode.no."
  ,"Buyer.Surname"
  ,"Buyer.First.Name"
  ,"Buyer.Email"
  ,"Date.Attending"
  ,"Device.Name"
  ,"Check.In.Date"
  ,"Discount"
  ,"Hold"
  ,"Order.Type"
  ,"Total.Paid"
  ,"Eventbrite.Fees"
  ,"Eventbrite.Payment.Processing"
  ,"Attendee.Status"
  ,"Delivery.Method"
  ,"Home.Address.1"
  ,"Home.Address.2"
  ,"Home.City"
  ,"County.of.Residence"
  ,"Home.Postcode"
  ,"Home.Country"
  ,"Gender"
  ,"Age"
  ,"Birth.Date"
  ,"Would.you.like.to.receive.email.updates.from.The.National.Archives."
  ,"Would.you.like.to.receive.our.free.enewsletter.and.emails.about.news..products.and.services.from.The.National.Archives."
  ,"Join.our.mailing.list"
  ,"How.did.you.hear.about.this.event."
  ,"Billing.Address.1"
  ,"Billing.Address.2"
  ,"Billing.City"
  ,"Billing.State.Province.County"
  ,"Billing.Postcode"
  ,"Billing.Country"
)

# 2. read data in
raw <- read.csv(paste0(input_path, input_filename),
                colClasses = "character")

# 3. Validate that we have all the columns
if(!setequal(intersect(vars_to_keep, names(raw)), vars_to_keep)) {
  missing = paste(setdiff(vars_to_keep, names(raw)), collapse=", ")
  stop(paste('Missing columns in ', input_filename, ':', missing, sep=" "))
}


# Helper function to replace \n with space
remove_newline <- function(x) {
  gsub("\n", " ", x)
}

# 4.  keep only variables required, and convert all newlines (\n) in data to space
to.import <- data.frame(lapply(raw[, names(raw) %in% vars_to_keep], remove_newline))

# 5. Set the column names to the expected values.
names(to.import) <- new_names

# 6.  export as tab delimited
# write.table(to.import,paste0(output_path, output_filename),sep="\t",row.names=FALSE, quote = FALSE, na= "")
write.xlsx(to.import,paste0(output_path, output_filename))


# 7.  check whether there are any fields that are not created for the export file
setdiff(vars_to_keep, names(to.import))



