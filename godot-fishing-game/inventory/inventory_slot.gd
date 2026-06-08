class_name InventorySlot
extends PanelContainer

signal slot_clicked(slot_index: int, button: MouseButton)
#signal slot_drag_started(slot_index: int)

@onready var icon: TextureRect = $Icon
@onready var quantity_label: Label = $QuantityLabel
@onready var highlight: ColorRect = $Highlight

var slot_index: int = -1
var _slot_data: InventorySlotData

func setup(index: int, slot_data: InventorySlotData) -> void:
	slot_index = index
	_slot_data = slot_data
	refresh()
	

func refresh() -> void:
	if _slot_data == null or _slot_data.is_empty():
		icon.texture = null
		quantity_label.visible = false
		tooltip_text = ""
	else:
		icon.texture = _slot_data.item.icon
		if _slot_data.quantity >= 1:
			quantity_label.text = str(_slot_data.quantity)
			quantity_label.visible = true
		else:
			quantity_label.visible = false
		tooltip_text = _slot_data.item.name


func set_highlighted(enabled: bool) -> void:
	highlight.visible = enabled

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		slot_clicked.emit(slot_index, event.button_index)
		
	
