class_name Fish
extends Item

## Fish Rarity as percentages (1-100)
enum Rarity {
	COMMON = 100,
	UNCOMMON = 50,
	RARE = 25,
	EPIC = 10,
	LEGENDARY = 1,
}

@export var active_times: Array[TimeManager.TimeOfDay]
@export var rarity: Rarity = Rarity.COMMON


func _init() -> void:
	resource_type = Game.ResourceType.FISH


func to_json_string() -> String:
	var save_object = {
		"resource_type" : Game.ResourceType.FISH,
		"id" : id,
		"name" : name,
		"description": description,
		"icon_path": icon_path,
		"max_stack": max_stack,
		"rarity": rarity,
		"active_times": active_times,
		#"game_version": ProjectSettings.get_setting("application/config/version"),
	}
	return JSON.stringify(save_object,"\t", false)


# todo: data validation (e.g. ensure item type is FISH and availalbe_times values are valid)
func from_json_string(json_string: String) -> void: 
	var data = JSON.parse_string(json_string)
	id = data.id
	name = data.name
	description = data.description
	icon = _set_icon(data.icon_path)
	icon_path = data.icon_path
	max_stack = int(data.max_stack)
	rarity = int(data.rarity) as Rarity
	active_times = _to_int_array(data.active_times) as Array[TimeManager.TimeOfDay]


func _to_int_array(array: Array) -> Array[int]:
	var output_array: Array[int] = []
	for n in array:
		output_array.append(int(n))
	return output_array
		
