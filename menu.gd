extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_new_game_button_down():
	get_tree().change_scene("res://game.tscn")
	pass # Replace with function "res://game.tscn"body.


func _on_hall_of_fame_button_down():
	get_tree().change_scene("res://hall_of_fame.tscn")
	pass # Replace with function body.


func _on_exit_button_down():
	get_tree().quit()
	pass # Replace with function body.
