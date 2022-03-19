extends Node2D

signal money_changed
export(PackedScene) var client_scene
export(PackedScene) var ghost_scene
export var max_waiting_clients = 8
export var init_client_position = Vector2(42, 42)
export var init_ghost_position = Vector2(42, 110)

var money = 0
var waiting_clients = []
var ghosts = []

## Scene init

func _ready():
	randomize()
	spawn_client()

func spawn_client():
	var client = init_new_client()
	connect_to_clients_signals(client)
	add_child(client)
	waiting_clients.push_back(client)
		
func connect_to_clients_signals(client):
	client.connect("client_left", self, "_on_Client_left")
	client.connect("station_selected", self, "_on_Client_station_selected")
	client.connect("client_died", self, "_on_Client_died")
	
func init_new_client():
	var client = client_scene.instance()
	client.position = compute_new_client_position()
	var stations = get_tree().get_nodes_in_group("Stations")
	for station in stations:
		client.register_station(station)
	return client
	
func compute_new_client_position(): 
	var last_client = waiting_clients.back()
	if(last_client == null):
		return init_client_position
	
	return last_client.position + Vector2(last_client.get_node("ClientSprite").texture.get_width() + 6, 0)
	
## Listening to signals

func _on_Client_left(money_received):
	self.money += money_received
	emit_signal("money_changed", self.money)
	
func _on_Client_station_selected(client): 
	waiting_clients.remove(waiting_clients.find(client))
		
func _on_Client_died():
	spawn_ghost()

func spawn_ghost():
	var ghost = ghost_scene.instance()
	ghost.position = compute_new_ghost_position()
	add_child(ghost)
	ghosts.push_back(ghost)

func compute_new_ghost_position():
	var last_ghost = ghosts.back()
	if(last_ghost == null):
		return init_ghost_position
	
	return last_ghost.position + Vector2(last_ghost.get_node("GhostSprite").texture.get_width() + 6, 0)
	
func _on_NewClientTimer_timeout():
	if(waiting_clients.size() < max_waiting_clients):
		spawn_client()
