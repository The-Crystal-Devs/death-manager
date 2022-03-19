extends KinematicBody2D

var startingPoint
var destination

var time
var timeDirection
var moveDuration

func _ready():
	reset_movement()

func _on_Client_selected(client):
	reset_movement()
	destination = client.position
	
func reset_movement():
	time = 0
	timeDirection = 1
	moveDuration = 2
	startingPoint = self.position
	destination = null

func _process(delta):
	if(destination != null):
		# Flip the direction of how time gets added
		# This ensures it moves back to its initial position
		if (time > moveDuration or time < 0):
			timeDirection = 0

		# delta is how long it takes to complete a frame.
		time += delta * timeDirection
		var t = time / moveDuration

		position = lerp(startingPoint, destination, t)
