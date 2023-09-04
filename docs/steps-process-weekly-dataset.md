
## Steps to process weekly complaints dataset

1. Create a folder for weekly analysis [here](https://drive.google.com/drive/folders/1hzE2N2INWBORahB7BVcPwdihEOTUr_Tn?usp=drive_link)
2. The raw data shared by SCADL will be in this [folder](https://drive.google.com/drive/folders/1GleIN63dNW5VqsRqWslEi0ozch_ydEu7?usp=drive_link). Create a google sheet for the latest data and move it in the weekly analysis folder. 
3. Delete the first 6 rows (with logo and other extra details) in the google sheet. 
4. Create a new folder in the data directory. Rename the folder to the current data on which the data was shared. E.g `04092023`
5. In the [vars](../scripts/vars.R) script, update these variables:
    1. `raw_data_url`
    2. `data_shared_on`
    3. `previous_data_shared_on`
6. When updating the new categories, check for any NAs in the dataset 
`(raw_data_sub[,c("department", "problem_category", "new_category")] %>% unique %>% View)`. In case there are any NA values, update the [new categories sheet](https://docs.google.com/spreadsheets/d/19LNgYOz4J3m41qP-3yNV_tJyWgW_vZLzqFeTYE8FhIo/edit#gid=563389144)
7. After running the [create_complaints_dataset.R](../scripts/create_complaints_dataset.R), the data folder will have three csv files - `raw_data_sheet`, `processed_data_sheet` & `appended_data_sheet`
8. Upload the `appended_data_sheet` on google drive in the weekly analysis folder

## Steps to calculate ward ranks from complaints dataset

1. Run [create_ward_ranks.R](../scripts/create_ward_ranks.R)
2. This will create two csv files in the data folder- `ward_ranks` and `zone_ranks`
3. Upload both files on google drive in the weekly analysis folder