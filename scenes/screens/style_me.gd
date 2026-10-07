extends VBoxContainer

const OCCASIONS := ["Quotidien", "Travail", "Sortie", "Soirée", "Sport", "Rendez-vous"]
const STYLES := ["Casual", "Élégant", "Minimal", "Streetwear", "Surprise"]

var _gen_area: VBoxContainer
var _generating := false

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
	back.pressed.connect(func(): Nav.back())
	add_child(back)

	add_child(PhiliaStyle.make_kicker("Styliste"))
	add_child(PhiliaStyle.make_display("Que veux-tu porter aujourd'hui ?", 32))

	add_child(PhiliaStyle.make_label("OCCASION", 11, PhiliaStyle.MUTED))
	var occ_wrap := HFlowContainer.new()
	occ_wrap.add_theme_constant_override("h_separation", 8)
	occ_wrap.add_theme_constant_override("v_separation", 8)
	add_child(occ_wrap)
	for o in OCCASIONS:
		var active := AppState.style_me_occasion == o
		var chip := PhiliaStyle.chip(o, active)
		var occasion := o
		chip.pressed.connect(func():
			AppState.style_me_occasion = occasion
			_build()
		)
		occ_wrap.add_child(chip)

	add_child(PhiliaStyle.make_label("STYLE", 11, PhiliaStyle.MUTED))
	var style_wrap := HFlowContainer.new()
	style_wrap.add_theme_constant_override("h_separation", 8)
	style_wrap.add_theme_constant_override("v_separation", 8)
	add_child(style_wrap)
	for s in STYLES:
		var active := AppState.style_me_style == s
		var chip := PhiliaStyle.chip(s, active)
		var style_name := s
		chip.pressed.connect(func():
			AppState.style_me_style = style_name
			_build()
		)
		style_wrap.add_child(chip)

	add_child(PhiliaStyle.make_label("MÉTÉO", 11, PhiliaStyle.MUTED))
	var w := AppState.weather
	var weather_pill := PanelContainer.new()
	var wsb := PhiliaStyle.button_style(Color(1, 1, 1, 0.45), 999)
	wsb.border_color = PhiliaStyle.LINE
	wsb.set_border_width_all(1)
	weather_pill.add_theme_stylebox_override("panel", wsb)
	weather_pill.add_child(PhiliaStyle.make_label("%d°C · %s" % [w.get("temp", 0), w.get("label", "")], 13, PhiliaStyle.INK_SOFT))
	add_child(weather_pill)
	add_child(PhiliaStyle.make_label("Les vêtements indisponibles ou au lavage seront ignorés.", 12, PhiliaStyle.MUTED))

	var gen := PhiliaStyle.primary_button("✦ Générer ma tenue")
	gen.disabled = _generating
	gen.pressed.connect(_generate)
	add_child(gen)

	_gen_area = VBoxContainer.new()
	_gen_area.add_theme_constant_override("separation", 12)
	add_child(_gen_area)

func _generate() -> void:
	if _generating:
		return
	_generating = true
	_build()
	for c in _gen_area.get_children():
		c.queue_free()
	var box := VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 14)
	_gen_area.add_child(box)
	box.add_child(PhiliaStyle.spacer(24))
	var ring := ProgressBar.new()
	ring.custom_minimum_size = Vector2(64, 8)
	ring.value = 40
	ring.show_percentage = false
	box.add_child(ring)
	box.add_child(PhiliaStyle.make_display("Composition en cours…", 24))
	box.add_child(PhiliaStyle.make_label("On croise ton dressing, ton style et la météo.", 13, PhiliaStyle.MUTED))

	var tween := create_tween()
	tween.tween_property(ring, "value", 100.0, 1.2)
	await tween.finished
	var look := AppState.generate_look_from_prefs()
	_generating = false
	Nav.go("look_detail", {"id": look.id})
