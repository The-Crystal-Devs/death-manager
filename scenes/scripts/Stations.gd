class_name Stations

enum Type {TYPE_1, TYPE_2, TYPE_3}

static func pick_station_image(type):
	var image_filename = ""

	match type:
		Type.TYPE_1:
			image_filename = "green_square.png"
		Type.TYPE_2:
			image_filename = "blue_square.png"
		Type.TYPE_3:
			image_filename = "red_square.png"

	return load("res://assets/" + image_filename)

static func pick_random_station_type():
	return Type.values()[randi() % Type.values().size()]
