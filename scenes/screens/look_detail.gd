extends VBoxContainer

var look_id: String = ""

func setup(params: Dictionary = {}) -> void:
	look_id = params.get("id", "")

func _ready() -> void:
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_theme_constant_override("separation", 10)
	_build()

func _build() -> void:
	for c in get_children():
		c.queue_free()

	var look := AppState.get_look(look_id)
	if look == null:
		add_child(PhiliaStyle.make_label("Look introuvable."))
		return

	var back := Button.new()
	back.text = "← Retour"
	back.flat = true
	back.add_theme_color_override("font_color", PhiliaStyle.INK_SOFT)
	back.pressed.connect(func(): Nav.back())
	add_child(back)

	add_child(PhiliaStyle.make_kicker(look.occasion))
	add_child(PhiliaStyle.make_display(look.name, 36))
	add_child(PhiliaStyle.make_label(look.style, 14, PhiliaStyle.MUTED))
	add_child(PhiliaStyle.make_label("%d%% compatible avec ton style" % look.score, 14, PhiliaStyle.ACCENT))

	var items := AppState.resolve_look_items(look)
	for i in items.size():
		if i > 0:
			var plus := PhiliaStyle.make_label("+", 14, PhiliaStyle.MUTED)
			plus.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			add_child(plus)
		var item: ClothingItem = items[i]
		var row := Button.new()
		row.custom_minimum_size = Vector2(0, 88)
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var sb := PhiliaStyle.panel_style(PhiliaStyle.SURFACE, 18)
		row.add_theme_stylebox_override("normal", sb)
		row.add_theme_stylebox_override("hover", sb)
		row.add_theme_stylebox_override("pressed", sb)
		var h := HBoxContainer.new()
		h.add_theme_constant_override("separation", 12)
		h.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		h.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(h)
		var thumb := PhiliaStyle.swatch_rect(item.color_a, item.color_b, 72)
		thumb.custom_minimum_size = Vector2(72, 72)
		thumb.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		thumb.mouse_filter = Control.MOUSE_FILTER_IGNORE
		h.add_child(thumb)
		var col := VBoxContainer.new()
		col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		col.mouse_filter = Control.MOUSE_FILTER_IGNORE
		col.add_child(PhiliaStyle.make_label(item.name, 15))
		col.add_child(PhiliaStyle.make_label("%s · %s" % [MockData.category_label(item.category), item.color], 12, PhiliaStyle.MUTED))
		col.add_child(PhiliaStyle.status_badge(item.status))
		h.add_child(col)
		h.add_child(PhiliaStyle.make_label("›", 18, PhiliaStyle.MUTED))
		var cid := item.id
		row.pressed.connect(func(): Nav.go("clothing_detail", {"id": cid}))
		add_child(row)

	var fav := PhiliaStyle.primary_button("♥ Dans les favoris" if look.favorite else "♡ Ajouter aux favoris")
	fav.pressed.connect(func():
		AppState.toggle_favorite(look.id)
		_build()
	)
	add_child(fav)
	var edit := PhiliaStyle.secondary_button("Modifier la tenue")
	edit.pressed.connect(func(): print("Prototype: remplacement pièce à pièce"))
	add_child(edit)
	var regen := PhiliaStyle.ghost_button("✦ Générer une autre tenue")
	regen.pressed.connect(func(): Nav.go("style_me"))
	add_child(regen)
