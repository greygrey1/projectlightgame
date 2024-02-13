extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	self.disabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Level_01.tscn")
	Saveload.loadgame()


func _on_button_pressed():
	self.disabled = true
