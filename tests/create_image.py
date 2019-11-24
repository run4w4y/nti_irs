import json
from PIL import Image

im = Image.open('image.png')
width, height = im.size
pixels = []
for i in range(0, height):
    tmp = []
    for j in range(0, width):
        tmp.append(list(im.getpixel((i, j))))
    pixels.append(tmp)

with open('image.json', 'w') as f:
    f.write(json.dumps(pixels))