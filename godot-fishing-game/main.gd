extends Node

var inventory: Inventory
var inventory_ui: InventoryUI

func _ready() -> void:
	# todo: load inventory from save if exists
	inventory = Inventory.new()
	inventory._initialize_slots()
	
	inventory_ui = $Gui/InventoryUi
	inventory_ui.setup(inventory)

# todo: remove all this debug stuff
func _input(event):
	if event is InputEventKey and event.is_pressed():
		# debug adding fish to inventory
		if event.keycode == KEY_R:
			print("r was pressed")
			var item_path = "user://fish/red_fish.json"
			if FileAccess.file_exists(item_path):
				var file = FileAccess.open(item_path, FileAccess.READ)
				var json_string = file.get_as_text()
				var item: Item = Item.new()
				item.from_json_string(json_string)
				inventory.add_item(item)
				var json_fish = item.to_json_string()
				print(json_fish)
			else:
				print("red fish file does not exist")
		elif event.keycode == KEY_B:
			print("b was pressed")
			var item: Item = preload("res://items/fish/blue_fish.tres")
			inventory.add_item(item)
		elif event.keycode == KEY_Y:
			print("y was pressed")
			var item_path = "user://fish/yellow_fish.json"
			if FileAccess.file_exists(item_path):
				var file = FileAccess.open(item_path, FileAccess.READ)
				var json_string = file.get_as_text()
				var item: Item = Item.new()
				item.from_json_string(json_string)
				inventory.add_item(item)
				var json_fish = item.to_json_string()
				print(json_fish)
			else:
				print("yellow fish file does not exist")
