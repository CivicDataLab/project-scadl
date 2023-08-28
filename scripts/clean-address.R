update_address_col <- function(data_file){
  
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
    
    matches <- grep(pattern_to_remove, add_split, value = TRUE)
    add_split <- add_split[!add_split %in% matches]
    # print(add_split)
    add_merge <- paste0(add_split,collapse = ", ")
    return(add_merge)
  }
  
  # data_file <- raw_data_sub
  address_df <- data_file[,c("pid","address")]  
  # Remove ID's where address is not available
  address_df <- address_df[!is.na(address_df$address),]
  
  to_remove <- c("Ahmedabad", "Gujarat", "India")
  pattern_to_remove <- paste(to_remove, collapse = "|")

  address_df <-
    address_df %>%
    rowwise() %>%
    mutate(cleaned_address = clean_address(address))
  
  return(address_df)
}
