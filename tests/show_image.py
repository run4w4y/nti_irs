import json
import matplotlib
from matplotlib import pyplot as plt

matplotlib.use('gtk3agg')

with open('image_res.json') as f:
    plt.imshow(json.loads(f.read()), cmap='gray', vmin=0, vmax=255)
    # plt.plot(123, 127, 'ro')
    # plt.plot(114, 2, 'ro')
    # plt.plot(19, 0, 'ro')
    # plt.plot(1, 127, 'ro')
    plt.show()