source("scripts/libraries.R")


# Merge all files ---------------------------------------------------------

base_file_path <- "data/20112023/appended_data_sheet.csv"
base_file <- readr::read_csv(base_file_path)
print(glue::glue("Total Rows - Base - {nrow(base_file)}"))
all_dates <- dir("data")
all_dates <- all_dates[!all_dates %in% c("archive","20112023","13112023","14082023","forDB")]

for(i in 1:length(all_dates)){
  
  current_folder <- all_dates[[i]]
  file_to_append_path <- glue::glue("data/{current_folder}/processed_data_sheet.csv")
  file_to_append <- readr::read_csv(file_to_append_path)
  file_to_append$week <- current_folder
  print(glue::glue("Total Rows - {nrow(file_to_append)}"))
  base_file <- dplyr::bind_rows(base_file, file_to_append)
}

print(glue::glue("Total Rows - {nrow(base_file)}"))
readr::write_csv(base_file, "data/forDB/processed_25112023.csv")

# To check which dates are present in the collated file
# Create a date vector
date_vec <-
  c(paste0(c(paste0("0", 1:9), 10:31), " ", c(
    rep("Aug", 31), rep("Sep", 31), rep("Oct", 31), rep("Nov", 18)
  ), " ", "2023"))

date_vec <- date_vec[!date_vec %in% c("31 Sep 2023")]

all_dates_file <- base_file$registration_date %>% unique()

dates_not_present <- date_vec[!date_vec %in% all_dates_file]


db_host <- "43.205.192.7"
db_port <- 5432
db_name <- "dvdrental"
db_user <- "apoorv"
db_password <- "aa-cdl"

con <- dbConnect(
  PostgreSQL(),
  dbname = db_name,
  host = db_host,
  port = db_port,
  user = db_user,
  password = db_password
)
