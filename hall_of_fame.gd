extends Node2D

var file = File.new()

func _ready():
	var a
	file.open(Global.path, File.READ)
	a = file.get_csv_line()
	file.close()
	
	var text
	var i = a.size()
	var j = 1
	if i > 10 :
		i = 10
	text = str(a[0])
	while j < i :
		text += ('\n' + a[j])
		j += 1
	$Label.text = text
	pass # Replace with function body.


func _on_Button_button_down():
	get_tree().change_scene("res://menu.tscn")
	pass # Replace with function body.
