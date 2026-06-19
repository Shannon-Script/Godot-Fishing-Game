class_name TimeManager
extends Node

## Time Of Day with value of each set to start time of the time period
enum TimeOfDay {
	MORNING = 0,
	MIDDAY = 4,
	SUNSET = 12,
	NIGHT = 16,
}

const END_OF_NIGHT = 24

signal time_of_day_changed(new_time_of_day: TimeOfDay)

@export var game_time: GameTime

## amount of in game seconds per real life second.
## default value: 40 makes a 24h in-game day cycle last 36 irl minutes
@export var ticks_per_second: int = 40

var current_time_of_day: TimeOfDay

func _process(delta: float) -> void:
	game_time.increase_by_seconds(delta * ticks_per_second)

func _ready() -> void:
	game_time.hour_changed.connect(_on_hour_changed)
	current_time_of_day = _get_time_of_day(game_time.hours)
	print("current time of day: %s" % current_time_of_day)
	
func _on_hour_changed(new_hour: int) -> void:
	# print("on hour changed %s" % new_hour)
	var new_time_of_day = _get_time_of_day(new_hour)
	if new_time_of_day != current_time_of_day:
		current_time_of_day = new_time_of_day
		print("current time of day: %s" % current_time_of_day)
		time_of_day_changed.emit(current_time_of_day)
	
func _get_time_of_day(hours: int) -> TimeOfDay:
	if range(TimeOfDay.MORNING, TimeOfDay.MIDDAY).has(hours):
		return TimeOfDay.MORNING
	elif range(TimeOfDay.MIDDAY, TimeOfDay.SUNSET).has(hours):
		return TimeOfDay.MIDDAY
	elif range(TimeOfDay.SUNSET, TimeOfDay.NIGHT).has(hours):
		return TimeOfDay.SUNSET
	elif range(TimeOfDay.NIGHT, END_OF_NIGHT).has(hours):
		return TimeOfDay.NIGHT
	# fallback on morning if above fails
	return TimeOfDay.MORNING
	
