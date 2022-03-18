extends Area2D

signal client_left
signal station_selected

enum StationType {TYPE_1, TYPE_2, TYPE_3}

export (StationType) var wanted_station_type
export var money = 9001

var selected = false;
var used_station = null

func _ready():
	wanted_station_type = StationType.values()[randi() % StationType.values().size()]
	
	var wanted_station_image = pick_station_image()
	$WantedStationType.texture = wanted_station_image
	
func pick_station_image():
	var image_filename = ""

	match wanted_station_type:
		StationType.TYPE_1:
			image_filename = "green_square.png"
		StationType.TYPE_2:
			image_filename = "blue_square.png"
		StationType.TYPE_3:
			image_filename = "red_square.png"

	return load("res://assets/" + image_filename)

func register_station(station):
	 station.connect("station_selected", self, "_on_Station_selected")

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed():
		selected = true;

func _on_Station_selected(station):
	if(selected and used_station == null and station.client == null and station.type == wanted_station_type):
		selected = false
		used_station = station
		station.assign_client(self)
		move_to_station(station)
		emit_signal("station_selected", self)

func move_to_station(station):
	self.position = station.position

func leave_station():
	self.used_station = null
	emit_signal("client_left", money)
	queue_free()
