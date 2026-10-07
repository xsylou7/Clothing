extends Control

signal closed
signal navigated(screen_id: String)

var _panel: PanelContainer
var _open := false
var _item_buttons: Array[Button] = []

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	visible = true
	modulate.a = 1.0

	var backdrop := ColorRect.new()
	backdrop.name = "Backdrop"
	backdrop.color = Color(0.08, 0.09, 0.086, 0.28)
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	backdrop.modulate.a = 0.0
	add_child(backdrop)
	backdrop.gui_input.connect(_on_backdrop_input)

	_panel = PanelContainer.new()
	_panel.name = "Panel"
	_panel.set_anchors_preset(Control.PRESET_TOP_WIDE)
	_panel.anchor_bottom = 0.0
	_panel.offset_left = 0
	_panel.offset_right = 0
	_panel.offset_top = 0
	_panel.grow_vertical = Control.GROW_DIRECTION_BEGIN
	var sb := StyleBoxFlat.new()
	sb.bg_color = PhiliaStyle.MENU_BG
	sb.set_corner_radius_all(0)
	sb.corner_radius_bottom_left = 32
	sb.corner_radius_bottom_right = 32
	sb.content_margin_left = 22
	sb.content_margin_right = 22
	sb.content_margin_top = 28
	sb.content_margin_bottom = 28
	_panel.add_theme_stylebox_override("panel", sb)
	add_child(_panel)

	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 8)
	_panel.add_child(v)

	var top := HBoxContainer.new()
	v.add_child(top)
	var brand_col := VBoxContainer.new()
	brand_col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	brand_col.add_child(PhiliaStyle.make_display("Philia", 34, PhiliaStyle.SURFACE))
	brand_col.add_child(PhiliaStyle.make_label("PERSONAL STYLIST", 11, Color(1, 1, 1, 0.45)))
	top.add_child(brand_col)

	var close_btn := Button.new()
	close_btn.text = "✕"
	close_btn.custom_minimum_size = Vector2(44, 44)
	var csb := PhiliaStyle.button_style(Color(1, 1, 1, 0.08), 999)
	csb.border_color = Color(1, 1, 1, 0.18)
	csb.set_border_width_all(1)
	close_btn.add_theme_stylebox_override("normal", csb)
	close_btn.add_theme_stylebox_override("hover", csb)
	close_btn.add_theme_stylebox_override("pressed", csb)
	close_btn.add_theme_color_override("font_color", PhiliaStyle.SURFACE)
	top.add_child(close_btn)
	close_btn.pressed.connect(func(): set_open(false))

	v.add_child(PhiliaStyle.spacer(18))

	for item in MockData.nav_items():
		var btn := _make_nav_item(item)
		v.add_child(btn)
		_item_buttons.append(btn)

	v.add_child(PhiliaStyle.spacer(16))
	var footer := PhiliaStyle.make_label("Prototype visuel · données fictives", 12, Color(1, 1, 1, 0.4))
	footer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(footer)

	# Start hidden above
	await get_tree().process_frame
	_panel.position.y = -_panel.size.y - 20
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	Nav.menu_toggled.connect(_on_menu_toggled)
	_sync_active()

func _make_nav_item(item: Dictionary) -> Button:
	var btn := Button.new()
	btn.custom_minimum_size = Vector2(0, 72)
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0, 0, 0, 0)
	sb.set_corner_radius_all(18)
	sb.content_margin_left = 14
	sb.content_margin_right = 14
	sb.content_margin_top = 12
	sb.content_margin_bottom = 12
	btn.add_theme_stylebox_override("normal", sb)
	var sb_h := sb.duplicate()
	sb_h.bg_color = Color(1, 1, 1, 0.08)
	btn.add_theme_stylebox_override("hover", sb_h)
	btn.add_theme_stylebox_override("pressed", sb_h)
	btn.set_meta("screen_id", item["id"])
	btn.set_meta("base_style", sb)
	btn.set_meta("active_style", sb_h)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 14)
	row.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	btn.add_child(row)

	var icon := PanelContainer.new()
	icon.custom_minimum_size = Vector2(42, 42)
	var isb := StyleBoxFlat.new()
	isb.bg_color = Color(1, 1, 1, 0.08)
	isb.set_corner_radius_all(14)
	isb.border_color = Color(1, 1, 1, 0.1)
	isb.set_border_width_all(1)
	icon.add_theme_stylebox_override("panel", isb)
	var icon_l := PhiliaStyle.make_label(_icon_for(item["id"]), 16, PhiliaStyle.SURFACE)
	icon_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	icon_l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	icon.add_child(icon_l)
	row.add_child(icon)

	var text_col := VBoxContainer.new()
	text_col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_col.mouse_filter = Control.MOUSE_FILTER_IGNORE
	text_col.add_child(PhiliaStyle.make_display(item["label"], 26, PhiliaStyle.SURFACE))
	text_col.add_child(PhiliaStyle.make_label(item["desc"], 12, Color(1, 1, 1, 0.45)))
	row.add_child(text_col)

	var mark := ColorRect.new()
	mark.custom_minimum_size = Vector2(8, 8)
	mark.color = PhiliaStyle.ACCENT_WARM
	mark.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	mark.visible = false
	mark.name = "Mark"
	row.add_child(mark)

	btn.pressed.connect(func():
		navigated.emit(item["id"])
		set_open(false)
		Nav.go(item["id"])
	)
	return btn

func _icon_for(id: String) -> String:
	match id:
		"home": return "⌂"
		"dressing": return "◷"
		"looks": return "✦"
		"inspiration": return "▣"
		"profile": return "☺"
		_: return "·"

func _on_backdrop_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		set_open(false)

func _on_menu_toggled(open: bool) -> void:
	set_open(open)

func set_open(open: bool) -> void:
	if _open == open:
		if open:
			_sync_active()
		return
	_open = open
	AppState.menu_open = open
	var backdrop: ColorRect = $Backdrop
	var tween := create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	if open:
		_sync_active()
		backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
		mouse_filter = Control.MOUSE_FILTER_STOP
		_panel.position.y = -_panel.size.y - 20
		tween.tween_property(_panel, "position:y", 0.0, 0.45)
		tween.tween_property(backdrop, "modulate:a", 1.0, 0.35)
		_stagger_items()
	else:
		tween.tween_property(_panel, "position:y", -_panel.size.y - 24.0, 0.4)
		tween.tween_property(backdrop, "modulate:a", 0.0, 0.3)
		tween.chain().tween_callback(func():
			backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
			mouse_filter = Control.MOUSE_FILTER_IGNORE
			closed.emit()
		)

func _stagger_items() -> void:
	for i in _item_buttons.size():
		var btn := _item_buttons[i]
		btn.modulate.a = 0.0
		btn.position.y = -10
		var t := create_tween()
		t.set_ease(Tween.EASE_OUT)
		t.set_trans(Tween.TRANS_CUBIC)
		t.tween_property(btn, "modulate:a", 1.0, 0.35).set_delay(0.08 + i * 0.06)

func _sync_active() -> void:
	for btn in _item_buttons:
		var sid: String = btn.get_meta("screen_id")
		var active := sid == Nav.current_screen or (Nav.current_screen in ["style_me", "look_detail"] and sid == "home") or (Nav.current_screen in ["clothing_detail", "add_clothing"] and sid == "dressing")
		var mark: ColorRect = btn.find_child("Mark", true, false)
		if mark:
			mark.visible = active
		var style: StyleBoxFlat = btn.get_meta("active_style") if active else btn.get_meta("base_style")
		btn.add_theme_stylebox_override("normal", style)
