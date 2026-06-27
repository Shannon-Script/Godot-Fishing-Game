class_name InventoryUI
extends CanvasLayer

@onready var grid_container: GridContainer = $Panel/GridContainer

var _inventory: Inventory
var _slot_scene: PackedScene = preload("res://inventory/inventory_slot.tscn")
var _slots: Array[InventorySlot] = []


func setup(inventory: Inventory) -> void:
	_inventory = inventory
	
	_inventory.item_added.connect(_on_slot_updated)
	_inventory.item_removed.connect(_on_slot_updated)
	_inventory.item_changed.connect(_on_slot_updated)
	
	_build_grid()

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#print("inventory_ui _ready()")
	#
	#InventoryManager.inventory_changed.connect(_on_slot_updated)
	#_build_grid()
	#update_ui()


func _build_grid() -> void:
	# clear existing
	for child in grid_container.get_children():
		child.queue_free()
	_slots.clear()
	
	# create slot uis
	for i in _inventory.slots.size():
		var slot_ui: InventorySlot = _slot_scene.instantiate()
		grid_container.add_child(slot_ui)
		slot_ui.setup(i, _inventory.slots[i])
		#slot_ui.slot_clicked.connect(_on_slot_clicked)
		#slot_ui.slot_drag_started.connect(_on_drag_started)
		_slots.append(slot_ui)
	_slots[0].grab_focus.call_deferred()
	
	#_set_focus_neighbors()

#func _set_focus_neighbors() -> void:
	## This seems to already be working in the grid without manual input
	## one thing missing is wrapping from end of row to start of same row if hitting right and vice versa with left
	#var row = 0
	#var slots_size = _slots.size()
	#
	#for i in slots_size:
		#var column_size = grid_container.columns
		#var slot = _slots[i]
		#
		## Left
		#if i != 0 and i % column_size != 0:
			#var left_neighbor_path = "../%s" % _slots[i-1].name
			#slot.focus_neighbor_left = left_neighbor_path
		#else:
			#row += 1
			#var left_neighbor_index = (column_size * row) - 1
			#if left_neighbor_index > slots_size: left_neighbor_index = slots_size -1
			#var left_neighbor_path = "../%s" % _slots[left_neighbor_index].name
			#slot.focus_neighbor_left = left_neighbor_path
		#
		## Right
		#if i != slots_size -1 and (i + 1) % column_size != 0:
			#var right_neighbor_path = "../%s" % _slots[i+1].name
			#slot.focus_neighbor_right = right_neighbor_path
		#else:
			#var right_neighbor_index = column_size * (row - 1)
			#var right_neighbor_path =  "../%s" % _slots[right_neighbor_index].name
			#slot.focus_neighbor_right = right_neighbor_path



func update_ui():
	var slots = grid_container.get_children()
	#var inventory_items = InventoryManager.items
	var inventory_items = _inventory.items
	
	for i in range(slots.size()):
		var slot = slots[i]
		if i < inventory_items.size():
			var item = inventory_items[i]
			slot.get_node("Icon").texture = item.icon
		else:
			slot.get_node("Icon").texture = null


func _on_slot_updated(slot_index: int) -> void:
	if slot_index >= 0 and slot_index < _slots.size():
		_slots[slot_index].refresh()
