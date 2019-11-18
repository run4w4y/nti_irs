from scipy.interpolate import interp1d

n, m = map(int, input().split())
exact, cal_values, raw_values = (list(map(float, input().split())) for i in range(3))
calibrated = interp1d(cal_values, exact)
print(*map(calibrated, raw_values))
