# pixie-zig

Zig wrapper for [pixie](https://github.com/treeform/pixie), a full-featured 2D graphics library written in Nim.


## Building

In `build.zig`. *(for cross-compiling, copy the `// Cross-compile` section and use `zig build -Dtarget=arch-os-abi` like `-target` in below example)*
```zig
const std = @import("std");
const pixie = @import("pixie-zig/build.zig");

pub fn build(b: *std.build.Builder) void {
    // If you prefer building from source
    // Make sure you already have `nim` (and `nimble`) in $PATH
    pixie.linkPkg(b, exe, .{.build_pixie = .{
        .install_pixie = true, // Run `nimble install pixie` for building 'pixie_ffi.nim'
        .option = .{
            // If you prefer using `zig cc`
            .extra_options = &[_][]const u8{
                "--cc:clang",
                "--clang.exe=zig-cc",        // Make sure you already have a `zig cc` wrapper in $PATH
                "--clang.linkerexe=zig-cc",  // because if not, Nim will find a program called `zig\ cc`

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

    // If you prefer linking with shared/static library
    // or already have pre-installed library
    pixie.linkPkg(b, exe, .{.link_pixie = .{
        .path = "/path/to/directory/containing/libpixie.*", // .so, .dll, .dylib
    }});
}
```


## Usage

In `src/main.zig`
```zig
const std = @import("std");
const pixie = @import("pixie-zig");

pub fn main() !void {
    var img = pixie.Image.initBlank(128, 128);
    defer img.deinit();

    // Fill entire image with provided color
    img.fill(.{
        .r = 0.12,
        .g = 0.76,
        .b = 0.34,
        .a = 1.00,
    });

    // Write image to file
    img.writeToFile("image.png");
}
```


## Credit

Thank you [treeform](https://github.com/treeform) for writing this library.
