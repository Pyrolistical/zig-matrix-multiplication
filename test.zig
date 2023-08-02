const std = @import("std");
const expectEqualSlices = std.testing.expectEqualSlices;

const common = @import("common.zig");

test "correctness" {
    inline for (common.variants) |variant| {
        const allocMatmul = common.matmul_by_variant(variant);
        const n = 2;
        const a = [_]f32{ 1, 2, 3, 4 };

        const b = [_]f32{ 5, 6, 7, 8 };

        const c = try allocMatmul(n, std.testing.allocator, &a, &b);
        defer std.testing.allocator.free(c);

        try expectEqualSlices(f32, &[_]f32{ 19, 22, 43, 50 }, c);
    }
}
