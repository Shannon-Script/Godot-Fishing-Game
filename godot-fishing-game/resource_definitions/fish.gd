class_name Fish
extends Item

## Fish Rarity as percentages (1-100)
enum Rarity {
	COMMON = 100,
	UNCOMMON = 45,
	RARE = 25,
	VERY_RARE = 10,
	LEGENDARY = 1,
}

@export var available_times: Array[Game.TIME]
@export var rarity: Rarity = Rarity.COMMON
@export var region_id: StringName

var item_type: Item.Type = Type.FISH


func to_json_string() -> String:
	var save_object = {
		"resource_type" : Game.ResourceType.ITEM,
		"item_type" : Item.Type.FISH,
		"id" : id,
		"name" : name,
		"description": description,
		"icon_path": icon_path,
		"max_stack": max_stack,
		"rarity": rarity,
		"region_id": region_id,
		"available_times": available_times,
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
	region_id = data.region_id
	available_times = _to_int_array(data.available_times) as Array[Game.TIME]
	#item_type = int(data.item_type) as Item.Type


func _to_int_array(array: Array) -> Array[int]:
	var output_array: Array[int] = []
	for n in array:
		output_array.append(int(n))
	return output_array
		
