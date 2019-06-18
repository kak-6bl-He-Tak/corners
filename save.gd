extends Node2D

var file = File.new()


func _on_Button_button_down():
	var a
	file.open(Global.path, File.READ)
	a = file.get_csv_line()
	file.close()
	a.resize(a.size() + 1)
	a[a.size() - 1] =  $LineEdit.text + ' - ' + str(1)
	
	for o in a :
		print(a[0], o)
	file.open(Global.path, File.WRITE)
	file.store_csv_line(a)
	file.close()
	
	
	file.open(Global.path, File.READ)
	a = file.get_csv_line()
	file.close()
	
	
	pass # Replace with function body.
