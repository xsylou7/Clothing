class_name InspirationItem
extends Resource

@export var id: String = ""
@export var title: String = ""
@export var colors: Array[Color] = []

static func from_dict(d: Dictionary) -> InspirationItem:
	var item := InspirationItem.new()
	item.id = d.get("id", "")
	item.title = d.get("title", "")
	item.colors.clear()
	for c in d.get("colors", []):
		item.colors.append(Color.html(str(c)))
	return item
