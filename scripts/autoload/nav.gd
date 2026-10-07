extends Node

signal screen_changed(screen_id: String, params: Dictionary)
signal menu_toggled(open: bool)
signal shell_dimmed(dim: bool)

const SCREENS := {
	"home": "res://scenes/screens/home.tscn",
	"dressing": "res://scenes/screens/dressing.tscn",
	"looks": "res://scenes/screens/looks.tscn",
	"inspiration": "res://scenes/screens/inspiration.tscn",
	"profile": "res://scenes/screens/profile.tscn",
	"style_me": "res://scenes/screens/style_me.tscn",
	"look_detail": "res://scenes/screens/look_detail.tscn",
	"clothing_detail": "res://scenes/screens/clothing_detail.tscn",
	"add_clothing": "res://scenes/screens/add_clothing.tscn",
}

var current_screen: String = "home"
var current_params: Dictionary = {}
var history: Array[Dictionary] = []

func go(screen_id: String, params: Dictionary = {}, push_history: bool = true) -> void:
	if push_history and current_screen != "":
		history.append({"id": current_screen, "params": current_params.duplicate()})
	current_screen = screen_id
	current_params = params.duplicate()
	AppState.menu_open = false
	menu_toggled.emit(false)
	shell_dimmed.emit(false)
	screen_changed.emit(screen_id, current_params)

func back() -> void:
	if history.is_empty():
		go("home", {}, false)
		return
	var prev: Dictionary = history.pop_back()
	current_screen = prev["id"]
	current_params = prev["params"]
	screen_changed.emit(current_screen, current_params)

func toggle_menu() -> void:
	set_menu_open(not AppState.menu_open)

func set_menu_open(open: bool) -> void:
	AppState.menu_open = open
	menu_toggled.emit(open)
	shell_dimmed.emit(open)

func scene_path(screen_id: String) -> String:
	return SCREENS.get(screen_id, SCREENS["home"])
