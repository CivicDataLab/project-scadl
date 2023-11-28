source("scripts/libraries.R")
source("scripts/vars.R")

# Read data
processed_data_path <-
  glue::glue("data/{data_shared_on}/processed_data_sheet.csv")

data_file <- readr::read_csv(processed_data_path)

# Filter data for selected wards and problem categories
# These are taken from this slide - "Priority wards across complaint categories"
wards_complaints_df <- data.frame(
  "ward_names" =
    c(
      "Saraspur",
      "Asarva",
      "Bapu Nagar",
      "Dariapur",
      "Asarva",
      "Jamalpur",
      "Dariapur",
      "Vasna",
      "Saraspur",
      "Sardar Nagar",
      "Nava Vadaj",
      "Dariapur"),
  "problem" = c(
    rep("Drainage", 3),
    rep("Public lighting", 3),
    rep("Sanitation", 3),
    rep("Water Supply", 3)
  ),
  stringsAsFactors = FALSE
)

wards_complaints_df$ward_names <-
  stringr::str_to_lower(wards_complaints_df$ward_names)

# For storing word count values
word_count_df <- c()

for(i in 1:nrow(wards_complaints_df)) {
  ward_i <- wards_complaints_df$ward_names[[i]]
  problem_i <- wards_complaints_df$problem[[i]]
  ward_complaints <- data_file[data_file$ward == ward_i &
                                 data_file$new_category == problem_i,]
  ward_complaints <- ward_complaints[!is.na(ward_complaints$ward),]
  
  # Get word count
  word_count <- get_word_count(ward_complaints$cleaned_address)
  word_count <- word_count[!word_count$phrase %in% stringr::str_to_title(ward_i),]

  # Updating the word count data frame
  word_count$ward <- ward_i
  word_count$new_category <- problem_i
  word_count_df <- dplyr::bind_rows(word_count_df, word_count)
  
  word_count$Freq <- word_count$Freq + 2 ^ word_count$Freq
  pal <- brewer.pal(8, "Dark2")
  file_name <-
    glue::glue("{ward_i}_{stringr::str_replace(problem_i,' ','_')}.png")
  viz_path <- glue::glue("viz/{data_shared_on}/wordcloud/{file_name}")
  
  # Set up the graphics device (PNG format in this case)
  png(viz_path,
      width = 800,
      height = 600,
      res = 150)
  
  word_count %>%
    with(wordcloud(
      phrase,random.color = FALSE,rot.per = 0.1,min.freq = 2,
      Freq,
      random.order = FALSE,
      colors = pal,
      scale = c(2,0.4),
      max.words = 50
    ))
  
  # Close the graphics device
  dev.off()
  
}

word_count_df_path <- glue::glue("data/{data_shared_on}/word_counts.csv")
readr::write_csv(word_count_df, word_count_df_path)
