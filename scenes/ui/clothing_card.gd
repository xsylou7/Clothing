extends Button

signal clothing_pressed(item_id: String)

var item: ClothingItem

func setup(p_item: ClothingItem) -> void:
	item = p_item
	flat = true
	clip_contents = true
	custom_minimum_size = Vector2(0, 220)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var sb := PhiliaStyle.panel_style(PhiliaStyle.SURFACE, 18)
	sb.content_margin_left = 0
	sb.content_margin_right = 0
	sb.content_margin_top = 0
	sb.content_margin_bottom = 0
	add_theme_stylebox_override("normal", sb)
	add_theme_stylebox_override("hover", sb)
	add_theme_stylebox_override("pressed", sb)

	var v := VBoxContainer.new()
	v.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(v)

	var media := PhiliaStyle.swatch_rect(item.color_a, item.color_b, 140)
	media.custom_minimum_size = Vector2(0, 140)
	media.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(media)

	var body := VBoxContainer.new()
	body.add_theme_constant_override("separation", 4)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_bottom", 12)
	margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(margin)
	margin.add_child(body)

	body.add_child(PhiliaStyle.make_label(item.name, 14, PhiliaStyle.INK))
	body.add_child(PhiliaStyle.make_label("%s · %s" % [MockData.category_label(item.category), item.color], 12, PhiliaStyle.MUTED))
	body.add_child(PhiliaStyle.status_badge(item.status))

	pressed.connect(func(): clothing_pressed.emit(item.id))
