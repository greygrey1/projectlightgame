# This script is an autoload, that can be accessed from any other script!

extends CanvasLayer
var current_scenename
@export var scenern: String
@export var current_scene: int
@onready var scene_transition_anim = $SceneTransitionAnim
@onready var dissolve_rect = $DissolveRect
@onready var scene_num : int = 0
@onready var scene : PackedScene
# Scene Transition can be changed from the inspector(Currently only 2, fade and scale. You can add more!)
enum state {FADE, SCALE}
@export var transition_type : state
func _process(delta):
	scenern = get_tree().get_current_scene().scene_file_path
	current_scenename = get_tree().get_current_scene().get_name()
	if current_scenename == "Level_01":
		current_scene = 1
	elif current_scenename == "Level_02":
		current_scene = 2
	elif current_scenename == "Level_03":
		current_scene = 3
	elif current_scenename == "Level_04":
		current_scene = 4
	elif current_scenename == "Level_05":
		current_scene = 5
func _ready():
	dissolve_rect.hide() # Hide the dissolve rect

# You can call this funciton from any script by doing SceneTransition.load_scene(target_scene)
func load_scene(a: int):
	match transition_type:
		state.FADE:
			transition_animation("fade", a)
		state.SCALE:
			transition_animation("scale", a)
			
func load_scene2(a: String):
	match transition_type:
		state.FADE:
			transition_animation2("fade", a)
		state.SCALE:
			transition_animation2("scale", a)

# This function handles the transition animation
func transition_animation(animation_name: String, a: int):
	scene_transition_anim.play(animation_name)
	await scene_transition_anim.animation_finished
	print(scene_num)
	if scene_num == 0:
		get_tree().change_scene_to_file("res://Scenes/Levels/Level_01.tscn")
	if scene_num == 1:
		get_tree().change_scene_to_file("res://Scenes/Levels/Level_02.tscn")
	elif scene_num == 2:
		get_tree().change_scene_to_file("res://Scenes/Levels/Level_03.tscn")
	elif scene_num == 3:
		get_tree().change_scene_to_file("res://Scenes/Levels/level_04.tscn")
	elif scene_num == 4:
		get_tree().change_scene_to_file("res://Scenes/Levels/Level_05.tscn")
	scene_transition_anim.play_backwards(animation_name)
	
func transition_animation2(animation_name: String, a: String):
	scene_transition_anim.play(animation_name)
	await scene_transition_anim.animation_finished
	get_tree().change_scene_to_file(a)
	scene_transition_anim.play_backwards(animation_name)
