extends Node2D

signal money_changed
export(PackedScene) var client_scene

var money = 0

func _ready():
	pass

func _on_Client_client_left(money_received):
	self.money += money_received
	emit_signal("money_changed", self.money)

func spawn_client():
	var client = client_scene.instance()
	client.position = Vector2(42, 42)
	add_child(client)
