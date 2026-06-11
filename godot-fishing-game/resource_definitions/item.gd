class_name Item
extends Resource

enum Type {
	FISH,
	DECORATION,
	BAIT,
	BOBBER,
}

@export var id: StringName
@export var name: String
@export_multiline var description: String
@export var icon: Texture
@export var icon_path: String
@export var max_stack: int = 1 # todo: cap the max stack size?

var resource_type: Game.ResourceType = Game.ResourceType.ITEM
#var game_version: String

func to_json_string() -> String:
	var save_object = {
		"resource_type": Game.ResourceType.ITEM,
		"id" : id,
		"name" : name,
		"description": description,
		"icon_path": icon_path,
		"max_stack": max_stack,
		#"game_version": ProjectSettings.get_setting("application/config/version")
	}
	return JSON.stringify(save_object,"\t", false)

# todo: data validation
func from_json_string(json_string: String) -> void: 
	var data = JSON.parse_string(json_string)
	resource_type = data.resource_type as Game.ResourceType
	id = data.id
	name = data.name
	description = data.description
	icon = _set_icon(data.icon_path)
	icon_path = data.icon_path
	max_stack = int(data.max_stack)
	#game_version = data.game_version

# todo: output error if texture not found
func _set_icon(path: String) -> Texture:
	if path.contains("res://"):
		return load(path)
	else:
		return _get_external_texture(path)

# todo: output error if texture not found
func _get_external_texture(path: String) -> ImageTexture:
	var img = Image.new()
	img.load(path)
	return ImageTexture.create_from_image(img)
