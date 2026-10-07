extends VBoxContainer

const ClothingCardScript = preload("res://scenes/ui/clothing_card.gd")
const LookCardScript = preload("res://scenes/ui/look_card.gd")

func setup(_params: Dictionary = {}) -> void:
	pass

func _ready() -> void:
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_theme_constant_override("separation", 8)
	_build()

func _build() -> void:
	for c in get_children():
		c.queue_free()

	var profile := AppState.profile
	var weather := AppState.weather
	var look := AppState.get_look("l01")
	if look == null and AppState.looks.size() > 0:
		look = AppState.looks[0]

	add_child(PhiliaStyle.make_kicker("Aujourd'hui"))
	var hello := PhiliaStyle.make_display("Bonjour %s" % profile.get("first_name", ""), 40)
	add_child(hello)

	var weather_pill := PanelContainer.new()
	var wsb := PhiliaStyle.button_style(Color(1, 1, 1, 0.45), 999)
	wsb.border_color = PhiliaStyle.LINE
	wsb.set_border_width_all(1)
	wsb.content_margin_left = 12
	wsb.content_margin_right = 12
	wsb.content_margin_top = 8
	wsb.content_margin_bottom = 8
	weather_pill.add_theme_stylebox_override("panel", wsb)
	weather_pill.add_child(PhiliaStyle.make_label("%d°C · %s" % [weather.get("temp", 0), weather.get("label", "")], 13, PhiliaStyle.INK_SOFT))
	add_child(weather_pill)
	add_child(PhiliaStyle.spacer(14))

	# Outfit hero
	var hero := PanelContainer.new()
	hero.add_theme_stylebox_override("panel", PhiliaStyle.panel_style(PhiliaStyle.SURFACE, 28))
	add_child(hero)
	var hero_v := VBoxContainer.new()
	hero_v.add_theme_constant_override("separation", 12)
	hero.add_child(hero_v)

	var pieces_row := HBoxContainer.new()
	pieces_row.add_theme_constant_override("separation", 6)
	pieces_row.custom_minimum_size = Vector2(0, 150)
	hero_v.add_child(pieces_row)
	if look:
		for item in AppState.resolve_look_items(look).slice(0, 4):
			var p := PhiliaStyle.swatch_rect(item.color_a, item.color_b, 140)
			p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			pieces_row.add_child(p)

	var hero_body := VBoxContainer.new()
	hero_body.add_theme_constant_override("separation", 6)
	hero_v.add_child(hero_body)
	hero_body.add_child(PhiliaStyle.make_kicker("Ton look du jour"))
	if look:
		hero_body.add_child(PhiliaStyle.make_display(look.name, 28))
		hero_body.add_child(PhiliaStyle.make_label(look.style, 13, PhiliaStyle.MUTED))
		hero_body.add_child(PhiliaStyle.make_label("%d%% de compatibilité" % look.score, 13, PhiliaStyle.ACCENT))
		var cta := PhiliaStyle.primary_button("Habille-moi")
		cta.pressed.connect(func(): Nav.go("style_me"))
		hero_body.add_child(cta)
		var see := PhiliaStyle.ghost_button("Voir la tenue")
		see.pressed.connect(func(): Nav.go("look_detail", {"id": look.id}))
		hero_body.add_child(see)

	add_child(PhiliaStyle.spacer(18))
	add_child(PhiliaStyle.section_title("Pour aujourd'hui"))
	var occ := GridContainer.new()
	occ.columns = 2
	occ.add_theme_constant_override("h_separation", 10)
	occ.add_theme_constant_override("v_separation", 10)
	add_child(occ)
	for pair in [["Journée normale", "◎"], ["Sortie", "◐"], ["Travail", "▢"], ["Soirée", "✧"]]:
		occ.add_child(_occasion_tile(pair[0], pair[1]))

	add_child(PhiliaStyle.spacer(18))
	var fav_head := HBoxContainer.new()
	fav_head.add_child(PhiliaStyle.section_title("Tes favoris"))
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	fav_head.add_child(spacer)
	var all_btn := Button.new()
	all_btn.text = "Voir tout"
	all_btn.flat = true
	all_btn.add_theme_color_override("font_color", PhiliaStyle.ACCENT)
	all_btn.pressed.connect(func(): Nav.go("looks"))
	fav_head.add_child(all_btn)
	add_child(fav_head)

	var fav_scroll := ScrollContainer.new()
	fav_scroll.custom_minimum_size = Vector2(0, 280)
	fav_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(fav_scroll)
	var fav_row := HBoxContainer.new()
	fav_row.add_theme_constant_override("separation", 12)
	fav_scroll.add_child(fav_row)
	for l in AppState.favorite_looks().slice(0, 4):
		var card := LookCardScript.new()
		fav_row.add_child(card)
		card.setup(l, true)
		card.look_pressed.connect(func(id): Nav.go("look_detail", {"id": id}))
		card.favorite_pressed.connect(func(id):
			AppState.toggle_favorite(id)
			_build()
		)

	add_child(PhiliaStyle.spacer(12))
	var dress_head := HBoxContainer.new()
	dress_head.add_child(PhiliaStyle.section_title("Dressing"))
	var sp2 := Control.new()
	sp2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	dress_head.add_child(sp2)
	var open_d := Button.new()
	open_d.text = "Ouvrir"
	open_d.flat = true
	open_d.add_theme_color_override("font_color", PhiliaStyle.ACCENT)
	open_d.pressed.connect(func(): Nav.go("dressing"))
	dress_head.add_child(open_d)
	add_child(dress_head)

	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 12)
	grid.add_theme_constant_override("v_separation", 12)
	add_child(grid)
	for item in AppState.clothes.slice(0, 4):
		var card := ClothingCardScript.new()
		grid.add_child(card)
		card.setup(item)
		card.clothing_pressed.connect(func(id): Nav.go("clothing_detail", {"id": id}))

func _occasion_tile(label: String, icon: String) -> Button:
	var b := Button.new()
	b.custom_minimum_size = Vector2(0, 88)
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var sb := PhiliaStyle.panel_style(PhiliaStyle.SURFACE, 18)
	b.add_theme_stylebox_override("normal", sb)
	b.add_theme_stylebox_override("hover", sb)
	b.add_theme_stylebox_override("pressed", sb)
	var v := VBoxContainer.new()
	v.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var icon_panel := PanelContainer.new()
	icon_panel.custom_minimum_size = Vector2(28, 28)
	var isb := PhiliaStyle.panel_style(PhiliaStyle.ACCENT_SOFT, 8)
	isb.content_margin_left = 4
	isb.content_margin_right = 4
	icon_panel.add_theme_stylebox_override("panel", isb)
	var il := PhiliaStyle.make_label(icon, 12, PhiliaStyle.ACCENT)
	il.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	icon_panel.add_child(il)
	v.add_child(icon_panel)
	v.add_child(PhiliaStyle.make_label(label, 14, PhiliaStyle.INK))
	v.add_child(PhiliaStyle.make_label("Suggérer une tenue", 11, PhiliaStyle.MUTED))
	b.add_child(v)
	b.pressed.connect(func(): Nav.go("style_me"))
	return b
