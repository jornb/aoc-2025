import functools

lines = open("input.txt").readlines()
connections = [l.strip().split(": ") for l in lines]
connections = {c0: c1.split() for c0, c1 in connections}


@functools.cache
def count_paths(start, goal):
    if start == goal:
        return 1

    if start not in connections:
        return 0

    return sum(count_paths(c, goal) for c in connections[start])


answer = count_paths("svr", "dac") * count_paths("dac", "fft") * count_paths("fft", "out")
answer += count_paths("svr", "fft") * count_paths("fft", "dac") * count_paths("dac", "out")
print(answer)
