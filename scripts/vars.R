
# This is the url of the latest data which we will receive from SCADL
# Will be updated every week

raw_data_url <-
  "https://docs.google.com/spreadsheets/d/1gK9i_2xt_fB3SvjcvJuIdw6UhOVdi8bdFaAzgmzr4pg/edit"

# This is the latest date on which the data was shared
data_shared_on <- "28082023"

# This is the date on which the previous data was shared
previous_data_shared_on <- "21082023"

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

problem_df <- data.frame(
  stringsAsFactors = FALSE,
           problem = c("Drainage- Choking Of Line",
                       "Drainage- Manhole Cover Missing","Drainage-Other",
                       "Drainage-Public Toilets and Urinals - Drainage Line Blockage or Choking","Water-No Supply",
                       "Water-Leakage In Main Line","Water-low  pressure","Water-Pollution In Supply",
                       "Water -Other","Road-Bhuva On Road","Road-Other",
                       "Road-Repair Require","SWM- Door-To-Door Vehicle Not Comming",
                       "SWM- Cleaning Not Done",
                       "SWM - Public Toilets and Urinals - Cleaning Out The Surroundings",
                       "SWM-Cleaning Burning Of Solid Wastes",
                       "SWM-Spitting Or Urinating at public place","SWM-Clearing Building Material Debris",
                       "SWM-Public Toilets and Urinals - Daily Cleaning Not Being Done",
                       "SWM-Clearing off the Dead Animals",
                       "Using Inferior Quality of Plastic for Tea/Pan/Water pouch/Other Food Throwing Plastic garbage/Waste",
                       "SWM-Clearing off the Big Dead Animals","Smart Toilet-Automatic Door is not working",
                       "Smart Toilet-Non Availability of water",
                       "Removal of waste-Dust Lying on both side of the road after re surfacing","Smart Toilet-Daily Cleaning not being done"),
     problem_recat = c("Choking","Manhole cover",
                       "Other","Public Toilet","No supply","Leakage",
                       "Low pressure","Pollution","Other","Bhuva","Other","Repair",
                       "D2D vehicle","Cleaning","Public toilets - Surroundings",
                       "Waste Burning","Spitting/Urinating",
                       "Debris not cleared","Public toilets - Cleaning",
                       "Clearing dead animals","Plastic waste","Clearing big dead animals",
                       "Smart toilet - Automatic Door",
                       "Smart toilet - Water Availability",
                       "Dust Removal","Smart Toilet - Daily Cleaning")
)
