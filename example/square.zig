const std = @import("std");
const pixie = @import("pixie-zig");

pub fn main() !void {
    var image = pixie.Image.init(200, 200);
    defer image.deinit();
    image.fill(.{ .r = 1, .g = 1, .b = 1, .a = 1 });

    var context = pixie.Context.initFromImage(image);
    defer context.deinit();

    var paint = pixie.Paint.init(.solid);
    defer paint.deinit();
    paint.setColor(.{ .r = 1, .g = 0, .b = 0, .a = 1 });

    context.setFillStyle(paint);
    context.fillRect(50, 50, 100, 100);

    image.writeToFile("square.png");
}
