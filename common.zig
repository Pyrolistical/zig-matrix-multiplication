const std = @import("std");

const Matmul_fn = *const fn (
    comptime n: usize,
    allocator: std.mem.Allocator,
    a: []const f32,
    b: []const f32,
) error{OutOfMemory}![]const f32;

pub const Variant = enum {
    baseline,
    transpose,
    @"vector-reduce",
    @"vector-muladd",
};

pub const variants = [_]Variant{
    .baseline,
    .transpose,
    .@"vector-reduce",
    .@"vector-muladd",
};

pub fn matmul_by_variant(comptime variant: Variant) Matmul_fn {
    return switch (variant) {
        .baseline => @import("baseline.zig").allocMatmul,
        .transpose => @import("transpose.zig").allocMatmul,
        .@"vector-reduce" => @import("vector-reduce.zig").allocMatmul,
        .@"vector-muladd" => @import("vector-muladd.zig").allocMatmul,
    };
}

pub fn allocTranspose(comptime n: usize, allocator: std.mem.Allocator, a: []const f32) ![]const f32 {
    var a_T = try allocator.alloc(f32, n * n);

    for (0..n) |i| {
        for (0..n) |j| {
            a_T[i * n + j] = a[j * n + i];
        }
    }

    return a_T;
}
