extends Area2D

signal client_left
signal client_selected
signal station_selected
signal client_died

export (Stations.Type) var wanted_station_type = Stations.Type.TYPE_1
export var money = 9001

var selected = false;
var used_station = null

func _ready():
	wanted_station_type = Stations.pick_random_station_type()
	
	var wanted_station_image = Stations.pick_station_image(wanted_station_type)
	$WantedStationType.texture = wanted_station_image

func register_station(station):
	 station.connect("station_selected", self, "_on_Station_selected")

func _input_event(viewport, event, shape_idx):
	if is_left_clicked(event):
		emit_signal("client_selected", self)
		
func select_client():
	get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME ,"Clients", "unselect")
	selected = true;
		
func is_left_clicked(event):
	return event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed()

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

func unselect():
	self.selected = false
	
func die():
	self.used_station = null
	emit_signal("client_died")
	queue_free()

func _on_Client_body_entered(body):
	select_client()
