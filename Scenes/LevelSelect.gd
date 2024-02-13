extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Level_01.tscn")


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Level_02.tscn")


func _on_button_3_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Level_03.tscn")


func _on_button_4_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/level_04.tscn")


func _on_button_5_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Level_05.tscn")
