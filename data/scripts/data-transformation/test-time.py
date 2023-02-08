# Python script to convert the times in stop_times from xsd:time to xsd:dateTime, setting the time and dat in ISO standard format
# Second to that, it will remove all 
import datetime
import csv
import pandas as pd

# read calendar_dates to dataframe
calendar_dates_df = pd.read_csv('/home/thomas/data/de-lijn-gtfs-03-02-2023/calendar_dates.csv')
# read trips to dataframe
trips_df = pd.read_csv('/home/thomas/data/de-lijn-gtfs-03-02-2023/trips.csv')
# read stop_times to dataframe
stop_times_df = pd.read_csv('/home/thomas/data/de-lijn-gtfs-03-02-2023/stop_times.csv')

# remove the rows with departure_time above 24:59:59
# stop_times_df = stop_times_df[stop_times_df['departure_time'] <= '24:59:59']

#apply leading zero where needed on time and remove all times from daylight savings
stop_times_df['departure_time'] = stop_times_df['departure_time'].apply(lambda x: '0'+x if len(x) == 7 else x)
# print(stop_times_df['departure_time'])
stop_times_df_filtered = stop_times_df[stop_times_df['departure_time'] <= '24:59:59']
# print(stop_times_df_filtered)

# merge calendar_dates_df and trips_df on the service_id column
#TODO drop columns that are not nescessarry
merged_df = pd.merge(calendar_dates_df, trips_df, on='service_id')
# print(merged_df.head(500))
# merged_df.to_csv('/home/thomas/data/de-lijn-gtfs-03-02-2023/merged.csv', index=False)
# TODO same drop of columns here
merged_df2 = pd.merge(merged_df, stop_times_df_filtered, on='trip_id')
print(merged_df2)
# TODO drop unnecessary columns here

# TODO append date column to time and delete date column --> convert to iso
exit()


print("Modifying departure times above 24...")

# loop through the stop_times_df and modify the departure_time if it's above 24:00:00
for index, row in stop_times_df.iterrows():
    departure_time = row['departure_time']
    # hour, minute, second = [int(i) for i in departure_time.split(":")]
    hour, minute, second = map(int, departure_time.split(":"))
    # print(f"{departure_time} -- hour is {hour}")

    if hour >= 24:
        hour = hour % 24
        departure_time = f"{hour:02d}:{minute:02d}:{second:02d}"
    if hour <10:
        departure_time = "0" + departure_time

    stop_times_df.at[index, 'departure_time'] = departure_time

# merge calendar_dates_df and trips_df on the service_id column
merged_df = pd.merge(calendar_dates_df, trips_df, on='service_id')

# create dict to store the merged data
trip_id_dict = {}
for index, row in merged_df.iterrows():
    trip_id_dict[row['trip_id']] = [row['date'], row['service_id']]

print("Replacing time format to ISO dateTime...")

# iterate over the stop_times_df to replace the departure_time to an iso format
for index, row in stop_times_df.iterrows():
    trip_id = row['trip_id']
    if trip_id in trip_id_dict:
        date = trip_id_dict[trip_id][0]
        departure_time = row['departure_time']
        mod_departure_time = datetime.datetime.strptime(str(date)+departure_time, '%Y%m%d%H:%M:%S') # set combine date and time
        stop_times_df.at[index, 'departure_time'] = mod_departure_time.isoformat() # convert to iso format

# write results to new file
stop_times_df.to_csv('/home/thomas/data/de-lijn-gtfs-03-02-2023/stop_times1.csv', index=False)

print("Finished adapting data stop_times from De Lijn..")