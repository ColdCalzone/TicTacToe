extends Control

onready var pos1 = $CenterContainer/Board/Pos1
onready var pos2 = $CenterContainer/Board/Pos2
onready var pos3 = $CenterContainer/Board/Pos3
onready var pos4 = $CenterContainer/Board/Pos4
onready var pos5 = $CenterContainer/Board/Pos5
onready var pos6 = $CenterContainer/Board/Pos6
onready var pos7 = $CenterContainer/Board/Pos7
onready var pos8 = $CenterContainer/Board/Pos8
onready var pos9 = $CenterContainer/Board/Pos9

const MENU = preload("res://Menu.tscn")

enum CHARACTER {X, O, NONE}

enum STATES {X, O, TIE}

signal player_moved

# Not sure why we have an extra blank...

var board : Array = [" ",
	" ", " ", " ",
	" ", " ", " ",
	" ", " ", " "
]

onready var visual_board = [" ",
	pos1, pos2, pos3,
	pos4, pos5, pos6,
	pos7, pos8, pos9
]


func insertLetter(letter, pos):
	board[pos] = letter
	visual_board[pos].character = letter

func spaceIsFree(pos):
	return board[pos] == ' '

# surely there's a better way!
func isWinner(bo, le):
	# I fuckin' hate this
	return (
		(bo[1] == le and bo[2] == le and bo[3] == le) or 
		(bo[4] == le and bo[5] == le and bo[6] == le) or 
		(bo[7] == le and bo[8] == le and bo[9] == le) or 
		(bo[1] == le and bo[4] == le and bo[7] == le) or 
		(bo[2] == le and bo[5] == le and bo[8] == le) or 
		(bo[3] == le and bo[6] == le and bo[9] == le) or 
		(bo[1] == le and bo[5] == le and bo[9] == le) or 
		(bo[3] == le and bo[5] == le and bo[7] == le)
	)

func playerMove(move : int):
	if move > 0 and move < 10:
		if spaceIsFree(move):
			insertLetter('X', move)
			if not isWinner(board, "X"):
				var comps_move = compMove()
				if comps_move > 0:
					insertLetter('O', comps_move)
					if isWinner(board, "O"):
						var menu = MENU.instance()
						menu.state = STATES.O
						add_child(menu)
				else:
					var menu = MENU.instance()
					menu.state = STATES.TIE
					add_child(menu)
			else:
				var menu = MENU.instance()
				menu.state = STATES.X
				add_child(menu)

func compMove():
	# Gets a list of all possible moves
	var possibleMoves = []
	for letter in range(board.size()):
		if board[letter] == ' ' and letter != 0:
			possibleMoves.append(letter)
	# Sets move as a default value
	var move = 0
	# The order of the code determines the AI's prioritization. Try to win before trying to stop the player before taking a corner before taking the center before taking the edge before tying the game.
	# Iterates twice, once from the perspective of the AI and once from the perspective of the player.
	for le in ['O', 'X']:
		# Only iterates over allowed spaces.
		for i in possibleMoves:
			# Copies the board as a unique object? py is weird man.
			var boardCopy = board.duplicate()
			# sets a character in a valid position
			boardCopy[i] = le
			# has anyone won?
			if isWinner(boardCopy, le):
				# Return the next move, either one that makes me win or robs the player of a winning oppurtunity.
				move = i
				return move
	var cornersOpen = []
	for i in possibleMoves:
		if i in [1,3,7,9]:
			cornersOpen.append(i)
	if len(cornersOpen) > 0:
		move = selectRandom(cornersOpen)
		return move
	if 5 in possibleMoves:
		move = 5
		return move
	var edgesOpen = []
	for i in possibleMoves:
		if i in [2,4,6,8]:
			edgesOpen.append(i)
	if len(edgesOpen) > 0:
		move = selectRandom(edgesOpen)
		return move
	return move

func selectRandom(li):
	var ln = len(li)
	var r = rand_range(0, ln)
	return li[r]

func isBoardFull(board):
	return not(board.count(' ') > 1)

func _ready():
	pos1.connect("pressed", self, "playerMove", [1])
	pos2.connect("pressed", self, "playerMove", [2])
	pos3.connect("pressed", self, "playerMove", [3])
	pos4.connect("pressed", self, "playerMove", [4])
	pos5.connect("pressed", self, "playerMove", [5])
	pos6.connect("pressed", self, "playerMove", [6])
	pos7.connect("pressed", self, "playerMove", [7])
	pos8.connect("pressed", self, "playerMove", [8])
	pos9.connect("pressed", self, "playerMove", [9])

func _input(event):
	if event.is_action_pressed("restart"):
		get_tree().change_scene("res://Game.tscn")
