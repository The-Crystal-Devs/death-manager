class_name Stations

enum Type {BOAT, HOUSE, MINE}

static func pick_station_image(type):
	var image_filename = ""

	match type:
		Type.BOAT:
			image_filename = "boat.png"
		Type.HOUSE:
			image_filename = "house.png"
		Type.MINE:
			image_filename = "mine.png"

	return load("res://assets/stations/" + image_filename)

static func pick_random_station_type():
	return Type.values()[randi() % Type.values().size()]
