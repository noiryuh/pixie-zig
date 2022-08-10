# =========================================
# Nim-C FFI
# =========================================

import system except cstring
import ./cffi

# Redefine `cstring` to `cistring`
type cstring = cistring

# =========================================
# Pixie bindings code
# =========================================

import std/unicode
import pixie, pixie/internal

var lastError: ref PixieError

proc takeError(): string =
  result = lastError.msg
  lastError = nil

proc checkError(): bool =
  result = lastError != nil

type
  Vector2* = object
    x*, y*: float32

  Matrix3* = object
    values*: array[9, float32]

proc matrix3(): Matrix3 =
  cast[Matrix3](mat3())

proc mul(a, b: Matrix3): Matrix3 =
  cast[Matrix3](cast[Mat3](a) * cast[Mat3](b))

proc translate(x, y: float32): Matrix3 =
  cast[Matrix3](translate(vec2(x, y)))

proc rotate(angle: float32): Matrix3 =
  cast[Matrix3](rotate(angle))

proc scale(x, y: float32): Matrix3 =
  cast[Matrix3](scale(vec2(x, y)))

proc inverse(m: Matrix3): Matrix3 =
  cast[Matrix3](inverse(cast[Mat3](m)))

proc parseColor(s: string): Color {.raises: [PixieError].} =
  try:
    result = parseHtmlColor(s)
  except:
    raise currentExceptionAsPixieError()

proc drawImage2(
  ctx: Context, image: Image, dx, dy, dWidth, dHeight: float32
) {.raises: [PixieError].} =
  ctx.drawImage(image, dx, dy, dWidth, dHeight)

proc drawImage3(
  ctx: Context,
  image: Image,
  sx, sy, sWidth, sHeight,
  dx, dy, dWidth, dHeight: float32
) {.raises: [PixieError].} =
  ctx.drawImage(image, sx, sy, sWidth, sHeight, dx, dy, dWidth, dHeight)

# =========================================
# Pixie custom code
# =========================================

proc pixie_new_context_from_image*(image: Image): Context {.raises: [], cdecl, exportc, dynlib.} =
  try:
    result = newContext(image)
  except PixieError as e:
    lastError = e

# =========================================
# Pixie generated internal code
# =========================================

proc pixie_check_error*(): bool {.raises: [], cdecl, exportc, dynlib.} =
  checkError()

proc pixie_take_error*(): cstring {.raises: [], cdecl, exportc, dynlib.} =
  takeError().cstring

proc pixie_vector2*(x: float32, y: float32): Vector2 {.raises: [], cdecl, exportc, dynlib.} =
  result.x = x
  result.y = y

proc pixie_vector2_eq*(a, b: Vector2): bool {.raises: [], cdecl, exportc, dynlib.}=
  a.x == b.x and a.y == b.y

proc pixie_matrix3*(): Matrix3 {.raises: [], cdecl, exportc, dynlib.} =
  matrix3()

proc pixie_matrix3_eq*(a, b: Matrix3): bool {.raises: [], cdecl, exportc, dynlib.}=
  a.values == b.values

proc pixie_matrix3_mul*(a: Matrix3, b: Matrix3): Matrix3 {.raises: [], cdecl, exportc, dynlib.} =
  mul(a, b)

proc pixie_rect*(x: float32, y: float32, w: float32, h: float32): Rect {.raises: [], cdecl, exportc, dynlib.} =
  result.x = x
  result.y = y
  result.w = w
  result.h = h

proc pixie_rect_eq*(a, b: Rect): bool {.raises: [], cdecl, exportc, dynlib.}=
  a.x == b.x and a.y == b.y and a.w == b.w and a.h == b.h

proc pixie_color*(r: float32, g: float32, b: float32, a: float32): Color {.raises: [], cdecl, exportc, dynlib.} =
  result.r = r
  result.g = g
  result.b = b
  result.a = a

proc pixie_color_eq*(a, b: Color): bool {.raises: [], cdecl, exportc, dynlib.}=
  a.r == b.r and a.g == b.g and a.b == b.b and a.a == b.a

proc pixie_color_stop*(color: Color, position: float32): ColorStop {.raises: [], cdecl, exportc, dynlib.} =
  result.color = color
  result.position = position

proc pixie_color_stop_eq*(a, b: ColorStop): bool {.raises: [], cdecl, exportc, dynlib.}=
  a.color == b.color and a.position == b.position

proc pixie_text_metrics*(width: float32): TextMetrics {.raises: [], cdecl, exportc, dynlib.} =
  result.width = width

proc pixie_text_metrics_eq*(a, b: TextMetrics): bool {.raises: [], cdecl, exportc, dynlib.}=
  a.width == b.width

proc pixie_image_dimensions*(width: int, height: int): ImageDimensions {.raises: [], cdecl, exportc, dynlib.} =
  result.width = width
  result.height = height

proc pixie_image_dimensions_eq*(a, b: ImageDimensions): bool {.raises: [], cdecl, exportc, dynlib.}=
  a.width == b.width and a.height == b.height

type SeqFloat32* = ref object
  s: seq[float32]

proc pixie_new_seq_float32*(): SeqFloat32 {.raises: [], cdecl, exportc, dynlib.} =
  SeqFloat32()

proc pixie_seq_float32_len*(s: SeqFloat32): int {.raises: [], cdecl, exportc, dynlib.} =
  s.s.len

proc pixie_seq_float32_add*(s: SeqFloat32, v: float32) {.raises: [], cdecl, exportc, dynlib.} =
  s.s.add(v)

proc pixie_seq_float32_get*(s: SeqFloat32, i: int): float32 {.raises: [], cdecl, exportc, dynlib.} =
  s.s[i]

proc pixie_seq_float32_set*(s: SeqFloat32, i: int, v: float32) {.raises: [], cdecl, exportc, dynlib.} =
  s.s[i] = v

proc pixie_seq_float32_delete*(s: SeqFloat32, i: int) {.raises: [], cdecl, exportc, dynlib.} =
  s.s.delete(i)

proc pixie_seq_float32_clear*(s: SeqFloat32) {.raises: [], cdecl, exportc, dynlib.} =
  s.s.setLen(0)

proc pixie_seq_float32_unref*(s: SeqFloat32) {.raises: [], cdecl, exportc, dynlib.} =
  GC_unref(s)

type SeqSpan* = ref object
  s: seq[Span]

proc pixie_new_seq_span*(): SeqSpan {.raises: [], cdecl, exportc, dynlib.} =
  SeqSpan()

proc pixie_seq_span_len*(s: SeqSpan): int {.raises: [], cdecl, exportc, dynlib.} =
  s.s.len

proc pixie_seq_span_add*(s: SeqSpan, v: Span) {.raises: [], cdecl, exportc, dynlib.} =
  s.s.add(v)

proc pixie_seq_span_get*(s: SeqSpan, i: int): Span {.raises: [], cdecl, exportc, dynlib.} =
  s.s[i]

proc pixie_seq_span_set*(s: SeqSpan, i: int, v: Span) {.raises: [], cdecl, exportc, dynlib.} =
  s.s[i] = v

proc pixie_seq_span_delete*(s: SeqSpan, i: int) {.raises: [], cdecl, exportc, dynlib.} =
  s.s.delete(i)

proc pixie_seq_span_clear*(s: SeqSpan) {.raises: [], cdecl, exportc, dynlib.} =
  s.s.setLen(0)

proc pixie_seq_span_unref*(s: SeqSpan) {.raises: [], cdecl, exportc, dynlib.} =
  GC_unref(s)

proc pixie_seq_span_typeset*(spans: SeqSpan, bounds: Vec2, h_align: HorizontalAlignment, v_align: VerticalAlignment, wrap: bool): Arrangement {.raises: [], cdecl, exportc, dynlib.} =
  typeset(spans.s, bounds, h_align, v_align, wrap)

proc pixie_seq_span_layout_bounds*(spans: SeqSpan): Vec2 {.raises: [], cdecl, exportc, dynlib.} =
  layoutBounds(spans.s)

proc pixie_image_unref*(x: Image) {.raises: [], cdecl, exportc, dynlib.} =
  GC_unref(x)

proc pixie_new_image*(width: int, height: int): Image {.raises: [], cdecl, exportc, dynlib.} =
  try:
    result = newImage(width, height)
  except PixieError as e:
    lastError = e

proc pixie_image_get_width*(image: Image): int {.raises: [], cdecl, exportc, dynlib.} =
  image.width

proc pixie_image_set_width*(image: Image, width: int) {.raises: [], cdecl, exportc, dynlib.} =
  image.width = width

proc pixie_image_get_height*(image: Image): int {.raises: [], cdecl, exportc, dynlib.} =
  image.height

proc pixie_image_set_height*(image: Image, height: int) {.raises: [], cdecl, exportc, dynlib.} =
  image.height = height

proc pixie_image_write_file*(image: Image, file_path: cstring) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    writeFile(image, file_path.`$`)
  except PixieError as e:
    lastError = e

proc pixie_image_copy*(image: Image): Image {.raises: [], cdecl, exportc, dynlib.} =
  copy(image)

proc pixie_image_get_color*(image: Image, x: int, y: int): Color {.raises: [], cdecl, exportc, dynlib.} =
  getColor(image, x, y)

proc pixie_image_set_color*(image: Image, x: int, y: int, color: Color) {.raises: [], cdecl, exportc, dynlib.} =
  setColor(image, x, y, color)

proc pixie_image_fill*(image: Image, color: Color) {.raises: [], cdecl, exportc, dynlib.} =
  fill(image, color)

proc pixie_image_paint_fill*(image: Image, paint: Paint) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    fill(image, paint)
  except PixieError as e:
    lastError = e

proc pixie_image_is_one_color*(image: Image): bool {.raises: [], cdecl, exportc, dynlib.} =
  isOneColor(image)

proc pixie_image_is_transparent*(image: Image): bool {.raises: [], cdecl, exportc, dynlib.} =
  isTransparent(image)

proc pixie_image_is_opaque*(image: Image): bool {.raises: [], cdecl, exportc, dynlib.} =
  isOpaque(image)

proc pixie_image_flip_horizontal*(image: Image) {.raises: [], cdecl, exportc, dynlib.} =
  flipHorizontal(image)

proc pixie_image_flip_vertical*(image: Image) {.raises: [], cdecl, exportc, dynlib.} =
  flipVertical(image)

proc pixie_image_rotate90*(image: Image) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    rotate90(image)
  except PixieError as e:
    lastError = e

proc pixie_image_sub_image*(image: Image, x: int, y: int, w: int, h: int): Image {.raises: [], cdecl, exportc, dynlib.} =
  try:
    result = subImage(image, x, y, w, h)
  except PixieError as e:
    lastError = e

proc pixie_image_rect_sub_image*(image: Image, rect: Rect): Image {.raises: [], cdecl, exportc, dynlib.} =
  try:
    result = subImage(image, rect)
  except PixieError as e:
    lastError = e

proc pixie_image_minify_by2*(image: Image, power: int): Image {.raises: [], cdecl, exportc, dynlib.} =
  try:
    result = minifyBy2(image, power)
  except PixieError as e:
    lastError = e

proc pixie_image_magnify_by2*(image: Image, power: int): Image {.raises: [], cdecl, exportc, dynlib.} =
  try:
    result = magnifyBy2(image, power)
  except PixieError as e:
    lastError = e

proc pixie_image_apply_opacity*(image: Image, opacity: float32) {.raises: [], cdecl, exportc, dynlib.} =
  applyOpacity(image, opacity)

proc pixie_image_invert*(image: Image) {.raises: [], cdecl, exportc, dynlib.} =
  invert(image)

proc pixie_image_ceil*(image: Image) {.raises: [], cdecl, exportc, dynlib.} =
  ceil(image)

proc pixie_image_blur*(image: Image, radius: float32, out_of_bounds: Color) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    blur(image, radius, out_of_bounds)
  except PixieError as e:
    lastError = e

proc pixie_image_resize*(src_image: Image, width: int, height: int): Image {.raises: [], cdecl, exportc, dynlib.} =
  try:
    result = resize(src_image, width, height)
  except PixieError as e:
    lastError = e

proc pixie_image_shadow*(image: Image, offset: Vec2, spread: float32, blur: float32, color: Color): Image {.raises: [], cdecl, exportc, dynlib.} =
  try:
    result = shadow(image, offset, spread, blur, color)
  except PixieError as e:
    lastError = e

proc pixie_image_super_image*(image: Image, x: int, y: int, w: int, h: int): Image {.raises: [], cdecl, exportc, dynlib.} =
  try:
    result = superImage(image, x, y, w, h)
  except PixieError as e:
    lastError = e

proc pixie_image_draw*(a: Image, b: Image, transform: Mat3, blend_mode: BlendMode) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    draw(a, b, transform, blend_mode)
  except PixieError as e:
    lastError = e

proc pixie_image_fill_gradient*(image: Image, paint: Paint) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    fillGradient(image, paint)
  except PixieError as e:
    lastError = e

proc pixie_image_fill_text*(target: Image, font: Font, text: cstring, transform: Mat3, bounds: Vec2, h_align: HorizontalAlignment, v_align: VerticalAlignment) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    fillText(target, font, text.`$`, transform, bounds, h_align, v_align)
  except PixieError as e:
    lastError = e

proc pixie_image_arrangement_fill_text*(target: Image, arrangement: Arrangement, transform: Mat3) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    fillText(target, arrangement, transform)
  except PixieError as e:
    lastError = e

proc pixie_image_stroke_text*(target: Image, font: Font, text: cstring, transform: Mat3, stroke_width: float32, bounds: Vec2, h_align: HorizontalAlignment, v_align: VerticalAlignment, line_cap: LineCap, line_join: LineJoin, miter_limit: float32, dashes: SeqFloat32) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    strokeText(target, font, text.`$`, transform, stroke_width, bounds, h_align, v_align, line_cap, line_join, miter_limit, dashes.s)
  except PixieError as e:
    lastError = e

proc pixie_image_arrangement_stroke_text*(target: Image, arrangement: Arrangement, transform: Mat3, stroke_width: float32, line_cap: LineCap, line_join: LineJoin, miter_limit: float32, dashes: SeqFloat32) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    strokeText(target, arrangement, transform, stroke_width, line_cap, line_join, miter_limit, dashes.s)
  except PixieError as e:
    lastError = e

proc pixie_image_fill_path*(image: Image, path: Path, paint: Paint, transform: Mat3, winding_rule: WindingRule) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    fillPath(image, path, paint, transform, winding_rule)
  except PixieError as e:
    lastError = e

proc pixie_image_stroke_path*(image: Image, path: Path, paint: Paint, transform: Mat3, stroke_width: float32, line_cap: LineCap, line_join: LineJoin, miter_limit: float32, dashes: SeqFloat32) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    strokePath(image, path, paint, transform, stroke_width, line_cap, line_join, miter_limit, dashes.s)
  except PixieError as e:
    lastError = e

proc pixie_image_new_context*(image: Image): Context {.raises: [], cdecl, exportc, dynlib.} =
  newContext(image)

proc pixie_image_opaque_bounds*(image: Image): Rect {.raises: [], cdecl, exportc, dynlib.} =
  opaqueBounds(image)

proc pixie_paint_unref*(x: Paint) {.raises: [], cdecl, exportc, dynlib.} =
  GC_unref(x)

proc pixie_new_paint*(kind: PaintKind): Paint {.raises: [], cdecl, exportc, dynlib.} =
  newPaint(kind)

proc pixie_paint_get_kind*(paint: Paint): PaintKind {.raises: [], cdecl, exportc, dynlib.} =
  paint.kind

proc pixie_paint_set_kind*(paint: Paint, kind: PaintKind) {.raises: [], cdecl, exportc, dynlib.} =
  paint.kind = kind

proc pixie_paint_get_blend_mode*(paint: Paint): BlendMode {.raises: [], cdecl, exportc, dynlib.} =
  paint.blendMode

proc pixie_paint_set_blend_mode*(paint: Paint, blendMode: BlendMode) {.raises: [], cdecl, exportc, dynlib.} =
  paint.blendMode = blendMode

proc pixie_paint_get_opacity*(paint: Paint): float32 {.raises: [], cdecl, exportc, dynlib.} =
  paint.opacity

proc pixie_paint_set_opacity*(paint: Paint, opacity: float32) {.raises: [], cdecl, exportc, dynlib.} =
  paint.opacity = opacity

proc pixie_paint_get_color*(paint: Paint): Color {.raises: [], cdecl, exportc, dynlib.} =
  paint.color

proc pixie_paint_set_color*(paint: Paint, color: Color) {.raises: [], cdecl, exportc, dynlib.} =
  paint.color = color

proc pixie_paint_get_image*(paint: Paint): Image {.raises: [], cdecl, exportc, dynlib.} =
  paint.image

proc pixie_paint_set_image*(paint: Paint, image: Image) {.raises: [], cdecl, exportc, dynlib.} =
  paint.image = image

proc pixie_paint_get_image_mat*(paint: Paint): Mat3 {.raises: [], cdecl, exportc, dynlib.} =
  paint.imageMat

proc pixie_paint_set_image_mat*(paint: Paint, imageMat: Mat3) {.raises: [], cdecl, exportc, dynlib.} =
  paint.imageMat = imageMat

proc pixie_paint_gradient_handle_positions_len*(paint: Paint): int {.raises: [], cdecl, exportc, dynlib.} =
  paint.gradientHandlePositions.len

proc pixie_paint_gradient_handle_positions_add*(paint: Paint, v: Vec2) {.raises: [], cdecl, exportc, dynlib.} =
  paint.gradientHandlePositions.add(v)

proc pixie_paint_gradient_handle_positions_get*(paint: Paint, i: int): Vec2 {.raises: [], cdecl, exportc, dynlib.} =
  paint.gradientHandlePositions[i]

proc pixie_paint_gradient_handle_positions_set*(paint: Paint, i: int, v: Vec2) {.raises: [], cdecl, exportc, dynlib.} =
  paint.gradientHandlePositions[i] = v

proc pixie_paint_gradient_handle_positions_delete*(paint: Paint, i: int) {.raises: [], cdecl, exportc, dynlib.} =
  paint.gradientHandlePositions.delete(i)

proc pixie_paint_gradient_handle_positions_clear*(paint: Paint) {.raises: [], cdecl, exportc, dynlib.} =
  paint.gradientHandlePositions.setLen(0)

proc pixie_paint_gradient_stops_len*(paint: Paint): int {.raises: [], cdecl, exportc, dynlib.} =
  paint.gradientStops.len

proc pixie_paint_gradient_stops_add*(paint: Paint, v: ColorStop) {.raises: [], cdecl, exportc, dynlib.} =
  paint.gradientStops.add(v)

proc pixie_paint_gradient_stops_get*(paint: Paint, i: int): ColorStop {.raises: [], cdecl, exportc, dynlib.} =
  paint.gradientStops[i]

proc pixie_paint_gradient_stops_set*(paint: Paint, i: int, v: ColorStop) {.raises: [], cdecl, exportc, dynlib.} =
  paint.gradientStops[i] = v

proc pixie_paint_gradient_stops_delete*(paint: Paint, i: int) {.raises: [], cdecl, exportc, dynlib.} =
  paint.gradientStops.delete(i)

proc pixie_paint_gradient_stops_clear*(paint: Paint) {.raises: [], cdecl, exportc, dynlib.} =
  paint.gradientStops.setLen(0)

proc pixie_paint_copy*(paint: Paint): Paint {.raises: [], cdecl, exportc, dynlib.} =
  copy(paint)

proc pixie_path_unref*(x: Path) {.raises: [], cdecl, exportc, dynlib.} =
  GC_unref(x)

proc pixie_new_path*(): Path {.raises: [], cdecl, exportc, dynlib.} =
  newPath()

proc pixie_path_copy*(path: Path): Path {.raises: [], cdecl, exportc, dynlib.} =
  copy(path)

proc pixie_path_transform*(path: Path, mat: Mat3) {.raises: [], cdecl, exportc, dynlib.} =
  transform(path, mat)

proc pixie_path_add_path*(path: Path, other: Path) {.raises: [], cdecl, exportc, dynlib.} =
  addPath(path, other)

proc pixie_path_close_path*(path: Path) {.raises: [], cdecl, exportc, dynlib.} =
  closePath(path)

proc pixie_path_compute_bounds*(path: Path, transform: Mat3): Rect {.raises: [], cdecl, exportc, dynlib.} =
  try:
    result = computeBounds(path, transform)
  except PixieError as e:
    lastError = e

proc pixie_path_fill_overlaps*(path: Path, test: Vec2, transform: Mat3, winding_rule: WindingRule): bool {.raises: [], cdecl, exportc, dynlib.} =
  try:
    result = fillOverlaps(path, test, transform, winding_rule)
  except PixieError as e:
    lastError = e

proc pixie_path_stroke_overlaps*(path: Path, test: Vec2, transform: Mat3, stroke_width: float32, line_cap: LineCap, line_join: LineJoin, miter_limit: float32, dashes: SeqFloat32): bool {.raises: [], cdecl, exportc, dynlib.} =
  try:
    result = strokeOverlaps(path, test, transform, stroke_width, line_cap, line_join, miter_limit, dashes.s)
  except PixieError as e:
    lastError = e

proc pixie_path_move_to*(path: Path, x: float32, y: float32) {.raises: [], cdecl, exportc, dynlib.} =
  moveTo(path, x, y)

proc pixie_path_line_to*(path: Path, x: float32, y: float32) {.raises: [], cdecl, exportc, dynlib.} =
  lineTo(path, x, y)

proc pixie_path_bezier_curve_to*(path: Path, x1: float32, y1: float32, x2: float32, y2: float32, x3: float32, y3: float32) {.raises: [], cdecl, exportc, dynlib.} =
  bezierCurveTo(path, x1, y1, x2, y2, x3, y3)

proc pixie_path_quadratic_curve_to*(path: Path, x1: float32, y1: float32, x2: float32, y2: float32) {.raises: [], cdecl, exportc, dynlib.} =
  quadraticCurveTo(path, x1, y1, x2, y2)

proc pixie_path_elliptical_arc_to*(path: Path, rx: float32, ry: float32, x_axis_rotation: float32, large_arc_flag: bool, sweep_flag: bool, x: float32, y: float32) {.raises: [], cdecl, exportc, dynlib.} =
  ellipticalArcTo(path, rx, ry, x_axis_rotation, large_arc_flag, sweep_flag, x, y)

proc pixie_path_arc*(path: Path, x: float32, y: float32, r: float32, a0: float32, a1: float32, ccw: bool) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    arc(path, x, y, r, a0, a1, ccw)
  except PixieError as e:
    lastError = e

proc pixie_path_arc_to*(path: Path, x1: float32, y1: float32, x2: float32, y2: float32, r: float32) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    arcTo(path, x1, y1, x2, y2, r)
  except PixieError as e:
    lastError = e

proc pixie_path_rect*(path: Path, x: float32, y: float32, w: float32, h: float32, clockwise: bool) {.raises: [], cdecl, exportc, dynlib.} =
  rect(path, x, y, w, h, clockwise)

proc pixie_path_rounded_rect*(path: Path, x: float32, y: float32, w: float32, h: float32, nw: float32, ne: float32, se: float32, sw: float32, clockwise: bool) {.raises: [], cdecl, exportc, dynlib.} =
  roundedRect(path, x, y, w, h, nw, ne, se, sw, clockwise)

proc pixie_path_ellipse*(path: Path, cx: float32, cy: float32, rx: float32, ry: float32) {.raises: [], cdecl, exportc, dynlib.} =
  ellipse(path, cx, cy, rx, ry)

proc pixie_path_circle*(path: Path, cx: float32, cy: float32, r: float32) {.raises: [], cdecl, exportc, dynlib.} =
  circle(path, cx, cy, r)

proc pixie_path_polygon*(path: Path, x: float32, y: float32, size: float32, sides: int) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    polygon(path, x, y, size, sides)
  except PixieError as e:
    lastError = e

proc pixie_typeface_unref*(x: Typeface) {.raises: [], cdecl, exportc, dynlib.} =
  GC_unref(x)

proc pixie_typeface_get_file_path*(typeface: Typeface): cstring {.raises: [], cdecl, exportc, dynlib.} =
  typeface.filePath.cstring

proc pixie_typeface_set_file_path*(typeface: Typeface, filePath: cstring) {.raises: [], cdecl, exportc, dynlib.} =
  typeface.filePath = filePath.`$`

proc pixie_typeface_ascent*(typeface: Typeface): float32 {.raises: [], cdecl, exportc, dynlib.} =
  ascent(typeface)

proc pixie_typeface_descent*(typeface: Typeface): float32 {.raises: [], cdecl, exportc, dynlib.} =
  descent(typeface)

proc pixie_typeface_line_gap*(typeface: Typeface): float32 {.raises: [], cdecl, exportc, dynlib.} =
  lineGap(typeface)

proc pixie_typeface_line_height*(typeface: Typeface): float32 {.raises: [], cdecl, exportc, dynlib.} =
  lineHeight(typeface)

proc pixie_typeface_has_glyph*(typeface: Typeface, rune: int32): bool {.raises: [], cdecl, exportc, dynlib.} =
  hasGlyph(typeface, rune.Rune)

proc pixie_typeface_get_glyph_path*(typeface: Typeface, rune: int32): Path {.raises: [], cdecl, exportc, dynlib.} =
  try:
    result = getGlyphPath(typeface, rune.Rune)
  except PixieError as e:
    lastError = e

proc pixie_typeface_get_advance*(typeface: Typeface, rune: int32): float32 {.raises: [], cdecl, exportc, dynlib.} =
  getAdvance(typeface, rune.Rune)

proc pixie_typeface_get_kerning_adjustment*(typeface: Typeface, left: int32, right: int32): float32 {.raises: [], cdecl, exportc, dynlib.} =
  getKerningAdjustment(typeface, left.Rune, right.Rune)

proc pixie_typeface_new_font*(typeface: Typeface): Font {.raises: [], cdecl, exportc, dynlib.} =
  newFont(typeface)

proc pixie_font_unref*(x: Font) {.raises: [], cdecl, exportc, dynlib.} =
  GC_unref(x)

proc pixie_font_get_typeface*(font: Font): Typeface {.raises: [], cdecl, exportc, dynlib.} =
  font.typeface

proc pixie_font_set_typeface*(font: Font, typeface: Typeface) {.raises: [], cdecl, exportc, dynlib.} =
  font.typeface = typeface

proc pixie_font_get_size*(font: Font): float32 {.raises: [], cdecl, exportc, dynlib.} =
  font.size

proc pixie_font_set_size*(font: Font, size: float32) {.raises: [], cdecl, exportc, dynlib.} =
  font.size = size

proc pixie_font_get_line_height*(font: Font): float32 {.raises: [], cdecl, exportc, dynlib.} =
  font.lineHeight

proc pixie_font_set_line_height*(font: Font, lineHeight: float32) {.raises: [], cdecl, exportc, dynlib.} =
  font.lineHeight = lineHeight

proc pixie_font_paints_len*(font: Font): int {.raises: [], cdecl, exportc, dynlib.} =
  font.paints.len

proc pixie_font_paints_add*(font: Font, v: Paint) {.raises: [], cdecl, exportc, dynlib.} =
  font.paints.add(v)

proc pixie_font_paints_get*(font: Font, i: int): Paint {.raises: [], cdecl, exportc, dynlib.} =
  font.paints[i]

proc pixie_font_paints_set*(font: Font, i: int, v: Paint) {.raises: [], cdecl, exportc, dynlib.} =
  font.paints[i] = v

proc pixie_font_paints_delete*(font: Font, i: int) {.raises: [], cdecl, exportc, dynlib.} =
  font.paints.delete(i)

proc pixie_font_paints_clear*(font: Font) {.raises: [], cdecl, exportc, dynlib.} =
  font.paints.setLen(0)

proc pixie_font_get_paint*(font: Font): Paint {.raises: [], cdecl, exportc, dynlib.} =
  font.paint

proc pixie_font_set_paint*(font: Font, paint: Paint) {.raises: [], cdecl, exportc, dynlib.} =
  font.paint = paint

proc pixie_font_get_text_case*(font: Font): TextCase {.raises: [], cdecl, exportc, dynlib.} =
  font.textCase

proc pixie_font_set_text_case*(font: Font, textCase: TextCase) {.raises: [], cdecl, exportc, dynlib.} =
  font.textCase = textCase

proc pixie_font_get_underline*(font: Font): bool {.raises: [], cdecl, exportc, dynlib.} =
  font.underline

proc pixie_font_set_underline*(font: Font, underline: bool) {.raises: [], cdecl, exportc, dynlib.} =
  font.underline = underline

proc pixie_font_get_strikethrough*(font: Font): bool {.raises: [], cdecl, exportc, dynlib.} =
  font.strikethrough

proc pixie_font_set_strikethrough*(font: Font, strikethrough: bool) {.raises: [], cdecl, exportc, dynlib.} =
  font.strikethrough = strikethrough

proc pixie_font_get_no_kerning_adjustments*(font: Font): bool {.raises: [], cdecl, exportc, dynlib.} =
  font.noKerningAdjustments

proc pixie_font_set_no_kerning_adjustments*(font: Font, noKerningAdjustments: bool) {.raises: [], cdecl, exportc, dynlib.} =
  font.noKerningAdjustments = noKerningAdjustments

proc pixie_font_copy*(font: Font): Font {.raises: [], cdecl, exportc, dynlib.} =
  copy(font)

proc pixie_font_scale*(font: Font): float32 {.raises: [], cdecl, exportc, dynlib.} =
  scale(font)

proc pixie_font_default_line_height*(font: Font): float32 {.raises: [], cdecl, exportc, dynlib.} =
  defaultLineHeight(font)

proc pixie_font_typeset*(font: Font, text: cstring, bounds: Vec2, h_align: HorizontalAlignment, v_align: VerticalAlignment, wrap: bool): Arrangement {.raises: [], cdecl, exportc, dynlib.} =
  typeset(font, text.`$`, bounds, h_align, v_align, wrap)

proc pixie_font_layout_bounds*(font: Font, text: cstring): Vec2 {.raises: [], cdecl, exportc, dynlib.} =
  layoutBounds(font, text.`$`)

proc pixie_span_unref*(x: Span) {.raises: [], cdecl, exportc, dynlib.} =
  GC_unref(x)

proc pixie_new_span*(text: cstring, font: Font): Span {.raises: [], cdecl, exportc, dynlib.} =
  newSpan(text.`$`, font)

proc pixie_span_get_text*(span: Span): cstring {.raises: [], cdecl, exportc, dynlib.} =
  span.text.cstring

proc pixie_span_set_text*(span: Span, text: cstring) {.raises: [], cdecl, exportc, dynlib.} =
  span.text = text.`$`

proc pixie_span_get_font*(span: Span): Font {.raises: [], cdecl, exportc, dynlib.} =
  span.font

proc pixie_span_set_font*(span: Span, font: Font) {.raises: [], cdecl, exportc, dynlib.} =
  span.font = font

proc pixie_arrangement_unref*(x: Arrangement) {.raises: [], cdecl, exportc, dynlib.} =
  GC_unref(x)

proc pixie_arrangement_layout_bounds*(arrangement: Arrangement): Vec2 {.raises: [], cdecl, exportc, dynlib.} =
  layoutBounds(arrangement)

proc pixie_arrangement_compute_bounds*(arrangement: Arrangement, transform: Mat3): Rect {.raises: [], cdecl, exportc, dynlib.} =
  try:
    result = computeBounds(arrangement, transform)
  except PixieError as e:
    lastError = e

proc pixie_context_unref*(x: Context) {.raises: [], cdecl, exportc, dynlib.} =
  GC_unref(x)

proc pixie_new_context*(width: int, height: int): Context {.raises: [], cdecl, exportc, dynlib.} =
  try:
    result = newContext(width, height)
  except PixieError as e:
    lastError = e

proc pixie_context_get_image*(context: Context): Image {.raises: [], cdecl, exportc, dynlib.} =
  context.image

proc pixie_context_set_image*(context: Context, image: Image) {.raises: [], cdecl, exportc, dynlib.} =
  context.image = image

proc pixie_context_get_fill_style*(context: Context): Paint {.raises: [], cdecl, exportc, dynlib.} =
  context.fillStyle

proc pixie_context_set_fill_style*(context: Context, fillStyle: Paint) {.raises: [], cdecl, exportc, dynlib.} =
  context.fillStyle = fillStyle

proc pixie_context_get_stroke_style*(context: Context): Paint {.raises: [], cdecl, exportc, dynlib.} =
  context.strokeStyle

proc pixie_context_set_stroke_style*(context: Context, strokeStyle: Paint) {.raises: [], cdecl, exportc, dynlib.} =
  context.strokeStyle = strokeStyle

proc pixie_context_get_global_alpha*(context: Context): float32 {.raises: [], cdecl, exportc, dynlib.} =
  context.globalAlpha

proc pixie_context_set_global_alpha*(context: Context, globalAlpha: float32) {.raises: [], cdecl, exportc, dynlib.} =
  context.globalAlpha = globalAlpha

proc pixie_context_get_line_width*(context: Context): float32 {.raises: [], cdecl, exportc, dynlib.} =
  context.lineWidth

proc pixie_context_set_line_width*(context: Context, lineWidth: float32) {.raises: [], cdecl, exportc, dynlib.} =
  context.lineWidth = lineWidth

proc pixie_context_get_miter_limit*(context: Context): float32 {.raises: [], cdecl, exportc, dynlib.} =
  context.miterLimit

proc pixie_context_set_miter_limit*(context: Context, miterLimit: float32) {.raises: [], cdecl, exportc, dynlib.} =
  context.miterLimit = miterLimit

proc pixie_context_get_line_cap*(context: Context): LineCap {.raises: [], cdecl, exportc, dynlib.} =
  context.lineCap

proc pixie_context_set_line_cap*(context: Context, lineCap: LineCap) {.raises: [], cdecl, exportc, dynlib.} =
  context.lineCap = lineCap

proc pixie_context_get_line_join*(context: Context): LineJoin {.raises: [], cdecl, exportc, dynlib.} =
  context.lineJoin

proc pixie_context_set_line_join*(context: Context, lineJoin: LineJoin) {.raises: [], cdecl, exportc, dynlib.} =
  context.lineJoin = lineJoin

proc pixie_context_get_font*(context: Context): cstring {.raises: [], cdecl, exportc, dynlib.} =
  context.font.cstring

proc pixie_context_set_font*(context: Context, font: cstring) {.raises: [], cdecl, exportc, dynlib.} =
  context.font = font.`$`

proc pixie_context_get_font_size*(context: Context): float32 {.raises: [], cdecl, exportc, dynlib.} =
  context.fontSize

proc pixie_context_set_font_size*(context: Context, fontSize: float32) {.raises: [], cdecl, exportc, dynlib.} =
  context.fontSize = fontSize

proc pixie_context_get_text_align*(context: Context): HorizontalAlignment {.raises: [], cdecl, exportc, dynlib.} =
  context.textAlign

proc pixie_context_set_text_align*(context: Context, textAlign: HorizontalAlignment) {.raises: [], cdecl, exportc, dynlib.} =
  context.textAlign = textAlign

proc pixie_context_save*(ctx: Context) {.raises: [], cdecl, exportc, dynlib.} =
  save(ctx)

proc pixie_context_save_layer*(ctx: Context) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    saveLayer(ctx)
  except PixieError as e:
    lastError = e

proc pixie_context_restore*(ctx: Context) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    restore(ctx)
  except PixieError as e:
    lastError = e

proc pixie_context_begin_path*(ctx: Context) {.raises: [], cdecl, exportc, dynlib.} =
  beginPath(ctx)

proc pixie_context_close_path*(ctx: Context) {.raises: [], cdecl, exportc, dynlib.} =
  closePath(ctx)

proc pixie_context_fill*(ctx: Context, winding_rule: WindingRule) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    fill(ctx, winding_rule)
  except PixieError as e:
    lastError = e

proc pixie_context_path_fill*(ctx: Context, path: Path, winding_rule: WindingRule) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    fill(ctx, path, winding_rule)
  except PixieError as e:
    lastError = e

proc pixie_context_clip*(ctx: Context, winding_rule: WindingRule) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    clip(ctx, winding_rule)
  except PixieError as e:
    lastError = e

proc pixie_context_path_clip*(ctx: Context, path: Path, winding_rule: WindingRule) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    clip(ctx, path, winding_rule)
  except PixieError as e:
    lastError = e

proc pixie_context_stroke*(ctx: Context) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    stroke(ctx)
  except PixieError as e:
    lastError = e

proc pixie_context_path_stroke*(ctx: Context, path: Path) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    stroke(ctx, path)
  except PixieError as e:
    lastError = e

proc pixie_context_measure_text*(ctx: Context, text: cstring): TextMetrics {.raises: [], cdecl, exportc, dynlib.} =
  try:
    result = measureText(ctx, text.`$`)
  except PixieError as e:
    lastError = e

proc pixie_context_get_transform*(ctx: Context): Mat3 {.raises: [], cdecl, exportc, dynlib.} =
  getTransform(ctx)

proc pixie_context_set_transform*(ctx: Context, transform: Mat3) {.raises: [], cdecl, exportc, dynlib.} =
  setTransform(ctx, transform)

proc pixie_context_transform*(ctx: Context, transform: Mat3) {.raises: [], cdecl, exportc, dynlib.} =
  transform(ctx, transform)

proc pixie_context_reset_transform*(ctx: Context) {.raises: [], cdecl, exportc, dynlib.} =
  resetTransform(ctx)

proc pixie_context_get_line_dash*(ctx: Context): SeqFloat32 {.raises: [], cdecl, exportc, dynlib.} =
  SeqFloat32(s: getLineDash(ctx))

proc pixie_context_set_line_dash*(ctx: Context, line_dash: SeqFloat32) {.raises: [], cdecl, exportc, dynlib.} =
  setLineDash(ctx, line_dash.s)

proc pixie_context_draw_image*(ctx: Context, image: Image, dx: float32, dy: float32) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    drawImage(ctx, image, dx, dy)
  except PixieError as e:
    lastError = e

proc pixie_context_draw_image2*(ctx: Context, image: Image, dx: float32, dy: float32, d_width: float32, d_height: float32) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    drawImage2(ctx, image, dx, dy, d_width, d_height)
  except PixieError as e:
    lastError = e

proc pixie_context_draw_image3*(ctx: Context, image: Image, sx: float32, sy: float32, s_width: float32, s_height: float32, dx: float32, dy: float32, d_width: float32, d_height: float32) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    drawImage3(ctx, image, sx, sy, s_width, s_height, dx, dy, d_width, d_height)
  except PixieError as e:
    lastError = e

proc pixie_context_move_to*(ctx: Context, x: float32, y: float32) {.raises: [], cdecl, exportc, dynlib.} =
  moveTo(ctx, x, y)

proc pixie_context_line_to*(ctx: Context, x: float32, y: float32) {.raises: [], cdecl, exportc, dynlib.} =
  lineTo(ctx, x, y)

proc pixie_context_bezier_curve_to*(ctx: Context, cp1x: float32, cp1y: float32, cp2x: float32, cp2y: float32, x: float32, y: float32) {.raises: [], cdecl, exportc, dynlib.} =
  bezierCurveTo(ctx, cp1x, cp1y, cp2x, cp2y, x, y)

proc pixie_context_quadratic_curve_to*(ctx: Context, cpx: float32, cpy: float32, x: float32, y: float32) {.raises: [], cdecl, exportc, dynlib.} =
  quadraticCurveTo(ctx, cpx, cpy, x, y)

proc pixie_context_arc*(ctx: Context, x: float32, y: float32, r: float32, a0: float32, a1: float32, ccw: bool) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    arc(ctx, x, y, r, a0, a1, ccw)
  except PixieError as e:
    lastError = e

proc pixie_context_arc_to*(ctx: Context, x1: float32, y1: float32, x2: float32, y2: float32, radius: float32) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    arcTo(ctx, x1, y1, x2, y2, radius)
  except PixieError as e:
    lastError = e

proc pixie_context_rect*(ctx: Context, x: float32, y: float32, width: float32, height: float32) {.raises: [], cdecl, exportc, dynlib.} =
  rect(ctx, x, y, width, height)

proc pixie_context_rounded_rect*(ctx: Context, x: float32, y: float32, w: float32, h: float32, nw: float32, ne: float32, se: float32, sw: float32) {.raises: [], cdecl, exportc, dynlib.} =
  roundedRect(ctx, x, y, w, h, nw, ne, se, sw)

proc pixie_context_ellipse*(ctx: Context, x: float32, y: float32, rx: float32, ry: float32) {.raises: [], cdecl, exportc, dynlib.} =
  ellipse(ctx, x, y, rx, ry)

proc pixie_context_circle*(ctx: Context, cx: float32, cy: float32, r: float32) {.raises: [], cdecl, exportc, dynlib.} =
  circle(ctx, cx, cy, r)

proc pixie_context_polygon*(ctx: Context, x: float32, y: float32, size: float32, sides: int) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    polygon(ctx, x, y, size, sides)
  except PixieError as e:
    lastError = e

proc pixie_context_clear_rect*(ctx: Context, x: float32, y: float32, width: float32, height: float32) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    clearRect(ctx, x, y, width, height)
  except PixieError as e:
    lastError = e

proc pixie_context_fill_rect*(ctx: Context, x: float32, y: float32, width: float32, height: float32) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    fillRect(ctx, x, y, width, height)
  except PixieError as e:
    lastError = e

proc pixie_context_stroke_rect*(ctx: Context, x: float32, y: float32, width: float32, height: float32) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    strokeRect(ctx, x, y, width, height)
  except PixieError as e:
    lastError = e

proc pixie_context_stroke_segment*(ctx: Context, ax: float32, ay: float32, bx: float32, by: float32) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    strokeSegment(ctx, ax, ay, bx, by)
  except PixieError as e:
    lastError = e

proc pixie_context_fill_text*(ctx: Context, text: cstring, x: float32, y: float32) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    fillText(ctx, text.`$`, x, y)
  except PixieError as e:
    lastError = e

proc pixie_context_stroke_text*(ctx: Context, text: cstring, x: float32, y: float32) {.raises: [], cdecl, exportc, dynlib.} =
  try:
    strokeText(ctx, text.`$`, x, y)
  except PixieError as e:
    lastError = e

proc pixie_context_translate*(ctx: Context, x: float32, y: float32) {.raises: [], cdecl, exportc, dynlib.} =
  translate(ctx, x, y)

proc pixie_context_scale*(ctx: Context, x: float32, y: float32) {.raises: [], cdecl, exportc, dynlib.} =
  scale(ctx, x, y)

proc pixie_context_rotate*(ctx: Context, angle: float32) {.raises: [], cdecl, exportc, dynlib.} =
  rotate(ctx, angle)

proc pixie_context_is_point_in_path*(ctx: Context, x: float32, y: float32, winding_rule: WindingRule): bool {.raises: [], cdecl, exportc, dynlib.} =
  try:
    result = isPointInPath(ctx, x, y, winding_rule)
  except PixieError as e:
    lastError = e

proc pixie_context_path_is_point_in_path*(ctx: Context, path: Path, x: float32, y: float32, winding_rule: WindingRule): bool {.raises: [], cdecl, exportc, dynlib.} =
  try:
    result = isPointInPath(ctx, path, x, y, winding_rule)
  except PixieError as e:
    lastError = e

proc pixie_context_is_point_in_stroke*(ctx: Context, x: float32, y: float32): bool {.raises: [], cdecl, exportc, dynlib.} =
  try:
    result = isPointInStroke(ctx, x, y)
  except PixieError as e:
    lastError = e

proc pixie_context_path_is_point_in_stroke*(ctx: Context, path: Path, x: float32, y: float32): bool {.raises: [], cdecl, exportc, dynlib.} =
  try:
    result = isPointInStroke(ctx, path, x, y)
  except PixieError as e:
    lastError = e

proc pixie_decode_image*(data: cstring): Image {.raises: [], cdecl, exportc, dynlib.} =
  try:
    result = decodeImage(data.`$`)
  except PixieError as e:
    lastError = e

proc pixie_decode_image_dimensions*(data: cstring): ImageDimensions {.raises: [], cdecl, exportc, dynlib.} =
  try:
    result = decodeImageDimensions(data.`$`)
  except PixieError as e:
    lastError = e

proc pixie_read_image*(file_path: cstring): Image {.raises: [], cdecl, exportc, dynlib.} =
  try:
    result = readImage(file_path.`$`)
  except PixieError as e:
    lastError = e

proc pixie_read_image_dimensions*(file_path: cstring): ImageDimensions {.raises: [], cdecl, exportc, dynlib.} =
  try:
    result = readImageDimensions(file_path.`$`)
  except PixieError as e:
    lastError = e

proc pixie_read_typeface*(file_path: cstring): Typeface {.raises: [], cdecl, exportc, dynlib.} =
  try:
    result = readTypeface(file_path.`$`)
  except PixieError as e:
    lastError = e

proc pixie_read_font*(file_path: cstring): Font {.raises: [], cdecl, exportc, dynlib.} =
  try:
    result = readFont(file_path.`$`)
  except PixieError as e:
    lastError = e

proc pixie_parse_path*(path: cstring): Path {.raises: [], cdecl, exportc, dynlib.} =
  try:
    result = parsePath(path.`$`)
  except PixieError as e:
    lastError = e

proc pixie_miter_limit_to_angle*(limit: float32): float32 {.raises: [], cdecl, exportc, dynlib.} =
  miterLimitToAngle(limit)

proc pixie_angle_to_miter_limit*(angle: float32): float32 {.raises: [], cdecl, exportc, dynlib.} =
  angleToMiterLimit(angle)

proc pixie_parse_color*(s: cstring): Color {.raises: [], cdecl, exportc, dynlib.} =
  try:
    result = parseColor(s.`$`)
  except PixieError as e:
    lastError = e

proc pixie_translate*(x: float32, y: float32): Matrix3 {.raises: [], cdecl, exportc, dynlib.} =
  translate(x, y)

proc pixie_rotate*(angle: float32): Matrix3 {.raises: [], cdecl, exportc, dynlib.} =
  rotate(angle)

proc pixie_scale*(x: float32, y: float32): Matrix3 {.raises: [], cdecl, exportc, dynlib.} =
  scale(x, y)

proc pixie_inverse*(m: Matrix3): Matrix3 {.raises: [], cdecl, exportc, dynlib.} =
  inverse(m)

proc pixie_snap_to_pixels*(rect: Rect): Rect {.raises: [], cdecl, exportc, dynlib.} =
  snapToPixels(rect)

proc pixie_mix*(a: Color, b: Color, v: float32): Color {.raises: [], cdecl, exportc, dynlib.} =
  mix(a, b, v)

