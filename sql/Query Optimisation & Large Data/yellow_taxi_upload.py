import os
from dotenv import load_dotenv
import pandas as pd
from sqlalchemy import create_engine, text

load_dotenv()
DB_USER = os.getenv('DB_USER')
DB_PASSWORD = os.getenv('DB_PASSWORD')
DB_HOST =  os.getenv('DB_HOST')
DB_PORT = os.getenv('DB_PORT')
DB_NAME = os.getenv('DB_NAME')

parquet_file = '/Users/jackthootinsley/development/projects/sql-crash-course/datasets/nyc_yellow_taxi/yellow_tripdata_2025-01.parquet'
df = pd.read_parquet(parquet_file)


# Keep only key columns for query optimization practice:
# - VendorID: taxi company identifier
# - tpep_pickup_datetime / tpep_dropoff_datetime: timestamps for trip duration and time-based analysis
# - passenger_count: number of passengers, useful for filtering/grouping
# - trip_distance: numeric field for aggregations
# - payment_type: method of payment, useful for filtering/grouping
# - fare_amount, tip_amount, total_amount: core numeric fields for revenue calculations and aggregations
columns_to_keep = [
    'VendorID',
    'tpep_pickup_datetime',
    'tpep_dropoff_datetime',
    'passenger_count',
    'trip_distance',
    'payment_type',
    'fare_amount',
    'tip_amount',
    'total_amount'
]
df = df[columns_to_keep]

# Time to 1M rows 
df = df.head(1000000)

# Rename columns to lowercase to match Postgres table
df.columns = [c.lower() for c in df.columns]

engine = create_engine(f'postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}')

create_table_query = """
CREATE TABLE IF NOT EXISTS nyc_yellow_taxi_jan2025 (
    vendorid INT,
    tpep_pickup_datetime TIMESTAMP,
    tpep_dropoff_datetime TIMESTAMP,
    passenger_count INT,
    trip_distance FLOAT,
    payment_type INT,
    fare_amount FLOAT,
    tip_amount FLOAT,
    total_amount FLOAT
);
"""
with engine.connect() as conn:
    conn.execute(text(create_table_query))

# Insert data in chunks to avoid memory issues
chunksize = 50000
for i, chunk in enumerate(range(0, len(df), chunksize)):
    df_chunk = df.iloc[chunk:chunk+chunksize]
    df_chunk.to_sql('nyc_yellow_taxi_jan2025', engine, if_exists='append', index=False)
    print(f"Inserted rows {chunk} to {chunk + len(df_chunk)}")

print("All data successfully uploaded to Supabase!")

# output_file = 'yellow_taxi_2025_01_trimmed.csv'
# df.to_csv(output_file, index=False)
# print(f"Trimmed dataset saved to {output_file}")
