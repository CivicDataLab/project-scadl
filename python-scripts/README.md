# Python Scripts For SCADL Dashboard


This folder contains the python scripts for the SCADL dashboard. There are two scripts:
- **`transformer.py`:** This script takes the excel file and tranforms it in to the required format
- **`upload.py`:** This script takes the final converted file and upload it to the server and loads the data in to the database

The scripts are supposed to run in `transformer.py -> upload.py` this order


## Folder Structure
- **`category-mapping.csv`:** This file contains mapping for all the categories to new categories
- **`complaints-mapping.csv`:** This file contains mapping for all complaints problem to new problem 
- **`ward-mapping.csv`:** This file containts mapping for all wards to ward numbers


## Todo
- [] Update code to catch mappings for category, complaints and ward that don't exist in the `category-mapping.csv`, `complaints-mapping.csv` and `ward-mapping.csv` files
- [] Automate the ingestion part to use just the google drive link of the excel