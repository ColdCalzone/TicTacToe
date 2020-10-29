extends CenterContainer

onready var label = $UI/LabelContainer/Label
onready var restart = $UI/ButtonContainer/Res
onready var quit = $UI/ButtonContainer/Quit
var state

enum STATES {X, O, TIE}

func restart():
	get_tree().change_scene("res://Game.tscn")

func quit():
	get_tree().quit()

func _ready():
	restart.connect("pressed", self, "restart")
	quit.connect("pressed", self, "quit")
	if state == STATES.TIE:
		label.text = "YOU TIED!"
	if state == STATES.X:
		label.text = "YOU WON!"
	if state == STATES.O:
		label.text = "YOU LOST!"
