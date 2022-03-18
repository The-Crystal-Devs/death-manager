extends Area2D

signal client_left

export var wanted_station_type = "pouet"
export var money = 9001

var selected = false;
var used_station = null

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
		station.asign_client(self)
		print("joined station")

func leave_station():
	self.used_station = null
	emit_signal("client_left", money)
	print("left station")
	queue_free()
