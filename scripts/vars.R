
# This is the url of the latest data which we will receive from SCADL
# Will be updated every week

raw_data_url <-
  "https://docs.google.com/spreadsheets/d/1NtQdU-HD5g4M-jednRcATAZLd89DjsJtQ6wPKCmv99s/edit#gid=487471307"

# This is the latest date on which the data was shared
data_shared_on <- "25122023"

# This is the date on which the previous data was shared
previous_data_shared_on <- "18122023"

# This is the date on which the previous data was shared
data_in_db_till_date <- "18122023"


new_categories_file_path <-
  "https://docs.google.com/spreadsheets/d/19LNgYOz4J3m41qP-3yNV_tJyWgW_vZLzqFeTYE8FhIo/edit" 

ward_population_file_path <-
  "https://docs.google.com/spreadsheets/d/1HfgnIr1TJzDlFRpe2nDIsctiMS2fVjMuiGIyjo22mTY/edit"

ward_numbers <- data.frame(
  stringsAsFactors = FALSE,
                              ward = c("ASARVA","JAMALPUR","SARASPUR",
                                       "BAPU NAGAR","KHADIA","DARIAPUR",
                                       "SAIJPUR BOGHA","AMRAIWADI","SHAHPUR","MANINAGAR",
                                       "DANILIMDA","KUBER NAGAR",
                                       "BHAIPURA HATKESHWAR","SHAHIBAUG",
                                       "THAKKARBAPA NAGAR","SP STADIUM","NAVA VADAJ",
                                       "INDIA COLONY","VIRAT NAGAR","GOMTIPUR",
                                       "VASNA","INDRAPURI","SARDAR NAGAR","ISANPUR",
                                       "NAVRANGPURA","BEHRAMPURA",
                                       "NARANPURA","PALDI","ODHAV","KHOKHRA","NARODA",
                                       "VATVA","NIKOL","SABARMATI",
                                       "VEJALPUR","CHANDKHEDA MOTERA","RANIP",
                                       "JODHPUR","THALTEJ","LAMBHA","VASTRAL",
                                       "SARKHEJ","BODAKDEV","MAKTAMPURA","GOTA",
                                       "RAMOL HATHIJAN","GHATLODIYA",
                                       "CHANDLODIYA"),
                          ward_number = c(15L,29L,27L,26L,28L,21L,13L,39L,
                                       17L,37L,36L,14L,43L,16L,23L,10L,
                                       6L,22L,25L,38L,31L,42L,11L,45L,18L,
                                       35L,9L,30L,40L,44L,12L,47L,24L,
                                       4L,32L,3L,5L,20L,8L,46L,41L,33L,
                                       19L,34L,1L,48L,7L,2L)
                )

ward_numbers$ward <-
  stringr::str_trim(str_to_lower(ward_numbers$ward))

get_word_count <- function(complaint_address){
  addr <- complaint_address
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
      "North",
      "South",
      "Central",
      "East",
      "South West",
      "South East",
      "West",
      "Market"
    ),]

  return(word_count)
}
