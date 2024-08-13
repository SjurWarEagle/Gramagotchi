extends Control
class_name LivingWorld

var allWorldActivities:Array = []
var takenWorldActivities:Array = []
var waitingWorldActivities:Array = []


func inform_about_task_done(activity:Types.GremlinGoal):
	if activity==Types.GremlinGoal.WORLD_PLANTING:
			waitingWorldActivities.append(activity)
			takenWorldActivities.erase(activity)
	pass

func inform_about_task_started(activity:Types.GremlinGoal):
	if activity==Types.GremlinGoal.WORLD_PLANTING:
			takenWorldActivities.append(activity)
			waitingWorldActivities.erase(activity)
#			waitingWorldActivities[activity] = false
#			takenWorldActivities[activity] = true
	pass

func inform_about_task_taken(_activity:Types.GremlinGoal):
	pass

func get_possible_world_actions() -> Array:
	var possible:Array=[]
	
	for activity in allWorldActivities:
		if waitingWorldActivities.has(activity):
			possible.append(activity)
	return possible

# Called when the node enters the scene tree for the first time.
func _ready():
	allWorldActivities.append(Types.GremlinGoal.WORLD_PLANTING)
	waitingWorldActivities.append_array(allWorldActivities)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
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
	for key in allWorldActivities:
		var valueTaken = takenWorldActivities.has(key)
		var valueRunning = takenWorldActivities.has(key)
		print(("| %s" % left_align(get_activity_name(key),15)) 
			+ " | " + left_align(str(valueTaken),5)
			+ " | " + left_align(str(valueRunning),5)
			+ "   |"
			)
	print("+-----------------+-------+---------+")
	pass
