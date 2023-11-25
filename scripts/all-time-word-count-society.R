source("scripts/libraries.R")
source("scripts/vars.R")

# Read data
processed_data_path <-
  glue::glue("data/forDB/processed_25112023.csv")

data_file <- readr::read_csv(processed_data_path)

all_wards <- data_file$ward %>% unique %>% sort()

# problem_categories <- c("Drainage",
#                         "Public lighting",
#                         "Sanitation",
#                         "Water Supply")

overall_word_count <- c()
for (w in 1:length(all_wards)) {
  selected_ward <- all_wards[[w]]
  print(selected_ward)
  ward_df <- data_file %>% filter(ward == selected_ward)
  ward_word_count <- get_word_count(ward_df$cleaned_address)
  ward_word_count <-
    ward_word_count[!ward_word_count$phrase %in% stringr::str_to_title(selected_ward),]
  ward_word_count$ward <- selected_ward
  overall_word_count <-
    dplyr::bind_rows(overall_word_count, ward_word_count)
}

overall_word_count_df_path <-
  glue::glue("data/overall_word_counts_all_categories.csv")
readr::write_csv(overall_word_count, overall_word_count_df_path)

