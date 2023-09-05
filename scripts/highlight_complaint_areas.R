source("scripts/libraries.R")
source("scripts/vars.R")

# Read data
processed_data_path <-
  glue::glue("data/{data_shared_on}/processed_data_sheet.csv")

data_file <- readr::read_csv(processed_data_path)

all_wards <- data_file$ward %>% unique %>% sort()

problem_categories <- c("Drainage",
                        "Public lighting",
                        "Sanitation",
                        "Water Supply")
overall_word_count <- c()
for(i in 1:length(problem_categories)) {
  problem_df <-
    data_file %>% filter(new_category == problem_categories[[i]])
  category_word_count <- c()
  for (w in 1:length(all_wards)) {
    selected_ward <- all_wards[[w]]
    ward_df <- problem_df %>% filter(ward == selected_ward)
    ward_word_count <- get_word_count(ward_df$cleaned_address)
    ward_word_count <-
      ward_word_count[!ward_word_count$phrase %in% stringr::str_to_title(selected_ward), ]
    ward_word_count$ward <- selected_ward
    category_word_count <-
      dplyr::bind_rows(category_word_count, ward_word_count)
  }
  
  category_word_count$new_category <- problem_categories[[i]]
  category_word_count <- category_word_count %>% arrange(desc(new_category, Freq))
  overall_word_count <-
    dplyr::bind_rows(overall_word_count, category_word_count)
}

overall_word_count_df_path <-
  glue::glue("data/{data_shared_on}/overall_word_counts.csv")
readr::write_csv(overall_word_count, overall_word_count_df_path)

