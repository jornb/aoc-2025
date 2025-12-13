lines = open("input.txt").readlines()
lines = [l.strip() for l in lines]

beams = [i for i, c in enumerate(lines[0]) if c == "S"]

answer = 0
for line in lines[1:]:
    new_beams = set()

    for beam in beams:
        if line[beam] == ".":
            new_beams.add(beam)
        else:
            answer += 1
            new_beams.add(beam - 1)
            new_beams.add(beam + 1)
    beams = new_beams

print(answer)
