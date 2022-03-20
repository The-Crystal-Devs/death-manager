extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Level_money_changed(money):
	$MoneyLabel.text = "$ " + str(money)

func _on_Level_remaining_seconds_changed(remaining_seconds):
	$TimerLabel.text = str(remaining_seconds)
