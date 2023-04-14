# This code should be run in a Python Worksheet in Snowflake
import snowflake.snowpark as snowpark
import pandas as pd

def main(session: snowpark.Session):

    # Create the data
    data = {
    'STATEMENT1': ['We', 'Love', 'Frosty', 'Friday'],
    'STATEMENT2': ['Python', 'Worksheets', 'Are', 'Cool']
    }

    # Create a pandas dataframe
    df = pd.DataFrame(data)

    # Use the create_dataframe a dataframe Snowflake can work with
    dataframe = session.create_dataframe(df)

    # Print a sample of the dataframe
    dataframe.show()

    # Return to Results tab
    return dataframe