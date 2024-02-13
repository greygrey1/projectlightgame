extends MenuButton
var idb
var popup
var set
@onready var anim = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("Boot")
	popup = get_popup()
	set = popup.id_pressed
	self.get_popup().id_pressed.connect(_on_item_pressed)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !anim.is_playing():
		if Input.is_action_just_pressed("Space"):
			get_tree().change_scene_to_file("res://Scenes/Levels/Level_01.tscn")
	elif anim.is_playing() and Input.is_action_just_pressed("Space"):
		anim.stop()
		anim.play("skip")
		

func _on_pressed():
	pass
	#get_tree().change_scene_to_file("res://Scenes/Levels/Level_01.tscn")
func _on_item_pressed(id: int):
	if id == 0:
		Saveload.savediff("easy")
	elif id == 1:
		Saveload.savediff("standard")
	Phealth.invitems.add_item("sword")
	get_tree().change_scene_to_file("res://Scenes/Levels/Level_01.tscn")
