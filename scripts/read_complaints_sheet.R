source("scripts/vars.R")
source("scripts/libraries.R")

complaints_data <- googlesheets4::read_sheet(ss = data_url_aug_week_3)
readr::write_csv(complaints_data, "data/21082023/raw_data_sheet.csv")
