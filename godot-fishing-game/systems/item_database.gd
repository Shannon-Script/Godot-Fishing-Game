# credit: https://www.strayspark.studio/blog/godot-4-inventory-crafting-system-complete-guide
extends Node

var _items: Dictionary = {}
var _fishes: Dictionary = {} 


func _ready() -> void:
	_load_all_items("res://items/")
	_load_all_items("user://items/")
	print("_fishes = %s" % _fishes)
	

func _load_all_items(path: String) -> void:
	var dir = DirAccess.open(path)
	if dir == null:
		push_error("Could not open item directory %s" % path)
		return
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		var full_path = path.path_join(file_name)
		if dir.current_is_dir() and file_name != "." and file_name != "..":
			_load_all_items(full_path)
		elif file_name.ends_with(".tres") or file_name.ends_with(".res"):
			var resource = load(full_path)
			if resource is Item:
				if resource.id == &"":
					push_warning("Item at %s has no ID, skipping" % full_path)
				elif _items.has(resource.id):
					push_warning("Duplicate item ID: %s at %s" % [resource.id, full_path])
				else:
					_items[resource.id] = resource
					# todo: this will likely need to be in its own function but this works for now
					#	-> main issue being the earlier logic about skipping repeat ids
					if resource.item_type == Item.Type.FISH:
						_fishes[resource.id] = resource
		# todo: add elif for .json files
		elif file_name.ends_with(".json"):
			var file = FileAccess.open(full_path, FileAccess.READ)
			var json_string = file.get_as_text()
			if _get_resource_type(json_string) == Game.ResourceType.ITEM:
				print(full_path)
				print("is item")
				# skipping the fish check for debugging. This whole db needs to be redone. We'll want a fish db, decoration db, location db... etc
				var fish: Fish = Fish.new()
				fish.from_json_string(json_string)
				_items[fish.id] = fish
				_fishes[fish.id] = fish
			else:
				print(full_path)
				print("is NOT item")

		file_name = dir.get_next()
		
	dir.list_dir_end()


# todo: better handling - currently throws error if no resource_type
func _get_resource_type(json_string: String) -> Game.ResourceType:
	var data = JSON.parse_string(json_string)
	return data.resource_type as Game.ResourceType


func get_item(id: StringName) -> Item:
	if _items.has(id):
		return _items[id]
	push_error("Item not found: %s" % id)
	return null

# todo: make a get all items of type (e.g. get all fish) (and make a get all fish in location)
func get_all_items() -> Array[Item]:
	var result: Array[Item] = []
	for item in _items.values():
		result.append(item)
	return result

func get_all_fish() -> Array[Fish]:
	var result: Array[Fish] = []
	for item in _items.values():
		if item.item_type == Item.Type.FISH:
			result.append(item)
	return result

func get_all_fish_in(region_id: StringName) -> Array[Fish]:
	var result: Array[Fish] = []
	for item in _items.values():
		if item.item_type == Item.Type.FISH && item.region_id == region_id:
			result.append(item)
	return result
