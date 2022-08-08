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

pub fn linkPkg(b: *std.build.Builder, exe: *std.build.LibExeObjStep, option: LinkPkgOption) void {
    const pixie_path = root_path ++ "/vendor/pixie";

    // Link '-lc' if needed
    if (!exe.is_linking_libc) {
        exe.linkLibC();
    }

    switch (option) {
        .link_pixie => |opt| {
            exe.addLibraryPath(opt.path);
        },
        .build_pixie => |opt| {
            _ = b.findProgram(
                &[_][]const u8{"nim"},
                &[_][]const u8{},
            ) catch @panic("'nim' not found");

            // Install 'pixie' via `nimble` for building FFI source
            if (opt.install_pixie) {
                _ = b.findProgram(
                    &[_][]const u8{"nimble"},
                    &[_][]const u8{},
                ) catch @panic("'nimble' not found");

                _ = b.exec(&[_][]const u8{
                    "nimble", "install", "pixie",
                }) catch @panic("failed to install 'pixie'");
            }

            // Make a build command
            const build_command = NimBuildOption.makeCommand(b.allocator, pixie_path ++ "/pixie_ffi.nim", opt.option) catch unreachable;
            defer b.allocator.free(build_command);

            _ = b.exec(build_command) catch @panic("failed to build 'pixie'");

            exe.addLibraryPath(pixie_path);
            exe.linkSystemLibrary("pixie_ffi");
        },
    }

    exe.addPackage(pkg);
}

pub const LinkPkgOption = union(enum) {
    /// Link pre-installed 'pixie'
    link_pixie: struct {
        path: []const u8,
        name: []const u8 = "pixie",
    },

    /// Build 'pixie' from source
    build_pixie: struct {
        /// Install via `nimble`
        install_pixie: bool = false,
        /// Nim build options
        option: NimBuildOption = .{},
    },
};

pub const NimBuildOption = struct {
    /// Build mode
    mode: BuildMode = .release,
    /// Garbage collector
    gc: Gc = .orc,
    /// Library linkage
    linkage: Linkage = .shared,
    /// Optimization
    optimization: Optimization = .speed,
    /// Use LTO (Link Time Optimization)
    use_lto: bool = false,
    /// Extra options
    extra_options: ?[]const []const u8 = null,

    pub fn makeCommand(allocator: std.mem.Allocator, path: []const u8, option: NimBuildOption) ![][]const u8 {
        var result = std.ArrayList([]const u8).init(allocator);
        errdefer result.deinit();

        // User must verify `nim` exists on their machine
        try result.append("nim");
        try result.append("c");

        // Prevent duplicating 'main' symbol
        try result.append("--noMain:on");

        const mode: []const u8 = switch (option.mode) {
            .debug => "-d:debug",
            .release => "-d:release",
            .danger => "-d:danger",
        };
        try result.append(mode);

        const gc: []const u8 = switch (option.gc) {
            .arc => "--gc:arc",
            .orc => "--gc:orc",
        };
        try result.append(gc);

        const linkage: []const u8 = switch (option.linkage) {
            .static => "--app:staticlib",
            .shared => "--app:lib",
        };
        try result.append(linkage);

        const optimization: []const u8 = switch (option.optimization) {
            .none => "--opt:none",
            .speed => "--opt:speed",
            .size => "--opt:size",
        };
        try result.append(optimization);

        if (option.use_lto) {
            try result.append("-d:lto");
        }

        if (option.extra_options) |extra_options| {
            try result.appendSlice(extra_options);
        }

        // Add Nim source file
        try result.append(path);

        return result.toOwnedSlice();
    }

    pub const BuildMode = enum {
        debug,
        release,
        danger,
    };

    pub const Gc = enum {
        arc,
        orc,
    };

    pub const Linkage = enum {
        static,
        shared,
    };

    pub const Optimization = enum {
        none,
        speed,
        size,
    };
};
