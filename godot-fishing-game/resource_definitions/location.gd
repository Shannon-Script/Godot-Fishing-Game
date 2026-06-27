class_name Location
extends Resource

signal min_pool_size_reached()

const MAX_POOL_SIZE: int = 100
const MIN_POOL_SIZE: int = 80
# todo: consider a MIN_POOL_SIZE_WITH_LEGENDARY to allow smaller pool size if there's still a legendary in pool
# todo: consdier a MIN_POOL_SIZE_NO_LEGENDARY with bigger min pool to reroll new faster
# todo: emit legendary caught signal and connect to a function that determines if we should regenerate fish pool


@export var id: StringName
@export var name: String
@export var is_unlocked: bool
@export var image: Texture
@export var image_path: String
@export var fish_ids: Array[StringName]

var _fish_id_pool: Array[StringName]
var _current_active_fish: Array[Fish]

func _init() -> void:
	min_pool_size_reached.connect(_generate_fish_pool)
	# connect time changed to _on_time_change

# manages pool of fish
# listens to time change signal
	# updates fish pool on time change
# also update fish pool if fish pool drops below a certain amount

func _generate_fish_pool() -> void:
	_fish_id_pool = []
	#var fishes_to_add: Array[Fish] = _get_all_active_fish(time)
	# todo: remove these debug vars
	var legendary = 0
	var epic = 0
	var rare = 0
	var uncommon = 0
	var common = 0
	
	for i in MAX_POOL_SIZE:
		var roll = randi() % 100 + 1
		var fish: Fish = null
		if roll <= Fish.Rarity.LEGENDARY:
			fish = _get_random_fish_of_rarity(_current_active_fish, Fish.Rarity.LEGENDARY)
			if fish: legendary += 1

		if roll <= Fish.Rarity.EPIC and !fish:
			fish = _get_random_fish_of_rarity(_current_active_fish, Fish.Rarity.EPIC)
			if fish: epic += 1

		if roll < Fish.Rarity.RARE and !fish:
			fish = _get_random_fish_of_rarity(_current_active_fish, Fish.Rarity.RARE)
			if fish: rare += 1

		if roll < Fish.Rarity.UNCOMMON and !fish:
			fish = _get_random_fish_of_rarity(_current_active_fish, Fish.Rarity.UNCOMMON)
			if fish: uncommon += 1

		if roll < Fish.Rarity.COMMON and !fish:
			fish = _get_random_fish_of_rarity(_current_active_fish, Fish.Rarity.COMMON)
			if fish: common += 1
		
		if fish:
			_fish_id_pool.append(fish.id)
		
	print("common %s, uncommon %s, rare %s, epic %s, legendary %s" % [common, uncommon, rare, epic, legendary])


func _set_current_active_fish(time: TimeManager.TimeOfDay) -> void:
	_current_active_fish = []
	for fish_id in fish_ids:
		var fish: Fish = ItemDatabase.get_fish_with(fish_id)
		if !fish: break
		if fish.active_times.has(time):
			_current_active_fish.append(fish)


## Returns a random fish of given rarity from the given fishes array. Returns Null if no such fish exists
func _get_random_fish_of_rarity(fishes: Array[Fish], rarity: Fish.Rarity) -> Fish:
	var all_fish_of_rarity: Array[Fish] = []
	for fish in fishes:
		if fish.rarity == rarity:
			all_fish_of_rarity.append(fish)
	if all_fish_of_rarity.size() == 0:
		return null
	return all_fish_of_rarity.pick_random()


func _on_time_change(time: TimeManager.TimeOfDay) -> void:
	_set_current_active_fish(time)
	_generate_fish_pool()


func setup(time_manger: TimeManager) -> void:
	time_manger.time_of_day_changed.connect(_on_time_change)
	_set_current_active_fish(time_manger.current_time_of_day)
	_generate_fish_pool()


func get_fish_id_pool() -> Array[StringName]:
	return _fish_id_pool.duplicate()


func take_random_fish_from_pool() -> Fish:
	if _fish_id_pool.size() < 1:
		return null # or throw error?
	var fish_index = randi() % _fish_id_pool.size()
	var random_fish = _fish_id_pool[fish_index]
	_fish_id_pool.remove_at(fish_index)
	if _fish_id_pool.size() < MIN_POOL_SIZE:
		min_pool_size_reached.emit()
	print("There are %s fish left in the pool" % _fish_id_pool.size())
	return ItemDatabase.get_fish_with(random_fish)

# todo: consider a return fish to pool function
# example use case: player doesn't catch fish / skips the fishing
func return_fish_to_pool(fish: Fish) -> void:
	if _current_active_fish.has(fish):
		_fish_id_pool.append(fish.id)
