extends Area2D

var pDoor1 = Vector2i(37, 6)
var pDoor2 = Vector2i(37, 7)
var pDoor3 = Vector2i(37, 8)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_body_entered(_body):
	#print("_on_body_entered")
	var map: TileMap = get_parent()
	map.set_cell(2, pDoor1, 0, Vector2i(9, 26), 0)
	map.set_cell(2, pDoor2, 0, Vector2i(9, 27), 0)
	map.set_cell(2, pDoor3, 0, Vector2i(9, 28), 0)
	pass  # Replace with function body.


func _on_body_exited(_body):
	#print("_on_body_exited")
	var map: TileMap = get_parent()
	map.set_cell(2, pDoor1, 0, Vector2i(12, 23), 0)
	map.set_cell(2, pDoor2, 0, Vector2i(12, 24), 0)
	map.set_cell(2, pDoor3, 0, Vector2i(12, 25), 0)
	pass  # Replace with function body.
