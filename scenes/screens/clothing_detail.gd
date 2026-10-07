extends VBoxContainer

var item_id: String = ""
var editing := false

func setup(params: Dictionary = {}) -> void:
	item_id = params.get("id", "")

func _ready() -> void:
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_theme_constant_override("separation", 10)
	_build()

func _build() -> void:
	for c in get_children():
		c.queue_free()

	var item := AppState.get_clothing(item_id)
	if item == null:
		add_child(PhiliaStyle.make_label("Vêtement introuvable."))
		return

	var back := Button.new()
	back.text = "← Retour"
	back.flat = true
	back.add_theme_color_override("font_color", PhiliaStyle.INK_SOFT)
	back.pressed.connect(func(): Nav.back())
	add_child(back)

	var media := PhiliaStyle.swatch_rect(item.color_a, item.color_b, 280)
	media.custom_minimum_size = Vector2(0, 280)
	add_child(media)
	add_child(PhiliaStyle.make_display(item.name, 34))
	add_child(PhiliaStyle.status_badge(item.status))

	if editing:
		_build_edit_form(item)
	else:
		var grid := GridContainer.new()
		grid.columns = 2
		grid.add_theme_constant_override("h_separation", 10)
		grid.add_theme_constant_override("v_separation", 10)
		add_child(grid)
		for pair in [
			["Catégorie", MockData.category_label(item.category)],
			["Couleur", item.color],
			["Style", item.style],
			["Saison", " · ".join(item.seasons)],
			["Marque", item.brand if item.brand else "—"],
			["Taille", item.size if item.size else "—"],
		]:
			grid.add_child(_meta_cell(pair[0], pair[1]))
		if item.notes != "":
			add_child(PhiliaStyle.make_label(item.notes, 13, PhiliaStyle.MUTED))
		var edit_btn := PhiliaStyle.secondary_button("Modifier les infos")
		edit_btn.pressed.connect(func():
			editing = true
			_build()
		)
		add_child(edit_btn)

	add_child(PhiliaStyle.section_title("Modifier le statut"))
	for status in ["available", "laundry", "unavailable"]:
		var btn := Button.new()
		btn.custom_minimum_size = Vector2(0, 48)
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var active := item.status == status
		var sb := PhiliaStyle.panel_style(PhiliaStyle.ACCENT_SOFT if active else PhiliaStyle.SURFACE, 16)
		if active:
			sb.border_color = PhiliaStyle.ACCENT
			sb.set_border_width_all(1)
		btn.add_theme_stylebox_override("normal", sb)
		btn.add_theme_stylebox_override("hover", sb)
		btn.add_theme_stylebox_override("pressed", sb)
		var row := HBoxContainer.new()
		row.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		row.add_child(PhiliaStyle.status_badge(status))
		btn.add_child(row)
		var st := status
		btn.pressed.connect(func():
			AppState.set_clothing_status(item.id, st)
			_build()
		)
		add_child(btn)

func _meta_cell(k: String, v: String) -> PanelContainer:
	var cell := PanelContainer.new()
	cell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cell.add_theme_stylebox_override("panel", PhiliaStyle.panel_style(PhiliaStyle.SURFACE, 14))
	var col := VBoxContainer.new()
	col.add_child(PhiliaStyle.make_label(k.to_upper(), 10, PhiliaStyle.MUTED))
	col.add_child(PhiliaStyle.make_label(v, 14))
	cell.add_child(col)
	return cell

func _build_edit_form(item: ClothingItem) -> void:
	var name_edit := LineEdit.new()
	name_edit.text = item.name
	name_edit.placeholder_text = "Nom"
	add_child(PhiliaStyle.make_label("NOM", 11, PhiliaStyle.MUTED))
	add_child(name_edit)

	add_child(PhiliaStyle.make_label("CATÉGORIE", 11, PhiliaStyle.MUTED))
	var cat := OptionButton.new()
	var cats := ["hauts", "bas", "vestes", "chaussures", "accessoires"]
	for c in cats:
		cat.add_item(MockData.category_label(c))
	var cat_idx := cats.find(item.category)
	cat.select(cat_idx if cat_idx >= 0 else 0)
	add_child(cat)

	add_child(PhiliaStyle.make_label("COULEUR", 11, PhiliaStyle.MUTED))
	var color_edit := LineEdit.new()
	color_edit.text = item.color
	add_child(color_edit)

	add_child(PhiliaStyle.make_label("STYLE", 11, PhiliaStyle.MUTED))
	var style_edit := LineEdit.new()
	style_edit.text = item.style
	add_child(style_edit)

	add_child(PhiliaStyle.make_label("MARQUE", 11, PhiliaStyle.MUTED))
	var brand_edit := LineEdit.new()
	brand_edit.text = item.brand
	add_child(brand_edit)

	add_child(PhiliaStyle.make_label("TAILLE", 11, PhiliaStyle.MUTED))
	var size_edit := LineEdit.new()
	size_edit.text = item.size
	add_child(size_edit)

	add_child(PhiliaStyle.make_label("NOTES", 11, PhiliaStyle.MUTED))
	var notes_edit := TextEdit.new()
	notes_edit.text = item.notes
	notes_edit.custom_minimum_size = Vector2(0, 80)
	add_child(notes_edit)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	add_child(row)
	var cancel := PhiliaStyle.ghost_button("Annuler")
	cancel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cancel.pressed.connect(func():
		editing = false
		_build()
	)
	row.add_child(cancel)
	var save := PhiliaStyle.primary_button("Enregistrer")
	save.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	save.pressed.connect(func():
		AppState.update_clothing(item.id, {
			"name": name_edit.text,
			"category": cats[cat.selected],
			"color": color_edit.text,
			"style": style_edit.text,
			"brand": brand_edit.text,
			"size": size_edit.text,
			"notes": notes_edit.text,
		})
		editing = false
		_build()
	)
	row.add_child(save)
