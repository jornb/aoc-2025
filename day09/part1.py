lines = [l.strip().split(",") for l in open("input.txt").readlines()]
points = [tuple(int(x) for x in l) for l in lines]


def area(a, b):
    dx = abs(a[0] - b[0]) + 1
    dy = abs(a[1] - b[1]) + 1
    return dx * dy

answer = max(area(a, b) for a in points for b in points)
print(answer)
