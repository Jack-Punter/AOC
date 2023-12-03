const std = @import("std");
const mem = std.mem;

fn is_digit(char: u8) bool {
    return char >= '0' and char <= '9';
}

pub fn puzzle_code(allocator: mem.Allocator, input: []const u8) !i64 {
    const stdout = std.io.getStdOut().writer();
    var sum: i64 = 0;
    var sum2: i64 = 0;

    var idxs = try std.ArrayList(usize).initCapacity(allocator, 512);
    var line_count: usize = 0;
    // Get the index's of all of the symbols in the file
    for (input, 0..) |char, idx| {
        // This is nasty, but the sybmols are: https://www.asciitable.com/
        // if (char >= '!' and char <= '/') {
        if (char == '\n') {
            line_count += 1;
        } else if (char != '.' and !is_digit(char)) {
            try idxs.append(idx);
        }
    }

    // For each symbol we found
    const line_length = mem.indexOfScalar(u8, input, '\n').? + 1;
    for (idxs.items) |symbol_idx| {
        const sx = symbol_idx % line_length;
        const sy = symbol_idx / line_length;

        var part_number_count: usize = 0;
        var part_numbers: [6:0]i64 = undefined;
        // Loop through the surrounding y lines
        const startY = switch (sy) {
            0 => sy,
            else => sy - 1,
        };
        const endY = @min(sy + 2, line_count + 1);
        y_loop: for (startY..endY) |y| {
            // Loop through the surrounding x lines
            const startX = switch (sy) {
                0 => sx,
                else => sx - 1,
            };
            const endX = @min(sx + 2, line_length);
            for (startX..endX) |x| {
                if (x == sx and y == sy) continue;
                const search_index = y * line_length + x;
                const character = input[search_index];

                if (character >= '0' and character <= '9') {
                    // Scan backwards for the start of the number
                    var start_index = search_index;
                    while (is_digit(input[start_index])) {
                        start_index -= 1;
                        // This messy, but we cant subtract from zero so we need to
                        // break and not trigger the ele if we're on index 0 and it
                        // _is_ a digit, otherwise we can let the while condition
                        // fail and exit into the else block
                        if (start_index == 0 and is_digit(input[start_index])) break;
                    } else {
                        // Go forwards 1 digit so we dont start on the non-digit.
                        start_index += 1;
                    }

                    // Scan forwards for the end of the number
                    var end_index = search_index;
                    while (start_index < input.len and is_digit(input[end_index])) {
                        end_index += 1;
                    }

                    const number = input[start_index..end_index];
                    try stdout.print("Adding number: '{s}'\n", .{number});

                    const number_val = try std.fmt.parseInt(i64, number, 10);
                    part_numbers[part_number_count] = number_val;
                    part_number_count += 1;

                    sum += number_val;
                    // If the end of the string is ahead of the current letter then it _must_ be the only number
                    // on that line that is adjacent to the symbol.
                    // we check the first, then if its ahead, but not past the end we cant have another adjacent
                    // to the symbol
                    // ll.
                    // .s.
                    // ...
                    if (end_index > search_index + 1) continue :y_loop;
                }
            }
        }

        // Part 2
        if (input[symbol_idx] == '*' and part_number_count == 2) {
            sum2 += part_numbers[0] * part_numbers[1];
        }
    }

    // return sum1
    return sum2;
}

pub fn main() !void {
    // const stdout = std.io.getStdOut().writer();

    const test_input =
        \\467..114..
        \\...*......
        \\..35..633.
        \\......#...
        \\617*......
        \\.....+.58.
        \\..592.....
        \\......755.
        \\...$.*....
        \\.664.598..
    ;
    _ = test_input;

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const input = @embedFile("input.txt");
    const answer = try puzzle_code(allocator, input);

    try stdout.print("Got result {d}\n", .{answer});
}
