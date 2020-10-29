extends TextureButton

onready var x = preload("res://Sprites/cross.png")
onready var o = preload("res://Sprites/circle.png")

onready var character = "NONE"

class_name TicTacToeButton

func _process(delta):
	if character == "X":
		texture_normal = x
	if character == "O":
		texture_normal = o
