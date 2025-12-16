import math

lines = open("input.txt").readlines()
lines = [l.strip().split(",") for l in lines]
boxes = [tuple(int(xyz) for xyz in l) for l in lines]


def distance(a, b):
    return (a[0] - b[0]) ** 2 + (a[1] - b[1]) ** 2 + (a[2] - b[2]) ** 2


pairs = []
for i0, b0 in enumerate(boxes[:-1]):
    for i1, b1 in enumerate(boxes[i0 + 1:]):
        d = distance(b0, b1)
        pairs.append((d, i0, i0 + i1 + 1))

pairs.sort(key=lambda p: p[0])

circuits = [[i] for i in range(len(boxes))]

for d, i0, i1 in pairs[:1000]:
    ic0 = next(i for i, c in enumerate(circuits) if i0 in c)
    ic1 = next(i for i, c in enumerate(circuits) if i1 in c)
    if ic0 != ic1:
        circuits[ic0] += circuits[ic1]
        circuits.pop(ic1)

circuits.sort(key=lambda c: len(c), reverse=True)
answer = math.prod([len(c) for c in circuits[:3]])
print(answer)
