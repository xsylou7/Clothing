extends PanelContainer

signal look_pressed(look_id: String)
signal favorite_pressed(look_id: String)

var look: LookItem
var compact: bool = false

func setup(p_look: LookItem, p_compact: bool = false) -> void:
	look = p_look
	compact = p_compact
	add_theme_stylebox_override("panel", PhiliaStyle.panel_style(PhiliaStyle.SURFACE, 22))
	custom_minimum_size = Vector2(260 if compact else 0, 0)
	if compact:
		size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	else:
		size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 10)
	add_child(v)

	var open_btn := Button.new()
	open_btn.flat = true
	open_btn.custom_minimum_size = Vector2(0, 170 if not compact else 150)
	open_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var empty := StyleBoxEmpty.new()
	open_btn.add_theme_stylebox_override("normal", empty)
	open_btn.add_theme_stylebox_override("hover", empty)
	open_btn.add_theme_stylebox_override("pressed", empty)
	v.add_child(open_btn)

	var stack_bg := PanelContainer.new()
	stack_bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	stack_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var stack_style := PhiliaStyle.panel_style(PhiliaStyle.BG_DEEP, 14)
	stack_style.content_margin_left = 8
	stack_style.content_margin_right = 8
	stack_style.content_margin_top = 8
	stack_style.content_margin_bottom = 8
	stack_bg.add_theme_stylebox_override("panel", stack_style)
	open_btn.add_child(stack_bg)

	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 4)
	grid.add_theme_constant_override("v_separation", 4)
	grid.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	grid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stack_bg.add_child(grid)

	var items := AppState.resolve_look_items(look)
	var shown := mini(4, items.size())
	for i in shown:
		var piece := PhiliaStyle.swatch_rect(items[i].color_a, items[i].color_b, 70)
		piece.custom_minimum_size = Vector2(0, 70)
		piece.mouse_filter = Control.MOUSE_FILTER_IGNORE
		if i == 0 and shown > 1:
			piece.custom_minimum_size = Vector2(0, 148)
		grid.add_child(piece)

	open_btn.pressed.connect(func(): look_pressed.emit(look.id))

	var body := HBoxContainer.new()
	body.add_theme_constant_override("separation", 8)
	v.add_child(body)

	var info := VBoxContainer.new()
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info.add_theme_constant_override("separation", 4)
	body.add_child(info)
	info.add_child(PhiliaStyle.make_display(look.name, 20))
	info.add_child(PhiliaStyle.make_label("%s · %s" % [look.style, look.occasion], 12, PhiliaStyle.MUTED))
	info.add_child(PhiliaStyle.make_label("%d%% de compatibilité" % look.score, 12, PhiliaStyle.ACCENT))

	var fav := Button.new()
	fav.custom_minimum_size = Vector2(36, 36)
	fav.text = "♥" if look.favorite else "♡"
	var fsb := PhiliaStyle.button_style(PhiliaStyle.ACCENT_WARM_SOFT if look.favorite else PhiliaStyle.SURFACE_2, 999)
	fsb.content_margin_left = 0
	fsb.content_margin_right = 0
	fav.add_theme_stylebox_override("normal", fsb)
	fav.add_theme_stylebox_override("hover", fsb)
	fav.add_theme_stylebox_override("pressed", fsb)
	fav.add_theme_color_override("font_color", Color("7a4e2e") if look.favorite else PhiliaStyle.INK_SOFT)
	body.add_child(fav)
	fav.pressed.connect(func():
		favorite_pressed.emit(look.id)
	)
