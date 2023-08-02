const std = @import("std");

pub fn allocMatmul(comptime n: usize, allocator: std.mem.Allocator, a: []const f32, b: []const f32) error{OutOfMemory}![]const f32 {
    var c = try allocator.alloc(f32, n * n);

    for (0..n) |i| {
        for (0..n) |j| {
            for (0..n) |k| {
                c[i * n + j] += a[i * n + k] * b[k * n + j];
            }
        }
    }

    return c;
}
