const std = @import("std");
const common = @import("common.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    inline for (common.variants) |variant| {
        const allocMatmul = common.matmul_by_variant(variant);
        const n = 48 * 40;

        var a = try allocator.alloc(f32, n * n);
        defer allocator.free(a);
        for (a) |*x| {
            x.* = 1;
        }
        var b = try allocator.alloc(f32, n * n);
        defer allocator.free(b);
        for (b) |*x| {
            x.* = 2;
        }

        const stdout = std.io.getStdOut().writer();
        const start = std.time.milliTimestamp();
        const c = try allocMatmul(n, allocator, a, b);
        defer allocator.free(c);
        nosuspend try stdout.print("{s} {} ms\n", .{ @tagName(variant), std.time.milliTimestamp() - start });
    }
}
