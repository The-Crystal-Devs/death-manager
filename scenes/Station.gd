extends Area2D

signal station_selected

export var type = "pouet"
var client = null

func _ready():
	pass

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
