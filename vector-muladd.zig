const std = @import("std");

pub fn allocMatmul(comptime n: usize, allocator: std.mem.Allocator, a: []const f32, b: []const f32) error{OutOfMemory}![]const f32 {
    var c = try allocator.alloc(f32, n * n);
    for (c) |*x| {
        x.* = 0;
    }

    for (0..n) |i| {
        const a_row: @Vector(n, f32) = a[i * n ..][0..n].*;
        for (0..n) |j| {
            const b_row: @Vector(n, f32) = b[j * n ..][0..n].*;
            const c_row: @Vector(n, f32) = c[i * n ..][0..n].*;
            c[i * n ..][0..n].* = @mulAdd(@Vector(n, f32), @splat(a_row[j]), b_row, c_row);
        }
    }

    return c;
}
