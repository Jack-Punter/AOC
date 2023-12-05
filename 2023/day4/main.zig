const std = @import("std");
const mem = std.mem;

fn is_digit(char: u8) bool {
    return char >= '0' and char <= '9';
}

pub fn puzzle_code(allocator: mem.Allocator, input: []const u8) !i64 {
    _ = allocator;

    const stdout = std.io.getStdOut().writer();
    _ = stdout;
    var sum: i64 = 0;

    var lines_iter = mem.tokenizeScalar(u8, input, '\n');
    // I can have a maximum of 10 matches, so I need 11 slots, 1 for the current card adn 10 for
    // the count of the next cards.
    var extra_cards: [11]i64 = undefined;
    for (&extra_cards) |*ptr| {
        ptr.* = 1;
    }

    while (lines_iter.next()) |line| {
        const colon = mem.indexOfScalar(u8, line, ':').?;
        const all_numbers = line[colon + 1 ..];
        const pipe = mem.indexOfScalar(u8, all_numbers, '|').?;
        const wining_numbers = all_numbers[0..pipe];
        const numbers = all_numbers[pipe + 1 ..];

        var wining_numbers_iter = mem.tokenizeScalar(u8, wining_numbers, ' ');
        var numbers_iter = mem.tokenizeScalar(u8, numbers, ' ');

        var matches: usize = 0;
        while (numbers_iter.next()) |number| {
            while (wining_numbers_iter.next()) |w_number| {
                if (mem.eql(u8, number, w_number)) {
                    matches += 1;
                }
            }
            wining_numbers_iter.reset();
        }

        // Add every card we have for this card index
        sum += extra_cards[0];
        // Then for all the cards we have copies of from our matches, we
        // add that that number of cards.
        for (1..matches + 1) |idx| {
            extra_cards[idx] += extra_cards[0];
        }
        for (0..extra_cards.len - 1) |idx| {
            extra_cards[idx] = extra_cards[idx + 1];
        }
        extra_cards[extra_cards.len - 1] = 1;
    }

    return sum;
    // return sum2;
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    const test_input =
        \\ Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
        \\ Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
        \\ Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
        \\ Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
        \\ Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
        \\ Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    ;
    _ = test_input;

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const input = @embedFile("input.txt");
    const answer = try puzzle_code(allocator, input);

    try stdout.print("Got result {d}\n", .{answer});
}
