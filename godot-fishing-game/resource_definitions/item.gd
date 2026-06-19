class_name Item
extends Resource

@export var id: StringName
@export var name: String
@export_multiline var description: String
@export var icon: Texture
@export var icon_path: String
@export var max_stack: int = 1 # todo: cap the max stack size?

var resource_type: Game.ResourceType
#var game_version: String


# todo: output error if texture not found
		# do we skip items without textures or do we give a default texture?
func _set_icon(path: String) -> Texture:
	if path.contains("res://"):
		return load(path)
	else:
		return _get_external_texture(path)

# todo: output error if texture not found
		# do we skip items without textures or do we give a default texture?
func _get_external_texture(path: String) -> ImageTexture:
	var img = Image.new()
	img.load(path)
	return ImageTexture.create_from_image(img)
