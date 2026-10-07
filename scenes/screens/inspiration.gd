extends VBoxContainer

func setup(_params: Dictionary = {}) -> void:
	pass

func _ready() -> void:
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_theme_constant_override("separation", 12)

	add_child(PhiliaStyle.make_kicker("Moodboard"))
	add_child(PhiliaStyle.make_display("Inspiration", 36))

	var cta := PanelContainer.new()
	var csb := StyleBoxFlat.new()
	csb.bg_color = PhiliaStyle.ACCENT
	csb.set_corner_radius_all(28)
	csb.content_margin_left = 20
	csb.content_margin_right = 20
	csb.content_margin_top = 28
	csb.content_margin_bottom = 28
	cta.add_theme_stylebox_override("panel", csb)
	add_child(cta)
	var cta_v := VBoxContainer.new()
	cta_v.add_theme_constant_override("separation", 8)
	cta.add_child(cta_v)
	cta_v.add_child(PhiliaStyle.make_label("BIENTÔT", 11, Color(1, 1, 1, 0.5)))
	cta_v.add_child(PhiliaStyle.make_display("Une tenue que tu aimes ?", 28, PhiliaStyle.SURFACE))
	cta_v.add_child(PhiliaStyle.make_label("Ajoute une photo — Philia analysera le look et proposera de le recréer avec ton dressing.", 13, Color(1, 1, 1, 0.65)))
	var add_btn := PhiliaStyle.secondary_button("+ Ajouter une inspiration")
	add_btn.pressed.connect(func(): _toast("Prototype : ajout photo à venir."))
	cta_v.add_child(add_btn)

	add_child(PhiliaStyle.section_title("Tes inspirations"))
	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 10)
	grid.add_theme_constant_override("v_separation", 10)
	add_child(grid)
	for insp in AppState.inspirations:
		var card := Button.new()
		card.custom_minimum_size = Vector2(0, 160)
		card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		card.clip_contents = true
		var empty := StyleBoxEmpty.new()
		card.add_theme_stylebox_override("normal", empty)
		card.add_theme_stylebox_override("hover", empty)
		card.add_theme_stylebox_override("pressed", empty)
		var c0: Color = insp.colors[0] if insp.colors.size() > 0 else Color.GRAY
		var c1: Color = insp.colors[1] if insp.colors.size() > 1 else c0
		var sw := PhiliaStyle.swatch_rect(c0, c1, 160)
		sw.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		sw.mouse_filter = Control.MOUSE_FILTER_IGNORE
		card.add_child(sw)
		var cap := PhiliaStyle.make_label(insp.title, 13, Color.WHITE)
		cap.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
		cap.offset_top = -36
		cap.offset_left = 12
		cap.offset_bottom = -12
		card.add_child(cap)
		grid.add_child(card)

	var recreate := PanelContainer.new()
	recreate.add_theme_stylebox_override("panel", PhiliaStyle.panel_style(PhiliaStyle.ACCENT_WARM_SOFT, 22, Color(0.72, 0.6, 0.45, 0.35)))
	add_child(recreate)
	var rv := VBoxContainer.new()
	rv.add_theme_constant_override("separation", 8)
	recreate.add_child(rv)
	rv.add_child(PhiliaStyle.make_display("Recréer avec mon dressing", 22))
	rv.add_child(PhiliaStyle.make_label("Prototype : correspondance pièce par pièce à venir.", 13, PhiliaStyle.INK_SOFT))
	var try_btn := PhiliaStyle.secondary_button("Essayer (démo)")
	try_btn.pressed.connect(func(): _toast("Prototype : équivalents dressing bientôt."))
	rv.add_child(try_btn)

func _toast(msg: String) -> void:
	print(msg)
	# Lightweight in-app notice
	var notice := PhiliaStyle.make_label(msg, 12, PhiliaStyle.ACCENT)
	add_child(notice)
	await get_tree().create_timer(2.0).timeout
	if is_instance_valid(notice):
		notice.queue_free()
