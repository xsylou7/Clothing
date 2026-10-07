class_name PhiliaStyle
extends RefCounted

const BG := Color("e9e6e0")
const BG_DEEP := Color("ddd8cf")
const SURFACE := Color("f5f3ef")
const SURFACE_2 := Color("fbfaf8")
const INK := Color("141816")
const INK_SOFT := Color("3a403c")
const MUTED := Color("7a817c")
const ACCENT := Color("1f3d32")
const ACCENT_SOFT := Color("dce8e2")
const ACCENT_WARM := Color("b89a72")
const ACCENT_WARM_SOFT := Color("f0e8dc")
const AVAILABLE := Color("2d6a4f")
const LAUNDRY := Color("9a7b2f")
const UNAVAILABLE := Color("8f3a3a")
const MENU_BG := Color("15201c")
const LINE := Color(0.078, 0.094, 0.086, 0.09)

static func status_color(status: String) -> Color:
	match status:
		"laundry":
			return LAUNDRY
		"unavailable":
			return UNAVAILABLE
		_:
			return AVAILABLE

static func make_label(text: String, size: int = 14, color: Color = INK, bold: bool = false) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	if bold:
		l.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0))
	return l

static func make_display(text: String, size: int = 32, color: Color = INK) -> Label:
	var l := make_label(text, size, color)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return l

static func make_kicker(text: String) -> Label:
	var l := make_label(text.to_upper(), 11, MUTED)
	return l

static func panel_style(bg: Color = SURFACE, radius: float = 18.0, border: Color = LINE) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = bg
	sb.set_corner_radius_all(int(radius))
	sb.border_color = border
	sb.set_border_width_all(1)
	sb.content_margin_left = 14
	sb.content_margin_right = 14
	sb.content_margin_top = 12
	sb.content_margin_bottom = 12
	return sb

static func button_style(bg: Color, radius: float = 999.0) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = bg
	sb.set_corner_radius_all(int(radius))
	sb.content_margin_left = 20
	sb.content_margin_right = 20
	sb.content_margin_top = 14
	sb.content_margin_bottom = 14
	return sb

static func primary_button(text: String) -> Button:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = Vector2(0, 52)
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.add_theme_stylebox_override("normal", button_style(ACCENT))
	b.add_theme_stylebox_override("hover", button_style(ACCENT.lightened(0.08)))
	b.add_theme_stylebox_override("pressed", button_style(ACCENT.darkened(0.08)))
	b.add_theme_color_override("font_color", SURFACE)
	b.add_theme_color_override("font_hover_color", SURFACE)
	b.add_theme_color_override("font_pressed_color", SURFACE)
	b.add_theme_font_size_override("font_size", 15)
	return b

static func secondary_button(text: String) -> Button:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = Vector2(0, 52)
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var sb := button_style(SURFACE)
	sb.border_color = Color(0.078, 0.094, 0.086, 0.16)
	sb.set_border_width_all(1)
	b.add_theme_stylebox_override("normal", sb)
	b.add_theme_stylebox_override("hover", sb)
	b.add_theme_stylebox_override("pressed", sb)
	b.add_theme_color_override("font_color", INK)
	b.add_theme_font_size_override("font_size", 15)
	return b

static func ghost_button(text: String) -> Button:
	var b := secondary_button(text)
	var sb := button_style(Color(0, 0, 0, 0))
	sb.border_color = LINE
	sb.set_border_width_all(1)
	b.add_theme_stylebox_override("normal", sb)
	b.add_theme_stylebox_override("hover", sb)
	b.add_theme_stylebox_override("pressed", sb)
	b.add_theme_color_override("font_color", INK_SOFT)
	return b

static func chip(text: String, active: bool = false) -> Button:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = Vector2(0, 40)
	var bg := ACCENT if active else SURFACE
	var fg := SURFACE if active else INK_SOFT
	var sb := button_style(bg, 999)
	if not active:
		sb.border_color = LINE
		sb.set_border_width_all(1)
	sb.content_margin_left = 14
	sb.content_margin_right = 14
	sb.content_margin_top = 10
	sb.content_margin_bottom = 10
	b.add_theme_stylebox_override("normal", sb)
	b.add_theme_stylebox_override("hover", sb)
	b.add_theme_stylebox_override("pressed", sb)
	b.add_theme_color_override("font_color", fg)
	b.add_theme_color_override("font_hover_color", fg)
	b.add_theme_font_size_override("font_size", 13)
	return b

static func swatch_rect(color_a: Color, color_b: Color, min_h: float = 120.0) -> ColorRect:
	var r := ColorRect.new()
	r.color = color_a
	r.custom_minimum_size = Vector2(0, min_h)
	r.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	r.size_flags_vertical = Control.SIZE_EXPAND_FILL
	# Second tone via child
	var overlay := ColorRect.new()
	overlay.color = Color(color_b.r, color_b.g, color_b.b, 0.55)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.anchor_left = 0.35
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	r.add_child(overlay)
	var shine := ColorRect.new()
	shine.color = Color(1, 1, 1, 0.12)
	shine.set_anchors_preset(Control.PRESET_TOP_WIDE)
	shine.anchor_bottom = 0.35
	shine.mouse_filter = Control.MOUSE_FILTER_IGNORE
	r.add_child(shine)
	return r

static func status_badge(status: String) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 7)
	var dot := ColorRect.new()
	dot.custom_minimum_size = Vector2(8, 8)
	dot.color = status_color(status)
	dot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	row.add_child(dot)
	var label := make_label(MockData.STATUS_LABELS.get(status, status), 12, INK_SOFT)
	row.add_child(label)
	return row

static func spacer(h: float = 12.0) -> Control:
	var c := Control.new()
	c.custom_minimum_size = Vector2(0, h)
	return c

static func section_title(text: String) -> Label:
	return make_display(text, 22)
