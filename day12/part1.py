lines = [l.strip() for l in open("input.txt").readlines() if "x" in l]

answer = 0
for l in lines:
    a, b = l.split(": ")
    w, h = a.split("x")
    if (int(w) * int(h)) // 9 >= sum(int(i) for i in b.split()):
        answer += 1

print(answer)
