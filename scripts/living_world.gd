extends Control
class_name LivingWorld

var takenWorldActivities:Dictionary = {
	Types.GremlinGoal.WORLD_PLANTING:false,
}

var waitingWorldActivities:Dictionary = {
	Types.GremlinGoal.WORLD_PLANTING:false,
}


func inform_about_task_done(activity:Types.GremlinGoal):
	if activity==Types.GremlinGoal.WORLD_PLANTING:
			waitingWorldActivities[activity]=true
	pass

func inform_about_task_started(activity:Types.GremlinGoal):
	if activity==Types.GremlinGoal.WORLD_PLANTING:
			takenWorldActivities[activity]=true
	pass

func inform_about_task_taken(activity:Types.GremlinGoal):
	pass

func get_possible_world_actions() -> Array:
	var possible:Array=[]
	possible.append(Types.GremlinGoal.WORLD_PLANTING)
	return possible

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_activity_name(value: int) -> String:
	for name in Types.GremlinGoal.keys():
		if Types.GremlinGoal[name] == value:
			return name
	return "Unknown"
	
func left_align(text: String, width: int) -> String:
	if text.length() >= width:
		return text
	for i in range (0,width - text.length()):
		text=text + " "
	return text
	
func _on_show_debug_info_timer_timeout():
	print("\nWorld-Status")
	print("+-----------------+-------+---------+")
	print(("| %s" % left_align("Activity",15)) + " | Taken | Running |")
	print("|-----------------|-------|---------|")
	for key in takenWorldActivities.keys():
		var valueTaken = takenWorldActivities[key]
		var valueRunning = takenWorldActivities[key]
		print(("| %s" % left_align(get_activity_name(key),15)) 
			+ " | " + left_align(str(valueTaken),5)
			+ " | " + left_align(str(valueRunning),5)
			+ "   |"
			)
	print("+-----------------+-------+---------+")
	pass
