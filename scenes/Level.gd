extends Node2D

signal money_changed
signal remaining_seconds_changed
signal game_is_over

export(PackedScene) var client_scene
export(PackedScene) var ghost_scene
export var level_duration_in_seconds = 120
export var max_waiting_clients = 8
export var init_client_position = Vector2(42, 42)
export var init_ghost_position = Vector2(42, 110)

var money = 0
var waiting_clients = []
var ghosts = []
var remaining_seconds
var is_game_over = false

## Scene init

func _ready():
	randomize()	
	spawn_client()
	update_remaining_seconds(level_duration_in_seconds)

func spawn_client():
	var client = init_new_client()
	connect_to_clients_signals(client)
	add_child(client)
	waiting_clients.push_back(client)
	
func connect_to_clients_signals(client):
	client.connect("client_left", self, "_on_Client_left")
	client.connect("client_died", self, "_on_Client_died")
	client.connect("station_selected", self, "_on_Client_station_selected")
	client.connect("client_selected", get_player_node(), "_on_client_selected")
	
func get_player_node():
	return get_node("Player")
	
func get_stations_nodes():
	return get_tree().get_nodes_in_group("Stations")
	
func init_new_client():
	var client = client_scene.instance()
	client.position = compute_new_client_position()
	var stations = get_stations_nodes()
	return client
	
func compute_new_client_position(): 
	var last_client = waiting_clients.back()
	if(last_client == null):
		return init_client_position
	
	return last_client.position + Vector2(last_client.get_node("ClientColision").shape.extents.x * 3, 0)
	
## Listening to signals

func _on_Client_left(money_received):
	self.money += money_received
	emit_signal("money_changed", self.money)
	
func _on_Client_station_selected(client): 
	waiting_clients.remove(waiting_clients.find(client))
	
func _on_Ghost_station_selected(ghost):
	ghosts.remove(ghosts.find(ghost))
		
func _on_Client_died():
	spawn_ghost()

func spawn_ghost():
	var ghost = ghost_scene.instance()
	ghost.position = compute_new_ghost_position()
	ghost.connect("ghost_selected", get_player_node(), "_on_ghost_selected")
	ghost.connect("station_selected", self, "_on_Ghost_station_selected")
	add_child(ghost)
	ghosts.push_back(ghost)

func compute_new_ghost_position():
	var last_ghost = ghosts.back()
	if(last_ghost == null):
		return init_ghost_position
	
	return last_ghost.position + Vector2(last_ghost.get_node("GhostColision").shape.extents.x + 12 , 0)
	
func _on_NewClientTimer_timeout():
	if(waiting_clients.size() < max_waiting_clients and not is_game_over):
		spawn_client()

func update_remaining_seconds(new_value):
	remaining_seconds = new_value
	emit_signal("remaining_seconds_changed", remaining_seconds)

func _on_OneSecondTimer_timeout():
	update_remaining_seconds(remaining_seconds - 1)
	
	if(remaining_seconds == 0):
		$OneSecondTimer.stop()
		emit_signal("game_is_over")
		is_game_over = true
