lines = open("input.txt").readlines()
lines = [l.strip() for l in lines]
lines = lines[:lines.index("")]

ranges = [l.split("-") for l in lines]
ranges = [[int(r[0]), int(r[1])] for r in ranges]
ranges.sort(key=lambda x: x[0])

merged = [ranges[0]]
for r in ranges[1:]:
    p = merged[-1]
    if r[0] <= p[1]:
        p[1] = max(p[1], r[1])
    else:
        merged.append(r)

print(sum(r[1] - r[0] + 1 for r in merged))
