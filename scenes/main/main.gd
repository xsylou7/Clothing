extends Control

@onready var shell: Control = $Shell
@onready var header: HBoxContainer = $Shell/VBox/HeaderPad/Header
@onready var content_host: Control = $Shell/VBox/ContentClip/ContentHost
@onready var scroll: ScrollContainer = $Shell/VBox/ContentClip
@onready var menu: Control = $DropdownMenu
@onready var dimmer: ColorRect = $Shell/Dimmer

var _current: Node = null

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	Nav.screen_changed.connect(_on_screen_changed)
	Nav.shell_dimmed.connect(_on_shell_dimmed)
	header.menu_pressed.connect(func(): Nav.toggle_menu())
	header.action_pressed.connect(_on_header_action)
	menu.navigated.connect(func(_id): pass)
	resized.connect(_sync_content_width)
	await get_tree().process_frame
	_sync_content_width()
	# Initial screen
	Nav.go("home", {}, false)

func _sync_content_width() -> void:
	content_host.custom_minimum_size.x = maxf(0.0, size.x - 36.0)

func _on_header_action() -> void:
	match Nav.current_screen:
		"home":
			Nav.go("style_me")
		"dressing":
			Nav.go("add_clothing")
		"looks":
			Nav.go("style_me")
		"look_detail", "clothing_detail", "style_me", "add_clothing":
			Nav.back()
		_:
			pass


func _on_shell_dimmed(dim: bool) -> void:
	header.set_menu_open(dim)
	var tween := create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	if dim:
		tween.tween_property(shell, "scale", Vector2(0.94, 0.94), 0.45)
		tween.tween_property(dimmer, "modulate:a", 1.0, 0.35)
	else:
		tween.tween_property(shell, "scale", Vector2.ONE, 0.4)
		tween.tween_property(dimmer, "modulate:a", 0.0, 0.3)

func _on_screen_changed(screen_id: String, params: Dictionary) -> void:
	_update_header_action(screen_id)
	if _current:
		_current.queue_free()
		_current = null
	var path := Nav.scene_path(screen_id)
	var packed := load(path) as PackedScene
	if packed == null:
		push_error("Missing scene: " + path)
		return
	_current = packed.instantiate()
	if _current.has_method("setup"):
		_current.call("setup", params)
	content_host.add_child(_current)
	scroll.scroll_vertical = 0
	# Page enter animation
	_current.modulate.a = 0.0
	_current.position.y = 12
	var t := create_tween()
	t.set_parallel(true)
	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_CUBIC)
	t.tween_property(_current, "modulate:a", 1.0, 0.35)
	t.tween_property(_current, "position:y", 0.0, 0.4)

func _update_header_action(screen_id: String) -> void:
	match screen_id:
		"home":
			header.set_action("✦", true)
		"dressing":
			header.set_action("+", true)
		"looks":
			header.set_action("✦", true)
		"look_detail", "clothing_detail", "style_me", "add_clothing":
			header.set_action("←", true)
		_:
			header.set_action("✦", false)
