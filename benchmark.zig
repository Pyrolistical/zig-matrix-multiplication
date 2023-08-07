const std = @import("std");
const common = @import("common.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    inline for (&[_]usize{ 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048 }) |n| {
        inline for (common.variants) |variant| {
            const allocMatmul = common.matmul_by_variant(variant);

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
            nosuspend try stdout.print("{},{s},{} ms\n", .{ n, @tagName(variant), std.time.milliTimestamp() - start });
        }
    }
}
