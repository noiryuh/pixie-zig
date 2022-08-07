const std = @import("std");

/// Path to current directory containing this 'build.zig'
pub const root_path = getRootPath();
fn getRootPath() []const u8 {
    return std.fs.path.dirname(@src().file) orelse ".";
}

pub fn build(b: *std.build.Builder) void {
    _ = b;
}
