extends Control

@onready var inventory_ui: Node = $InventoryUi
@onready var journal_ui: Node = $JournalUi
@onready var map_ui: Node = $MapUi
@onready var gui_container: Control = $"."


func _input(event):
	if event.is_action_pressed("inventory"):
		toggle_gui(inventory_ui)
			
	elif event.is_action_pressed("journal"):
		toggle_gui(journal_ui)
		
	elif event.is_action_pressed("map"):
		toggle_gui(map_ui)


func toggle_gui(gui_to_toggle: Node) -> void:
	if gui_to_toggle.visible:
		gui_to_toggle.visible = false
	else:
		for n in gui_container.get_children():
			n.visible = false
		gui_to_toggle.visible = true
		
