extends Area2D

# Define the next scene to load in the inspector
@export var next_scene : PackedScene
func _ready():
	AudioManager.scene = 1
# Load next level scene when player collide with level finish door.
func _on_body_entered(body):
	if body.is_in_group("Player"):
		# death_tween is called here just to give the feeling of player entering the door.
		AudioManager.level_complete_sfx.play()
		get_tree().call_group("Player", "soundplay")
		SceneTransition.scene_num = SceneTransition.scene_num + 1
		SceneTransition.load_scene(SceneTransition.scene_num)
		
		
		
