import math

lines = open("input.txt").readlines()

indices = [i for i, c in enumerate(lines[-1]) if c in ["+", "*"]]
indices.append(0)

answer = 0

for i0, i1 in zip(indices[:-1], indices[1:]):
    operand = lines[-1][i0]
    entries = [l[i0:i1 - 1] for l in lines[:-1]]

    nums = []

    for j in range(len(entries[0])):
        nums.append(int("".join(e[j] for e in entries).strip()))

    if operand == "+":
        answer += sum(nums)
    else:
        answer += math.prod(nums)

print(answer)
