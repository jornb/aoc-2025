import math

lines = open("input.txt").readlines()
lines = [l.strip().split() for l in lines]

answer = 0
for i in range(len(lines[0])):
    nums = [int(l[i]) for l in lines[:-1]]
    if lines[-1][i] == "+":
        answer += sum(nums)
    else:
        answer += math.prod(nums)

print(len(lines))
print(answer)
