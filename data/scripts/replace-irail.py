import pandas as pd
pd.set_option('precision', 0)
df = pd.read_csv("/home/thomas/data/iRail/facilities.csv")

for i in range(len(df.index)):
    old_value = df.loc[i, "URI"]
    new_value = format(int(old_value.split('/')[-1]), '07d')
    print(old_value, new_value)
    print()
    df.loc[i, "URI"] = new_value



df.to_csv("/home/thomas/data/iRail/facilities1.csv", index=False)