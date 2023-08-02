const std = @import("std");
const common = @import("common.zig");

pub fn allocMatmul(comptime n: usize, allocator: std.mem.Allocator, a: []const f32, b: []const f32) error{OutOfMemory}![]const f32 {
    var c = try allocator.alloc(f32, n * n);

    const b_T = try common.allocTranspose(n, allocator, b);
    defer allocator.free(b_T);

    for (0..n) |i| {
        const a_row: @Vector(n, f32) = a[i * n ..][0..n].*;
        for (0..n) |j| {
            const b_column: @Vector(n, f32) = b_T[j * n ..][0..n].*;
            c[i * n + j] = @reduce(.Add, a_row * b_column);
        }
    }

    return c;
}
