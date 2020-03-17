import json
import matplotlib
import sys
from matplotlib import pyplot as plt

matplotlib.use('gtk3agg')

with open('../out/{}.marker'.format(sys.argv[-1])) as f:
    plt.imshow(
        [[abs(int(j) - 1) for j in i.strip()] for i in f.readlines()],
    cmap='gray', vmin=0, vmax=1)

plt.axis('off')
plt.show()