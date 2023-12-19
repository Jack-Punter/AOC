# input_file = "example_input"
input_file = "02input"
mapping = {
    "X": "lose",
    "Y": "draw",
    "Z": "win"
}

with open(input_file, "r") as f:
    lines = f.readlines()
    game = map(lambda x: x.split(), lines)
    game = map(lambda x: (x[0], mapping[x[1]]), game) 

scores = {
    "A": 1,
    "B": 2,
    "C": 3,
}

loses = {
    "A": "B",
    "B": "C",
    "C": "A",
}

beats = {
    "A": "C",
    "B": "A",
    "C": "B",
}

score = 0
for p1, goal in game:
    if goal == "lose":
        score += scores[beats[p1]]
    elif goal == "draw":
        score += 3 + scores[p1]
    elif goal == "win":
        score += 6 + scores[loses[p1]]

print(score)
