const std = @import("std");
const pixie = @import("pixie-zig");

pub fn main() !void {
    var img = pixie.Image.init(200, 200);
    defer img.deinit();
    img.fill(.{ .r = 1, .g = 1, .b = 1, .a = 1 });

    var paint = pixie.Paint.init(.radial_gradient);
    defer paint.deinit();

    paint.appendGradientHandlePositions(.{ .x = 100, .y = 100 });
    paint.appendGradientHandlePositions(.{ .x = 200, .y = 100 });
    paint.appendGradientHandlePositions(.{ .x = 100, .y = 200 });

    paint.appendGradientStops(.{
        .color = .{ .r = 1, .g = 0, .b = 0, .a = 1 },
        .position = 0,
    });
    paint.appendGradientStops(.{
        .color = .{ .r = 1, .g = 0, .b = 0, .a = 0.15625 },
        .position = 1,
    });

    var path = pixie.Path.parseFromString(
        \\M 20 60
        \\A 40 40 90 0 1 100 60
        \\A 40 40 90 0 1 180 60
        \\Q 180 120 100 180
        \\Q 20 120 20 60
        \\z
    );
    defer path.deinit();

    img.fillPath(path, paint, pixie.Matrix3.identity(), .non_zero);
    img.writeToFile("gradient_heart.png");
}
