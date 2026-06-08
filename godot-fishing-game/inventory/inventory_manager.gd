extends Node

# var items: Array[Item] = []

#var inventory: Inventory
#var inventory_ui: InventoryUI
#
#func _ready() -> void:
	## todo: load inventory from save if exists
	#inventory = Inventory.new()
	#inventory._initialize_slots()
	#
	#inventory_ui = $Gui/InventoryUi
	#inventory_ui.setup(inventory)

#signal inventory_changed(slot_index: int)
#signal inventory_full
#
#@export var slots: Array[InventorySlotData] = []
#@export var max_slots: int = 16
#
#func _init() -> void:
	#_initialize_slots()
	#
#
#func _initialize_slots() -> void:
	#slots.clear()
	#for i in max_slots:
		#slots.append(InventorySlotData.new())
#
#
#func add_item(item: Item):
	#items.append(item)
	#inventory.add_item(item)
	##inventory_changed.emit()
	
	
#func remove_item(item: Item):
	#if items.has(item):
		#items.erase(item)
		#inventory_changed.emit()
#
### Attempts to add an item. Returns the number of items that could not be added
#func add_item(item: Item, amount: int = 1) -> int:
	#if item == null or amount <= 0:
		#return amount
	#
	#var to_add = amount
	#
	## First pass: stack with existing items
	#if item.max_stack > 1:
		#for i in slots.size():
			#if to_add <= 0:
				#break
			#if slots[i].item != null and slots[i].item.id == item.id:
				#var space = slots[i].available_stack_space()
				#if space > 0:
					#var add_amount = mini(to_add, space)
					#slots[i].quantity += add_amount
					#to_add -= add_amount
					#inventory_changed.emit(i)
			#
	## Second pass: fill empty slots
	#for i in slots.size():
		#if to_add <= 0:
			#break
		#if slots[i].is_empty():
			#var add_amount = min(to_add, item.max_stack)
			#slots[i].item = item
			#slots[i].quantity = add_amount
			#to_add -= add_amount
			#inventory_changed.emit(i)
	#
	#if to_add > 0:
		#inventory_full.emit()
	#
	#return to_add
