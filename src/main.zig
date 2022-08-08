const std = @import("std");

pub const auto_line_height = -1.0;
pub const default_miter_limit = 4.0;

extern fn pixie_check_error() callconv(.C) bool;
pub const checkError = pixie_check_error;

extern fn pixie_take_error() callconv(.C) [*:0]const u8;
pub const takeError = pixie_take_error;

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

extern fn pixie_miter_limit_to_angle(limit: f32) callconv(.C) f32;
pub const miterLimitToAngle = pixie_miter_limit_to_angle;

extern fn pixie_angle_to_miter_limit(angle: f32) callconv(.C) f32;
pub const angleToMiterLimit = pixie_angle_to_miter_limit;

pub const Vector2 = extern struct {
    const Self = @This();

    x: f32,
    y: f32,

    extern fn pixie_vector2(x: f32, y: f32) callconv(.C) Self;
    pub const init = pixie_vector2;

    extern fn pixie_vector2_eq(self: Self, other: Self) callconv(.C) bool;
    pub const eql = pixie_vector2_eq;
};

pub const Matrix3 = extern struct {
    const Self = @This();

    values: [9]f32,

    extern fn pixie_matrix3() callconv(.C) Self;
    pub const init = pixie_matrix3;

    extern fn pixie_matrix3_eq(self: Self, other: Self) callconv(.C) bool;
    pub const eql = pixie_matrix3_eq;

    extern fn pixie_matrix3_mul(self: Self, other: Self) callconv(.C) Self;
    pub const mul = pixie_matrix3_mul;

    extern fn pixie_translate(x: f32, y: f32) callconv(.C) Self;
    pub const translate = pixie_translate;

    extern fn pixie_rotate(angle: f32) callconv(.C) Self;
    pub const rotate = pixie_rotate;

    extern fn pixie_scale(x: f32, y: f32) callconv(.C) Self;
    pub const scale = pixie_scale;

    extern fn pixie_inverse(matrix: Self) callconv(.C) Self;
    pub const inverse = pixie_inverse;
};

pub const Rect = extern struct {
    const Self = @This();

    x: f32,
    y: f32,
    w: f32,
    h: f32,

    extern fn pixie_rect(x: f32, y: f32, w: f32, h: f32) callconv(.C) Self;
    pub const init = pixie_rect;

    extern fn pixie_rect_eq(self: Self, other: Self) callconv(.C) bool;
    pub const eql = pixie_rect_eq;
};

pub const Color = extern struct {
    const Self = @This();

    r: f32,
    g: f32,
    b: f32,
    a: f32,

    extern fn pixie_color(r: f32, g: f32, b: f32, a: f32) callconv(.C) Self;
    pub const init = pixie_color;

    extern fn pixie_parse_color(s: [*:0]const u8) callconv(.C) Self;
    pub const initFromString = pixie_parse_color;

    extern fn pixie_color_eq(self: Self, other: Self) callconv(.C) bool;
    pub const eql = pixie_color_eq;
};

pub const ColorStop = extern struct {
    const Self = @This();

    color: Color,
    position: f32,

    extern fn pixie_color_stop(color: Color, position: f32) callconv(.C) Self;
    pub const init = pixie_color_stop;

    extern fn pixie_color_stop_eq(self: Self, other: Self) callconv(.C) bool;
    pub const eql = pixie_color_stop_eq;
};

pub const TextMetrics = extern struct {
    const Self = @This();

    width: f32,

    extern fn pixie_text_metrics(width: f32) callconv(.C) Self;
    pub const init = pixie_text_metrics;

    extern fn pixie_text_metrics_eq(self: Self, other: Self) callconv(.C) bool;
    pub const eql = pixie_text_metrics_eq;
};

pub const ImageDimensions = extern struct {
    const Self = @This();

    width: isize,
    height: isize,

    extern fn pixie_image_dimensions(width: isize, height: isize) callconv(.C) Self;
    pub const init = pixie_image_dimensions;

    extern fn pixie_read_image_dimensions(path: [*:0]const u8) callconv(.C) Self;
    pub const initFromImage = pixie_read_image_dimensions;

    extern fn pixie_decode_image_dimensions(data: [*:0]const u8) callconv(.C) Self;
    pub const initFromMemory = pixie_decode_image_dimensions;

    extern fn pixie_image_dimensions_eq(self: Self, other: Self) callconv(.C) bool;
    pub const eql = pixie_image_dimensions_eq;
};

pub const Image = opaque {
    const Self = @This();

    extern fn pixie_new_image(width: isize, height: isize) callconv(.C) *Self;
    pub const initBlank = pixie_new_image;

    extern fn pixie_read_image(path: [*:0]const u8) callconv(.C) *Self;
    pub const initFromImage = pixie_read_image;

    extern fn pixie_decode_image(data: [*:0]const u8) callconv(.C) *Self;
    pub const initFromMemory = pixie_decode_image;

    extern fn pixie_image_unref(self: *Self) callconv(.C) void;
    pub const deinit = pixie_image_unref;

    extern fn pixie_image_write_file(self: *Self, path: [*:0]const u8) callconv(.C) void;
    pub const writeToFile = pixie_image_write_file;

    extern fn pixie_image_get_width(self: *Self) callconv(.C) isize;
    pub const getWidth = pixie_image_get_width;

    extern fn pixie_image_get_height(self: *Self) callconv(.C) isize;
    pub const getHeight = pixie_image_get_height;

    extern fn pixie_image_set_width(self: *Self, width: isize) callconv(.C) void;
    pub const setWidth = pixie_image_set_width;

    extern fn pixie_image_set_height(self: *Self, height: isize) callconv(.C) void;
    pub const setHeight = pixie_image_set_height;

    extern fn pixie_image_copy(self: *Self) callconv(.C) *Self;
    pub const copy = pixie_image_copy;

    extern fn pixie_image_resize(self: *Self, width: isize, height: isize) callconv(.C) *Self;
    pub const resize = pixie_image_resize;
};
