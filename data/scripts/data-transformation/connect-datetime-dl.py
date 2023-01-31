# Python script to convert the times in stop_times from xsd:time to xsd:dateTime, setting the time and dat in ISO standard format
# Second to that, it will remove all 
import datetime
import csv
import pandas as pd

# read calendar_dates to dataframe
calendar_dates_df = pd.read_csv('/home/thomas/data/de-lijn-gtfs/calendar_dates.csv')
# read trips to dataframe
trips_df = pd.read_csv('/home/thomas/data/de-lijn-gtfs/trips.csv')
# read stop_times to dataframe
stop_times_df = pd.read_csv('/home/thomas/data/de-lijn-gtfs/stop_times.csv')

# remove the rows with departure_time above 24:59:59
stop_times_df = stop_times_df[stop_times_df['departure_time'] <= '24:59:59']

# loop through the stop_times_df and modify the departure_time if it's above 24:00:00
for index, row in stop_times_df.iterrows():
    departure_time = row['departure_time']
    hour, minute, second = [int(i) for i in departure_time.split(":")]
    if hour >= 24:
        hour = hour % 24
        departure_time = f"{hour:02d}:{minute:02d}:{second:02d}"
    stop_times_df.at[index, 'departure_time'] = departure_time

# merge calendar_dates_df and trips_df on the service_id column
merged_df = pd.merge(calendar_dates_df, trips_df, on='service_id')

# create dict to store the merged data
trip_id_dict = {}
for index, row in merged_df.iterrows():
    trip_id_dict[row['trip_id']] = [row['date'], row['service_id']]

# iterate over the stop_times_df to replace the departure_time to an iso format
for index, row in stop_times_df.iterrows():
    trip_id = row['trip_id']
    if trip_id in trip_id_dict:
        date = trip_id_dict[trip_id][0]
        departure_time = row['departure_time']
        mod_departure_time = datetime.datetime.strptime(str(date)+departure_time, '%Y%m%d%H:%M:%S') # set combine date and time
        stop_times_df.at[index, 'departure_time'] = mod_departure_time.isoformat() # convert to iso format

# write results to new file
stop_times_df.to_csv('/home/thomas/data/de-lijn-gtfs/stop_times_mod.csv', index=False)