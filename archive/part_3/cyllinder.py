from scipy.interpolate import interp1d
from scipy.signal import medfilt, wiener
from scipy.misc import derivative

def filt(values, s=7):
    return wiener(medfilt(wiener(values), s))

def read_values(read_function):
    values = []
    encoders = []
    n = int(read_function())
    for enc, s in [map(float, read_function().split()) for i in range(n)]:
        encoders.append(enc)
        values.append(s)
    return values, encoders

def sign(f):
    if abs(f) <= 0.3:
        return 0
    elif f < 0:
        return -1
    else:
        return 1

def get_points(xs, ys):
    res = []
    grow = False
    drop = False

    for x, y in zip(xs, ys):
        if sign(y) > 0 and not grow:
            res.append(x)
            grow = True
        elif sign(y) < 0 and grow:
            drop = True
        elif sign(y) >= 0 and grow and drop:
            res.append(x)
            drop = False
            grow = False

            if sign(y) > 0 and not grow:
                res.append(x)
                grow = True

    return res

def divide_2(l):
    for i in range(0, len(l), 2):  
        yield l[i:i + 2] 


PROD = 0
TEST = 1
env = PROD
test_num = 4

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

filtered = list(map(lambda x: 3700 if x > 3650 else x, filt(values[2:])))
f = interp1d(encoders[2:], filtered, fill_value="extrapolate")
ds = filt(list(map(lambda x: -derivative(f, x), encoders)), 9)
points = get_points(encoders, ds)

sizes = list(map(lambda x: x[1] - x[0], list(divide_2(points))))
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
    # plt.plot(encoders, values, '-b')
    # plt.plot(encoders, list(map(f, encoders)), 'r')
    plt.plot(encoders, ds)
    plt.axhline(y=0, c='black')

    for i in points:
        plt.axvline(x=i, c='red')

    plt.show()
