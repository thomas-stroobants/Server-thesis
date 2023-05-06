import pandas as pd
df = pd.read_csv("/home/thomas/data-bench/iRail/facilities.csv")

for i in range(len(df.index)):
    old_value = df.loc[i, "URI"]
    new_value = format(int(old_value.split('/')[-1]), '07d')
    # print(old_value, new_value)
    # print()
    df.loc[i, "URI"] = new_value

df["blue-bike"] = df["blue-bike"].fillna(0)
df["blue-bike"] = df["blue-bike"].astype(int)

df.to_csv("/home/thomas/data-bench/iRail/facilities.csv", index=False)