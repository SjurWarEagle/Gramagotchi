extends CharacterBody2D
class_name GremlinCharacter

enum GremlinGoal{
	NONE,
	POND,
	EAT,
	EAT2,
	COFFEE,
	SLEEP,
	TV,
	TOILETT,
	POSTAL,
	CLEANING,
}


var movement_speed: float = 100.0
var movement_target_position: Vector2
var current_goal: GremlinGoal
var is_on_break: bool=false

@onready var navigation_agent: NavigationAgent2D = get_node("NavigationAgent2D")

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	hide_action_display()

	# Now that the navigation map is no longer empty, set the movement target.
	_decide_new_target()

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func perform_break_activity():
	#print(current_goal)
	pass

func _physics_process(_delta):
	if is_on_break:
		perform_break_activity()
		return
	if navigation_agent.is_navigation_finished():
		_on_navigation_agent_2d_target_reached()
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	show_current_current_goal()
	move_and_slide()

func show_current_current_goal():
	if (current_goal==GremlinGoal.EAT):
		show_action_display("🍌")
	elif (current_goal==GremlinGoal.EAT2):
		show_action_display("🧀")
	elif (current_goal==GremlinGoal.POND):
		show_action_display("🐟")
	elif (current_goal==GremlinGoal.SLEEP):
		show_action_display("🛏️")
	elif (current_goal==GremlinGoal.COFFEE):
		show_action_display("☕")
	elif (current_goal==GremlinGoal.TV):
		show_action_display("📺")
	elif (current_goal==GremlinGoal.POSTAL):
		show_action_display("💌")
	elif (current_goal==GremlinGoal.TOILETT):
		show_action_display("🧻")
	elif (current_goal==GremlinGoal.CLEANING):
		show_action_display("🪣")
	#hide_action_display()

func _decide_new_target():
	var rnd = RandomNumberGenerator.new().randi_range(0,8)
	if(rnd==0):
		movement_target_position=get_node("../position_sleep").position
		current_goal=GremlinGoal.SLEEP
	elif(rnd==1):
		movement_target_position=get_node("../position_tv").position
		current_goal=GremlinGoal.TV
	elif(rnd==2):
		movement_target_position=get_node("../position_eat").position
		current_goal=GremlinGoal.EAT
	elif(rnd==3):
		movement_target_position=get_node("../position_coffee").position
		current_goal=GremlinGoal.COFFEE
	elif(rnd==4):
		movement_target_position=get_node("../position_toilett").position
		current_goal=GremlinGoal.TOILETT
	elif(rnd==5):
		movement_target_position=get_node("../position_postal").position
		current_goal=GremlinGoal.POSTAL
	elif(rnd==6):
		movement_target_position=get_node("../position_pond").position
		current_goal=GremlinGoal.POND
	elif(rnd==7):
		movement_target_position=get_node("../position_eat2").position
		current_goal=GremlinGoal.EAT2
	elif(rnd==8):
		movement_target_position=get_node("../position_storage").position
		current_goal=GremlinGoal.CLEANING
	else:
		print(rnd)
	set_movement_target(movement_target_position)
	pass

func _on_navigation_agent_2d_target_reached():
	#print("_on_navigation_agent_2d_target_reached")
	get_node("OnBreakTimer").start()
	is_on_break=true
	_decide_new_target()
	pass # Replace with function body.

func _on_on_break_timer_timeout():
	is_on_break=false
	pass # Replace with function body.

func hide_action_display():
	get_node("Bubble1").visible=false
	get_node("Bubble2").visible=false
	get_node("Bubble3").visible=false
	get_node("RichTextLabel").visible=false
	
func show_action_display(text:String):
	get_node("Bubble1").visible=true
	get_node("Bubble2").visible=true
	get_node("Bubble3").visible=true
	get_node("RichTextLabel").text=text
	get_node("RichTextLabel").visible=true
	
func set_texture(given_texture:ImageTexture):
	#texture = given_texture
	get_node("Sprite2D").texture=given_texture
	pass
