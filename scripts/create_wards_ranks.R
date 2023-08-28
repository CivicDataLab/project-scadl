source("scripts/libraries.R") # libraries
source("scripts/vars.R") # google sheet url

# Ranking Weights
pop_weight <- 0.7
area_weight <- 0.3

# Read ward population dataset
ward_pop <-
  googlesheets4::read_sheet(ss = ward_population_file_path, sheet = "WARD_POPULATION_AREA_DENSITY_2022")
ward_pop_cols <- c("WARD_NUM", "POP_2022", "area")
ward_pop <- ward_pop[!is.na(ward_pop$WARD_NUM),ward_pop_cols] %>% unique()

# Read weekly complaints data 
weekly_data_file_path <-
  glue::glue("data/{data_shared_on}/processed_data_sheet.csv")

complaints_data <- readr::read_csv(weekly_data_file_path)

# Aggregate complaints
complaints_data_stats <- complaints_data %>% group_by(ward_number,ward,new_category) %>% summarise(total_complaints = n())

# Merge population data
complaints_data_stats <-
  left_join(complaints_data_stats, ward_pop, by = c("ward_number" = "WARD_NUM"))

# Calculate ranking stats
complaints_data_stats <-
  complaints_data_stats %>% mutate(comp_per_pop = total_complaints / POP_2022,
                                   comp_per_area = total_complaints /
                                     area)
complaints_data_stats$total_score <-
  complaints_data_stats$comp_per_pop * pop_weight + complaints_data_stats$comp_per_area *
  area_weight

# Assign a rank for each ward - category combination
complaints_data_stats <-
  complaints_data_stats %>% 
  group_by(new_category) %>% 
  mutate(ward_rank = order(order(total_score,decreasing = TRUE)))


# Weekly ward rank file path 
ward_ranks_file_path <-
  glue::glue("data/{data_shared_on}/ward_ranks.csv")

# Write File
readr::write_csv(complaints_data_stats, ward_ranks_file_path)
