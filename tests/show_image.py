import json
import matplotlib
from matplotlib import pyplot as plt

matplotlib.use('gtk3agg')

with open('image_res.json') as f:
    plt.imshow(json.loads(f.read()), cmap='gray', vmin=0, vmax=255)
    # plt.plot(127, 123, 'ro')
    # plt.plot(2, 114, 'ro')
    # plt.plot(0, 19, 'ro')
    # plt.plot(127, 1, 'ro')
    plt.show()