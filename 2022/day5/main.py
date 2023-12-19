input_file = "example_input"
# input_file = "04input"

initial_stack = []
moves = []
with open(input_file, "r") as f:
    lines = [line.strip() for line in f]
    split_point = lines.index("")
    print(split_point)
    print(lines[split_point - 1])
    print(lines[split_point + 1])

