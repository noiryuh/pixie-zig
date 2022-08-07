const std = @import("std");

/// Path to current directory containing this 'build.zig'
pub const root_path = getRootPath();
fn getRootPath() []const u8 {
    return std.fs.path.dirname(@src().file) orelse ".";
}

pub fn build(b: *std.build.Builder) void {
    _ = b;
}

// ========================================
// Package SDK
// ========================================

pub const pkg = std.build.Pkg{
    .name = "pixie-zig",
    .source = .{ .path = root_path ++ "/src/main.zig" },
};

pub fn linkPkg(_: *std.build.Builder, exe: *std.build.LibExeObjStep, option: LinkPkgOption) void {
    if (!exe.is_linking_libc) {
        exe.linkLibC();
    }

    exe.addLibraryPath(option.path);
    exe.linkSystemLibrary("pixie");

    exe.addPackage(pkg);
}

pub const LinkPkgOption = struct {
    /// Path to library
    path: []const u8,
};
