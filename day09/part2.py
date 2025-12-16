import sys
import time
import tqdm

lines = [l.strip().split(",") for l in open("input.txt").readlines()]
points = [tuple(int(x)//1 for x in l) for l in lines]

import cv2
import numpy as np

W = max(p[0] for p in points) + 1
H = max(p[1] for p in points) + 1

I = np.ones((H, W), dtype="uint8") * 255
cv2.fillPoly(I, pts=[np.array([points])], color=0)

# cv2.imwrite("out.png", cv2.resize(I, None, fx=0.001, fy=0.001))



def area(a, b):
    dx = abs(a[0] - b[0]) + 1
    dy = abs(a[1] - b[1]) + 1
    return dx * dy


answer = 0
best = None

for i, p in enumerate(points[:-1]):
    sys.stderr.write(f"{i+1} / {len(points) - 1}\n")
    for q in tqdm.tqdm(points[i+1:]):
        a = area(p, q)
        if a <= answer:
            continue

        x0, y0 = p
        x1, y1 = q
        x0, y0, x1, y1 = min(x0, x1), min(y0, y1), max(x0, x1), max(y0, y1)

        # Guaranteed that the middle is not part of the solution
        if (y0 > H/2) != (y1 > H/2):
            continue

        # Must be in different halves
        if (x0 > W/2) == (x1 > W/2):
            continue

        if np.any(I[y0:y1+1, x0:x1+1]):
            continue

        answer = a
        best = ((x0, y0), (x1, y1))

print(answer)
with open("answer.txt", "w") as f:
    f.write(str(answer))

(x0, y0), (x1, y1) = best
cv2.rectangle(I, (x0, y0), (x1, y1), color=128, thickness=-1)

cv2.imwrite("out.png", cv2.resize(I, None, fx=0.001, fy=0.001))

