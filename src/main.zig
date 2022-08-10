const std = @import("std");

pub const auto_line_height = -1.0;
pub const default_miter_limit = 4.0;

pub const FileFormat = enum(u8) {
    png = 0,
    bmp = 1,
    jpg = 2,
    gif = 3,
    qoi = 4,
    ppm = 5,
};

pub const BlendMode = enum(u8) {
    normal = 0,
    darken = 1,
    multiply = 2,
    color_burn = 3,
    lighten = 4,
    screen = 5,
    color_dodge = 6,
    overlay = 7,
    soft_light = 8,
    hard_light = 9,
    difference = 10,
    exclusion = 11,
    hue = 12,
    saturation = 13,
    color = 14,
    luminosity = 15,
    mask = 16,
    overwrite = 17,
    subtract_mask = 18,
    exclude_mask = 19,
};

pub const PaintKind = enum(u8) {
    solid = 0,
    image = 1,
    tiled_image = 2,
    linear_gradient = 3,
    radial_gradient = 4,
    angular_gradient = 5,
};

pub const WindingRule = enum(u8) {
    non_zero = 0,
    even_odd = 1,
};

pub const LineCap = enum(u8) {
    butt = 0,
    round = 1,
    square = 2,
};

pub const LineJoin = enum(u8) {
    miter = 0,
    round = 1,
    bevel = 2,
};

pub const HorizontalAlignment = enum(u8) {
    left = 0,
    center = 1,
    right = 2,
};

pub const VerticalAlignment = enum(u8) {
    top = 0,
    middle = 1,
    bottom = 2,
};

pub const TextCase = enum(u8) {
    normal = 0,
    upper = 1,
    lower = 2,
    title = 3,
};

extern fn pixie_check_error() callconv(.C) bool;
pub inline fn checkError() bool {
    return pixie_check_error();
}

extern fn pixie_take_error() callconv(.C) [*:0]const u8;
pub inline fn takeError() [:0]const u8 {
    return std.mem.span(pixie_take_error());
}

pub const Vector2 = extern struct {
    x: f32,
    y: f32,

    extern fn pixie_vector2_eq(self: Vector2, other: Vector2) callconv(.C) bool;
    pub inline fn eql(self: Vector2, other: Vector2) bool {
        return pixie_vector2_eq(self, other);
    }
};

pub const Matrix3 = extern struct {
    values: [9]f32,

    extern fn pixie_matrix3_eq(self: Matrix3, other: Matrix3) callconv(.C) bool;
    pub inline fn eql(self: Matrix3, other: Matrix3) bool {
        return pixie_matrix3_eq(self, other);
    }

    extern fn pixie_matrix3_mul(self: Matrix3, other: Matrix3) callconv(.C) Matrix3;
    pub inline fn mul(self: Matrix3, other: Matrix3) Matrix3 {
        return pixie_matrix3_mul(self, other);
    }

    extern fn pixie_matrix3() callconv(.C) Matrix3;
    pub inline fn identity() Matrix3 {
        return pixie_matrix3();
    }

    extern fn pixie_translate(x: f32, y: f32) callconv(.C) Matrix3;
    pub inline fn translate(x: f32, y: f32) Matrix3 {
        return pixie_translate(x, y);
    }

    extern fn pixie_rotate(angle: f32) callconv(.C) Matrix3;
    pub inline fn rotate(angle: f32) Matrix3 {
        return pixie_rotate(angle);
    }

    extern fn pixie_scale(x: f32, y: f32) callconv(.C) Matrix3;
    pub inline fn scale(x: f32, y: f32) Matrix3 {
        return pixie_scale(x, y);
    }

    extern fn pixie_inverse(m: Matrix3) callconv(.C) Matrix3;
    pub inline fn inverse(m: Matrix3) Matrix3 {
        return pixie_inverse(m);
    }
};

pub const Rect = extern struct {
    x: f32,
    y: f32,
    w: f32,
    h: f32,

    extern fn pixie_rect_eq(self: Rect, other: Rect) callconv(.C) bool;
    pub inline fn eql(self: Rect, other: Rect) bool {
        return pixie_rect_eq(self, other);
    }

    extern fn pixie_snap_to_pixels(rect: Rect) callconv(.C) Rect;
    pub inline fn snapToPixels(rect: Rect) Rect {
        return pixie_snap_to_pixels(rect);
    }
};

pub const Color = extern struct {
    r: f32,
    g: f32,
    b: f32,
    a: f32,

    extern fn pixie_color_eq(self: Color, other: Color) callconv(.C) bool;
    pub inline fn eql(self: Color, other: Color) bool {
        return pixie_color_eq(self, other);
    }

    extern fn pixie_parse_color(s: [*:0]const u8) callconv(.C) Color;
    pub inline fn parseFromString(s: [:0]const u8) Color {
        return pixie_parse_color(s.ptr);
    }

    extern fn pixie_mix(a: Color, b: Color, v: f32) callconv(.C) Color;
    /// Mixes two Color colors together using simple lerp.
    pub inline fn mix(a: Color, b: Color, v: f32) Color {
        return pixie_mix(a, b, v);
    }
};

pub const ColorStop = extern struct {
    color: Color,
    position: f32,

    extern fn pixie_color_stop_eq(self: ColorStop, other: ColorStop) callconv(.C) bool;
    pub inline fn eql(self: ColorStop, other: ColorStop) bool {
        return pixie_color_stop_eq(self, other);
    }
};

pub const TextMetrics = extern struct {
    width: f32,

    extern fn pixie_text_metrics_eq(self: TextMetrics, other: TextMetrics) callconv(.C) bool;
    pub inline fn eql(self: TextMetrics, other: TextMetrics) bool {
        return pixie_text_metrics_eq(self, other);
    }
};

pub const ImageDimensions = extern struct {
    width: isize,
    height: isize,

    extern fn pixie_image_dimensions_eq(self: ImageDimensions, other: ImageDimensions) callconv(.C) bool;
    pub inline fn eql(self: ImageDimensions, other: ImageDimensions) bool {
        return pixie_image_dimensions_eq(self, other);
    }

    extern fn pixie_read_image_dimensions(path: [*:0]const u8) callconv(.C) ImageDimensions;
    /// Decodes an image's dimensions from a file.
    pub inline fn loadFromFile(file_path: [:0]const u8) ImageDimensions {
        return pixie_read_image_dimensions(file_path.ptr);
    }

    extern fn pixie_decode_image_dimensions(data: [*:0]const u8) callconv(.C) ImageDimensions;
    /// Decodes an image's dimensions from memory.
    pub inline fn loadFromMemory(data: [:0]const u8) ImageDimensions {
        return pixie_decode_image_dimensions(data.ptr);
    }
};

pub const SeqFloat32 = opaque {
    extern fn pixie_seq_float32_unref(self: *SeqFloat32) callconv(.C) void;
    pub inline fn deinit(self: *SeqFloat32) void {
        return pixie_seq_float32_unref(self);
    }

    extern fn pixie_new_seq_float32() callconv(.C) *SeqFloat32;
    pub inline fn init() *SeqFloat32 {
        return pixie_new_seq_float32();
    }

    extern fn pixie_seq_float32_len(self: *SeqFloat32) callconv(.C) isize;
    pub inline fn len(self: *SeqFloat32) isize {
        return pixie_seq_float32_len(self);
    }

    extern fn pixie_seq_float32_get(self: *SeqFloat32, index: isize) callconv(.C) f32;
    pub inline fn get(self: *SeqFloat32, index: isize) f32 {
        return pixie_seq_float32_get(self, index);
    }

    extern fn pixie_seq_float32_set(self: *SeqFloat32, index: isize, value: f32) callconv(.C) void;
    pub inline fn set(self: *SeqFloat32, index: isize, value: f32) void {
        return pixie_seq_float32_set(self, index, value);
    }

    extern fn pixie_seq_float32_add(self: *SeqFloat32, value: f32) callconv(.C) void;
    pub inline fn append(self: *SeqFloat32, value: f32) void {
        return pixie_seq_float32_add(self, value);
    }

    extern fn pixie_seq_float32_delete(self: *SeqFloat32, index: isize) callconv(.C) void;
    pub inline fn orderedRemove(self: *SeqFloat32, index: isize) void {
        return pixie_seq_float32_delete(self, index);
    }

    extern fn pixie_seq_float32_clear(self: *SeqFloat32) callconv(.C) void;
    pub inline fn clear(self: *SeqFloat32) void {
        return pixie_seq_float32_clear(self);
    }
};

pub const SeqSpan = opaque {
    extern fn pixie_seq_span_unref(self: *SeqSpan) callconv(.C) void;
    pub inline fn deinit(self: *SeqSpan) void {
        return pixie_seq_span_unref(self);
    }

    extern fn pixie_new_seq_span() callconv(.C) *SeqSpan;
    pub inline fn init() *SeqSpan {
        return pixie_new_seq_span();
    }

    extern fn pixie_seq_span_len(self: *SeqSpan) callconv(.C) isize;
    pub inline fn len(self: *SeqSpan) isize {
        return pixie_seq_span_len(self);
    }

    extern fn pixie_seq_span_get(self: *SeqSpan, index: isize) callconv(.C) *Span;
    pub inline fn get(self: *SeqSpan, index: isize) *Span {
        return pixie_seq_span_get(self, index);
    }

    extern fn pixie_seq_span_set(self: *SeqSpan, index: isize, value: *Span) callconv(.C) void;
    pub inline fn set(self: *SeqSpan, index: isize, value: *Span) void {
        return pixie_seq_span_set(self, index, value);
    }

    extern fn pixie_seq_span_add(self: *SeqSpan, value: *Span) callconv(.C) void;
    pub inline fn append(self: *SeqSpan, value: *Span) void {
        return pixie_seq_span_add(self, value);
    }

    extern fn pixie_seq_span_delete(self: *SeqSpan, index: isize) callconv(.C) void;
    pub inline fn orderedRemove(self: *SeqSpan, index: isize) void {
        return pixie_seq_span_delete(self, index);
    }

    extern fn pixie_seq_span_clear(self: *SeqSpan) callconv(.C) void;
    pub inline fn clear(self: *SeqSpan) void {
        return pixie_seq_span_clear(self);
    }

    extern fn pixie_seq_span_typeset(self: *SeqSpan, bounds: Vector2, h_align: HorizontalAlignment, v_align: VerticalAlignment, wrap: bool) callconv(.C) *Arrangement;
    /// Lays out the character glyphs and returns the arrangement.
    /// Optional parameters:
    /// bounds: width determines wrapping and hAlign, height for vAlign
    /// hAlign: horizontal alignment of the text
    /// vAlign: vertical alignment of the text
    /// wrap: enable/disable text wrapping
    pub inline fn typeset(self: *SeqSpan, bounds: Vector2, h_align: HorizontalAlignment, v_align: VerticalAlignment, wrap: bool) *Arrangement {
        return pixie_seq_span_typeset(self, bounds, h_align, v_align, wrap);
    }

    extern fn pixie_seq_span_layout_bounds(self: *SeqSpan) callconv(.C) Vector2;
    /// Computes the width and height of the spans in pixels.
    pub inline fn layoutBounds(self: *SeqSpan) Vector2 {
        return pixie_seq_span_layout_bounds(self);
    }
};

pub const Image = opaque {
    extern fn pixie_image_unref(self: *Image) callconv(.C) void;
    pub inline fn deinit(self: *Image) void {
        return pixie_image_unref(self);
    }

    extern fn pixie_new_image(width: isize, height: isize) callconv(.C) *Image;
    /// Creates a new image with the parameter dimensions.
    pub inline fn init(width: isize, height: isize) *Image {
        return pixie_new_image(width, height);
    }

    extern fn pixie_image_get_width(self: *Image) callconv(.C) isize;
    pub inline fn getWidth(self: *Image) isize {
        return pixie_image_get_width(self);
    }

    extern fn pixie_image_set_width(self: *Image, value: isize) callconv(.C) void;
    pub inline fn setWidth(self: *Image, value: isize) void {
        return pixie_image_set_width(self, value);
    }

    extern fn pixie_image_get_height(self: *Image) callconv(.C) isize;
    pub inline fn getHeight(self: *Image) isize {
        return pixie_image_get_height(self);
    }

    extern fn pixie_image_set_height(self: *Image, value: isize) callconv(.C) void;
    pub inline fn setHeight(self: *Image, value: isize) void {
        return pixie_image_set_height(self, value);
    }

    extern fn pixie_image_write_file(self: *Image, file_path: [*:0]const u8) callconv(.C) void;
    /// Writes an image to a file.
    pub inline fn writeToFile(self: *Image, file_path: [:0]const u8) void {
        return pixie_image_write_file(self, file_path.ptr);
    }

    extern fn pixie_decode_image(data: [*:0]const u8) callconv(.C) *Image;
    /// Loads an image from memory.
    pub inline fn loadFromMemory(data: [:0]const u8) *Image {
        return pixie_decode_image(data.ptr);
    }

    extern fn pixie_read_image(file_path: [*:0]const u8) callconv(.C) *Image;
    /// Loads an image from a file.
    pub inline fn loadFromFile(file_path: [:0]const u8) *Image {
        return pixie_read_image(file_path.ptr);
    }

    extern fn pixie_image_copy(self: *Image) callconv(.C) *Image;
    /// Copies the image data into a new image.
    pub inline fn copy(self: *Image) *Image {
        return pixie_image_copy(self);
    }

    extern fn pixie_image_get_color(self: *Image, x: isize, y: isize) callconv(.C) Color;
    /// Gets a color at (x, y) or returns transparent black if outside of bounds.
    pub inline fn getColor(self: *Image, x: isize, y: isize) Color {
        return pixie_image_get_color(self, x, y);
    }

    extern fn pixie_image_set_color(self: *Image, x: isize, y: isize, color: Color) callconv(.C) void;
    /// Sets a color at (x, y) or does nothing if outside of bounds.
    pub inline fn setColor(self: *Image, x: isize, y: isize, color: Color) void {
        return pixie_image_set_color(self, x, y, color);
    }

    extern fn pixie_image_fill(self: *Image, color: Color) callconv(.C) void;
    /// Fills the image with the color.
    pub inline fn fill(self: *Image, color: Color) void {
        return pixie_image_fill(self, color);
    }

    extern fn pixie_image_paint_fill(self: *Image, paint: *Paint) callconv(.C) void;
    /// Fills the image with the paint.
    pub inline fn fillPaint(self: *Image, paint: *Paint) void {
        return pixie_image_paint_fill(self, paint);
    }

    extern fn pixie_image_is_one_color(self: *Image) callconv(.C) bool;
    /// Checks if the entire image is the same color.
    pub inline fn isOneColor(self: *Image) bool {
        return pixie_image_is_one_color(self);
    }

    extern fn pixie_image_is_transparent(self: *Image) callconv(.C) bool;
    /// Checks if this image is fully transparent or not.
    pub inline fn isTransparent(self: *Image) bool {
        return pixie_image_is_transparent(self);
    }

    extern fn pixie_image_is_opaque(self: *Image) callconv(.C) bool;
    /// Checks if the entire image is opaque (alpha values are all 255).
    pub inline fn isOpaque(self: *Image) bool {
        return pixie_image_is_opaque(self);
    }

    extern fn pixie_image_flip_horizontal(self: *Image) callconv(.C) void;
    /// Flips the image around the Y axis.
    pub inline fn flipHorizontal(self: *Image) void {
        return pixie_image_flip_horizontal(self);
    }

    extern fn pixie_image_flip_vertical(self: *Image) callconv(.C) void;
    /// Flips the image around the X axis.
    pub inline fn flipVertical(self: *Image) void {
        return pixie_image_flip_vertical(self);
    }

    extern fn pixie_image_rotate90(self: *Image) callconv(.C) void;
    /// Rotates the image 90 degrees clockwise.
    pub inline fn rotate90(self: *Image) void {
        return pixie_image_rotate90(self);
    }

    extern fn pixie_image_sub_image(self: *Image, x: isize, y: isize, w: isize, h: isize) callconv(.C) *Image;
    /// Gets a sub image from this image.
    pub inline fn subImage(self: *Image, x: isize, y: isize, w: isize, h: isize) *Image {
        return pixie_image_sub_image(self, x, y, w, h);
    }

    extern fn pixie_image_rect_sub_image(self: *Image, rect: Rect) callconv(.C) *Image;
    /// Gets a sub image from this image via rectangle.
    /// Rectangle is snapped/expanded to whole pixels first.
    pub inline fn subImageRect(self: *Image, rect: Rect) *Image {
        return pixie_image_rect_sub_image(self, rect);
    }

    extern fn pixie_image_minify_by2(self: *Image, power: isize) callconv(.C) *Image;
    /// Scales the image down by an integer scale.
    pub inline fn minifyBy2(self: *Image, power: isize) *Image {
        return pixie_image_minify_by2(self, power);
    }

    extern fn pixie_image_magnify_by2(self: *Image, power: isize) callconv(.C) *Image;
    /// Scales image up by 2 ^ power.
    pub inline fn magnifyBy2(self: *Image, power: isize) *Image {
        return pixie_image_magnify_by2(self, power);
    }

    extern fn pixie_image_apply_opacity(self: *Image, opacity: f32) callconv(.C) void;
    /// Multiplies alpha of the image by opacity.
    pub inline fn applyOpacity(self: *Image, opacity: f32) void {
        return pixie_image_apply_opacity(self, opacity);
    }

    extern fn pixie_image_invert(self: *Image) callconv(.C) void;
    /// Inverts all of the colors and alpha.
    pub inline fn invert(self: *Image) void {
        return pixie_image_invert(self);
    }

    extern fn pixie_image_ceil(self: *Image) callconv(.C) void;
    /// A value of 0 stays 0. Anything else turns into 255.
    pub inline fn ceil(self: *Image) void {
        return pixie_image_ceil(self);
    }

    extern fn pixie_image_blur(self: *Image, radius: f32, out_of_bounds: Color) callconv(.C) void;
    /// Applies Gaussian blur to the image given a radius.
    pub inline fn blur(self: *Image, radius: f32, out_of_bounds: Color) void {
        return pixie_image_blur(self, radius, out_of_bounds);
    }

    extern fn pixie_image_resize(self: *Image, width: isize, height: isize) callconv(.C) *Image;
    /// Resize an image to a given height and width.
    pub inline fn resize(self: *Image, width: isize, height: isize) *Image {
        return pixie_image_resize(self, width, height);
    }

    extern fn pixie_image_shadow(self: *Image, offset: Vector2, spread: f32, blur_value: f32, color: Color) callconv(.C) *Image;
    /// Create a shadow of the image with the offset, spread and blur.
    pub inline fn shadow(self: *Image, offset: Vector2, spread: f32, blur_value: f32, color: Color) *Image {
        return pixie_image_shadow(self, offset, spread, blur_value, color);
    }

    extern fn pixie_image_super_image(self: *Image, x: isize, y: isize, w: isize, h: isize) callconv(.C) *Image;
    /// Either cuts a sub image or returns a super image with padded transparency.
    pub inline fn superImage(self: *Image, x: isize, y: isize, w: isize, h: isize) *Image {
        return pixie_image_super_image(self, x, y, w, h);
    }

    extern fn pixie_image_draw(self: *Image, b: *Image, transform_value: Matrix3, blend_mode: BlendMode) callconv(.C) void;
    /// Draws one image onto another using a matrix transform and color blending.
    pub inline fn draw(self: *Image, b: *Image, transform_value: Matrix3, blend_mode: BlendMode) void {
        return pixie_image_draw(self, b, transform_value, blend_mode);
    }

    extern fn pixie_image_fill_gradient(self: *Image, paint: *Paint) callconv(.C) void;
    /// Fills with the Paint gradient.
    pub inline fn fillGradient(self: *Image, paint: *Paint) void {
        return pixie_image_fill_gradient(self, paint);
    }

    extern fn pixie_image_fill_text(self: *Image, font: *Font, text: [*:0]const u8, transform_value: Matrix3, bounds: Vector2, h_align: HorizontalAlignment, v_align: VerticalAlignment) callconv(.C) void;
    /// Typesets and fills the text. Optional parameters:
    /// transform_value: translation or matrix to apply
    /// bounds: width determines wrapping and hAlign, height for vAlign
    /// hAlign: horizontal alignment of the text
    /// vAlign: vertical alignment of the text
    pub inline fn fillText(self: *Image, font: *Font, text: [:0]const u8, transform_value: Matrix3, bounds: Vector2, h_align: HorizontalAlignment, v_align: VerticalAlignment) void {
        return pixie_image_fill_text(self, font, text.ptr, transform_value, bounds, h_align, v_align);
    }

    extern fn pixie_image_arrangement_fill_text(self: *Image, arrangement: *Arrangement, transform_value: Matrix3) callconv(.C) void;
    /// Fills the text arrangement.
    pub inline fn fillTextArrangement(self: *Image, arrangement: *Arrangement, transform_value: Matrix3) void {
        return pixie_image_arrangement_fill_text(self, arrangement, transform_value);
    }

    extern fn pixie_image_stroke_text(self: *Image, font: *Font, text: [*:0]const u8, transform_value: Matrix3, stroke_width: f32, bounds: Vector2, h_align: HorizontalAlignment, v_align: VerticalAlignment, line_cap: LineCap, line_join: LineJoin, miter_limit: f32, dashes: *SeqFloat32) callconv(.C) void;
    /// Typesets and strokes the text. Optional parameters:
    /// transform_value: translation or matrix to apply
    /// bounds: width determines wrapping and hAlign, height for vAlign
    /// hAlign: horizontal alignment of the text
    /// vAlign: vertical alignment of the text
    /// lineCap: stroke line cap shape
    /// lineJoin: stroke line join shape
    pub inline fn strokeText(self: *Image, font: *Font, text: [:0]const u8, transform_value: Matrix3, stroke_width: f32, bounds: Vector2, h_align: HorizontalAlignment, v_align: VerticalAlignment, line_cap: LineCap, line_join: LineJoin, miter_limit: f32, dashes: *SeqFloat32) void {
        return pixie_image_stroke_text(self, font, text.ptr, transform_value, stroke_width, bounds, h_align, v_align, line_cap, line_join, miter_limit, dashes);
    }

    extern fn pixie_image_arrangement_stroke_text(self: *Image, arrangement: *Arrangement, transform_value: Matrix3, stroke_width: f32, line_cap: LineCap, line_join: LineJoin, miter_limit: f32, dashes: *SeqFloat32) callconv(.C) void;
    /// Strokes the text arrangement.
    pub inline fn strokeTextArrangement(self: *Image, arrangement: *Arrangement, transform_value: Matrix3, stroke_width: f32, line_cap: LineCap, line_join: LineJoin, miter_limit: f32, dashes: *SeqFloat32) void {
        return pixie_image_arrangement_stroke_text(self, arrangement, transform_value, stroke_width, line_cap, line_join, miter_limit, dashes);
    }

    extern fn pixie_image_fill_path(self: *Image, path: *Path, paint: *Paint, transform_value: Matrix3, winding_rule: WindingRule) callconv(.C) void;
    /// Fills a path.
    pub inline fn fillPath(self: *Image, path: *Path, paint: *Paint, transform_value: Matrix3, winding_rule: WindingRule) void {
        return pixie_image_fill_path(self, path, paint, transform_value, winding_rule);
    }

    extern fn pixie_image_stroke_path(self: *Image, path: *Path, paint: *Paint, transform_value: Matrix3, stroke_width: f32, line_cap: LineCap, line_join: LineJoin, miter_limit: f32, dashes: *SeqFloat32) callconv(.C) void;
    /// Strokes a path.
    pub inline fn strokePath(self: *Image, path: *Path, paint: *Paint, transform_value: Matrix3, stroke_width: f32, line_cap: LineCap, line_join: LineJoin, miter_limit: f32, dashes: *SeqFloat32) void {
        return pixie_image_stroke_path(self, path, paint, transform_value, stroke_width, line_cap, line_join, miter_limit, dashes);
    }

    extern fn pixie_image_new_context(self: *Image) callconv(.C) *Context;
    /// Create a new Context that will draw to the parameter image.
    pub inline fn newContext(self: *Image) *Context {
        return pixie_image_new_context(self);
    }

    extern fn pixie_image_opaque_bounds(self: *Image) callconv(.C) Rect;
    /// Returns the bounds of opaque pixels.
    /// Some images have transparency around them, use this to find just the
    /// visible part of the image and then use subImage to cut it out.
    /// Returns zero rect if whole image is transparent.
    /// Returns just the size of the image if no edge is transparent.
    pub inline fn opaqueBounds(self: *Image) Rect {
        return pixie_image_opaque_bounds(self);
    }
};

pub const Paint = opaque {
    extern fn pixie_paint_unref(self: *Paint) callconv(.C) void;
    pub inline fn deinit(self: *Paint) void {
        return pixie_paint_unref(self);
    }

    extern fn pixie_new_paint(kind: PaintKind) callconv(.C) *Paint;
    /// Create a new Paint.
    pub inline fn init(kind: PaintKind) *Paint {
        return pixie_new_paint(kind);
    }

    extern fn pixie_paint_get_kind(self: *Paint) callconv(.C) PaintKind;
    pub inline fn getKind(self: *Paint) PaintKind {
        return pixie_paint_get_kind(self);
    }

    extern fn pixie_paint_set_kind(self: *Paint, value: PaintKind) callconv(.C) void;
    pub inline fn setKind(self: *Paint, value: PaintKind) void {
        return pixie_paint_set_kind(self, value);
    }

    extern fn pixie_paint_get_blend_mode(self: *Paint) callconv(.C) BlendMode;
    pub inline fn getBlendMode(self: *Paint) BlendMode {
        return pixie_paint_get_blend_mode(self);
    }

    extern fn pixie_paint_set_blend_mode(self: *Paint, value: BlendMode) callconv(.C) void;
    pub inline fn setBlendMode(self: *Paint, value: BlendMode) void {
        return pixie_paint_set_blend_mode(self, value);
    }

    extern fn pixie_paint_get_opacity(self: *Paint) callconv(.C) f32;
    pub inline fn getOpacity(self: *Paint) f32 {
        return pixie_paint_get_opacity(self);
    }

    extern fn pixie_paint_set_opacity(self: *Paint, value: f32) callconv(.C) void;
    pub inline fn setOpacity(self: *Paint, value: f32) void {
        return pixie_paint_set_opacity(self, value);
    }

    extern fn pixie_paint_get_color(self: *Paint) callconv(.C) Color;
    pub inline fn getColor(self: *Paint) Color {
        return pixie_paint_get_color(self);
    }

    extern fn pixie_paint_set_color(self: *Paint, value: Color) callconv(.C) void;
    pub inline fn setColor(self: *Paint, value: Color) void {
        return pixie_paint_set_color(self, value);
    }

    extern fn pixie_paint_get_image(self: *Paint) callconv(.C) *Image;
    pub inline fn getImage(self: *Paint) *Image {
        return pixie_paint_get_image(self);
    }

    extern fn pixie_paint_set_image(self: *Paint, value: *Image) callconv(.C) void;
    pub inline fn setImage(self: *Paint, value: *Image) void {
        return pixie_paint_set_image(self, value);
    }

    extern fn pixie_paint_get_image_mat(self: *Paint) callconv(.C) Matrix3;
    pub inline fn getImageMat(self: *Paint) Matrix3 {
        return pixie_paint_get_image_mat(self);
    }

    extern fn pixie_paint_set_image_mat(self: *Paint, value: Matrix3) callconv(.C) void;
    pub inline fn setImageMat(self: *Paint, value: Matrix3) void {
        return pixie_paint_set_image_mat(self, value);
    }

    extern fn pixie_paint_copy(self: *Paint) callconv(.C) *Paint;
    /// Create a new Paint with the same properties.
    pub inline fn copy(self: *Paint) *Paint {
        return pixie_paint_copy(self);
    }
};

pub const Path = opaque {
    extern fn pixie_path_unref(self: *Path) callconv(.C) void;
    pub inline fn deinit(self: *Path) void {
        return pixie_path_unref(self);
    }

    extern fn pixie_new_path() callconv(.C) *Path;
    /// Create a new Path.
    pub inline fn init() *Path {
        return pixie_new_path();
    }

    extern fn pixie_path_copy(self: *Path) callconv(.C) *Path;
    pub inline fn copy(self: *Path) *Path {
        return pixie_path_copy(self);
    }

    extern fn pixie_path_transform(self: *Path, mat: Matrix3) callconv(.C) void;
    /// Apply a matrix transform to a path.
    pub inline fn transform(self: *Path, mat: Matrix3) void {
        return pixie_path_transform(self, mat);
    }

    extern fn pixie_path_add_path(self: *Path, other: *Path) callconv(.C) void;
    /// Adds a path to the current path.
    pub inline fn addPath(self: *Path, other: *Path) void {
        return pixie_path_add_path(self, other);
    }

    extern fn pixie_path_close_path(self: *Path) callconv(.C) void;
    /// Attempts to add a straight line from the current point to the start of
    /// the current sub-path. If the shape has already been closed or has only
    /// one point, this function does nothing.
    pub inline fn closePath(self: *Path) void {
        return pixie_path_close_path(self);
    }

    extern fn pixie_path_compute_bounds(self: *Path, transform_value: Matrix3) callconv(.C) Rect;
    /// Compute the bounds of the path.
    pub inline fn computeBounds(self: *Path, transform_value: Matrix3) Rect {
        return pixie_path_compute_bounds(self, transform_value);
    }

    extern fn pixie_path_fill_overlaps(self: *Path, test_value: Vector2, transform_value: Matrix3, winding_rule: WindingRule) callconv(.C) bool;
    /// Returns whether or not the specified point is contained in the current path.
    pub inline fn fillOverlaps(self: *Path, test_value: Vector2, transform_value: Matrix3, winding_rule: WindingRule) bool {
        return pixie_path_fill_overlaps(self, test_value, transform_value, winding_rule);
    }

    extern fn pixie_path_stroke_overlaps(self: *Path, test_value: Vector2, transform_value: Matrix3, stroke_width: f32, line_cap: LineCap, line_join: LineJoin, miter_limit: f32, dashes: *SeqFloat32) callconv(.C) bool;
    /// Returns whether or not the specified point is inside the area contained
    /// by the stroking of a path.
    pub inline fn strokeOverlaps(self: *Path, test_value: Vector2, transform_value: Matrix3, stroke_width: f32, line_cap: LineCap, line_join: LineJoin, miter_limit: f32, dashes: *SeqFloat32) bool {
        return pixie_path_stroke_overlaps(self, test_value, transform_value, stroke_width, line_cap, line_join, miter_limit, dashes);
    }

    extern fn pixie_path_move_to(self: *Path, x: f32, y: f32) callconv(.C) void;
    /// Begins a new sub-path at the point (x, y).
    pub inline fn moveTo(self: *Path, x: f32, y: f32) void {
        return pixie_path_move_to(self, x, y);
    }

    extern fn pixie_path_line_to(self: *Path, x: f32, y: f32) callconv(.C) void;
    /// Adds a straight line to the current sub-path by connecting the sub-path's
    /// last point to the specified (x, y) coordinates.
    pub inline fn lineTo(self: *Path, x: f32, y: f32) void {
        return pixie_path_line_to(self, x, y);
    }

    extern fn pixie_path_bezier_curve_to(self: *Path, x1: f32, y1: f32, x2: f32, y2: f32, x3: f32, y3: f32) callconv(.C) void;
    /// Adds a cubic Bézier curve to the current sub-path. It requires three
    /// points: the first two are control points and the third one is the end
    /// point. The starting point is the latest point in the current path,
    /// which can be changed using moveTo() before creating the Bézier curve.
    pub inline fn bezierCurveTo(self: *Path, x1: f32, y1: f32, x2: f32, y2: f32, x3: f32, y3: f32) void {
        return pixie_path_bezier_curve_to(self, x1, y1, x2, y2, x3, y3);
    }

    extern fn pixie_path_quadratic_curve_to(self: *Path, x1: f32, y1: f32, x2: f32, y2: f32) callconv(.C) void;
    /// Adds a quadratic Bézier curve to the current sub-path. It requires two
    /// points: the first one is a control point and the second one is the end
    /// point. The starting point is the latest point in the current path,
    /// which can be changed using moveTo() before creating the quadratic
    /// Bézier curve.
    pub inline fn quadraticCurveTo(self: *Path, x1: f32, y1: f32, x2: f32, y2: f32) void {
        return pixie_path_quadratic_curve_to(self, x1, y1, x2, y2);
    }

    extern fn pixie_path_elliptical_arc_to(self: *Path, rx: f32, ry: f32, x_axis_rotation: f32, large_arc_flag: bool, sweep_flag: bool, x: f32, y: f32) callconv(.C) void;
    /// Adds an elliptical arc to the current sub-path, using the given radius
    /// ratios, sweep flags, and end position.
    pub inline fn ellipticalArcTo(self: *Path, rx: f32, ry: f32, x_axis_rotation: f32, large_arc_flag: bool, sweep_flag: bool, x: f32, y: f32) void {
        return pixie_path_elliptical_arc_to(self, rx, ry, x_axis_rotation, large_arc_flag, sweep_flag, x, y);
    }

    extern fn pixie_path_arc(self: *Path, x: f32, y: f32, r: f32, a0: f32, a1: f32, ccw: bool) callconv(.C) void;
    /// Adds a circular arc to the current sub-path.
    pub inline fn arc(self: *Path, x: f32, y: f32, r: f32, a0: f32, a1: f32, ccw: bool) void {
        return pixie_path_arc(self, x, y, r, a0, a1, ccw);
    }

    extern fn pixie_path_arc_to(self: *Path, x1: f32, y1: f32, x2: f32, y2: f32, r: f32) callconv(.C) void;
    /// Adds a circular arc using the given control points and radius.
    /// Commonly used for making rounded corners.
    pub inline fn arcTo(self: *Path, x1: f32, y1: f32, x2: f32, y2: f32, r: f32) void {
        return pixie_path_arc_to(self, x1, y1, x2, y2, r);
    }

    extern fn pixie_path_rect(self: *Path, x: f32, y: f32, w: f32, h: f32, clockwise: bool) callconv(.C) void;
    /// Adds a rectangle.
    /// Clockwise param can be used to subtract a rect from a path when using
    /// even-odd winding rule.
    pub inline fn rect(self: *Path, x: f32, y: f32, w: f32, h: f32, clockwise: bool) void {
        return pixie_path_rect(self, x, y, w, h, clockwise);
    }

    extern fn pixie_path_rounded_rect(self: *Path, x: f32, y: f32, w: f32, h: f32, nw: f32, ne: f32, se: f32, sw: f32, clockwise: bool) callconv(.C) void;
    /// Adds a rounded rectangle.
    /// Clockwise param can be used to subtract a rect from a path when using
    /// even-odd winding rule.
    pub inline fn roundedRect(self: *Path, x: f32, y: f32, w: f32, h: f32, nw: f32, ne: f32, se: f32, sw: f32, clockwise: bool) void {
        return pixie_path_rounded_rect(self, x, y, w, h, nw, ne, se, sw, clockwise);
    }

    extern fn pixie_path_ellipse(self: *Path, cx: f32, cy: f32, rx: f32, ry: f32) callconv(.C) void;
    /// Adds a ellipse.
    pub inline fn ellipse(self: *Path, cx: f32, cy: f32, rx: f32, ry: f32) void {
        return pixie_path_ellipse(self, cx, cy, rx, ry);
    }

    extern fn pixie_path_circle(self: *Path, cx: f32, cy: f32, r: f32) callconv(.C) void;
    /// Adds a circle.
    pub inline fn circle(self: *Path, cx: f32, cy: f32, r: f32) void {
        return pixie_path_circle(self, cx, cy, r);
    }

    extern fn pixie_path_polygon(self: *Path, x: f32, y: f32, size: f32, sides: isize) callconv(.C) void;
    /// Adds an n-sided regular polygon at (x, y) with the parameter size.
    /// Polygons "face" north.
    pub inline fn polygon(self: *Path, x: f32, y: f32, size: f32, sides: isize) void {
        return pixie_path_polygon(self, x, y, size, sides);
    }
};

pub const Typeface = opaque {
    extern fn pixie_typeface_unref(self: *Typeface) callconv(.C) void;
    pub inline fn deinit(self: *Typeface) void {
        return pixie_typeface_unref(self);
    }

    extern fn pixie_typeface_get_file_path(self: *Typeface) callconv(.C) [*:0]const u8;
    pub inline fn getFilePath(self: *Typeface) [:0]const u8 {
        return std.mem.span(pixie_typeface_get_file_path(self));
    }

    extern fn pixie_typeface_set_file_path(self: *Typeface, value: [*:0]const u8) callconv(.C) void;
    pub inline fn setFilePath(self: *Typeface, value: [:0]const u8) void {
        return pixie_typeface_set_file_path(self, value.ptr);
    }

    extern fn pixie_read_typeface(file_path: [*:0]const u8) callconv(.C) *Typeface;
    /// Loads a typeface from a file.
    pub inline fn loadFromFile(file_path: [:0]const u8) *Typeface {
        return pixie_read_typeface(file_path.ptr);
    }

    extern fn pixie_typeface_ascent(self: *Typeface) callconv(.C) f32;
    /// The font ascender value in font units.
    pub inline fn ascent(self: *Typeface) f32 {
        return pixie_typeface_ascent(self);
    }

    extern fn pixie_typeface_descent(self: *Typeface) callconv(.C) f32;
    /// The font descender value in font units.
    pub inline fn descent(self: *Typeface) f32 {
        return pixie_typeface_descent(self);
    }

    extern fn pixie_typeface_line_gap(self: *Typeface) callconv(.C) f32;
    /// The font line gap value in font units.
    pub inline fn lineGap(self: *Typeface) f32 {
        return pixie_typeface_line_gap(self);
    }

    extern fn pixie_typeface_line_height(self: *Typeface) callconv(.C) f32;
    /// The default line height in font units.
    pub inline fn lineHeight(self: *Typeface) f32 {
        return pixie_typeface_line_height(self);
    }

    extern fn pixie_typeface_has_glyph(self: *Typeface, rune: u21) callconv(.C) bool;
    /// Returns if there is a glyph for this rune.
    pub inline fn hasGlyph(self: *Typeface, rune: u21) bool {
        return pixie_typeface_has_glyph(self, rune);
    }

    extern fn pixie_typeface_get_glyph_path(self: *Typeface, rune: u21) callconv(.C) *Path;
    /// The glyph path for the rune.
    pub inline fn getGlyphPath(self: *Typeface, rune: u21) *Path {
        return pixie_typeface_get_glyph_path(self, rune);
    }

    extern fn pixie_typeface_get_advance(self: *Typeface, rune: u21) callconv(.C) f32;
    /// The advance for the rune in pixels.
    pub inline fn getAdvance(self: *Typeface, rune: u21) f32 {
        return pixie_typeface_get_advance(self, rune);
    }

    extern fn pixie_typeface_get_kerning_adjustment(self: *Typeface, left: u21, right: u21) callconv(.C) f32;
    /// The kerning adjustment for the rune pair, in pixels.
    pub inline fn getKerningAdjustment(self: *Typeface, left: u21, right: u21) f32 {
        return pixie_typeface_get_kerning_adjustment(self, left, right);
    }

    extern fn pixie_typeface_new_font(self: *Typeface) callconv(.C) *Font;
    pub inline fn newFont(self: *Typeface) *Font {
        return pixie_typeface_new_font(self);
    }
};

pub const Font = opaque {
    extern fn pixie_font_unref(self: *Font) callconv(.C) void;
    pub inline fn deinit(self: *Font) void {
        return pixie_font_unref(self);
    }

    extern fn pixie_font_get_typeface(self: *Font) callconv(.C) *Typeface;
    pub inline fn getTypeface(self: *Font) *Typeface {
        return pixie_font_get_typeface(self);
    }

    extern fn pixie_font_set_typeface(self: *Font, value: *Typeface) callconv(.C) void;
    pub inline fn setTypeface(self: *Font, value: *Typeface) void {
        return pixie_font_set_typeface(self, value);
    }

    extern fn pixie_font_get_size(self: *Font) callconv(.C) f32;
    pub inline fn getSize(self: *Font) f32 {
        return pixie_font_get_size(self);
    }

    extern fn pixie_font_set_size(self: *Font, value: f32) callconv(.C) void;
    pub inline fn setSize(self: *Font, value: f32) void {
        return pixie_font_set_size(self, value);
    }

    extern fn pixie_font_get_line_height(self: *Font) callconv(.C) f32;
    pub inline fn getLineHeight(self: *Font) f32 {
        return pixie_font_get_line_height(self);
    }

    extern fn pixie_font_set_line_height(self: *Font, value: f32) callconv(.C) void;
    pub inline fn setLineHeight(self: *Font, value: f32) void {
        return pixie_font_set_line_height(self, value);
    }

    extern fn pixie_font_get_paint(self: *Font) callconv(.C) *Paint;
    pub inline fn getPaint(self: *Font) *Paint {
        return pixie_font_get_paint(self);
    }

    extern fn pixie_font_set_paint(self: *Font, value: *Paint) callconv(.C) void;
    pub inline fn setPaint(self: *Font, value: *Paint) void {
        return pixie_font_set_paint(self, value);
    }

    extern fn pixie_font_get_text_case(self: *Font) callconv(.C) TextCase;
    pub inline fn getTextCase(self: *Font) TextCase {
        return pixie_font_get_text_case(self);
    }

    extern fn pixie_font_set_text_case(self: *Font, value: TextCase) callconv(.C) void;
    pub inline fn setTextCase(self: *Font, value: TextCase) void {
        return pixie_font_set_text_case(self, value);
    }

    extern fn pixie_font_get_underline(self: *Font) callconv(.C) bool;
    pub inline fn getUnderline(self: *Font) bool {
        return pixie_font_get_underline(self);
    }

    extern fn pixie_font_set_underline(self: *Font, value: bool) callconv(.C) void;
    pub inline fn setUnderline(self: *Font, value: bool) void {
        return pixie_font_set_underline(self, value);
    }

    extern fn pixie_font_get_strikethrough(self: *Font) callconv(.C) bool;
    pub inline fn getStrikethrough(self: *Font) bool {
        return pixie_font_get_strikethrough(self);
    }

    extern fn pixie_font_set_strikethrough(self: *Font, value: bool) callconv(.C) void;
    pub inline fn setStrikethrough(self: *Font, value: bool) void {
        return pixie_font_set_strikethrough(self, value);
    }

    extern fn pixie_font_get_no_kerning_adjustments(self: *Font) callconv(.C) bool;
    pub inline fn getNoKerningAdjustments(self: *Font) bool {
        return pixie_font_get_no_kerning_adjustments(self);
    }

    extern fn pixie_font_set_no_kerning_adjustments(self: *Font, value: bool) callconv(.C) void;
    pub inline fn setNoKerningAdjustments(self: *Font, value: bool) void {
        return pixie_font_set_no_kerning_adjustments(self, value);
    }

    extern fn pixie_read_font(file_path: [*:0]const u8) callconv(.C) *Font;
    /// Loads a font from a file.
    pub inline fn loadFromFile(file_path: [:0]const u8) *Font {
        return pixie_read_font(file_path.ptr);
    }

    extern fn pixie_parse_path(s: [*:0]const u8) callconv(.C) *Path;
    /// Converts a SVG style path string into seq of commands.
    pub inline fn parseFromString(s: [:0]const u8) *Path {
        return pixie_parse_path(s.ptr);
    }

    extern fn pixie_font_copy(self: *Font) callconv(.C) *Font;
    pub inline fn copy(self: *Font) *Font {
        return pixie_font_copy(self);
    }

    extern fn pixie_font_scale(self: *Font) callconv(.C) f32;
    /// The scale factor to transform font units into pixels.
    pub inline fn scale(self: *Font) f32 {
        return pixie_font_scale(self);
    }

    extern fn pixie_font_default_line_height(self: *Font) callconv(.C) f32;
    /// The default line height in pixels for the current font size.
    pub inline fn defaultLineHeight(self: *Font) f32 {
        return pixie_font_default_line_height(self);
    }

    extern fn pixie_font_typeset(self: *Font, text: [*:0]const u8, bounds: Vector2, h_align: HorizontalAlignment, v_align: VerticalAlignment, wrap: bool) callconv(.C) *Arrangement;
    /// Lays out the character glyphs and returns the arrangement.
    /// Optional parameters:
    /// bounds: width determines wrapping and hAlign, height for vAlign
    /// hAlign: horizontal alignment of the text
    /// vAlign: vertical alignment of the text
    /// wrap: enable/disable text wrapping
    pub inline fn typeset(self: *Font, text: [:0]const u8, bounds: Vector2, h_align: HorizontalAlignment, v_align: VerticalAlignment, wrap: bool) *Arrangement {
        return pixie_font_typeset(self, text.ptr, bounds, h_align, v_align, wrap);
    }

    extern fn pixie_font_layout_bounds(self: *Font, text: [*:0]const u8) callconv(.C) Vector2;
    /// Computes the width and height of the text in pixels.
    pub inline fn layoutBounds(self: *Font, text: [:0]const u8) Vector2 {
        return pixie_font_layout_bounds(self, text.ptr);
    }
};

pub const Span = opaque {
    extern fn pixie_span_unref(self: *Span) callconv(.C) void;
    pub inline fn deinit(self: *Span) void {
        return pixie_span_unref(self);
    }

    extern fn pixie_new_span(text: [*:0]const u8, font: *Font) callconv(.C) *Span;
    /// Creates a span, associating a font with the text.
    pub inline fn init(text: [:0]const u8, font: *Font) *Span {
        return pixie_new_span(text.ptr, font);
    }

    extern fn pixie_span_get_text(self: *Span) callconv(.C) [*:0]const u8;
    pub inline fn getText(self: *Span) [:0]const u8 {
        return std.mem.span(pixie_span_get_text(self));
    }

    extern fn pixie_span_set_text(self: *Span, value: [*:0]const u8) callconv(.C) void;
    pub inline fn setText(self: *Span, value: [:0]const u8) void {
        return pixie_span_set_text(self, value.ptr);
    }

    extern fn pixie_span_get_font(self: *Span) callconv(.C) *Font;
    pub inline fn getFont(self: *Span) *Font {
        return pixie_span_get_font(self);
    }

    extern fn pixie_span_set_font(self: *Span, value: *Font) callconv(.C) void;
    pub inline fn setFont(self: *Span, value: *Font) void {
        return pixie_span_set_font(self, value);
    }
};

pub const Arrangement = opaque {
    extern fn pixie_arrangement_unref(self: *Arrangement) callconv(.C) void;
    pub inline fn deinit(self: *Arrangement) void {
        return pixie_arrangement_unref(self);
    }

    extern fn pixie_arrangement_layout_bounds(self: *Arrangement) callconv(.C) Vector2;
    /// Computes the width and height of the arrangement in pixels.
    pub inline fn layoutBounds(self: *Arrangement) Vector2 {
        return pixie_arrangement_layout_bounds(self);
    }

    extern fn pixie_arrangement_compute_bounds(self: *Arrangement, transform_value: Matrix3) callconv(.C) Rect;
    pub inline fn computeBounds(self: *Arrangement, transform_value: Matrix3) Rect {
        return pixie_arrangement_compute_bounds(self, transform_value);
    }
};

pub const Context = opaque {
    extern fn pixie_context_unref(self: *Context) callconv(.C) void;
    pub inline fn deinit(self: *Context) void {
        return pixie_context_unref(self);
    }

    extern fn pixie_new_context(width: isize, height: isize) callconv(.C) *Context;
    /// Create a new Context that will draw to a new image of width and height.
    pub inline fn init(width: isize, height: isize) *Context {
        return pixie_new_context(width, height);
    }

    extern fn pixie_context_get_image(self: *Context) callconv(.C) *Image;
    pub inline fn getImage(self: *Context) *Image {
        return pixie_context_get_image(self);
    }

    extern fn pixie_context_set_image(self: *Context, value: *Image) callconv(.C) void;
    pub inline fn setImage(self: *Context, value: *Image) void {
        return pixie_context_set_image(self, value);
    }

    extern fn pixie_context_get_fill_style(self: *Context) callconv(.C) *Paint;
    pub inline fn getFillStyle(self: *Context) *Paint {
        return pixie_context_get_fill_style(self);
    }

    extern fn pixie_context_set_fill_style(self: *Context, value: *Paint) callconv(.C) void;
    pub inline fn setFillStyle(self: *Context, value: *Paint) void {
        return pixie_context_set_fill_style(self, value);
    }

    extern fn pixie_context_get_stroke_style(self: *Context) callconv(.C) *Paint;
    pub inline fn getStrokeStyle(self: *Context) *Paint {
        return pixie_context_get_stroke_style(self);
    }

    extern fn pixie_context_set_stroke_style(self: *Context, value: *Paint) callconv(.C) void;
    pub inline fn setStrokeStyle(self: *Context, value: *Paint) void {
        return pixie_context_set_stroke_style(self, value);
    }

    extern fn pixie_context_get_global_alpha(self: *Context) callconv(.C) f32;
    pub inline fn getGlobalAlpha(self: *Context) f32 {
        return pixie_context_get_global_alpha(self);
    }

    extern fn pixie_context_set_global_alpha(self: *Context, value: f32) callconv(.C) void;
    pub inline fn setGlobalAlpha(self: *Context, value: f32) void {
        return pixie_context_set_global_alpha(self, value);
    }

    extern fn pixie_context_get_line_width(self: *Context) callconv(.C) f32;
    pub inline fn getLineWidth(self: *Context) f32 {
        return pixie_context_get_line_width(self);
    }

    extern fn pixie_context_set_line_width(self: *Context, value: f32) callconv(.C) void;
    pub inline fn setLineWidth(self: *Context, value: f32) void {
        return pixie_context_set_line_width(self, value);
    }

    extern fn pixie_context_get_miter_limit(self: *Context) callconv(.C) f32;
    pub inline fn getMiterLimit(self: *Context) f32 {
        return pixie_context_get_miter_limit(self);
    }

    extern fn pixie_context_set_miter_limit(self: *Context, value: f32) callconv(.C) void;
    pub inline fn setMiterLimit(self: *Context, value: f32) void {
        return pixie_context_set_miter_limit(self, value);
    }

    extern fn pixie_context_get_line_cap(self: *Context) callconv(.C) LineCap;
    pub inline fn getLineCap(self: *Context) LineCap {
        return pixie_context_get_line_cap(self);
    }

    extern fn pixie_context_set_line_cap(self: *Context, value: LineCap) callconv(.C) void;
    pub inline fn setLineCap(self: *Context, value: LineCap) void {
        return pixie_context_set_line_cap(self, value);
    }

    extern fn pixie_context_get_line_join(self: *Context) callconv(.C) LineJoin;
    pub inline fn getLineJoin(self: *Context) LineJoin {
        return pixie_context_get_line_join(self);
    }

    extern fn pixie_context_set_line_join(self: *Context, value: LineJoin) callconv(.C) void;
    pub inline fn setLineJoin(self: *Context, value: LineJoin) void {
        return pixie_context_set_line_join(self, value);
    }

    extern fn pixie_context_get_font(self: *Context) callconv(.C) [*:0]const u8;
    pub inline fn getFont(self: *Context) [:0]const u8 {
        return std.mem.span(pixie_context_get_font(self));
    }

    extern fn pixie_context_set_font(self: *Context, value: [*:0]const u8) callconv(.C) void;
    pub inline fn setFont(self: *Context, value: [:0]const u8) void {
        return pixie_context_set_font(self, value.ptr);
    }

    extern fn pixie_context_get_font_size(self: *Context) callconv(.C) f32;
    pub inline fn getFontSize(self: *Context) f32 {
        return pixie_context_get_font_size(self);
    }

    extern fn pixie_context_set_font_size(self: *Context, value: f32) callconv(.C) void;
    pub inline fn setFontSize(self: *Context, value: f32) void {
        return pixie_context_set_font_size(self, value);
    }

    extern fn pixie_context_get_text_align(self: *Context) callconv(.C) HorizontalAlignment;
    pub inline fn getTextAlign(self: *Context) HorizontalAlignment {
        return pixie_context_get_text_align(self);
    }

    extern fn pixie_context_set_text_align(self: *Context, value: HorizontalAlignment) callconv(.C) void;
    pub inline fn setTextAlign(self: *Context, value: HorizontalAlignment) void {
        return pixie_context_set_text_align(self, value);
    }

    extern fn pixie_context_save(self: *Context) callconv(.C) void;
    /// Saves the entire state of the context by pushing the current state onto
    /// a stack.
    pub inline fn save(self: *Context) void {
        return pixie_context_save(self);
    }

    extern fn pixie_context_save_layer(self: *Context) callconv(.C) void;
    /// Saves the entire state of the context by pushing the current state onto
    /// a stack and allocates a new image layer for subsequent drawing. Calling
    /// restore blends the current layer image onto the prior layer or root image.
    pub inline fn saveLayer(self: *Context) void {
        return pixie_context_save_layer(self);
    }

    extern fn pixie_context_restore(self: *Context) callconv(.C) void;
    /// Restores the most recently saved context state by popping the top entry
    /// in the drawing state stack. If there is no saved state, this method does
    /// nothing.
    pub inline fn restore(self: *Context) void {
        return pixie_context_restore(self);
    }

    extern fn pixie_context_begin_path(self: *Context) callconv(.C) void;
    /// Starts a new path by emptying the list of sub-paths.
    pub inline fn beginPath(self: *Context) void {
        return pixie_context_begin_path(self);
    }

    extern fn pixie_context_close_path(self: *Context) callconv(.C) void;
    /// Attempts to add a straight line from the current point to the start of
    /// the current sub-path. If the shape has already been closed or has only
    /// one point, this function does nothing.
    pub inline fn closePath(self: *Context) void {
        return pixie_context_close_path(self);
    }

    extern fn pixie_context_fill(self: *Context, winding_rule: WindingRule) callconv(.C) void;
    /// Fills the current path with the current fillStyle.
    pub inline fn fill(self: *Context, winding_rule: WindingRule) void {
        return pixie_context_fill(self, winding_rule);
    }

    extern fn pixie_context_path_fill(self: *Context, path: *Path, winding_rule: WindingRule) callconv(.C) void;
    /// Fills the path with the current fillStyle.
    pub inline fn fillPath(self: *Context, path: *Path, winding_rule: WindingRule) void {
        return pixie_context_path_fill(self, path, winding_rule);
    }

    extern fn pixie_context_clip(self: *Context, winding_rule: WindingRule) callconv(.C) void;
    /// Turns the current path into the current clipping region. The previous
    /// clipping region, if any, is intersected with the current or given path
    /// to create the new clipping region.
    pub inline fn clip(self: *Context, winding_rule: WindingRule) void {
        return pixie_context_clip(self, winding_rule);
    }

    extern fn pixie_context_path_clip(self: *Context, path: *Path, winding_rule: WindingRule) callconv(.C) void;
    /// Turns the path into the current clipping region. The previous clipping
    /// region, if any, is intersected with the current or given path to create
    /// the new clipping region.
    pub inline fn clipPath(self: *Context, path: *Path, winding_rule: WindingRule) void {
        return pixie_context_path_clip(self, path, winding_rule);
    }

    extern fn pixie_context_stroke(self: *Context) callconv(.C) void;
    /// Strokes (outlines) the current or given path with the current strokeStyle.
    pub inline fn stroke(self: *Context) void {
        return pixie_context_stroke(self);
    }

    extern fn pixie_context_path_stroke(self: *Context, path: *Path) callconv(.C) void;
    /// Strokes (outlines) the current or given path with the current strokeStyle.
    pub inline fn strokePath(self: *Context, path: *Path) void {
        return pixie_context_path_stroke(self, path);
    }

    extern fn pixie_context_measure_text(self: *Context, text: [*:0]const u8) callconv(.C) TextMetrics;
    /// Returns a TextMetrics object that contains information about the measured
    /// text (such as its width, for example).
    pub inline fn measureText(self: *Context, text: [:0]const u8) TextMetrics {
        return pixie_context_measure_text(self, text.ptr);
    }

    extern fn pixie_context_get_transform(self: *Context) callconv(.C) Matrix3;
    /// Retrieves the current transform matrix being applied to the context.
    pub inline fn getTransform(self: *Context) Matrix3 {
        return pixie_context_get_transform(self);
    }

    extern fn pixie_context_set_transform(self: *Context, transform_value: Matrix3) callconv(.C) void;
    /// Overrides the transform matrix being applied to the context.
    pub inline fn setTransform(self: *Context, transform_value: Matrix3) void {
        return pixie_context_set_transform(self, transform_value);
    }

    extern fn pixie_context_transform(self: *Context, transform_value: Matrix3) callconv(.C) void;
    /// Multiplies the current transform with the matrix described by the
    /// arguments of this method.
    pub inline fn transform(self: *Context, transform_value: Matrix3) void {
        return pixie_context_transform(self, transform_value);
    }

    extern fn pixie_context_reset_transform(self: *Context) callconv(.C) void;
    /// Resets the current transform to the identity matrix.
    pub inline fn resetTransform(self: *Context) void {
        return pixie_context_reset_transform(self);
    }

    extern fn pixie_context_get_line_dash(self: *Context) callconv(.C) *SeqFloat32;
    pub inline fn getLineDash(self: *Context) *SeqFloat32 {
        return pixie_context_get_line_dash(self);
    }

    extern fn pixie_context_set_line_dash(self: *Context, line_dash: *SeqFloat32) callconv(.C) void;
    pub inline fn setLineDash(self: *Context, line_dash: *SeqFloat32) void {
        return pixie_context_set_line_dash(self, line_dash);
    }

    extern fn pixie_context_draw_image(self: *Context, image: *Image, dx: f32, dy: f32) callconv(.C) void;
    /// Draws a source image onto the destination image.
    pub inline fn drawImage(self: *Context, image: *Image, dx: f32, dy: f32) void {
        return pixie_context_draw_image(self, image, dx, dy);
    }

    extern fn pixie_context_draw_image2(self: *Context, image: *Image, dx: f32, dy: f32, d_width: f32, d_height: f32) callconv(.C) void;
    pub inline fn drawImage2(self: *Context, image: *Image, dx: f32, dy: f32, d_width: f32, d_height: f32) void {
        return pixie_context_draw_image2(self, image, dx, dy, d_width, d_height);
    }

    extern fn pixie_context_draw_image3(self: *Context, image: *Image, sx: f32, sy: f32, s_width: f32, s_height: f32, dx: f32, dy: f32, d_width: f32, d_height: f32) callconv(.C) void;
    pub inline fn drawImage3(self: *Context, image: *Image, sx: f32, sy: f32, s_width: f32, s_height: f32, dx: f32, dy: f32, d_width: f32, d_height: f32) void {
        return pixie_context_draw_image3(self, image, sx, sy, s_width, s_height, dx, dy, d_width, d_height);
    }

    extern fn pixie_context_move_to(self: *Context, x: f32, y: f32) callconv(.C) void;
    /// Begins a new sub-path at the point (x, y).
    pub inline fn moveTo(self: *Context, x: f32, y: f32) void {
        return pixie_context_move_to(self, x, y);
    }

    extern fn pixie_context_line_to(self: *Context, x: f32, y: f32) callconv(.C) void;
    /// Adds a straight line to the current sub-path by connecting the sub-path's
    /// last point to the specified (x, y) coordinates.
    pub inline fn lineTo(self: *Context, x: f32, y: f32) void {
        return pixie_context_line_to(self, x, y);
    }

    extern fn pixie_context_bezier_curve_to(self: *Context, cp1x: f32, cp1y: f32, cp2x: f32, cp2y: f32, x: f32, y: f32) callconv(.C) void;
    /// Adds a cubic Bézier curve to the current sub-path. It requires three
    /// points: the first two are control points and the third one is the end
    /// point. The starting point is the latest point in the current path,
    /// which can be changed using moveTo() before creating the Bézier curve.
    pub inline fn bezierCurveTo(self: *Context, cp1x: f32, cp1y: f32, cp2x: f32, cp2y: f32, x: f32, y: f32) void {
        return pixie_context_bezier_curve_to(self, cp1x, cp1y, cp2x, cp2y, x, y);
    }

    extern fn pixie_context_quadratic_curve_to(self: *Context, cpx: f32, cpy: f32, x: f32, y: f32) callconv(.C) void;
    /// Adds a quadratic Bézier curve to the current sub-path. It requires two
    /// points: the first one is a control point and the second one is the end
    /// point. The starting point is the latest point in the current path,
    /// which can be changed using moveTo() before creating the quadratic
    /// Bézier curve.
    pub inline fn quadraticCurveTo(self: *Context, cpx: f32, cpy: f32, x: f32, y: f32) void {
        return pixie_context_quadratic_curve_to(self, cpx, cpy, x, y);
    }

    extern fn pixie_context_arc(self: *Context, x: f32, y: f32, r: f32, a0: f32, a1: f32, ccw: bool) callconv(.C) void;
    /// Draws a circular arc.
    pub inline fn arc(self: *Context, x: f32, y: f32, r: f32, a0: f32, a1: f32, ccw: bool) void {
        return pixie_context_arc(self, x, y, r, a0, a1, ccw);
    }

    extern fn pixie_context_arc_to(self: *Context, x1: f32, y1: f32, x2: f32, y2: f32, radius: f32) callconv(.C) void;
    /// Draws a circular arc using the given control points and radius.
    pub inline fn arcTo(self: *Context, x1: f32, y1: f32, x2: f32, y2: f32, radius: f32) void {
        return pixie_context_arc_to(self, x1, y1, x2, y2, radius);
    }

    extern fn pixie_context_rect(self: *Context, x: f32, y: f32, width: f32, height: f32) callconv(.C) void;
    /// Adds a rectangle to the current path.
    pub inline fn rect(self: *Context, x: f32, y: f32, width: f32, height: f32) void {
        return pixie_context_rect(self, x, y, width, height);
    }

    extern fn pixie_context_rounded_rect(self: *Context, x: f32, y: f32, w: f32, h: f32, nw: f32, ne: f32, se: f32, sw: f32) callconv(.C) void;
    /// Adds a rounded rectangle to the current path.
    pub inline fn roundedRect(self: *Context, x: f32, y: f32, w: f32, h: f32, nw: f32, ne: f32, se: f32, sw: f32) void {
        return pixie_context_rounded_rect(self, x, y, w, h, nw, ne, se, sw);
    }

    extern fn pixie_context_ellipse(self: *Context, x: f32, y: f32, rx: f32, ry: f32) callconv(.C) void;
    /// Adds an ellipse to the current sub-path.
    pub inline fn ellipse(self: *Context, x: f32, y: f32, rx: f32, ry: f32) void {
        return pixie_context_ellipse(self, x, y, rx, ry);
    }

    extern fn pixie_context_circle(self: *Context, cx: f32, cy: f32, r: f32) callconv(.C) void;
    /// Adds a circle to the current path.
    pub inline fn circle(self: *Context, cx: f32, cy: f32, r: f32) void {
        return pixie_context_circle(self, cx, cy, r);
    }

    extern fn pixie_context_polygon(self: *Context, x: f32, y: f32, size: f32, sides: isize) callconv(.C) void;
    /// Adds an n-sided regular polygon at (x, y) of size to the current path.
    pub inline fn polygon(self: *Context, x: f32, y: f32, size: f32, sides: isize) void {
        return pixie_context_polygon(self, x, y, size, sides);
    }

    extern fn pixie_context_clear_rect(self: *Context, x: f32, y: f32, width: f32, height: f32) callconv(.C) void;
    /// Erases the pixels in a rectangular area.
    pub inline fn clearRect(self: *Context, x: f32, y: f32, width: f32, height: f32) void {
        return pixie_context_clear_rect(self, x, y, width, height);
    }

    extern fn pixie_context_fill_rect(self: *Context, x: f32, y: f32, width: f32, height: f32) callconv(.C) void;
    /// Draws a rectangle that is filled according to the current fillStyle.
    pub inline fn fillRect(self: *Context, x: f32, y: f32, width: f32, height: f32) void {
        return pixie_context_fill_rect(self, x, y, width, height);
    }

    extern fn pixie_context_stroke_rect(self: *Context, x: f32, y: f32, width: f32, height: f32) callconv(.C) void;
    /// Draws a rectangle that is stroked (outlined) according to the current
    /// strokeStyle and other context settings.
    pub inline fn strokeRect(self: *Context, x: f32, y: f32, width: f32, height: f32) void {
        return pixie_context_stroke_rect(self, x, y, width, height);
    }

    extern fn pixie_context_stroke_segment(self: *Context, ax: f32, ay: f32, bx: f32, by: f32) callconv(.C) void;
    /// Strokes a segment (draws a line from ax, ay to bx, by) according
    /// to the current strokeStyle and other context settings.
    pub inline fn strokeSegment(self: *Context, ax: f32, ay: f32, bx: f32, by: f32) void {
        return pixie_context_stroke_segment(self, ax, ay, bx, by);
    }

    extern fn pixie_context_fill_text(self: *Context, text: [*:0]const u8, x: f32, y: f32) callconv(.C) void;
    /// Draws the outlines of the characters of a text string at the specified
    /// coordinates.
    pub inline fn fillText(self: *Context, text: [:0]const u8, x: f32, y: f32) void {
        return pixie_context_fill_text(self, text.ptr, x, y);
    }

    extern fn pixie_context_stroke_text(self: *Context, text: [*:0]const u8, x: f32, y: f32) callconv(.C) void;
    /// Draws the outlines of the characters of a text string at the specified
    /// coordinates.
    pub inline fn strokeText(self: *Context, text: [:0]const u8, x: f32, y: f32) void {
        return pixie_context_stroke_text(self, text.ptr, x, y);
    }

    extern fn pixie_context_translate(self: *Context, x: f32, y: f32) callconv(.C) void;
    /// Adds a translation transformation to the current matrix.
    pub inline fn translate(self: *Context, x: f32, y: f32) void {
        return pixie_context_translate(self, x, y);
    }

    extern fn pixie_context_scale(self: *Context, x: f32, y: f32) callconv(.C) void;
    /// Adds a scaling transformation to the context units horizontally and/or
    /// vertically.
    pub inline fn scale(self: *Context, x: f32, y: f32) void {
        return pixie_context_scale(self, x, y);
    }

    extern fn pixie_context_rotate(self: *Context, angle: f32) callconv(.C) void;
    /// Adds a rotation to the transformation matrix.
    pub inline fn rotate(self: *Context, angle: f32) void {
        return pixie_context_rotate(self, angle);
    }

    extern fn pixie_context_is_point_in_path(self: *Context, x: f32, y: f32, winding_rule: WindingRule) callconv(.C) bool;
    /// Returns whether or not the specified point is contained in the current path.
    pub inline fn isPointInPath(self: *Context, x: f32, y: f32, winding_rule: WindingRule) bool {
        return pixie_context_is_point_in_path(self, x, y, winding_rule);
    }

    extern fn pixie_context_path_is_point_in_path(self: *Context, path: *Path, x: f32, y: f32, winding_rule: WindingRule) callconv(.C) bool;
    /// Returns whether or not the specified point is contained in the current path.
    pub inline fn isPointInPathPath(self: *Context, path: *Path, x: f32, y: f32, winding_rule: WindingRule) bool {
        return pixie_context_path_is_point_in_path(self, path, x, y, winding_rule);
    }

    extern fn pixie_context_is_point_in_stroke(self: *Context, x: f32, y: f32) callconv(.C) bool;
    /// Returns whether or not the specified point is inside the area contained
    /// by the stroking of a path.
    pub inline fn isPointInStroke(self: *Context, x: f32, y: f32) bool {
        return pixie_context_is_point_in_stroke(self, x, y);
    }

    extern fn pixie_context_path_is_point_in_stroke(self: *Context, path: *Path, x: f32, y: f32) callconv(.C) bool;
    /// Returns whether or not the specified point is inside the area contained
    /// by the stroking of a path.
    pub inline fn isPointInStrokePath(self: *Context, path: *Path, x: f32, y: f32) bool {
        return pixie_context_path_is_point_in_stroke(self, path, x, y);
    }
};

extern fn pixie_miter_limit_to_angle(limit: f32) callconv(.C) f32;
/// Converts miter-limit-ratio to miter-limit-angle.
pub inline fn miterLimitToAngle(limit: f32) f32 {
    return pixie_miter_limit_to_angle(limit);
}

extern fn pixie_angle_to_miter_limit(angle: f32) callconv(.C) f32;
/// Converts miter-limit-angle to miter-limit-ratio.
pub inline fn angleToMiterLimit(angle: f32) f32 {
    return pixie_angle_to_miter_limit(angle);
}
