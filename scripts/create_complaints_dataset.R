source("scripts/libraries.R") # libraries
source("scripts/vars.R") # google sheet url
source("scripts/clean-address.R") # cleaning addresses

# File Paths
previous_data_file_path <-
  glue::glue("data/{previous_data_shared_on}/processed_data_sheet.csv")

raw_data_file_path <-
  glue::glue("data/{data_shared_on}/raw_data_sheet.csv")

processed_data_file_path <-
  glue::glue("data/{data_shared_on}/processed_data_sheet.csv")

appended_data_file_path <-
  glue::glue("data/{data_shared_on}/appended_data_sheet.csv")

# Read from google sheet only if local file does not exists
if(!file.exists(raw_data_file_path)) {
  # Read data from google sheet
  complaints_data <-
    googlesheets4::read_sheet(ss = raw_data_url)
  
  # Write raw data. Use local data for processing.
  readr::write_csv(x = complaints_data, file = raw_data_file_path)
} 

# Steps to process the data are listed in this document - https://docs.google.com/document/d/1eG79o8wpZ0Woij5iBJGThBgmYcs3Mhq4DcG2ROfOhNk/edit

raw_data <- readr::read_csv(raw_data_file_path)


# For report created on 14112023, we had to remove complaints registered on 041123 since they
# were included in the previous report.
# For report created on 25092023, we had to remove complaints registered on 24092023 since they
# were included in the previous report.
# For report created on 25092023, no data was present for 17092023.

# raw_data <- raw_data[!raw_data$`Registration Date` %in% "04 Nov 2023",]



# Assign a primary key
raw_data$pid <- glue::glue("{data_shared_on}_{1:nrow(raw_data)}")

cols_to_keep <-
  c("pid",
    "Department",
    "Zone",
    "Ward",
    "Complaint No",
    "Token No",
    "Registration Date",
    "Registration Time",
    "Mode of Complaint",
    "Regestered By Opr",
    "Allocation Date",
    "Allocation Time",
    "Allocated To",
    "SLA Time",
    "SLA Status",
    "Complaint Status",
    "Problem Category",
    "Problem",
    "Reported By Citizen",
    "Citizen s Mobile No",
    "Citizen Remarks",
    "Complaint Source",
    "Address"
  )

# Remove empty cols and rename cols
raw_data_sub <- raw_data[,cols_to_keep]
names(raw_data_sub) <- c("pid","department", "zone", "ward", "complaint_number", "token_number", "registration_date", "registration_time", "mode_of_complaint", "registered_by_opr", "allocation_date", "allocation_time", "allocated_to", "sla_time", "sla_status", "complaint_status", "problem_category", "problem", "reported_by_citizen", "citizen_mobile", "citizen_remarks", "complaint_source", "address")


# Map new categories
new_categories <-
  googlesheets4::read_sheet(ss = new_categories_file_path)

raw_data_sub <-
  left_join(raw_data_sub,
            new_categories,
            by = c("department", "problem_category"))

# Remove the department - Night Round
raw_data_sub <-
  raw_data_sub[!raw_data_sub$department %in% "Night Round", ]

# Change all ward names to lower case
raw_data_sub$ward <-
  stringr::str_trim(str_to_lower(raw_data_sub$ward))

# Add ward numbers
raw_data_sub <- left_join(raw_data_sub, ward_numbers, by = c("ward"))

# Clean address col
update_address <- update_address_col(data_file = raw_data_sub)
update_address$address <- NULL
raw_data_sub <- left_join(raw_data_sub, update_address, by="pid")

# Create file for DB
raw_data_sub$week <- data_shared_on
raw_data_sub$week_label <- "current"

#Add problem subcategories (Recategorising problems)
problem_df <-
  googlesheets4::read_sheet(ss = new_categories_file_path, sheet = "renaming-complaint")

raw_data_sub <- left_join(raw_data_sub, problem_df, by=c("new_category","problem"))
raw_data_sub$problem_recat[is.na(raw_data_sub$problem_recat)] <- raw_data_sub$problem[is.na(raw_data_sub$problem_recat)]

# Write processed dataset
readr::write_csv(raw_data_sub, processed_data_file_path)

# Append processed data sheet of previous week
previous_week_data <- readr::read_csv(previous_data_file_path)

# Assign week
raw_data_sub$week <- "current"
previous_week_data$week <- "previous"

# Append files
appended_data <- dplyr::bind_rows(raw_data_sub, previous_week_data)

# Write appended dataset
readr::write_csv(appended_data, appended_data_file_path)
