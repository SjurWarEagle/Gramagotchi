extends Control
var gremlin_scene = preload("res://scenes/gremlin.tscn")
@onready var world = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready():
	generate_gremlin_for_nick("SjurWarEagle")
	for i in 100:
		generate_gremlin_for_nick("Demo"+str(i))
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func generate_gremlin(texture: ImageTexture, gremlin_name: String):
	var gremlin: GremlinCharacter = gremlin_scene.instantiate()
#	gremlin.rotates=false
	gremlin.get_child(0).visible = true
	gremlin.set_texture(texture)
#	(gremlin.get_child(0) as TextureRect).scale=Vector2(1,1)
	gremlin.position = Vector2(100, 150)

	(gremlin as CharacterBody2D).visible = true
	gremlin.name = "Gremlin " + gremlin_name
	world.add_child(gremlin)
	pass


func http_request_dna_completed(
	_result, _response_code, _headers, body, dna_http_request: HTTPRequest, gremlin_name: String
):
	#print("http_request_dna_completed")
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var gremlinDna = json.get_data()
	dna_http_request.queue_free()

	#print(_data)
	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(
		self.http_request_image_completed.bind(http_request, gremlin_name)
	)
	# Perform the HTTP request. The URL below returns a PNG image as of writing.
	var url = (
		"https://gremlin.tkunkel.de/api/generate-gremlin?colourSkin=0x%x&colourFurFront=0x%x&colourFurBack=0x%x&size=200"
		% [gremlinDna.colourSkin, gremlinDna.colourFurFront, gremlinDna.colourFurBack]
	)
	print("getting " + url)
	var error = http_request.request(url)
	if error != OK:
		push_error("An error occurred in the HTTP request.")


# Called when the HTTP request is completed.
func http_request_image_completed(
	_result,
	_response_code,
	_headers,
	body: PackedByteArray,
	image_http_request: HTTPRequest,
	gremlin_name: String
):
	#print("http_request_image_completed")

	var image = Image.new()
	var byte_array: PackedByteArray = PackedByteArray(body)
	var error = image.load_png_from_buffer(byte_array)
	if error != OK:
		push_error("Couldn't load the image.")

	image_http_request.queue_free()
	var texture = ImageTexture.new()
	texture = ImageTexture.create_from_image(image)

	#var node = Sprite2D.new()
	#node.position=Vector2(200,200)
	#node.texture=texture
	#$Control/Room.add_child(node)
	generate_gremlin(texture, gremlin_name)


func generate_gremlin_for_nick(nick):
	print("generate_gremlin_for_nick {0}".format([nick]))
	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	self.add_child(http_request)
	http_request.request_completed.connect(self.http_request_dna_completed.bind(http_request, nick))

	var url = "https://gremlin.tkunkel.de/api/dna/convert-nick?nick={0}"
	print("getting " + url.format([nick]))
	var error = http_request.request(url.format([nick]))
	if error != OK:
		push_error("An error occurred in the HTTP request.")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
