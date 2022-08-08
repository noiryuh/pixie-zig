const std = @import("std");

pub const auto_line_height = -1.0;
pub const default_miter_limit = 4.0;

pub const FileFormat = enum(u8) {
    png,
    bmp,
    jpg,
    gif,
    qoi,
    ppm,
};

pub const BlendMode = enum(u8) {
    normal,
    darken,
    multiply,
    color_burn,
    lighten,
    screen,
    color_dodge,
    overlay,
    soft_light,
    hard_light,
    difference,
    exclusion,
    hue,
    saturation,
    color,
    luminosity,
    mask,
    overwrite,
    subtract_mask,
    exclude_mask,
};

pub const PaintKind = enum(u8) {
    solid,
    image,
    tiled_image,
    linear_gradient,
    radial_gradient,
    angular_gradient,
};

pub const WindingRule = enum(u8) {
    non_zero,
    even_odd,
};

pub const LineCap = enum(u8) {
    butt,
    round,
    square,
};

pub const LineJoin = enum(u8) {
    miter,
    round,
    bevel,
};

pub const HorizontalAlignment = enum(u8) {
    left,
    center,
    right,
};

pub const VerticalAlignment = enum(u8) {
    top,
    middle,
    bottom,
};

pub const TextCase = enum(u8) {
    normal,
    upper,
    lower,
    title,
};

extern fn pixie_check_error() callconv(.C) bool;
pub const checkError = pixie_check_error;

extern fn pixie_take_error() callconv(.C) [*:0]const u8;
pub inline fn takeError() [:0]const u8 {
    return std.mem.span(pixie_take_error());
}

extern fn pixie_miter_limit_to_angle(limit: f32) callconv(.C) f32;
pub const miterLimitToAngle = pixie_miter_limit_to_angle;

extern fn pixie_angle_to_miter_limit(angle: f32) callconv(.C) f32;
pub const angleToMiterLimit = pixie_angle_to_miter_limit;

pub const Vector2 = extern struct {
    x: f32,
    y: f32,

    extern fn pixie_vector2(x: f32, y: f32) callconv(.C) Vector2;
    pub const init = pixie_vector2;

    extern fn pixie_vector2_eq(self: Vector2, other: Vector2) callconv(.C) bool;
    pub const eql = pixie_vector2_eq;
};

pub const Matrix3 = extern struct {
    values: [9]f32,

    extern fn pixie_matrix3() callconv(.C) Matrix3;
    pub const init = pixie_matrix3;

    extern fn pixie_matrix3_eq(self: Matrix3, other: Matrix3) callconv(.C) bool;
    pub const eql = pixie_matrix3_eq;

    extern fn pixie_matrix3_mul(self: Matrix3, other: Matrix3) callconv(.C) Matrix3;
    pub const mul = pixie_matrix3_mul;

    extern fn pixie_translate(x: f32, y: f32) callconv(.C) Matrix3;
    pub const translate = pixie_translate;

    extern fn pixie_rotate(angle: f32) callconv(.C) Matrix3;
    pub const rotate = pixie_rotate;

    extern fn pixie_scale(x: f32, y: f32) callconv(.C) Matrix3;
    pub const scale = pixie_scale;

    extern fn pixie_inverse(matrix: Matrix3) callconv(.C) Matrix3;
    pub const inverse = pixie_inverse;
};

pub const Rect = extern struct {
    x: f32,
    y: f32,
    w: f32,
    h: f32,

    extern fn pixie_rect(x: f32, y: f32, w: f32, h: f32) callconv(.C) Rect;
    pub const init = pixie_rect;

    extern fn pixie_rect_eq(self: Rect, other: Rect) callconv(.C) bool;
    pub const eql = pixie_rect_eq;
};

pub const Color = extern struct {
    r: f32,
    g: f32,
    b: f32,
    a: f32,

    extern fn pixie_color(r: f32, g: f32, b: f32, a: f32) callconv(.C) Color;
    pub const init = pixie_color;

    extern fn pixie_parse_color(s: [*:0]const u8) callconv(.C) Color;
    pub inline fn initFromString(s: [:0]const u8) Color {
        return pixie_parse_color(s.ptr);
    }

    extern fn pixie_color_eq(self: Color, other: Color) callconv(.C) bool;
    pub const eql = pixie_color_eq;
};

pub const ColorStop = extern struct {
    color: Color,
    position: f32,

    extern fn pixie_color_stop(color: Color, position: f32) callconv(.C) ColorStop;
    pub const init = pixie_color_stop;

    extern fn pixie_color_stop_eq(self: ColorStop, other: ColorStop) callconv(.C) bool;
    pub const eql = pixie_color_stop_eq;
};

pub const TextMetrics = extern struct {
    width: f32,

    extern fn pixie_text_metrics(width: f32) callconv(.C) TextMetrics;
    pub const init = pixie_text_metrics;

    extern fn pixie_text_metrics_eq(self: TextMetrics, other: TextMetrics) callconv(.C) bool;
    pub const eql = pixie_text_metrics_eq;
};

pub const ImageDimensions = extern struct {
    width: isize,
    height: isize,

    extern fn pixie_image_dimensions(width: isize, height: isize) callconv(.C) ImageDimensions;
    pub const init = pixie_image_dimensions;

    extern fn pixie_read_image_dimensions(path: [*:0]const u8) callconv(.C) ImageDimensions;
    pub inline fn initFromImage(path: [:0]const u8) ImageDimensions {
        return pixie_read_image_dimensions(path.ptr);
    }

    extern fn pixie_decode_image_dimensions(data: [*:0]const u8) callconv(.C) ImageDimensions;
    pub inline fn initFromMemory(data: [:0]const u8) ImageDimensions {
        return pixie_decode_image_dimensions(data.ptr);
    }

    extern fn pixie_image_dimensions_eq(self: ImageDimensions, other: ImageDimensions) callconv(.C) bool;
    pub const eql = pixie_image_dimensions_eq;
};

pub const Image = opaque {
    extern fn pixie_new_image(width: isize, height: isize) callconv(.C) *Image;
    pub const initBlank = pixie_new_image;

    extern fn pixie_read_image(path: [*:0]const u8) callconv(.C) *Image;
    pub inline fn initFromImage(path: [:0]const u8) *Image {
        return pixie_read_image(path.ptr);
    }

    extern fn pixie_decode_image(data: [*:0]const u8) callconv(.C) *Image;
    pub inline fn initFromMemory(data: [:0]const u8) *Image {
        return pixie_decode_image(data.ptr);
    }

    extern fn pixie_image_unref(self: *Image) callconv(.C) void;
    pub const deinit = pixie_image_unref;

    extern fn pixie_image_write_file(self: *Image, path: [*:0]const u8) callconv(.C) void;
    pub inline fn writeToFile(self: *Image, path: [:0]const u8) void {
        return pixie_image_write_file(self, path.ptr);
    }

    extern fn pixie_image_get_width(self: *Image) callconv(.C) isize;
    pub const getWidth = pixie_image_get_width;

    extern fn pixie_image_get_height(self: *Image) callconv(.C) isize;
    pub const getHeight = pixie_image_get_height;

    extern fn pixie_image_set_width(self: *Image, width: isize) callconv(.C) void;
    pub const setWidth = pixie_image_set_width;

    extern fn pixie_image_set_height(self: *Image, height: isize) callconv(.C) void;
    pub const setHeight = pixie_image_set_height;

    extern fn pixie_image_copy(self: *Image) callconv(.C) *Image;
    pub const copy = pixie_image_copy;

    extern fn pixie_image_resize(self: *Image, width: isize, height: isize) callconv(.C) *Image;
    pub const resize = pixie_image_resize;
};
