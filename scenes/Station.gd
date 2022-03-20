extends Area2D

signal station_selected
signal station_finished

class_name Station
export (Stations.Type) var type
export var chances_to_kill_client = 100
var client = null
var ghost = null

func _ready():
	var station_image = Stations.pick_station_image(type)
	$Sprite.texture = station_image


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed() \
	and !event.is_echo():
		emit_signal("station_selected", self)

func assign_client(client):
	client.used_station = self
	client.unselect()
	self.client = client
	$StationDuration.start()

func assign_ghost(ghost):
	ghost.used_station = self
	self.ghost = ghost
	self.connect("station_finished", ghost, "on_station_finished")
	ghost.connect("ghost_died", self, "_on_ghost_death")

func _on_StationDuration_timeout():
	var kill_client = randi() % 100 <= chances_to_kill_client

	if(kill_client):
		self.client.die()
	else:
		self.client.leave_station()

	self.client = null
	emit_signal("station_finished")

func _on_ghost_death():
	self.ghost = null;
