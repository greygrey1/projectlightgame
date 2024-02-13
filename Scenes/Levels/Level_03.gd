extends Node2D
@onready var textboxing = $UserInterface/GameUI/TextBox
@onready var mobile = $Player
@onready var end = $Cutscene
@onready var sprite = $stag
@onready var cam = $Player/Camera2D
@onready var spawn_point = $Level/SpawnPoint
@onready var flower = $Kubjelle
# Called when the node enters the scene tree for the first time.
func _ready():
	SceneTransition.scene_num = 3
	textboxing.cutscene = 0
	AudioManager.whichmusic = 1
	sprite.visible = true

func debug():
	if Input.is_action_just_pressed("Debug"):
		spawn_point.global_position = Vector2(8227, -2130)
		mobile.global_position = Vector2(8227, -2130)
		flower.health = 15
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	debug()
	if mobile.canmove == 1:
		sprite.visible = false
		var tween2 = create_tween()
		var tween = create_tween()
		tween.tween_property(cam, "offset", Vector2(0, 0), 0.15)
		tween2.tween_property(cam, "zoom", Vector2(1.27, 1.27), 0.15)
	if mobile.canmove == 0:
		
		var tween = create_tween()
		var tween2 = create_tween()
		tween.tween_property(cam, "offset", Vector2(100, 0), 0.15)
		tween2.tween_property(cam, "zoom", Vector2(1, 1), 0.15)
func bmusic():
	AudioManager.whichmusic = 2
func _on_area_2d_area_entered(area):
	if area.is_in_group("Player"):
		sprite.visible = true
		bmusic()
		mobile.canmove = 0
		textboxing.cutscene = 2
		await textboxing.cutscene == 0
		end.endcutscene()
		


func _on_area_2d_area_exited(area):
	pass
