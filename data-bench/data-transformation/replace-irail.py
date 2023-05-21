import pandas as pd
# Load the file into a Pandas DataFrame
df = pd.read_csv("/home/thomas/data-bench/iRail/facilities.csv")

# Remove the URI and keep only the stop_id of the stations
for i in range(len(df.index)):
    uri = df.loc[i, "URI"]
    stop_id = format(int(uri.split('/')[-1]), '07d')
    df.loc[i, "URI"] = stop_id

# Fill the empty values witth zero and cast to integer value
df["blue-bike"] = df["blue-bike"].fillna(0)
df["blue-bike"] = df["blue-bike"].astype(int)

# Overwrite the original file with the changed data
df.to_csv("/home/thomas/data-bench/iRail/facilities.csv", index=False)