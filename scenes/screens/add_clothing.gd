extends VBoxContainer

enum Step { CHOOSE, ANALYZING, REVIEW }

var step: Step = Step.CHOOSE
var draft := {
	"name": "Jean bleu",
	"category": "bas",
	"color": "Bleu",
	"style": "Casual",
	"color_a": Color("2f4f7a"),
	"color_b": Color("1e3558"),
}

func setup(_params: Dictionary = {}) -> void:
	pass

func _ready() -> void:
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_theme_constant_override("separation", 12)
	_build()

func _build() -> void:
	for c in get_children():
		c.queue_free()

	var back := Button.new()
	back.text = "← Retour"
	back.flat = true
	back.add_theme_color_override("font_color", PhiliaStyle.INK_SOFT)
	back.pressed.connect(func():
		if step == Step.REVIEW:
			step = Step.CHOOSE
			_build()
		else:
			Nav.back()
	)
	add_child(back)

	match step:
		Step.CHOOSE:
			_build_choose()
		Step.ANALYZING:
			_build_analyzing()
		Step.REVIEW:
			_build_review()

func _build_choose() -> void:
	add_child(PhiliaStyle.make_kicker("Nouveau"))
	add_child(PhiliaStyle.make_display("Ajouter un vêtement", 32))
	add_child(PhiliaStyle.make_label("Prends une photo ou choisis-en une — l'analyse est simulée.", 13, PhiliaStyle.MUTED))

	for pair in [["◎", "Prendre une photo", "Utiliser l'appareil"], ["▢", "Choisir une photo", "Depuis la galerie"]]:
		var btn := Button.new()
		btn.custom_minimum_size = Vector2(0, 72)
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var sb := PhiliaStyle.panel_style(PhiliaStyle.SURFACE, 22)
		btn.add_theme_stylebox_override("normal", sb)
		btn.add_theme_stylebox_override("hover", sb)
		btn.add_theme_stylebox_override("pressed", sb)
		var h := HBoxContainer.new()
		h.add_theme_constant_override("separation", 14)
		h.mouse_filter = Control.MOUSE_FILTER_IGNORE
		h.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		var icon := PanelContainer.new()
		icon.custom_minimum_size = Vector2(48, 48)
		icon.add_theme_stylebox_override("panel", PhiliaStyle.panel_style(PhiliaStyle.ACCENT_SOFT, 16))
		var il := PhiliaStyle.make_label(pair[0], 16, PhiliaStyle.ACCENT)
		il.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		il.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		icon.add_child(il)
		h.add_child(icon)
		var col := VBoxContainer.new()
		col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		col.mouse_filter = Control.MOUSE_FILTER_IGNORE
		col.add_child(PhiliaStyle.make_label(pair[1], 15))
		col.add_child(PhiliaStyle.make_label(pair[2], 12, PhiliaStyle.MUTED))
		h.add_child(col)
		btn.add_child(h)
		btn.pressed.connect(_start_analysis)
		add_child(btn)

func _build_analyzing() -> void:
	add_child(PhiliaStyle.spacer(60))
	var box := VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 14)
	add_child(box)
	var bar := ProgressBar.new()
	bar.custom_minimum_size = Vector2(200, 8)
	bar.value = 20
	bar.show_percentage = false
	box.add_child(bar)
	box.add_child(PhiliaStyle.make_display("Analyse de ton vêtement…", 26))
	box.add_child(PhiliaStyle.make_label("Détection de la catégorie, couleur et style.", 13, PhiliaStyle.MUTED))
	var tween := create_tween()
	tween.tween_property(bar, "value", 100.0, 1.6)
	await tween.finished
	step = Step.REVIEW
	_build()

func _build_review() -> void:
	add_child(PhiliaStyle.make_kicker("Résultat"))
	add_child(PhiliaStyle.make_display("Nous pensons qu'il s'agit de :", 28))

	var preview := PanelContainer.new()
	preview.add_theme_stylebox_override("panel", PhiliaStyle.panel_style(PhiliaStyle.SURFACE, 24))
	add_child(preview)
	var pv := VBoxContainer.new()
	pv.add_theme_constant_override("separation", 12)
	preview.add_child(pv)
	pv.add_child(PhiliaStyle.swatch_rect(draft["color_a"], draft["color_b"], 180))

	add_child(PhiliaStyle.make_label("NOM", 11, PhiliaStyle.MUTED))
	var name_edit := LineEdit.new()
	name_edit.text = draft["name"]
	add_child(name_edit)

	add_child(PhiliaStyle.make_label("CATÉGORIE", 11, PhiliaStyle.MUTED))
	var cat := OptionButton.new()
	var cats := ["hauts", "bas", "vestes", "chaussures", "accessoires"]
	for c in cats:
		cat.add_item(MockData.category_label(c))
	cat.select(1)
	add_child(cat)

	add_child(PhiliaStyle.make_label("COULEUR", 11, PhiliaStyle.MUTED))
	var color_edit := LineEdit.new()
	color_edit.text = draft["color"]
	add_child(color_edit)

	add_child(PhiliaStyle.make_label("STYLE", 11, PhiliaStyle.MUTED))
	var style_edit := LineEdit.new()
	style_edit.text = draft["style"]
	add_child(style_edit)

	var save := PhiliaStyle.primary_button("Enregistrer dans le dressing")
	save.pressed.connect(func():
		var item := ClothingItem.new()
		item.id = "c%d" % Time.get_ticks_msec()
		item.name = name_edit.text
		item.category = cats[cat.selected]
		item.color = color_edit.text
		item.style = style_edit.text
		item.seasons = PackedStringArray(["Printemps", "Été", "Automne"])
		item.status = "available"
		item.notes = "Ajouté via prototype"
		item.color_a = draft["color_a"]
		item.color_b = draft["color_b"]
		AppState.add_clothing(item)
		Nav.go("clothing_detail", {"id": item.id}, false)
	)
	add_child(save)

func _start_analysis() -> void:
	step = Step.ANALYZING
	_build()
