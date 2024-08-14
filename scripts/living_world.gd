extends Control
class_name LivingWorld

var allWorldActivities: Array = []
var takenWorldActivities: Array = []
var waitingWorldActivities: Array = []

var living_world_planting_blossom_1 = Vector2i(25, 55)
var living_world_planting_blossom_2 = Vector2i(28, 55)
var living_world_planting_blossom_3 = Vector2i(25, 58)
var living_world_planting_blossom_4 = Vector2i(26, 59)
var living_world_planting_blossom_5 = Vector2i(27, 59)


func inform_about_task_done(activity: Types.GremlinGoal):
	if activity == Types.GremlinGoal.WORLD_PLANTING:
		if takenWorldActivities.has(activity):
			var timer = get_node("BloomTimer")
			timer.start()
	if activity == Types.GremlinGoal.WORLD_HARVEST:
		if takenWorldActivities.has(activity):
			change_plants_to_empty_and_ready_planting()
	waitingWorldActivities.erase(activity)
	takenWorldActivities.erase(activity)
	pass


func inform_about_task_started(activity: Types.GremlinGoal):
	if activity == Types.GremlinGoal.WORLD_PLANTING:
		takenWorldActivities.append(activity)
		waitingWorldActivities.erase(activity)
	elif activity == Types.GremlinGoal.WORLD_HARVEST:
		takenWorldActivities.append(activity)
		waitingWorldActivities.erase(activity)
#			waitingWorldActivities[activity] = false
	pass


func inform_about_task_taken(_activity: Types.GremlinGoal):
	pass


func change_plants_to_fruit_and_ready_harvest():
	var map: TileMap = get_node("../TileMap Outdoor")
	var fruit = Vector2i(65, 86)
	map.set_cell(2, living_world_planting_blossom_1, 0, fruit, 0)
	map.set_cell(2, living_world_planting_blossom_2, 0, fruit, 0)
	map.set_cell(2, living_world_planting_blossom_3, 0, fruit, 0)
	map.set_cell(2, living_world_planting_blossom_4, 0, fruit, 0)
	map.set_cell(2, living_world_planting_blossom_5, 0, fruit, 0)

	var timer = get_node("BloomTimer")
	timer.stop()
	if !waitingWorldActivities.has(Types.GremlinGoal.WORLD_HARVEST):
		waitingWorldActivities.append(Types.GremlinGoal.WORLD_HARVEST)
	pass


func change_plants_to_blossom_and_start_riping():
	var map: TileMap = get_node("../TileMap Outdoor")
	var blossom = Vector2i(41, 46)
	map.set_cell(2, living_world_planting_blossom_1, 0, blossom, 0)
	map.set_cell(2, living_world_planting_blossom_2, 0, blossom, 0)
	map.set_cell(2, living_world_planting_blossom_3, 0, blossom, 0)
	map.set_cell(2, living_world_planting_blossom_4, 0, blossom, 0)
	map.set_cell(2, living_world_planting_blossom_5, 0, blossom, 0)

	var timer = get_node("BloomTimer")
	timer.stop()
	timer = get_node("GrowingTimer")
	timer.start(15)
	pass


func change_plants_to_empty_and_ready_planting():
	var map: TileMap = get_node("../TileMap Outdoor")
	var blossom = Vector2i(41, 46)
	map.erase_cell(2, living_world_planting_blossom_1)
	map.erase_cell(2, living_world_planting_blossom_2)
	map.erase_cell(2, living_world_planting_blossom_3)
	map.erase_cell(2, living_world_planting_blossom_4)
	map.erase_cell(2, living_world_planting_blossom_5)

	var timer = get_node("BloomTimer")
	timer.stop()
	timer = get_node("GrowingTimer")
	timer.stop()

	if !waitingWorldActivities.has(Types.GremlinGoal.WORLD_PLANTING):
		waitingWorldActivities.append(Types.GremlinGoal.WORLD_PLANTING)
	pass


func get_possible_world_actions() -> Array:
	var possible: Array = []

	for activity in allWorldActivities:
		if waitingWorldActivities.has(activity):
			possible.append(activity)
	return possible


# Called when the node enters the scene tree for the first time.
func _ready():
	if !waitingWorldActivities.has(Types.GremlinGoal.WORLD_PLANTING):
		allWorldActivities.append(Types.GremlinGoal.WORLD_PLANTING)
	if !waitingWorldActivities.has(Types.GremlinGoal.WORLD_HARVEST):
		allWorldActivities.append(Types.GremlinGoal.WORLD_HARVEST)
	#waitingWorldActivities.append_array(allWorldActivities)

	var timer = get_node("GrowingTimer")
	timer.start(15)

	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func get_activity_name(value: int) -> String:
	for goalName in Types.GremlinGoal.keys():
		if Types.GremlinGoal[goalName] == value:
			return goalName
	return "Unknown"


func left_align(text: String, width: int) -> String:
	if text.length() >= width:
		return text
	for i in range(0, width - text.length()):
		text = text + " "
	return text


func _on_show_debug_info_timer_timeout():
	print("\nWorld-Status")
	print("\nTimer")
	var timer: Timer = get_node("GrowingTimer")
	print("GrowingTimer: " + str(timer.wait_time))
	timer = get_node("BloomTimer")
	print("BloomTimer: " + str(timer.wait_time))
	print("")
	print("+-----------------+-------+---------+")
	print(("| %s" % left_align("Activity", 15)) + " | Taken | Running |")
	print("|-----------------|-------|---------|")
	for key in allWorldActivities:
		var valueTaken = takenWorldActivities.has(key)
		var valueRunning = takenWorldActivities.has(key)
		print(
			(
				("| %s" % left_align(get_activity_name(key), 15))
				+ " | "
				+ left_align(str(valueTaken), 5)
				+ " | "
				+ left_align(str(valueRunning), 5)
				+ "   |"
			)
		)
	print("+-----------------+-------+---------+")
	pass
