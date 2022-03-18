extends Area2D

signal station_selected

enum StationType {TYPE_1, TYPE_2, TYPE_3}
export var type = StationType.TYPE_1
var client = null

func _ready():
	var station_image = pick_station_image()
	$Sprite.texture = station_image
	
func pick_station_image():
	var image_filename = ""
	
	match type:
		StationType.TYPE_1:
			image_filename = "green_square.png"
		StationType.TYPE_2:
			image_filename = "blue_square.png"
		StationType.TYPE_3:
			image_filename = "red_square.png"

	return load("res://assets/" + image_filename)
			

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed():
		emit_signal("station_selected", self)

func assign_client(client): 
	self.client = client
	$StationDuration.start()

func _on_StationDuration_timeout():
	self.client.leave_station()
	self.client = null
