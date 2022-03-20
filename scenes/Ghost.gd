extends Area2D

signal ghost_selected
signal station_selected
signal ghost_died

var selected = false
var used_station = null
var tween
var remaining_life = 5

func _ready():
	tween = get_node("Tween")
		
func register_station(station):
	 station.connect("station_selected", self, "_on_Station_selected")

func _input_event(viewport, event, shape_idx):
	if is_left_clicked(event):
		emit_signal("ghost_selected", self)
		
func select_ghost():
	get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME ,"Ghosts", "unselect")
	selected = true;

func unselect():
	self.selected = false
		
func is_left_clicked(event):
	return event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.is_pressed()

func _on_Station_selected(station):
	if(selected and used_station == null and station.ghost == null):
		selected = false
		move_to_station(station)
		emit_signal("station_selected", self)
		return true
		
	return false

func move_to_station(station):
	# Put ghost under the station
	var destination = station.position + Vector2(0, 60)
	var distance = self.position.distance_to(destination)
	tween.remove_all()
	tween.interpolate_property(self, "position",
		self.position, destination, distance * 0.005,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func on_station_finished():
	remaining_life -= 1
	if(remaining_life <= 0):
		emit_signal("ghost_died")
		$GhostSprite.animation = "death"
		yield($GhostSprite, "animation_finished")
		queue_free()
		
