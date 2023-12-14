source("scripts/libraries.R")
source("scripts/vars.R")


# Merge all files ---------------------------------------------------------

# base_file_path <- "data/20112023/appended_data_sheet.csv"
# base_file <- readr::read_csv(base_file_path)
# print(glue::glue("Total Rows - Base - {nrow(base_file)}"))
# all_dates <- dir("data")
# all_dates <- all_dates[!all_dates %in% c("archive","20112023","13112023","14082023","forDB")]

base_file <- c()
all_dates <- dir("data")
all_dates <- all_dates[!all_dates %in% c("archive","forDB","overall_word_counts_all_categories.csv")]

for(i in 1:length(all_dates)){
  
  current_folder <- all_dates[[i]]
  file_to_append_path <- glue::glue("data/{current_folder}/processed_data_sheet.csv")
  file_to_append <- readr::read_csv(file_to_append_path)
  file_to_append$week <- current_folder
  print(glue::glue("Total Rows - {nrow(file_to_append)}"))
  base_file <- dplyr::bind_rows(base_file, file_to_append)
}

print(glue::glue("Total Rows - {nrow(base_file)}"))

# To check which dates are present in the collated file
# Create a date vector
date_vec <-
  c(paste0(c(paste0("0", 1:9), 10:31), " ", c(
    rep("Aug", 31), rep("Sep", 31), rep("Oct", 31), rep("Nov", 18)
  ), " ", "2023"))

date_vec <- date_vec[!date_vec %in% c("31 Sep 2023")]
all_dates_file <- base_file$registration_date %>% unique()
dates_not_present <- date_vec[!date_vec %in% all_dates_file]

#Add current-previous week label to the dataset
base_file$week_label <- ""
base_file$week_label[base_file$week == "11122023"] <- "current"
base_file$week_label[base_file$week == "04122023"] <- "previous"

#Add problem subcategories (Recategorising problems)
problem_df <-
  googlesheets4::read_sheet(ss = new_categories_file_path, sheet = "renaming-complaint")

base_file <- left_join(base_file, problem_df, by=c("new_category","problem"))
base_file$problem_recat[is.na(base_file$problem_recat)] <- base_file$problem[is.na(base_file$problem_recat)]

readr::write_csv(base_file, "data/forDB/processed_12122023.csv")
