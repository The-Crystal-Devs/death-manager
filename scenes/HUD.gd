extends CanvasLayer

var current_score = "0"

# Called when the node enters the scene tree for the first time.
func _ready():
	$GameOver.hide()

func _on_Level_money_changed(money):
	current_score = str(money)
	$MoneyLabel.text = "$ " + current_score

func _on_Level_remaining_seconds_changed(remaining_seconds):
	$TimerLabel.text = str(remaining_seconds)

func _on_Level_game_over():
	$GameOver/FinalScoreLabel.text = "Your final score: $" + current_score
	$GameOver.show()
