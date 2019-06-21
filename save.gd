extends Node2D

var file = File.new()

func _on_Button_button_down():
	var a
	file.open(Global.path, File.READ)
	a = file.get_csv_line()
	file.close()
	a.resize(a.size() + 1)
	a[a.size() - 1] =  $LineEdit.text + ' - ' +  str(Global.steps)

	var i = a.size() - 1
	var save
	while i > 1 && int(a[i]) > int(a[i - 1]) :
		save = a[i]
		a[i] = a[i - 1]
		a[i - 1] = save 
		i -= 1
	file.open(Global.path, File.WRITE)
	file.store_csv_line(a)
	file.close()
	get_tree().change_scene("res://menu.tscn")
	pass # Replace with function body.

