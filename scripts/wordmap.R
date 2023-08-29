source("scripts/libraries.R")
source("scripts/vars.R")

# Read data
processed_data_path <-
  glue::glue("data/{data_shared_on}/appended_data_sheet.csv")

data_file <- readr::read_csv(processed_data_path)

# Filter data for selected wards and problem categories
# These are taken from this slide - "Priority wards across complaint categories"
wards_complaints_df <- data.frame(
  "ward_names" =
    c(
      "Saraspur",
      "Asarva",
      "Jamalpur",
      "Dariapur",
      "Asarva",
      "Kuber nagar",
      "Nava Vadaj",
      "Saraspur",
      "Danilimda",
      "Naranpura",
      "Paldi",
      "Dariapur"
    ),
  "problem" = c(
    rep("Drainage", 3),
    rep("Public lighting", 3),
    rep("Water Supply", 3),
    rep("Sanitation", 3)
  ),
  stringsAsFactors = FALSE
)

wards_complaints_df$ward_names <-
  stringr::str_to_lower(wards_complaints_df$ward_names)

for(i in 1:nrow(wards_complaints_df)) {
  ward_i <- wards_complaints_df$ward_names[[i]]
  problem_i <- wards_complaints_df$problem[[i]]
  ward_complaints <- data_file[data_file$ward == ward_i &
                                 data_file$new_category == problem_i,]
  ward_complaints <- ward_complaints[!is.na(ward_complaints$ward),]
  addr <- ward_complaints$cleaned_address
  addr_phrase <-
    stringr::str_split(addr, pattern = ",", simplify = FALSE)
  
  # Only consider first two words from each address
  addr_phrase_2 <- lapply(addr_phrase, function(vec)
    vec[1:2])
  
  addr_phrase_2 <- addr_phrase_2 %>% unlist() %>% str_trim()
  addr_phrase_2 <- addr_phrase_2[!addr_phrase_2 %in% c("", " ")]
  word_count <-
    addr_phrase_2 %>% table() %>% data.frame() %>% arrange(desc(Freq))
  names(word_count)[1] <- "phrase"
  word_with_numbers <-
    word_count$phrase[grepl("^[0-9]+", x = word_count$phrase)] %>% as.character() %>% unlist()
  word_count <-
    word_count[!word_count$phrase %in% word_with_numbers, ]
  word_count <-
    word_count[!word_count$phrase %in% c(
      ward_i,
      "North",
      "South",
      "Central",
      "East",
      "South West",
      "South East",
      "West",
      "Market",
      stringr::str_to_title(ward_i)
    ),]
  
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
      phrase,
      Freq,
      random.order = TRUE,
      colors = pal,
      max.words = 50
    ))
  
  # Close the graphics device
  dev.off()
  
}

