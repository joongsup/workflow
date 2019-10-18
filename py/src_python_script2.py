

import numpy as np
import pandas as pd
from matplotlib import pyplot as plt

x1 = ['a', 'b', 'c', 'c', 'c', 'b', 'b', 'a', 'a', 'c']
x2 = range(10)
y = [True, False, False, False, True, True, True, False, True, False]
df = pd.DataFrame(zip(x1, x2, y), columns = ['x1', 'x2', 'y'])

# View the data frame
print(df.head())

df.groupby('x1').size().reset_index(name = 'count').plot(kind = 'bar', x = 'x1', y = 'count')
plt.show(block = False)
