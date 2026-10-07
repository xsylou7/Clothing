class_name LookItem
extends Resource

@export var id: String = ""
@export var name: String = ""
@export var style: String = ""
@export var occasion: String = ""
@export var score: int = 0
@export var favorite: bool = false
@export var item_ids: PackedStringArray = []

static func from_dict(d: Dictionary) -> LookItem:
	var look := LookItem.new()
	look.id = d.get("id", "")
	look.name = d.get("name", "")
	look.style = d.get("style", "")
	look.occasion = d.get("occasion", "")
	look.score = int(d.get("score", 0))
	look.favorite = bool(d.get("favorite", false))
	look.item_ids = PackedStringArray(d.get("items", []))
	return look
