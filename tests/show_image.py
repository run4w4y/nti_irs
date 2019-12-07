import json
import matplotlib
from matplotlib import pyplot as plt

matplotlib.use('gtk3agg')

with open('image_res.json') as f:
    plt.imshow(json.loads(f.read()), cmap='gray', vmin=0, vmax=255)
    # plt.plot(125, 127, 'ro')
    # plt.plot(115, 1, 'ro')
    # plt.plot(18, 0, 'ro')
    # plt.plot(0, 127, 'ro')
    
    # plt.plot(34, 0, 'ro')
    # plt.plot(15, 21, 'ro')
    # plt.plot(18, 0, 'ro')
    # plt.plot(32, 21, 'ro')
    # plt.plot(50, 0, 'ro')
    # plt.plot(49, 22, 'ro')
    # plt.plot(12, 43, 'ro')
    # plt.plot(30, 43, 'ro')
    
    # marker = [[0,0,255,0,0,0],[0,0,0,0,0,255],[255,255,0,255,255,0],[255,0,0,0,255,255],[255,0,255,255,0,0],[255,255,0,0,0,255]]
    # plt.imshow(marker, cmap='gray', vmin=0, vmax=255)
    plt.show()