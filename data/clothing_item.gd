class_name ClothingItem
extends Resource

@export var id: String = ""
@export var name: String = ""
@export var category: String = ""
@export var color: String = ""
@export var style: String = ""
@export var seasons: PackedStringArray = []
@export var brand: String = ""
@export var size: String = ""
@export var status: String = "available"
@export var notes: String = ""
@export var color_a: Color = Color(0.5, 0.5, 0.5)
@export var color_b: Color = Color(0.35, 0.35, 0.35)

static func from_dict(d: Dictionary) -> ClothingItem:
	var item := ClothingItem.new()
	item.id = d.get("id", "")
	item.name = d.get("name", "")
	item.category = d.get("category", "")
	item.color = d.get("color", "")
	item.style = d.get("style", "")
	item.seasons = PackedStringArray(d.get("seasons", []))
	item.brand = d.get("brand", "")
	item.size = d.get("size", "")
	item.status = d.get("status", "available")
	item.notes = d.get("notes", "")
	var cols: Array = d.get("colors", ["#888888", "#666666"])
	item.color_a = Color.html(cols[0])
	item.color_b = Color.html(cols[1] if cols.size() > 1 else cols[0])
	return item
