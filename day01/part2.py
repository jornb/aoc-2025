from functools import reduce

print(reduce(lambda x, y: [(x[0] + z, n) for (z, n) in [[(sum(c == 0 for c in t[1:]), t[-1]) for t in [
    reduce(lambda w, _: w + [(w[-1] + (1 if y > 0 else 99)) % 100], range(abs(y)),
           [x[1]])]][0]]][0], [(-1 if s[0] == "L" else 1) * int(s[1:]) for s in open("input.txt").read().splitlines()],
             (0, 50))[0])
