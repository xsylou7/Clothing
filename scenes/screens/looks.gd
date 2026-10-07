extends VBoxContainer

const LookCardScript = preload("res://scenes/ui/look_card.gd")

func setup(_params: Dictionary = {}) -> void:
	pass

func _ready() -> void:
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_theme_constant_override("separation", 12)
	_build()

func _build() -> void:
	for c in get_children():
		c.queue_free()

	var favs := AppState.favorite_looks().size()
	add_child(PhiliaStyle.make_kicker("Tenues"))
	add_child(PhiliaStyle.make_display("Looks", 36))
	add_child(PhiliaStyle.make_label("%d tenues · %d favoris" % [AppState.looks.size(), favs], 13, PhiliaStyle.MUTED))
	var gen := PhiliaStyle.primary_button("Habille-moi")
	gen.pressed.connect(func(): Nav.go("style_me"))
	add_child(gen)

	for look in AppState.looks:
		var card := LookCardScript.new()
		add_child(card)
		card.setup(look, false)
		card.look_pressed.connect(func(id): Nav.go("look_detail", {"id": id}))
		card.favorite_pressed.connect(func(id):
			AppState.toggle_favorite(id)
			_build()
		)
