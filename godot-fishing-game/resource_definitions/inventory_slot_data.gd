class_name InventorySlotData
extends Resource

@export var item: Item = null
@export var quantity: int = 0

func is_empty() -> bool:
	return item == null or quantity <= 0
	

func can_stack_with(other_item: Item) -> bool:
	if is_empty():
		return true
	return item.id == other_item.id and quantity < item.max_stack
	

func available_stack_space() -> int:
	if is_empty():
		return 0
	return item.max_stack - quantity
	

func clear() -> void:
	item = null
	quantity = 0
	
