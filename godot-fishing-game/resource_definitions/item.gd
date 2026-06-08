class_name Item
extends Resource

@export var id: String
@export var name: String
@export_multiline var description: String
@export var icon: Texture
@export var icon_path: String
@export var max_stack: int = 1


func to_json_string() -> String:
	var save_object = {
		"id" : id,
		"name" : name,
		"description": description,
		"icon_path": icon_path,
		"max_stack": max_stack,
	}
	return JSON.stringify(save_object,"\t", false)

func from_json_string(json_string: String) -> void: 
	var data = JSON.parse_string(json_string)
	id = data.id
	name = data.name
	description = data.description
	icon = set_icon(data.icon_path)
	icon_path = data.icon_path
	max_stack = int(data.max_stack)

func set_icon(path: String) -> Texture:
	if path.contains("res://"):
		return load(path)
	else:
		return get_external_texture(path)
	
func get_external_texture(path: String) -> ImageTexture:
	var img = Image.new()
	img.load(path)
	return ImageTexture.create_from_image(img)
