############################################################
## Frosty Friday Week 8
## https://frostyfriday.org/2022/08/05/week-8-basic/
############################################################

# Import packages
from configparser import ConfigParser
import streamlit as st
import pandas as pd
import snowflake.connector

# Read config file
config_sf = ConfigParser()
config_sf.sections()
config_sf.read('config_sf.ini')

# Assign connection parameters
sf_account = config_sf['Snowflake']['sf_account']
sf_user = config_sf['Snowflake']['sf_user']
sf_password = config_sf['Snowflake']['sf_password']
sf_warehouse = config_sf['Snowflake']['sf_warehouse']
sf_database = config_sf['Snowflake']['sf_database']
sf_schema = config_sf['Snowflake']['sf_schema']

# Credit to Atzmon Ben Binyamin for much of the logic below
# https://theinformationlab.nl/2022/10/19/streamlit-integration-in-snowflake/

# Connect to Snowflake
conn = snowflake.connector.connect (
    user = sf_user,
    password = sf_password,
    account = sf_account,
    warehouse = sf_warehouse,
    database = sf_database,
    schema = sf_schema
)

# Run SQL query
query = """
    select
        date_trunc('week', to_date(payment_date)) as payment_date,
        sum(amount_spent) as amount_per_week
    from ff_week_8
    group by 1;
    """

# Cache query
@st.cache

# Load data to dataframe
def load_data():
    cur = conn.cursor().execute(query)
    payments_df = pd.DataFrame.from_records(iter(cur), columns = [x[0] for x in cur.description])
    payments_df['PAYMENT_DATE'] = pd.to_datetime(payments_df['PAYMENT_DATE'])
    payments_df = payments_df.set_index('PAYMENT_DATE')
    return payments_df

# Load data
payments_df = load_data()

# Get min date
def get_min_date():
    return min(payments_df.index.to_list()).date()

# Get max date
def get_max_date():
    return max(payments_df.index.to_list()).date()

# Create app
def app_creation():
    # Title
    st.title('Payments in 2021')

    # Min date
    min_filter = st.slider('Select Min date',
                           min_value=get_min_date(),
                           max_value=get_max_date(),
                           value=get_min_date()
                           )
    
    # Max date
    max_filter = st.slider('Select Max date',
                           min_value=get_min_date(),
                           max_value=get_max_date(),
                           value=get_max_date()
                           )
    # Mask
    mask = (payments_df.index >= pd.to_datetime(min_filter)) & (payments_df.index <= pd.to_datetime(max_filter))

    # Filtered dataframe
    payments_df_filt = payments_df.loc[mask]

    # Line chart with filtered dataframe
    st.line_chart(payments_df_filt)

# Call the app creation function
app_creation()