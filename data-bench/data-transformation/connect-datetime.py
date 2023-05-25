# Python script to convert the times in stop_times from xsd:time to 
# xsd:dateTime, setting the time and date in ISO standard format
import datetime
import pandas as pd

# Read calendar_dates to dataframe and drop exception_type column
calendar_dates_df = pd.read_csv('/home/thomas/data-bench/nmbs-gtfs\
                                /calendar_dates.csv')
calendar_dates_df = calendar_dates_df.drop('exception_type', axis=1)

# List of columns that we do not need to connect both dataframes
trip_column_list = ['route_id', 'trip_headsign', 'trip_short_name', \
                    'direction_id', 'block_id', 'shape_id', 'trip_type']
# Read trips to dataframe and drop list of columns
trips_df = pd.read_csv('/home/thomas/data-bench/nmbs-gtfs/trips.csv')
trips_df = trips_df.drop(trip_column_list, axis=1)

# Read stop_times to dataframe
stop_times_df = pd.read_csv('/home/thomas/data-bench/nmbs-gtfs\
                            /stop_times.csv')

def checkmidnight(time):
    hour, minute, second = map(int, time.split(":"))
    if hour >= 24:
        hour = hour % 24
        time = f"{hour:02d}:{minute:02d}:{second:02d}"
    return time

# Remove the rows with departure_time above 23:59:59
stop_times_df = stop_times_df[stop_times_df['departure_time'] \
                              <= '23:59:59']
# stop_times_df['departure_time'] = stop_times_df['departure_time'].apply(lambda x: checkmidnight(x))

# Merge calendar_dates_df and trips_df on the service_id column
merged_serviceid_df = pd.merge(calendar_dates_df, trips_df, \
                               on='service_id')

# Merge trips_df and stop_times_df on trip_id
merged_tripid_df = pd.merge(merged_serviceid_df, stop_times_df, \
                            on='trip_id')

# Create a ISO timestamp from the rows date and departure_time
def dateToISO(row):
    return datetime.datetime.strptime(str(row['date'])+row['departure_time'],\
                                       '%Y%m%d%H:%M:%S').isoformat()

# Replace the time value with a ISO timestamp
merged_tripid_df['departure_time'] = \
    merged_tripid_df.apply(lambda row: dateToISO(row), axis=1)

# Drop service_id and date from the dataframe to be left with the
# original columns of stop_times.csv
column_list_stop = ['service_id', 'date']
merged_tripid_df = merged_tripid_df.drop(column_list_stop, axis=1)

# Write results to stop_times.csv
merged_tripid_df.to_csv('/home/thomas/data-bench/nmbs-gtfs/stop_times.csv',\
                         index=False)