import json
import matplotlib
import sys
from matplotlib import pyplot as plt

matplotlib.use('gtk3agg')

with open('pic.json') as f:
    plt.imshow(
        json.loads(f.read())
    )

plt.show()