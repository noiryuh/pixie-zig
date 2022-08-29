const std = @import("std");
const pixie = @import("pixie-zig");

pub fn main() !void {
    var img = try pixie.Image.init(200, 200);
    defer img.deinit();
    img.fill(.{ .r = 1, .g = 1, .b = 1, .a = 1 });

    var ctx = try pixie.Context.initFromImage(img);
    defer ctx.deinit();

    var paint = pixie.Paint.init(.solid);
    defer paint.deinit();
    paint.setColor(.{ .r = 1, .g = 0, .b = 0, .a = 1 });

    ctx.setFillStyle(paint);
    try ctx.fillRect(50, 50, 100, 100);

    try img.writeToFile("square.png");
}
