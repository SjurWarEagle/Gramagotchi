extends Area2D

var pDoor1 = Vector2i(29, 6)
var pDoor2 = Vector2i(29, 7)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_body_entered(_body):
	#print("_on_body_entered")
	var map: TileMap = get_parent()
	map.erase_cell(2, pDoor1)
	map.erase_cell(2, pDoor2)
	pass  # Replace with function body.


func _on_body_exited(_body):
	#print("_on_body_exited")
	var map: TileMap = get_parent()
	map.set_cell(2, pDoor1, 9, Vector2i(4, 43), 0)
	map.set_cell(2, pDoor2, 9, Vector2i(4, 44), 0)
	pass  # Replace with function body.
