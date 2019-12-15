import json
import matplotlib
from matplotlib import pyplot as plt

matplotlib.use('gtk3agg')

def draw_pt(x, y):
    plt.plot(x, y, 'ro')

with open('image_res.json') as f:
    plt.imshow(json.loads(f.read()), cmap='gray', vmin=0, vmax=255)
    draw_pt(256, 219)
    draw_pt(249, 57)
    draw_pt(86, 65)
    draw_pt(94, 226)

    # marker = [[255,255,255,255,255,255],[255,255,0,0,255,255],[255,0,255,255,0,255],[255,0,255,255,0,255],[255,255,0,0,0,255],[255,255,255,255,255,255]]
    # plt.imshow(marker, cmap='gray', vmin=0, vmax=255)

    plt.show()