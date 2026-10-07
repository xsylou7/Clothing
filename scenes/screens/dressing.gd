extends VBoxContainer

const ClothingCardScript = preload("res://scenes/ui/clothing_card.gd")

func setup(_params: Dictionary = {}) -> void:
	pass

func _ready() -> void:
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_theme_constant_override("separation", 10)
	_build()

func _build() -> void:
	for c in get_children():
		c.queue_free()

	var stats := AppState.stats()
	add_child(PhiliaStyle.make_kicker("Garde-robe"))
	add_child(PhiliaStyle.make_display("Dressing", 36))
	add_child(PhiliaStyle.make_label("%d pièces · %d disponibles" % [stats["clothes"], stats["available"]], 13, PhiliaStyle.MUTED))

	var filters := HBoxContainer.new()
	filters.add_theme_constant_override("separation", 8)
	add_child(filters)
	for cat in MockData.CATEGORIES:
		var active: bool = AppState.dressing_filter == cat["id"]
		var chip := PhiliaStyle.chip(cat["label"], active)
		var cat_id: String = cat["id"]
		chip.pressed.connect(func():
			AppState.dressing_filter = cat_id
			_build()
		)
		filters.add_child(chip)

	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 12)
	grid.add_theme_constant_override("v_separation", 12)
	add_child(grid)
	for item in AppState.filtered_clothes():
		var card := ClothingCardScript.new()
		grid.add_child(card)
		card.setup(item)
		card.clothing_pressed.connect(func(id): Nav.go("clothing_detail", {"id": id}))

	add_child(PhiliaStyle.spacer(60))
	var fab := PhiliaStyle.primary_button("+ Ajouter un vêtement")
	fab.pressed.connect(func(): Nav.go("add_clothing"))
	add_child(fab)
