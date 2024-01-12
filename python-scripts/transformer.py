import os
import re
import pandas as pd

"Catch mappings that don't exist"


def main(week: str):
    df = pd.read_csv(os.getcwd() + "/complaints.csv")

    df = rename_headers(df)
    df = add_pid(df, week)
    df = add_new_category(df)
    df = add_cleaned_address(df)
    df = add_ward_number(df)
    df = add_week_and_week_label(df, week)
    df = add_problem_recat(df)

    # print(df)

    df.to_csv("output.csv", index=False)


def rename_headers(df):
    """
    Rename headers for the dataframe
    """

    df.columns = [
        'department',
        'zone',
        'ward',
        'complaint_number',
        'token_number',
        'registration_date',
        'registration_time',
        'mode_of_complaint',
        'registered_by_opr',
        'allocation_date',
        'allocation_time',
        'allocated_to',
        'sla_time',
        'sla_status',
        'complaint_status',
        'problem_category',
        'problem',
        'reported_by_citizen',
        'citizen_mobile',
        'citizen_remarks',
        'complaint_source',
        'address',
    ]

    return df


def add_pid(df, week):
    df.insert(loc=0, column="pid", value=f"{week}")

    df.index += 1

    df['pid'] = df['pid'] + "_" + df.index.values.astype(str)
    
    return df


def add_new_category(df):
    """
    Add new_category column
    """
    category_mapping_df = pd.read_csv(os.getcwd() + "/category-mapping.csv")
    category_mapping_df.drop(axis=1, columns="department", inplace=True)
    category_mapping_df.replace('\r', '', regex=True, inplace=True)

    category_mapping_dict = category_mapping_df.set_index('problem_category').to_dict()['new_category']

    df['new_category'] = df['problem_category']

    df.replace({"new_category": category_mapping_dict}, inplace=True)

    return df


def add_cleaned_address(df):
    """
    Add cleaned_address column
    """
    df['cleaned_address'] = df['address'].apply(clean_address)

    return df


def add_ward_number(df):
    """
    Add ward_number column
    """
    ward_mapping_df = pd.read_csv(os.getcwd() + "/ward-mapping.csv")

    ward_mapping_dict = ward_mapping_df.set_index('name').to_dict()['number']

    df['ward_number'] = df['ward'].apply(str.lower)

    df.replace({"ward_number": ward_mapping_dict}, inplace=True)

    return df


def add_week_and_week_label(df, week):
    """
    Add week and week_label column
    """
    df['week'] = week
    df['week_label'] = 'current'

    return df


def add_problem_recat(df):
    """
    Add problem_recat column
    """
    complaint_mapping_df = pd.read_csv(os.getcwd() + "/complaints-mapping.csv")
    complaint_mapping_df.drop(axis=1, columns="new_category", inplace=True)
    complaint_mapping_df.replace('\r', '', regex=True, inplace=True)

    complaint_mapping_dict = complaint_mapping_df.set_index('problem').to_dict()['problem_recat']

    df['problem_recat'] = df['problem']

    df.replace({"problem_recat": complaint_mapping_dict}, inplace=True)

    return df


def clean_address(address: str):
    """
    Cleans address string
    """
    if isinstance(address, float):
        return address
    
    address = address.strip().replace("\n", " ").replace("\r", " ")
    address.replace("Ahmedabad", "").replace("Gujarat", "").replace("India", "")

    address = re.sub("\d{6}", "", address)

    return address


if __name__ == "__main__":
    week = str(input("Please enter the week (DDMMYYYY): "))

    main(week)