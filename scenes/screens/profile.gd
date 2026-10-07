extends VBoxContainer

func setup(_params: Dictionary = {}) -> void:
	pass

func _ready() -> void:
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_theme_constant_override("separation", 12)

	var p := AppState.profile
	var s := AppState.stats()

	add_child(PhiliaStyle.make_kicker("Compte"))
	add_child(PhiliaStyle.make_display("Profil", 36))

	var head := HBoxContainer.new()
	head.add_theme_constant_override("separation", 16)
	add_child(head)
	var avatar := PanelContainer.new()
	avatar.custom_minimum_size = Vector2(76, 76)
	var asb := StyleBoxFlat.new()
	asb.bg_color = PhiliaStyle.ACCENT
	asb.set_corner_radius_all(999)
	avatar.add_theme_stylebox_override("panel", asb)
	var ini := PhiliaStyle.make_display(p.get("initials", "S"), 30, PhiliaStyle.SURFACE)
	ini.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ini.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	avatar.add_child(ini)
	head.add_child(avatar)
	var info := VBoxContainer.new()
	info.add_child(PhiliaStyle.make_display(p.get("first_name", ""), 30))
	info.add_child(PhiliaStyle.make_label(p.get("main_style", ""), 14, PhiliaStyle.MUTED))
	head.add_child(info)

	var stats_row := HBoxContainer.new()
	stats_row.add_theme_constant_override("separation", 8)
	add_child(stats_row)
	for pair in [[str(s["clothes"]), "Vêtements"], [str(s["looks"]), "Looks"], [str(s["favorites"]), "Favoris"]]:
		var cell := PanelContainer.new()
		cell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		cell.add_theme_stylebox_override("panel", PhiliaStyle.panel_style(PhiliaStyle.SURFACE, 16))
		var cv := VBoxContainer.new()
		cv.alignment = BoxContainer.ALIGNMENT_CENTER
		var val := PhiliaStyle.make_display(pair[0], 26)
		val.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		cv.add_child(val)
		var lab := PhiliaStyle.make_label(pair[1], 11, PhiliaStyle.MUTED)
		lab.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		cv.add_child(lab)
		cell.add_child(cv)
		stats_row.add_child(cell)

	add_child(PhiliaStyle.section_title("Mon style"))
	var tags := HFlowContainer.new()
	tags.add_theme_constant_override("h_separation", 8)
	tags.add_theme_constant_override("v_separation", 8)
	add_child(tags)
	for tag in p.get("style_tags", []):
		var active: bool = tag == "CASUAL"
		tags.add_child(PhiliaStyle.chip(tag, active))

	add_child(PhiliaStyle.make_label("Secondaires : %s" % " · ".join(p.get("secondary_styles", [])), 13, PhiliaStyle.MUTED))

	add_child(PhiliaStyle.section_title("Couleurs favorites"))
	var colors := HFlowContainer.new()
	colors.add_theme_constant_override("h_separation", 8)
	add_child(colors)
	for c in p.get("favorite_colors", []):
		colors.add_child(PhiliaStyle.chip(c, false))

	add_child(PhiliaStyle.section_title("Mes préférences"))
	for pref in p.get("preferences", []):
		var row := PanelContainer.new()
		row.add_theme_stylebox_override("panel", PhiliaStyle.panel_style(PhiliaStyle.SURFACE, 16))
		var h := HBoxContainer.new()
		h.add_child(PhiliaStyle.make_label(pref["label"], 14))
		var sp := Control.new()
		sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		h.add_child(sp)
		h.add_child(PhiliaStyle.make_label(pref["value"], 13, PhiliaStyle.MUTED))
		row.add_child(h)
		add_child(row)

	var weather := AppState.weather
	var wrow := PanelContainer.new()
	wrow.add_theme_stylebox_override("panel", PhiliaStyle.panel_style(PhiliaStyle.SURFACE, 16))
	var wh := HBoxContainer.new()
	wh.add_child(PhiliaStyle.make_label("Météo (démo)", 14))
	var wsp := Control.new()
	wsp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	wh.add_child(wsp)
	wh.add_child(PhiliaStyle.make_label("%d°C · %s" % [weather.get("temp", 0), weather.get("label", "")], 13, PhiliaStyle.MUTED))
	wrow.add_child(wh)
	add_child(wrow)
