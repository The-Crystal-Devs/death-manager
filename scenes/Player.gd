extends KinematicBody2D

var startingPoint
var destination

var time = 0
var timeDirection = 1
var moveDuration = 2

func _ready():
	pass

func _on_Client_selected(client):
	startingPoint = position
	destination = client.position
	
func _process(delta):
	if(destination != null ):
		# Flip the direction of how time gets added
		# This ensures it moves back to its initial position
		if (time > moveDuration or time < 0):
			timeDirection = 0

		# delta is how long it takes to complete a frame.
		time += delta * timeDirection
		var t = time / moveDuration

		position = lerp(startingPoint, destination, t)
