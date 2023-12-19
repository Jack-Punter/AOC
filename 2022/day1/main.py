
input_file = "01input"
with open(input_file, "r") as f:
    lines = f.readlines()
    lines.append("")


elves = []
current_calorie = 0
for i, line in enumerate(lines):
    if line.strip() == "": 
        elves.append(current_calorie)
        current_calorie = 0
    else:
        current_calorie += int(line)

print(sum(sorted(elves, reverse=True)[:3]))
