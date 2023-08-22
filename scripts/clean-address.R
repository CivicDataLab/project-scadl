source("scripts/vars.R")
source("scripts/libraries.R")

# data_file <- googlesheets4::read_sheet(ss = data_url_aug_week_3)
data_file <- readr::read_csv("data/21082023/raw-data.csv")
# write_csv(data_file,"data/21082023/raw-data.csv")

#Assign a primary key
data_file$pid <- 1:nrow(data_file)

address_df <- data_file[,c("pid","Address")]

# Remove ID's where address is not available
address_df <- address_df[!is.na(address_df$Address),]
to_remove <- c("Ahmedabad", "Gujarat", "India")
pattern <- paste(to_remove, collapse = "|")

clean_address <- function(address_row){
  # sample(nrow(address_df),1)
  # address_row <- address_df$Address[[9]]
  detect_comma <- stringr::str_detect(address_row, pattern = ",")
  if(detect_comma) {
    add_split <-
      str_split(address_row, pattern = ",") %>%
      unlist() %>%
      stringr::str_trim() %>%
      stringr::str_to_title()
  } else {
    add_split <-
      str_split(address_row, pattern = " ") %>%
      unlist() %>%
      stringr::str_trim() %>%
      stringr::str_to_title()
  }
  matches <- grep(pattern, add_split, value = TRUE)
  add_split <- add_split[!add_split %in% matches]
  # print(add_split)
  add_merge <- paste0(add_split,collapse = ", ")
  return(add_merge)
}

address_df <-
  address_df %>%
  rowwise() %>%
  mutate(cleaned_address = clean_address(Address))

processed_data <-
  left_join(data_file, address_df[, c("pid", "cleaned_address")], by = "pid")

readr::write_csv(processed_data, "data/21082023/cleaned_address.csv")
