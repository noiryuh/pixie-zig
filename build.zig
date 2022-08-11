const std = @import("std");

/// Path to current directory containing this 'build.zig'
pub const root_path = getRootPath();
fn getRootPath() []const u8 {
    return std.fs.path.dirname(@src().file) orelse ".";
}

pub fn build(b: *std.build.Builder) !void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    for (examples) |example| {
        const exe = b.addExecutable(example.name, example.path);
        exe.setTarget(target);
        exe.setBuildMode(mode);

        // zig fmt: off
        linkPkg(b, exe, .{.build_pixie = .{
            .check_existence = true,
            .option = .{
                .gc = .arc,
                .extra_options = &[_][]const u8{
                    "--cc:clang",
                    "--clang.exe:zig-cc",
                    "--clang.linkerexe:zig-cc",

                    // // Cross-compile for Linux Glibc
                    // "-t:-target x86_64-linux-gnu",
                    // "-t:-target x86_64-linux-gnu",
                    // "--os:linux",

                    // // Cross-compile for Linux Musl
                    // "-t:-target x86_64-linux-musl",
                    // "-t:-target x86_64-linux-musl",
                    // "--os:linux",

                    // // Cross-compile for Windows
                    // "-t:-target x86_64-windows-gnu",
                    // "-l:-target x86_64-windows-gnu",
                    // "--os:windows",
                    // "-d:mingw",

                    // // Cross-compile for Macos
                    // "-t:-target x86_64-macos",
                    // "-l:-target x86_64-macos",
                    // "--os:macosx",
                },
            },
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
        /// Check if 'pixie_ffi' exists
        check_existence: bool = false,
        /// Nim build options
        option: NimBuild = .{
            .mode = .release,
            .gc = .orc,
            .linkage = .static,
            .optimization = .speed,
        },
    },
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
            exe.addPackage(pkg);
        },
        .build_pixie => |opt| {
            if (opt.check_existence) {
                const library_paths = switch (exe.target.getOsTag()) {
                    .windows => &[_][]const u8{
                        pixie_path ++ "/libpixie_ffi.a",
                        pixie_path ++ "/libpixie_ffi.lib",
                        pixie_path ++ "/libpixie_ffi.dll",
                        pixie_path ++ "/pixie_ffi.a",
                        pixie_path ++ "/pixie_ffi.lib",
                        pixie_path ++ "/pixie_ffi.dll",
                    },
                    .macos => &[_][]const u8{
                        pixie_path ++ "/libpixie_ffi.a",
                        pixie_path ++ "/libpixie_ffi.so",
                        pixie_path ++ "/libpixie_ffi.dylib",
                        pixie_path ++ "/pixie_ffi.a",
                        pixie_path ++ "/pixie_ffi.so",
                        pixie_path ++ "/pixie_ffi.dylib",
                    },
                    else => &[_][]const u8{
                        pixie_path ++ "/libpixie_ffi.a",
                        pixie_path ++ "/libpixie_ffi.so",
                        pixie_path ++ "/pixie_ffi.a",
                        pixie_path ++ "/pixie_ffi.so",
                    },
                };

                for (library_paths) |library_path| if (checkFileExist(library_path)) {
                    exe.addLibraryPath(pixie_path);
                    exe.linkSystemLibrary("pixie_ffi");
                    exe.addPackage(pkg);
                    return;
                };
            }

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
            exe.addPackage(pkg);
        },
    }
}

fn checkFileExist(path: []const u8) bool {
    var file = std.fs.cwd().openFile(path, .{}) catch |err| switch (err) {
        error.FileNotFound => return false,
        else => unreachable,
    };
    defer file.close();

    return true;
}

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
