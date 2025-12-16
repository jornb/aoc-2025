import tqdm

lines = open("input.txt").readlines()


def parse_state(bits):
    out = 0
    for b in bits:
        out = (out << 1) | b
    return out


def parse_button(N, bits):
    out = 0
    for b in bits:
        out |= 1 << (N - 1 - b)
    return out


def solve(target, buttons):
    best = None
    heads = [(0, 0)]

    while heads:
        heads.sort(key=lambda x: x[0])
        num_pushes, state = heads.pop(0)

        if best and num_pushes >= best:
            continue

        if state == target:
            best = num_pushes
            continue

        for b in buttons:
            new_state = state ^ b
            i = next((i for i, (n, s) in enumerate(heads) if s == new_state), None)
            if i is None:
                heads.append((num_pushes + 1, new_state))
            elif num_pushes + 1 < heads[i][0]:
                heads[i] = (num_pushes + 1, new_state)

    return best


answer = 0
for line in tqdm.tqdm(lines):
    s = line.strip().split(" ")
    target_str = s[0][1:-1]
    target = parse_state([x == "#" for x in target_str])
    buttons = [parse_button(len(target_str), [int(x) for x in b[1:-1].split(",")]) for b in s[1:-1]]

    answer += solve(target, buttons)

print(answer)
