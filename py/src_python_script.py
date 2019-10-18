


import pandas as pd
from matplotlib import pyplot as plt

ncaa = pd.read_csv("data/champions.csv")

ncaa_grp = ncaa.groupby(["CHAMPION", "COACH"]).size().reset_index(name = 'n').sort_values(by = "n", ascending = False)
p = ncaa_grp[ncaa_grp.n >= 2]
print(p)

ncaa_grp = ncaa.groupby(["CHAMPION"]).size().reset_index(name = 'n').sort_values(by = "n", ascending = False)
p = ncaa_grp[ncaa_grp.n >= 3]
p.plot(kind = 'bar', x = 'CHAMPION', y = 'n', title = "NCAA Men's Basketball Champions (3+ Rings Club!)")
plt.show()

