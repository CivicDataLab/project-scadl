source("scripts/libraries.R")
source("scripts/vars.R")

# Merge all files ---------------------------------------------------------
base_file <- c()
all_dates <- dir("data")
all_dates <- all_dates[!all_dates %in% c("archive","forDB","society-mapping","maps")]

for(i in 1:length(all_dates)){
  
  current_folder <- all_dates[[i]]
  file_to_append_path <- glue::glue("data/{current_folder}/processed_data_sheet.csv")
  file_to_append <- readr::read_csv(file_to_append_path)
  cols_s <- c("pid","token_number","ward","ward_number","cleaned_address") 
  file_to_append <- file_to_append[,cols_s]
  
  # Extract the first two phrases from the address
  
  addr_phrase <-
    stringr::str_split(file_to_append$cleaned_address, pattern = ",", simplify = FALSE)
  
  # Only consider first two words from each address
  addr_phrase_2 <- lapply(addr_phrase, function(vec)
    vec[1:2])
  
  # Save the two parts in two different columns
  file_to_append$addr_phrase_1 <- purrr::map_chr(addr_phrase_2,1) %>% stringr::str_trim() 
  file_to_append$addr_phrase_2 <- purrr::map_chr(addr_phrase_2,2) %>% stringr::str_trim()
  
  # file_to_append$week <- current_folder
  # print(glue::glue("Total Rows - {nrow(file_to_append)}"))
  base_file <- dplyr::bind_rows(base_file, file_to_append)
}

print(glue::glue("Total Rows - {nrow(base_file)}"))

# To check which dates are present in the collated file
# Create a date vector
# date_vec <-
#   c(paste0(c(paste0("0", 1:9), 10:31), " ", c(
#     rep("Aug", 31), rep("Sep", 31), rep("Oct", 31), rep("Nov", 18)
#   ), " ", "2023"))
# 
# date_vec <- date_vec[!date_vec %in% c("31 Sep 2023")]
# all_dates_file <- base_file$registration_date %>% unique()
# dates_not_present <- date_vec[!date_vec %in% all_dates_file]
# 
# #Add current-previous week label to the dataset
# base_file$week_label <- ""
# base_file$week_label[base_file$week == "11122023"] <- "current"
# base_file$week_label[base_file$week == "04122023"] <- "previous"

# #Add problem subcategories (Recategorising problems)
# problem_df <-
#   googlesheets4::read_sheet(ss = new_categories_file_path, sheet = "renaming-complaint")
# 
# base_file <- left_join(base_file, problem_df, by=c("new_category","problem"))
# base_file$problem_recat[is.na(base_file$problem_recat)] <- base_file$problem[is.na(base_file$problem_recat)]
# 
# readr::write_csv(base_file, "data/forDB/processed_12122023.csv")

society_coord <-
  readr::read_csv("data/forDB/society-wise-lat-lng.csv", col_types = cols())
society_coord <- society_coord[!society_coord$ward %in% c("1","2"),]
society_coord$phrase <- stringr::str_trim(society_coord$phrase)
society_coord$locality_id <- NULL
society_coord <- unique(society_coord)

# Consider only those localities where the frequency is greater than 3
society_coord <- society_coord[society_coord$freq > 3,]
# First join with addr_phrase_1
merged_file <-
  left_join(base_file,
            society_coord,
            by = c("ward" = "ward", "addr_phrase_1" = "phrase"))

merged_file$freq <- NULL

# Second join with addr_phrase_1

merged_file <-
  left_join(merged_file,
            society_coord,
            by = c("ward" = "ward", "addr_phrase_2" = "phrase"))

merged_file$freq <- NULL

# Calculate final lat lon
merged_file$lat <- ifelse(!is.na(merged_file$lat.x),merged_file$lat.x,merged_file$lat.y)
merged_file$lon <- ifelse(!is.na(merged_file$lon.x),merged_file$lon.x,merged_file$lon.y)

# Export file
cols_e <- c("pid","token_number","ward","ward_number","lat","lon","addr_phrase_1","addr_phrase_2")
x <- merged_file[!is.na(merged_file$lat),cols_e]
x$lat <- as.numeric(x$lat)
x$lon <- as.numeric(x$lon)
x <- x[!is.na(x$lat),]
readr::write_csv(x, path = "data/society-mapping/token_lat_lon.csv")
