lines = open("input.txt").readlines()
connections = [l.strip().split(": ") for l in lines]
connections = {c0: c1.split() for c0, c1 in connections}

def count_paths(start):
    if start == "out":
        return 1

    return sum(count_paths(c) for c in connections[start])

answer = count_paths("you")
print(answer)
