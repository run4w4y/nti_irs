import json
import matplotlib
import sys
from matplotlib import pyplot as plt

matplotlib.use('gtk3agg')

def draw_pt(x, y):
    plt.plot(x, y, 'ro')

def draw_line(x1, y1, x2, y2):
    plt.plot([x1, x2], [y1, y2], 'r')

with open('../out/{}.binimg'.format(sys.argv[-1])) as f:
    plt.imshow(json.loads(f.read()), cmap='gray', vmin=0, vmax=255)

with open('../out/{}.grid'.format(sys.argv[-1])) as f:
    t = f.readline()
    while t:
        if t.strip().startswith('ln'):
            x1, y1 = map(float, f.readline().strip().split()[1:])
            draw_pt(x1, y1)
            x2, y2 = map(float, f.readline().strip().split()[1:])
            draw_pt(x2, y2)
            draw_line(x1, y1, x2, y2)
        elif t.strip().startswith('pt'):
            x, y = map(float, t.split()[1:])
            draw_pt(x, y)
        t = f.readline()

plt.show()