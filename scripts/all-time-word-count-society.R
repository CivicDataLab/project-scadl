source("scripts/libraries.R")
source("scripts/vars.R")

# Read data
processed_data_path <-
  glue::glue("data/forDB/processed_12122023.csv")

data_file <- readr::read_csv(processed_data_path)

all_wards <- data_file$ward %>% unique %>% sort()

problem_categories <- c("Drainage",
                        "Water Supply")

overall_word_count <- c()
for (w in 1:length(all_wards)) {
  selected_ward <- all_wards[[w]]
  print(selected_ward)
  ward_df <- data_file %>% filter(ward == selected_ward)
  for(category in 1:length(problem_categories)){
    complaints_df <- ward_df[ward_df$new_category==problem_categories[category],]
    ward_word_count <- get_word_count(complaints_df$cleaned_address)  
    ward_word_count <-
      ward_word_count[!ward_word_count$phrase %in% stringr::str_to_title(selected_ward),]
    ward_word_count$rank <- row_number(desc(ward_word_count$Freq))    
    ward_word_count$category <- problem_categories[category]
    ward_word_count$ward <- selected_ward
    ward_number <- complaints_df$ward_number %>% unique()
    ward_word_count$locality_ID <- paste0(ward_number,"_",1:nrow(ward_word_count))
    overall_word_count <-
      dplyr::bind_rows(overall_word_count, ward_word_count)
  }
}

names(overall_word_count) <-
  c("society",
    "totalComplaints",
    "rank",
    "category",
    "ward",
    "locality_ID")
overall_word_count <-
  overall_word_count[, c("ward",
                         "society",
                         "locality_ID",
                         "category",
                         "totalComplaints",
                         "rank")]


overall_word_count_drainage_df_path <-
  glue::glue("data/overall_word_counts_drainage_121223.csv")

overall_word_count_ws_df_path <-
  glue::glue("data/overall_word_counts_watersupply_121223.csv")


readr::write_csv(overall_word_count[overall_word_count$category=="Drainage",], overall_word_count_drainage_df_path)
readr::write_csv(overall_word_count[overall_word_count$category=="Water Supply",], overall_word_count_ws_df_path)

