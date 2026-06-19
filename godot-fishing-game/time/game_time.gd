class_name GameTime
extends Resource

signal hour_changed(hour: int)

@export_range(0, 59) var seconds: int = 0
@export_range(0, 59) var minutes: int = 0
@export_range(0, 23) var hours: int = 0

var delta_time: float = 0

func increase_by_seconds(delta_seconds: float) -> void:
	delta_time += delta_seconds
	if delta_time < 1:
		return
	var delta_int_secs: int = int(delta_time)
	delta_time -= delta_int_secs
	
	seconds += delta_int_secs
	@warning_ignore("integer_division")
	minutes += seconds / 60
	var old_hours = hours
	@warning_ignore("integer_division")
	hours += minutes / 60
	
	seconds = seconds % 60
	minutes = minutes % 60
	hours = hours % 24
	
	if old_hours != hours: hour_changed.emit(hours)
	
	# print("%s: %s: %s" % [hours, minutes, seconds])
