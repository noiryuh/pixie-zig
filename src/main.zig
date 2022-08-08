const std = @import("std");

pub const auto_line_height = -1.0;
pub const default_miter_limit = 4.0;

/// Check if any error occurred
pub const checkError = pixie_check_error;
extern fn pixie_check_error() callconv(.C) bool;

/// Return error message and clear current error
pub const takeError = pixie_take_error;
extern fn pixie_take_error() callconv(.C) [*:0]const u8;

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

pub const Vector2 = extern struct {
    const Self = @This();

    x: f32,
    y: f32,

    pub const init = pixie_vector2;
    extern fn pixie_vector2(x: f32, y: f32) callconv(.C) Self;

    pub const eql = pixie_vector2_eq;
    extern fn pixie_vector2_eq(self: Self, other: Self) callconv(.C) bool;
};

pub const Matrix3 = extern struct {
    const Self = @This();

    values: [9]f32,

    pub const init = pixie_matrix3;
    extern fn pixie_matrix3() callconv(.C) Self;

    pub const eql = pixie_matrix3_eq;
    extern fn pixie_matrix3_eq(self: Self, other: Self) callconv(.C) bool;

    pub const mul = pixie_matrix3_mul;
    extern fn pixie_matrix3_mul(self: Self, other: Self) callconv(.C) Self;
};

pub const Rect = extern struct {
    const Self = @This();

    x: f32,
    y: f32,
    w: f32,
    h: f32,

    pub const init = pixie_rect;
    extern fn pixie_rect(x: f32, y: f32, w: f32, h: f32) callconv(.C) Self;

    pub const eql = pixie_rect_eq;
    extern fn pixie_rect_eq(self: Self, other: Self) callconv(.C) bool;
};

pub const Color = extern struct {
    const Self = @This();

    r: f32,
    g: f32,
    b: f32,
    a: f32,

    pub const init = pixie_color;
    extern fn pixie_color(r: f32, g: f32, b: f32, a: f32) callconv(.C) Self;

    pub const eql = pixie_color_eq;
    extern fn pixie_color_eq(self: Self, other: Self) callconv(.C) bool;
};

pub const ColorStop = extern struct {
    const Self = @This();

    color: Color,
    position: f32,

    pub const init = pixie_color_stop;
    extern fn pixie_color_stop(color: Color, position: f32) callconv(.C) Self;

    pub const eql = pixie_color_stop_eq;
    extern fn pixie_color_stop_eq(self: Self, other: Self) callconv(.C) bool;
};

pub const TextMetrics = extern struct {
    const Self = @This();

    width: f32,

    pub const init = pixie_text_metrics;
    extern fn pixie_text_metrics(width: f32) callconv(.C) Self;

    pub const eql = pixie_text_metrics_eq;
    extern fn pixie_text_metrics_eq(self: Self, other: Self) callconv(.C) bool;
};

pub const ImageDimensions = extern struct {
    const Self = @This();

    width: isize,
    height: isize,

    pub const init = pixie_image_dimensions;
    extern fn pixie_image_dimensions(width: isize, height: isize) callconv(.C) Self;

    pub const eql = pixie_image_dimensions_eq;
    extern fn pixie_image_dimensions_eq(self: Self, other: Self) callconv(.C) bool;
};
