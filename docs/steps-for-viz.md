
## Steps for viz

1. Create a new folder under the [viz](../viz/) folder
2. Rename the folder as per the `data_shared_on` value (Same as in the [vars](../scripts/vars.R script))
3. Within this folder, create two sub folders `weekly-complaints-bar` and `wordcloud`
4. Run the [complaints_facet.R](../scripts/complaints_facet.R) script for generating weekly horizontal bar plots
    1. After merging the file with [new problem categories file](https://docs.google.com/spreadsheets/d/19LNgYOz4J3m41qP-3yNV_tJyWgW_vZLzqFeTYE8FhIo/edit#gid=1690690537), check if there are any NA values. Run this script - `View(data[,c("new_category","problem", "problem_recat")] %>% unique())`
    2. In case of any NA values, update the file and run the script again
    3. Create a PR to commit and push all the graphs
    4. Merge with main
5. Run the [wordmap.R](../scripts/wordmap.R) script for creating word clouds
    1. Update the `wards_complaints_df` as per the analysis
    2. Create a PR to commit and push all the graphs
    3. Merge with main
    4. Upload the word count on google drive in the weekly analysis folder
