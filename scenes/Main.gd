extends Node2D

signal money_changed
export(PackedScene) var client_scene

var money = 0
var waiting_clients = []

func _ready():
	spawn_client()

func _on_Client_left(money_received):
	self.money += money_received
	emit_signal("money_changed", self.money)
	
func _on_Client_station_selected(client): 
	waiting_clients.remove(waiting_clients.find(client))
	
func spawn_client():
	var client = client_scene.instance()
	client.position = compute_new_client_position()
	client.register_station(get_node("Station"))
	client.connect("client_left", self, "_on_Client_left")
	client.connect("station_selected", self, "_on_Client_station_selected")
	add_child(client)
	waiting_clients.push_back(client)
	
func compute_new_client_position(): 
	var last_client = waiting_clients.back()
	if(last_client == null):
		return Vector2(42, 42)
	
	return last_client.position + Vector2(last_client.get_node("ClientSprite").texture.get_width() + 6, 0)

func _on_NewClientTimer_timeout():
	spawn_client()
