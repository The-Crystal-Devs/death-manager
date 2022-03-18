extends Node2D

signal money_changed

var money = 0

func _ready():
	pass # Replace with function body.

func _on_Client_client_left(money_received):
	self.money += money_received
	emit_signal("money_changed", self.money)
