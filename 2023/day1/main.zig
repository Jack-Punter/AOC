const std = @import("std");

pub fn main() !void {
    const test_input =
        \\1abc2
        \\pqr3stu8vwx
        \\a1b2c3d4e5f
        \\treb7uchet
    ;
    _ = test_input;

    const test_input2 =
        \\two1nine
        \\eightwothree
        \\abcone2threexyz
        \\xtwone3four
        \\4nineeightseven2
        \\zoneight234
        \\7pqrstsixteen
    ;
    _ = test_input2;

    const stdout = std.io.getStdOut().writer();
    const file_buffer = @embedFile("input.txt");
    const replacements = [_][2][]const u8{
        .{ "one", "1" },
        .{ "two", "2" },
        .{ "three", "3" },
        .{ "four", "4" },
        .{ "five", "5" },
        .{ "six", "6" },
        .{ "seven", "7" },
        .{ "eight", "8" },
        .{ "nine", "9" },
    };

    const input: []const u8 = file_buffer;
    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    var sum: i64 = 0;

    while (lines.next()) |line| {
        var result_str: [2]u8 = undefined;
        var first_found: bool = false;

        char_iter: for (line, 0..) |char, idx| {
            for (replacements) |pair| {
                if (pair[0].len <= line[idx..].len and
                    std.mem.eql(u8, line[idx .. idx + pair[0].len], pair[0]))
                {
                    if (!first_found) {
                        // Theres got to be a better way to do this
                        // really replacements should be a [_].{[]const u8, u8};
                        result_str[0] = pair[1][0];
                        first_found = true;
                    }

                    result_str[1] = pair[1][0];
                    continue :char_iter;
                }
            }

            if (char >= '0' and char <= '9') {
                if (!first_found) {
                    result_str[0] = char;
                    first_found = true;
                }
                result_str[1] = char;
            }
        }

        sum += std.fmt.parseInt(i32, result_str[0..], 10) catch 0;
    }
    try stdout.print("Answer {d}", .{sum});
}
