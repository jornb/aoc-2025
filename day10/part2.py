from scipy.optimize import linprog


# Solve Ax=b problem with scipy
# https://docs.scipy.org/doc/scipy-1.16.2/reference/optimize.linprog-highs.html
def solve(target, buttons):
    c = [1 for b in buttons]
    A = [[1 if i in b else 0 for b in buttons] for i in range(len(target))]
    b = target
    return int(linprog(c, A_eq=A, b_eq=b, integrality=1, method="highs").fun)


answer = 0
for line in open("input.txt").readlines():
    s = line.strip().split(" ")
    target = tuple([int(x) for x in s[-1][1:-1].split(",")])
    buttons = [tuple(int(x) for x in b[1:-1].split(",")) for b in s[1:-1]]

    answer += solve(target, buttons)

print(answer)
