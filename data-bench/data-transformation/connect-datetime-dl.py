# Python script to convert the times in stop_times from xsd:time to xsd:dateTime, setting the time and dat in ISO standard format
# Second to that, it will remove all rows that have times greater than 24:59:59 for daylight savings time
import datetime
import csv
import pandas as pd

# read calendar_dates to dataframe
calendar_dates_df = pd.read_csv('/home/thomas/data-bench/de-lijn-gtfs/calendar_dates.csv')
calendar_dates_df = calendar_dates_df.drop('exception_type', axis=1)
# read trips to dataframe
trips_df = pd.read_csv('/home/thomas/data-bench/de-lijn-gtfs/trips.csv')
column_list_trip = ['route_id', 'trip_headsign', 'trip_short_name', 'direction_id', 'block_id', 'shape_id']
trips_df = trips_df.drop(column_list_trip, axis=1)
# read stop_times to dataframe
stop_times_df = pd.read_csv('/home/thomas/data-bench/de-lijn-gtfs/stop_times.csv')

print(f"{datetime.datetime.now()} Modifying departure times above 24...")

#apply leading zero where needed on time and remove all times from daylight savings
stop_times_df['departure_time'] = stop_times_df['departure_time'].apply(lambda x: '0'+x if len(x) == 7 else x)

def checkmidnight(time):
    hour, minute, second = map(int, time.split(":"))
    if hour >= 24:
        hour = hour % 24
        time = f"{hour:02d}:{minute:02d}:{second:02d}"
    return time

# remove the rows with departure_time above 24:59:59
stop_times_df = stop_times_df[stop_times_df['departure_time'] <= '24:59:59']
stop_times_df['departure_time'] = stop_times_df['departure_time'].apply(lambda x: checkmidnight(x))

# merge calendar_dates_df and trips_df on the service_id column
merged_df = pd.merge(calendar_dates_df, trips_df, on='service_id')

# merge trips_df and stop_times_df on trip_id
merged_df2 = pd.merge(merged_df, stop_times_df, on='trip_id')

def dateToISO(row):
    return datetime.datetime.strptime(str(row['date'])+row['departure_time'], '%Y%m%d%H:%M:%S').isoformat()

print(f"{datetime.datetime.now()} Replacing time format to ISO dateTime...")
merged_df2['departure_time'] = merged_df2.apply(lambda row: dateToISO(row), axis=1)

# drop service_id and date
column_list_stop = ['service_id', 'date']
merged_df2 = merged_df2.drop(column_list_stop, axis=1)
# print(merged_df2)

print(f"{datetime.datetime.now()} len of DF is {len(merged_df2)}")

# write results to new file
print(f"{datetime.datetime.now()} Writing results to file")
merged_df2.to_csv('/home/thomas/data-bench/de-lijn-gtfs/stop_times.csv', index=False)

print(f"{datetime.datetime.now()} Finished adapting data stop_times from De Lijn..")