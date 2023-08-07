const std = @import("std");
const common = @import("common.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const stdout = std.io.getStdOut().writer();
    nosuspend try stdout.print("n", .{});
    inline for (common.variants) |variant| {
        nosuspend try stdout.print("\t{s}", .{@tagName(variant)});
    }
    nosuspend try stdout.print("\n", .{});
    inline for (&[_]usize{ 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048 }) |n| {
        nosuspend try stdout.print("{}", .{n});
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

            const start = std.time.nanoTimestamp();
            const c = try allocMatmul(n, allocator, a, b);
            defer allocator.free(c);
            nosuspend try stdout.print("\t{}", .{std.time.nanoTimestamp() - start});
        }
        nosuspend try stdout.print("\n", .{});
    }
}
