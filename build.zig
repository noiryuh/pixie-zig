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
    if (option.build_pixie) {
        _ = b.findProgram(
            &[_][]const u8{"nim"},
            &[_][]const u8{},
        ) catch @panic("'nim' not found");

        if (option.install_pixie) {
            _ = b.findProgram(
                &[_][]const u8{"nimble"},
                &[_][]const u8{},
            ) catch @panic("'nimble' not found");

            // zig fmt: off
            _ = b.exec(&[_][]const u8{
                "nimble", "install", "pixie"
            }) catch @panic("failed to install 'pixie'");
            // zig fmt: on
        }

        const out_dir = std.mem.concat(b.allocator, &[_][]const u8{ "--outdir:", option.library_path });

        const name = switch (option.linkage) {
            .static => "libpixie.a",
            .shared => switch (exe.target.getOsTag()) {
                .windows => "--out:libpixie.dll",
                .macos => "--out:libpixie.dylic",
                else => "--out:libpixie.so",
            },
        };

        const mode = switch (option.mode) {
            .debug => "-d:debug",
            .release => "-d:release",
            .danger => "-d:danger",
        };

        const gc = switch (option.gc) {
            .arc => "--gc:arc",
            .orc => "--gc:orc",
        };

        const linkage = switch (option.linkage) {
            .static => "--app:staticlib",
            .shared => "--app:lib",
        };

        const optimization = switch (option.optimization) {
            .none => "--opt:none",
            .speed => "--opt:speed",
            .size => "--opt:size",
        };

        const use_lto = if (option.use_lto) "-d:lto" else "";

        // zig fmt: off
        _ = b.exec(&[_][]const u8{
            "nim", "c", linkage, "--noMain:on", out_dir, name,
            mode, gc, optimization, use_lto, "--tlsEmulation:off",
            root_path ++ "/vendor/pixie/pixie_ffi.nim",
        }) catch @panic("failed to build 'pixie'");
        // zig fmt: on
    }

    // Link '-lc' if needed
    if (!exe.is_linking_libc) {
        exe.linkLibC();
    }

    exe.addLibraryPath(option.library_path);
    exe.linkSystemLibrary("pixie");

    exe.addPackage(pkg);
}

pub const LinkPkgOption = struct {
    /// Path to 'pixie' library
    library_path: []const u8,
    /// Nim building options
    mode: BuildMode = .release,
    use_lto: bool = true,
    gc: Gc = .orc,
    linkage: Linkage = .static,
    optimization: Optimization = .speed,
    /// Pixie building options
    build_pixie: bool = true,
    install_pixie: bool = false,

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
        size,
        speed,
    };
};
