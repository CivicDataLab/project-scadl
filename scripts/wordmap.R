source("scripts/libraries.R")
source("scripts/vars.R")

data_file <- readr::read_csv("data/21082023/cleaned_address.csv")

#one ward, one category
wards_complaints_df <- data.frame(
  "ward_names" =
    c(
      "Saraspur",
      "Asarva",
      "Jamalpur",
      "Chandkheda Motera",
      "Lambha",
      "Behrampura"),
  "problem" = c(
    rep("Drainage", 3),
    rep("Water Supply", 3)  
    ),
  stringsAsFactors = FALSE
)

for(i in 1:nrow(wards_complaints_df)){
  
  ward_i <- wards_complaints_df$ward_names[[i]]
  problem_i <- wards_complaints_df$problem[[i]]
  ward_complaints <- data_file[data_file$Ward == ward_i &
                                 data_file$re_re_categ == problem_i, ]
  ward_complaints <- ward_complaints[!is.na(ward_complaints$Ward),] 
  addr <- ward_complaints$cleaned_address
  addr_phrase <-
    stringr::str_split(addr, pattern = ",", simplify = FALSE) 
  
  # Only consider first two words from each address
  addr_phrase_2 <- lapply(addr_phrase, function(vec) vec[1:2])
  
  addr_phrase_2 <- addr_phrase_2 %>% unlist() %>% str_trim()
  addr_phrase_2 <- addr_phrase_2[!addr_phrase_2 %in% c(""," ")]
  word_count <- addr_phrase_2 %>% table() %>% data.frame() %>% arrange(desc(Freq))
  names(word_count)[1] <- "phrase"
  word_with_numbers <-
    word_count$phrase[grepl("^[0-9]+", x = word_count$phrase)] %>% as.character() %>% unlist()
  word_count <- word_count[!word_count$phrase %in% word_with_numbers,]
  word_count <-
    word_count[!word_count$phrase %in% c(ward_i,
                                         "North",
                                         "South",
                                         "Central",
                                         "East",
                                         "South West",
                                         "South East",
                                         "West",
                                         "Market"), ]

  word_count$Freq <- word_count$Freq + 2^word_count$Freq
  pal <- brewer.pal(8,"Dark2")
  file_name <- glue::glue("{ward_i}_{stringr::str_replace(problem_i,' ','_')}.png") 
  viz_path <- glue::glue("viz/220823/wordcloud/{file_name}")
  
  # Set up the graphics device (PNG format in this case)
  png(viz_path, width = 800, height = 600,res = 150)
  
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

