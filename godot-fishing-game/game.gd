class_name Game
extends Node

## The different times of day
enum TIME {
	MORNING,
	MIDDAY,
	SUNSET,
	NIGHT,
}

## The different types of resources
enum ResourceType {
	FISH,
	LOCATION,
	WORLD,
}

@onready var time_manager = $TimeManager

var inventory: Inventory
var inventory_ui: InventoryUI

# debug vars
var current_time:TIME = TIME.MORNING
var current_location: StringName = "LEVEL-1"
var test_location: Location = Location.new()



func _ready() -> void:
	# todo: load inventory from save if exists
	inventory = SaveSystem.load_inventory()
	if inventory == null:
		inventory = Inventory.new()
	
	inventory_ui = $Gui/InventoryUi
	inventory_ui.setup(inventory)
	
	# todo: remove --- debug stuff
	test_location.fish_ids = ["FISH-common", "FISH-uncommon", "FISH-rare", "FISH-epic", "FISH-legendary"]
	# test_location.fish_ids = ["FISH-common", "FISH-uncommon", "FISH-very-rare", "FISH-legendary"]
	#test_location._generate_fish_pool(current_time)
	test_location.setup(time_manager)


# todo: remove all this debug stuff
func _input(event):
	if event is InputEventKey and event.is_pressed():
		# debug adding fish to inventory
		if event.keycode == KEY_R:
			print("r was pressed")
			var fish: Item = preload("res://items/fish/red-fish.tres")
			# var item: Fish = ItemDatabase.get_item("FISH-new-red")
			inventory.add_item(fish)
			print(ProjectSettings.get_setting("application/config/version"))
			#var json_fish = item.to_json_string()
			#print(json_fish)
			
			
		elif event.keycode == KEY_B:
			print("b was pressed")
			var fish: Item = preload("res://items/fish/blue-fish.tres")
			inventory.add_item(fish)
			
		elif event.keycode == KEY_Y:
			print("y was pressed")
			var item_path = "user://items/fish/yellow_fish.json"
			if FileAccess.file_exists(item_path):
				var file = FileAccess.open(item_path, FileAccess.READ)
				var json_string = file.get_as_text()
				var fish: Fish = Fish.new()
				fish.from_json_string(json_string)
				inventory.add_item(fish)
				var json_fish = fish.to_json_string()
				print(json_fish)
			else:
				print("yellow fish file does not exist")
				
		elif event.keycode == KEY_G:
			print("g was pressed")
			var item_path = "user://items/fish/green_fish.json"
			if FileAccess.file_exists(item_path):
				var file = FileAccess.open(item_path, FileAccess.READ)
				var json_string = file.get_as_text()
				var fish: Fish = Fish.new()
				fish.from_json_string(json_string)
				inventory.add_item(fish)
				var json_fish = fish.to_json_string()
				print(json_fish)
			else:
				print("green fish file does not exist")
				
		elif event.keycode == KEY_S:
			# fake save
			# print(inventory.to_json_string())
			SaveSystem.save_inventory(inventory)
			
		elif event.keycode == KEY_F:
			# fake fishing
			print("pressed F")
			_go_fish()

func _go_fish() -> void:
	var fish_caught: Fish = test_location.take_random_fish_from_pool()
	# todo: handle if Fish is null
	print("You caught a %s" %fish_caught.name)
	inventory.add_item(fish_caught)

	
	
	
