source("scripts/libraries.R") # libraries
source("scripts/vars.R") # google sheet url

# Ranking Weights
pop_weight <- 0.7
area_weight <- 0.3

# Read ward population dataset
ward_pop <-
  googlesheets4::read_sheet(ss = ward_population_file_path, sheet = "WARD_POPULATION_AREA_DENSITY_2022")
ward_pop_cols <- c("Zone","WARD_NUM", "POP_2022", "area")
ward_pop <- ward_pop[!is.na(ward_pop$WARD_NUM),ward_pop_cols] %>% unique()

# Read weekly complaints data 
weekly_data_file_path <-
  glue::glue("data/{data_shared_on}/processed_data_sheet.csv")

complaints_data <- readr::read_csv(weekly_data_file_path)


# Assign ward ranks -------------------------------------------------------

# Aggregate complaints by ward
complaints_data_stats <- complaints_data %>% group_by(ward_number,ward,new_category) %>% summarise(total_complaints = n())

# Merge population data
complaints_data_stats <-
  left_join(complaints_data_stats, ward_pop, by = c("ward_number" = "WARD_NUM"))

# Calculate ranking stats
complaints_data_stats <-
  complaints_data_stats %>% mutate(
    pop_normalised = POP_2022 / 1000, # Normalise population col
    comp_per_pop = total_complaints / pop_normalised,
    comp_per_area = total_complaints /
      area
  )

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

# Assign zonal ranks ------------------------------------------------------

# Aggregate complaints by zone
zone_stats <-
  complaints_data %>% group_by(zone, new_category) %>% summarise(total_complaints = n())

# Calculate population and area for each zone
zone_pop_area <-
  ward_pop %>% group_by(Zone) %>% summarise(pop = sum(POP_2022),
                                            area = sum(area)) 

# Merge population data
zone_stats <- left_join(zone_stats, zone_pop_area, by=c("zone"="Zone"))

# Calculate ranking stats
zone_stats <-
  zone_stats %>% mutate(
    pop_normalised = pop / 100000, # Normalise population
    comp_per_pop = total_complaints / pop_normalised,
    comp_per_area = total_complaints /
      area
  )

zone_stats$total_score <-
  zone_stats$comp_per_pop * pop_weight + zone_stats$comp_per_area *
  area_weight

# Assign a rank for each ward - category combination
zone_stats <-
  zone_stats %>% 
  group_by(new_category) %>% 
  mutate(ward_rank = order(order(total_score,decreasing = TRUE)))

# Weekly zone rank file path 
zone_ranks_file_path <-
  glue::glue("data/{data_shared_on}/zone_ranks.csv")

# Write File
readr::write_csv(zone_stats, zone_ranks_file_path)
