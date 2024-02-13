# This script is an autoload, that can be accessed from any other script!

extends Node2D
var time : float
var score : int = 0
@export var reset : int = 0

@onready var r_timer = $ResetTimer
# Adds 1 to score variable
func add_score():
	score = 1 + score
	
func _ready():
	pass


# Loads next level
func load_next_level(next_scene : PackedScene):
	get_tree().change_scene_to_packed(next_scene)
func reset_scene():
	if SceneTransition.current_scene == 5:
		get_node("/root/Level_05")
	reset = 1
	await get_tree().create_timer(0.2).timeout
	reset = 0
	



