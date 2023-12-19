input_file = "example_input"
input_file = "04input"

with open(input_file, "r") as f:
    lines = f.readlines()
    lines = map(lambda x: x.strip(), lines)
    lines = map(lambda x: x.replace(",", "-"), lines)
    ranges = map(lambda x: x.split("-"), lines)

score = 0
for e11, e12, e21, e22 in ranges:
    e1start = int(e11)
    e1end = int(e12)
    e2start = int(e21)
    e2end = int(e22)

    if (e2start <= e1start <= e2end or e2start <= e1end <= e2end or \
        e1start <= e2start <= e1end or e1start <= e2end <= e1end):
        score += 1

print(score)
