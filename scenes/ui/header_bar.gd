extends HBoxContainer

signal menu_pressed
signal action_pressed

var menu_btn: Button
var action_btn: Button

func _ready() -> void:
	add_theme_constant_override("separation", 12)
	alignment = BoxContainer.ALIGNMENT_CENTER

	var brand := VBoxContainer.new()
	brand.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	brand.add_theme_constant_override("separation", 1)
	brand.add_child(PhiliaStyle.make_display("Philia", 26))
	brand.add_child(PhiliaStyle.make_label("DRESSING", 10, PhiliaStyle.MUTED))
	add_child(brand)

	menu_btn = Button.new()
	menu_btn.text = "Menu  ▾"
	menu_btn.custom_minimum_size = Vector2(96, 42)
	var msb := PhiliaStyle.button_style(PhiliaStyle.INK, 999)
	msb.content_margin_left = 16
	msb.content_margin_right = 16
	menu_btn.add_theme_stylebox_override("normal", msb)
	menu_btn.add_theme_stylebox_override("hover", PhiliaStyle.button_style(PhiliaStyle.INK.lightened(0.1), 999))
	menu_btn.add_theme_stylebox_override("pressed", PhiliaStyle.button_style(PhiliaStyle.INK.darkened(0.05), 999))
	menu_btn.add_theme_color_override("font_color", PhiliaStyle.SURFACE)
	menu_btn.add_theme_color_override("font_hover_color", PhiliaStyle.SURFACE)
	menu_btn.add_theme_font_size_override("font_size", 13)
	add_child(menu_btn)
	menu_btn.pressed.connect(func(): menu_pressed.emit())

	action_btn = Button.new()
	action_btn.text = "✦"
	action_btn.custom_minimum_size = Vector2(42, 42)
	var asb := PhiliaStyle.button_style(PhiliaStyle.SURFACE, 999)
	asb.border_color = PhiliaStyle.LINE
	asb.set_border_width_all(1)
	asb.content_margin_left = 0
	asb.content_margin_right = 0
	action_btn.add_theme_stylebox_override("normal", asb)
	action_btn.add_theme_stylebox_override("hover", asb)
	action_btn.add_theme_stylebox_override("pressed", asb)
	action_btn.add_theme_color_override("font_color", PhiliaStyle.INK)
	add_child(action_btn)
	action_btn.pressed.connect(func(): action_pressed.emit())

func set_menu_open(open: bool) -> void:
	if menu_btn:
		menu_btn.text = "Menu  ▴" if open else "Menu  ▾"

func set_action(text: String, visible_action: bool = true) -> void:
	if action_btn == null:
		return
	action_btn.text = text
	action_btn.visible = visible_action
