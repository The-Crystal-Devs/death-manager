extends KinematicBody2D

var previous_destination
var previous_destination_type
var destination
var destination_type
var tween
var movingClientToStation

enum DestinationType {CLIENT, STATION}

func _ready():
	tween = get_node("Tween")
	tween.connect("tween_completed", self, "_on_movement_completed")

func _on_client_selected(client):
	if(client == destination || movingClientToStation):
		return
	update_previous_destination()
	destination = client
	destination_type = DestinationType.CLIENT
	
	var destination_position = destination.position + Vector2(client.get_node("ClientColision").shape.extents.x * 2, 0)
	
	_move_to_destination(destination_position)
	
func _on_station_selected(element):
	if(element == destination || movingClientToStation):
		return
	update_previous_destination()
	destination = element
	destination_type = DestinationType.STATION
	
	var destination_position
	if(previous_destination_type == DestinationType.CLIENT):
		movingClientToStation = previous_destination._on_Station_selected(destination)
		destination_position = destination.position + Vector2(previous_destination.get_node("ClientColision").shape.extents.x * 2, 0)
	else:
		destination_position = destination.position
	
	_move_to_destination(destination_position)

func update_previous_destination():
	previous_destination = destination
	previous_destination_type = destination_type
	
func _move_to_destination(destination_position):
	$AnimatedSprite.flip_h = destination_position.x < self.position.x
	$AnimatedSprite.animation = "walk"
	var distance = self.position.distance_to(destination_position)
	tween.remove_all()
	tween.interpolate_property(self, "position",
		self.position, destination_position, distance * 0.005,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_movement_completed(object, key):
	if(destination_type == DestinationType.CLIENT):
		destination.select_client()
	elif(destination_type == DestinationType.STATION and previous_destination_type == DestinationType.CLIENT):
		movingClientToStation = false
		destination.assign_client(previous_destination)
	$AnimatedSprite.animation = "idle"
