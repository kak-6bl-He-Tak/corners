extends Node2D


var k = 32 # corection
var Black = preload("res://black.tscn")
var Wite = preload("res://wite.tscn")
var Ok = preload("res://ok.tscn")
var label = preload("res://Label.tscn")
var button = preload("res://new_game.tscn")
var pick # выбранная фигура {фигура, х, у}
var STEP # общее колчичество шагов
var Print_step # вводимое кол-во шагов
var win # победитель
var board # массив - доска

func _ready():
	new_game()
	pass # Replace with function body.

func _process(delta):
	var a = STEP % 2
	var message = label.instance()
	var player
	win = check_winer()
	if Input.is_action_just_pressed("ui_mouse1") && !win :
		var mouse = get_field_click()
		var x = int (mouse.x)
		var y = int (mouse.y)
		var last_x = pick.x
		var last_y = pick.y
		var on_board = (x >= 0 && x <= 7) && (y >= 0 && y <= 7) #координата мыши в пределах доски
		if (on_board && (board[y][x] == 1 || board[y][x] == 2)) :
			if pick.checker == board[y][x] || !pick.checker :
				if (board[y][x] == 1 && ! a) || (board[y][x] == 2 && a) :
					pick.checker = board[y][x]
					pick.x = x
					pick.y = y
		if on_board && (!board[y][x] || board[y][x] == 3 || (last_x == pick.x && last_y == pick.y)) :
			if (pick.checker && board[y][x] == 3) :
				board[y][x] = pick.checker
				board[pick.y][pick.x] = 0
				STEP += 1
				if (!a) :
					Print_step += 1
			pick.checker = 0
			pick.x = -1
			pick.y = -1
			only_checkers()
			set_checkers()
		elif on_board && pick.checker  :
			show_steps()
	if (!win) :
		if STEP % 2 :
			player = "White"
		else :
			player = "Black"
		message.text = "STEP " + str(Print_step) + ' ' + player
		set_checkers()
		add_child(message)
		get_node("button").position.y = 50
	else :
		if win == 1 :
			message.text = "BLAK WINNER!"
		else :
			message.text = "WHITE WINNER!"
		set_checkers()
		add_child(message)
		get_node("button").position.y = 0
		Global.steps = STEP
	pass

func new_game() : # начальные данные игры
	board = [
		[1,1,1,0,0,0,0,0],
		[1,1,1,0,0,0,0,0],
		[1,1,1,0,0,0,0,0],
		[0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0],
		[0,0,0,0,0,2,2,2],
		[0,0,0,0,0,2,2,2],
		[0,0,0,0,0,2,2,2],
	]
	pick = {'checker' : 0, 'x' : -1, 'y' : -1}
	STEP = 1
	Print_step = 1
	win = 0
	pass

func check_winer() : # проверка на победителя
	var a = 2
	var x
	var y = 0
	while y < 3 :
		x = 0
		while x < 3 :
			if board[y][x] != 2 :
				a = 0
			x += 1
		y += 1
	if !a :
		a = 1
		y = 5
		while y < 8 :
			x = 5
			while x < 8 :
				if board[y][x] != 1 :
					a = 0
				x += 1
			y += 1
	return (a)
	pass
	 
func show_steps() : # укладывает в массив 3 на взможные ходы относительно выбранной фигуры
	only_checkers()
	ok_horizon(pick.x, pick.y)
	ok_vertical(pick.x, pick.y)
	ok_diagonal_right(pick.x, pick.y)
	ok_diagonal_left(pick.x, pick.y)
	pass

func ok_diagonal_left(x, y) : 
	var tmp_x = x
	var tmp_y = y
	
	while (tmp_x < 7 && tmp_y > 0) :
		if (!board[tmp_y - 1][tmp_x + 1]) :
			board[tmp_y - 1][tmp_x + 1] = 3
		elif (board[tmp_y - 1][tmp_x + 1] == 1 || board[tmp_y - 1][tmp_x + 1] == 2) && tmp_x < 6 && tmp_y > 1 :
			if (board[tmp_y - 2][tmp_x + 2] == 1 || board[tmp_y - 2][tmp_x + 2] == 2) :
				tmp_x = 8
		tmp_x += 1
		tmp_y -= 1
	tmp_x = x
	tmp_y = y
	while (tmp_x > 0 && tmp_y < 7) :
		if (!board[tmp_y + 1][tmp_x - 1]) :
			board[tmp_y + 1][tmp_x - 1] = 3
		elif (board[tmp_y + 1][tmp_x - 1] == 1 || board[tmp_y + 1][tmp_x - 1] == 2) && tmp_x > 1 && tmp_y < 6 :
			if (board[tmp_y + 2][tmp_x - 2] == 1 || board[tmp_y + 2][tmp_x - 2] == 2) :
				tmp_x = 0
		tmp_x -= 1
		tmp_y += 1
	pass

func ok_diagonal_right(x, y) :
	var tmp_x = x
	var tmp_y = y
	
	while (tmp_x < 7 && tmp_y < 7) :
		if (!board[tmp_y + 1][tmp_x + 1]) :
			board[tmp_y + 1][tmp_x + 1] = 3
		elif (board[tmp_y + 1][tmp_x + 1] == 1 || board[tmp_y + 1][tmp_x + 1] == 2) && tmp_x < 6 && tmp_y < 6 :
			if (board[tmp_y + 2][tmp_x + 2] == 1 || board[tmp_y + 2][tmp_x + 2] == 2) :
				tmp_x = 8
		tmp_x += 1
		tmp_y += 1
	tmp_x = x
	tmp_y = y
	while (tmp_x > 0 && tmp_y > 0) :
		if (!board[tmp_y - 1][tmp_x - 1]) :
			board[tmp_y - 1][tmp_x - 1] = 3
		elif (board[tmp_y - 1][tmp_x - 1] == 1 || board[tmp_y - 1][tmp_x - 1] == 2) && tmp_x > 0 && tmp_y > 0 :
			if (board[tmp_y - 2][tmp_x - 2] == 1 || board[tmp_y - 2][tmp_x - 2] == 2) :
				tmp_x = 0
		tmp_x -= 1
		tmp_y -= 1
	
	pass

func ok_vertical(x, y) :
	var tmp_y
	tmp_y = y
	while tmp_y < 7 :
		if (!board[tmp_y + 1][x]) :
			board[tmp_y + 1][x] = 3
		elif (board[tmp_y + 1][x] == 1 || board[tmp_y + 1][x] == 2) && tmp_y < 6 :
			if (board[tmp_y + 2][x] == 1 || board[tmp_y + 2][x] == 2) :
				tmp_y = 8
		tmp_y += 1
	tmp_y = y
	while tmp_y > 0 :
		if (!board[tmp_y - 1][x]) :
			board[tmp_y - 1][x] = 3
		elif (board[tmp_y - 1][x] == 1 || board[tmp_y - 1][x] == 2) && x > 1 :
			if (board[tmp_y - 2][x] == 1 || board[tmp_y - 2][x] == 2) :
				tmp_y = -1
		tmp_y -= 1
	pass

func ok_horizon(x,y) :
	var tmp_x = x
	while tmp_x < 7 :
		if (!board[y][tmp_x + 1]) :
			board[y][tmp_x + 1] = 3
		elif (board[y][tmp_x + 1] == 1 || board[y][tmp_x + 1] == 2) && tmp_x < 6 :
			if (board[y][tmp_x + 2] == 1 || board[y][tmp_x + 2] == 2) :
				tmp_x = 8
		tmp_x += 1
	tmp_x = x
	while tmp_x > 0 :
		if (!board[y][tmp_x - 1]) :
			board[y][tmp_x - 1] = 3
		elif (board[y][tmp_x - 1] == 1 || board[y][tmp_x - 1] == 2) && y > 1:
			if (board[y][tmp_x - 2] == 1 || board[y][tmp_x - 2] == 2) :
				tmp_x = -1
		tmp_x -= 1
	pass

func set_checkers() : # устанавливает спрайты фигур и галочек соответсвенно положениям в массиве
	var x
	var y = 0
	var checker
	var i = 3

	checker = get_children()
	while i < checker.size() :
		remove_child(checker[i])
		i += 1
	while (y < 8) :
		x = 0;
		while (x < 8) :
			if (board[y][x] == 1) :
				checker = Black.instance()
				checker.position.x = x * 44 + k + 23
				checker.position.y = y * 44 + k + 23
				add_child(checker)
			elif (board[y][x] == 2) :
				checker = Wite.instance()
				checker.position.x = x * 44 + k + 24
				checker.position.y = y * 44 + k + 24
				add_child(checker)
			elif (board[y][x] == 3) :
				checker = Ok.instance()
				checker.position.x = x * 44 + k + 25
				checker.position.y = y * 44 + k + 23
				add_child(checker)
			x += 1
		y += 1
	pass

func only_checkers() : # удаляет из массива все 3
	var x
	var y = 0
	
	while y < 8 :
		x = 0
		while x < 8 :
			if board[y][x] == 3 :
				board[y][x] = 0
			x += 1
		y += 1
	pass

func get_field_click() : # возвращает координаты курсора с началом координат от верхнего левого угла доски
	var mouse = Vector2 (0, 0)
	
	mouse.x = (get_global_mouse_position().x - k) / 44 
	mouse.y = (get_global_mouse_position().y - k) / 44
	return(mouse)	
	pass

func _on_button_button_down():
	new_game()
	pass # Replace with function body.


func _on_menu_button_down():
	get_tree().change_scene("res://menu.tscn")
	pass # Replace with function body.


func _on_Button_button_down():
	get_tree().change_scene("res://save.tscn")
	pass # Replace with function body.
