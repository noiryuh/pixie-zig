const std = @import("std");

/// Path to current directory containing this 'build.zig'
pub const root_path = getRootPath();
fn getRootPath() []const u8 {
    return std.fs.path.dirname(@src().file) orelse ".";
}

pub fn build(b: *std.build.Builder) !void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const build_command = try NimBuild.makeCommand(b.allocator, root_path ++ "/vendor/pixie/pixie_ffi.nim", .{
        .mode = .release,
        .gc = .arc,
        .linkage = .static,
        .optimization = .speed,
        .extra_options = &[_][]const u8{
            "--cc=clang",
            "--clang.exe=zig-cc",
            "--clang.linkerexe=zig-cc",

            // // Cross-compile to windows mingw
            // "-t:-target x86_64-windows-gnu",
            // "-l:-target x86_64-windows-gnu",
            // "--os:windows",
            // "-d:mingw",
        },
    });
    defer b.allocator.free(build_command);
    _ = b.exec(build_command) catch @panic("failed to build 'pixie'");

    for (examples) |example| {
        const exe = b.addExecutable(example.name, example.path);
        exe.setTarget(target);
        exe.setBuildMode(mode);

        // zig fmt: off
        linkPkg(b, exe, .{.link_pixie = .{
            .name = "pixie_ffi",
            .path = root_path ++ "/vendor/pixie",
        }});
        // zig fmt: on

        exe.install();
    }
}

const Example = struct {
    name: []const u8,
    path: []const u8,
};

const examples = [_]Example{
    Example{
        .name = "square",
        .path = root_path ++ "/example/square.zig",
    },
    Example{
        .name = "gradient_heart",
        .path = root_path ++ "/example/gradient_heart.zig",
    },
};

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
            exe.linkSystemLibrary(opt.name);
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
            const build_command = NimBuild.makeCommand(b.allocator, pixie_path ++ "/pixie_ffi.nim", opt.option) catch unreachable;
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
        option: NimBuild = .{},
    },
};

pub const NimBuild = struct {
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

    pub fn makeCommand(allocator: std.mem.Allocator, path: []const u8, option: NimBuild) ![][]const u8 {
        var result = std.ArrayList([]const u8).init(allocator);
        errdefer result.deinit();

        // User must verify `nim` exists on their machine
        try result.append("nim");
        try result.append("c");

        // Prevent duplicating 'main' symbol
        try result.append("--noMain:on");

        // Add build mode
        try result.append(switch (option.mode) {
            .debug => "-d:debug",
            .release => "-d:release",
            .danger => "-d:danger",
        });

        // Choose garbage collector
        try result.append(switch (option.gc) {
            .arc => "--gc:arc",
            .orc => "--gc:orc",
        });

        // Choose library linkage
        try result.append(switch (option.linkage) {
            .static => "--app:staticlib",
            .shared => "--app:lib",
        });

        // Add optimization
        try result.append(switch (option.optimization) {
            .none => "--opt:none",
            .speed => "--opt:speed",
            .size => "--opt:size",
        });

        // Use LTO if enabled
        if (option.use_lto) {
            try result.append("-d:lto");
        }

        // Add extra options
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
