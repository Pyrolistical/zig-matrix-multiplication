const std = @import("std");
const common = @import("common.zig");

pub fn allocMatmul(comptime n: usize, allocator: std.mem.Allocator, a: []const f32, b: []const f32) error{OutOfMemory}![]const f32 {
    var c = try allocator.alloc(f32, n * n);

    const b_T = try common.allocTranspose(n, allocator, b);
    defer allocator.free(b_T);

    for (0..n) |i| {
        for (0..n) |j| {
            for (0..n) |k| {
                c[i * n + j] += a[i * n + k] * b_T[j * n + k]; // note b_T[j * n + k] instead of b[k * n + j]
            }
        }
    }

    return c;
}
