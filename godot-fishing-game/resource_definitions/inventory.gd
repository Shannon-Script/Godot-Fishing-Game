# credit: https://www.strayspark.studio/blog/godot-4-inventory-crafting-system-complete-guide
class_name Inventory
extends Resource

signal item_added(slot_index: int)
signal item_removed(slot_index: int)
signal item_changed(slot_index: int)
signal inventory_full

@export var slots: Array[InventorySlotData] = []
@export var max_slots: int = 16

func _init() -> void:
	_initialize_slots()
	

func _initialize_slots() -> void:
	slots.clear()
	for i in max_slots:
		slots.append(InventorySlotData.new())
	

## Attempts to add an item. Returns the number of items that could not be added
func add_item(item: Item, amount: int = 1) -> int:
	if item == null or amount <= 0:
		return amount
	
	var to_add = amount
	
	# First pass: stack with existing items
	if item.max_stack > 1:
		for i in slots.size():
			if to_add <= 0:
				break
			if slots[i].item != null and slots[i].item.id == item.id:
				var space = slots[i].available_stack_space()
				if space > 0:
					var add_amount = mini(to_add, space)
					slots[i].quantity += add_amount
					to_add -= add_amount
					item_changed.emit(i)
			
	# Second pass: fill empty slots
	for i in slots.size():
		if to_add <= 0:
			break
		if slots[i].is_empty():
			var add_amount = min(to_add, item.max_stack)
			slots[i].item = item
			slots[i].quantity = add_amount
			to_add -= add_amount
			item_added.emit(i)
	
	if to_add > 0:
		inventory_full.emit()
	
	return to_add
	

## Remove a specific quantity from a slot. Returns true if successful
func remove_item_at(slot_index: int, amount: int = 1) -> bool:
	if slot_index < 0 or slot_index >= slots.size():
		return false
	
	var slot = slots[slot_index]
	if slot.is_empty() or amount <= 0 or amount > slot.quantity:
		return false
	
	slot.quantity -= amount
	
	if slot.quantity <= 0:
		slot.clear()
		item_removed.emit(slot_index)
	else:
		item_changed.emit(slot_index)
	
	return true
	

## Remove items by ID from anywhere in the inventory. Returns amount actually removed
func remove_item_by_id(item_id: StringName, amount: int = 1) -> int:
	var removed = 0
	
	for i in slots.size():
		if removed >= amount:
			break
		if slots[i].item != null and slots[i].item.id == item_id:
			var to_remove = mini(amount - removed, slots[i].quantity)
			remove_item_at(i, to_remove)
			removed += to_remove
		
	return removed
	

## Count total quantity of an item accross all slots
func count_item(item_id: StringName) -> int:
	var total = 0
	for slot in slots:
		if slot.item != null and slot.item.id == item_id:
			total += slot.quantity
	return total
	

## Check if the inventory contains at least 'amount' of an item
func has_item(item_id: StringName, amount: int = 1) -> bool:
	return count_item(item_id) >= amount
	

# todo:
## Swap two slots

## Try to merge (stack) from on slot into another

## Split a stack

# todo: remove if saving resource works
func to_json_string() -> String:
	var save_object = {}
	for i in slots.size():
		if not slots[i].is_empty():
			var item_id = slots[i].item.id
			var quantity = slots[i].quantity
			save_object[i] = {
				"item_id": item_id,
				"quantity": quantity,
			}

	return JSON.stringify(save_object,"\t", false)


# todo: remove if loading resource works
func from_json_string(json_string: String) -> void: 
	var data = JSON.parse_string(json_string)
	for i in data.size():
		if slots[i].is_empty():
			# todo better cleaning/checking e.g. quantity > 0 of data
			# slots[i].item = ItemDatabase.get_item_by_id(data[i].id)
			# slots[i].quantity = data[i].quantity
			pass
