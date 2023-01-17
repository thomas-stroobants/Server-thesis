import pandas as pd

df = pd.read_csv("/home/thomas/data/iRail/facilities.csv")

for index, row in df.iterrows():
    old_value = row["URI"]
    new_value = format(int(old_value.split('/')[-1]), '07d')
    print(row["URI"], new_value)
    print()
    row["URI"] = new_value



df.to_csv("/home/thomas/data/iRail/facilities1.csv")