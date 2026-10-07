extends Node

signal changed
signal favorites_changed
signal clothing_changed

var clothes: Array[ClothingItem] = []
var looks: Array[LookItem] = []
var inspirations: Array[InspirationItem] = []
var profile: Dictionary = {}
var weather: Dictionary = {}

var dressing_filter: String = "all"
var style_me_occasion: String = "Quotidien"
var style_me_style: String = "Casual"
var last_generated_look_id: String = "l01"
var menu_open: bool = false

func _ready() -> void:
	_load_mock()

func _load_mock() -> void:
	clothes.clear()
	for d in MockData.clothes_raw():
		clothes.append(ClothingItem.from_dict(d))
	looks.clear()
	for d in MockData.looks_raw():
		looks.append(LookItem.from_dict(d))
	inspirations.clear()
	for d in MockData.inspirations_raw():
		inspirations.append(InspirationItem.from_dict(d))
	profile = MockData.profile()
	weather = MockData.weather()

func get_clothing(id: String) -> ClothingItem:
	for c in clothes:
		if c.id == id:
			return c
	return null

func resolve_look_items(look: LookItem) -> Array[ClothingItem]:
	var result: Array[ClothingItem] = []
	for id in look.item_ids:
		var item := get_clothing(id)
		if item:
			result.append(item)
	return result

func get_look(id: String) -> LookItem:
	for l in looks:
		if l.id == id:
			return l
	return null

func filtered_clothes() -> Array[ClothingItem]:
	if dressing_filter == "all":
		return clothes.duplicate()
	var result: Array[ClothingItem] = []
	for c in clothes:
		if c.category == dressing_filter:
			result.append(c)
	return result

func available_ids() -> Dictionary:
	var d := {}
	for c in clothes:
		if c.status == "available":
			d[c.id] = true
	return d

func toggle_favorite(look_id: String) -> void:
	var look := get_look(look_id)
	if look == null:
		return
	look.favorite = not look.favorite
	favorites_changed.emit()
	changed.emit()

func set_clothing_status(id: String, status: String) -> void:
	var item := get_clothing(id)
	if item == null:
		return
	item.status = status
	clothing_changed.emit()
	changed.emit()

func update_clothing(id: String, patch: Dictionary) -> void:
	var item := get_clothing(id)
	if item == null:
		return
	for k in patch.keys():
		item.set(k, patch[k])
	clothing_changed.emit()
	changed.emit()

func add_clothing(item: ClothingItem) -> void:
	clothes.insert(0, item)
	clothing_changed.emit()
	changed.emit()

func favorite_looks() -> Array[LookItem]:
	var result: Array[LookItem] = []
	for l in looks:
		if l.favorite:
			result.append(l)
	return result

func stats() -> Dictionary:
	var favs := 0
	for l in looks:
		if l.favorite:
			favs += 1
	var avail := 0
	for c in clothes:
		if c.status == "available":
			avail += 1
	return {"clothes": clothes.size(), "looks": looks.size(), "favorites": favs, "available": avail}

func generate_look_from_prefs() -> LookItem:
	var available := available_ids()
	var scored: Array = []
	for look in looks:
		var all_ok := true
		for id in look.item_ids:
			if not available.has(id):
				all_ok = false
				break
		if not all_ok:
			continue
		var score := look.score
		if look.occasion == style_me_occasion:
			score += 8
		if look.style == style_me_style or style_me_style == "Surprise":
			score += 6
		scored.append({"look": look, "score": score})
	scored.sort_custom(func(a, b): return a["score"] > b["score"])
	var pick: LookItem = scored[0]["look"] if scored.size() > 0 else looks[0]
	last_generated_look_id = pick.id
	changed.emit()
	return pick
