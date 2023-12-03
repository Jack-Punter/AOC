const std = @import("std");
const mem = std.mem;

pub fn puzzle_code(allocator: mem.Allocator, input: []const u8) !i64 {
    var lines = mem.tokenizeScalar(u8, input, '\n');
    var sum: i64 = 0;
    var min_colours = std.StringHashMap(i32).init(allocator);

    while (lines.next()) |line| {
        const colon = mem.indexOfScalar(u8, line, ':').?;

        const game = line[0..colon];
        const last_space = mem.lastIndexOfScalar(u8, game, ' ').?;
        const game_number_str = game[last_space + 1 ..];
        const game_number = try std.fmt.parseInt(i32, game_number_str, 10);
        _ = game_number;

        const game_inputs = line[colon + 1 ..];

        var game_input_iter = mem.tokenizeScalar(u8, game_inputs, ';');
        while (game_input_iter.next()) |game_input_| {
            const game_input = mem.trim(u8, game_input_, " ");
            var colour_iters = mem.tokenizeScalar(u8, game_input, ',');

            // try stdout.print("{s}\n", .{game_input});

            while (colour_iters.next()) |colour_count_| {
                const colour_count = mem.trim(u8, colour_count_, " ");
                const space_idx = mem.indexOfScalar(u8, colour_count, ' ').?;

                const count = try std.fmt.parseInt(i32, colour_count[0..space_idx], 10);
                const colour = colour_count[space_idx + 1 ..];
                // if (count > bag_content.get(colour).?) {
                //     break :this_game;
                // }
                if (!min_colours.contains(colour) or
                    count > min_colours.get(colour).?)
                {
                    try min_colours.put(colour, count);
                }
            }
        }
        // else {
        //     sum += game_number;
        // }
        var power: i32 = 1;
        var iterator = min_colours.iterator();
        while (iterator.next()) |iter| {
            power *= iter.value_ptr.*;
            iter.value_ptr.* = 0;
        }
        // try stdout.print("Power: {d}\n", .{power});
        sum += power;
    }
    return sum;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    const test_input =
        \\Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
        \\Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
        \\Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
        \\Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
        \\Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    ;
    _ = test_input;

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const input = @embedFile("input.txt");
    const answer = try puzzle_code(allocator, input);

    try stdout.print("Got result {d}\n", .{answer});
}
