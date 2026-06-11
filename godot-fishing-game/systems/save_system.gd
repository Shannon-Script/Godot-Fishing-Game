# credit: https://www.strayspark.studio/blog/godot-4-inventory-crafting-system-complete-guide
extends Node

const SAVE_PATH = "user://save/"

# todo: add a save or game version (do this in res items too)
# --> this will allow handling older versions if definitions change

# todo: move to a JSON save. The inventory will break if ever item or slot data definitions change
func save_inventory(inventory: Inventory, filename: String = "inventory.tres") -> void:
	var dir = DirAccess.open("user://")
	if not dir.dir_exists("save"):
		dir.make_dir("save")
	
	var err = ResourceSaver.save(inventory, SAVE_PATH + filename)
	if err != OK:
		push_error("Failed to save inventory: %s" % error_string(err))

# todo: load from JSON (see save_inventory comment)
func load_inventory(filename: String = "inventory.tres") -> Inventory:
	var path = SAVE_PATH + filename
	if ResourceLoader.exists(path):
		var inventory = ResourceLoader.load(path) as Inventory
		if inventory:
			return inventory
	return null
