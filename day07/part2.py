import functools

lines = open("input.txt").readlines()
lines = [l.strip() for l in lines]


@functools.cache
def count_timelines(i_line, i_column):
    if i_line == len(lines) - 1:
        return 1

    if lines[i_line][i_column] == '.':
        return count_timelines(i_line + 1, i_column)

    return count_timelines(i_line + 1, i_column + 1) + count_timelines(i_line + 1, i_column - 1)


answer = count_timelines(1, lines[0].index("S"))
print(answer)
