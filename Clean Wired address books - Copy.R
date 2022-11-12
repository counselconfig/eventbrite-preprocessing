
# WIRED DATA PROCESSING

# 1. please follow the instruction on the SCV update document on how to download the address books from Wired
# 2. locate the files and moved them to the location as mentioend in the document
# 3. run this script in order to import that file, keep the variables required only in the right format, and export it as tab delimited text file

# Make sure required packages are installed
list.of.packages <- c("dplyr", "openxlsx")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[, "Package"])]
if(length(new.packages)) install.packages(new.packages, repos = "http://cran.us.r-project.org")

#setting: avoid scientific notation
options("scipen"=100, "digits"=4)
library("dplyr")
library("openxlsx")

input_path <- "J:\\BSS Team\\ModelCitizenDataExtracts\\2018\\wired and eventbrite input\\"
output_path <- "J:\\BSS Team\\ModelCitizenDataExtracts\\2018\\wired and eventbrite\\"

######################################################################
######################################################################
# 2. list variables to keep and list of variables to modify

# variables to keep
# Note that spaces in column names are turned into '.' by R.
vars_to_keep <- c("ï..DateCreated"
                  ,"DateModified"       
                  ,"Email"     
                  ,"EmailType"           
                  ,"OptInType"            
                  ,"Lastmaileddate"      
                  ,"LastOpenedDate"       
                  ,"X2014Clicks"          
                  ,"X2014Opens"           
                  ,"X2015Clicks"          
                  ,"X2015Opens"           
                  ,"X2016Archives"       
                  ,"X2016Bookshopclicks"  
                  ,"X2016Bookshopopens"   
                  ,"X2016Clicks"          
                  ,"X2016Fww"             
                  ,"X2016Govt"            
                  ,"X2016Images"         
                  ,"X2016Opens"           
                  ,"X2016Research"        
                  ,"X2016Whatsonclicks"   
                  ,"X2016Whatsonopens"    
                  ,"X2017Summerbookshop"  
                  ,"Australia"           
                  ,"Bouncecode"           
                  ,"Bouncestatus"         
                  ,"Bouncetype"           
                  ,"City"                 
                  ,"Companyname"          
                  ,"Country"             
                  ,"County"               
                  ,"Created"              
                  ,"Datesuppressed"       
                  ,"Distancetna"          
                  ,"Earliest_Source"      
                  ,"Educationmailinglist"
                  ,"Eventbrite"           
                  ,"Eventname"            
                  ,"Firstname"            
                  ,"Firstworldwar"        
                  ,"Fullname"             
                  ,"Gender"              
                  ,"Jobtitle"             
                  ,"L2y_Emails"           
                  ,"L2y_Engagement"       
                  ,"Lastname"             
                  ,"Lastsubscribed"       
                  ,"Localevent"          
                  ,"Marketing_Flag"       
                  ,"Marketing_Flg_Date"   
                  ,"Marketing_Flg_Date_2" 
                  ,"Marketing_Flg_Month"  
                  ,"Marketing_Flg_Source" 
                  ,"Market.Research"      
                  ,"Name"                 
                  ,"Organisation"         
                  ,"Origdatecreated"      
                  ,"Phonenumber"          
                  ,"Position"             
                  ,"Possiblesource"      
                  ,"Postcode"             
                  ,"Source"               
                  ,"Surname"              
                  ,"Telephone"            
                  ,"Testsept2016news"     
                  ,"Title"               
                  ,"Tnabooks"             
                  ,"Tna.News.Educ"          
                  ,"Twitter"              
                  ,"Unsubbed"             
                  ,"Volunteer"            
                  ,"Whatsoninterest")

# Sometimes columns change names, which break downstream processes
# This makes sure they're always called the same.
# If a name changes in the input file, change it above, but leave
# the list below as it is, to ensure that the name is correct
# when input into the downstream process.
new_names <- c("ï..DateCreated"
               ,"DateModified"       
               ,"Email"     
               ,"EmailType"           
               ,"OptInType"            
               ,"Lastmaileddate"      
               ,"LastOpenedDate"       
               ,"X2014Clicks"          
               ,"X2014Opens"           
               ,"X2015Clicks"          
               ,"X2015Opens"           
               ,"X2016Archives"       
               ,"X2016Bookshopclicks"  
               ,"X2016Bookshopopens"   
               ,"X2016Clicks"          
               ,"X2016Fww"             
               ,"X2016Govt"            
               ,"X2016Images"         
               ,"X2016Opens"           
               ,"X2016Research"        
               ,"X2016Whatsonclicks"   
               ,"X2016Whatsonopens"    
               ,"X2017Summerbookshop"  
               ,"Australia"           
               ,"Bouncecode"           
               ,"Bouncestatus"         
               ,"Bouncetype"           
               ,"City"                 
               ,"Companyname"          
               ,"Country"             
               ,"County"               
               ,"Created"              
               ,"Datesuppressed"       
               ,"Distancetna"          
               ,"Earliest_Source"      
               ,"Educationmailinglist"
               ,"Eventbrite"           
               ,"Eventname"            
               ,"Firstname"            
               ,"Firstworldwar"        
               ,"Fullname"             
               ,"Gender"              
               ,"Jobtitle"             
               ,"L2y_Emails"           
               ,"L2y_Engagement"       
               ,"Lastname"             
               ,"Lastsubscribed"       
               ,"Localevent"          
               ,"Marketing_Flag"       
               ,"Marketing_Flg_Date"   
               ,"Marketing_Flg_Date_2" 
               ,"Marketing_Flg_Month"  
               ,"Marketing_Flg_Source" 
               ,"Market-Research"      
               ,"Name"                 
               ,"Organisation"         
               ,"Origdatecreated"      
               ,"Phonenumber"          
               ,"Position"             
               ,"Possiblesource"      
               ,"Postcode"             
               ,"Source"               
               ,"Surname"              
               ,"Telephone"            
               ,"Testsept2016news"     
               ,"Title"               
               ,"Tnabooks"             
               ,"Tna-News-Educ"          
               ,"Twitter"              
               ,"Unsubbed"             
               ,"Volunteer"            
               ,"Whatsoninterest")

# the list of date variables that we need to only keep the date part
dt_var <- c("ï..DateCreated",
            "DateModified",
            "Lastmaileddate",
            "LastOpenedDate",
            "Created")

######################################################################
######################################################################
# 4. define odd term to serach

# the list of words you would like to search - TSD included capitalised versions
search_term <- c("http", "www","Http","HTTP","WWW","Www")

process_address_book <- function(input_filename, output_filename) {
  print(paste('Reading file:', input_filename))
  df_raw <- read.csv(paste0(input_path, input_filename), colClasses = "character")
  
  # Validate that we have all the columns
  if(!setequal(intersect(vars_to_keep, names(df_raw)), vars_to_keep)) {
    missing = paste(setdiff(vars_to_keep, names(df_raw)), collapse=", ")
    stop(paste0('Missing columns in ', input_filename, ':', missing, sep=" "))
  }
  
  
  df_tmp <- df_raw[, names(df_raw) %in% vars_to_keep]
  names(df_tmp) <- new_names

  print('Converting dates...')
  # to convert the 4 dates from datetime to date
  # Convert back to character, otherwise weird things happen when importing
  # Excel file into SQL Server.
  df_tmp[, dt_var] <- lapply(lapply(df_tmp[, dt_var], as.Date, "%d/%m/%Y"), as.character, '%d/%m/%Y')
  
  print('Finding odd words...')
  # create a new variable oddwords if the search terms exists in Firstname, Lastname, Fullname
  ## grepl("http|www", newsfromTna$Firstname)
  df_tmp$oddwords <- ifelse(grepl(paste(search_term, collapse = "|"), df_tmp$Firstname), 1, 
                            ifelse(grepl(paste(search_term, collapse = "|"), df_tmp$Lastname), 1 ,
                                   ifelse(grepl(paste(search_term, collapse = "|"), df_tmp$Name), 1 ,
                                          ifelse(grepl(paste(search_term, collapse = "|"), df_tmp$Surname), 1 ,
                                                 ifelse(grepl(paste(search_term, collapse = "|"), df_tmp$Organisation), 1 ,
                                                        ifelse(grepl(paste(search_term, collapse = "|"), df_tmp$Title), 1 ,
                                                               ifelse(grepl(paste(search_term, collapse = "|"), df_tmp$Fullname), 1, 0)))))))
  
  # only keep odd records and do count
  df_oddwordsonly <- df_tmp[df_tmp$oddwords == TRUE, c("Email", "Firstname", "Lastname", "ï..DateCreated")]
  df_oddwordsonly$domain_name <- gsub(".*@", "", df_oddwordsonly$Email)
  
  print('Preparing validation tables...')
  # count by date
  df_oddwordsonly %>% 
    group_by(ï..DateCreated) %>% 
    summarise(n = n()) %>% 
    print(n = 1000)
  
  # count by domain
  df_oddwordsonly %>% 
    group_by(domain_name) %>% 
    summarise(n = n()) %>% 
    print(n = 1000)
  
  print('Creating final data table...')
  # create the clean tables
  df <- df_tmp[df_tmp$oddwords == FALSE, names(df_tmp) %in% new_names]
  
  print('Cleaning up...')
  # remove the object that contains odd words
  rm(df_tmp)
  rm(df_raw)
  rm(df_oddwordsonly)
  
  # Write file
  # write.table(df,paste0(output_path, output_filename),sep="\t",row.names=FALSE, quote = FALSE, na= "")
  print('Writing file...')
  write.xlsx(df,paste0(output_path, output_filename))
}

process_address_book("Archives-sector-news.csv", "Archives-sector-news_clean.xlsx")
process_address_book("Digitisation-subscribers.csv", "Digitisation-subscribers_clean.xlsx")
process_address_book("First-World-War-100-portal.csv", "First-World-War-100-portal_clean.xlsx")
process_address_book("Image-library-signups.csv", "Image-library-signups_clean.xlsx")
process_address_book("News-from-The-National-Archives.csv", "News-from-The-National-Archives_clean.xlsx")
process_address_book("Research-news.csv", "Research-news_clean.xlsx")
process_address_book("SIRO-Update.csv", "SIRO-Update_clean.xlsx")
