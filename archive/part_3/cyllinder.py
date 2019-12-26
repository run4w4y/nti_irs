from scipy.interpolate import interp1d
from scipy.signal import medfilt, wiener

def read_values(read_function):
    values = []
    encoders = []
    n = int(read_function())
    for enc, s in [map(float, read_function().split()) for i in range(n)]:
        encoders.append(enc)
        values.append(s)
    return values, encoders


def get_points(xs, ys):
    res = []
    prev_y = ys[0]

    for x, y in zip(xs, ys):
        if abs(prev_y - y) > 500:
            res.append(x)
        prev_y = y
    
    return res


def divide_2(l):
    for i in range(0, len(l), 2):  
        yield l[i:i + 2] 


PROD = 0
TEST = 1
env = TEST
test_num = 3

if env == TEST:
    import matplotlib
    from matplotlib import pyplot as plt
    matplotlib.use('gtk3agg')

values = []
encoders = []

if env == TEST:
    with open('cyllinder_tests/{}'.format(test_num)) as f:
        values, encoders = read_values(f.readline)
else:
    values, encoders = read_values(input)

filtered = medfilt(wiener(values), 9)
points = get_points(encoders, filtered)

sizes = list(map(lambda x: x[1] - x[0], divide_2(points)))
max_index = 0

for i in range(len(sizes)):
    if sizes[i] > sizes[max_index]:
        max_index = i

ans = max_index + 1
if env == TEST:
    correct = -1
    with open('cyllinder_tests/{}.clue'.format(test_num)) as f:
        correct = int(f.readline())
    if ans == correct:
        print('OK. Answer is: {}'.format(ans))
    else:
        print('WA. Your answer: {}. Correct answer: {}'.format(ans, correct))
else:
    print(ans)

if env == TEST:
    plt.plot(encoders, values, '-b')
    plt.plot(encoders, filtered, 'r')

    for i in points:
        plt.axvline(x=i)

    plt.show()
