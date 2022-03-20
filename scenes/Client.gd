extends Area2D

signal client_left
signal client_selected
signal station_selected
signal client_died

export (Stations.Type) var wanted_station_type = Stations.Type.TYPE_1
export var money = 9001

var selected = false
var used_station = null
var tween

func _ready():
	tween = get_node("Tween")
	wanted_station_type = Stations.pick_random_station_type()
	
	var wanted_station_image = Stations.pick_station_image(wanted_station_type)
	$WantedStationType.texture = wanted_station_image
	
func _on_movement_completed(object, key):
	$ClientSprite.animation = "idle"

func register_station(station):
	 station.connect("station_selected", self, "_on_Station_selected")

func _input_event(viewport, event, shape_idx):
	if is_left_clicked(event):
		emit_signal("client_selected", self)
		
func select_client():
	get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME ,"Clients", "unselect")
	selected = true;

func unselect():
	self.selected = false
		
func is_left_clicked(event):
	return event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed()

func _on_Station_selected(station):
	if(selected and used_station == null and station.client == null and station.type == wanted_station_type):
		selected = false
		move_to_station(station)
		emit_signal("station_selected", self)
		return true
		
	return false

func move_to_station(station):
	var distance = self.position.distance_to(station.position)
	tween.remove_all()
	tween.interpolate_property(self, "position",
		self.position, station.position, distance * 0.005,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	$ClientSprite.animation = "walk"

func leave_station():
	self.used_station = null
	emit_signal("client_left", money)
	queue_free()
	
func die():
	self.used_station = null
	emit_signal("client_died")
	queue_free()
