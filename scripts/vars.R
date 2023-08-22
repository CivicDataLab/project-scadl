data_url_aug_week_3 <-
  "https://docs.google.com/spreadsheets/d/1GqbRt-30XR7BFYeRQXyh4AMVxLwxsSIMe_nDIRqgt5c/edit"

problem_df <- data.frame(
  stringsAsFactors = FALSE,
           Problem = c("Drainage- Choking Of Line",
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
                       "Smart Toilet-Non Availability of water"),
     Problem_recat = c("Choking","Manhole cover",
                       "Other","Public Toilet","No supply","Leakage",
                       "Low pressure","Pollution","Other","Bhuva","Other","Repair",
                       "D2D vehicle","Cleaning","Public toilets - Surroundings",
                       "Waste Burning","Spitting/Urinating",
                       "Debris not cleared","Public toilets - Cleaning",
                       "Clearing dead animals","Plastic waste","Clearing big dead animals",
                       "Smart toilet - automatic door",
                       "Smart toilet - water availability")
)