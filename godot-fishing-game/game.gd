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
	ITEM,
	LOCATION,
	WORLD,
}

var inventory: Inventory
var inventory_ui: InventoryUI

# debug vars
var current_time:TIME = TIME.MORNING
var current_region: StringName = "REGION-Level1"



func _ready() -> void:
	# todo: load inventory from save if exists
	inventory = SaveSystem.load_inventory()
	if inventory == null:
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
	# todo: will also need to check time of day
	var fish_in_region: Array[Fish] = ItemDatabase.get_all_fish_in(current_region)

	var fish_pool: Array[Fish] = []
	var test_pool: Array[String] = []
	var legendary = 0
	var very_rare = 0
	var rare = 0
	var uncommon = 0
	var common = 0
	for i in 100:
		var roll = randi() % 100 + 1
		if roll <= Fish.Rarity.LEGENDARY:
			# check if a legendary fish exists in region-time
				# yes: add legendary fish to pool
				# else: pass
			test_pool.append("Legendary")
			legendary += 1
			pass
		elif roll <= Fish.Rarity.VERY_RARE:
			# add very rare fish to pool
			test_pool.append("Very Rare")
			very_rare += 1
			pass
		elif roll < Fish.Rarity.RARE:
			# add rare fish to pool
			test_pool.append("Rare")
			rare += 1
			pass
		elif roll < Fish.Rarity.UNCOMMON:
			# add uncommon fish to pool
			test_pool.append("Uncommon")
			uncommon += 1
			pass
		else:
			# add common fish to pool
			test_pool.append("Common")
			common += 1
			pass
	print("hello world")
	#print(test_pool)
	print("common %s, uncommon %s, rare %s, very rare %s, legendary %s" % [common, uncommon, rare, very_rare, legendary])
	var fish_index = randi() % test_pool.size()
	var fish_caught = test_pool[fish_index]
	test_pool.remove_at(fish_index)
	print("You caught a %s!" % fish_caught)
	print("There are %s fish left in the pool" % test_pool.size())

	
	
	
