input_file = "example_input"
input_file = "03input"

halves = []
with open(input_file, "r") as f:
    lines = f.readlines()
    lines = list(map(lambda x: x.strip(), lines))
    for l in lines:
        halves.append((l[:len(l)//2],
                       l[len(l)//2:]))

score = 0
# for c1, c2 in halves:
start = 0
while start < len(lines):
    elves  = lines[start:start+3] 
    start += 3
    common = set(elves[0]) & set(elves[1]) & set(elves[2])
    if (letter := common.pop()) >= "a":
        score += 1 + (ord(letter) - ord("a"))
    else:
        score += 27 + (ord(letter) - ord("A"))

print(score)
        
